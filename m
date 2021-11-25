Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D223445D8F8
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232920AbhKYLSk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:18:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:43234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229601AbhKYLQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:16:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F6F960FE8;
        Thu, 25 Nov 2021 11:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637838808;
        bh=c8IJyWpjCB8S06pHcSJNDfuWHCeVvAcoKzocRXj8Vy8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NoLh9nGsQB/J2q9dEgT8HTswrcehGfLI6u3aCbd5XArfvddwwzyHb0+6EgKOyh7ob
         ABIJE1xa3GeYC9/SpullDH/fhkRTKpJSGdEykVnEnziDY8M78+qpJaCwmtDML0pIyj
         7H0A/ZIDiUN67iaYrIS+9+n56lWvjk2QtlL3K+jw=
Date:   Thu, 25 Nov 2021 12:13:20 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-kernel@vger.kernel.org, shuah@kernel.org,
        f.fainelli@gmail.com, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, linux@roeck-us.net,
        Nadav Amit <namit@vmware.com>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 4.19 000/323] 4.19.218-rc1 review
Message-ID: <YZ9v0NWt6kEJw4co@kroah.com>
References: <20211124115718.822024889@linuxfoundation.org>
 <CA+G9fYt4wOWx5fEkMdYmT0JO+G5+6KBgdDDS7oS_2ox8X_JF4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYt4wOWx5fEkMdYmT0JO+G5+6KBgdDDS7oS_2ox8X_JF4g@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 09:03:46PM +0530, Naresh Kamboju wrote:
> On Wed, 24 Nov 2021 at 18:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.218 release.
> > There are 323 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.218-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
> 
> Regression found on s390 gcc-11 builds with defconfig
> 
> Here it is reported,
> https://lore.kernel.org/stable/CA+G9fYv+SjDwfvP=Zgf-gr2RngkrzHO_w6OQzH7wqzU-dOW9+g@mail.gmail.com/
> 
> mm/hugetlb.c: In function '__unmap_hugepage_range':
> mm/hugetlb.c:3455:25: error: implicit declaration of function
> 'tlb_flush_pmd_range'; did you mean 'tlb_flush_mmu_free'?
> [-Werror=implicit-function-declaration]
>  3455 |                         tlb_flush_pmd_range(tlb, address &
> PUD_MASK, PUD_SIZE);
>       |                         ^~~~~~~~~~~~~~~~~~~
>       |                         tlb_flush_mmu_free
> cc1: some warnings being treated as errors
> 
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 

Should now be fixed, thanks.

greg k-h
