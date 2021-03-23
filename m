Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 563C1345876
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 08:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230057AbhCWHT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 03:19:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:37262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229972AbhCWHT1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Mar 2021 03:19:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BB61E61994;
        Tue, 23 Mar 2021 07:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616483967;
        bh=rdG665sJM9rxcoSZiQkXRGZEaeY27wUAYv3b17ihGNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cdmtUal9cpp5FD30YqgHqBg8AP0seCQNOOearh+IsT6XCcLa3K1l/hAKkOk5sgnsK
         Mq6vOXN6ladJoAeexh33yQVvWfjroVSiQhlEWAA8OSawn+5/YLUIGxIYDpECFRzdxK
         bJSPfByEgfRmc1xAl0QaKUSulJp3H1y9+vfawZyI=
Date:   Tue, 23 Mar 2021 08:19:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/156] 5.10.26-rc2 review
Message-ID: <YFmWfPA9vAZzFpWp@kroah.com>
References: <20210322151845.637893645@linuxfoundation.org>
 <20210322215231.GB51597@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322215231.GB51597@roeck-us.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 22, 2021 at 02:52:31PM -0700, Guenter Roeck wrote:
> On Mon, Mar 22, 2021 at 04:19:10PM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.26 release.
> > There are 156 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 24 Mar 2021 15:18:19 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 156 pass: 156 fail: 0
> Qemu test results:
> 	total: 432 pass: 428 fail: 4
> Failed tests:
> 	arm:realview-pb-a8:realview_defconfig:realview_pb:mem512:arm-realview-pba8:initrd
> 	arm:realview-pbx-a9:realview_defconfig:realview_pb:arm-realview-pbx-a9:initrd
> 	arm:realview-eb:realview_defconfig:realview_eb:mem512:arm-realview-eb:initrd
> 	arm:realview-eb-mpcore:realview_defconfig:realview_eb:mem512:arm-realview-eb-11mp-ctrevb:initrd
> 
> Build failure:
> 
> kernel/rcu/tree.c:683:2: error: implicit declaration of function 'IRQ_WORK_INIT'
> 
> The patch introducing IRQ_WORK_INIT is not in v5.10.y.

That patch keeps coming back, Sasha and I have both added it multiple
times now... I'll go drop it, thanks.

greg k-h
