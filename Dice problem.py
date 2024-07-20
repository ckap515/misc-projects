#!/usr/bin/env python
# coding: utf-8

# Imagine a game involving two standard dice. These are the rules:
# 	1. You pay $8 to play
#     2. You roll the two dice, and see the result. Then, you have two options:
# 		a. Take $1 per pip showing (and end the game)
# 		or
# 		b. Pay another $8, reroll both dice, and take $2 per pip showing on the new roll (and end the game)
# 
# Assume you will play so that you will maximize your return from this game.
# 
# 1) What strategy should you use to play this game? When should you reroll, and when should you stop after one roll?
# 
# 2) What is the expected return if you use this strategy?
# 
# 3) Would you play this game? Why or why not?
# 
# 4) Now suppose the price to play the game (and to reroll) drops to $7. Does this change your strategy? Would you play the game now?
# 
# 5) What do you think is a fair price to play this game?

# In[1]:


def game_results(k, p):
    
    '''
    k = highest value of dice that will be rerolled (higher will be kept)
    p = cost to play/reroll
    outcome = expected return under the selected strategy and cost
    '''
    outcome = 0
    round_2_exp = 14 - 2*p
    
    result_and_prob = {2: 1.0/36, 3: 2.0/36, 4: 3.0/36, 5: 4.0/36, 6: 5.0/36, 7: 6.0/36,
                       8: 5.0/36, 9: 4.0/36, 10: 3.0/36, 11: 2.0/36, 12: 1.0/36}
    
    for result, prob in result_and_prob.items():
        
        if result > k:
            
            outcome += prob*(result - p)
        
        else:
            
            outcome += prob*(round_2_exp)
    
    return outcome


# In[2]:


### If p = 8
for i in range(1, 13):
    print(i)
    print(game_results(i, 8))
    print('')


# In[3]:


### If p = 7
for i in range(1, 13):
    print(i)
    print(game_results(i, 7))
    print('')


# In[ ]:





# In[4]:


def find_fair_cost():

    win = 0
    loss = 0

    result_and_prob = {2: 1.0/36, 3: 2.0/36, 4: 3.0/36, 5: 4.0/36, 6: 5.0/36, 7: 6.0/36,
                       8: 5.0/36, 9: 4.0/36, 10: 3.0/36, 11: 2.0/36, 12: 1.0/36}

    for result, prob in result_and_prob.items():

        if result > 6:
            
            win += prob * result
            loss += prob

        else:

            win += prob * 14
            loss += prob * 2

    return win / loss


# In[5]:


fair_cost = find_fair_cost()
fair_cost


# In[6]:


### If p = fair_cost
for i in range(1, 13):
    print(i)
    print(game_results(i, fair_cost))
    print('')


# In[7]:


game_results(6, 7.686274509803923)


# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[ ]:





# In[35]:


(1.0*(-2)/36) + (2.0*(-2)/36) + (3.0*(-2)/36) + (4.0*(-2)/36) + (5.0*(-2)/36) + (6.0*(7 - 8)/36) + (5.0*(8 - 8)/36) + (4.0*(9 - 8)/36) + (3.0*(10 - 8)/36) + (2.0*(11 - 8)/36) + (1.0*(12 - 8)/36)


# In[32]:


print(1.0*(-2)/36)
print(2.0*(-2)/36)
print(3.0*(-2)/36)
print(4.0*(-2)/36)
print(5.0*(-2)/36)
print(6.0*(7 - 8)/36)
print(5.0*(8 - 8)/36)
print(4.0*(9 - 8)/36)
print(3.0*(10 - 8)/36)
print(2.0*(11 - 8)/36)
print(1.0*(12 - 8)/36)


# In[ ]:





# In[ ]:





# In[9]:


def find_fair_cost_k(k):

#     round_2_exp = 14 - 2*x
    win = 0
    loss = 0

    result_and_prob = {2: 1.0/36, 3: 2.0/36, 4: 3.0/36, 5: 4.0/36, 6: 5.0/36, 7: 6.0/36,
                       8: 5.0/36, 9: 4.0/36, 10: 3.0/36, 11: 2.0/36, 12: 1.0/36}

    for result, prob in result_and_prob.items():

        if result > k:
            
            win += prob * result
            loss += prob# * x
#             outcome += prob*(result - x)
            

        else:

            win += prob * 14
            loss += prob * 2# * x
#             outcome += prob*(round_2_exp)

    return win / loss
    
    
#     return outcome


# In[11]:


for i in range(1, 13):
    print(i)
    fair_cost_k = find_fair_cost_k(i)
    print(fair_cost_k)
    print('')


# In[76]:


for i in range(1, 13):
    print(i)
    fair_cost_k = find_fair_cost_k(i)
    print('fair cost:', fair_cost_k)
    for j in range(1, 13):
        print(j)
        print(game_results(j, fair_cost_k))
        print('')
    print('')

