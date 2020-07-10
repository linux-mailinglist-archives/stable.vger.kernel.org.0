Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9EC121B7AD
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:03:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbgGJODI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:03:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbgGJODG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:03:06 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7CA06207DF;
        Fri, 10 Jul 2020 14:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389785;
        bh=pdbPkm8l563fG65KOonKINs2vxMtCsXAAOeQm6PC/F0=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=werET4HNCbsdj4zSD4QvW4xdd9ui8vL3FeNl4Zzatt1kqZmJSsodQ0yPRxPXnPvMz
         Xwl7nOf8ZYzOZPDLrHUGN7O/r/aDEims2Wq2UuLnhNrNmrivYy/aOUF3VER1Q/Rxmq
         W9sFCGTUxDnFh/Oohnx/6BvnOWiZMGSLds1/Tqq8=
Date:   Fri, 10 Jul 2020 14:03:04 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Danny Lin <danny@kdrag0n.dev>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     Nathan Chancellor <natechancellor@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] vmlinux.lds.h: Coalesce transient LLVM dead code elimination sections
In-Reply-To: <20200702232713.123893-1-danny@kdrag0n.dev>
References: <20200702232713.123893-1-danny@kdrag0n.dev>
Message-Id: <20200710140305.7CA06207DF@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.7.7, v5.4.50, v4.19.131, v4.14.187, v4.9.229, v4.4.229.

v5.7.7: Build OK!
v5.4.50: Build OK!
v4.19.131: Build OK!
v4.14.187: Failed to apply! Possible dependencies:
    266ff2a8f51f0 ("kbuild: Fix asm-generic/vmlinux.lds.h for LD_DEAD_CODE_DATA_ELIMINATION")
    4bebdc7a85aa4 ("bpf: add helper bpf_perf_prog_read_value")
    52c8ee5bad8f3 ("vmlinux.lds.h: Fix linker warnings about orphan .LPBX sections")
    540adea3809f6 ("error-injection: Separate error-injection from kprobe")
    663faf9f7beea ("error-injection: Add injectable error types")
    908432ca84fc2 ("bpf: add helper bpf_perf_event_read_value for perf event array map")
    97562633bcbac ("bpf: perf event change needed for subsequent bpf helpers")
    9802d86585db9 ("bpf: add a bpf_override_function helper")
    a621438500533 ("vmlinux.lds.h: remove no-op macro VMLINUX_SYMBOL()")
    cd86d1fd21025 ("bpf: Adding helper function bpf_getsockops")
    dd0bb688eaa24 ("bpf: add a bpf_override_function helper")
    de8f3a83b0a0f ("bpf: add meta pointer for direct access")
    f3edacbd697f9 ("bpf: Revert bpf_overrid_function() helper changes.")

v4.9.229: Failed to apply! Possible dependencies:
    17bedab272314 ("bpf: xdp: Allow head adjustment in XDP prog")
    1a1d74d378b13 ("nfp: use AND instead of modulo to get ring indexes")
    23a4e389bdc71 ("nfp: create separate define for max number of vectors")
    266ff2a8f51f0 ("kbuild: Fix asm-generic/vmlinux.lds.h for LD_DEAD_CODE_DATA_ELIMINATION")
    416db5c1e4488 ("nfp: remove support for nfp3200")
    4b89b7f7aad57 ("kbuild: keep data tables through dead code elimination")
    52c8ee5bad8f3 ("vmlinux.lds.h: Fix linker warnings about orphan .LPBX sections")
    540adea3809f6 ("error-injection: Separate error-injection from kprobe")
    663faf9f7beea ("error-injection: Add injectable error types")
    67f8b1dcb9ee7 ("net/mlx4_en: Refactor the XDP forwarding rings scheme")
    68453c7a89733 ("nfp: centralize runtime reconfiguration logic")
    7ff5c83a1deb0 ("nfp: simplify nfp_net_poll()")
    9802d86585db9 ("bpf: add a bpf_override_function helper")
    a4b562bb8ebd4 ("nfp: use unsigned int for vector/ring counts")
    a621438500533 ("vmlinux.lds.h: remove no-op macro VMLINUX_SYMBOL()")
    bf187ea01b077 ("nfp: centralize the buffer size calculation")
    cbeaf7aa733a1 ("nfp: bring back support for different ring counts")
    ccc109b8ed24c ("net/mlx4_en: Add TX_XDP for CQ types")
    dd0bb688eaa24 ("bpf: add a bpf_override_function helper")
    e390b55d5aefe ("bpf: make bpf_xdp_adjust_head support mandatory")
    ecd63a0217d5f ("nfp: add XDP support in the driver")
    f3edacbd697f9 ("bpf: Revert bpf_overrid_function() helper changes.")

v4.4.229: Failed to apply! Possible dependencies:
    0f4c4af06eec5 ("kbuild: -ffunction-sections fix for archs with conflicting sections")
    266ff2a8f51f0 ("kbuild: Fix asm-generic/vmlinux.lds.h for LD_DEAD_CODE_DATA_ELIMINATION")
    52c8ee5bad8f3 ("vmlinux.lds.h: Fix linker warnings about orphan .LPBX sections")
    a5967db9af51a ("kbuild: allow architectures to use thin archives instead of ld -r")
    b67067f1176df ("kbuild: allow archs to select link dead code/data elimination")
    cb87481ee89db ("kbuild: linker script do not match C names unless LD_DEAD_CODE_DATA_ELIMINATION is configured")
    f235541699bcf ("export.h: allow for per-symbol configurable EXPORT_SYMBOL()")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
