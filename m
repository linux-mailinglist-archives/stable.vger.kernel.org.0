Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63CC52E6342
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405805AbgL1PkU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:40:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:49122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405863AbgL1Ns1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25E99205CB;
        Mon, 28 Dec 2020 13:48:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163291;
        bh=mX2TkD6zpHLPFDP1hQhcaLT5edWDLw7gHBo+aZKePFU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gmuIbJWWsozsU7qm5f9SoCX7VSTfdk6/KBLYs0KQZnhve2DIp8BwOmlJs5Fzj7cpv
         3I2KqA6WZGDpgfeLRY6BY/GY1X0O5JQRPJZMj2s2tzOC9u2JnsOmAH50jY/DiFQKLe
         J0HRzAYwJUdjEena78qsjRhlJ9RT1cECnXRodIIs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 234/453] cpufreq: scpi: Add missing MODULE_ALIAS
Date:   Mon, 28 Dec 2020 13:47:50 +0100
Message-Id: <20201228124948.479913218@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
index 2b51e0718c9f6..b341ffbf56bc3 100644
--- a/drivers/cpufreq/scpi-cpufreq.c
+++ b/drivers/cpufreq/scpi-cpufreq.c
@@ -239,6 +239,7 @@ static struct platform_driver scpi_cpufreq_platdrv = {
 };
 module_platform_driver(scpi_cpufreq_platdrv);
 
+MODULE_ALIAS("platform:scpi-cpufreq");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("ARM SCPI CPUFreq interface driver");
 MODULE_LICENSE("GPL v2");
-- 
2.27.0



