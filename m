Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F80B45DA9F
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 14:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355082AbhKYNEJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 08:04:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:47884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355019AbhKYNCI (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 08:02:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 66D1E60E98;
        Thu, 25 Nov 2021 12:58:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637845137;
        bh=nzxEflpodupMMfvREykEvTvMUBykRj+0xYVt9aq0zGA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gbKdb8p2Wg8Xpvg3M6+r+gqvr8kmlF/aHQIjgdr6N2P9ZvnYzpVTNMlHwtNw0h3Qd
         P4GU3QxiqXylM1k31mep1hJ/jz5tvA43rGyzFc9D8fNWVLKPkAL10HJWatDm6bSyIw
         HxyzSYOg5bcThP1pWG+ev0IBjZfy8htiP6h8iXEs=
Date:   Thu, 25 Nov 2021 13:58:48 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: stable-rc queue/4.9 buil arm tinyconfigs build failure
Message-ID: <YZ+IiOvUPIJeGSeC@kroah.com>
References: <CA+G9fYug3rX1wKksHsSmnpnkLj+p2JVKYFMFxqT3aAfJGCRYKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYug3rX1wKksHsSmnpnkLj+p2JVKYFMFxqT3aAfJGCRYKQ@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Nov 25, 2021 at 12:54:37PM +0530, Naresh Kamboju wrote:
> FYI,
> As you already know this build error still noticed on recent stable-rc queue/4.9
> 
> make --silent --keep-going --jobs=8
> O=/home/tuxbuild/.cache/tuxmake/builds/current ARCH=arm
> CROSS_COMPILE=arm-linux-gnueabihf- 'CC=sccache
> arm-linux-gnueabihf-gcc' 'HOSTCC=sccache gcc'
> In file included from /builds/linux/arch/arm/include/asm/tlb.h:28,
>                  from /builds/linux/arch/arm/mm/init.c:34:
> /builds/linux/include/asm-generic/tlb.h: In function 'tlb_flush_pmd_range':
> /builds/linux/include/asm-generic/tlb.h:208:47: error: 'PMD_SIZE'
> undeclared (first use in this function); did you mean 'PUD_SIZE'?
>   208 |  if (tlb->page_size != 0 && tlb->page_size != PMD_SIZE)
>       |                                               ^~~~~~~~
>       |                                               PUD_SIZE
> 
> metadata:
>     git_describe: v4.9.290-204-g1b54705bd25f
>     git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc-queues
>     git_sha: 1b54705bd25fff60b31f9d6db7b9e380f70beb03
>     git_short_log: 1b54705bd25f (\hugetlbfs: flush TLBs correctly
> after huge_pmd_unshare\)
>     kconfig: tinyconfig
>     target_arch: arm
>     toolchain: gcc-10 / gcc-11
> 
> Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> 
> --
> Linaro LKFT
> https://lkft.linaro.org

Should now be resolved.

thanks,

greg k-h
