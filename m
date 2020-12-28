Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0BA2E3775
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:57:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727758AbgL1Mzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:55:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbgL1Mzn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:55:43 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5AA37208BA;
        Mon, 28 Dec 2020 12:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160102;
        bh=xvxEK+dhAsqyF62rtdJUybRBa9CaZRDIvG8ECLBo2MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+2EhF8GzV0b7bd5ZkfJKFztq2zBPnUlNHeCr3i6S3Z8ytmxURRvH4VIaAAUHCd1n
         WsURoWjhdyDnE1av4LO4/G6eIduiIJc7AiiefnmyyHql/Z5jwchzR9I23A/zIqj82K
         BHbePuUtRsNPTEbjCC4kEE6XRtjgt0TYE6AhK7jA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 070/132] cpufreq: loongson1: Add missing MODULE_ALIAS
Date:   Mon, 28 Dec 2020 13:49:14 +0100
Message-Id: <20201228124849.828882142@linuxfoundation.org>
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

[ Upstream commit b9acab091842ca8b288882798bb809f7abf5408a ]

This patch adds missing MODULE_ALIAS for automatic loading of this cpufreq
driver when it is compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: a0a22cf14472f ("cpufreq: Loongson1: Add cpufreq driver for Loongson1B")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/ls1x-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/ls1x-cpufreq.c b/drivers/cpufreq/ls1x-cpufreq.c
index 262581b3318d7..367cb1615c30d 100644
--- a/drivers/cpufreq/ls1x-cpufreq.c
+++ b/drivers/cpufreq/ls1x-cpufreq.c
@@ -217,6 +217,7 @@ static struct platform_driver ls1x_cpufreq_platdrv = {
 
 module_platform_driver(ls1x_cpufreq_platdrv);
 
+MODULE_ALIAS("platform:ls1x-cpufreq");
 MODULE_AUTHOR("Kelvin Cheung <keguang.zhang@gmail.com>");
 MODULE_DESCRIPTION("Loongson 1 CPUFreq driver");
 MODULE_LICENSE("GPL");
-- 
2.27.0



