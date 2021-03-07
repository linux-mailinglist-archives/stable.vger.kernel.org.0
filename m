Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 715EB330069
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 12:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230286AbhCGLjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 06:39:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:32786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230155AbhCGLio (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 06:38:44 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 816FA64FCC;
        Sun,  7 Mar 2021 11:38:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615117124;
        bh=52A57wW6aRnAHSI/SU6mwLqt3+p/2rCLskgNvcPy+EY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cf+HO/62w2zBXeudmYjSzMqny7rhJCLylFIY9ItW0KlruboGHoQSQCFx1byKqpstV
         A0qbLctNE7trW3GuwjTg8GZRlXp3GHkh7DkfHjDBQLvoiJisS7W5k5/DpYJvASw3SH
         oncB8825T9YLddPc/bT1poP8sKWMTyNN5e718dFU=
Date:   Sun, 7 Mar 2021 12:38:42 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/102] 5.10.21-rc1 review
Message-ID: <YES7QrvKHWPKOo9W@kroah.com>
References: <20210305120903.276489876@linuxfoundation.org>
 <8d4fbde6-b004-2874-af2d-a10f20be4993@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8d4fbde6-b004-2874-af2d-a10f20be4993@huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 06, 2021 at 02:25:44PM +0800, Samuel Zou wrote:
> 
> 
> On 2021/3/5 20:20, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.21 release.
> > There are 102 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.21-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Our test CI monitored the 5.10.21-rc1, and compile failure on arm64:
> 
> Kernel repo:
> https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Arch: arm64/x86
> Version: 5.10.21-rc1+
> Commit: 80aaabbaf433294d1f075981fa3785d7f4b55159
> Compiler: gcc version 7.3.0 (GCC)
> 
> 
> arm64 (compile failure)
> --------------------------------------------------------------------
> Kernel build failed, error log:
> kernel/rcu/tree.c:683:2: error: implicit declaration of function
> ‘IRQ_WORK_INIT’; did you mean ‘QSTR_INIT’?
> [-Werror=implicit-function-declaration]
>   IRQ_WORK_INIT(late_wakeup_func);
>   ^~~~~~~~~~~~~
>   QSTR_INIT
> kernel/rcu/tree.c:683:2: error: invalid initializer
> 
> 
> x86 (No kernel failures)
> --------------------------------------------------------------------
> Testcase Result Summary:
> total_num: 4716
> succeed_num: 4714
> failed_num: 2
> timeout_num: 0
> 
> Tested-by: Hulk Robot <hulkci@huawei.com>

Thanks for testing and letting me know.

greg k-h
