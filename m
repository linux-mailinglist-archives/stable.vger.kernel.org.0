Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE24F6F54
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 09:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726819AbfKKIB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 03:01:29 -0500
Received: from sonic315-15.consmr.mail.bf2.yahoo.com ([74.6.134.125]:34341
        "EHLO sonic315-15.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726791AbfKKIB3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 03:01:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1573459287; bh=vdONypa+pmkSCxMpJ481zxWsfmYXdIIKq3bhYsM38cE=; h=Date:From:Reply-To:Subject:From:Subject; b=mfNBa8oRodbMKqETdCJxdR1l/YcPpe4Z8PQ/iGWtyqGFNlgirFi7R3vKhmFot82CHJlH6AIDX5duM1QaTBUaAa911xTDFNkRNOcItuT2niqLMye83PIz1EnnVcplE7UzKm4pdDfjoclf7JluzndxSHPhLIHOB7dbn97Wfv7Q0HMF4gxtFqLec0pmOgy8Vd6gzTrEd3DEbef4mymGwPgInOsBiuuhiHw8118bdYeIs9M22K0zHK3GjDDm0OcmqVJtdne0RPcuYlz5vtIoOAFrwdAxTom0f7h9scZoQOdYx7EIa/yOLYoPSvpgyc1w0S6STb3CLwzTs9QsBN+BC03ilQ==
X-YMail-OSG: FYpFZnEVM1mNKa62XwDUFAYsWTqQRNEYBkc9q53LPHKM.qSXlvU.0bxChxf.iHL
 HT_4klHrzQ_nH_K92y2A_3vTM5gFyc9MzCl4MHypX24fK70lpa42lgJKo4jQqbdUneRa2M3SjL51
 jtMS0YoVI9ZTFFwDToIU3z0Fxi9YVvKp3QoYniGu1sv0dmg97y7ZzUJpkG2D_yHwBKhHdJiFHGap
 rrAbafvkNbe4zSeeP9QYeAcNGH31V4hleSxUeRFYm_0K6YG0_ymo.foDZj8pjKR4TqAZ5iIZcQCo
 a61QpQmOcu.CAtkiVVyUmforzi8Qh0SD2CPec8sijXoEIIfXq7bbucza9K9FRXDdK1L9VL9kESWN
 m_Y37PA_iudbonoIeXg04pR2U2nSqkeLjutmaV3WnXChSbgOqE2OU0Q3AhmwnGUnAAgoNNYOeFfH
 6GxWoOpgBePSj6pMoVAJCnH4GbxKINQq53nTBHEr5L7gUm8dZmELbzz5bZse0fhNQk5XhYQqwmmy
 3dEt.FOzcUlVREE28f8__ZWVoD3bDAZZtnqSP.oFW1Ez_2I55T8oTZOm..KmdPpS0qURYj9x.HQ5
 qaAtvvfKi2iijX_18YFB_ynjhnjxX3CmQclSp8W7Axp5C9a5UFrf.vM0CuAdShvm7dGapyIfLdqP
 NtFLXJA2VrptuMcaZbCvpV9hrSornMewQaJiblY5cHg5fkduJt.Ciu_Y9O2hWgZhtawpMppksJp.
 skCd1zDgQT7Jfb.Xcajv6nvKyXSoX8PzBQRPJBtgVJn3UEq0QV5T3MGVyaA7q0h1mZkcYF3_u23i
 M4Da5wt8Lz.GNU0AadPw_AJBorni3pu89.9aQuTNp_PzNaklX_tYudA5h6t2zUmm8oZTh264sBga
 UkrQ_4_3y.sodjfyGIb7ncxxgC5TWi943P.PufpZk_5YKfHiHyIizsPAhbkUirpxq3N.dLxKSSyM
 gIOWyyEyN7wE27Ibyk387bMtdV9D4jaFyfngYi3qMmBc8NBdeFeizWXQyfEXe2n4zx7ZSsAlX33O
 bd9hccyl_Th8AGfaYaPx65JGgspQSPY3rsnd45xDQCY46dRf823qj9jJyafgyWCQdgx_Awks_gow
 KrCI1tOKOCAn4cRGYO3b8NX7KMjvO1d3A8ySm1RBqxfgR_KGaRH.obaZR5JFR0RTz8WcGzwtZ1Ge
 4KG_VohxtzUELnz2t7Zb_QlZ5mgs71n9wEsvQTnUEndcdYQypdloJd0zyi05HC8jVBTdtyBnaKT0
 2eEnC_wxAR59JdUKgZ2y7k4vcDYDujD.0JCL5Sws3WcZ2agHoLSj0_HeU8kUdca5Kns1CftCu834
 s
Received: from sonic.gate.mail.ne1.yahoo.com by sonic315.consmr.mail.bf2.yahoo.com with HTTP; Mon, 11 Nov 2019 08:01:27 +0000
Date:   Mon, 11 Nov 2019 08:01:26 +0000 (UTC)
From:   Mrs Elodie Antoine <elodieantoine423@gmail.com>
Reply-To: elodiem97@yahoo.com
Message-ID: <1681403244.1559189.1573459286917@mail.yahoo.com>
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
