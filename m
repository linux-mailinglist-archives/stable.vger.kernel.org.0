Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1570929C111
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:22:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1818685AbgJ0RWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:22:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:55470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368526AbgJ0Oy5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:54:57 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 460B52071A;
        Tue, 27 Oct 2020 14:54:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810496;
        bh=xnbp1dIgqAtzK5mxxPFGP3kKzzQDD2U0U9B2MsJeFXI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YKh3a5lvsd/AA5lIM5/5FzLWYg/IVxhW4kuhETcaqnacHc+cM5UtYqB/Kx38bpaUW
         /BvI7z+7RGbLmwzPWfV/GCBrkwLCC0LGyJsFX91t6e/ZpRAKxeiznh9pYp8JJYUDsh
         yTHrVFpHUWPKW0a/jWFRyp5PbXi58dBPl2Zs9ZpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam.ravnborg@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 160/633] drm: panel: Fix bus format for OrtusTech COM43H4M85ULC panel
Date:   Tue, 27 Oct 2020 14:48:23 +0100
Message-Id: <20201027135530.180446041@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
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
index 7debf2ca42522..85fa4027d82d7 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -2867,7 +2867,7 @@ static const struct panel_desc ortustech_com43h4m85ulc = {
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



