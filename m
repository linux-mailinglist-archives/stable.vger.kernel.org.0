Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3A82A27244F
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727017AbgIUMyz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgIUMyy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:54 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 150CA21789;
        Mon, 21 Sep 2020 12:54:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692894;
        bh=uswhDTH8q04YI2FBF6oV00o3tKMvoXaueN/nwuvYk3s=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=VhHsncJEQ86Y9rdMX+RCIokO18CQXtkJFkuR3tG7Kkb7YsV8DTiwNpEoQaSYPoaEH
         jBDgBvV34ybU6NxAal8gux8TnEzPGWAjW2pC8X10Q399MIsxGSaHUAgRu/sS82XH8/
         gkJs+ALj88BGa1acwv8rIpOIw2IhFFC5Tdr8nthc=
Date:   Mon, 21 Sep 2020 12:54:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 3/9] ARM: oabi-compat: add epoll_pwait handler
In-Reply-To: <20200918124624.1469673-4-arnd@arndb.de>
References: <20200918124624.1469673-4-arnd@arndb.de>
Message-Id: <20200921125454.150CA21789@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 369842658a36 ("ARM: 5677/1: ARM support for TIF_RESTORE_SIGMASK/pselect6/ppoll/epoll_pwait").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Build OK!
v4.9.236: Failed to apply! Possible dependencies:
    00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
    17435e5f8cf3 ("time: Introduce CONFIG_COMPAT_32BIT_TIME")
    338035edc9b9 ("arm: Wire up restartable sequences system call")
    4e2648db9c5f ("ARM: remove indirection of asm/mach-types.h")
    73aeb2cbcdc9 ("ARM: 8787/1: wire up io_pgetevents syscall")
    78594b95998f ("ARM: add migrate_pages() system call")
    96a8fae0fe09 ("ARM: convert to generated system call tables")
    a1016e94cce9 ("ARM: wire up statx syscall")
    c281634c8652 ("ARM: compat: remove KERNEL_DS usage in sys_oabi_epoll_ctl()")
    d4703ddafd1e ("time: Introduce CONFIG_64BIT_TIME in architectures")

v4.4.236: Failed to apply! Possible dependencies:
    00bf25d693e7 ("y2038: use time32 syscall names on 32-bit")
    03590cb56d5d ("ARM: wire up copy_file_range() syscall")
    0d4a619b64ba ("dma-mapping: make the generic coherent dma mmap implementation optional")
    17435e5f8cf3 ("time: Introduce CONFIG_COMPAT_32BIT_TIME")
    4e2648db9c5f ("ARM: remove indirection of asm/mach-types.h")
    96a8fae0fe09 ("ARM: convert to generated system call tables")
    c281634c8652 ("ARM: compat: remove KERNEL_DS usage in sys_oabi_epoll_ctl()")
    d4703ddafd1e ("time: Introduce CONFIG_64BIT_TIME in architectures")
    f2335a2a0a59 ("ARM: wire up preadv2 and pwritev2 syscalls")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
