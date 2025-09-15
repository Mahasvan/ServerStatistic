#
//  server.py
//  Statistic
//
//  Created by Mahasvan Mohan on 15/09/25.
//

try:
    from fastapi import FastAPI, Query
    from pydantic import BaseModel
    from typing import List, Optional
    import psutil
    import time
    import uvicorn
except:
    print("Could not import libraries. Please install fastapi, uvicorn, and psutil.")
    exit(0)

history: dict = {
    "cpu": [],
    "memory": [],
    "disk": []
}
limit = 10

app = FastAPI()

# ---------- Response Models ----------
class CPUResponseModel(BaseModel):
    currentUsage: float
    usageHistory: Optional[List[float]] = None


class MemoryResponseModel(BaseModel):
    currentUsage: float
    usageHistory: Optional[List[float]] = None


class DiskResponseModel(BaseModel):
    currentUsage: float
    usageHistory: Optional[List[float]] = None


class ComponentResponseModel(BaseModel):
    cpu: Optional[CPUResponseModel] = None
    memory: Optional[MemoryResponseModel] = None
    disk: Optional[DiskResponseModel] = None



# ---------- API Endpoint ----------
@app.get("/components", response_model=ComponentResponseModel)
def get_components(
    cpu: bool = Query(False, description="Include CPU data"),
    memory: bool = Query(False, description="Include Memory data"),
    disk: bool = Query(False, description="Include Disk data")
):
    response = ComponentResponseModel()

    if cpu:
        # psutil.cpu_percent() gives current CPU usage percentage
        current = psutil.cpu_percent() / 100.0

        history["cpu"].append(current)
        if len(history["cpu"]) > limit:
            history["cpu"] = history["cpu"][-limit:]

        response.cpu = CPUResponseModel(
            currentUsage=round(current, 3),
            usageHistory=history["cpu"]
        )

    if memory:
        mem = psutil.virtual_memory()
        current = mem.percent / 100.0

        history["memory"].append(current)
        if len(history["memory"]) > limit:
            history["memory"] = history["memory"][-limit:]

        response.memory = MemoryResponseModel(
            currentUsage=round(current, 3),
            usageHistory=history["memory"]
        )

    if disk:
        disk_usage = psutil.disk_usage('/')
        current = disk_usage.percent / 100.0

        history["disk"].append(current)
        if len(history["disk"]) > limit:
            history["disk"] = history["disk"][-limit:]

        response.disk = DiskResponseModel(
            currentUsage=round(current, 3),
            usageHistory=history["disk"]
        )

    return response


if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8005)
