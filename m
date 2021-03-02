Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272F032AED0
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235891AbhCCAGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1836209AbhCBGtl (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Mar 2021 01:49:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA11261601;
        Tue,  2 Mar 2021 06:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614667735;
        bh=6gx9TQVInjaRAjc4CSLRzI0NtYgyuPCdiIBICyndZqI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yn8PYz7nhQn2VRsk6fUnEaWqn5TEbEGqIqytnOOrRBIAxiWc/D2NmAEMZpA9aAIFR
         fZhXExBNjAC3oxJwOFcTMEo7bNfpzBVhBtMjgxlOQqsqLMQ4/t8gs4q3jRVo77ynw0
         s4FL2ptZrkzUOMwFCvmVmAtU94vrbfrMWRaLm2So=
Date:   Tue, 2 Mar 2021 07:48:52 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hanjun Guo <guohanjun@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org,
        zou_wei@huawei.com, Yanjin <yanjin.yan@huawei.com>
Subject: Re: [PATCH 5.4 000/340] 5.4.102-rc1 review
Message-ID: <YD3f1N3X3scF+2i8@kroah.com>
References: <20210301161048.294656001@linuxfoundation.org>
 <8271eb39-c44d-37ed-7501-e9d05d7fee17@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8271eb39-c44d-37ed-7501-e9d05d7fee17@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 02:42:15PM +0800, Hanjun Guo wrote:
> Hi Greg,
> 
> On 2021/3/2 0:09, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.102 release.
> > There are 340 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 03 Mar 2021 16:09:49 +0000.
> > Anything received after that time might be too late.
> 
> Our test CI monitored the 5.4.102-rc2, and compile failure:
> 
> kernel/rcu/tree.c:617:2: error: implicit declaration of function
> ‘IRQ_WORK_INIT’; did you mean ‘IRQ_WORK_BUSY’?
> [-Werror=implicit-function-declaration]
>   IRQ_WORK_INIT(late_wakeup_func);
>   ^~~~~~~~~~~~~
>   IRQ_WORK_BUSY
> kernel/rcu/tree.c:617:2: error: invalid initializer
> 
> Should be commit e1e41aa31ed1 (rcu/nocb: Trigger self-IPI on late
> deferred wake up before user resume) fails the build.

Odd, what arch/configuration causes this?

> By the way, do you expect us test the 5.4.102-rc1 or the
> 5.4.102-rc2 in your tree?

-rc2 would be great, given that it fixes a number of reported issues
with -rc1.

thanks,

greg k-h
