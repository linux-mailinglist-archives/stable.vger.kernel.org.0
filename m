Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F111C7E14
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728267AbgEFXmU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:56374 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbgEFXmS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:18 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E11D2082E;
        Wed,  6 May 2020 23:42:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808538;
        bh=pIDuvi7hZHDoRNZ0lRKDUEFjk1MXxuMGhXIA0Wo68U0=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=JjaTHdC38uOJSHNE+tyA3DGXHGYw8YtnJE7wrxtrumD5ACDtLSulvVzYjzomSDBxO
         aP32xzZrFMXUy7TaAxJaH4lBhlgcIlx48ARCdmbmdvlq6SvmdqKU9KRSXVaqPdWRhy
         OlRlh4aWw2ii38zyaXhHBTJpQgzjn8x2BuoRfjBw=
Date:   Wed, 06 May 2020 23:42:17 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Jon Hunter <jonathanh@nvidia.com>
To:     Thierry Reding <thierry.reding@gmail.com>
CC:     <devicetree@vger.kernel.org>, <linux-tegra@vger.kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] arm64: tegra: Fix ethernet phy-mode for Jetson Xavier
In-Reply-To: <20200501072756.25348-1-jonathanh@nvidia.com>
References: <20200501072756.25348-1-jonathanh@nvidia.com>
Message-Id: <20200506234218.4E11D2082E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.8, v5.4.36, v4.19.119, v4.14.177, v4.9.220, v4.4.220.

v5.6.8: Build OK!
v5.4.36: Build OK!
v4.19.119: Build OK!
v4.14.177: Failed to apply! Possible dependencies:
    5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
    b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0000 board")
    f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
    f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")

v4.9.220: Failed to apply! Possible dependencies:
    5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
    99575bceebd6 ("arm64: tegra: Add NVIDIA P2771 board support")
    b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0000 board")
    f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
    f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")

v4.4.220: Failed to apply! Possible dependencies:
    0f279ebdf3ce ("arm64: tegra: Add NVIDIA Tegra132 Norrin support")
    2cc85bd90337 ("arm64: tegra: Add NVIDIA P2571 board support")
    34b4f6d0599e ("arm64: tegra: Add Tegra132 support")
    5425fb15d8ee ("arm64: tegra: Add Tegra194 chip device tree")
    5d17ba6e638e ("arm64: tegra: Add support for Google Pixel C")
    63023e95bec0 ("arm64: tegra: Add NVIDIA P2371 board support")
    99575bceebd6 ("arm64: tegra: Add NVIDIA P2771 board support")
    b8656c673a6b ("arm64: tegra: Add device tree for the Tegra194 P2972-0000 board")
    f69ce393ec48 ("arm64: tegra: Add GPIO controller on Tegra194")
    f89b58ce71a9 ("arm64: tegra: Add ethernet controller on Tegra194")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
