Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34B79273223
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 20:44:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbgIUSol (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 14:44:41 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:37568 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726973AbgIUSol (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Sep 2020 14:44:41 -0400
Received: by mail-ot1-f66.google.com with SMTP id o8so13296055otl.4;
        Mon, 21 Sep 2020 11:44:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f9F01z2Bb5z2ZzTC5oN6TiPPe6hXeQsG8uh2XLvZwBk=;
        b=Xpvu6JQrJGnGih4hXoIT4vyDLvDjVnsHE9M3RysvEr6yYozNoJlJbE1d2MEo6maSAx
         UnIlA4gq8jUxV3JF8MMOM25ufaDGk2n5wd5OQsBnNI8n8RVa+5UY6T6WpX007n2XoJiX
         30FWSMvbVCjzpRILxSN1E0CEG+id0R3Dl+VrIrd+r5PSKcXeLcrt7ShyG/um2/p8TRhy
         niOiv9Nhu3JWZYA3Vegw9J9fCgcHJOjaWJxceQT50pA/f0K5nCTJPpm7Cas/6gKljFeW
         IpTT1VtoemosBEudzl9/DkaGWLd/KxU3kNv8zPyRTbG/k71JjeKAs81ffWIZ4+q49O5c
         atJA==
X-Gm-Message-State: AOAM533drkJPs/c3ZryUxRtsqY9VTDEW/3LDjpx/Ny8d7Mz7csbJVJoX
        MQ2tH44YStQpRMOxn9PS3qVsiWUjwoE9cdTM8Y761200
X-Google-Smtp-Source: ABdhPJyO6UOg193jgPD+dvYrx2dx3pZjktblM7sGAP0U09mFmjWTD6HUIM/r22gTXuP1ftM2NnVlNhk7oWeWpMvU7yQ=
X-Received: by 2002:a9d:5a92:: with SMTP id w18mr512260oth.145.1600713880522;
 Mon, 21 Sep 2020 11:44:40 -0700 (PDT)
MIME-Version: 1.0
References: <20200921162036.324813383@linuxfoundation.org>
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 21 Sep 2020 20:44:29 +0200
Message-ID: <CAMuHMdVhowO4jK7hNk9MK5-SdmgQs3BTV3rd9jvYBknTX0GeXA@mail.gmail.com>
Subject: Re: [PATCH 5.8 000/118] 5.8.11-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Sep 21, 2020 at 6:47 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.8.11 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Sep 2020 16:20:12 +0000.
> Anything received after that time might be too late.

> Jan Kara <jack@suse.cz>
>     dax: Fix compilation for CONFIG_DAX && !CONFIG_FS_DAX
>
> Jan Kara <jack@suse.cz>
>     dm: Call proper helper to determine dax support

Perhaps it would be wise to hold-off a bit on backporting these, until
they have received more testing?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
