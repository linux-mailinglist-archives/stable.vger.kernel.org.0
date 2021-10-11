Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1901A428CA0
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 14:08:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236477AbhJKMKE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 08:10:04 -0400
Received: from gandalf.ozlabs.org ([150.107.74.76]:47573 "EHLO
        gandalf.ozlabs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236440AbhJKMKB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 08:10:01 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4HScxq0KxHz4xqd;
        Mon, 11 Oct 2021 23:07:59 +1100 (AEDT)
From:   Michael Ellerman <patch-notifications@ellerman.id.au>
To:     paul.gortmaker@windriver.com, linuxppc-dev@lists.ozlabs.org,
        mpe@ellerman.id.au, Xiaoming Ni <nixiaoming@huawei.com>,
        stable@vger.kernel.org, oss@buserror.net, benh@kernel.crashing.org,
        chenhui.zhao@freescale.com, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, paulus@samba.org,
        Yuantian.Tang@feescale.com
Cc:     liuwenliang@huawei.com, chenjianguo3@huawei.com, wangle6@huawei.com
In-Reply-To: <20210929033646.39630-1-nixiaoming@huawei.com>
References: <021a5ee3-25ef-1de4-0111-d4c3281e0f45@huawei.com> <20210929033646.39630-1-nixiaoming@huawei.com>
Subject: Re: [PATCH v2 0/2] powerpc:85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n
Message-Id: <163395399480.4094789.15095321874781475669.b4-ty@ellerman.id.au>
Date:   Mon, 11 Oct 2021 23:06:34 +1100
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 29 Sep 2021 11:36:44 +0800, Xiaoming Ni wrote:
> When CONFIG_SMP=y, timebase synchronization is required for mpc8572 when
>  the second kernel is started
> 	arch/powerpc/kernel/smp.c:
> 	int __cpu_up(unsigned int cpu, struct task_struct *tidle)
> 	{
> 		...
> 		if (smp_ops->give_timebase)
> 			smp_ops->give_timebase();
> 		...
> 	}
> 
> [...]

Applied to powerpc/next.

[1/2] powerpc:85xx:Fix oops when mpc85xx_smp_guts_ids node cannot be found
      https://git.kernel.org/powerpc/c/3c2172c1c47b4079c29f0e6637d764a99355ebcd
[2/2] powerpc:85xx: fix timebase sync issue when CONFIG_HOTPLUG_CPU=n
      https://git.kernel.org/powerpc/c/c45361abb9185b1e172bd75eff51ad5f601ccae4

cheers
