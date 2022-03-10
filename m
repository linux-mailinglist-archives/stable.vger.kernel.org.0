Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2FA64D4531
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 11:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233163AbiCJK7c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 05:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232769AbiCJK7c (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 05:59:32 -0500
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7162B12A76E;
        Thu, 10 Mar 2022 02:58:31 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id z30so10116159ybi.2;
        Thu, 10 Mar 2022 02:58:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=2vyPILdksEKQ/91DNQr4IF++5+dXCv46TKTfWGt4bI0=;
        b=Sd/BMD6Z7Ek7AoGTWCHm27Ji3PaiZL2R7WRdCDaAWwWfRgnGP9XZyxUAukmh9P+soe
         N9k+Sg7AOmRV60kbwWB+xeIAofyrc6V70ayyreDBRnVtdC+QfO0i5S2CsgCJP/OWhaa3
         Y757+9XlHCaKu/XI4L1K7ReiWDawo+2cz+nnCvjcHNYPMkR28EsJ5CgtR4OQqSJzhlus
         /VfVr+gJ+28UnzGPPGkgXRU39fTlhBW0M5XEtyTbDPeQ5TuZHuJvLuqsWz3UpNIGNykl
         jcWVzCWd9rwaxJVnCqIjS/c2VTdSp4fckg6bNFIa1YSHO8s5Pk+CxdXiYywitB8giFXr
         CYgw==
X-Gm-Message-State: AOAM5302dAXZYpM+80cPEKlYTO23K2HfX+BrQ4NUhaOMeBTADPHI8oMs
        93ShH6Gv0bGf4zz+NJu7SIwSPdUzMBLyB57xV4s=
X-Google-Smtp-Source: ABdhPJyHSLHMgP/mxlDj5pAIHk6jXZ9MHGeA9bBiTuLvuVOxHvz5HeqITq5ICBa7BuoXLjLFWGq8R+hyrkt/HEmslkA=
X-Received: by 2002:a25:fe10:0:b0:625:262f:e792 with SMTP id
 k16-20020a25fe10000000b00625262fe792mr3170099ybe.365.1646909910721; Thu, 10
 Mar 2022 02:58:30 -0800 (PST)
MIME-Version: 1.0
References: <31b9d1cd-6a67-218b-4ada-12f72e6f00dc@redhat.com> <3f86f46d-947b-8485-bf87-2ebd4477a6c7@leemhuis.info>
In-Reply-To: <3f86f46d-947b-8485-bf87-2ebd4477a6c7@leemhuis.info>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Thu, 10 Mar 2022 11:58:19 +0100
Message-ID: <CAJZ5v0hLjj0UUtBoZ1rqcBm40HhX2AHL8RSvhNb+pzgt5w3izg@mail.gmail.com>
Subject: Re: Many reports of laptops getting hot while suspended with kernels
 >= 5.16.10 || >= 5.17-rc1
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Linux PM <linux-pm@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Mark Pearson <markpearson@lenovo.com>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 11:02 AM Thorsten Leemhuis
<regressions@leemhuis.info> wrote:
>
> Hi, this is your Linux kernel regression tracker.
>
> On 09.03.22 14:44, Hans de Goede wrote:
> >
> > We (Fedora) have been receiving a whole bunch of bug reports about
> > laptops getting hot/toasty while suspended with kernels >= 5.16.10
> > and this seems to still happen with 5.17-rc7 too.
>
> I was about to sent a similar mail, but then I found this one. Thx for
> making my life easier. :-D
>
> But could you do me a big favor and CC the regression mailing list
> (regressions@lists.linux.dev) in case similar situations arise in the
> future? tia!
>
> > The following are all bugzilla.redhat.com bug numbers:
> >
> >    1750910 - Laptop failed to suspend and completely drained the battery
> >    2050036 - Framework laptop: 5.16.5 breaks s2idle sleep
> >    2053957 - Package c-states never go below C2
> >    2056729 - No lid events when closing lid / laptop does not suspend
> >    2057909 - Thinkpad X1C 9th in s2idle suspend still draining battery to zero over night , Ap
> >    2059668 - HP Envy Laptop deadlocks on entering suspend power state when plugged in. Case ge
> >    2059688 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
> >
> > And one of the bugs has also been mirrored at bugzilla.kernel.org by
> > the reporter:
> >
> >  bko215641 - Dell G15 5510 s2idle fails in 5.16.11 works in 5.16.10
>
> Here is another, but it's basically linking to reports you already
> mentioned:
> https://bugzilla.kernel.org/show_bug.cgi?id=215661
>
> > The common denominator here (besides the kernel version) seems to
> > be that these are all Ice or Tiger Lake systems (I did not do
> > check this applies 100% to all bugs, but it does see, to be a pattern).
> >
> > A similar arch-linux report:
> >
> > https://bbs.archlinux.org/viewtopic.php?id=274292&p=2
> >
> > Suggest that reverting
> > "ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE"
> >
> > which was cherry-picked into 5.16.10 fixes things.
>
> From the thread I gather that it looks like 5.17 is not affected; if

This is most likely correct.

There are at least 3 different sources that have confirmed that.

> that changes, could anybody please give me a heads up please?

Sure.
