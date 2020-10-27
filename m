Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04DFD29B7F0
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:08:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1798576AbgJ0P2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:41070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1798163AbgJ0P0T (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:26:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 84D4420728;
        Tue, 27 Oct 2020 15:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603812379;
        bh=d46/vpdNZttYmYBAY4pG2R0HXtTvs1Muf3yv/DF3TeE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=auFF82C7I9xW3lQozbITemb/5SFjaMlDainDQIRb0+HIlF2YUfwoz0Su/38g+P43E
         F5vSdsFCGtp4KnEhVZVlYVgq3wVcfTSFvI4jB7M3g7r+/sa/z+9zyaQbEM8NmOXBTd
         fMYV51dx2N8M2ib5/+22QV2+y1DIMYofqa2nZAKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam.ravnborg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 189/757] drm: panel: Fix bus format for OrtusTech COM43H4M85ULC panel
Date:   Tue, 27 Oct 2020 14:47:19 +0100
Message-Id: <20201027135459.473582593@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit f098f168e91ca915c6cf8aa316136af647792f2f ]

The OrtusTech COM43H4M85ULC panel is a 18-bit RGB panel, set the bus
format to MEDIA_BUS_FMT_RGB666_1X18.

Fixes: 725c9d40f3fe ("drm/panel: Add support for OrtusTech COM43H4M85ULC panel")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam.ravnborg@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200812220244.24500-1-laurent.pinchart@ideasonboard.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index cb6550d37e858..7bd5ffe8c88f3 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2946,7 +2946,7 @@ static const struct panel_desc ortustech_com43h4m85ulc = {
 		.width = 56,
 		.height = 93,
 	},
-	.bus_format = MEDIA_BUS_FMT_RGB888_1X24,
+	.bus_format = MEDIA_BUS_FMT_RGB666_1X18,
 	.bus_flags = DRM_BUS_FLAG_DE_HIGH | DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE,
 	.connector_type = DRM_MODE_CONNECTOR_DPI,
 };
-- 
2.25.1



