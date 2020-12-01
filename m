Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EDB62C98FD
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 09:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728281AbgLAIT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 03:19:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728193AbgLAITz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Dec 2020 03:19:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FEFD2085B;
        Tue,  1 Dec 2020 08:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606810755;
        bh=0/yOIYQ98fm3d3u1FxrZ+6Y5Jj/gTetcUK3rSD1zAa4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=t902PH78vejIKt9/oIji5wZ3DjzlRhnwu3eYsRbwg/CWslYw7nbCdkcgEdwR4175w
         uuC5l45f1FM66NEZ7BPb1LVrc7xg5uGM0J8U+pVcbsmX7Jm/hj5WjGBsqw1M2RM3bO
         ZtzV1br9AYFBwyS9KsO7fZ1Q8EP4XgKphPnZ+Cf4=
Date:   Tue, 1 Dec 2020 09:20:27 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org, Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        x86@vger.kernel.org, Matthias Kaehlcke <mka@chromium.org>
Subject: Re: [stable 4.9] PANIC: double fault, error_code: 0x0 - clang boot
 failed on x86_64
Message-ID: <X8X8y4j9Ip+C5DwS@kroah.com>
References: <CA+G9fYt0qHxUty2qt7_9_YTOZamdtknhddbsi5gc3PDy0PvZ5A@mail.gmail.com>
 <X79NpRIqAHEp2Lym@kroah.com>
 <CAKwvOdmfEY6fnNFUUzLvN9bKyeTt7OMc-Uvx=YqTuMR2BuD5XA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKwvOdmfEY6fnNFUUzLvN9bKyeTt7OMc-Uvx=YqTuMR2BuD5XA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 30, 2020 at 12:12:39PM -0800, Nick Desaulniers wrote:
> On Wed, Nov 25, 2020 at 10:38 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Is the mainline 4.9 tree supposed to work with clang?  I didn't think
> > that upstream effort started until 4.19 or so.
> 
> (For historical records, separate from the initial bug report that
> started this thread)
> 
> I consider 785f11aa595b ("kbuild: Add better clang cross build
> support") to be the starting point of a renewed effort to upstream
> clang support. 785f11aa595b landed in v4.12-rc1.  I think most patches
> landed between there and 4.15 (would have been my guess).  From there,
> support was backported to 4.14, 4.9, and 4.4 for x86_64 and aarch64.
> We still have CI coverage of those branches+arches with Clang today.
> Pixel 2 shipped with 4.4+clang, Pixel 3 and 3a with 4.9+clang, Pixel 4
> and 4a with 4.14+clang.  CrOS has also shipped clang built kernels
> since 4.4+.

Thanks for the info.  Naresh, does this help explain why maybe testing
these kernel branches with clang might not be the best thing to do?

greg k-h
