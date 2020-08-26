Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5015B25309C
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 15:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730574AbgHZNyp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 09:54:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:60822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730489AbgHZNyJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 26 Aug 2020 09:54:09 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E84D22B4E;
        Wed, 26 Aug 2020 13:54:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598450049;
        bh=q4c2G+DMJJG8DxKX2Gu+9oVh8DAzXC5NkRNj06nvtDI=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=QxoE8yhXfOJWl7ejwtwdyJxxpxdUBYcyG6z2YtxdHj0z82RLHWxCDiReLzUjDHayw
         woJAYoGA9qmeqG2/3X2SNK61KHJ2WrctiJK/lwuidDcX+obo6hfC+9d1Uy+rpRxigx
         SdzYGH3lg8B5M5V0Z2326YOmP2tu68pHP//LbMbs=
Date:   Wed, 26 Aug 2020 13:54:08 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 6/6] sdhci: tegra: Add missing TMCLK for data timeout
In-Reply-To: <1596673949-1571-7-git-send-email-skomatineni@nvidia.com>
References: <1596673949-1571-7-git-send-email-skomatineni@nvidia.com>
Message-Id: <20200826135409.3E84D22B4E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: b5a84ecf025a ("mmc: tegra: Add Tegra210 support").

The bot has tested the following trees: v5.8.2, v5.7.16, v5.4.59, v4.19.140, v4.14.193, v4.9.232.

v5.8.2: Build OK!
v5.7.16: Build OK!
v5.4.59: Build OK!
v4.19.140: Build OK!
v4.14.193: Build OK!
v4.9.232: Failed to apply! Possible dependencies:
    20567be9d2e6 ("mmc: tegra: Support module reset")
    4346b7c7941d ("mmc: tegra: Add Tegra186 support")
    86ac2f8bf90a ("mmc: tegra: Reconfigure pad voltages during voltage switching")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
