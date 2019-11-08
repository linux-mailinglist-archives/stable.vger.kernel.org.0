Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 793B4F4B35
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 13:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732332AbfKHMON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 07:14:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:51146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731980AbfKHLiN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 06:38:13 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CACC021D7F;
        Fri,  8 Nov 2019 11:38:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573213093;
        bh=OVrIbVCAkUxIXhK+atxs9e/hAi56a9ksTK9A2USy0Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sALhzTJQ1hqYKvxLEoacg5QWDtM0M5sMYau2AiyzEJBwJ7LhTPg4LXFhQoNG8x+1s
         2bfI5pv0FkYMrnqw8uO6B/965+kHf2P8OGydfXiZ/P8XiI2BfcZyqqAVMmE7DmSK/c
         YGXUjoroY9KDuhuYptEn3Mb8z3XXFS8C81e7PlNc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Sasha Levin <sashal@kernel.org>, rtc-linux@googlegroups.com
Subject: [PATCH AUTOSEL 4.19 018/205] rtc: rv8803: fix the rv8803 id in the OF table
Date:   Fri,  8 Nov 2019 06:34:45 -0500
Message-Id: <20191108113752.12502-18-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191108113752.12502-1-sashal@kernel.org>
References: <20191108113752.12502-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit c856618d20662695fcdb47bf4d560dc457662aec ]

The ID for RV8803 must be rv_8803

Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-rv8803.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-rv8803.c b/drivers/rtc/rtc-rv8803.c
index 29fc3d2103923..17ccef5d5db1a 100644
--- a/drivers/rtc/rtc-rv8803.c
+++ b/drivers/rtc/rtc-rv8803.c
@@ -623,7 +623,7 @@ MODULE_DEVICE_TABLE(i2c, rv8803_id);
 static const struct of_device_id rv8803_of_match[] = {
 	{
 		.compatible = "microcrystal,rv8803",
-		.data = (void *)rx_8900
+		.data = (void *)rv_8803
 	},
 	{
 		.compatible = "epson,rx8900",
-- 
2.20.1

