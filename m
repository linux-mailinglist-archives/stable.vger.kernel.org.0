Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9810932F93D
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 10:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhCFJzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 04:55:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:42604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230303AbhCFJz0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 6 Mar 2021 04:55:26 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3EA765025;
        Sat,  6 Mar 2021 09:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615024525;
        bh=nAW87PL9WYwlyXEbLrb/CHnw8p6hW7I12G7vshmaDZo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UFd1Jq1vgV9tU/RfTXKyD48JQAFlIFn+q0hNqZ33xxl1pOdBZJ7u8W8yu8VfnVTAM
         bHvEgRojHJnM8OIgLDwp3ZUFpoi6yFmUpklCb6URkEvJqvwsEXivgBGCTGWQxBXLn4
         rwPfSh0G25JkGFRCql49btZy+/GYz2cmc6+GigaM=
Date:   Sat, 6 Mar 2021 10:55:22 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/72] 5.4.103-rc1 review
Message-ID: <YENRioOC4RWvApuZ@kroah.com>
References: <20210305120857.341630346@linuxfoundation.org>
 <2604d5be-cf84-01d3-76cd-8b5983445d35@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2604d5be-cf84-01d3-76cd-8b5983445d35@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 06, 2021 at 08:57:00AM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/5 20:21, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.4.103 release.
> > There are 72 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.103-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Our test CI monitored the 5.4.103-rc1, and compile failure on arm64 and x86:
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.4.y
> Arch: arm64/x86
> Version:
> Commit: 2e10dba9fe0e67740146f3b3be42ed9403a7636e
> Compiler: gcc version 7.3.0 (GCC)
> 
> --------------------------------------------------------------------
> 
> Kernel build failed, error log:
> kernel/rcu/tree.c:617:2: error: implicit declaration of function
> ‘IRQ_WORK_INIT’; did you mean ‘IRQ_WORK_BUSY’?
> [-Werror=implicit-function-declaration]
>   IRQ_WORK_INIT(late_wakeup_func);
>   ^~~~~~~~~~~~~
>   IRQ_WORK_BUSY
> kernel/rcu/tree.c:617:2: error: invalid initializer

Thanks for the report, will go fix this up...

greg k-h
