Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4922E3D63
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440562AbgL1OPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:49938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440560AbgL1OPC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B74C20731;
        Mon, 28 Dec 2020 14:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164862;
        bh=7uDYTVtXnM1WvFOoz4TG/EcHoYyud/ONQRl0prtLKrU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p7i0+eb4Z7Y19kvSUYeAfMFevNgxGGktzLNMe7JpX5eIn2Y5PgrAsXSFQUA8SNgI+
         K6DV5Vito1wK2f0pbKHtJyUqCgbTh+O1denug4dSd1bsUjn4eSF0BDY7/4f7t/EO9q
         p+COpFu8MJS7p/fQUqVRVsrl0t/F0ZTNEnah89ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 326/717] cpufreq: qcom: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:45:24 +0100
Message-Id: <20201228125036.638181993@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit a5a6031663bc1dd0a10babd49d1bcb3153a8327f ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 46e2856b8e188 ("cpufreq: Add Kryo CPU scaling driver")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index d06b37822c3df..fba9937a406b3 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -464,6 +464,7 @@ static const struct of_device_id qcom_cpufreq_match_list[] __initconst = {
 	{ .compatible = "qcom,msm8960", .data = &match_data_krait },
 	{},
 };
+MODULE_DEVICE_TABLE(of, qcom_cpufreq_match_list);
 
 /*
  * Since the driver depends on smem and nvmem drivers, which may
-- 
2.27.0



