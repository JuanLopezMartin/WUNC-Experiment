# Arguments

title = "Example title"
story = "This is the story"
plea = "This is the plea"
friends = "10"
likes = "1,000"
followers = "100,000"
verified = True
famoussupport = True
famousperson = "Someone famous"
profilepic = "./images/pouting-face-emoji-by-google.png"
bannerpic = "./images/ows.jpg"
teampic = "./images/supporters.png"

# Code

verifiedcode = '<a class="_56_f _5dzy _5d-1 _3twv _33v-" id="u_fetchstream_3_9" data-hovercard="u_fetchstream_3_9" data-hovercard-prefer-more-content-show="1" href="file:///C:/Users/Juanl/Desktop/WUNC/#" role="button" aria-describedby="u_fetchstream_3_b" aria-owns=""></a>'
famouscode = '''<div class="_3qn7 _61-0 _2fyi _3qnf _2pi9 _3-95" style="
    padding-top: 3px;
"><div class="_1xgg"><i class="_15y0 img sp_Op3MyGN4ZMD_1_5x sx_68ffa5"></i></div><span style="
    padding-left: 4px;
"><div><a rel="dialog" style="font-weight: bold;" role="button" id="u_0_1i">#FamousPerson#</a> supports this</div></span></div>'''

f = open("template1.html", "r")
text = f.read()
f.close()
text = text.replace('#MainTitle#', title)
text = text.replace('#Story#', story)
text = text.replace('#Plea#', plea)
text = text.replace('#NumberofFriends#', friends)
text = text.replace('#NumberofLikes#', likes)
text = text.replace('#NumberofFollowers#', followers)
if not verified:
    text = text.replace(verifiedcode, "")
if not famoussupport:
    text = text.replace(famouscode, "")
else:
    text = text.replace("#FamousPerson#", famousperson)

text = text.replace("#ProfilePic#", profilepic)
text = text.replace("#BannerPic#", bannerpic)
text = text.replace("#BannerPic#", bannerpic)
text = text.replace("#TeamPic#", teampic)
with open('example.html', 'w') as file:
    file.write(text)
