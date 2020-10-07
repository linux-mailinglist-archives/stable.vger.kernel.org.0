Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A87D42859DF
	for <lists+stable@lfdr.de>; Wed,  7 Oct 2020 09:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727760AbgJGHui (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Oct 2020 03:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52824 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJGHui (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 7 Oct 2020 03:50:38 -0400
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E84CB2168B;
        Wed,  7 Oct 2020 07:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602057037;
        bh=wjdNt9fk4taQnomW0LVqef9xaaEAkbgb9aWhBDQXp98=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=mATuEgSyP7rL8fztvdZ53xzVIQ0qiPBqDwDBwWpo7rGEWsoGSbmmjIVQ5/T1+oElx
         LvpkoKvJ8f5ss619Sonne3lz61hYZpXyQxmYthySt9mfenl+HmSvgO6FwM2OsG4YKJ
         kT3Htww3WM2HgrpoCHPm4ah8QAk7jTJJ0BtcldME=
Received: by mail-ej1-f52.google.com with SMTP id e22so1605094ejr.4;
        Wed, 07 Oct 2020 00:50:36 -0700 (PDT)
X-Gm-Message-State: AOAM530rc7NFY9sIYC3ycga8oDTSn/LbnamHO4qCVw159nvj2qvEJ95X
        BlXgludfSrtgpWIvbFSDw+lpLyJGeh48gKgmmNM=
X-Google-Smtp-Source: ABdhPJyWOIbIcP4wtSvYOiWoDxRKahL3vDWWNT1vEumlBFNfZ5i4lu4dCOOmyGNrCQg5lbBkQnB6XJQZzof4vU1nLm8=
X-Received: by 2002:a17:906:8401:: with SMTP id n1mr1955039ejx.215.1602057035339;
 Wed, 07 Oct 2020 00:50:35 -0700 (PDT)
MIME-Version: 1.0
References: <20201006160814.22047-1-ceggers@arri.de> <20201006160814.22047-2-ceggers@arri.de>
In-Reply-To: <20201006160814.22047-2-ceggers@arri.de>
From:   Krzysztof Kozlowski <krzk@kernel.org>
Date:   Wed, 7 Oct 2020 09:50:23 +0200
X-Gmail-Original-Message-ID: <CAJKOXPctS2DGkQW3EhP5Tg0y39oVF0xhEcmbs=T0vHmUsMgsQw@mail.gmail.com>
Message-ID: <CAJKOXPctS2DGkQW3EhP5Tg0y39oVF0xhEcmbs=T0vHmUsMgsQw@mail.gmail.com>
Subject: Re: [PATCH v4 1/3] i2c: imx: Fix reset of I2SR_IAL flag
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

On Tue, 6 Oct 2020 at 18:10, Christian Eggers <ceggers@arri.de> wrote:
>
> According to the "VFxxx Controller Reference Manual" (and the comment
> block starting at line 97), Vybrid requires writing a one for clearing
> an interrupt flag. Syncing the method for clearing I2SR_IIF in
> i2c_imx_isr().
>
> Signed-off-by: Christian Eggers <ceggers@arri.de>
> Cc: stable@vger.kernel.org
> ---
>  drivers/i2c/busses/i2c-imx.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)

I replied to your v2 with testing, so what happened with all my tested tags?

Best regards,
Krzysztof
