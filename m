Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0233C62F4
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230199AbhGLS41 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:56:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:51864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhGLS41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 14:56:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DC7461221;
        Mon, 12 Jul 2021 18:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626116018;
        bh=s5jqSJ9v8G1sh1/3+68CAGkBAdSPamjiEhmZ50bNubQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqTck/A5Ooq96/ThUj1uk2cn1NCPs989ua7/yYEyB0UmF+ftgCLFGo0cpqbj26HWD
         5cRCcwuaN7U6a4upgXQKncTp0TwFjsOlNw7P2xzmXdatC917weKH0o90K2xCPDPZuc
         qZLSiLZd3bh8zf5eR2p+EwNfFyoDSN64s9dWhX+E=
Date:   Mon, 12 Jul 2021 20:53:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 000/348] 5.4.132-rc1 review
Message-ID: <YOyPsNnRIkJ/7p27@kroah.com>
References: <20210712060659.886176320@linuxfoundation.org>
 <806c2ec9-9e2e-f151-9873-6c53e20cd509@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806c2ec9-9e2e-f151-9873-6c53e20cd509@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 06:44:41AM -0700, Guenter Roeck wrote:
> On 7/11/21 11:06 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.132 release.
> > There are 348 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 157 pass: 153 fail: 4
> Failed builds:
> 	powerpc:defconfig
> 	powerpc:allmodconfig
> 	powerpc:cell_defconfig
> 	powerpc:maple_defconfig
> Qemu test results:
> 	total: 428 pass: 404 fail: 24
> Failed tests:
> 	<almost all ppc64 tests>
> 
> Error log:
> arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
> arch/powerpc/kernel/stacktrace.c:248:33: error: implicit declaration of function 'udelay'

Pushed out a -rc2 that should hopefully fix this.

thanks,

greg k-h
