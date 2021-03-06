Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC34532F93B
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 10:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230271AbhCFJzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 04:55:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:42434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229948AbhCFJzL (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 04:55:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD5206501C;
        Sat,  6 Mar 2021 09:55:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615024511;
        bh=qmM7OayTN3e6SuZ9GjYamTTixinEjsKjYdnOG8GHDJA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EjYS2GBpQiop8ACsyX89wMN/YKTroZ/fLmaRQ3McdIKWXARUXtPDdDnENOcftnX7C
         LiN8TAgG3nkbZnG6H3MnAGPPL6oLs4oruc/mB7V1dDCMudvm5LoBxmTCQz4k6I4jQf
         YYXnPFMi0SwdudoqcRctrYjUgTIj2zK00dDeqaMU=
Date:   Sat, 6 Mar 2021 10:55:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
Message-ID: <YENReyBNFZJyRxQN@kroah.com>
References: <20210305120857.341630346@linuxfoundation.org>
 <20210306032325.GA193012@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210306032325.GA193012@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 05, 2021 at 07:23:25PM -0800, Guenter Roeck wrote:
> On Fri, Mar 05, 2021 at 01:21:02PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.103 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Building arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd ... failed
> ------------
> Error log:
> kernel/rcu/tree.c:617:2: error: implicit declaration of function 'IRQ_WORK_INIT'; did you mean 'IRQ_WORK_BUSY'? [-Werror=implicit-function-declaration]
>   617 |  IRQ_WORK_INIT(late_wakeup_func);
>       |  ^~~~~~~~~~~~~
>       |  IRQ_WORK_BUSY

Thanks, will go fix this here too...
