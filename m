Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD0FE3C62F6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 20:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235800AbhGLS4m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 14:56:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:52064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230182AbhGLS4m (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 14:56:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D96B261241;
        Mon, 12 Jul 2021 18:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626116033;
        bh=CciheyvTeSzh3buSbrPbA/OuKp0HfvZuBz1QdhdVs9c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PIu3TRSeYAsemPXmd9KO5UfWukzBcajtic+r92WwUsxZk2hzd/H5dIbewIlasXTMz
         n2ryUjV7nxA/7hJOzrz9EW+9D5cpeB7eNqY9VOqiBK3RDdYsNModm61cdKqwrc2f96
         0+hGSORelXk1kPcJ47WmePLJgu1+XVk2rYaBFhEg=
Date:   Mon, 12 Jul 2021 20:53:51 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/593] 5.10.50-rc1 review
Message-ID: <YOyPv0ILiy9D2tR8@kroah.com>
References: <20210712060843.180606720@linuxfoundation.org>
 <8c443632-f09f-acbb-a23b-7cefdffe633f@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c443632-f09f-acbb-a23b-7cefdffe633f@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 06:46:32AM -0700, Guenter Roeck wrote:
> On 7/11/21 11:02 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.50 release.
> > There are 593 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 14 Jul 2021 06:02:46 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 159 pass: 155 fail: 4
> Failed builds:
> 	powerpc:defconfig
> 	powerpc:allmodconfig
> 	powerpc:cell_defconfig
> 	powerpc:maple_defconfig
> Qemu test results:
> 	total: 455 pass: 431 fail: 24
> Failed tests:
> 	<almost all ppc64 tests>
> 
> Error log:
> arch/powerpc/kernel/stacktrace.c: In function 'raise_backtrace_ipi':
> arch/powerpc/kernel/stacktrace.c:248:33: error: implicit declaration of function 'udelay'

Pushed out a -rc2 that should fix this.

thanks

greg k-h
