Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0147A3C904A
	for <lists+stable@lfdr.de>; Wed, 14 Jul 2021 22:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241272AbhGNTyP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Jul 2021 15:54:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241112AbhGNTuX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Jul 2021 15:50:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5F347613C3;
        Wed, 14 Jul 2021 19:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626292010;
        bh=qvM0yYNL8q3J19oHR2x8OxnAyfO7cTAeFwbNUv4zl3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWJF3nKe58HLNnfFyEazIvzNJSoV+A1DSESFgwpB+V6VxQuNTVBWxdoI1SspFz9p3
         t1y6WaM9Vc7vyBRdF1JrTlp4X8Lw4SpgzZpI0gyEIx4aBUCdGgxh/bilFZQrMgY4ko
         fTKJj5s9lmI/blDXcVlrOblBHIBtDBsbSGQBUl+DMWIgnzotffE6REGR03psVUtC12
         RKBd5jSiEjZAS6hDYiDJDUVTady3Pd+lakEPqcBXN01AFdqDtxWBOZCkwwFjh0dCWh
         qfwznz4g4X8jqUOjZ1YWLtQ7B4U+ATpSMtr9kSxWOTQhYm88jBs8XYXrdmCJfSvfxd
         OrJNuBTRsZEQA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bixuan Cui <cuibixuan@huawei.com>, Hulk Robot <hulkci@huawei.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, linux-rtc@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 18/39] rtc: mxc_v2: add missing MODULE_DEVICE_TABLE
Date:   Wed, 14 Jul 2021 15:46:03 -0400
Message-Id: <20210714194625.55303-18-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210714194625.55303-1-sashal@kernel.org>
References: <20210714194625.55303-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 206e04ec7539e7bfdde9aa79a7cde656c9eb308e ]

This patch adds missing MODULE_DEVICE_TABLE definition which generates
correct modalias for automatic loading of this driver when it is built
as an external module.

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Link: https://lore.kernel.org/r/20210508031509.53735-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-mxc_v2.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/rtc/rtc-mxc_v2.c b/drivers/rtc/rtc-mxc_v2.c
index 007879a5042d..45c7366b7286 100644
--- a/drivers/rtc/rtc-mxc_v2.c
+++ b/drivers/rtc/rtc-mxc_v2.c
@@ -395,6 +395,7 @@ static const struct of_device_id mxc_ids[] = {
 	{ .compatible = "fsl,imx53-rtc", },
 	{}
 };
+MODULE_DEVICE_TABLE(of, mxc_ids);
 
 static struct platform_driver mxc_rtc_driver = {
 	.driver = {
-- 
2.30.2

