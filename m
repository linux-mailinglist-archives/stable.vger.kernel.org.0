Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1AAA515397D
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 21:21:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBEUVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 15:21:20 -0500
Received: from sonic307-2.consmr.mail.bf2.yahoo.com ([74.6.134.41]:46220 "EHLO
        sonic307-2.consmr.mail.bf2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726720AbgBEUVU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 15:21:20 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580934078; bh=am3dXXYtKcTrelmyGm4P0+mHOmyqtUVUqrhirAr+7T4=; h=Date:From:Reply-To:Subject:References:From:Subject; b=KzogIAR5JGdbc/U8QYxO1IXQiMYLIX1/FgtA4YeypVWPrxqvN0dwMhgvDdJiIZ/3sF9txrtNGYYIK/ZAxxnjl2LRDicMH/LZAYnuEeJWiZCLWLJ+O/9VLSKS2p7PLsCjnNV/fttsIc+tAfPpDc8M2IjWFNbVphYAmwpja/QjAkbFjeBJOKqfdSatXxbmMX7yPtpLm0QwFlCdxumSqYicKeN1rjQdYjUva0EJTSk8YtVIAVFfzPWi97S5+JDiSLapDkZ8a1dwyGHkc2coK+PkOrKEamHmKVPw4Sopt2O3L+b7a1Hpai9W6rm6YKGjiFYVDlgXNolbZsc94BVwo4JRsA==
X-YMail-OSG: b43WZwsVM1kfeb10w.162Vxk9k4ZPfTgKUvzScUtTucQnSweGZWIASN423lo.wj
 ONW8Z8PPtCRMOewAvz0ZAAy4MKQUVPtzXBusIqUplca2nPmBRP1Oy3z6at5JwhKDRYh30P5AuziV
 LQYiMvfs0tlLvWHB8NbxXUk.4mboUZDj0MXqH9IrhUkDATA2UfMF847p.Talsfs8rrHQ6E1FI0e1
 96OGz5IwQRAgd.1M2dKiz8..WJ..WiIOqSc0qetWZNALc1R3bMKIWNyrZ_o1eI1Sd5_Oa3x2C_CG
 TnexEfCbOP1XVx_NgyH6QPkOovjz..H.XZSOpAmwVKaIPuWCPkzP01YHFpphqVebPr3LqXEyJP.n
 c1qf7sDQXhcO7WW.0dNrqJBHjdcg_uAhUE13AtgXxNEJGA_gwSycJjMPznr0GBoI3kv8GKozMU0O
 cZantrBBJILBMWw7jwk9.eEueK6650d3EFJGK41qAyIlIhGxlA7vSRl1L6YEVru1l.bMUjLUhFfN
 X8Gf8ntQa6gYXevApI7ZxJk0FK4E9KNPudO2VH9ywCrj3wppZJu_AsfShj1hN1.9k69qJkV.u89G
 vAR2_r6Hylr1wfjv5TSJ4jpEdgdUC.X0Nf.i44JrfQCpCHJuOTZM5oeMAjfyy9KNm90aw10ZZSPh
 L5SgkTbAgPNvyasx54v4kihLitdZlz046plMzbSyaHjZXO0xRUlGt0tRAQ5gJpqxtEdMH_78QBkn
 p4A5sSlbIJYfy3LII8dJPpyNGnIqXnhvijoR4iwn0HLEPJowsx6cLdx3oCn6a0cFP2PT7qlUzj6Y
 ZEzcbTezG9bzOSILhwx8rP22Dk1K77p8wjgXHyCZ0ds8TOq30z4Hgm2bawVJojsoB.7gteOgoBH9
 ytF7jPr2SM.2cHQ3RJPuIMhBon1rQVmcJrv2.dsqsgRSbJ7.hzAlYs7Bax5wPriO01tIsQiqd_q9
 WR1aLopM3iOXhjAP5d5eSB8bzoI4uzU968uDKoV42Q0ZYehVk.AiIU9Mm5ZcsJrx0OlSQ4AVjHPo
 zMnYZxRjvSBfs0SnkJT21nKP_GoKPe5BATJrS5E14NmAkcWxJPiBmPE1EpPoVEiwYSMy6hE3p1oF
 bRk2cLY7Jf6LsPybKvb95kueQxFlGGezjzmhPME63s8yFqeZqfykWN4cQwKyF95eDQb9nwXbg9XF
 e.HlMiddkYDGQzZL4LajCFNKJ5vBREHnQw.nsMs0BQu1HtV9V80YlK5wwS4E0LY_HWapcMCwSGfU
 T9iglWUlCjDUknxkZIiqWBk5KZ9AoYvUmRiBT.NwwJdxCJudnB3ucwZuxojecmQkhk8OZRXLaZJM
 m8pw-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.bf2.yahoo.com with HTTP; Wed, 5 Feb 2020 20:21:18 +0000
Date:   Wed, 5 Feb 2020 20:21:14 +0000 (UTC)
From:   Dr Rhama Benson <drrhamabenson2016@gmail.com>
Reply-To: drrhamabenson16@gmail.com
Message-ID: <1656320076.701118.1580934074513@mail.yahoo.com>
Subject: Contact me back immediately.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1656320076.701118.1580934074513.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15158 YMailNodin Mozilla/5.0 (Windows NT 5.1; rv:47.0) Gecko/20100101 Firefox/47.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org





My Dear Friend.

How are you and your family Today? I hope all is well, and I am happy to share this transaction with you ,but you must keep everything as secret and very confidential.

I have a very lucrative business transaction which requires your utmost discretion. Please understand that you and I myself, are to work as one team to inherit this fund, hence I am your insider in the bank as the transaction commence. I advise you to feel free with me for all is going to be well with us.

Though, I know it would come to you at uttermost surprise because it is virtually impossible to know who is trustworthy and who to believed. I am Dr. Rhama Benson, A banker by profession. Please, I want to transfer the sum of ($10.5 million) dollars into your bank account. This business is 100% risk free.

Your share will be 40% while 60% for me. Contact me for further advice. Full details will be send to you on the receipt of your urgent response by forwarding the following details bellow.

1. Your Full Name................
2. Your Telephone No..........
3. Your Age................
4. Your Home Address........
5. Your Country............

Thanks for your anticipated co-operation.
Best regards.
Dr Rhama.
