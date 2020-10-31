Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30EF72A1519
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 11:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726705AbgJaKP3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 06:15:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:53880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgJaKP3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 06:15:29 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7E9420719;
        Sat, 31 Oct 2020 10:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604139328;
        bh=3Cmzv6DicAII9v7mimD1qHIYZDQWfFrKWlHS+W2TAh4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ev+Tvctn7XJ48Cz/NXCEDlhIIlPIBtFjuK7GCtrPhYcbdZBZPSk+JgzF35ESAuYIh
         tku+KIwNs2BQGNuW2QSNyz6pjyj/IGz3LHBOrWenqc43Z5lSlxa1G/00o2GUmruJMc
         aT/VSmHJ5gRYTsyLGcxjFGgBptQjuwKIVtEXyArI=
Date:   Sat, 31 Oct 2020 11:16:14 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/264] 4.19.153-rc1 review
Message-ID: <20201031101614.GA525483@kroah.com>
References: <20201027135430.632029009@linuxfoundation.org>
 <20201028171035.GD118534@roeck-us.net>
 <20201028195619.GC124982@roeck-us.net>
 <20201031094500.GA271135@eldamar.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031094500.GA271135@eldamar.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 31, 2020 at 10:45:00AM +0100, Salvatore Bonaccorso wrote:
> Hi Greg,
> 
> On Wed, Oct 28, 2020 at 12:56:19PM -0700, Guenter Roeck wrote:
> > Retry.
> > 
> > On Wed, Oct 28, 2020 at 10:10:35AM -0700, Guenter Roeck wrote:
> > > On Tue, Oct 27, 2020 at 02:50:58PM +0100, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.19.153 release.
> > > > There are 264 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Thu, 29 Oct 2020 13:53:47 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > Build results:
> > > 	total: 155 pass: 152 fail: 3
> > > Failed builds:
> > > 	i386:tools/perf
> > > 	powerpc:ppc6xx_defconfig
> > > 	x86_64:tools/perf
> > > Qemu test results:
> > > 	total: 417 pass: 417 fail: 0
> > > 
> > > perf failures are as usual. powerpc:
> 
> Regarding the perf failures, do you plan to revert b801d568c7d8 ("perf
> cs-etm: Move definition of 'traceid_list' global variable from header
> file") included in 4.19.152 or is a bugfix underway?

No bugfix that I know of :)

If you can send a patch that I can apply to resolve this, I'll gladly
take it.

thanks,

greg k-h
