Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78B9E46B58F
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:18:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232517AbhLGIWR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:22:17 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:40980 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhLGIWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:22:17 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BBEAB816BC;
        Tue,  7 Dec 2021 08:18:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6BACC341C3;
        Tue,  7 Dec 2021 08:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638865125;
        bh=zFoR9N2NGYr1DLBj6Tsew0aaSC+9bRcGhu92lmWFvyw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qr/Jmt0g/EdZl1CVwZ+PMYJtvZA/RNvfEo+dXiHz3+losRKTt94iE0A1b3AuU2IHv
         lzf3TRXv9nTlzeoSSt+ReiXpEu3x201qQE/3vIX6VAsKDRTGGbplvK0u1frpec9o2n
         1FNQVmhOVB7k5S8q8n2uew2vaLRXgohxGCKlOzfk=
Date:   Tue, 7 Dec 2021 09:18:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
Message-ID: <Ya8Y4usHrdld8IOT@kroah.com>
References: <20211206145559.607158688@linuxfoundation.org>
 <4a881261-ba90-2095-58df-13dcffe6bcf2@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a881261-ba90-2095-58df-13dcffe6bcf2@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 06, 2021 at 08:46:58AM -0800, Guenter Roeck wrote:
> On 12/6/21 6:55 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.84 release.
> > There are 130 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building i386:allyesconfig ... failed
> --------------
> Error log:
> x86_64-linux-ld: drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd.o: in function `amdgpu_amdkfd_resume_iommu':
> amdgpu_amdkfd.c:(.text+0x2b3): undefined reference to `kgd2kfd_resume_iommu'
> 
> Building i386:allmodconfig ... failed
> --------------
> Error log:
> ERROR: modpost: "kgd2kfd_resume_iommu" [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
> 
> The same error is seen for alpha:allmodconfig, arm:allmodconfig,
> mips:allmodconfig, parisc:allmodconfig, riscv32:allmodconfig,
> riscv64:allmodconfig, s390:allmodconfig, sparc64:allmodconfig,
> and xtensa:allmodconfig.

Thanks for the report, should be fixed in -rc2

greg k-h
