import asyncio
from langchain_openai import ChatOpenAI
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
        llm=ChatOllama(model="qwen2.5:72b"),
        use_vision=True, 
    )
    
    
    result = await agent.run()
    print(result)


if __name__ == "__main__":
    asyncio.run(main())