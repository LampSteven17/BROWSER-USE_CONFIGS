import asyncio
from langchain_ollama import ChatOllama
from browser_use import Agent
from dotenv import load_dotenv
import logging
import random
import time

# Load environment variables
load_dotenv()

# Set up logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

async def main():
    agent = Agent(
        task="Imagine that you are a real human, and that you have access to a computer. Perform real actions on that computer such as making searches on google, browsing youtube, and shopping online. You can imagine you are any gender. Make sure to take breaks and sleep. ",
        llm = ChatOllama(
            base_url="http://127.0.0.1:11434",
            model="deepseek-r1:8b"
        ),
        use_vision=True, 
    )
    
    await agent.run()
    #result = await agent.run()
    #print(result)

asyncio.run(main())