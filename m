Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAFC5E9788
	for <lists+stable@lfdr.de>; Wed, 30 Oct 2019 09:02:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbfJ3IC3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Oct 2019 04:02:29 -0400
Received: from sonic317-34.consmr.mail.ne1.yahoo.com ([66.163.184.45]:38573
        "EHLO sonic317-34.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725942AbfJ3IC3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Oct 2019 04:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1572422547; bh=tnR598H/QqPT1Ph/+p7nVdpgic7bknwMcbeRQcbc5RI=; h=Date:From:Reply-To:Subject:From:Subject; b=Qn0vlaGl/DYBigj1dqlAwvUoWDxG56isl/jI2ubiPCuEQmBPSsN4QFdJcsj66XLnL50nqWQJqtXDK9upaVJ+xP5euyA4HBX4kaQLP6nXlbYrbE9Kibgz6WO8LD5Uj0cF/VE0naj7yMilRoIUl9l4Q2aHx27kJm7CAc682w884L+dAa84TWomtOCv8qPf5t7CBlGZTCCpgixDJrVOnzY59Lk3vphMB3jINJ4D2g8vF3qGVpu6H7VRr4cgrIVVUAtS2PqI/TEPJ+radi7wEW8dEeZE0Hj9ar6kp94K9E1xWbESsRuPhmIxHXOErsxSpqMv1W3U8bHjcGyfoxV8mnH+Dw==
X-YMail-OSG: UXRf1bUVM1mSSq2CNP6ne81_UzC68bJYAYRH.ygBDgOVeqzL1OmjCRINc33UOLS
 DMfYWbgfuZPRTH72TCW4vad1pHQiW7UYzpPWF5Z1sMicQ1..ZnOF3HvlLNvy8e0Nfs8poBKIIjQ6
 9BMqbbPw.4Z4ZxGib4xjWIwMQzg9BtYx2_6fPC9pSCo9rfgqCBOK8WcFoTO0SwhA.BqOTbZHgflu
 q0K37.pEFV8O0BRqZupmHSGb4GLTLWAEVlVXl0wldY8RbsMFiLpPdKrVWNkLb2fRfpSPsNHjmO51
 k7OecAn1wi4r4B0qZ51_MLSMeFsWFT50gArTCznVn_MQk9wRkQdGd_n1Vy6LSY4IhbOQKkaaJBrH
 FnBv94MzzeiMaz_CKdtLVoUL2I7Oh2ba4WfgYyec_4ODO.dgAnRxylldOijIQh.MA2GbjpqMq25h
 uiKEDbg.6EOEo7zVoMem.tVg2OuY.CX1nMOBfaWqGdW5mPEjK0mAckOYt00TBS2Aiz67agrucpPU
 iTE_k2.VvhPEa7MCM2GdIljn.nKmy8ejwXkS0PGa1Xybvtgs8AJNXsCG_Pigdj349DC_Hd3GLain
 5D2Q8Vt_rfNxqWAJnfW6Fol.iAkpc.IBoaLSIRIDENIylzOS.zUc8pdmKOcrDq.qtibZllwzq.ey
 RM5X8LQnDNLuvjUuvuN9dDhpZEXLClgjDJzEY.YH9elUl1qrniP2JqyrOU4YHwqqfRnwXzKx4oH_
 EhN88tAEtL65OCQcz.q67npZrgYPcaMI0YmAc3eBFtvUP4.Bu3mgxUxaqUG1on.z6_fANzWBxsTw
 JDmS5edrFd3IEHMc0BdsSD7rHIV1FnWfQ1kTVg05VJ2bhx.0bwn6RSsmvlwtQprqEZRcR9lm.DGJ
 muZzr560KgcN9u20kLcLpIykkp84tbqMlxsuX2pG0IHg7WDv3r3wmCaTyJT1BixtP2JpcV7vbZGw
 NE6mXA2sT61XI3v.CjJGh1wEjtJ0QFuEtd6foQYc8p3U8fiAXB2zQPOkzn3Ot.5Soe9hNm45D6GU
 KZ_tbQSXezIv.fyo1nX5V3xpqFZDk2LeLyYX7cmiNZ3_Gp53qYrQ9qf2mPiqGeqmSnIBqXGU5HFz
 mrkigAjdJjpz5K21NpE1PYzO7f4RQVAhbA4yC4rCtx3VswtPfTZ5wIz_CKoWUY._7_3JLuJsKNc3
 n.tNorIEqhp2Ji_gMMndqnBVf_NOeB8UbKkzAhc5pJP6UnhGeMCb8ZgJJF2Gv1Tr7i06yy3ZtQdz
 MutKdfx9uMU876PynoLxWmIMSwrJs10FXF1LgwAmBHLigP_cfteHBgGF.tzEKQr5EBJkL.DmXN2e
 m3tU-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic317.consmr.mail.ne1.yahoo.com with HTTP; Wed, 30 Oct 2019 08:02:27 +0000
Date:   Wed, 30 Oct 2019 08:02:24 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine890@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <1474667639.4288876.1572422544513@mail.yahoo.com>
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
