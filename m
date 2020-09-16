Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2B0926C08D
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:29:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgIPJ3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:29:50 -0400
Received: from mout.gmx.net ([212.227.17.21]:48101 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbgIPJ3u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 05:29:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1600248552;
        bh=qUGJBV+LmwxwcbrLgtQC3FmqOE9MHn2vtmTA4RuY3Ys=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=U1cz8VM0uS5s6ucIGVHbJehmWY6HZBNoIE58j0GJUCbdts6kKuupEvrcAl4ECSq2j
         TAS1eoH5/yhHpTv1rVUijGqsqX2Qup/n+3kx8cDpXnquLogxFvs5w2bt5oxsNDBRnV
         MWfw4OydIwPBOnSAKtVAGSumau6j+loWLIgProps=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [217.61.159.245] ([217.61.159.245]) by web-mail.gmx.net
 (3c-app-gmx-bap11.server.lan [172.19.172.81]) (via HTTP); Wed, 16 Sep 2020
 11:29:11 +0200
MIME-Version: 1.0
Message-ID: <trinity-ae5f43d2-c2e3-46eb-84c7-d96843beb7de-1600248551915@3c-app-gmx-bap11>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     Frank Wunderlich <linux@fw-web.de>
Cc:     linux-mediatek@lists.infradead.org,
        Rob Herring <robh+dt@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Landen Chao <landen.chao@mediatek.com>,
        Qingfang DENG <dqfext@gmail.com>,
        =?UTF-8?Q?Ren=C3=A9_van_Dorst?= <opensource@vdorst.com>,
        Sean Wang <sean.wang@mediatek.com>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Aw: [PATCH] arm: dts: mt7623: add missing pause for switchport
Content-Type: text/plain; charset=UTF-8
Date:   Wed, 16 Sep 2020 11:29:11 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20200907070517.51715-1-linux@fw-web.de>
References: <20200907070517.51715-1-linux@fw-web.de>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:TC01A2xr8RkXbGgsLFqV/VbN+AQWwQnYA29J/gOoyTQTIr8jw2P4VTWWxuwr9MrAtMe6U
 uzP6I/mCnUJpUbaPsvJHZzg7U+63MfHeqcKzLQ4PHx48//3Ftii+5hGc97AKyZeiUGBVu8b53bqb
 UsV8RZZS1vslD17/qzt4n0p/+sB6x5XxE5jJoiLFJ7LoyoaWWM1oDs4igtcYPsRddltjzZ7H/kQ4
 NPP0VsOmDPrWc91W0xoXyIxg5yqiqLHKrTpFdhA2BD90X5LVXXbVZ3AaXuTUszI2FixJyaaxw1lT
 io=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:sqErrydygD4=:evonUZdnNfjkzK5DzG4aaM
 usCFiwJmZLrRLKL0CDSIY2jUA64Co9RBWXVZAPuli/1LI7qzhg8mRuGc+xufAiDLbioLmwPmt
 riQPSD9BPMGyJ3iqGv/4DFw6NcX+DhaRgLr2priRBqHBZyLFAuwjsA1gxQ8MCxAPOiYQC2EQ6
 RE1CqkORT9ReeumjCaGZTYWyiyGIu7b+Y0gJ6370Cr9L/V90R/UggTWgIGD6a+nscgUh9JNb/
 NW03Uph/yvz0I10wotR3Ws9xuFHuc4OWDlcL7Uv75cb6l24gykk85ZEiy3J4+mLUKgnzlABFh
 tKYP4akwZaMeivNq0HDs2DuhHgZf6PPF3bUKN2XgYLdZZfgEFhGhIX9ZxymKOMX/hyiaxoAWR
 jDPr/FCviuP5QqX+m8Oxr38iAvX4uIGB1NfsZqNwtFOkUgsMCcfIvLUlWyn6zIq/FG7lX+GxE
 GhYTg1KO9vJEM6ZMV9ToVPBIyBQP3OPyqny6pXr3V5+SgJWWToEMxPTE7kf8/rfTFScifnLoV
 lXlaqjwyD1NE2lXGRl6/IAAyUnsGBS83Wp8nakQgolDn1kHR4QZTRmd1enisnle6vPUCs5WIv
 rhZMGzYGE9Ico2lE5zSZpr2wCfzBtO6IYRDmdlAeWQMrcuAk0FmFO7/fFOjjDzMaiLbyx8Bx1
 1JHv1ZS4j7fXim8TefcpdAYwU+K6sfcHlXgaN3If+WrEWMOS1zQElrViMTDSxBV07FAY=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

just a gentle ping

regards Frank


> Gesendet: Montag, 07. September 2020 um 09:05 Uhr

> +++ b/arch/arm/boot/dts/mt7623n-bananapi-bpi-r2.dts
> @@ -192,6 +192,7 @@ port@6 {
>  					fixed-link {
>  						speed = <1000>;
>  						full-duplex;
> +						pause;

