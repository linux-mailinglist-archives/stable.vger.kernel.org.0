Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6AAE1E6278
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 13:53:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726533AbfJ0MxK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 08:53:10 -0400
Received: from sonic314-13.consmr.mail.bf2.yahoo.com ([74.6.132.123]:43026
        "EHLO sonic314-13.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725807AbfJ0MxK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Oct 2019 08:53:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572180789; bh=tnR598H/QqPT1Ph/+p7nVdpgic7bknwMcbeRQcbc5RI=; h=Date:From:Reply-To:Subject:From:Subject; b=BTr01Td9KQCbUqhADiTJengkr0KktS1DZmG+/E91jLuqfNfXO7Uj9aNGlqaHyFXDI3gScoMrUb0DfrnzoLZe3fWhX6i0Hl5z2aW7YZFQjuIVIxMuTSr58kb0EX1hC2TZzVDrb+uU921NaK/FdeN+Ps8RZExT5pNPfeyH+NMRfAoqp05mxXr/7Xx5a9OhOtdSXDQQYGmW+u+J3VGMxe9/OYvweAU2HnnAttAm82+deOLoUR3C7oKeb3x8cJs0VtMF9YGrRz3a5A2f74BPAVu+rBy+EUdF/Gxei6GwIBGEfPxsvjRMgVf/fEU71x7Ynl2m9rtdo3pv7ZLFkLUO3Z3AVQ==
X-YMail-OSG: layDttIVM1l93juOB1vlmlFXzWmA3auh6lgeFsSmyRaTnkGHoi.HcelH2FJyz8t
 ptYULPFh4aSs9b212g3J8nP0refRZwh3YT_lKxb00g26OOeBfErgBJO8UVvoQ2OS3BK7Vjv1zIWE
 T9v__0UTQfS_.jhHbhrpMWcGy7JvrGuOLUksWRd0OEsO4aaz2UGxaBwerZ4KJWMbyrJ3_3da1wUu
 OPRIaiG1mll.tJRof54zTLLQEv8E8qJ2RQqLUTRtGeA9TGKPcW_ElijitDJg75Dw8eQw07mfwyYF
 MxwRLghtEN2mxIk.GvT2DJo8TP3YiPcP5g5iWRhDqpFtXbpPoPSFLK65kpVgaY8b4J1hgwpS7yzR
 WqVkXwqdeilzxqL6V3eQ1Hcp5LLzxbkeZnT9blhuyukhDXbpLsEpXa4VKSqVy2uxD.gt7rggEcIR
 umwWLID1.UESGJs6iEDxPBtjqKOllwsiBVgyK5qveZY8oxGL5AiD7.RNAobJruzU5ZP407kiSxB3
 c5DjbpT5d72ErZlxNpzPq6hk3mr.j1L7Y5xP8ZHPgjefP0ytT0ir.hMtNPkG52zWEVwLRsyXtQB1
 szTwh3zL2HihsQ.h.0XKK8rMLQZlA5kFXlFUl8_SJNXCUViigap.y486ig4tln0fHtO9hHT29np8
 kp226oRqXSLWsjN_lIKK82BN4UoHQNLS9k6BZYRbS92Bk2CqCCXIwvXxXP4MWPyLh9qx7p1s3KO_
 oOzWFeMPm3JxSNVTOdCj4vP_qJfHbQsJifCaY_7cs7ap8pSomAqqHZx35vfxjK_shD8hpXpWePil
 uC4ngB2QDTnc7cr5mgJvO_r80fTHMhTsyGK6hKp7IGe4sAOgkzYPTdchgvk.VV9vedTc5UM9Evxm
 WZZANoyLfRsH87.fQAcj8ZXXMeUXZ4TzTGwGuk4Iq7qDQOBFh2us7NJUklVefCdfmgz6HDHXPdsQ
 uqsvQZjVii.1LiPaj51C3JiW3XQ6gefbfA7ppmK638_jP6Tbn02gFczoyyIH6_eJmu2FWN_uMua6
 NLKNo6ZSsj1oYf3G8KcAyQFa8PXxc37.DL3PzlrWaRf6dW6OvUHC8iEkRZzhBQP0qEL1UGdpWyn3
 eXwgkUtRWj5qP0e6JFBC.x.XJTIpPqyr9g.REL3fKZGUrLY9PwuKNrpIAXNAUbztQb.LUrbbyX5V
 eS70z60C2YHYDSRitAuUmwmj4MYXrsXBAwqwARvUhf3VbdF4itNOLXtiSkahjZIiiNNKSGlZ0Waw
 IomNilQZ5yZk6ldHOcUMjpr9znbmtdjlDDI51SOkdbWiuYKOg070Gb4DSZYI7iFrN3n0CAleurEr
 Mi2yE
Received: from sonic.gate.mail.ne1.yahoo.com by sonic314.consmr.mail.bf2.yahoo.com with HTTP; Sun, 27 Oct 2019 12:53:09 +0000
Date:   Sun, 27 Oct 2019 12:53:03 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine890@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <1831858520.1022837.1572180783914@mail.yahoo.com>
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
