Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A45FEC4F
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 13:41:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727556AbfKPMll (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 07:41:41 -0500
Received: from sonic304-9.consmr.mail.bf2.yahoo.com ([74.6.128.32]:40632 "EHLO
        sonic304-9.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727510AbfKPMll (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 16 Nov 2019 07:41:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1573908099; bh=tnR598H/QqPT1Ph/+p7nVdpgic7bknwMcbeRQcbc5RI=; h=Date:From:Reply-To:Subject:From:Subject; b=GOJf0qws8ZgSnSiILkEFUX/xEEGGSvjigYNKIJAkVuFJANPK61K0tqQIAAR+CHxINbHZNUo4RoRN823l8ksEe7EKqXtneGkhfud3ujHbcruqd6TSkewqccdTqUjHmSMgJOYwWWqPAULS/8yvfgoNCSJueYBYzri2tAAx+25h7WJGoy2YY6b5DdS7ayKHjp2DNgEUnsZaJOQdwVosuEOn8SvFCINwLcTDosSkPVmekwclEh+xx4nD4DvtZiQidK4zgG+kA3PTD0fKLj6Z5mdXhRU10SQaAyk3B0Tr02LXvHXZtE/kvibOLweFiIO6lNGaIW8asWQCQ/MytAKgL6W06w==
X-YMail-OSG: I_kKek0VM1mHFOsPTO7SBdIjGDfiAMqpb3jX12ZqMFeZjB4Dar51qyXtbIcgOhH
 YbsGdIEKIkicVdrAN4m.d_7Jan44VbL8vNSNmUmti2klip8ujcCxuA7VLVl_e1jtgnsHYxD6p.sK
 kUst.yzitVIgM71SAAAZ2QOfiC1FG2Toq.fMwByFSE7mkN3FutCoWCmDClNNCrCaORUHmQO62TYY
 Jg53_TR6KaQWQjeWiMQ_7ly1TTHILWr878ABuXIZe5MD7n3QjJcmOPTSPwPgpvySofKi5wCy9BRP
 F0xwZBuSxu9TJGeNZlwQJVYT.z0wI1zi9_8loFNtX9X1.9UWcstTlavZFlhS4Ga9VUK2mxU1wTZR
 fYlYSfIgAzwJNzTiEcR.GbTqElGJJVfvuPIM71lyJSnDSBnhXgX_R1LxfBUke28vcQSJLgfe.Xye
 .AsKXBiTj293tteTq4MKIZE9Bn3dTfHOw_g.W1ihzDuulBhWlW2qxrUNM0cm5pkVwB6f36iXX4BZ
 adUjRSPYnwfyADaLjOj.0A4tUJvkk9Ecvd52hVSPUxA00yZrr21JQF2KKXKFlKjGp1XUR1Douzk7
 9vZwV3g0WXBzzhDnKtSLH7wjXgbMVFTrdyz5ITPfFziSNEL9fQXYNym7cha2gq_ivdQ1hVcVsIXX
 .rH8sUGKajjlVDhggH1oh8jRPIYch2zEu16nE2U_cGKtScc4AlQoMpGOloHKgWgUfjysyc9xI0t9
 oSDBWbq6kkHOn1EfyRu9AguSDMYv6D.Pv9EqOJ4Dq83hVCUMcJIMCSUfxHERcKJCBPKcoLlQJnLF
 O.PTls5SHNLJHqCvknYNBguCP3hp762v1BdOp2wZRVMju4yePOEBz8_.y2af91UP8sQnUWKGCHxU
 Crmaud42ZX4wp7vD.iF5BA7Ur_YWLnekUrhWFlVDwRyj7FQgBlTNCuzuOi1.s2ODUWYW5M8YTNA.
 vJPMRu2idIsa6yx6FYsGqi7Zm5cVXQ0nP0RcTcOULMUx0w9x8_e4krOHQ6De8NFOSiJdY63tC7X9
 EEya_29RxRLn7LrT.iyLaNjF.na4Q8_vU4bxU9wLvkM07N3Gl2wurxdLbEZghgkuVxroC0XdUcMF
 fct7FmENFQQUI9cTXdeYdrFGLIMVkYn_hWIs.TW1a9FZVK4zx.01TEqCkIdnoj5_5.GoScvH14.a
 lihSJ7rqWRC6BrwXW3VmlYysEG.DptLwGLkudbKhTwNg47ugkTdeRWgXbYCPUm0pbmw2vDzzopTQ
 GGyDWxsLrNj8x40hUANcY79W.u7sd4z9kLfAX1QjRlw.gsuds6jZDXOYSb2053EaTqoK6Lse63TV
 r
Received: from sonic.gate.mail.ne1.yahoo.com by sonic304.consmr.mail.bf2.yahoo.com with HTTP; Sat, 16 Nov 2019 12:41:39 +0000
Date:   Sat, 16 Nov 2019 12:41:35 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine890@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <464456927.746005.1573908095430@mail.yahoo.com>
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
