Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3338915C980
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 18:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgBMRhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 12:37:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:52360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728549AbgBMRhH (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 Feb 2020 12:37:07 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E2D721734;
        Thu, 13 Feb 2020 17:37:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581615426;
        bh=RNM032s+Hqx7GeiULhfp9Y1V+WuZ090C4Tk0kSL561M=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=SSiGgfrXTgZvWLhBnS0cN08xcZlTyf0C8/m4nj8Nx1xDowdxUliAutmVUOYLFDQBo
         MljRIFDPFdmPWkSH5qySqsOBoxvevKX7Q5KchVnxg90D0FtFXGHCfC3y++N1Cj6x5v
         +xnU0agtlBeHkFMkRKfMCz0q4pYwGpwxiEWxnl5U=
Date:   Thu, 13 Feb 2020 17:37:05 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jani Nikula <jani.nikula@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     jani.nikula@intel.com, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/2] MAINTAINERS: Update drm/i915 bug filing URL
In-Reply-To: <20200212160434.6437-1-jani.nikula@intel.com>
References: <20200212160434.6437-1-jani.nikula@intel.com>
Message-Id: <20200213173706.5E2D721734@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.3, v5.4.19, v4.19.103, v4.14.170, v4.9.213, v4.4.213.

v5.5.3: Build OK!
v5.4.19: Build OK!
v4.19.103: Build OK!
v4.14.170: Build OK!
v4.9.213: Failed to apply! Possible dependencies:
    15accb3cbbcd ("MAINTAINERS: extend mvebu SoC entry with pinctrl drivers")
    1cb0b57fec06 ("MAINTAINERS: add irqchip related drivers to Marvell EBU maintainers")
    20bb5505e96f ("MAINTAINERS: cpufreq: add bmips-cpufreq.c")
    21dd0ece34c2 ("ARM: dts: at91: add devicetree for the Axentia TSE-850")
    2e7d1098c00c ("MAINTAINERS: add entry for dma mapping helpers")
    384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
    3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
    3f0d80b6d228 ("MAINTAINERS: Add bnxt_en maintainer info.")
    413dfbbfca54 ("MAINTAINERS: add entry for Aspeed I2C driver")
    420a3879d694 ("MAINTAINERS: change email address from atmel to microchip")
    51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
    52c468fb37b6 ("MAINTAINERS: oxnas: Add new files definitions")
    70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
    7683e9e52925 ("Properly alphabetize MAINTAINERS file")
    81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
    aa43112445f0 ("ASoC: atmel: tse850: add ASoC driver for the Axentia TSE-850")
    b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
    c821d30148ca ("ASoC: tse850: document axentia,tse850-pcm5142 bindings")
    e7c1572f6565 ("MAINTAINERS: sort F entries for Marvell EBU maintainers")
    fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")

v4.4.213: Failed to apply! Possible dependencies:
    1f664ab7d9d4 ("MAINTAINERS: update entry for Marvell ARM platform maintainers")
    27eb6622ab67 ("config: add android config fragments")
    384fe7a4d732 ("drivers: net: xgene-v2: Add DMA descriptor")
    3b3f9a75d931 ("drivers: net: xgene-v2: Add base driver")
    413dfbbfca54 ("MAINTAINERS: add entry for Aspeed I2C driver")
    51c5d8447bd7 ("MMC: meson: initial support for GX platforms")
    5255034d1701 ("ARM: mach-artpec: add entry to MAINTAINERS")
    54176cc68038 ("maintainers: update rmk's email address(es)")
    5b7551db8688 ("ARM: dts: keystone: Add minimum support for K2G evm")
    5edafc29829b ("ARM: dts: k2*: Rename the k2* files to keystone-k2* files")
    6683d91cde25 ("MAINTAINERS: ARM/Amlogic: add co-maintainer, misc. updates")
    70dbd9b258d5 ("MAINTAINERS: Add entry for APM X-Gene SoC Ethernet (v2) driver")
    7683e9e52925 ("Properly alphabetize MAINTAINERS file")
    79318452cb36 ("MAINTAINERS: Extend info, add wiki and ml for meson arch")
    81ccd0cab29b ("drivers: net: xgene-v2: Add mac configuration")
    8bb0bce92ec9 ("MAINTAINERS: add maintainer and reviewers for the etnaviv DRM driver")
    8c2ed9bcfbeb ("arm: Add Aspeed machine")
    8cb555b603f3 ("MAINTAINERS: add Chanho Min as ARM/LG1K maintainer")
    9f123def55d3 ("cpufreq: mvebu: Move cpufreq code into drivers/cpufreq/")
    b105bcdaaa0e ("drivers: net: xgene-v2: Add transmit and receive")
    dcc3068a757e ("MAINTAINERS: Extend dts entry for ARM64 mvebu files")
    e68d7c143a62 ("MAINTAINERS: Add missing platform maintainers for dts files")
    e7c1572f6565 ("MAINTAINERS: sort F entries for Marvell EBU maintainers")
    fd33f3eca6bf ("MAINTAINERS: Add maintainers for the meson clock driver")
    fd3a628e3f2a ("MAINTAINERS: Add entry for APM X-Gene SoC PMU driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
