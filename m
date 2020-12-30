Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 363982E7C4B
	for <lists+stable@lfdr.de>; Wed, 30 Dec 2020 21:45:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgL3Uos (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Dec 2020 15:44:48 -0500
Received: from relay-us1.mymailcheap.com ([51.81.35.219]:56180 "EHLO
        relay-us1.mymailcheap.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgL3Uor (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Dec 2020 15:44:47 -0500
Received: from relay5.mymailcheap.com (relay5.mymailcheap.com [159.100.248.207])
        by relay-us1.mymailcheap.com (Postfix) with ESMTPS id A360120159
        for <stable@vger.kernel.org>; Wed, 30 Dec 2020 20:44:06 +0000 (UTC)
Received: from relay2.mymailcheap.com (relay2.mymailcheap.com [217.182.113.132])
        by relay5.mymailcheap.com (Postfix) with ESMTPS id 9D4A1260EB;
        Wed, 30 Dec 2020 20:43:12 +0000 (UTC)
Received: from filter2.mymailcheap.com (filter2.mymailcheap.com [91.134.140.82])
        by relay2.mymailcheap.com (Postfix) with ESMTPS id 93EC93EDFC;
        Wed, 30 Dec 2020 21:41:39 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by filter2.mymailcheap.com (Postfix) with ESMTP id 711A92A524;
        Wed, 30 Dec 2020 21:41:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mymailcheap.com;
        s=default; t=1609360899;
        bh=FRGW8gu58lGpw7gwIy7zr0D1bR8uZrCGzxkRxv0pFb4=;
        h=From:To:Cc:Subject:Date:From;
        b=hdOH/nL163C+MJWV37q702UBmnSpoPxINNoYM/yqN/OnYdO1UhNhcbv4CSWTen7te
         R7REtL21tc9yeDEKvvAAk9i1H4EhwPqHJvBQqk6EtPlq18NXJZQEPo+7ZJPXBFs0qe
         crcjdAwotB0V2jTBC4sQvWJzWRYQbFhYlP6NZHTM=
X-Virus-Scanned: Debian amavisd-new at filter2.mymailcheap.com
Received: from filter2.mymailcheap.com ([127.0.0.1])
        by localhost (filter2.mymailcheap.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 54ouhL5P2Orm; Wed, 30 Dec 2020 21:41:38 +0100 (CET)
Received: from mail20.mymailcheap.com (mail20.mymailcheap.com [51.83.111.147])
        (using TLSv1.2 with cipher ADH-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by filter2.mymailcheap.com (Postfix) with ESMTPS;
        Wed, 30 Dec 2020 21:41:38 +0100 (CET)
Received: from [213.133.102.83] (ml.mymailcheap.com [213.133.102.83])
        by mail20.mymailcheap.com (Postfix) with ESMTP id 88D5241FB0;
        Wed, 30 Dec 2020 20:41:37 +0000 (UTC)
Authentication-Results: mail20.mymailcheap.com;
        dkim=pass (1024-bit key; unprotected) header.d=aosc.io header.i=@aosc.io header.b="ZAE1txoD";
        dkim-atps=neutral
AI-Spam-Status: Not processed
Received: from ice-e5v2.lan (unknown [59.41.160.237])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail20.mymailcheap.com (Postfix) with ESMTPSA id 18AAF41E18;
        Wed, 30 Dec 2020 20:41:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=aosc.io; s=default;
        t=1609360887; bh=FRGW8gu58lGpw7gwIy7zr0D1bR8uZrCGzxkRxv0pFb4=;
        h=From:To:Cc:Subject:Date:From;
        b=ZAE1txoDvI/Sr6IEXZfrYbhDo2Wi1V0ZRYetZqSy440m3QtHX3Mz2zOiXm3JbSnLf
         lQGVZRPHjqJ5YPD61luGKabNDG+YJR4SU51Vtvfy0G1tqSK44anQ/wVaMCokMYCvxO
         T4hJ9edY6aIB6etTkExDb3jbjaSCvqpqFOQ4+hVU=
From:   Icenowy Zheng <icenowy@aosc.io>
To:     Thierry Reding <thierry.reding@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Maxime Ripard <mripard@kernel.org>
Cc:     dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Icenowy Zheng <icenowy@aosc.io>, stable@vger.kernel.org
Subject: [PATCH] drm/panel: ilitek-ili9881c: fix attach failure cleanup
Date:   Thu, 31 Dec 2020 04:41:10 +0800
Message-Id: <20201230204110.52053-1-icenowy@aosc.io>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: mail20.mymailcheap.com
X-Spamd-Result: default: False [6.40 / 20.00];
         RCVD_VIA_SMTP_AUTH(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         BROKEN_CONTENT_TYPE(1.50)[];
         R_SPF_SOFTFAIL(0.00)[~all];
         ML_SERVERS(-3.10)[213.133.102.83];
         DKIM_TRACE(0.00)[aosc.io:+];
         RCPT_COUNT_SEVEN(0.00)[9];
         FREEMAIL_TO(0.00)[gmail.com,ravnborg.org,linux.ie,ffwll.ch,kernel.org];
         RCVD_NO_TLS_LAST(0.10)[];
         RECEIVED_SPAMHAUS_PBL(0.00)[59.41.160.237:received];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:24940, ipnet:213.133.96.0/19, country:DE];
         ARC_NA(0.00)[];
         R_DKIM_ALLOW(0.00)[aosc.io:s=default];
         FROM_HAS_DN(0.00)[];
         FREEMAIL_ENVRCPT(0.00)[gmail.com];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         TAGGED_RCPT(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         DMARC_NA(0.00)[aosc.io];
         MID_CONTAINS_FROM(1.00)[];
         HFILTER_HELO_BAREIP(3.00)[213.133.102.83,1];
         RCVD_COUNT_TWO(0.00)[2];
         SUSPICIOUS_RECIPS(1.50)[]
X-Rspamd-Queue-Id: 88D5241FB0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When mipi_dsi_attach() fails (e.g. got a -EPROBE_DEFER), the panel should
be removed, otherwise a pointer to it will be kept and then lead to
use-after-free when DRM panel codes are called (e.g. the panel is probed
again).

Fix this by adding cleanup code after mipi_dsi_attach() failure.

Fixes: 26aec25593c2 ("drm/panel: Add Ilitek ILI9881c panel driver")
Cc: stable@vger.kernel.org
Signed-off-by: Icenowy Zheng <icenowy@aosc.io>
---
 drivers/gpu/drm/panel/panel-ilitek-ili9881c.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
index 0145129d7c66..22f2268f00f7 100644
--- a/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
+++ b/drivers/gpu/drm/panel/panel-ilitek-ili9881c.c
@@ -674,7 +674,13 @@ static int ili9881c_dsi_probe(struct mipi_dsi_device *dsi)
 	dsi->format = MIPI_DSI_FMT_RGB888;
 	dsi->lanes = 4;
 
-	return mipi_dsi_attach(dsi);
+	ret = mipi_dsi_attach(dsi);
+	if (ret < 0) {
+		drm_panel_remove(&ctx->panel);
+		return ret;
+	}
+
+	return 0;
 }
 
 static int ili9881c_dsi_remove(struct mipi_dsi_device *dsi)
-- 
2.28.0
