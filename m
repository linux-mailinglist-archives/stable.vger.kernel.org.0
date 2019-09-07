Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B90AAC982
	for <lists+stable@lfdr.de>; Sat,  7 Sep 2019 23:44:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393100AbfIGVoB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Sep 2019 17:44:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:41936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727500AbfIGVoA (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Sep 2019 17:44:00 -0400
Received: from localhost (unknown [40.117.208.15])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C52A21835;
        Sat,  7 Sep 2019 21:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567892639;
        bh=tG6ibY3bwu8/lbK5I8xYgA8C7LOlZHhpePhd9yGxnSk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=0b710CxyMis2Ymk7bxOSvBOm6F0nX8Vbst/RMfumcEMe6gzPsfUnisN2Iha6/bD4m
         HSyUvjtTMCNU1WNJw1OXyrb9/t2iLRshU0hAahnWfZzR5ZWoXl998uXXpq5SnXhq/x
         t2Ao76fTgVm9YJbO5ROFanEzUi4V4hZHCGrMZtAE=
Date:   Sat, 07 Sep 2019 21:43:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Christian Lamparter <chunkeey@gmail.com>
To:     linux-wireless@vger.kernel.org, ath10k@lists.infradead.org
Cc:     Kalle Valo <kvalo@codeaurora.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ath10k: restore QCA9880-AR1A (v1) detection
In-Reply-To: <20190906215423.23589-1-chunkeey@gmail.com>
References: <20190906215423.23589-1-chunkeey@gmail.com>
Message-Id: <20190907214359.1C52A21835@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 1a7fecb766c8 ath10k: reset chip before reading chip_id in probe.

The bot has tested the following trees: v5.2.13, v4.19.71, v4.14.142, v4.9.191, v4.4.191.

v5.2.13: Failed to apply! Possible dependencies:
    6d084ac27ab4 ("ath10k: initialise struct ath10k_bus params to zero")

v4.19.71: Failed to apply! Possible dependencies:
    31324d17976e ("ath10k: support extended board data download for dual-band QCA9984")
    5849ed48d226 ("ath10k: refactoring needed for extended board data download")
    6d084ac27ab4 ("ath10k: initialise struct ath10k_bus params to zero")
    7c2dd6154fc2 ("ath10k: add device type enum to ath10k_bus_params")
    ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
    c0d8d565787c ("ath10k: add struct ath10k_bus_params")
    de8781d7e74d ("ath10k: disable interface pause wow config for integrated chipset")
    f1908735f141 ("ath10k: allow ATH10K_SNOC with COMPILE_TEST")

v4.14.142: Failed to apply! Possible dependencies:
    0fa4fbe9b8cf ("ath10k: add hif power-up/power-down methods")
    17f5559e0da5 ("ath10k: platform driver for WCN3990 SNOC WLAN module")
    2a1e1ad3fd37 ("ath10k: Add support for 64 bit ce descriptor")
    50c51f394e68 ("ath10k: do not mix spaces and tabs in Kconfig")
    5dac5f3772f6 ("ath10k: Use dma_addr_t for ce buffers to support 64bit target")
    6d084ac27ab4 ("ath10k: initialise struct ath10k_bus params to zero")
    7f9befbb555d ("ath10k: move pktlog_filter out of ath10k_debug")
    84efe7f6ebc5 ("ath10k: map HTC services to tx/rx pipes for wcn3990")
    a0aedd6e0b57 ("ath10k: build ce layer in ath10k core module")
    a6a793f98786 ("ath10k: vote for hardware resources for WCN3990")
    a6e149a9ff03 ("ath10k: add hif start/stop methods for wcn3990 snoc layer")
    ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
    c0d8d565787c ("ath10k: add struct ath10k_bus_params")
    c963a683e701 ("ath10k: add resource init and deinit for WCN3990")
    d390509bdf50 ("ath10k: add hif tx methods for wcn3990")
    dafa42036012 ("ath10k: use 64-bit crash dump timestamps")
    e2fcf60c6fe8 ("ath10k: detach coredump.c from debug.c")
    f1908735f141 ("ath10k: allow ATH10K_SNOC with COMPILE_TEST")
    f25b9f285a0e ("ath10k: refactor firmware crashdump code to coredump.c")

v4.9.191: Failed to apply! Possible dependencies:
    0fa4fbe9b8cf ("ath10k: add hif power-up/power-down methods")
    17f5559e0da5 ("ath10k: platform driver for WCN3990 SNOC WLAN module")
    4db66499df91 ("ath10k: add initial USB support")
    50c51f394e68 ("ath10k: do not mix spaces and tabs in Kconfig")
    5524ddd4c1f1 ("ath10k: select WANT_DEV_COREDUMP")
    6d084ac27ab4 ("ath10k: initialise struct ath10k_bus params to zero")
    84efe7f6ebc5 ("ath10k: map HTC services to tx/rx pipes for wcn3990")
    a0aedd6e0b57 ("ath10k: build ce layer in ath10k core module")
    a6a793f98786 ("ath10k: vote for hardware resources for WCN3990")
    a6e149a9ff03 ("ath10k: add hif start/stop methods for wcn3990 snoc layer")
    ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")
    c0d8d565787c ("ath10k: add struct ath10k_bus_params")
    c963a683e701 ("ath10k: add resource init and deinit for WCN3990")
    cec17c382140 ("ath10k: add per peer htt tx stats support for 10.4")
    d390509bdf50 ("ath10k: add hif tx methods for wcn3990")
    d96db25d2025 ("ath10k: add initial SDIO support")
    f1908735f141 ("ath10k: allow ATH10K_SNOC with COMPILE_TEST")

v4.4.191: Failed to apply! Possible dependencies:
    0b523ced9a3c ("ath10k: add basic skeleton to support ahb")
    0d87c9208a17 ("ath10k: expose hif ops for ahb")
    133df0f849bc ("ath10k: add chip and bus halt logic in ahb")
    14854bfd9daa ("ath10k: add reset ctrl related functions in ahb")
    1c44fcb9234c ("ath10k: include irq related functions in ahb")
    4ddb3299aa49 ("ath10k: make ath10k_pci_read32/write32() ops more generic")
    6d084ac27ab4 ("ath10k: initialise struct ath10k_bus params to zero")
    704dc4e36769 ("ath10k: add resource init and deinit in ahb")
    7f8e79cdc253 ("ath10k: add helper functions in ahb.c for reg rd/wr")
    8beff219c528 ("ath10k: add clock ctrl related functions in ahb")
    f52f517189de ("ath10k: make some of ath10k_pci_* func reusable")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
