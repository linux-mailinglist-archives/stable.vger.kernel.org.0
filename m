Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CAA62DAAD8
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 11:27:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728348AbgLOK0w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Dec 2020 05:26:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:42486 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728344AbgLOK0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Dec 2020 05:26:52 -0500
Date:   Tue, 15 Dec 2020 11:27:09 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1608027966;
        bh=zGYbq+RDghEu+OWjtEcowOB/HGN126cSLD2pWbCec6Q=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=GS0XeDv1kAcL4MYklVy5dScdyauFsNjGonCtLl8goHs2Iy3DjDpaR3nnws1xQdjBT
         TNjFXwOkHjncr1B7yPjD3yOU5CjRWvAnoV5ruBOTpmkGIcKfYhCXP4MV1khofEjCzd
         73H64Df8akC7BsTmPHDqTp4b7/6Y2FEEbE9ktq/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org,
        linux-stable <stable@vger.kernel.org>, pavel@denx.de,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 5.10 0/2] 5.10.1-rc1 review
Message-ID: <X9iPfX8CtjOoWF7u@kroah.com>
References: <20201214170452.563016590@linuxfoundation.org>
 <CA+G9fYvanzter2c+H8HH=_PCYgf6DHHKihD2SwzG2+P+yGpz_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+G9fYvanzter2c+H8HH=_PCYgf6DHHKihD2SwzG2+P+yGpz_g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 15, 2020 at 03:50:57PM +0530, Naresh Kamboju wrote:
> On Mon, 14 Dec 2020 at 22:35, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.1 release.
> > There are 2 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Monday, 14 Dec 2020 18:04:42 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.1-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Results from Linaro’s test farm.
> No regressions on arm64, arm, x86_64, and i386.
> 
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

Thanks for testing this one!

greg k-h
