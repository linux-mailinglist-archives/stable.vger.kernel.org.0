Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4D49182076
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 19:11:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730715AbgCKSL1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 14:11:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:57002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730468AbgCKSL1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 14:11:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4CE68206E9;
        Wed, 11 Mar 2020 18:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583950287;
        bh=LAmVj8hirhN3uk0lMXdix5Qllm0bCBFn3qLGsn2mMvg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LGPUgkFLLBgL0IAOcLhsDT86TeQGHsV6APi/lf/8oQrDVPqprbuWpaBPVZja9JYcl
         XHzeZE4S7au+PD0JTqAH/wQFC6EW6otigBaJJ2YaTn4wOQhwSY313QScmFyV2yru6Q
         SUDq1GbzCjCd8GuK94Ti/k6n+Zr1A4X1Q0q3+yZo=
Date:   Wed, 11 Mar 2020 19:11:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.5 000/189] 5.5.9-stable review
Message-ID: <20200311181124.GC3970258@kroah.com>
References: <20200310123639.608886314@linuxfoundation.org>
 <a98e88fd-8e52-4f27-5e06-878241d65d4e@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a98e88fd-8e52-4f27-5e06-878241d65d4e@roeck-us.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 10, 2020 at 03:05:59PM -0700, Guenter Roeck wrote:
> On 3/10/20 5:37 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.5.9 release.
> > There are 189 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Thu, 12 Mar 2020 12:34:10 +0000.
> > Anything received after that time might be too late.
> > 
> 
> For v5.5.8-190-g11e07aec0780:
> 
> 
> Build results:
> 	total: 157 pass: 152 fail: 5
> Failed builds:
> 	csky:defconfig
> 	csky:allnoconfig
> 	csky:tinyconfig
> 	m68k:defconfig
> 	m68k:sun3_defconfig
> Qemu test results:
> 	total: 423 pass: 418 fail: 5
> Failed tests:
> 	arm:sx1:sx1_defconfig:initrd
> 	arm:sx1:sx1_defconfig:sd:rootfs
> 	arm:sx1:sx1_defconfig:flash32,26,3:rootfs
> 	q800:m68040:mac_defconfig:initrd
> 	q800:m68040:mac_defconfig:rootfs
> 
> csky:
> 
> kernel/fork.c:2588:2: error: #error clone3 requires copy_thread_tls support in arch
>  2588 | #error clone3 requires copy_thread_tls support in arch

That's odd, let me dig...
