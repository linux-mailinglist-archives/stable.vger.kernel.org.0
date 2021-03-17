Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C085F33E50D
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 02:03:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhCQBA2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 21:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232068AbhCQA62 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:58:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E77CF64FB5;
        Wed, 17 Mar 2021 00:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942699;
        bh=xqcx6d71Un00AaqJTis7UNPrbtDRn8FQVFgouZYa7lU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Emi9Q65kwI+s5Gew7rqkWhwFXFi88x7eWctDvdciF2oxHxK5W+jZqjNI7XyR6j1b7
         oCQP5KPtu+1DR768v4wZe852CknJ9dFQLQrGdnT+wX9NVEsBXAyNPQ2SYcqhtQuXvz
         M13GZhzcecCM+Jsi27fUzlRpCxbhqudKjKdV9NReSxlGX1j5IrliSl7QvjMnJIE2Kd
         Us4DXTtNsFnH6up9wt3XZ0ES16ej3ovh+9PoMDCs9BYoF5PaywD2P9lMZAXyrvmSXV
         8pm31sxcx95vKL9b5qhXDRBbW3Q+z/7RSqCMRP5m9UBre5VA10XpgR9cMwKxurqiLv
         CUMMNGFEYVwww==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 13/37] cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev
Date:   Tue, 16 Mar 2021 20:57:38 -0400
Message-Id: <20210317005802.725825-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005802.725825-1-sashal@kernel.org>
References: <20210317005802.725825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sudeep Holla <sudeep.holla@arm.com>

[ Upstream commit fbb31cb805fd3574d3be7defc06a7fd2fd9af7d2 ]

Add "arm,vexpress" to cpufreq-dt-platdev blacklist since the actual
scaling is handled by the firmware cpufreq drivers(scpi, scmi and
vexpress-spc).

Signed-off-by: Sudeep Holla <sudeep.holla@arm.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq-dt-platdev.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/cpufreq/cpufreq-dt-platdev.c b/drivers/cpufreq/cpufreq-dt-platdev.c
index bca8d1f47fd2..1200842c3da4 100644
--- a/drivers/cpufreq/cpufreq-dt-platdev.c
+++ b/drivers/cpufreq/cpufreq-dt-platdev.c
@@ -103,6 +103,8 @@ static const struct of_device_id whitelist[] __initconst = {
 static const struct of_device_id blacklist[] __initconst = {
 	{ .compatible = "allwinner,sun50i-h6", },
 
+	{ .compatible = "arm,vexpress", },
+
 	{ .compatible = "calxeda,highbank", },
 	{ .compatible = "calxeda,ecx-2000", },
 
-- 
2.30.1

