Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8F8306CA0
	for <lists+stable@lfdr.de>; Thu, 28 Jan 2021 06:14:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbhA1FMK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jan 2021 00:12:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229825AbhA1FMH (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jan 2021 00:12:07 -0500
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AEA2C061573
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 21:11:26 -0800 (PST)
Received: by mail-lj1-x232.google.com with SMTP id e18so4806965lja.12
        for <stable@vger.kernel.org>; Wed, 27 Jan 2021 21:11:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Yz4dvbWilv+59+sGvg7GlreEXmLYHQWRQqY4rHmQdj8=;
        b=DA1aho4knu8EGzj179+534CVs3VecnJZBpLja6mPhWG/xBuAx9rDxzXSUifoEgPTs5
         Ph9OLQDunZxUpZO6gnUjM2AdExHmh4vrgf1Zet00XwJMirfurIp9uZQvjp2wc/d6UkrU
         Z38rRoKRhyo3jsNYTk3f8PQadKp3/Rh9TiuPKJFJUea2i5UF4/ZRtMkqohBsvYR4mLBJ
         A3H0xXUdHCEcTqkDnJ4gfzj9bOX+d4Hf+An/guf1uSx+cv89bkGXnvgKBln8/N3sL+TU
         4OI51WtZfUYE/g99NT1XeiM7s1d/ZqgQLJVMUUZPvN3EelapRn7aNrKjze/PVaDacAaI
         VtZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Yz4dvbWilv+59+sGvg7GlreEXmLYHQWRQqY4rHmQdj8=;
        b=CpnPR8MMzlIvkI0cpAvdhTia9jtPOl5QzkeU/Z1Snifn4wywfgvMvgkpAssl0Imyzl
         pyU2X157Q5u0apOYxb9Jr2SS08L9zUMCjrqfNvrAtSyDKokp8cWRIRG4OV62V29npLOY
         9gx/YER+xA8tA0GXlB3biZR8OiwPybkOaGrtQMwp9W5+S8/ED/93PKR/pRrtZ3XsnaNf
         f/LMEzVXVPq2jl1J9vnGgDHCZCCqBs+CmqpqRVjegMZKApMYhmD5Wl24OLEVUvuJu+t8
         Nma8YEaP+55vcb5mm9hrgGxaKqQcskrtjiyf/KGIHe4vC6ZUmYbgtBStR60TG6C4ZHdM
         au5g==
X-Gm-Message-State: AOAM530d9P3axHHYXSoTRJhU5zBxWX4FyyhjpAONtVCcrCTp31su36I+
        3JvwZ8+h3PUtFe08L7upS8UZN3GQGnrNbY1tpMv+Iw==
X-Google-Smtp-Source: ABdhPJx1h6w8r4GuWW2pMTFX/gJji2VtuNCQtzxOgmz9AZ9wjQFJUaHAmSpPueSwlFMNk5huWj533XG+GxZ9oZbGbsY=
X-Received: by 2002:a2e:97cc:: with SMTP id m12mr7313826ljj.343.1611810684701;
 Wed, 27 Jan 2021 21:11:24 -0800 (PST)
MIME-Version: 1.0
References: <1611313556-4004-1-git-send-email-sumit.garg@linaro.org>
 <CAD=FV=V8HwhdhpCoiZx4XbTMWug0CAxhsnPR+5V9rB0W7QXFTQ@mail.gmail.com> <20210125081855.gfq3n6urcmght3ef@maple.lan>
In-Reply-To: <20210125081855.gfq3n6urcmght3ef@maple.lan>
From:   Sumit Garg <sumit.garg@linaro.org>
Date:   Thu, 28 Jan 2021 10:41:12 +0530
Message-ID: <CAFA6WYN8dOScFg8txFFis+kTm9qLU95XO4JO6uqZ4o=SfZeJGg@mail.gmail.com>
Subject: Re: [PATCH v3] kdb: Make memory allocations more robust
To:     Daniel Thompson <daniel.thompson@linaro.org>
Cc:     Doug Anderson <dianders@chromium.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 4.0+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 25 Jan 2021 at 13:48, Daniel Thompson
<daniel.thompson@linaro.org> wrote:
>
> On Fri, Jan 22, 2021 at 09:25:44AM -0800, Doug Anderson wrote:
> > Hi,
> >
> > On Fri, Jan 22, 2021 at 3:06 AM Sumit Garg <sumit.garg@linaro.org> wrote:
> > >
> > > Currently kdb uses in_interrupt() to determine whether its library
> > > code has been called from the kgdb trap handler or from a saner calling
> > > context such as driver init.  This approach is broken because
> > > in_interrupt() alone isn't able to determine kgdb trap handler entry from
> > > normal task context. This can happen during normal use of basic features
> > > such as breakpoints and can also be trivially reproduced using:
> > > echo g > /proc/sysrq-trigger
> >
> > I guess an alternative to your patch is to fully eliminate GFP_KDB.
> > It always strikes me as a sub-optimal design to choose between
> > GFP_ATOMIC and GFP_KERNEL like this.  Presumably others must agree
> > because otherwise I'd expect that the overall kernel would have
> > something like "GFP_AUTOMATIC"?
> >
> > It doesn't feel like it'd be that hard to do something more explicit.
> > From a quick glance:
> >
> > * I think kdb_defcmd() and kdb_defcmd2() are always called in response
> > to a user typing something on the kdb command line.  Those should
> > always be GFP_ATOMIC, right?
>
> No. I'm afraid not. The kdb parser is also used to execute
> kernel/debug/kdb/kdb_cmds as part of the kdb initialization. This
> initialization happens from the init calls rather than from the kgdb
> trap handler code.
>
> When I first looked at Sumit's patch I had a similar reaction to you
> but, whilst it is clearly it's not impossible to pass flags into the
> kdb parser and all its subcommands, I concluded that GFP_KDB is a
> better approach.
>
> BTW the reason I insisted on getting rid of the in_atomic() was to make
> it clear that GFP_KDB discriminates between exactly two calling contexts
> (normal and kgdb trap handler). I was didn't want any hints that imply
> GFP_KDB is a (broken) implementation of something like GFP_AUTOMATIC!
>

Ah, I see the reasoning to keep GFP_KDB. So we don't need any further
refactoring and can go ahead with this patch only.

-Sumit

>
> Daniel.
