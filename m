Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126C234C7D9
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232983AbhC2ISV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:18:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:58584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233279AbhC2IRY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:17:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 356466197F;
        Mon, 29 Mar 2021 08:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617005829;
        bh=+eUHutKYIktr+Eq43papny8RGVP67Auq//PQTZkp4f4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WS3yb2EMwP1Q+XSqf32a1lJiTov6cHWHSZL25W18yUGjFOCl7JitoDzqe3NeoJ4cC
         bJ7Ouq9QKBUiIW50pIvJvuQzf4VFaKDsEs72OEfB7BuECxrgt0e9LOI8ONW19DTb2H
         4QYBnLw2GmZWcTqVgeoEP6FDCdWUrB3xmEWYYKRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sudeep Holla <sudeep.holla@arm.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/221] cpufreq: blacklist Arm Vexpress platforms in cpufreq-dt-platdev
Date:   Mon, 29 Mar 2021 09:55:51 +0200
Message-Id: <20210329075629.857898399@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



