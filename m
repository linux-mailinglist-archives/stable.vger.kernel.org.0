Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D28892E40D7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440486AbgL1OOq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:48914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440480AbgL1OOp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C7593207B2;
        Mon, 28 Dec 2020 14:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164870;
        bh=hKI9+bMyMnTnOxTtRK3FN9x3PmaDyT2Z2WXACaEfjuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QgFqKgnsP+bXP4BoJC9j6JL8Lg6AERg14v0Q+5rbIY+5RqukSfNY2bmtw4C4eg7Cl
         GtZAfFoXGFe6KeDJ8tMIAMPURpZypAm8lSN8oBLNt+HtRwJqhdBMK9yhNiPCl7dqTV
         yC3Mj1OUnZn3Qfltp9ny+Lr4hOjwtGFtXfeEbh2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Yangtao Li <tiny.windzz@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 328/717] cpufreq: sun50i: Add missing MODULE_DEVICE_TABLE
Date:   Mon, 28 Dec 2020 13:45:26 +0100
Message-Id: <20201228125036.735330673@linuxfoundation.org>
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

[ Upstream commit af2096f285077e3339eb835ad06c50bdd59f01b5 ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this cpufreq driver when it is
compiled as an external module.

Signed-off-by: Pali Rohár <pali@kernel.org>
Fixes: f328584f7bff8 ("cpufreq: Add sun50i nvmem based CPU scaling driver")
Reviewed-by: Yangtao Li <tiny.windzz@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/sun50i-cpufreq-nvmem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/cpufreq/sun50i-cpufreq-nvmem.c b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
index 9907a165135b7..2deed8d8773fa 100644
--- a/drivers/cpufreq/sun50i-cpufreq-nvmem.c
+++ b/drivers/cpufreq/sun50i-cpufreq-nvmem.c
@@ -167,6 +167,7 @@ static const struct of_device_id sun50i_cpufreq_match_list[] = {
 	{ .compatible = "allwinner,sun50i-h6" },
 	{}
 };
+MODULE_DEVICE_TABLE(of, sun50i_cpufreq_match_list);
 
 static const struct of_device_id *sun50i_cpufreq_match_node(void)
 {
-- 
2.27.0



