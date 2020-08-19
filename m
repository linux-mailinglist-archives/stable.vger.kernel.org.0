Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A8E24AA41
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgHSX5e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726957AbgHSX4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:55 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4B7C21775;
        Wed, 19 Aug 2020 23:56:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881414;
        bh=h/HiWAywJlSa5mSBR+HYgDRJ7rEjeDW2Fcu6W4zTkdk=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=MaKDaSBNPUVyEFdTIIdy20QRLlcazr/etKxW5uaGo5/konCpd7NgRxCqr1K/r9aOL
         C/VFTMlN2i5kvsX8ZwRq1eFfyzXXDcpCTefQgqsi2FBcNMmWJ8stAbEXnGgXSTO/mb
         sNlS6G/EiLyv8t6vaV88ByCXd3Nm1dhXLIIMvXmI=
Date:   Wed, 19 Aug 2020 23:56:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 4/6] arm64: tegra: Add missing timeout clock to Tegra186 SDMMC nodes
In-Reply-To: <1596673949-1571-5-git-send-email-skomatineni@nvidia.com>
References: <1596673949-1571-5-git-send-email-skomatineni@nvidia.com>
Message-Id: <20200819235653.D4B7C21775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 39cb62cb8973 ("arm64: tegra: Add Tegra186 support").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193.

v5.8.1: Build OK!
v5.7.15: Build OK!
v5.4.58: Build OK!
v4.19.139: Failed to apply! Possible dependencies:
    05705c721591 ("arm64: tegra: Enable SMMU for XUSB host on Tegra186")
    06c6b06f8908 ("arm64: tegra: Make XUSB node consistent with the rest")
    24005fd1b3b4 ("arm64: dts: Add Tegra186 sdmmc pinctrl voltage states")
    29ef1f4dacb5 ("arm64: tegra: Enable SMMU for VIC on Tegra186")
    31af04cd60d3 ("arm64: dts: Remove inconsistent use of 'arm,armv8' compatible string")
    3f6eaef9ab37 ("arm64: tegra: Add external memory controller on Tegra186")
    41408c215ab7 ("arm64: dts: tegra186: Add sdmmc pad auto calibration offsets")
    5298166d47a6 ("arm64: tegra: Add CPU cache topology for Tegra186")
    541d7c44069b ("arm64: tegra: Sort device tree nodes alphabetically")
    5d2249dda08e ("arm64: tegra: Add ACONNECT, ADMA and AGIC nodes")
    6f90c6f0db83 ("arm64: dts: tegra186: Add SDHCI tap and trim values")
    8589a649d5f9 ("arm64: dts: tegra186: Enable IOMMU for SDHCI")
    8bfde5183e98 ("arm64: tegra: Add XUSB and pad controller on Tegra186")
    954490b30cb4 ("arm64: tegra: Describe interconnect paths on Tegra186")
    98a2494f847c ("arm64: dts: tegra186: Assign clocks for sdmmc1 and sdmmc4")
    9c8c52f7cb4f ("arm64: dts: meson-g12a: add initial g12a s905d2 SoC DT support")
    b066a31040b7 ("arm64: tegra: Add HDA controller on Tegra186")
    b72d52a1b60b ("arm64: tegra: Add interrupt for memory controller on Tegra186")
    dfdbf16c50d8 ("arm64: tegra: Fix insecure SMMU users for Tegra186")
    f2a465e7185f ("arm64: tegra: Enable SMMU translation for PCI on Tegra186")

v4.14.193: Failed to apply! Possible dependencies:
    15274c232131 ("arm64: tegra: Add BPMP thermal sensor to Tegra186")
    24005fd1b3b4 ("arm64: dts: Add Tegra186 sdmmc pinctrl voltage states")
    3f6eaef9ab37 ("arm64: tegra: Add external memory controller on Tegra186")
    41408c215ab7 ("arm64: dts: tegra186: Add sdmmc pad auto calibration offsets")
    5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
    5d2249dda08e ("arm64: tegra: Add ACONNECT, ADMA and AGIC nodes")
    6f90c6f0db83 ("arm64: dts: tegra186: Add SDHCI tap and trim values")
    85593b75ee71 ("arm64: tegra: Add FUSE block on Tegra186")
    8589a649d5f9 ("arm64: dts: tegra186: Enable IOMMU for SDHCI")
    954490b30cb4 ("arm64: tegra: Describe interconnect paths on Tegra186")
    98a2494f847c ("arm64: dts: tegra186: Assign clocks for sdmmc1 and sdmmc4")
    b066a31040b7 ("arm64: tegra: Add HDA controller on Tegra186")
    b72d52a1b60b ("arm64: tegra: Add interrupt for memory controller on Tegra186")
    b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0000 board")
    d25a3bf11fc9 ("arm64: tegra: Add memory controller on Tegra186")
    dfdbf16c50d8 ("arm64: tegra: Fix insecure SMMU users for Tegra186")
    f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
    f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
