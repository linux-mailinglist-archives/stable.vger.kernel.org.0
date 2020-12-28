Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E59D62E6287
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405994AbgL1Nsw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:50340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405981AbgL1Nst (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 54CFC22B37;
        Mon, 28 Dec 2020 13:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163288;
        bh=251wZNfZEHhyW3NJI7VYHBDf9tk7fIR2Vdj+RrpCtu0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mEHxdDWguOX6f+I8wxaCf4cRrECeIFrufztTkuf6Mjhr89tuIggi8cvYDr7KasDeW
         g0stFK9t23lETheMZNBiSZUmP/xoS4f18RkLUd74VdMv8Wgu+mdny/9ArWOn40LKKy
         n9j7AoVc7uhxCr2Z1OjZlwz/OYNfLbUdfTO59K6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 233/453] cpufreq: loongson1: Add missing MODULE_ALIAS
Date:   Mon, 28 Dec 2020 13:47:49 +0100
Message-Id: <20201228124948.432255932@linuxfoundation.org>
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

[ Upstream commit b9acab091842ca8b288882798bb809f7abf5408a ]

This patch adds missing MODULE_ALIAS for automatic loading of this cpufreq
driver when it is compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: a0a22cf14472f ("cpufreq: Loongson1: Add cpufreq driver for Loongson1B")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/loongson1-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/loongson1-cpufreq.c b/drivers/cpufreq/loongson1-cpufreq.c
index 0ea88778882ac..86f612593e497 100644
--- a/drivers/cpufreq/loongson1-cpufreq.c
+++ b/drivers/cpufreq/loongson1-cpufreq.c
@@ -216,6 +216,7 @@ static struct platform_driver ls1x_cpufreq_platdrv = {
 
 module_platform_driver(ls1x_cpufreq_platdrv);
 
+MODULE_ALIAS("platform:ls1x-cpufreq");
 MODULE_AUTHOR("Kelvin Cheung <keguang.zhang@gmail.com>");
 MODULE_DESCRIPTION("Loongson1 CPUFreq driver");
 MODULE_LICENSE("GPL");
-- 
2.27.0



