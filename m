Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C155200FE8
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392716AbgFSPXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:23:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393184AbgFSPXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:23:30 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E44282158C;
        Fri, 19 Jun 2020 15:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580209;
        bh=Sl/PYpXNg++EVQUk+AQqR0ej8vbmve0/ub7u9lPRBMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vBKLiG/sJpdRokNCEcX0NWQUojNRIbWMfiKw70xao10KAi/kIqbtpPSm+xHhK1wzm
         u7Y3nuxztWIRXdPVNdClA1uVWkZIPbkcxyexWKJM1raq2qqlxx6VrkVEVZBpwo+2J8
         VRoi75AdMxDxjNmsALaz6FPe9KSS6yDWlhCul12o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ansuel Smith <ansuelsmth@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 146/376] cpufreq: qcom: fix wrong compatible binding
Date:   Fri, 19 Jun 2020 16:31:04 +0200
Message-Id: <20200619141717.242087123@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ansuel Smith <ansuelsmth@gmail.com>

[ Upstream commit 2dea651680cea1f3a29925de51002f33d1f55711 ]

Binding in Documentation is still "operating-points-v2-kryo-cpu".
Restore the old binding to fix the compatibility problem.

Fixes: a8811ec764f9 ("cpufreq: qcom: Add support for krait based socs")
Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/qcom-cpufreq-nvmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/cpufreq/qcom-cpufreq-nvmem.c b/drivers/cpufreq/qcom-cpufreq-nvmem.c
index a1b8238872a2..d06b37822c3d 100644
--- a/drivers/cpufreq/qcom-cpufreq-nvmem.c
+++ b/drivers/cpufreq/qcom-cpufreq-nvmem.c
@@ -277,7 +277,7 @@ static int qcom_cpufreq_probe(struct platform_device *pdev)
 	if (!np)
 		return -ENOENT;
 
-	ret = of_device_is_compatible(np, "operating-points-v2-qcom-cpu");
+	ret = of_device_is_compatible(np, "operating-points-v2-kryo-cpu");
 	if (!ret) {
 		of_node_put(np);
 		return -ENOENT;
-- 
2.25.1



