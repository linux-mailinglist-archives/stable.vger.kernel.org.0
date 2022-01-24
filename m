Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 315804990B9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354700AbiAXUDd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:03:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376355AbiAXUBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:01:31 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26CBC055AB8;
        Mon, 24 Jan 2022 11:28:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A6D2B811F9;
        Mon, 24 Jan 2022 19:28:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D1BC340E5;
        Mon, 24 Jan 2022 19:28:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643052524;
        bh=yIwPMOuMtW3hepi44yX+nWOd3v69Bk/KG7AjPaytj0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NoImzNL4ceY496bR3mNdzs6EvbubgY+GTIFsuZS9M/NpTqkhKH0fFzVLWrR/1bCZJ
         pHdmrEvlJ2v7M9HRURNyL/1jXke5qLKiVVyT6rc/MGyfNasLcqBPzf+LhP/SOdciWo
         bbf3L9Zl6VC+lScN4Ewys9zYfM9OI2aZ9xm32c9A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 087/320] drm/bridge: ti-sn65dsi86: Set max register for regmap
Date:   Mon, 24 Jan 2022 19:41:11 +0100
Message-Id: <20220124183956.698481483@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124183953.750177707@linuxfoundation.org>
References: <20220124183953.750177707@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Stephen Boyd <swboyd@chromium.org>

[ Upstream commit 0b665d4af35837f0a0ae63135b84a3c187c1db3b ]

Set the maximum register to 0xff so we can dump the registers for this
device in debugfs.

Fixes: a095f15c00e2 ("drm/bridge: add support for sn65dsi86 bridge driver")
Cc: Rob Clark <robdclark@chromium.org>
Cc: Douglas Anderson <dianders@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Stephen Boyd <swboyd@chromium.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211215002529.382383-1-swboyd@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi86.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi86.c b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
index f1de4bb6558ca..dbb4a374cb646 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -115,6 +115,7 @@ static const struct regmap_config ti_sn_bridge_regmap_config = {
 	.val_bits = 8,
 	.volatile_table = &ti_sn_bridge_volatile_table,
 	.cache_type = REGCACHE_NONE,
+	.max_register = 0xFF,
 };
 
 static void ti_sn_bridge_write_u16(struct ti_sn_bridge *pdata,
-- 
2.34.1



