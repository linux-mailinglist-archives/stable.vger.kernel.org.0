Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E92ED24AA3D
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 01:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgHSX53 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 19:57:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:54368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgHSX47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 19:56:59 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E94820FC3;
        Wed, 19 Aug 2020 23:56:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881419;
        bh=95865ixrYC1v6ZjX0Pjv06mJR5GvBzZXg7ZLlGo0yXA=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=elK8Yczd/rlfQZufDXDKhrAYIUJ8NwMdqR91FSkIJxkknj/4OvXQyY9HNYT+8yvq1
         H855kFDgHLmHDvBOxVnINhCkMkCQXAfyeZC8xqRhEYPdQLyZ49JC0J9f7W8uzMsUPN
         D38AVRhAvqS49d5E2gizwdlOSJbSsN6xGGmj95Es=
Date:   Wed, 19 Aug 2020 23:56:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sowjanya Komatineni <skomatineni@nvidia.com>
To:     <adrian.hunter@intel.com>, <ulf.hansson@linaro.org>
CC:     <skomatineni@nvidia.com>, <linux-tegra@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 6/6] sdhci: tegra: Add missing TMCLK for data timeout
In-Reply-To: <1596673949-1571-7-git-send-email-skomatineni@nvidia.com>
References: <1596673949-1571-7-git-send-email-skomatineni@nvidia.com>
Message-Id: <20200819235659.1E94820FC3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: b5a84ecf025a ("mmc: tegra: Add Tegra210 support").

The bot has tested the following trees: v5.8.1, v5.7.15, v5.4.58, v4.19.139, v4.14.193, v4.9.232.

v5.8.1: Build OK!
v5.7.15: Build OK!
v5.4.58: Build OK!
v4.19.139: Build OK!
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
