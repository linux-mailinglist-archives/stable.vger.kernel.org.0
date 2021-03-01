Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E6E328A47
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239347AbhCASO2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:14:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:59384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239395AbhCASIi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:08:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 414FB65353;
        Mon,  1 Mar 2021 17:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620707;
        bh=63TBHjeSWuvczyyY/giIxjnwHefWxTBUbswcUBa4EyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zPrKD3VV/5WsG7CCRj362ITYj7iuCQZfPvO/mqCgJ+rKDMfogS1jt56WRVousWczJ
         SPgujLQYO+t1XCABIGw59nTSSaMPIJ6oIc9+IsP4OxfGtB3oCuAWJX8UMaovsAmdAJ
         +vK1quRHmronZXNdR/ZoiF5VZfOl9pjrfBoqRy4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 233/775] media: i2c/Kconfig: Select FWNODE for OV772x sensor
Date:   Mon,  1 Mar 2021 17:06:41 +0100
Message-Id: <20210301161213.143875278@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit b7cdd6453ca2c2449c5270f2d0ae88b644a1d2fb ]

Fix OV772x build breakage by selecting V4L2_FWNODE config:

ia64-linux-ld: drivers/media/i2c/ov772x.o: in function `ov772x_probe':
ov772x.c:(.text+0x1ee2): undefined reference to `v4l2_fwnode_endpoint_alloc_parse'
ia64-linux-ld: ov772x.c:(.text+0x1f12): undefined reference to `v4l2_fwnode_endpoint_free'
ia64-linux-ld: ov772x.c:(.text+0x2212): undefined reference to `v4l2_fwnode_endpoint_alloc_parse'

Fixes: 8a10b4e3601e ("media: i2c: ov772x: Parse endpoint properties")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Acked-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/Kconfig b/drivers/media/i2c/Kconfig
index 2b9d81e4794a4..6eed3209ee2d3 100644
--- a/drivers/media/i2c/Kconfig
+++ b/drivers/media/i2c/Kconfig
@@ -1000,6 +1000,7 @@ config VIDEO_OV772X
 	tristate "OmniVision OV772x sensor support"
 	depends on I2C && VIDEO_V4L2
 	select REGMAP_SCCB
+	select V4L2_FWNODE
 	help
 	  This is a Video4Linux2 sensor driver for the OmniVision
 	  OV772x camera.
-- 
2.27.0



