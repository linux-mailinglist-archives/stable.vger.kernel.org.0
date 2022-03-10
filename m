Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B710F4D43CA
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240930AbiCJJxI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:53:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233237AbiCJJxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:53:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0322313AA27;
        Thu, 10 Mar 2022 01:52:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 904F961D1F;
        Thu, 10 Mar 2022 09:52:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E95C340E8;
        Thu, 10 Mar 2022 09:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646905923;
        bh=VhDOW2Sr5evNMu3/dbxDxBWBiSMat/vpe3p/uE5RTa0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=tbWivgEbyPFhif75Azoc0IBuUnDp9JBuOiiQxb/jp2a+Tp3LC61XwnjQ1QAKK26mh
         KojH4yWcxDCUF+fmf/zcN3bnPSRzXn36uyhzWHJ6Qv2hnydilUyU3AfwfKqYJGhP/f
         a259137UzJbbj4tlqvFEx/rQcZcWIx/e+S+qxycw=
Date:   Thu, 10 Mar 2022 10:51:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
Message-ID: <YinKPfWBqkHH+ycl@kroah.com>
References: <20220309155856.155540075@linuxfoundation.org>
 <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
 <CADVatmMceoHeQqFDEJND_3GmSeQqgefeP0Z9_Zi=UTAVfZ71RQ@mail.gmail.com>
 <YijwKvDQxJzoYpFR@kroah.com>
 <CADVatmMkbwBNUhjb-S6=zVhiHi7s2Exqbwq3vXPsNzCutbYR-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmMkbwBNUhjb-S6=zVhiHi7s2Exqbwq3vXPsNzCutbYR-A@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 09:41:18AM +0000, Sudip Mukherjee wrote:
> On Thu, Mar 10, 2022 at 9:18 AM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Wed, Mar 09, 2022 at 06:15:08PM +0000, Sudip Mukherjee wrote:
> > > On Wed, Mar 9, 2022 at 6:08 PM Sudip Mukherjee
> > > <sudipm.mukherjee@gmail.com> wrote:
> > > >
> > > > Hi Greg,
> > > >
> > > > On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> > > > <gregkh@linuxfoundation.org> wrote:
> > > > >
> > > > > This is the start of the stable review cycle for the 4.19.234 release.
> > > > > There are 18 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > >
> > > > > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > > > > Anything received after that time might be too late.
> > > >
> > > > My tests are still running, but just an initial result for you,
> > > >
> > > > x86_64 defconfig fails with:
> > > > arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> > > > arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> > > > function 'unprivileged_ebpf_enabled'
> > > > [-Werror=implicit-function-declaration]
> > > >   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())
> > >
> > > And, lots of failures in arm builds also.
> > > Error:
> > > arch/arm/common/secure_cntvoff.S: Assembler messages:
> > > arch/arm/common/secure_cntvoff.S:24: Error: co-processor register
> > > expected -- `mcr p15,0,r0,c7,r5,4'
> > > arch/arm/common/secure_cntvoff.S:27: Error: co-processor register
> > > expected -- `mcr p15,0,r0,c7,r5,4'
> > > arch/arm/common/secure_cntvoff.S:29: Error: co-processor register
> > > expected -- `mcr p15,0,r0,c7,r5,4'
> > > make[1]: *** [scripts/Makefile.build:403:
> > > arch/arm/common/secure_cntvoff.o] Error 1
> > > make[1]: *** Waiting for unfinished jobs....
> > > arch/arm/kernel/entry-common.S: Assembler messages:
> > > arch/arm/kernel/entry-common.S:178: Error: co-processor register
> > > expected -- `mcr p15,0,r0,c7,r5,4'
> > > arch/arm/kernel/entry-common.S:187: Error: co-processor register
> > > expected -- `mcr p15,0,r0,c7,r5,4'
> > > make[1]: *** [scripts/Makefile.build:403:
> > > arch/arm/kernel/entry-common.o] Error 1
> > > make[1]: *** Waiting for unfinished jobs....
> > > arch/arm/mm/cache-v7.S: Assembler messages:
> > > arch/arm/mm/cache-v7.S:64: Error: co-processor register expected --
> > > `mcr p15,0,r0,c7,r5,4'
> > > arch/arm/mm/cache-v7.S:137: Error: co-processor register expected --
> > > `mcr p15,0,r0,c7,r5,4'
> > > arch/arm/mm/cache-v7.S:171: Error: co-processor register expected --
> > > `mcr p15,0,r0,c7,r5,4'
> > > arch/arm/mm/cache-v7.S:299: Error: co-processor register expected --
> > > `mcr p15,0,r0,c7,r5,4'
> > > make[1]: *** [scripts/Makefile.build:403: arch/arm/mm/cache-v7.o] Error 1
> >
> > All clang builds for arm are known to fail, and some arm64 clang builds
> > will also fail.  I have seen initial patches for arm64, will let the
> > clang developers come up with the arm fix as I have no idea how to
> > handle that.  This just mirrors Linus's tree right now :)
> >
> > Unless this is gcc?
> 
> This is gcc version 11.2.1 20220301
> 
> Guenter has also reported the same: "Almost all arm builds, all
> branches from 4.9.y to 5.16.y:"

Sorry, my email was stalled yesterday.  The fix for this should now be
in the queue, I'm doing some more build testing right now before I'll
release -rc2 for all branches.

thanks,

greg k-h
