Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F4449A901
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1321882AbiAYDT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:19:59 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:44612 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357182AbiAXTta (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:49:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D0AFB6090B;
        Mon, 24 Jan 2022 19:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DEFC340E8;
        Mon, 24 Jan 2022 19:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053769;
        bh=CLLAa3KRYtUtrOCmUpY1ensPN6KX3tszgWRlsKu2Gqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZmQT3va2LIKrEsHfKKjq5fMRdCiv3Sb5ovxN1IHPeHeuBp07K7oWZ51dXk4PoHzoA
         7Ok8WnxXcwJeupksC160dQYynvB+MxEuJkUWeI1oeNiQyBkklGI+fefeVI+6tv0xIr
         5+Z+wFyayiCTUjKeB9EuCPgHYejgrtK0RtMKsgHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Rob Clark <robdclark@chromium.org>,
        Douglas Anderson <dianders@chromium.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stephen Boyd <swboyd@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 170/563] drm/bridge: ti-sn65dsi86: Set max register for regmap
Date:   Mon, 24 Jan 2022 19:38:55 +0100
Message-Id: <20220124184030.296105763@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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
index ecdf9b01340f5..1a58481037b3f 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi86.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi86.c
@@ -171,6 +171,7 @@ static const struct regmap_config ti_sn_bridge_regmap_config = {
 	.val_bits = 8,
 	.volatile_table = &ti_sn_bridge_volatile_table,
 	.cache_type = REGCACHE_NONE,
+	.max_register = 0xFF,
 };
 
 static void ti_sn_bridge_write_u16(struct ti_sn_bridge *pdata,
-- 
2.34.1



