Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C25E933E3D8
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230408AbhCQA5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:57:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:35252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231536AbhCQA5S (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:57:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15F2A64F9B;
        Wed, 17 Mar 2021 00:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942637;
        bh=+eUHutKYIktr+Eq43papny8RGVP67Auq//PQTZkp4f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DOy1ZeH01NBn8kqS0pTQ047doG/1cSjdfqzvtySzi0sMENoWrIWvCNHaP7dfsitK7
         ToSHOIU4e6nGDMjRvszThByIrH+MpoO0Jpfv8mG46HBk3fPKSVpX1la9Dx3cIH5Hll
         YJNeh0QWJFCszrojFCXWedBu130LN+pw+LXjcZ7FWyaB6jpd1JlSbbPQcdIDO6r8UE
         asmpBFdPahWb9vLo7aRD7wOFOkILU6RQyYF0Z3I7dbeyEki8CH5h5RXUTdMbjfRHEs
         Jw2JovDbV/dYi+k1FsXCbII0SiPLter6xAy+hlL6MVogli8arSU5ZDmvIvSFfPwrGY
         L1YdPK+xJN7Yg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 18/54] cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev
Date:   Tue, 16 Mar 2021 20:56:17 -0400
Message-Id: <20210317005654.724862-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005654.724862-1-sashal@kernel.org>
References: <20210317005654.724862-1-sashal@kernel.org>
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
index 3776d960f405..1c192a42f11e 100644
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

