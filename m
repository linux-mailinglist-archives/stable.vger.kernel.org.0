Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E03331F381A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 12:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728780AbgFIK21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 06:28:27 -0400
Received: from lelv0142.ext.ti.com ([198.47.23.249]:40144 "EHLO
        lelv0142.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgFIK21 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Jun 2020 06:28:27 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by lelv0142.ext.ti.com (8.15.2/8.15.2) with ESMTP id 059ASGcT030666;
        Tue, 9 Jun 2020 05:28:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1591698496;
        bh=V9QdnPw8d/vxiPjsYDXpzBS3COUWNuJVQoFpYX6mjwQ=;
        h=From:To:CC:Subject:Date;
        b=PSMeDzuuj/XXOG6VNhDZE80PKwyqTy8+S3bQLw6xFn5HEWGx1UtTNrtS97AR0P08F
         vS/1GuUL6j+pc/UH1D+jNFWt4pKItTdfUMWsAmgLLxIGFipTpdMSt/k2KKbRyvEoaK
         Xwlxn6PHLiokufalDItVYv4CDFKzvGn/i14N2T/o=
Received: from DFLE107.ent.ti.com (dfle107.ent.ti.com [10.64.6.28])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 059ASGJx048661;
        Tue, 9 Jun 2020 05:28:16 -0500
Received: from DFLE102.ent.ti.com (10.64.6.23) by DFLE107.ent.ti.com
 (10.64.6.28) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 9 Jun
 2020 05:28:16 -0500
Received: from fllv0039.itg.ti.com (10.64.41.19) by DFLE102.ent.ti.com
 (10.64.6.23) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 9 Jun 2020 05:28:16 -0500
Received: from deskari.lan (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0039.itg.ti.com (8.15.2/8.15.2) with ESMTP id 059ASE3v026607;
        Tue, 9 Jun 2020 05:28:15 -0500
From:   Tomi Valkeinen <tomi.valkeinen@ti.com>
To:     <dri-devel@lists.freedesktop.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>
CC:     Tony Lindgren <tony@atomide.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        <stable@vger.kernel.org>
Subject: [PATCH] drm/panel-simple: fix connector type for newhaven_nhd_43_480272ef_atxl
Date:   Tue, 9 Jun 2020 13:28:09 +0300
Message-ID: <20200609102809.753203-1-tomi.valkeinen@ti.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Add connector type for newhaven_nhd_43_480272ef_atxl, as
drm_panel_bridge_add() requires connector type to be set.

Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Cc: stable@vger.kernel.org # v5.5+
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 3ad828eaefe1..00c1a8dc4ce8 100644
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
Texas Instruments Finland Oy, Porkkalankatu 22, 00180 Helsinki.
Y-tunnus/Business ID: 0615521-4. Kotipaikka/Domicile: Helsinki

