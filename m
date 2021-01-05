Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 345F72EA6EB
	for <lists+stable@lfdr.de>; Tue,  5 Jan 2021 10:07:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727217AbhAEJGE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jan 2021 04:06:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbhAEJGE (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 5 Jan 2021 04:06:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E1372255F;
        Tue,  5 Jan 2021 09:05:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609837523;
        bh=HsxNQ3hY9JJAVm03uoKx2FYQuoFXeHhxoEY7BQJSUcI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=urNOYSD3LnSIWXqIjYoQ4MmR4LHPqtdBgC5kvhQWTkQi77B9r2XCetN7/iGKe61Vq
         XUDf9nlzJuOJW2aOjFM70QSomb8lIkcUO05HSY6h9z4qpNp/sbEQ76bG9pW8WlonzH
         91jOeGVvz5BGYnc73CsL4CDFYoreseICrHklcT78=
Date:   Tue, 5 Jan 2021 10:06:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Pavel Machek <pavel@denx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 00/35] 4.19.165-rc1 review
Message-ID: <X/QsKKc0YR/wddUb@kroah.com>
References: <20210104155703.375788488@linuxfoundation.org>
 <CAEUSe78+F1Q9LFjpf8SQzQa6+Ak4wcPiiNcUVxEcv+KPdrYvBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAEUSe78+F1Q9LFjpf8SQzQa6+Ak4wcPiiNcUVxEcv+KPdrYvBw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 04, 2021 at 11:43:28AM -0600, Daniel Díaz wrote:
> Hello!
> 
> On Mon, 4 Jan 2021 at 09:58, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > This is the start of the stable review cycle for the 4.19.165 release.
> > There are 35 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Jan 2021 15:56:52 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.165-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> >
> > -------------
> > Pseudo-Shortlog of commits:
> >
> > Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> >     Linux 4.19.165-rc1
> [...]
> > Peter Zijlstra <peterz@infradead.org>
> >     mm/mmu_gather: invalidate TLB correctly on batch allocation failure and flush
> [...]
> 
> This one fails to compile on the X15 (arm 32-bits) with:
> | /srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/mm/memory.c:
> In function 'tlb_table_invalidate':
> | /srv/oe/build/tmp-lkft-glibc/work-shared/am57xx-evm/kernel-source/mm/memory.c:342:6:
> error: implicit declaration of function 'tlb_needs_table_invalidate';
> did you mean 'tlb_table_invalidate'?
> [-Werror=implicit-function-declaration]
> |   if (tlb_needs_table_invalidate()) {
> |       ^~~~~~~~~~~~~~~~~~~~~~~~~~
> |       tlb_table_invalidate

Thanks for letting me know, will go drop this and the other patches in
this series and do a -rc2 soon.

greg k-h
