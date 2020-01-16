Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3733213F93F
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:24:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729609AbgAPTXv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 14:23:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730624AbgAPQxB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:53:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B604205F4;
        Thu, 16 Jan 2020 16:53:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193581;
        bh=2Q9Q4pExj05WwTW9qKCbxEahwlpn9K6XUKlq3Krbhz4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jy9EBFGRrhYu8/kKJr8+WfZ0VLKTfkmWPVW1gUR+lmlwYTib90l33Gm32P6yMK5Ol
         nb8CH1EK5DHtJ3vYsZgSxxnA9ymlaN6mP8lFM+Ixm+n3vkyFprYfVIZEu2ID3ltGsY
         fVcXDz5SIxbo5/PFuymxXbpbC5BU7zcF2gZrLBJQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jonas Karlman <jonas@kwiboo.se>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 123/205] media: cedrus: Use correct H264 8x8 scaling list
Date:   Thu, 16 Jan 2020 11:41:38 -0500
Message-Id: <20200116164300.6705-123-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonas Karlman <jonas@kwiboo.se>

[ Upstream commit a6b8feae7c88343212686120740cf7551dd16e08 ]

Documentation now defines the expected order of scaling lists,
change to use correct indices.

Fixes: 6eb9b758e307 ("media: cedrus: Add H264 decoding support")
Signed-off-by: Jonas Karlman <jonas@kwiboo.se>
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/sunxi/cedrus/cedrus_h264.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
index 08c6c9c410cc..c07526c12629 100644
--- a/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
+++ b/drivers/staging/media/sunxi/cedrus/cedrus_h264.c
@@ -244,8 +244,8 @@ static void cedrus_write_scaling_lists(struct cedrus_ctx *ctx,
 			       sizeof(scaling->scaling_list_8x8[0]));
 
 	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_8x8_1,
-			       scaling->scaling_list_8x8[3],
-			       sizeof(scaling->scaling_list_8x8[3]));
+			       scaling->scaling_list_8x8[1],
+			       sizeof(scaling->scaling_list_8x8[1]));
 
 	cedrus_h264_write_sram(dev, CEDRUS_SRAM_H264_SCALING_LIST_4x4,
 			       scaling->scaling_list_4x4,
-- 
2.20.1

