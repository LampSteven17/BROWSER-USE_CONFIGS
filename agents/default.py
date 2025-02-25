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
        task="Browse google, youtube, and shop like an average human.",
        llm=ChatOllama(model="deepseek-r1:70b"),
    )
    
    while True:
        try:
            result = await agent.run()
            print(result)
            # Simulate realistic human behavior with random delays
            time.sleep(random.uniform(1, 3))
        except Exception as e:
            logger.error(f"An error occurred: {e}")
            # Wait before retrying
            time.sleep(random.uniform(5, 10))

if __name__ == "__main__":
    asyncio.run(main())