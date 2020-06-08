Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8031F2FF2
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728426AbgFIAym (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:54:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:55248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728423AbgFHXJb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:09:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F352E208C3;
        Mon,  8 Jun 2020 23:09:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657771;
        bh=Sl/PYpXNg++EVQUk+AQqR0ej8vbmve0/ub7u9lPRBMY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NeELp2pjl36MzAMRdPZaZKHlcTTbpu2DLTvfPnWfEZrRxfB53jd7a75gmj0kXPSwV
         JzVwRlM6M90BJLtUvEnloFpG9Ehv9Ey4ejcQsWEZVzRi+UAvNSss5H5QXLU+WsKHI1
         BHMP6d4s2OTrddoC/lLpGx+YLPRDtbi3x/SMAFTI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ansuel Smith <ansuelsmth@gmail.com>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 155/274] cpufreq: qcom: fix wrong compatible binding
Date:   Mon,  8 Jun 2020 19:04:08 -0400
Message-Id: <20200608230607.3361041-155-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

