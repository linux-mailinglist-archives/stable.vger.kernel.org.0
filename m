Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD169145B95
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 19:29:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725884AbgAVS3j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 13:29:39 -0500
Received: from sonic311-24.consmr.mail.ne1.yahoo.com ([66.163.188.205]:37065
        "EHLO sonic311-24.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725836AbgAVS3j (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jan 2020 13:29:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=aol.com; s=a2048; t=1579717778; bh=KB5k1+sCGpSRd9pTKc0P9/4ZGPy9ZVtmix5g8Hf7Eac=; h=Date:From:Reply-To:Subject:References:From:Subject; b=GUHaOALL/X1ntw9u1AFCd5Fr8IbcbTl+KL8FJ/gXJGrpwRjNfuTqu06C4YKwmHvH8Il1gvpG5mRWLpG9kACZwame/BJGm/7InIOlVugxMOKBympoifKTwoezILR3z3r9vwgOiO1LlFLIfO7SGf467S3srVCA+b9PtiYLqjiggPw5380VL2cANE6A3hs7q45pkf8eFfhgxwvFNkEEzDZUjcEJPbHWo/l3qSrTgE8aOQ8U1aPPbcGhsEZYK9qkd29yTJkT4dPvDkPoiSExbKFl79BMbD2f48pl1zq9KWdKmyt1qqI06Mqoz2t0DtpZJ8e1Lz8e/HoOuAI6yC7zqE5PDQ==
X-YMail-OSG: Ypnh2mQVM1lnbn2jdDgfYT2v8DyFNAmuGkWN8kR0FtV_vLjn041QBopxOr_oCRH
 6V_NLwe88UAj0coJ2sGfquQwma8H_fEbTBssYbdc5ur3UjxHIULdHLv.JqHxlU_3_tKaX6YpStx4
 dLJZj.SoIXsh4DYKiSVYiF8BO9sHg2adhUupZ9Kp0odlex6uCbCFXG8FY87XmghSQjTHazORgGUv
 mXUkr0B6Okr9z69s18MKyxLDBXnN.vhHw9s0p0Y7bnFlm37iJ_EKSayW7UjzcDB52Yj7iuARw8ip
 z7SwWwVID7e6fF5LcAQ4Vori.w5e.tOsU6DBiYRtkH7OwGOS2u.yJyCqOx.1qqor_RDXageLD1AU
 lk7LKsR2teP.wKtU9tbVosfvZhbY_nf.0AYc.ejRDlvbfh1MlMEVOXio7dGt0tol0fmVxqbIaBdm
 QMGlLKsADMNAI42TdwaddRjDBZF4VjAcZ_nBnDslNND5TtKxM51x.vbZrawsZAWQJKL5msEGmnAZ
 efYPK8WPuOJypcEbZzZQwSRKhMLvTg8PSxcduVDi9.uyoRwb7AcGdD7G2EHJeLjXbln83hKQxrVE
 QfJYYsJaR807KFXG8n3KkA6OPrWUgKLJ0XwfmL.dnToQ7Up2Jy6b23oiLrKiJjskTfH70aJeFgiF
 sQsvseHugdvCxXQhWXs0UovJ6qWPpC16LIB8buZQVf8VRjHDT.TZs9JODw.l.R4lHQla6x2D9fIh
 fjz5PWn3w3WDtCTA6FI5Eziw6lZASuxPf7mQ0ZrNQN8ArLNkozUvp73YBUqgOrpCaVSc1S3YZ.K5
 ul1aPre6woRBJYcbSZHVmFLotWcoBVX1oqha9XJBc7XYygzw3UmSHvyAGRPROSe9NpXu3fOqi29Y
 FcT2kKSiC_N0jz0jxDMLZYUFJKV4An9WE5o5yVPWne8JkkL5fhCK6yOh._3sD6WIn0x4qA3bRDuB
 wZ28QQga.2iKg8dvSeBqJ1zF4dOICxGdGDLNpVOpXk6tT7rih2UPelTqmlYa.KYooOj5yJd3hjd3
 lE4icyK7BkC7NH3lVOWXDz9gyqNvb1AFUkYOYR7LWp6Ii0P8PUui7WDcfwsrjarHWHQ1fzioetjI
 txTk57hjxjvGD0eGkGSfHBn6iY3Qt3GAzO0EBRIY.38TBvn10LzuiCzkjasPTXgnZ3ycdCWVOxOk
 CH.HQsTByiSIMp4mR.K7_DHdxJFPmxOrjMqFc2ij7eSGMBiNGe_t7bgGaPZGxADjDnIXoyKCmwHM
 OhjfBBkafXqfZvHRl26cXJaymrr7I_zr8kXNn85lTWj8.M9Kx9tpWfjH1861d6DCS1hdDPg--
Received: from sonic.gate.mail.ne1.yahoo.com by sonic311.consmr.mail.ne1.yahoo.com with HTTP; Wed, 22 Jan 2020 18:29:38 +0000
Date:   Wed, 22 Jan 2020 18:29:33 +0000 (UTC)
From:   jerom Njitap <jeromenjitap10@aol.com>
Reply-To: jeromenjitap100@gmail.com
Message-ID: <565273505.2649073.1579717773131@mail.yahoo.com>
Subject: SESAME SEED SUPPLY BURKINA FASO
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
References: <565273505.2649073.1579717773131.ref@mail.yahoo.com>
X-Mailer: WebService/1.1.15077 YMailNodin Mozilla/5.0 (Windows NT 6.3; Win64; x64; rv:72.0) Gecko/20100101 Firefox/72.0
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Dear Sir,

This is to bring to your notice that we can supply your needs for
quality Sesame seeds and other products listed below :


Cashew nut
Raw cotton
Sesame seed
Copper cathode
Copper wire scraps
Mazut 100 oil,D6
Used rails
HMS 1/2


We offer the best quality at reasonable prices both on CIF and FOB,
depending on the nature of your offer. Our company has been in this
line of business for over a decade so you you can expect nothing but a
top-notch professional touch and guarantee when you deal or trade with
us.all communication should be through this email address for
confidencial purpose(jeromenjitap100@gmail.com)and your whatsaap number.

Look forward to your response.

Regards
Mr Jerome
