Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3409533B0B3
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 12:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbhCOLKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 07:10:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:45810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229828AbhCOLKT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 07:10:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7427964E83;
        Mon, 15 Mar 2021 11:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615806619;
        bh=m+a/jMM5qLgG2kScM3LE9WutzLlbyEyqAQ+LLAVfxUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U+S5oVGQCgrQwLCC3o9g+wAPhpqJRVN7hjnnzpgkQCH4KPldnBQX4bSm8P+awD6hU
         cewpNZ/Dpyr/sQmuXSvB/KngEVPJ6+aC8Z1deZ9NseE2VIg7wydD25N1veQAOdA5UO
         qweLh8QCOir8xkLMvJiqaLse8oy6JCL1AIUu8jIw=
Date:   Mon, 15 Mar 2021 12:10:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     hulkrobot@huawei.com
Cc:     stable@vger.kernel.org
Subject: Re: [linux-stable-rc CI] Test report for 5.10.24-rc1/x86
Message-ID: <YE9AmC1IccBTomxo@kroah.com>
References: <c2371fc0-2f0f-4fd0-b4a3-c3a04a09a25a@DGGEMS405-HUB.china.huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c2371fc0-2f0f-4fd0-b4a3-c3a04a09a25a@DGGEMS405-HUB.china.huawei.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 15, 2021 at 06:44:43PM +0800, hulkrobot@huawei.com wrote:
> Kernel repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> Branch: linux-5.10.y
> Arch: x86
> Version: 5.10.24-rc1
> Commit: 5b0ddd114df102f34c83b8cd4ce4a03397ab7aa9
> Compiler: gcc version 7.3.0 (GCC)
> --------------------------------------------------------------------
> Kernel build failed, error log:
> arch/x86/kernel/sev-es.c:1275:14: error: implicit declaration of function ‘irqentry_nmi_enter’; did you mean ‘irqentry_enter’? [-Werror=implicit-function-declaration]
>   irq_state = irqentry_nmi_enter(regs);
>               ^~~~~~~~~~~~~~~~~~
>               irqentry_enter
> arch/x86/kernel/sev-es.c:1275:12: error: incompatible types when assigning to type ‘irqentry_state_t {aka struct irqentry_state}’ from type ‘int’
>   irq_state = irqentry_nmi_enter(regs);
>             ^
> arch/x86/kernel/sev-es.c:1339:2: error: implicit declaration of function ‘irqentry_nmi_exit’; did you mean ‘irqentry_exit’? [-Werror=implicit-function-declaration]
>   irqentry_nmi_exit(regs, irq_state);
>   ^~~~~~~~~~~~~~~~~
>   irqentry_exit
> cc1: some warnings being treated as errors
> make[2]: *** [scripts/Makefile.build:279: arch/x86/kernel/sev-es.o] Error 1
> make[2]: *** Waiting for unfinished jobs....

I do not see irqentry_nmi_enter() in this tree at all, where did that
come from?

> --
> mm/page_alloc.c:3275:2: error: implicit declaration of function ‘split_page_memcg’; did you mean ‘split_page_owner’? [-Werror=implicit-function-declaration]
>   split_page_memcg(page, 1 << order);
>   ^~~~~~~~~~~~~~~~
>   split_page_owner

This is now fixed.

thanks,

greg k-h
