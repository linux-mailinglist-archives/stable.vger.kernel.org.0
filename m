Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51E8C2859E9
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 09:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727647AbgJGHvR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 03:51:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:53378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGHvR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 03:51:17 -0400
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 647702083B;
        Wed,  7 Oct 2020 07:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602057076;
        bh=pPe0QZH8ds38VJC2EDHDXgxsIIWzI5GyW5gBbQu8Wp4=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=ziIUUno7tUa/CJR94p7AGzuV5nmGieR4sEIkA4cnhFU41dlvgr0OedmZQcruKmHG8
         rhnT782UwpMgyoAu9T7u6Ar0nXwm5TquAA1OI8PZDkH/7OMU6FAJFu1pEOiV9lT3oP
         p36+qgA7lvbsfikp9L5+LAxpt81PocXuEZz6BCos=
Received: by mail-ed1-f50.google.com with SMTP id v19so1135032edx.9;
        Wed, 07 Oct 2020 00:51:16 -0700 (PDT)
X-Gm-Message-State: AOAM532oHnRf3VWdbPNAYKiyoY7sYmhWp3a16+tpffoRICfhxeZBr7N+
        L49uDfMaizipnIxiQZzvwTN1omew4L8rl8K2yEM=
X-Google-Smtp-Source: ABdhPJzTD5nsOCxLuzUZRs3e0s1+5hkp77bWRxgXkCPy9k8HczaULR8h/+CBUEGxdc+jTPlN+fThYH5g8eZdl981y8o=
X-Received: by 2002:aa7:d1d5:: with SMTP id g21mr2269960edp.348.1602057074792;
 Wed, 07 Oct 2020 00:51:14 -0700 (PDT)
MIME-Version: 1.0
References: <20201006160814.22047-1-ceggers@arri.de> <20201006160814.22047-3-ceggers@arri.de>
In-Reply-To: <20201006160814.22047-3-ceggers@arri.de>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 7 Oct 2020 09:51:03 +0200
X-Gmail-Original-Message-ID: <CAJKOXPc3ppDdcQCGCuLG2=QHRuXzMZV-Nodzc==LWjRMNxXpaA@mail.gmail.com>
Message-ID: <CAJKOXPc3ppDdcQCGCuLG2=QHRuXzMZV-Nodzc==LWjRMNxXpaA@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] i2c: imx: Check for I2SR_IAL after every byte
To:     Christian Eggers <ceggers@arri.de>
Cc:     Oleksij Rempel <linux@rempel-privat.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>,
        David Laight <David.Laight@aculab.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        NXP Linux Team <linux-imx@nxp.com>,
        linux-i2c@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 6 Oct 2020 at 18:11, Christian Eggers <ceggers@arri.de> wrote:
>
> Arbitration Lost (IAL) can happen after every single byte transfer. If
> arbitration is lost, the I2C hardware will autonomously switch from
> master mode to slave. If a transfer is not aborted in this state,
> consecutive transfers will not be executed by the hardware and will
> timeout.
>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org

Where is the tested-by tag from me?

Best regards,
Krzysztof
