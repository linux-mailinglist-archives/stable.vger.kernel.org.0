Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855442E60E6
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405865AbgL1Nsf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:48:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405902AbgL1Nsd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:48:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 248A522AAA;
        Mon, 28 Dec 2020 13:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163267;
        bh=USMpCL9bNvMHIeZ3KURxV+/tP3/hVUWvPmJp/zlBXZ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UYuuLozvjpYJ7P/dq40/xjOZ4Vo0ksUv3hTnunuU84QKSvpgqPwfnEAd1bYMV1V21
         BZ1tEXYgh1oruPt1YztCs4Lv4uvx8HQ6WdhJungE2wkoMGY9TM5Y9yWAZpheNtUwJi
         1OlKovotO0HxA7kKOOj+MlrPLX0Hx838Cpp61HnQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 227/453] cpufreq: ap806: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:47:43 +0100
Message-Id: <20201228124948.144819703@linuxfoundation.org>
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

[ Upstream commit 925a5bcefe105f2790ecbdc252eb2315573f309d ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: f525a670533d9 ("cpufreq: ap806: add cpufreq driver for Armada 8K")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/armada-8k-cpufreq.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/cpufreq/armada-8k-cpufreq.c b/drivers/cpufreq/armada-8k-cpufreq.c
index 39e34f5066d3d..b0fc5e84f8570 100644
--- a/drivers/cpufreq/armada-8k-cpufreq.c
+++ b/drivers/cpufreq/armada-8k-cpufreq.c
@@ -204,6 +204,12 @@ static void __exit armada_8k_cpufreq_exit(void)
 }
 module_exit(armada_8k_cpufreq_exit);
 
+static const struct of_device_id __maybe_unused armada_8k_cpufreq_of_match[] = {
+	{ .compatible = "marvell,ap806-cpu-clock" },
+	{ },
+};
+MODULE_DEVICE_TABLE(of, armada_8k_cpufreq_of_match);
+
 MODULE_AUTHOR("Gregory Clement <gregory.clement@bootlin.com>");
 MODULE_DESCRIPTION("Armada 8K cpufreq driver");
 MODULE_LICENSE("GPL");
-- 
2.27.0



