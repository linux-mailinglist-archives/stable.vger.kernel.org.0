Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 875C92E6947
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:48:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgL1Qq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:46:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:52204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728614AbgL1Mzq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:55:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C5D5208D5;
        Mon, 28 Dec 2020 12:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160106;
        bh=nse2/lH7GiPM5GDrfQ+M1mb+40BJ4+k+utImoH1uKeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yVsyDXf1QqEKryYPTEWK9FqgZbH9d3bCMkPa2yQZaz3xUBoMSOr9k9V4F+x3GM6Ki
         b9LSnfqyWNMF5Ps+rdb6nx8g6HWSvWtoX1JGLdBionLKERk/NhQdcO6F+c5U71aSZS
         3l68kzGBxGIbZ1iNaryUDECxnVm4i5B5slb0MJpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 071/132] cpufreq: scpi: Add missing MODULE_ALIAS
Date:   Mon, 28 Dec 2020 13:49:15 +0100
Message-Id: <20201228124849.879506496@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
index de5e89b2eaaa3..98f762cca9010 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -119,6 +119,7 @@ static struct platform_driver scpi_cpufreq_platdrv = {
 };
 module_platform_driver(scpi_cpufreq_platdrv);
 
+MODULE_ALIAS("platform:scpi-cpufreq");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCPI CPUFreq interface driver");
 MODULE_LICENSE("GPL v2");
-- 
2.27.0



