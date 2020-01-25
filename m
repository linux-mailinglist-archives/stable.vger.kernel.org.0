Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E104B1493EB
	for <lists+stable@lfdr.de>; Sat, 25 Jan 2020 08:33:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726565AbgAYHd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jan 2020 02:33:56 -0500
Received: from sonic307-1.consmr.mail.bf2.yahoo.com ([74.6.134.40]:40403 "EHLO
        sonic307-1.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726303AbgAYHd4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jan 2020 02:33:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1579937635; bh=ZuyEM3dgJG1J7uxm4tvg+0sEPyOCN4U5wrhpxYfWco0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=OIjjD9HYM72YMrGSVPn3OSpZI6WQNXCEn/7nCTrVeNZAsA2wkQxaUgkSfQyigzGHFbXCymSymUZCH41Xm3dSEKEKfo8qZVUGbr2DSafDK7sG1jirCSSWZHQd0ZWQSHWEkhedoqdMNFqF/hWMTat8iegU97a6x9OGT3CR90xMpu1J3Dg/uvM/65kP5NtoPHob44tSPBWTMipz4basLK+gSIe4DZIufx+/KnTmZOw/iz9kDu1651OFBiKl2N7FEiFhZmnXBNcVOvKbR54gQFFj2IsYt12q5RpDHJ6Tf/U07W4zWnBA4hcaBB8ubTn6ftDJc3glJldXDEBiVJ21ZVkgeQ==
X-YMail-OSG: DsU_FZUVM1nJno3WNZ_GdAVyhHFnPooQWBnj2ZfL7mZ56tzdJ9AhyGvz7_33RgX
 v2Bsc5N_UlfQw7Jv8yjQ88r27I1d6eKrzQf340KSnzDzlYFJT42qoHEah8zblvoYVZLB3OYPZPhG
 T.L5K9uWt.WEkOkmk49hzKTqiDLLxi_ZsUYKwfyZY.9Uh1tqPtWrRuDdO122XGYrIqQVx1WdTqFN
 MXDREzhkZgllaEqvHH.blyAIE0z_SMoXTvR5TSj1Gl7MK.EmQB51lE.71kYAEwNd2eKGOSk4yyxZ
 HclgO8xHNZ5BkXN5poCV.Lq0n3YPAlHt9NmgI.QQnnxLSDwbh5cP2tMLjW89PYogm.WpvIS87YPK
 Y_Z_UfT_baZBBtocYJPH6AfMtGsrvZhjTqlkhdviDKQfuRg5eL4jWer2.4qF7IHC3uXfHK.WKz_p
 JYiWMygo82VX_pFRtEi1IGXV.GRFC22hFckhcZHeIq2ozl243wBErHLbNu_fiy6bMhtZv7uGkXZ0
 ZrDJndmQzMCt.EY0qGsdeJG7RsjaxTXiMWvpveGNJtS7EREurIa0Plox08pvjLZ0PuP8ruQFQVPi
 No94OtHOGBAIMbPwMRrAOTLu6NqLIUYZXHdEhur4sY2SNCOya8WgYMzYXNop7dFIk5BmHWBG5fEW
 ABG._jX8fla._bEVsi3rrczxQstHyARzLUdt4JZZVFqcMQ.x30DaDSUe6.hhSgCjEPcYvIAcxvHw
 r5dvRzMXl2ahTRbHW8CnmqUOkyLe6Jyy8dmZ0XfME9w52_M4DXQSvPsHGfRpg7A4KVOmvhNxxUC3
 UQ5UvgFy_XFeX2_OYrUReBhfKOba0edzU3HnAuLrO_2ksn9y.NXGGLjaBZTbdFl6tFkCRuqf5nC_
 Q0kwicKnGDUvFyn28H4ijHHapSkizYV1ri8OyZqcAnxSLbX7xZ07LM56wEcVGEICvyn36LSbyFIW
 JFK3QegbtXG4kA8_sY3DRPjPqlHNq24cw.cC6ev32JG_wkUELybDWukozF7bxL29C5tfP4JWmhLR
 WrjxjW9HhQXGsPoHk6xnsLkJQejEdnrJuCrILoIL_I.kX25bnidbDRC4QzBf8bhf6ARzXXSq5pnc
 TRm.vEAQ0Q4UTIIFzReo7fC2VyTlwdZ5o2hjyxpAhXVq6vQjlhLl5cC6nB6fjigt9a2VOIQ9mJ6p
 ms6Bk1M9jdYC2etjYgToH0W8EA53X7xhxQhp8vJAkSHYxYPrGj2U7.VZZIAxptn5ICf_pGvo6CM6
 pxBRENDycMRfwan_5SjcQB4mLCISBwPc_68H3amFw.N3gF41F9lD3m1pbWju.UuTxduEjnNdteHB
 Cs5M-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Sat, 25 Jan 2020 07:33:55 +0000
Date:   Sat, 25 Jan 2020 07:33:54 +0000 (UTC)
From:   Mrs Dhawan Nisha Pradeep <peterobiokoye123@gmail.com>
Reply-To: mrsdhawannishapradeep@gmail.com
Message-ID: <788721498.11396639.1579937634861@mail.yahoo.com>
Subject: Greetings From Mrs Dhawan Nisha Pradeep,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
References: <788721498.11396639.1579937634861.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.14873 YMailNodin Mozilla/5.0 (Windows NT 6.1; rv:72.0) Gecko/20100101 Firefox/72.0
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
