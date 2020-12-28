Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A5E02E40C8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:58:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440628AbgL1OPU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:50292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440622AbgL1OPT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:15:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 35DCB229C6;
        Mon, 28 Dec 2020 14:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164878;
        bh=vTA5h6oKF1d251ZPjrjKg4RMStRyzVxm1d6P755RUH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j7ijHy6MUjLRFD94oMk2zpEPygOXs8/F+Yzu/WpAG6/TLiBRYjqj9Q45Jko0WH2hX
         CyFLKK0kweXl3E4Al06ofytqAodsC/Xvr0qB4iQ9xCyzPAbdDxN5cmVcw5JnDbh8eE
         38Fw404PanoDIoxZW4CG03nx3nW1xk7m1I4k6+v4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 331/717] cpufreq: vexpress-spc: Add missing MODULE_ALIAS
Date:   Mon, 28 Dec 2020 13:45:29 +0100
Message-Id: <20201228125036.880210696@linuxfoundation.org>
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

[ Upstream commit d15183991c2d53d7cecf27a1555c91b702cef1ea ]

This patch adds missing MODULE_ALIAS for automatic loading of this cpufreq
driver when it is compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: 47ac9aa165540 ("cpufreq: arm_big_little: add vexpress SPC interface driver")
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/vexpress-spc-cpufreq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/vexpress-spc-cpufreq.c b/drivers/cpufreq/vexpress-spc-cpufreq.c
index e89b905754d21..f711d8eaea6a2 100644
--- a/drivers/cpufreq/vexpress-spc-cpufreq.c
+++ b/drivers/cpufreq/vexpress-spc-cpufreq.c
@@ -591,6 +591,7 @@ static struct platform_driver ve_spc_cpufreq_platdrv = {
 };
 module_platform_driver(ve_spc_cpufreq_platdrv);
 
+MODULE_ALIAS("platform:vexpress-spc-cpufreq");
 MODULE_AUTHOR("Viresh Kumar <viresh.kumar@linaro.org>");
 MODULE_AUTHOR("Sudeep Holla <sudeep.holla@arm.com>");
 MODULE_DESCRIPTION("Vexpress SPC ARM big LITTLE cpufreq driver");
-- 
2.27.0



