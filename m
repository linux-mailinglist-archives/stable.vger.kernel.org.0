Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC77C3CF46E
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237043AbhGTFlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236407AbhGTFlI (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 01:41:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 98FBA60FF4;
        Tue, 20 Jul 2021 06:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626762106;
        bh=jq0ewQwBw6Q1yW64gNoLCeTHLITzxApdaNjRG0iJlrs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qwKgcWgLiMYn06+ltx7KwDAOJO1RlwGmUwdk3TCad2x/M921gztXufgGiI+R7+JU6
         B26QEsLPF1VFqBaIifhwzOoY2w4g9njSY8uTMY9zdlsFsLYM7meScVMoAnHEBDGF2y
         0687mPc9r1eawSiuzJ+RWDiZNMstCWrsAn60T2Cs=
Date:   Tue, 20 Jul 2021 08:21:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     shuah@kernel.org, f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        linux-kernel@vger.kernel.org, namhyung@kernel.org
Subject: Re: [PATCH 5.4 000/148] 5.4.134-rc2 review
Message-ID: <YPZrcigTNlR5196d@kroah.com>
References: <20210719184316.974243081@linuxfoundation.org>
 <3d770ab7-5008-cbee-98c1-101d839739cd@linaro.org>
 <b98fa7ee-bfb2-4c0b-19e1-9b4175e4a167@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b98fa7ee-bfb2-4c0b-19e1-9b4175e4a167@linaro.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 05:46:26PM -0500, Daniel Díaz wrote:
> Hello!
> 
> On 7/19/21 3:46 PM, Daniel Díaz wrote:
> > On 7/19/21 1:45 PM, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.134 release.
> > > There are 148 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Wed, 21 Jul 2021 18:42:54 +0000.
> > > Anything received after that time might be too late.
> > > 
> > > The whole patch series can be found in one patch at:
> > >     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.134-rc2.gz
> > > or in the git tree and branch at:
> > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > > and the diffstat can be found below.
> > > 
> > > thanks,
> > > 
> > > greg k-h
> > 
> > Perf fails to compile in 5.4 on Arm, Arm64, i386 and x86 (GCC 11 and GCC 7.3):
> > 
> >    builtin-report.c:669:12: error: 'process_attr' used but never defined [-Werror]
> >      669 | static int process_attr(struct perf_tool *tool __maybe_unused,
> >          |            ^~~~~~~~~~~~
> >    cc1: all warnings being treated as errors
> >    make[3]: *** [/builds/linux/tools/build/Makefile.build:96: /home/tuxbuild/.cache/tuxmake/builds/current/builtin-report.o] Error 1
> 
> Bisection points to ee7531fb817c ("perf report: Fix --task and --stat with pipe input" [upstream commit 892ba7f18621a02af4428c58d97451f64685dba4]).

Thanks, now dropped.

greg k-h
