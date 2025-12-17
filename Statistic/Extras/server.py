# server.py
# A simple API server that matches the structure your Swift client expects.

from fastapi import FastAPI, Query
from pydantic import BaseModel
import psutil  # optional; used for real metrics. Install with: pip install psutil
import uvicorn


app = FastAPI()

# ---------- RESPONSE MODELS ----------


class CPUResponseModel(BaseModel):
    currentUsage: float | None = None
    currentTemp: float | None = None


class MemoryResponseModel(BaseModel):
    currentUsage: float | None = None
    totalCapacity: float | None = None


class DiskResponseModel(BaseModel):
    currentUsage: float | None = None
    totalCapacity: float | None = None


class ComponentResponseModel(BaseModel):
    cpu: CPUResponseModel | None = None
    memory: MemoryResponseModel | None = None
    disk: DiskResponseModel | None = None


class CPUStaticInfo(BaseModel):
    name: str | None = None
    coreCount: int | None = None
    threadCount: int | None = None


class MemoryStaticInfo(BaseModel):
    totalCapacity: float | None = None
    clockSpeed: int | None = None


class DiskStaticInfo(BaseModel):
    volumeName: str | None = None
    totalCapacity: float | None = None


class StaticResponseModel(BaseModel):
    cpu: CPUStaticInfo | None = None
    memory: MemoryStaticInfo | None = None
    disk: DiskStaticInfo | None = None


# ---------- ROUTES ----------


@app.get("/components", response_model=ComponentResponseModel)
def get_components(
    cpu: bool = Query(default=False),
    memory: bool = Query(default=False),
    disk: bool = Query(default=False),
):
    response = {}

    # CPU
    if cpu:
        usage = psutil.cpu_percent(interval=0.1)
        temp = None
        try:
            temp_data = psutil.sensors_temperatures()
            if temp_data:
                temp = temp_data[list(temp_data.keys())[0]][0].current
        except Exception:
            temp = None

        response["cpu"] = CPUResponseModel(currentUsage=usage, currentTemp=temp)

    # Memory
    if memory:
        mem = psutil.virtual_memory()
        response["memory"] = MemoryResponseModel(
            currentUsage=mem.percent, totalCapacity=mem.total / (1024**3)
        )

    # Disk
    if disk:
        disk_stat = psutil.disk_usage("/")
        response["disk"] = DiskResponseModel(
            currentUsage=disk_stat.percent, totalCapacity=disk_stat.total / (1024**3)
        )

    return ComponentResponseModel(**response)


@app.get("/components/static", response_model=StaticResponseModel)
def get_static_components():
    import platform

    # CPU
    cpu_name = platform.processor()
    cpu = CPUStaticInfo(
        name=cpu_name,
        coreCount=psutil.cpu_count(logical=False),
        threadCount=psutil.cpu_count(logical=True),
    )

    # Memory
    mem = psutil.virtual_memory()
    memory = MemoryStaticInfo(
        totalCapacity=float(mem.total),
        clockSpeed=None,
    )

    # Disk
    disk_usage = psutil.disk_usage("/")
    disk = DiskStaticInfo(
        volumeName="System Root",
        totalCapacity=float(disk_usage.total) / 10e8,
    )

    return StaticResponseModel(cpu=cpu, memory=memory, disk=disk)


# ---------- RUN ----------
# Start the server using: uvicorn server:app --host 0.0.0.0 --port 8080

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
