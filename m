Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCABF46B591
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:18:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbhLGIWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:22:25 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:41048 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhLGIWZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:22:25 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F272B816D2;
        Tue,  7 Dec 2021 08:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DE98C341C6;
        Tue,  7 Dec 2021 08:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638865133;
        bh=fT6fSuGahXakGiGnV0+VFN8wdw79fnDif1DejAcw+qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hqgmo5j6DN7JjPyQbv/nZPChoEmx+22CLj132naFUE7cfM8sKpTfcDhoejLuW/xqc
         6Ky2diT8NOvDnZUGrEuFLSHOpD8wHR3MZ06GYV+lDPMWUwJB0oZ9NZ7w5VNDdu3I4o
         1ClJ9tf9BBbPkliEXXCG4F12z/gQvBFPysNaHbK4=
Date:   Tue, 7 Dec 2021 09:18:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/130] 5.10.84-rc1 review
Message-ID: <Ya8Y6jo7UbtD5C5j@kroah.com>
References: <20211206145559.607158688@linuxfoundation.org>
 <bd0bddb3-8fa7-dc8e-d205-5c266e98d8b9@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd0bddb3-8fa7-dc8e-d205-5c266e98d8b9@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 07, 2021 at 10:17:40AM +0800, Samuel Zou wrote:
> 
> 
> On 2021/12/6 22:55, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.84 release.
> > There are 130 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.84-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> > 
> 
> Built for 5.10.84-rc1, and compile failure on arm64 and x86:
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Version: 5.10.84-rc1
> Commit: ea2293709b3cac4bdfcb88ad67605c58264608df
> Compiler: gcc version 7.3.0 (GCC)
> 
> --------------------------------------------------------------------
> 
> Kernel build failed, error log:
> ERROR: modpost: "kgd2kfd_resume_iommu"
> [drivers/gpu/drm/amd/amdgpu/amdgpu.ko] undefined!
> make[1]: *** [scripts/Makefile.modpost:124: modules-only.symvers] Error 1
> make[1]: *** Deleting file 'modules-only.symvers'
> make: *** [Makefile:1413: modules] Error 2
> make: *** Waiting for unfinished jobs....
> 
> --------------------------------------------------------------------
> 
> Tested-by: Hulk Robot <hulkrobot@huawei.com>


Thanks for the report, should be fixed in -rc2

greg k-h
