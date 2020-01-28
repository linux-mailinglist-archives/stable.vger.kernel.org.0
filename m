Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C069E14B33F
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 12:04:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725937AbgA1LEy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 06:04:54 -0500
Received: from sonic314-13.consmr.mail.bf2.yahoo.com ([74.6.132.123]:38395
        "EHLO sonic314-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725903AbgA1LEx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jan 2020 06:04:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580209492; bh=ZuyEM3dgJG1J7uxm4tvg+0sEPyOCN4U5wrhpxYfWco0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=FlzttlyVW33j4Y95+1DwIfZcyXSNSZAnvehTZwBwIVdeOzXfjzMD85NPS+Dmr9v0blywWuOYXTwMPLSRI0YA+06fzes1xvk1phVKFa3DbFFMiUNf6fqpXWvfLUxmk+bkVh5RdG4VCIHvRMh/Dspo85UOV5psYCU53mHcqq9YTZRWzVAkGi7EWGzmTMaPjfdF+jWarOLzdM+6C6qqP5Ic/j2Vxk1wexZtB3kVx+zOIQBdomy6msg9pdOCz567Rh2053pbnFgNADCGlK18MApkdrXkL6POffz4i3D3eE/zGZ4EaRz/s54phS6RKDW3+mxIkYjjM1+VC5N/YP74WbjEgA==
X-YMail-OSG: MkBrWzEVM1krdvktmwq7PxFBP9S5os89xyOjEPvzdIpeNymukidVQumxnUUy9M2
 Fuy76lmxoYY26hOP0hoYrpSuQVYy_FB8Fjxs.cwQAJy4WKHc90JhQePFm9Hln6Wvlm1D2rgFjeB_
 PCst2yWdO9pVHXDfHQ.EzoWgvinHw2a4ltlejhR6DUrMJdvpVA2LX9sHt0.8zQnPWZPxUMS62oxf
 glHvpEdc.y9nk_rwKPPgmKTG5V0zQOlizKKaOx.YueHijpFEEDNmyDT23uqJqMxqfE1LDHPkG7TH
 zK6ETLgymT.BPn3j1lSQ0ZcUpISPKxRbsMdZp664C4wuF4MNUkhZLiBH4R.03_8J3PixPSPY6SXL
 pufLBkfv91x2_duNy_3PuPNk56zlpH.XRILoQhV6btOv5wd.GT5W7Qu7S7TzRAu2qDVr8QlgDYy.
 YkzU2RBEnkRjakgwkln2M2jHIKDLFXMWuiXLccdNnkw_aYHgwSOEXNJuXAGMQfLPwevdSqJ_2qB_
 yp033a7nOu6v0vyCTayecXZDKPEI9b61IKZQox9Zrw58p7wQanAYdzCW98mr9L8kIYqyyQa95hi8
 vaorkf7OkKLp9Dxzt4Dl7ay0OSGzvBcezfQxBNz6h8S3BTnZ8Lzl5jaI5zIZTtocgiCV73y7Q3X1
 1dXDr_HS.eKyEWRY11gUchyaw5eoTf93wl7HwoenIv1QyI3KKGY2ayzisG5QrHeoqFyeCmzVKkpS
 T1j74sKLVwtoXlQlyT.T650QN.9wuw8RoWkz4GYqTYoVp40sS7sXT8Rum3S37Yh40dd5y2Q_mVac
 Mu1kxxvmkUm0nTe3T0_F2OO4FYbO3C22EIVQDgKB9lRJknvJXEDs.d9t.pFTYiBH.YCaVLtBmIJi
 gMKQSz.Xf.AvogV9bRfp.MMT1UvRYgU1H8p3nhpklkzyjj59cXd1lEPirQ0K7Kc.sWIPijI_xiTg
 RD2HqvGptBmkAh.OvE4aznfXvCokfybxnwxj68WcXqo_x9Vtj6H2LfXWxqHYIiyoU3quocma4TbS
 WCSSSij1sQrVVfgEF3cU60zZmYIh0TVgsaQgiKnWsnRgz7VzpmII9lWSb6TqNI3RmuMZw9Th59VW
 lTnQ3WB4WJ.UH3fgB_V0R6U4baR8RjBiNq.SkiaTRvTkjjmiKxG5468LRwFUy7s76fXADtMXsN6u
 fAAeEhWc3EJibP0YGHRaSLIjIF50tJqBJpUOXEI5irjyu7csyFY9gz5nUogVBMG7lgRiF1cXUDJG
 fM8vpT7vET2MZGCJSyJqAjDEDo_d0eBpT.P1Ub0gFjbNBMkHWr9YRGgOyN2LW5gvj40CE0bn1EaQ
 SpFwA
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Tue, 28 Jan 2020 11:04:52 +0000
Date:   Tue, 28 Jan 2020 11:04:51 +0000 (UTC)
From:   Mrs Dhawan Nisha Pradeep <peterobiokoye123@gmail.com>
Reply-To: mrsdhawannishapradeep@gmail.com
Message-ID: <409772505.231509.1580209491336@mail.yahoo.com>
Subject: Greetings From Mrs Dhawan Nisha Pradeep,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <409772505.231509.1580209491336.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15116 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings From Mrs Dhawan Nisha Pradeep,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIS=
T the giver of every good thing. Good day,i know this letter will definitel=
y come to you as a huge surprise, but I implore you to take the time to go =
through it carefully as the decision you make will go off a long way to det=
ermine my future and continued existence. I am Mrs Dhawan Nisha Pradeep agi=
ng widow suffering from long time illness. I have some funds I inherited fr=
om my late husband which we work together for.

The sum of (=E2=82=AC4.5 MILLION EURO) and I needed a very honest and God f=
earing who can withdraw this money then use the funds for Charity works. I =
WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email addres=
s from the internet after honest prayers to the LORD to bring me a helper a=
nd i decided to contact you if you may be willing and interested to handle =
these trust funds in good faith before anything happens to me.

I accept this decision because I do not have any child who will inherit thi=
s money after I die. I want your urgent reply to me so that I will give you=
 the deposit receipt which the bank issued to me as next of kin for immedia=
te transfer of the money to your account in your country, to start the good=
 work of God, I want you to use the 50/percent of the total amount to help =
yourself in doing the project.

I am desperately in keen need of assistance and I have summoned up courage =
to contact you for this task, you must not fail me and the millions of the =
poor people in our today WORLD. This is no stolen money and there are no da=
ngers involved,100% RISK FREE with full legal proof. Please if you would be=
 able to use the funds for the Charity works kindly let me know immediately=
.Please i want you to send your details as listed below so that i will forw=
ard it to the bank as requested for the processing of the transfer of the f=
und into your bank account.

Your complete name
Address (home/office)
Your mobile number
Your age
Occupation
A copy of your ID

I will appreciate your utmost confidentiality and trust in this matter to a=
ccomplish my heart desire, as I don't want anything that will jeopardize my=
 last wish. I want you to take 50 percent of the total money for your perso=
nal use while 50% of the money will go to charity. I will appreciate your u=
tmost confidentiality and trust in this matter to accomplish my heart desir=
e, as I don't want anything that will jeopardize my last wish.

Thanks and God bless you.
Mrs Dhawan Nisha Pradeep
