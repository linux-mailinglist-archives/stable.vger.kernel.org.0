Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EC325182971
	for <lists+stable@lfdr.de>; Thu, 12 Mar 2020 08:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388035AbgCLHCz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Mar 2020 03:02:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:42902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387845AbgCLHCy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 12 Mar 2020 03:02:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0ECA9206FA;
        Thu, 12 Mar 2020 07:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583996572;
        bh=tHtY2a+bDXFzDLQpJxEq11G1LE52aQPvJ2P6CHx5RNg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qca7UhL+3b9z0ltFZSIL0KM73MUr8cA9HyJQ5V2HO3TooOfpW0cHoRH5Nco63ghie
         B9t6dwZj15fQygPIFmgaivyjv83kV7LaQaKJOI0i2YPSIMAt4z03rxtnK3YIalZskU
         3yt2DC0WnbkqjEKWVNmhfm6MKMv26evO79lcq4jo=
Date:   Thu, 12 Mar 2020 08:02:50 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Backlund <tmb@mageia.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/169] 5.4.25-rc4 review
Message-ID: <20200312070250.GB4157582@kroah.com>
References: <20200311204002.240698596@linuxfoundation.org>
 <20200311230653.GA25697@roeck-us.net>
 <fb6f1f17-456b-86ec-f7d7-e9e6e8c28ba1@mageia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fb6f1f17-456b-86ec-f7d7-e9e6e8c28ba1@mageia.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 12, 2020 at 01:22:34AM +0200, Thomas Backlund wrote:
> Den 12-03-2020 kl. 01:06, skrev Guenter Roeck:
> > On Wed, Mar 11, 2020 at 09:41:16PM +0100, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.4.25 release.
> > > There are 169 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > > 
> > > Responses should be made by Fri, 13 Mar 2020 20:39:27 +0000.
> > > Anything received after that time might be too late.
> > > 
> > 
> > Build results:
> > 	total: 158 pass: 146 fail: 12
> > Failed builds:
> > 	alpha:allmodconfig
> > 	arm:allmodconfig
> > 	arm64:allmodconfig
> > 	m68k:allmodconfig
> > 	mips:allmodconfig
> > 	nds32:allmodconfig
> > 	parisc:allmodconfig
> > 	powerpc:allmodconfig
> > 	riscv:defconfig
> > 	s390:allmodconfig
> > 	sparc64:allmodconfig
> > 	xtensa:allmodconfig
> > Qemu test results:
> > 	total: 422 pass: 405 fail: 17
> > Failed tests:
> > 	<all riscv>
> > 
> > As already reported, the failure is:
> > 
> > drivers/gpu/drm/virtio/virtgpu_object.c:31:67: error: expected ')' before 'int'
> >     31 | module_param_named(virglhack, virtio_gpu_virglrenderer_workaround, int, 0400);
> > 
> > Guenter
> > 
> 
> I guess you need:
> commit b0138364da17617db052c4a738b58bf45e42f500
> Author: Stephen Rothwell <sfr@canb.auug.org.au>
> Date:   Wed Aug 28 18:55:16 2019 +1000
> 
>     drm/virtio: module_param_named() requires linux/moduleparam.h

Now added, thanks.

greg k-h
