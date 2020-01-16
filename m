Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6801F13F31D
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 19:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390069AbgAPRMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 12:12:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:53884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390367AbgAPRMA (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 12:12:00 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 701BF24697;
        Thu, 16 Jan 2020 17:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579194719;
        bh=0FEKFmNTzNHdWMgpZioN6dASvgMpPIEyyAdbTtRIJwQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bFvan5K5D6NtwOsJeh3BlvQo+yUi5WJqI7cIHhu7bxrmffeYY65vCAGF88I97Dihv
         r+T+TTjOjPM07JXlt8ycb+fJkP+SQLbFwm/ZIQxZVteCZzDWARkprspJ9hyvnDAtLQ
         2AeACDy/ZdWGu2ieWirRciPoSKS//AU6zVF7gPGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>,
        Jassi Brar <jaswinder.singh@linaro.org>,
        Sasha Levin <sashal@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 555/671] mailbox: qcom-apcs: fix max_register value
Date:   Thu, 16 Jan 2020 12:03:13 -0500
Message-Id: <20200116170509.12787-292-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116170509.12787-1-sashal@kernel.org>
References: <20200116170509.12787-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>

[ Upstream commit 556a0964e28c4441dcdd50fb07596fd042246bd5 ]

The mailbox length is 0x1000 hence the max_register value is 0xFFC.

Fixes: c6a8b171ca8e ("mailbox: qcom: Convert APCS IPC driver to use
regmap")
Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez-ortiz@linaro.org>
Signed-off-by: Jassi Brar <jaswinder.singh@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/qcom-apcs-ipc-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/qcom-apcs-ipc-mailbox.c b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
index 5255dcb551a7..d8b4f08f613b 100644
--- a/drivers/mailbox/qcom-apcs-ipc-mailbox.c
+++ b/drivers/mailbox/qcom-apcs-ipc-mailbox.c
@@ -36,7 +36,7 @@ static const struct regmap_config apcs_regmap_config = {
 	.reg_bits = 32,
 	.reg_stride = 4,
 	.val_bits = 32,
-	.max_register = 0x1000,
+	.max_register = 0xFFC,
 	.fast_io = true,
 };
 
-- 
2.20.1

