Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F1120E793
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726448AbgF2V6i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:58:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgF2Sf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7850C247D8;
        Mon, 29 Jun 2020 15:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444146;
        bh=KxMLodaL9VRmXU3o6wjS4X4aIDtMS1Hm+31sE0FPM9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCpTWII19VTejB1w78fKHDavcR3/tjQHKRG1AybL0Xi5cfKIYSkSKprd9pXoHE2UN
         BKUFmL23GtJNPL9BOQ2rtqnlL/CZTYaMcCpckHIdEvsKXRPqkmAM1mKcaItomf9Z9n
         /RRKIhOmbdnjKy/tNXavx8yf6DQu4XiEUtRakRF4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 251/265] drm/panel-simple: fix connector type for newhaven_nhd_43_480272ef_atxl
Date:   Mon, 29 Jun 2020 11:18:04 -0400
Message-Id: <20200629151818.2493727-252-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tomi Valkeinen <tomi.valkeinen@ti.com>

commit 8a4f5e1185db61bce6ce3a5dce6381a77bcf94e6 upstream.

Add connector type for newhaven_nhd_43_480272ef_atxl, as
drm_panel_bridge_add() requires connector type to be set.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: stable@vger.kernel.org # v5.5+
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20200609102809.753203-1-tomi.valkeinen@ti.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 3ad828eaefe1c..00c1a8dc4ce8f 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2465,6 +2465,7 @@ static const struct panel_desc newhaven_nhd_43_480272ef_atxl = {
 	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE |
 		     DRM_BUS_FLAG_SYNC_DRIVE_POSEDGE,
+	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
 
 static const struct display_timing nlt_nl192108ac18_02d_timing = {
-- 
2.25.1

