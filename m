Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA2C215303F
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 12:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725793AbgBEL7D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 06:59:03 -0500
Received: from sonic306-19.consmr.mail.ir2.yahoo.com ([77.238.176.205]:40450
        "EHLO sonic306-19.consmr.mail.ir2.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726386AbgBEL7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Feb 2020 06:59:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1580903939; bh=i1iy2zmNcKe0bXbaLfhFmX2GVXb72vV0A+dUbZZzr/s=; h=Date:From:Reply-To:Subject:References:From:Subject; b=pn3+qu6Cdr7x8ZqZEDnzlFiqFd+8hBfq6kxjlQmwAdk3MEV2BekEXzu+hSOqtw8kFIXkcW6giEdfd5EszqSHzJffRiVP49vNek6YbLIglRQQRV/WmDKVi4uBaSiRQAfEePDXPmDROqVaYVLy46+E1ZiZ+0RxgAlCy85fVmlUx92ZlVufnUKKbI23h3BwwMkySOtUi8giyuHDB6HY9py06yapbtqpkKDlase7rM7vC9pl1v/sERWynC4dUSi9FeLP8PIlKAvms0pgKrSiUJVHpUO0i3nwimllDUsezsm/3vFCCcSF7PgICI8aGgfZWen5kmh8bG2lFVxYxBrUeyH1Hw==
X-YMail-OSG: EmdJvM4VM1mF0efNQGfZ7TlVxjs6bK6FDH1GyGpIYpjdCSBv13QjspA7FM5nlgG
 S7Up5V.n4LDzKcgruNJlY0We_0rJKAVAFR1gv4GayeJ41I410uPelgs4SMpLa9bAddF8oxC_oiMr
 MBk.eXvNgEh_eHpsDkikobU3hcG.BgUcUy9CI.n3apUXYRZSNPj9k1IDx53mwv1FVifWPj8y.LmA
 Gv2BLXdBums7RtS8Db10hSjxrlcavjrYeQBzpIO6LjbdJiMtUQEyoQj6I11g87ZHnaYFvrLmEroN
 _FcxQ7pG.JdbCH4Sz3awU5kkcc5qMMmB34ISdgP5FKwaY5jQ1fS4S5eDnQJ3SBoZHVqE_eOVFdqD
 kznSZ7jCujg1w2d1BRRUqg9wkFo72_wEpFUINgda0EMB_hzfCfDEgVVGNPh1OlqTL36JL47dDozF
 H0DtX0cfv8OIZM5MU0jF_JPf8h2.iOUKs0ZKSU4Os_wCQncB28gPVg4Fc_HSenC5wUYudHweDFBr
 lK4xSDtl1QCoyajjM8W.7_PeZFWAqinUXEMScuKroJcD6tNO2a0x3Lv7zB_VVD23J7paYlYhmIbI
 k2HH0Xq_2TAyhVzcFP5WVDRQCaDgkSf2EalEgOUWb.QOGnt5ciLh7sxFIv6qTvnz9WOGBOIEGyIr
 Hnt31Fp5vxDcYpZ0U2pyWTwrw0n.yrNLJWEu0DBsQQo._XL0YHPQQ8yugUgMPB2LAgyKAtVq1cjO
 ttyUu6k0RDDklKnt6CN8sYAhTcXMT6eI2TztlDtgrV_VVEfz6BywXX.t1rn7yggB64jGN.e5LZwG
 1tghtjGUZj0kknAIkaTl4MNueblNsdrmV1I7wXK_M8_0KBNuVHUOBOD3VnJSgALJcn_NQbJaQJHU
 Tr1iXFqcuxrIs3jSUuNYVqguNGHEcbRrDADeMdcuQ1OM9IdyVyWCFzGPL4YcXDQnjanzruJO4oHt
 tjiGPcawL3EN9cleILbCWBblgYNaX8fEFwGJH7BqunsHaTXkCPa0K_VWl_l0mq0L_Tas0_KHOMfG
 _PtAjR9MsvLSrRUcXc4n_welGacX3FRav0cS1QRRxzPqc4qqFly.G0R7D5YkvBwnLPwc26q1SFj7
 yCd14IhYgWNQUvfC.ASQIG6uYZVSNJe2ZDvmdOislWqfAXDHACSDSyq.U2jflv13nnIZ0wJVefUq
 PfGq6Oh5LgPdWxfSodSgoZSX5mz9pXyMWPUf96.WU6Yv12rmsV86Jxu97_gRgNfVTbZM_zieqymP
 d6I2rthKj6ZqLLWT9Y7OUSkqx1CDkSqJ0wktXREDfQnMITrQu.2pMTZAoTMTc1U6gN0dcTtJJLb_
 K5koX
Received: from sonic.gate.mail.ne1.yahoo.com by sonic306.consmr.mail.ir2.yahoo.com with HTTP; Wed, 5 Feb 2020 11:58:59 +0000
Date:   Wed, 5 Feb 2020 11:58:55 +0000 (UTC)
From:   "Mrs. Bridggie William" <mrsbridggieee1william@gmail.com>
Reply-To: mrssbridggiee1william@gmail.com
Message-ID: <1373283461.1350850.1580903935569@mail.yahoo.com>
Subject: From Mrs Bridggie William writing from hospital
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <1373283461.1350850.1580903935569.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15158 YMailNodin Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; WOW64; Trident/4.0; SLCC2; .NET CLR 2.0.50727; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; InfoPath.2; .NET4.0C; .NET4.0E)
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



From Mrs Bridggie William
Ave 12 Rue 123 Abobo 01
Cote D' Ivoire Abidjan


With Due Respect And Humanity, I was compelled to write to you under a humanitarian ground. My name is Mrs Bridggie William nationality of Mozambique .I am married to Mr. Francisco Willam director J.R Industries Cote d'Ivoire. We were married for 46 years without a child. He died after a Cadiac Arteries Operation.

And Recently, My Doctor told me that I would not last longer due to my cancer problem (cancer of the liver and stroke).Before my husband died last year there is this sum $15.8 Million Dollars that he deposited at the Security Valut here In Ivory Coast. Presently this money is still in the Vault. Having known my condition I decided to donate this fund to any good God fearing brother or sister that will utilize this fund the way I am going to instruct herein..

I want somebody that will use this fund according to the desire of mylate.husband to help Less privilaged people, orphanages,widows and propagating the word of God. I inherit this fund, And I don't want in any way where this money will be used in took this decision because I don't have any child that willan unGodly way. This is why I am taking this decision to hand you over this Fund.

I am not afraid of death hence I know where I am going.I want you to always remember me in your daily prayers because of my up coming Cancer Surgery. Write back as soon as possible any delay in your reply will give me room in sourcing another person for this same purpose.

Hoping to read from you asap.God bless you as you listening to the voice of reasoning.

Mrs. Bridggie William
