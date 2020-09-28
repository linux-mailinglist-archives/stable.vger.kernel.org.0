Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0515527B38E
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 19:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726583AbgI1RrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 13:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726565AbgI1RrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 13:47:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5396C061755;
        Mon, 28 Sep 2020 10:47:22 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so2299911wrx.7;
        Mon, 28 Sep 2020 10:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/xC7sVHcrGN898jvMxBaTyGhFlsYYmV8IqAwKCr7ZRU=;
        b=X76xYhd3KRTbRwTGgCMGcp5w+6fynAQyONy4JxAdpZLdFts8jyvyqy24e25xd62OLW
         bXh3WC80JwOIuG6yDk/pKVffBWEoijaVHqq/eutJsgQprp9A8pL9nvFVdrybd5GjxPnD
         WBHAUi+F2Y8BzPBLa9HNqHKG44yaC1YsRRd4eQsgmn4BXV1ccl2zJ+IlaylH+k2Tghym
         /dMddaO53BkB6tdFR9rh0eBqq5Gt7kKslAB44podqTRX9yM+Vuh2uzNsatcZ3YQxmclP
         6fWl2Nj8FfhtHyCa8Z+RYUe+6s9SgAeGtg4FlhxdL7cmvqU/mhgOmNeywVui/AIwBgsE
         LwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/xC7sVHcrGN898jvMxBaTyGhFlsYYmV8IqAwKCr7ZRU=;
        b=ZkVNJ9mxk+aVJMquWop/z2H0ipRW8ML1YSPpera6hiT0ReM5tjcXXqifJJ98KNzPha
         v3bW257aR5TL777pSsfu7wFEfiKbHHbepOv84PHxFwZpqOhXYNJbhCdjetXy28JiNBLj
         Pl3PCyMj4WWJ3hgabCj+tIjpxM6mGnlNqokMq6/5oiK3SL0KuZ0vDFzQIhtuW0SO86zP
         f3b5PvDJCPSn+I5QhpzaQt3vUhdP/B60MK6Kohz8Rp+t7D1uqzC/G3y95RoxcIW/GhHH
         yq9CzMrUZo8ilq35i/yB6PaIDHgAdSThunohBokzHiAaXAhoO9399RUsqxo5Syjgv74R
         qNIg==
X-Gm-Message-State: AOAM533txVF66dK3ZCnoa9Yv3cOGylEn8+RzSilbnLji16x9rHnBskmk
        h2m6/OeChrJ56cuj6eSP06JZ+Q1qc9vfgmTBWZZcNqSKzSKOxA==
X-Google-Smtp-Source: ABdhPJx96v0ZgUBrLgFUbFXE7T0XgggFSabVgtJyLhF55ex8gUwVYGVjuiecada1ajgSx01ecXIIvnOKHaUaymBd4Pc=
X-Received: by 2002:a5d:630a:: with SMTP id i10mr2821633wru.137.1601315241434;
 Mon, 28 Sep 2020 10:47:21 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20200928095910epcas5p2226ab95a8e4fbd3cfe3f48afb1a58c40@epcas5p2.samsung.com>
 <20200928095549.184510-1-joshi.k@samsung.com> <20200928121136.GA661041@kroah.com>
In-Reply-To: <20200928121136.GA661041@kroah.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Mon, 28 Sep 2020 23:16:55 +0530
Message-ID: <CA+1E3rLzwkqwn09mzi7-112ZYyBU_mU_9Nszb0=aymm3H2sGpA@mail.gmail.com>
Subject: Re: [PATCH v2 0/1] concurrency handling for zoned null-blk
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Kanchan Joshi <joshi.k@samsung.com>, Jens Axboe <axboe@kernel.dk>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        stable@vger.kernel.org, Selvakumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 28, 2020 at 5:42 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Sep 28, 2020 at 03:25:48PM +0530, Kanchan Joshi wrote:
> > Changes since v1:
> > - applied the refactoring suggested by Damien
> >
> > Kanchan Joshi (1):
> >   null_blk: synchronization fix for zoned device
> >
> >  drivers/block/null_blk.h       |  1 +
> >  drivers/block/null_blk_zoned.c | 22 ++++++++++++++++++----
> >  2 files changed, 19 insertions(+), 4 deletions(-)
> >
> > --
> > 2.25.1
> >
>
>
> <formletter>
>
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read:
>     https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> for how to do this properly.
>
> </formletter>
I'm sorry for the goof-up, Greg.



--
Joshi
