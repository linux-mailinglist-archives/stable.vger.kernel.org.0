Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16A2427244D
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727012AbgIUMyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727009AbgIUMyw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:52 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32E0E21D7A;
        Mon, 21 Sep 2020 12:54:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692892;
        bh=fxZsZ0yO4kvbV8sxqbzkWyHlk5R9/YttlJa1PJCl+9Q=;
        h=Date:From:To:To:To:Cc:CC:Cc:Subject:In-Reply-To:References:From;
        b=0gz+15C6uE9Cni3bTj6HBmpSL44Kd6LtFtjXpr44V/+bsLrhKgqTDNa8QXo1BvSLY
         jKoO7CQp5PI9ynwOy++1itK5ecTfZSKtNpChXk6Asum8dUAUFMDSvVjFwyeCEyHSic
         TOJWAeJn8bF+GjmQ9kCxtpb4TUaoTzn5iMYNU/OY=
Date:   Mon, 21 Sep 2020 12:54:51 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tony Ambardar <tony.ambardar@gmail.com>
To:     Michael Ellerman <mpe@ellerman.id.au>
Cc:     Tony Ambardar <Tony.Ambardar@gmail.com>
CC:     Stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] powerpc: fix EDEADLOCK redefinition error in uapi/asm/errno.h
In-Reply-To: <20200917135437.1238787-1-Tony.Ambardar@gmail.com>
References: <20200917135437.1238787-1-Tony.Ambardar@gmail.com>
Message-Id: <20200921125452.32E0E21D7A@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Failed to apply! Possible dependencies:
    7af7919f0f4b ("tools include s390: Grab a copy of arch/s390/include/uapi/asm/unistd.h")
    95f28190aa01 ("tools include arch: Grab a copy of errno.h for arch's supported by perf")
    a3f22d505f56 ("s390/perf: add callback to perf to enable using AUX buffer")
    a81c42136604 ("perf s390: add regs_query_register_offset()")
    a9fc2db0a8ab ("s390/perf: define common DWARF register string table")
    f704ef44602f ("s390/perf: add support for perf_regs and libdw")

v4.9.236: Failed to apply! Possible dependencies:
    0c744ea4f77d ("Linux 4.10-rc2")
    2bd6bf03f4c1 ("Linux 4.14-rc1")
    2ea659a9ef48 ("Linux 4.12-rc1")
    49def1853334 ("Linux 4.10-rc4")
    566cf877a1fc ("Linux 4.10-rc6")
    5771a8c08880 ("Linux v4.13-rc1")
    7089db84e356 ("Linux 4.10-rc8")
    7a308bb3016f ("Linux 4.10-rc5")
    7af7919f0f4b ("tools include s390: Grab a copy of arch/s390/include/uapi/asm/unistd.h")
    7ce7d89f4883 ("Linux 4.10-rc1")
    95f28190aa01 ("tools include arch: Grab a copy of errno.h for arch's supported by perf")
    a121103c9228 ("Linux 4.10-rc3")
    a81c42136604 ("perf s390: add regs_query_register_offset()")
    a9fc2db0a8ab ("s390/perf: define common DWARF register string table")
    b24413180f56 ("License cleanup: add SPDX GPL-2.0 license identifier to files with no license")
    c1ae3cfa0e89 ("Linux 4.11-rc1")
    c470abd4fde4 ("Linux 4.10")
    d5adbfcd5f7b ("Linux 4.10-rc7")

v4.4.236: Failed to apply! Possible dependencies:
    0c4d40d58075 ("tools build: Add BPF feature check to test-all")
    1925459b4d92 ("tools build: Fix feature Makefile issues with 'O='")
    58683600dfe3 ("perf build: Use FEATURE-DUMP in bpf subproject")
    76ee2ff34274 ("tools build feature: Move dwarf post unwind choice output into perf")
    7af7919f0f4b ("tools include s390: Grab a copy of arch/s390/include/uapi/asm/unistd.h")
    8ee4646038e4 ("perf build: Add libcrypto feature detection")
    95f28190aa01 ("tools include arch: Grab a copy of errno.h for arch's supported by perf")
    96b9e70b8e6c ("perf build: Introduce FEATURES_DUMP make variable")
    9fd4186ac19a ("tools build: Allow subprojects select all feature checkers")
    abb26210a395 ("perf tools: Force fixdep compilation at the start of the build")
    aeafd623f866 ("perf tools: Move headers check into bash script")
    c053a1506fae ("perf build: Select all feature checkers for feature-dump")
    d4dfdf00d43e ("perf jvmti: Plug compilation into perf build")
    d58ac0bf8d1e ("perf build: Add clang and llvm compile and linking support")
    d8ad6a15cc3a ("tools lib bpf: Don't do a feature check when cleaning")
    e12b202f8fb9 ("perf jitdump: Build only on supported archs")
    e26e63be64a1 ("perf build: Add sdt feature detection")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
