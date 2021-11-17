Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5499345490F
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:43:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232993AbhKQOqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:46:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233479AbhKQOqy (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Nov 2021 09:46:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B3461260;
        Wed, 17 Nov 2021 14:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637160235;
        bh=ezJcZ5yqF7AhnQakOLB1XrIaYOGRiiXwqKF7Jc9dx+Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2cinq2VNohMQomac7UlDeiou/MpXc7XOSuGzDdeXgJX9qJ8SVIcSBoMMqjUBPfRyI
         OnMMDMd2akdkanWbYu2eX2YD2USMtobwVLZadO8nvcrv2DG/hnaH7Xn/NiZF6dyWE0
         umO1Z2YfCm+lJeb8pLsr81x/70cBR3irrWW34ybU=
Date:   Wed, 17 Nov 2021 15:43:53 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <YZUVKX0KraPWiXx1@kroah.com>
References: <20211117101657.463560063@linuxfoundation.org>
 <81192f2a-afe7-1eee-847a-f8103a6d7cd1@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81192f2a-afe7-1eee-847a-f8103a6d7cd1@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 06:13:47AM -0800, Guenter Roeck wrote:
> On 11/17/21 2:19 AM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.3 release.
> > There are 923 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build is still broken for m68k.
> 
> drivers/block/ataflop.c: In function 'atari_cleanup_floppy_disk':
> drivers/block/ataflop.c:2050:17: error: implicit declaration of function 'blk_cleanup_disk'
> drivers/block/ataflop.c: In function 'atari_floppy_init':
> drivers/block/ataflop.c:2065:15: error: implicit declaration of function '__register_blkdev'
> 
> Are you sure you want to carry that patch series into v5.10.y ? I had to revert
> pretty much everything to get it to compile. It seems to me that someone should
> provide a working backport if the series is needed/wanted in v5.10.y.

Wow, I dropped the wrong patch :(

No, I don't want to carry that series, let me go rip out everything for
ataflop.c now.  If someone cares about this for 5.10.y, I'll take a
backport series, but really, they should just go use 5.15.y instead.

I'll push out a -rc4 now.

thanks,

greg k-h
