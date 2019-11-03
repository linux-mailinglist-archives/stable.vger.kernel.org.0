Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F21DED26C
	for <lists+stable@lfdr.de>; Sun,  3 Nov 2019 08:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726558AbfKCHv1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Nov 2019 02:51:27 -0500
Received: from sonic317-28.consmr.mail.bf2.yahoo.com ([74.6.129.83]:34528 "EHLO
        sonic317-28.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726522AbfKCHv1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Nov 2019 02:51:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572767484; bh=vdONypa+pmkSCxMpJ481zxWsfmYXdIIKq3bhYsM38cE=; h=Date:From:Reply-To:Subject:From:Subject; b=Nw9/ntQikRbz88rGJ66i2okPVSg1YXbjPStgtD9zWoi74hwpBgg5ZPP6H1IoBKleSQa7fG8EL0Q39AsJWrrO/44FXXf+vHPr4aWfnMqtP5mV0I9Pz/iEZiP6JfnEi+UQS+g+OCxM8AeFU1C/1TqL8cz67rNpuavgBlBcZk9Uz8el9VAn9k17KUMWvm+NUnsJYD7rp8vBeTomAW5aDpilX+8w4frHztdsWQYQ3sH9t8k85ZH8je0+Rv4jhOj15GclB3A+fNZi2vRh0sNsDIxpTgMd8/W4cF5g5sZf3QRhAGcoIeh+koTS8t5B9RML8vySni9XpZk6TWyAtqH7ndEWdg==
X-YMail-OSG: jPB0O50VM1mGMk8Dv0wlW52DR8oHP1qahm4R5oAPZpUFr_iuBaFn6uXna8pVu9w
 d1ORph4P7NyL7rtAQebWcYj1LXFkhC66unOhgJK0IU6_IyFpVqTSOP9TQaSB4NRzBSfKwzI3qZGS
 U8nLowFdDieJvpi_Cz7CM_5G_lOj8bg8IwkX_TWJts3O.W5No4TAMivN6zWoylqSJfczyfxQv7PZ
 _8juMYIKkDO67RnjgI0nogFX3ztLErXiUsUL6pqQXFr_K.Jze4_dlkE8p.olmq7o3Hxrt0WfAow8
 LxhdzA6LwyrhiUvxBsqq0E2PKWIe_ztK5TvimvfZev2N2_DADIODtSmHJZuJ4sM2NQni_V2sUyqn
 y6H1EE5UO0G.mWFAyEp22w_75In9ZFRogJK11pYcEZMrTEph_2DxA7hBy6Siq9jCNMme_.Ikrxhm
 eyJwSIamI.UGhmospimORjOkdMXIhc.zb9YzV6IP0MNnqFqfwOkAW5skX8NlI9e7.GLC10SqZ1B8
 C04n77edQxakyNEVCfzHs1m5abj2vCTRy_d5Rielx9wPUwxWP0kV16Xzdw_VnHu3pnvMsHiYVOTU
 _i5kvnsyvi8_pMN1wxIkErjtHxVZODzJNKPudRTyt6RsKhphpX0tqPUZjI.HlINTXdKw3ULkL02N
 5Ia5sp5jhzLDyWyaxppEeWDEYQE6hoNdJFnfnFqHXbB4AVyNnQ9BA8nncsOKakBh_emedm2qGTGh
 vWTBiKi7y63N6VN68V14dwhC78ic8so0wMCS9KSQMUHOwlI1SXVEo1aCcASbW98ds5HX0DPWJnqh
 kIQT0UJIDX0FEM0tzB2tIvrKmce6tnrmSkGJnykmSDh326BiWujju3WwDDhZhBcOIt3WV5QRMxyK
 EJ0bm7qJ9nUz2lGorz3_eKz5IC7W8HteEgUY7y5yRdMlhkNYgZW9Yv18GCF.mzFhcTP_l_xyuYJt
 BK2lqErQBck2C.E7ba4KYmRkcfyZNTwrY_iBCYgyVSKQ0O.upgl41UXnLaUtgJplCoW7NSnzNY4.
 jS6_mECjT1DsH.2ccz8oY3KRVzdlLRGjMkjnXY6uruFNOmWubtgjrqcTYwLCAm8eljSgzjxekHj7
 _PbRx.ubnwivHovHA_2Fy7sD8aiItVYPaxK7Oc75aBsv9TwNzf_5Bx1J0XPtpie4Zhhb7TH5naay
 oJ06CFMoEBM9bOPA4QRrLf4DlJ9kktk82D_J2ZK4pnb1aumTHK5F1WszrbN9ioP0sxbmdFVoliVu
 MyWEzTsN28Yh1CMgPKBibjlf12ZcpH6xyfmpPVFZjVli010wlNFlQc.J6LU638CxQ6i1PTdpnkp5
 5k6cT
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.bf2.yahoo.com with HTTP; Sun, 3 Nov 2019 07:51:24 +0000
Date:   Sun, 3 Nov 2019 07:51:23 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine423@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <289075050.260120.1572767483719@mail.yahoo.com>
Subject: Greetings From Mrs Elodie,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Greetings From Mrs Elodie,

Calvary Greetings in the name of the LORD Almighty and Our LORD JESUS CHRIST the giver of every good thing. Good day,i know this letter will definitely come to you as a huge surprise, but I implore you to take the time to go through it carefully as the decision you make will go off a long way to determine my future and continued existence. I am Mrs Elodie Antoine
aging widow of 59 years old suffering from long time illness. I have some funds I inherited from my late husband,

The sum of (US$4.5 Million Dollars) and I needed a very honest and God fearing who can withdraw this money then use the funds for Charity works. I WISH TO GIVE THIS FUNDS TO YOU FOR CHARITY WORKS. I found your email address from the internet after honest prayers to the LORD to bring me a helper and i decided to contact you if you may be willing and interested to handle these trust funds in good faith before anything happens to me.
I accept this decision because I do not have any child who will inherit this money after I die. I want your urgent reply to me so that I will give you the deposit receipt which the COMPANY issued to me as next of kin for immediate transfer of the money to your account in your country, to start the good work of God, I want you to use the 15/percent of the total amount to help yourself in doing the project.


I am desperately in keen need of assistance and I have summoned up courage to contact you for this task, you must not fail me and the millions of the poor people in our todays WORLD. This is no stolen money and there are no dangers involved,100% RISK FREE with full legal proof. Please if you would be able to use the funds for the Charity works kindly let me know immediately.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish. I want you to take 15 percent of the total money for your personal use while 85% of the money will go to charity.I will appreciate your utmost confidentiality and trust in this matter to accomplish my heart desire, as I don't want anything that will jeopardize my last wish.


kindly respond for further details.

Thanks and God bless you,

Mrs Elodie Antoine
