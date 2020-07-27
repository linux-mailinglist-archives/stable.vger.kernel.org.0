Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E21C922FB49
	for <lists+stable@lfdr.de>; Mon, 27 Jul 2020 23:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgG0VYk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jul 2020 17:24:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726183AbgG0VYj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jul 2020 17:24:39 -0400
Received: from localhost (unknown [13.85.75.251])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DBDBB20809;
        Mon, 27 Jul 2020 21:24:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595885079;
        bh=knhv49uFCxxfu4kqNb1U/FnB93xWgtry5seDBIv8xy8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=wxjIGBZ4pBONqk1h8LYGjsRtkbJspLhH4xB8YvkW4NnHNsl2OXesJX8dFGTup3q3b
         Qq7Z7Cw7uM/Ygsrb7xuOyyJB4perLAqipcMf7tzJuxhKYUfl+rWDh0xn/5MQebgDD4
         HMh3a7fyoJaiIZvmBuqUswBuX7kJv5uJTl0n+ed4=
Date:   Mon, 27 Jul 2020 21:24:38 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kees Cook <keescook@chromium.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kees Cook <keescook@chromium.org>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 04/19] fs/kernel_read_file: Remove FIRMWARE_PREALLOC_BUFFER enum
In-Reply-To: <20200724213640.389191-5-keescook@chromium.org>
References: <20200724213640.389191-5-keescook@chromium.org>
Message-Id: <20200727212438.DBDBB20809@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: a098ecd2fa7d ("firmware: support loading into a pre-allocated buffer").

The bot has tested the following trees: v5.7.10, v5.4.53, v4.19.134, v4.14.189, v4.9.231.

v5.7.10: Build OK!
v5.4.53: Failed to apply! Possible dependencies:
    85db1cde8253 ("firmware: Rename FW_OPT_NOFALLBACK to FW_OPT_NOFALLBACK_SYSFS")
    901cff7cb961 ("firmware_loader: load files from the mount namespace of init")
    e4c2c0ff00ec ("firmware: Add new platform fallback mechanism and firmware_request_platform()")

v4.19.134: Failed to apply! Possible dependencies:
    5342e7093ff2 ("firmware: Factor out the paged buffer handling code")
    82fd7a8142a1 ("firmware: Add support for loading compressed files")
    8f58570b98c0 ("firmware: Unify the paged buffer release helper")
    901cff7cb961 ("firmware_loader: load files from the mount namespace of init")
    993f5d11a963 ("firmware: Use kvmalloc for page tables")
    ddaf29fd9bb6 ("firmware: Free temporary page table after vmapping")
    eac473bce4b7 ("firmware: hardcode the debug message for -ENOENT")

v4.14.189: Failed to apply! Possible dependencies:
    02c399306826 ("firmware_loader: enhance Kconfig documentation over FW_LOADER")
    06bfd3c8ab1d ("firmware_loader: move kconfig FW_LOADER entries to its own file")
    367d09824193 ("firmware_loader: replace ---help--- with help")
    7f55c733b660 ("firmware: Drop FIRMWARE_IN_KERNEL Kconfig option")
    82fd7a8142a1 ("firmware: Add support for loading compressed files")

v4.9.231: Failed to apply! Possible dependencies:
    0015a978a254 ("s390: fix zfcpdump-config")
    02c399306826 ("firmware_loader: enhance Kconfig documentation over FW_LOADER")
    06bfd3c8ab1d ("firmware_loader: move kconfig FW_LOADER entries to its own file")
    16ddcc34b8bd ("s390: update defconfig")
    1d9995771fcb ("s390: update defconfigs")
    6b0b7551428e ("perf/core: Rename CONFIG_[UK]PROBE_EVENT to CONFIG_[UK]PROBE_EVENTS")
    7f55c733b660 ("firmware: Drop FIRMWARE_IN_KERNEL Kconfig option")
    80abb39b504e ("s390: update defconfig")
    82fd7a8142a1 ("firmware: Add support for loading compressed files")
    a518d63777a4 ("ARC: [plat-hsdk] initial port for HSDK board")
    c7ff87409d1a ("m68k/defconfig: Update defconfigs for v4.10-rc1")
    dafba3f6fb86 ("ARM: tegra: Enable GMI driver in default configuration")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
