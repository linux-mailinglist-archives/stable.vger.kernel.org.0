Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF48533E353
	for <lists+stable@lfdr.de>; Wed, 17 Mar 2021 01:57:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhCQA4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Mar 2021 20:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:33048 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230055AbhCQA4A (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Mar 2021 20:56:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D192164F99;
        Wed, 17 Mar 2021 00:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615942560;
        bh=sPQZ5s9ecY6bsqQ2F4HSHnT6X4JoUINd/+vhwy11Tkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O5J8fL7M6D754STCoTBkLh7L/VPFmOpZd5YzKEBlmjXlip7zk8JfEW0l+6A+Fz99k
         ZliiOQNmHZu48lg4trK7bMkEDdt/pFpdRPRweZO7OxI8i6/tCQth1QvO+OS6gP0uC+
         Zx76k9gQpEO91slMakgsU2b/fc7BFxskhIiageQEDTjYJ+yoVi8KCzf29DspYmXIkl
         wNB8ffCp1OFF1hXk+w8w7hnWFtcDt9eVKwlTlPvKs02PVMB9y90SfylfKrurcyJHGA
         Og1DeQxCA2mvuMVLDcfMsf3M23hImI80VFpjIxqVy7B+zaRkSSaqofrlhbkKAN7Nz9
         91rZqZuiiGY7Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 19/61] cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev
Date:   Tue, 16 Mar 2021 20:54:53 -0400
Message-Id: <20210317005536.724046-19-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210317005536.724046-1-sashal@kernel.org>
References: <20210317005536.724046-1-sashal@kernel.org>
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
index bd2db0188cbb..91e6a0c10dbf 100644
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

