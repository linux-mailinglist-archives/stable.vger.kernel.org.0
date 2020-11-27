Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54B082C61CB
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 10:35:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgK0JeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 04:34:20 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:40435 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbgK0JeT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Nov 2020 04:34:19 -0500
Received: by mail-oi1-f194.google.com with SMTP id a130so5201867oif.7;
        Fri, 27 Nov 2020 01:34:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+o1zY6oeZsDsItG8Zlzn8+hdL/E+Dvm6aLi6UCmULNY=;
        b=iuxQtW3e9JZz/l0oiSiwFWm/H2uysEK/rorJ+p7ck0M1uyyBBv8oCETVLXcHliLgK6
         OnMJLnT5u9SZsqnI1Ay9PAYH+hsKfZVirdXQAqXYupkBqCbqzQXCWKYPcewc8NYDHIlm
         Odg+tDPfbHGblHWDeVkduw2vwkSB13PYS8y98tebZ2ZcowUlCWOm8KH4UG7KeYwL1Mnl
         OZ11FC7Vjj8uUpKlq6LMRfIT4Tk8+cbMtgUGIMAzBrhADRQcrPPpVEzBA/sLYVOkx38s
         tF3hWmDdLscpAORENx7y5Jar1bpOT25t+Y9KEAZBNGMTGnQVHxx+C8qcEn4Y1gKiPxxZ
         bs7w==
X-Gm-Message-State: AOAM5313zndwpO8VzQyQMgYBui+OWO/pfzOzpvZ7lFbHWQBb/1bvEkvg
        +/dXUB0R6dS4z2R2kyldRzWYofLEORTLhV+IbvA=
X-Google-Smtp-Source: ABdhPJypZau4G8SzRKhoEB8MnXbJ2NQjoa9bW01aaFTI6Gq5cOeHMzFtu7h3MBg9R2pYA0XiH2NAr2gRYk1zlk3GHN4=
X-Received: by 2002:aca:c3c4:: with SMTP id t187mr4569554oif.148.1606469658632;
 Fri, 27 Nov 2020 01:34:18 -0800 (PST)
MIME-Version: 1.0
References: <20201126191146.8753-1-prabhakar.mahadev-lad.rj@bp.renesas.com> <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
In-Reply-To: <20201126191146.8753-2-prabhakar.mahadev-lad.rj@bp.renesas.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 27 Nov 2020 10:34:07 +0100
Message-ID: <CAMuHMdVfuJ79OR3mUPEux7JC0yDAbgnbx6wuyXMdBtJhHSSFEg@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] memory: renesas-rpc-if: Return correct value to
 the caller of rpcif_manual_xfer()
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Jiri Kosina <trivial@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Prabhakar <prabhakar.csengg@gmail.com>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 26, 2020 at 8:12 PM Lad Prabhakar
<prabhakar.mahadev-lad.rj@bp.renesas.com> wrote:
> In the error path of rpcif_manual_xfer() the value of ret is overwritten
> by value returned by reset_control_reset() function and thus returning
> incorrect value to the caller.
>
> This patch makes sure the correct value is returned to the caller of
> rpcif_manual_xfer() by dropping the overwrite of ret in error path.
> Also now we ignore the value returned by reset_control_reset() in the
> error path and instead print a error message when it fails.
>
> Fixes: ca7d8b980b67f ("memory: add Renesas RPC-IF driver")
> Reported-by: Pavel Machek <pavel@denx.de>
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Sergei Shtylyov <sergei.shtylyov@gmail.com>

Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
