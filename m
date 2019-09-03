Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B00EA6FAE
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730031AbfICQeT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 12:34:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:49802 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbfICQ2G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Sep 2019 12:28:06 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D81123431;
        Tue,  3 Sep 2019 16:28:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567528085;
        bh=Q3J76ibsb9b/yijBhYCVKKVj1TBh9pMTt7rn8oqua04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL0dcpD8nQAk6jixd3PbLBcF4L43SFHqaIncT5CP1oQ8Eem8HnJwfOmDLEL6Jsqmd
         1a2QuW+yZYNUBGogeGdC5fE7CfHiETdTT+Uu2njyVAQ9DwaiF8LpwIvKi5yKr40ngY
         UMKruQ0+pT8N8r0Xsw4CY32LDSXMDONVz+f5FQtQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Koen Vandeputte <koen.vandeputte@ncentric.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 096/167] media: i2c: tda1997x: select V4L2_FWNODE
Date:   Tue,  3 Sep 2019 12:24:08 -0400
Message-Id: <20190903162519.7136-96-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190903162519.7136-1-sashal@kernel.org>
References: <20190903162519.7136-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Koen Vandeputte <koen.vandeputte@ncentric.com>

[ Upstream commit 5f2efda71c09b12012053f457fac7692f268b72c ]

Building tda1997x fails now unless V4L2_FWNODE is selected:

drivers/media/i2c/tda1997x.o: in function `tda1997x_parse_dt'
undefined reference to `v4l2_fwnode_endpoint_parse'

While at it, also sort the selections alphabetically

Fixes: 9ac0038db9a7 ("media: i2c: Add TDA1997x HDMI receiver driver")

Signed-off-by: Koen Vandeputte <koen.vandeputte@ncentric.com>
Cc: stable@vger.kernel.org # v4.17+
Acked-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 63c9ac2c6a5ff..8b1ae1d6680b7 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -60,8 +60,9 @@ config VIDEO_TDA1997X
 	tristate "NXP TDA1997x HDMI receiver"
 	depends on VIDEO_V4L2 && I2C && VIDEO_V4L2_SUBDEV_API
 	depends on SND_SOC
-	select SND_PCM
 	select HDMI
+	select SND_PCM
+	select V4L2_FWNODE
 	---help---
 	  V4L2 subdevice driver for the NXP TDA1997x HDMI receivers.
 
-- 
2.20.1

