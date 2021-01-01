Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772FB2E857B
	for <lists+stable@lfdr.de>; Fri,  1 Jan 2021 21:07:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727335AbhAAUHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Jan 2021 15:07:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727213AbhAAUHH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Jan 2021 15:07:07 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB754C061573
        for <stable@vger.kernel.org>; Fri,  1 Jan 2021 12:06:26 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id 6so28826268ejz.5
        for <stable@vger.kernel.org>; Fri, 01 Jan 2021 12:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:reply-to:references:mime-version
         :content-disposition:in-reply-to;
        bh=t6kIwAU70shIXQTRRuWOxa3k/LhMN/GTBFY0h/PA8iE=;
        b=TuRFMJ8hoMTwWbnkLTPKNQqaH2eEgzrJivZWkuV74vAkH5rOXkqFJHAOdW+yyTgrEC
         DYHYUifLi0Z8XHg92jsn5sc1UOEO/HBvGMl65mlNgL4CyjzAV37YO9irUgngVtameO9m
         Fy2OG1Pnm/VERt7PlBW04zmR9HgTUuNxeJqKHH5I096cXD4+xZHkx14tciRAP7yeKZWU
         TMxO1Iojecleqe/gcFz4GDTrZhWtY61Vr1YEwsfh9bpnt6ns4042X77u7/dDfF5S9/x7
         PA/N1W+/BEGcaNSrgwCQYLawXUdtE/g2wOAwqbJqIKXGFePder17YtlDOP/NfHOPmO7Y
         QA+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:reply-to
         :references:mime-version:content-disposition:in-reply-to;
        bh=t6kIwAU70shIXQTRRuWOxa3k/LhMN/GTBFY0h/PA8iE=;
        b=H9JvZU8do5i5TWsuHVdNPbtu6Ia27YI/Q/5AQ/rgkdvh/DCW07jSOF1HNi7nV9WL6J
         KIfX70ek/ykxWKOoNz/V7KPZrHUPaqU40bNJkVBci2yKMnWcM0ze5XNWu3qb29hsCChV
         ezQ3V8SiewSM2NRihNmP4QBOa1zRU/t0i/AIzWljbfgSOl6+c5dUYBzu3zm3JPmKwARA
         hpZqe9qAccUJXtfm0HqDzqSKJdB61gM0j+FpjJwvEQxAqQhxTUGaZdY/1b06bjOQjeip
         duYiJC7RK0G0Sck1+ZXCFhD6w4Vdn9ksSk7yj0l0gAeCPA1crZrbSBk5cwgT3OyhjwZc
         7rmw==
X-Gm-Message-State: AOAM530o2tgr8OHXXcsVvwb/EL5KtqdTUOxH9Vo+V7Fvuv5s5krodquR
        mYQwjQBgnq0yGtznRMbiaMctxBCF0lMhFw==
X-Google-Smtp-Source: ABdhPJwbHKYWtKg0KPqpnO9g/PyZRD4SjR191bymsfbLUyL47PXMpo8tdbKNT+BB7f3JP5qS5nmanQ==
X-Received: by 2002:a17:906:1741:: with SMTP id d1mr48896271eje.182.1609531585451;
        Fri, 01 Jan 2021 12:06:25 -0800 (PST)
Received: from pevik ([62.201.25.198])
        by smtp.gmail.com with ESMTPSA id s15sm12938048eja.36.2021.01.01.12.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jan 2021 12:06:24 -0800 (PST)
Date:   Fri, 1 Jan 2021 21:06:22 +0100
From:   Petr Vorel <petr.vorel@gmail.com>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, Rich Felker <dalias@libc.org>,
        Peter Korsgaard <peter@korsgaard.com>,
        Baruch Siach <baruch@tkos.co.il>,
        Florian Weimer <fweimer@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1] uapi: move constants from <linux/kernel.h> to
 <linux/const.h>
Message-ID: <X++AviN6Zb75Yziv@pevik>
Reply-To: Petr Vorel <petr.vorel@gmail.com>
References: <20210101200308.22770-1-petr.vorel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210101200308.22770-1-petr.vorel@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

> and include <linux/const.h> in UAPI headers instead of <linux/kernel.h>.

> commit a85cbe6159ffc973e5702f70a3bd5185f8f3c38d upstream.

> The reason is to avoid indirect <linux/sysinfo.h> include when using
> some network headers: <linux/netlink.h> or others -> <linux/kernel.h>
> -> <linux/sysinfo.h>.

> This indirect include causes on MUSL redefinition of struct sysinfo when
> included both <sys/sysinfo.h> and some of UAPI headers:

>     In file included from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/kernel.h:5,
>                      from x86_64-buildroot-linux-musl/sysroot/usr/include/linux/netlink.h:5,
>                      from ../include/tst_netlink.h:14,
>                      from tst_crypto.c:13:
>     x86_64-buildroot-linux-musl/sysroot/usr/include/linux/sysinfo.h:8:8: error: redefinition of `struct sysinfo'
>      struct sysinfo {
>             ^~~~~~~
>     In file included from ../include/tst_safe_macros.h:15,
>                      from ../include/tst_test.h:93,
>                      from tst_crypto.c:11:
>     x86_64-buildroot-linux-musl/sysroot/usr/include/sys/sysinfo.h:10:8: note: originally defined here

> Link: https://lkml.kernel.org/r/20201015190013.8901-1-petr.vorel@gmail.com
> Signed-off-by: Petr Vorel <petr.vorel@gmail.com>
> Suggested-by: Rich Felker <dalias@aerifal.cx>
> Acked-by: Rich Felker <dalias@libc.org>
> Cc: Peter Korsgaard <peter@korsgaard.com>
> Cc: Baruch Siach <baruch@tkos.co.il>
> Cc: Florian Weimer <fweimer@redhat.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> ---
> Hi,

> could this fix be backported to stable releases?
> Maybe safer to wait till v5.11 release.

> Adjusted for stable/linux-4.9.y.
I'm sorry, this one is for stable/linux-4.4.y

Kind regards,
Petr
