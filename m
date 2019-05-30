Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E4A2FEC5
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 17:02:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726682AbfE3PCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 11:02:21 -0400
Received: from sonic309-24.consmr.mail.ir2.yahoo.com ([77.238.179.82]:42616
        "EHLO sonic309-24.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726609AbfE3PCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 May 2019 11:02:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1559228538; bh=r8mvpsdSWTgrFU7sKbqDDOp6njqb0485clzVt3O86CA=; h=Date:From:Reply-To:Subject:References:From:Subject; b=dm7XchzcaZdS1nR8inQcRkFtHStwSzpiaJqZvKecWO9BMrq47HQSa1Po52AkPdtfUtMMUseeLmLmgoMoXqSQSsm0Mkz3HBDSgaIVUlpTMFfny9hMtPx/z8K0PWZKcTaj3tPPLhUVnxR8f1kviTdmGA7A4u6oJf/iB7Bmg2h/sLSnTPJObTj/EkSPPUCjKbrpsMpDkY6dEm95LZ2/JQ2Vg4z3TuF0rAYVV4OcJOImF/pBjOhCFcElWiUYVfM3XBlLkIcApXZlRSM+0JqSop1ikGiFOS8+j2Y13v4P2bfskfZuYvJ/grjgxxO2zvETe6vT59mKksjHLmZQiPwqEnF61w==
X-YMail-OSG: JCpGDtoVM1lQ7.noNWZkJqrVTxtsZPFvmAMP0pGiDVvTS0kOJ6mVOIjIiVwACeo
 VtUiyBzQlFLoDpCubM.KZDAGPfxVatE8UyUtUFW8_K6BMZOfZovFI3bBCbHgxFjNeStSaZqAv1xr
 n2qpD0TRpfQLOhmIJVWcaakRMGizI43B9TdS8ONPja6Ltb3_tJxVyZL48ajNeDv5moV3fhmgkGIJ
 w6ni.W.ByI3xwgWpnpYhFuPob.HL5XvmIjKGORT8VPpZ0bLHylaiDUGc.43GIJb1E2sNy87oJDzY
 CbCqafPoCfW9y0fmEddfqKpbvjhB1kemK0XIcxKDBu2XMZUdpcHHNY3b311zZeyHlx8DEflAz7ns
 2RUSZOPOpd5JqGDIpuq0e7WiT_gBuA5NfLqEQ1G..emjRtKXfyT.Y9ZE_655f5F7ib.HHdlbQ7Ec
 ow3dXRXNHcoLpkzdFnqwhpiiyW.HS.JMeVi7gh_wMHvq70ARVnc3RCzPlKjD3YPlCfS28rsfYa9A
 FNFw_xvVty2EMjVndIf8MXJ1joFgHLUvyIugmTtU5YrmdMjL2kRAqL6D.RxEKO7Y6FE0g.SQKFhi
 Ex2kC.L3MT07p3EEkU8.qvfTe1TEkzYuaJfwcqf0Vjd1R4Os2khqJ0lAKlvJxS1APee7YXxM1QOG
 EzNMok33h8436EK2MTfu.l9SK7YjXQVDroooWExh98Xqida5Ar.JpBq4kvZu9GEOM9VlHJuA8ZVY
 I3B_PwUhw.BftklQRcVM.QaYOnbgJiE96IRxYFOwf54PLJ6SStkZleWuVU9e3r1GPX3aSC2nYXPd
 2izJkebyqIEpHlV_SrYpXfOG2bh8F_B4Fbpd4qdo1LVYKz0rE_W09V5_fUenbr6DsJjdC67W_yGW
 WVmHuUo7ZlH0cJqhJybXLhmihOQt_5slYl83Q9SmS_lV0zDy5jCyzCwWfLm3nkC8UXZcVPzJUl1o
 jO_yRZom3eS9tkI5jy.M2Ep.79rEN3bWSX2wIkPX1le2hSeoxoW1Ir6AZFWVefetDnwEkprCEMgN
 EPKkPII0iNyfC2zyxMhoAsCRiunt4OvRC8pBcEVdnMdhToutepM5PvcwHLvuM2VKs8KhrNhjq9f.
 Butox8lRFJGzhuGgIxklGpzyLQO.UKHSQTFDspPQTmTBU6x3qv_SVMYwFalQLt4boSG6d2Z53Xbt
 04Xxfy8iv9pxrt8dmnmbFNz7ROm2LoadHe.b3tt6Mvno3Q1xb06AmMl4Q7ThzLQ--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ir2.yahoo.com with HTTP; Thu, 30 May 2019 15:02:18 +0000
Date:   Thu, 30 May 2019 15:02:16 +0000 (UTC)
From:   "Mr. Nor Hizam Hashim" <abmousa444@gmail.com>
Reply-To: "Mr. Nor Hizam Hashim" <nhizamhshi@gmail.com>
Message-ID: <1955570798.13522196.1559228536186@mail.yahoo.com>
Subject: Waiting for your urgent reply,
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1955570798.13522196.1559228536186.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.13634 YahooMailBasic Mozilla/5.0 (Windows NT 6.1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.131 Safari/537.36
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir/ Madam,

Please forgive me if my request is not acceptable by your kind person.

I am Mr. Nor Hizam Hashim, Working at MAYBANK (Malaysia) as the Independent Non-Executive Director & Audit Committee. During our last banking Audits we discovered an abandoned account belongs to one of our Foreign Deceased Customer, Late Mr. Wang Jian, The Co-founder and Co-chairman of HNA Group, a Chinese conglomerate with significant real estate ownerships across the U.S., died in an accident while on a business trip in France on Tuesday.


Please go through this link:https://observer.com/2018/07/wang-jian-hna-founder-dies-tragic-fall/

I am writing to request your assistance in transferring the sum of $15.000.000.00 (Fifteen Million United States Dollars) into your account as the Late Mr. Wang Jian Foreign Business Partner. Meanwhile, before I contacted you I have done personal investigation in locating any of Late Mr. Wang Jian relatives who knows about the account, but I came out unsuccessful.

I will like to bring to your notice that I have made all the necessary arrangements with my colleagues to transfer the funds into your nominated bank account without any problem.  Upon your consideration and acceptance of this offer, I am willing to offer you 40% for your assistant, while 60% for me which I am planning to invest into a profitable business venture in your country.

More details information will be forwarded to you to breakdown explaining comprehensively what require of you.

 
Waiting for your urgent reply,
Best Regards
Mr. Nor Hizam Hashim.
E-Mail Address (nhizam.has@yahoo.com)

