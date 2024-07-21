#!/usr/bin/env python
# coding: utf-8

# In[1]:


import re


# In[2]:


text = """
The human brain is an amazing thing, malleable to all sorts of changes in its stimulus. Fot insrance, one could swap one lerret fot anorhet in a senrence of some rexr, and rhe btain mighr have rtouble wirh ir ar rhe beginning of rhe senrence, bur be petfecrly able ro tead fluenrly by rhe end. Yo8 co8ld even swap n8mbets ot symbols fot lerrets and ptobably be j8sr fine.

Rhe peng8in btdin is dlso dn dmdzing objecr - rho8gh pethdps nor ds dadprdble ds o8ts, ir is q8ire cdpdble of rtickety dna aeceipr. Ir is dls1 incteaibly daepr dr pdrretn mdrching dna sens1ty mem1ty, dble r1 pick 18r irs mdre 1t y18ng in d fl1ck 1f o000s 1f bitas.

C1nni6ing is aefinea ds being in61l6ea in c1nspiting r1 a1 s1merhing imm1tdl, illegdl, 1t hdtmf8l. Whdr is s1 hdtlf8m 1t ill1tdm ds pmdcing d ge1cdche p8zzme? We'mm med6e ir *ilpmy in rhe tedml 1f rtickety dna aeceir.

Ir i* d w1na7t h1w ldny m7rr7t *wdp* rh7 btdin cdn hdnam7? Ldyb7 dfr7t r11 ldny, rh7 whdng7* dt7 r11 gt7dr f1t rh7 btdin r1 b7 dbm7 r1 t7da fm87nrmy, dna l8*r c1tk cirh 1rh7t f1tl* 1f d**i*rdnw7. 1t 37thd3* rh7t7 dt7 rh1*7 rhdr hd67 7x7l3mdty gtdy ldrr7t rhdr wdn md*r rh7 f8mm m7ngrh 1f rh7 r7xr cirh18r t7*1tring r1 dia* 1f dny *1tr.

H1c dt7 y18 a1i2g dr rhi* 31i2r? Dt7 y18 *r0mm dbm7 r1 g1 c0rh18r ct0r02g 02*rt8l72r, 1t w1l38r7t? Rty d2a 761k7 y18t +0ta +td02 d2a *rt72grh72 y18t 3drr7t2 ldrwh02g *k0mm*. T7mdx, whd227m f18t 0227t 31c7t*, 8*7 rh7 y1tw7. *77, 21c a17*2'r f18t +td02 y77m *rt1257t dmt7daf?
"""


# In[60]:


text_list = text.lower().replace('\n', ' ').replace('?', '.').split('. ')
text_list


# In[44]:


for sentence in text_list:
    print(sentence)
    print('')


# In[26]:


def swap(sentence, rules):
    
    for rule in rules:
        
        sentence = sentence.replace(list(rule.keys())[0], list(rule.keys())[0] + '&&&')
        sentence = sentence.replace(list(rule.values())[0], list(rule.values())[0] + '&&&')
        sentence = sentence.replace(list(rule.keys())[0] + '&&&', list(rule.values())[0]).replace(list(rule.values())[0] + '&&&', list(rule.keys())[0])
    
    return sentence


# In[27]:


swap(text_list[1], [{'r':'t'}])


# In[81]:


len(text_list)


# In[91]:


rules = []

print(text_list[0])
print('')

rules.append({'r':'t'})
print(swap(text_list[1], rules))
print('')

rules.append({'u':'8'})
print(swap(text_list[2], rules))
print('')

rules.append({'a':'d'})
print(swap(text_list[3], rules))
print('')

rules.append({'o':'1'})
print(swap(text_list[4], rules))
print('')

rules.append({'v':'6'})
print(swap(text_list[5], rules))
print('')

rules.append({'l':'m'})
print(swap(text_list[6], rules))
print('')

rules.append({'s':'*'})
print(swap(text_list[7], rules))
print('')

rules.append({'e':'7'})
print(swap(text_list[8], rules))
print('')

rules.append({'c':'w'})
print(swap(text_list[9], rules))
print('')

rules.append({'p':'3'})
print(swap(text_list[10], rules))
print('')

rules.append({'n':'2'})
print(swap(text_list[11], rules))
print('')

rules.append({'i':'0'})
print(swap(text_list[12], rules))
print('')

rules.append({'b':'+'})
print(swap(text_list[13], rules))
print('')

rules.append({'f':'y'})
print(swap(text_list[14], rules))
print('')

rules.append({'g':'5'})
print(swap(text_list[15], rules))
print('')


# The human brain is an amazing thing, malleable to all sorts of changes in its stimulus. For instance, one could swap one letter for another in a sentence of some text, and the brain might have trouble with it at the beginning of the sentence, but be perfectly able to read fluently by the end. You could even swap numbers or symbols for letters and probably be just fine.
# 
# The penguin brain is also an amazing object - though perhaps not as adaptable as ours, it is quite capable of trickery and deceipt. It is also incredibly adept at pattern matching and sensory memory, able to pick out its mate or young in a flock of 1000s of birds.
# 
# Conniving is defined as being involved in conspiring to do something immoral, illegal, or harmful. What is so harmful or immoral as placing a geocache puzzle? We'll leave it simply in the realm of trickery and deceit.
# 
# It is a wonder how many letter swaps the brain can handle? Maybe after too many, the changes are too great for the brain to be able to read fluently, and must work with other forms of assistance. Or perhaps there are those that have exemplary gray matter that can last the full length of the text without resorting to aids of any sort.
# 
# How are you doing at this point? Are you still able to go without writing instrument, or computer? Try and evoke your bird brain and strengthen your pattern matching skills. Relax, channel your inner powers, use the force. See, now doesn't your brain feel stronger already?

# In[92]:


rules.append({'h':'z'})
swap('F18 wd2 6dm0adr7 f18t 38hhm7 *1m8r012 c0rz w7tr0r8a7.'.lower(), rules)


# In[ ]:





# In[ ]:


rules.append({'r':'t'})
rules.append({'a':'d'})
rules.append({'l':'m'})
rules.append({'c':'w'})
rules.append({'f':'y'})
rules.append({'h':'z'})


# In[ ]:


rules.append({'u':'8'})
rules.append({'o':'1'})
rules.append({'v':'6'})
rules.append({'s':'*'})
rules.append({'e':'7'})
rules.append({'p':'3'})
rules.append({'n':'2'})
rules.append({'i':'0'})
rules.append({'b':'+'})
rules.append({'g':'5'})


# In[ ]:


u o v s e p n i b g


# In[ ]:


o v s b


# In[ ]:


p e n g u i n


# In[ ]:


3 7 2 5 8 0 2


# In[96]:


816 * 7320 + 5


# In[ ]:


u o v s e p n i b g
b e g i n o p s u v


# In[ ]:




