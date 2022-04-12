Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A39CE4FE6C5
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 19:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346048AbiDLRZf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 13:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233538AbiDLRZe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 13:25:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E39EA60D97;
        Tue, 12 Apr 2022 10:23:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 47804B817F0;
        Tue, 12 Apr 2022 17:23:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D147C385A5;
        Tue, 12 Apr 2022 17:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649784193;
        bh=geoNenn1ptPKGhEeXjJtW/a5sBuvxlaIOo6LL0Lr6Tc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PrJTV6Ln0dofLpsKXnUfqycsy9uxB9og0Rh9hHgrnqaXtYeVM9nrJVzXPhIHRFTJL
         k2hfO9A2cn6gPc9R+10QjJFJJ3j42gpSXHjDYFx7GzQxzw498rP2igPw27tYhNyDst
         pg8pXHSjOuQQfi8tXdMCWCkIq6whasWAU7VaY8dU=
Date:   Tue, 12 Apr 2022 19:23:10 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     Marco Elver <elver@google.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Alexander Potapenko <glider@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        kasan-dev <kasan-dev@googlegroups.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH 5.15 000/277] 5.15.34-rc1 review
Message-ID: <YlW1fk8TvqIxiCvr@kroah.com>
References: <20220412062942.022903016@linuxfoundation.org>
 <CA+G9fYseyeNoxQwEWtiiU8dLs_1coNa+sdV-1nqoif6tER_46Q@mail.gmail.com>
 <CANpmjNP4-jG=kW8FoQpmt4X64en5G=Gd-3zaBebPL7xDFFOHmA@mail.gmail.com>
 <CA+G9fYuJKsYMR2vW+7d=xjDj9zoBtTF5=pSmcQRaiQitAjXCcw@mail.gmail.com>
 <YlWsI/v0SWjpyofc@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlWsI/v0SWjpyofc@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 06:43:15PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Apr 12, 2022 at 09:13:59PM +0530, Naresh Kamboju wrote:
> > Hi Marco
> > 
> > On Tue, 12 Apr 2022 at 20:32, Marco Elver <elver@google.com> wrote:
> > >
> > > On Tue, 12 Apr 2022 at 16:16, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > > >
> > > > On Tue, 12 Apr 2022 at 12:11, Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 5.15.34 release.
> > > > > There are 277 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Thu, 14 Apr 2022 06:28:59 +0000.
> > > > > Anything received after that time might be too late.
> > > > >
> > > > > The whole patch series can be found in one patch at:
> > > > >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.34-rc1.gz
> > > > > or in the git tree and branch at:
> > > > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > > > > and the diffstat can be found below.
> > > > >
> > > > > thanks,
> > > > >
> > > > > greg k-h
> > > >
> > > >
> > > > On linux stable-rc 5.15 x86 and i386 builds failed due to below error [1]
> > > > with config [2].
> > > >
> > > > The finding is when kunit config is enabled the builds pass.
> > > > CONFIG_KUNIT=y
> > > >
> > > > But with CONFIG_KUNIT not set the builds failed.
> > > >
> > > > x86_64-linux-gnu-ld: mm/kfence/core.o: in function `__kfence_alloc':
> > > > core.c:(.text+0x901): undefined reference to `filter_irq_stacks'
> > > > make[1]: *** [/builds/linux/Makefile:1183: vmlinux] Error 1
> > > >
> > > > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> > > >
> > > > I see these three commits, I will bisect and get back to you
> > > >
> > > > 2f222c87ceb4 kfence: limit currently covered allocations when pool nearly full
> > > > e25487912879 kfence: move saving stack trace of allocations into
> > > > __kfence_alloc()
> > > > d99355395380 kfence: count unexpectedly skipped allocations
> > >
> > > My guess is that this commit is missing:
> > 
> > This patch is missing Fixes: tag.
> > 
> > > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=f39f21b3ddc7fc0f87eb6dc75ddc81b5bbfb7672
> > 
> > For your information, I have reverted the below commit and build pass.
> > 
> > kfence: limit currently covered allocations when pool nearly full
> > 
> > [ Upstream commit 08f6b10630f284755087f58aa393402e15b92977 ]
> 
> I've added the above commit, does that fix the issue?
> 
> Hm, I can test that here, let me try it...

I can't duplicate the failure here with my config, let me try yours...
