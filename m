Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8526426FB7A
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 13:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIRLaB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Sep 2020 07:30:01 -0400
Received: from sonic306-19.consmr.mail.ir2.yahoo.com ([77.238.176.205]:34319
        "EHLO sonic306-19.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726394AbgIRL3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Sep 2020 07:29:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1600428573; bh=Wbb5kU9+nuXHtr27nxpSCllVwLyRvN526jc5ol4mfd0=; h=Date:From:Reply-To:Subject:References:From:Subject; b=R3EB/FCs0Y6Byqk4NQ3y46breMEYK3B+YpRExp3k1irTmNokhRHdH1k7/q3uudJKZyeLK4PBPt2drbX52A28z9y7BaeOz3gKjQv/zFDM3CL554x8R4b6xntYjnZFF+0Q+rPWmhMhpGC3/NujcGU6f70U1IlzYF3Y1PEXGzzoYr/btFkkWRgrtlfcc9AKY0QcYzinzq7TD3i6UmtK6wyW6E0t8it8oYJqSPjUCZ9BspgL76zMJsPhIenJIL3PC6N8URNp0qGYnHnxx9H6OY7VNJykWEmsyP558UIth6kTtJzptc+4w06UsbYJCt2zw+HZkPWNTxa2eawKHe1dpwGTgA==
X-YMail-OSG: Rw48g24VM1nIdmdeXoE7Quj0xZkmNm3W.g_TTrPtD0QUwJW1BI4bsRBCD2Q5NJ.
 U8..3YubmEnNgrxUKT4vwaVL9suy_Xj.T1RplaCBvZl1C22yW5irPpRHG.td7CyEsFnH3MiUbmqI
 ivmU1EDyTmRRliWV4vHZUfvUMSKLmkutB5.DmQyvP1TOV7BlJMC3XYOTnshHeq2rLxHLnvjcVJ0K
 pKdUAVMb8x7IFZc6qCu6KNO.k6cNeaJEKWfcqDko0AE1vYBURpoW9w3YMjlB874hYIKoUQWS5_C9
 f5oRbkptaLzpi7dFB8CrIZiPzo3y83_UNw9zJiMSK10oMzxMKDRD0ArYFpvIlfkXQ31ebfd4DnH5
 p4w3UfhElTuZZDNSx5EbqvsUivoLrHu5Zr5HzjXyZMcQYKKqcnMRJx_5.ASsax0t4fpjxO3t4rn2
 xsjZ2yECjCE4c1lLYMyoZs94Tw6isFj56DbiNoNipUB4578fA74ysnyE2bwKKXKFhso0Sh8agejy
 OGpbsYwWllsm9Vi3liVaKYs3ymxVbULzPMkQN8jitYhKQ.I_GxfaN10GA7CfsMggb.6hlZKRpivd
 fvXd37IokTO0EutU9DOEgj.YObmf1v9omTtgvm7hJ6P0Q52kRZ.usR.PsDOnKj7DIfQ7Ce4Y7cuk
 a7YFSYKP85.dFjwmz8O3ny3ru.ti5YtZEVRVKu7ksh8cX_3sJsP25wo_yJdQoYgJwS08HlpE8AUi
 2jqZICTKZudSokTx1Tuekh9WWyJkYiLt8VRgo7Kxz.Mdg11FBsLPDdIZChD1Ua167inJ3eX.n7qs
 ulZPDmE.a.jiGVQrUFhJ8tpG.WtyRWggn4wLU7PYDp9u.QzIjs2Ln9mVut8DHD3e57Oc3ZLkcnym
 Gsi3e7M_NvfaA49feJI.n94iTD_uisrEF.jbjDw_9B313M2gbNWGmpTJIuIYUaV_NGocU71OWpYH
 EmPbMCVFIdm0sgbXtDQLmpoZnuAZBC.TfTUlwRJyOdiejPpnEdiyT8nrDO7HzI7pPKhsdC5cluYH
 od6qLeQVyCZPhcMr1F81njLGmk3zngPthNIkjoFtHVvgTjTS6oQCHZ1veUQKembuThDA9vUhGpGG
 5JrBpSNhosw6MctEPY5P.UW9qrTy9C3gNQBuD3Axek.vjjXYW82QZ0HEZ8msm7GA..0ulMA7aGiS
 hKmu7gRIEdT1LyJj1gM.KVmqo450i1lz36csR0GmciTD.kwrMFfKP.xPZOIdjzxU9v7_CHi.SlU6
 Bzxh_AiNRZouN2F1hrEqV0bZe7SXjgqdNroKBNaEDHwzcactz0rhT3p9fu3ru0tnth.aZvSbC0ih
 pXxyeEJj_mNSgSm.PgOqw2X_VkwBmAwgoqEc.8udwJjU4SVhG1xylAqlL_OTLzfam2G.a.fRsDBe
 phTc_JD2rjK.CI1Rk0K68PEh5eR9vB9QnJbhpetRWw19XJN7b
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Fri, 18 Sep 2020 11:29:33 +0000
Date:   Fri, 18 Sep 2020 11:29:32 +0000 (UTC)
From:   "Mr.Sawadogo Michel" <sawadogomichel38@gmail.com>
Reply-To: mr.sawadogomichel1@gmail.com
Message-ID: <555605376.1662739.1600428572210@mail.yahoo.com>
Subject: Hello Dear Friend,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <555605376.1662739.1600428572210.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.16583 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:52.0) Gecko/20100101 Firefox/52.0
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear Friend,

My name is Mr.Sawadogo Michel. I have decided to seek a confidential co-operation  with you in the execution of the deal described here-under for our both  mutual benefit and I hope you will keep it a top secret because of the nature  of the transaction, During the course of our bank year auditing, I discovered  an unclaimed/abandoned fund, sum total of {US$19.3 Million United State  Dollars} in the bank account that belongs to a Saudi Arabia businessman Who unfortunately lost his life and entire family in a Motor Accident.

Now our bank has been waiting for any of the relatives to come-up for the claim but nobody has done that. I personally has been unsuccessful in locating any of the relatives, now, I sincerely seek your consent to present you as the next of kin / Will Beneficiary to the deceased so that the proceeds of this account valued at {US$19.3 Million United State Dollars} can be paid to you, which we will share in these percentages ratio, 60% to me and 40% to you. All I request is your utmost sincere co-operation; trust and maximum confidentiality to achieve this project successfully. I have carefully mapped out the moralities for execution of this transaction under a legitimate arrangement to protect you from any breach of the law both in your country and here in Burkina Faso when the fund is being transferred to your bank account.

I will have to provide all the relevant document that will be requested to indicate that you are the rightful beneficiary of this legacy and our bank will release the fund to you without any further delay, upon your consideration and acceptance of this offer, please send me the following information as stated below so we can proceed and get this fund transferred to your designated bank account immediately.

-Your Full Name:
-Your Contact Address:
-Your direct Mobile telephone Number:
-Your Date of Birth:
-Your occupation:

I await your swift response and re-assurance.

Best regards,
Mr.Sawadogo Michel.
