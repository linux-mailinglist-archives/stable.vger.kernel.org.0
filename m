Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF162E423A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:20:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437016AbgL1OCv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:02:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:36658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437011AbgL1OCv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:02:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0040820731;
        Mon, 28 Dec 2020 14:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164130;
        bh=cZmdTMHTneq2zpO4/K6LRNiaOTR8J4LM8QZLwwJdUDM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tUNlaK7oZd3bMoSNw+corfu0b/CcBiRkFBDNIbA5I+kVAEps9lw6rP9YqyaDpBT1v
         NrdR5aSdGyCkYlA5bN5g6iyTJAnB/egfY4ec/aBh7GJNqsU4vtTCfkckKaCQCuJUc6
         VT5OE5gtawbSs9yphX+nuUq0hUvq4xGk/lfNb4a8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/717] drm/panel: simple: Add flags to boe_nv133fhm_n61
Date:   Mon, 28 Dec 2020 13:41:09 +0100
Message-Id: <20201228125024.392880378@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit ab6fd5d44aa21ede9e566f89132f7bdda7f33093 ]

Reading the EDID of this panel shows that these flags should be set. Set
them so that we match what is in the EDID.

Cc: Douglas Anderson <dianders@chromium.org>
Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: b0c664cc80e8 ("panel: simple: Add BOE NV133FHM-N61")
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20201106182333.3080124-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 2be358fb46f7d..204674fccd646 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -1327,6 +1327,7 @@ static const struct drm_display_mode boe_nv133fhm_n61_modes = {
 	.vsync_start = 1080 + 3,
 	.vsync_end = 1080 + 3 + 6,
 	.vtotal = 1080 + 3 + 6 + 31,
+	.flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_NVSYNC,
 };
 
 /* Also used for boe_nv133fhm_n62 */
-- 
2.27.0



