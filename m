Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B39413CF46D
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 08:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236354AbhGTFlH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 01:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236023AbhGTFlF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 20 Jul 2021 01:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D272161164;
        Tue, 20 Jul 2021 06:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626762103;
        bh=kT858tbM+FvoZJvsNWp8Z/qAwVIb0XIdGfoX9Qw5ELw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sBzwYBJmynrsdT64h222sKJzYzllzQb/0LG0Hlm1BGwCQRXm5vN/1Gp8rhfliVzuq
         DVrt6B7pm+v0sFRrVt15qjeSJ4gIX7z57jz1JPR6LU7L3PVMol3oEcSG6CBPyexSFI
         Q4QR92kenKuntNIWpGxs+Z6ooDY4csXi2KU06OKg=
Date:   Tue, 20 Jul 2021 08:21:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Jon Hunter <jonathanh@nvidia.com>,
        linux-stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Namhyung Kim <namhyung@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Ian Rogers <irogers@google.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 4.19 000/420] 4.19.198-rc2 review
Message-ID: <YPZraezaAgdBNPSp@kroah.com>
References: <20210719184335.198051502@linuxfoundation.org>
 <CA+G9fYtAN7y5Z82nO59daxD=AtYOyu2J7ECFjY2P64JR9Fqifg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYtAN7y5Z82nO59daxD=AtYOyu2J7ECFjY2P64JR9Fqifg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 11:25:22AM +0530, Naresh Kamboju wrote:
> On Tue, 20 Jul 2021 at 00:15, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.198 release.
> > There are 420 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 21 Jul 2021 18:42:43 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.198-rc2.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Perf fails to compile in 4.19 on Arm, Arm64, i386 and x86 with gcc 7.3
> It was also reported on 5.4.134-rc2.
> 
>   perf-1.0/perf-in.o: In function `tasks_setup':
>   tools/perf/builtin-report.c:664: undefined reference to `process_attr'
>   perf-in.o: In function `stats_setup':
>   tools/perf/builtin-report.c:644: undefined reference to `process_attr'
> 
> Bisection points to ee7531fb817c ("perf report: Fix --task and --stat
> with pipe input" [upstream commit
> 892ba7f18621a02af4428c58d97451f64685dba4]).
> 
> 
> > Namhyung Kim <namhyung@kernel.org>
> >     perf report: Fix --task and --stat with pipe input
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks, now dropped from all branches.

greg k-h
