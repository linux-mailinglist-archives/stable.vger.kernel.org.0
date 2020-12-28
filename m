Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C07C02E6575
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390257AbgL1NaD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:30:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:58864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390249AbgL1NaC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:30:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B922C2072C;
        Mon, 28 Dec 2020 13:29:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162162;
        bh=k5RTE5SuaIMdDo6xyKA23v9Nr8Y6BhKBS/cDvULcEcA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GT6qbtcVE2QKuHf9Nxa4ygfr95y8mbUk7+tvwL7PgjVDyXr6YNXe7hrJLlMl7JGTb
         wJn0O4GwdrK9a6wkP9lqZ5zQblElSmrpCSbujyKCs89sU1UoAqXzttKHPibsGplEA6
         3uM3lW/7rqP/V4nuYg2njly3KOnbr3xi5EDDvSJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 208/346] cpufreq: scpi: Add missing MODULE_ALIAS
Date:   Mon, 28 Dec 2020 13:48:47 +0100
Message-Id: <20201228124929.849436692@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit c0382d049d2def37b81e907a8b22661a4a4a6eb5 ]

This patch adds missing MODULE_ALIAS for automatic loading of this cpufreq
driver when it is compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 8def31034d033 ("cpufreq: arm_big_little: add SCPI interface driver")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/scpi-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/scpi-cpufreq.c b/drivers/cpufreq/scpi-cpufreq.c
index 87a98ec77773a..0338885332a75 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -246,6 +246,7 @@ static struct platform_driver scpi_cpufreq_platdrv = {
 };
 module_platform_driver(scpi_cpufreq_platdrv);
 
+MODULE_ALIAS("platform:scpi-cpufreq");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCPI CPUFreq interface driver");
 MODULE_LICENSE("GPL v2");
-- 
2.27.0



