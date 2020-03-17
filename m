Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47858189173
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 23:30:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727228AbgCQWa1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 18:30:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgCQWaX (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 18:30:23 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B1A420738;
        Tue, 17 Mar 2020 22:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584484222;
        bh=2/6olAvWkYOYPZIWvP9yYOujhWczid99pdbzyci6984=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=e/UAP+AWJjgFc8vzTJjQTV3DjCt2O7Pak49b+VarZurP7d+oxzDv2rfpj2HBAMae2
         i13FasJ363DUXuSH5QyiBycy8m37IXKfjgScu1CGLVFW2RD1RVEkGrkSO5HALsA4ch
         zIarqTvlQUIQPmJ5nqKFJZmc5ZzgeAK/TToB0fUQ=
Date:   Tue, 17 Mar 2020 22:30:21 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc:     Florian Weimer <fw@deneb.enyo.de>
Cc:     Peter Maydell <peter.maydell@linaro.org>
Cc:     Andy Lutomirski <luto@kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ext4: Give 32bit personalities 32bit hashes
In-Reply-To: <20200317113153.7945-1-linus.walleij@linaro.org>
References: <20200317113153.7945-1-linus.walleij@linaro.org>
Message-Id: <20200317223022.9B1A420738@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.9, v5.4.25, v4.19.109, v4.14.173, v4.9.216, v4.4.216.

v5.5.9: Build OK!
v5.4.25: Build OK!
v4.19.109: Failed to apply! Possible dependencies:
    592ddec7578a ("ext4: use IS_ENCRYPTED() to check encryption status")
    b886ee3e778e ("ext4: Support case-insensitive file name lookups")

v4.14.173: Failed to apply! Possible dependencies:
    2ee6a576be56 ("fs, fscrypt: add an S_ENCRYPTED inode flag")
    69fe2d75dd91 ("btrfs: make the delalloc block rsv per inode")
    79f015f21653 ("btrfs: cleanup extent locking sequence")
    8b62f87bad9c ("Btrfs: rework outstanding_extents")
    ae5e165d855d ("fs: new API for handling inode->i_version")
    b886ee3e778e ("ext4: Support case-insensitive file name lookups")
    ee73f9a52a34 ("ext4: convert to new i_version API")

v4.9.216: Failed to apply! Possible dependencies:
    39bc88e5e38e ("arm64: Disable TTBR0_EL1 during normal kernel execution")
    5e9d0e3d9ea6 ("powerpc/lib: Fix randconfig build failure in sstep.c")
    783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
    7c0f6ba682b9 ("Replace <asm/uaccess.h> with <linux/uaccess.h> globally")
    9cf09d68b89a ("arm64: xen: Enable user access before a privcmd hvc call")
    b886ee3e778e ("ext4: Support case-insensitive file name lookups")
    bd38967d406f ("arm64: Factor out PAN enabling/disabling into separate uaccess_* macros")
    ee73f9a52a34 ("ext4: convert to new i_version API")

v4.4.216: Failed to apply! Possible dependencies:
    39bc88e5e38e ("arm64: Disable TTBR0_EL1 during normal kernel execution")
    4dffbfc48d65 ("arm64/efi: mark UEFI reserved regions as MEMBLOCK_NOMAP")
    57f4959bad0a ("arm64: kernel: Add support for User Access Override")
    6c94f27ac847 ("arm64: switch to relative exception tables")
    783d94854499 ("ext4: add EXT4_IOC_GOINGDOWN ioctl")
    7c0f6ba682b9 ("Replace <asm/uaccess.h> with <linux/uaccess.h> globally")
    7dd01aef0557 ("arm64: trap userspace "dc cvau" cache operation on errata-affected core")
    9b7365fc1c82 ("ext4: add FS_IOC_FSSETXATTR/FS_IOC_FSGETXATTR interface support")
    9e8e865bbe29 ("arm64: unify idmap removal")
    b886ee3e778e ("ext4: Support case-insensitive file name lookups")
    d5370f754875 ("arm64: prefetch: add alternative pattern for CPUs without a prefetcher")
    e5bc22a42e4d ("arm64/efi: split off EFI init and runtime code for reuse by 32-bit ARM")
    e7227d0e528f ("arm64: Cleanup SCTLR flags")
    ee73f9a52a34 ("ext4: convert to new i_version API")
    f7d924894265 ("arm64/efi: refactor EFI init and runtime code for reuse by 32-bit ARM")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
