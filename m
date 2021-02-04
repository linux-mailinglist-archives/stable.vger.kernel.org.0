Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC66430FB9F
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 19:36:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238809AbhBDSe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 13:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239168AbhBDSd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 13:33:59 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25522C06178B
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 10:33:18 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id u4so4628874ljh.6
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 10:33:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hsUHxWVQ9pn1uVdqIrgpTfjCGGtb4+YVBfEy6i5I4j8=;
        b=MIpB4GK7A+9drQZ10/Y0xovSPfiwOCvliMddfq/jpGDedVMqXyhEAhy7KYlKseXjin
         A2upjPV9hbYJ3KKwZxV7a8IotVYydpQXhvxCZReUKugIa6aGcF5zj1akjgRTnweyO43c
         TVmSCIRenACFaf9Nu8ulsM6OzU/sCMUNDL6H8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hsUHxWVQ9pn1uVdqIrgpTfjCGGtb4+YVBfEy6i5I4j8=;
        b=Tvxd0015ayxqt7k3I4M6oxLxybOvEtLKD5QEnjtBeHY9fCrj0LA1b851qvwOFXVsry
         9voxnJGDpf2DpPoFsYh5a+QxpwngK2BlNWHZhemQ1ZgqfGl2QWlDc+Gg4ZbSyaNiSIQf
         slqaManer1t9x4vsatsTYUMslVVl+PxgjFTUUC5YXNxJKctQJF5m8qavTD9tNvs+CYpx
         0f4+3Zp8Wcv4emRtE6F49Fa0FH4CXzjq0PcrN6gHgCrkbRueCk2DLZSPTqtDioWbah/U
         MWn8UpBLiUzew9KIiIZ2cbfHNA0kkbHsE81WaTs7tZylkIa61+OkwIbyG07OzXku+d5U
         X6hw==
X-Gm-Message-State: AOAM532cdzE25IlF5Ydrvdx8QE8kqBmCgT2hmKbziR7GuH28bufr/d1D
        3DXvEJP47NQOWcgHLmK2gpvHg6SZSZ/4yw==
X-Google-Smtp-Source: ABdhPJwD5hsLgciWQHUjciciszJpJ3/p2YBrWBmM5/kTLIrzrCwaxTckSqAGZJVhk0SPF9pNuTm+5g==
X-Received: by 2002:a05:651c:151:: with SMTP id c17mr400694ljd.246.1612463594685;
        Thu, 04 Feb 2021 10:33:14 -0800 (PST)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id o30sm703902lfi.168.2021.02.04.10.33.13
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 Feb 2021 10:33:13 -0800 (PST)
Received: by mail-lj1-f177.google.com with SMTP id t8so4592231ljk.10
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 10:33:13 -0800 (PST)
X-Received: by 2002:a2e:720d:: with SMTP id n13mr421266ljc.220.1612463592842;
 Thu, 04 Feb 2021 10:33:12 -0800 (PST)
MIME-Version: 1.0
References: <CAHk-=wgmJ0q1URHrOb-2iCOdZ8gYybiH6LY2Gq7cosXu6kxAnA@mail.gmail.com>
 <161160687463.28991.354987542182281928@build.alporthouse.com>
 <CAHk-=wh23BXwBwBgPmt9h2EJztnzKKf=qr5r=B0Hr6BGgZ-QDA@mail.gmail.com> <20210204181925.GL299309@linux.ibm.com>
In-Reply-To: <20210204181925.GL299309@linux.ibm.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 4 Feb 2021 10:32:56 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg49zd_Z2V7+djV-sCVia0=Gv3GNWz6MYsa7vG16Ya5Sg@mail.gmail.com>
Message-ID: <CAHk-=wg49zd_Z2V7+djV-sCVia0=Gv3GNWz6MYsa7vG16Ya5Sg@mail.gmail.com>
Subject: Re: Linux 5.11-rc5
To:     Mike Rapoport <rppt@linux.ibm.com>
Cc:     Chris Wilson <chris@chris-wilson.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 4, 2021 at 10:19 AM Mike Rapoport <rppt@linux.ibm.com> wrote:
>
> On Mon, Jan 25, 2021 at 12:49:39PM -0800, Linus Torvalds wrote:
> >
> > Mike: should we perhaps revert the first patch too (commit
> > bde9cfa3afe4: "x86/setup: don't remove E820_TYPE_RAM for pfn 0")?
>
> Unfortunately, I was too optimistic and didn't take into account that this
> commit changes the way /dev/mem sees the first page of memory.
>
> There were reports of slackware users about issues with lilo after upgrade
> from 5.10.11 to 5.10.12

Ok, applied to mainline.

Greg & stable people - this is now commit 5c279c4cf206 ("Revert
"x86/setup: don't remove E820_TYPE_RAM for pfn 0"") in my tree.
Although maybe you just want to revert the commit in stable, rather
than take it from upstream? Same difference.

                 Linus
