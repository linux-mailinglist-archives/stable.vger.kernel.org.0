Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3C89594826
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:06:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343530AbiHOXRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241876AbiHOXO3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:14:29 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D10DA474FB;
        Mon, 15 Aug 2022 13:01:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 09617CE12E7;
        Mon, 15 Aug 2022 20:01:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C7CC433C1;
        Mon, 15 Aug 2022 20:01:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593707;
        bh=nDbHqfhdNpzYZKdbkZ4LGk/SQWMKL/OIcQRYU9Jk20o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WkV4qifhuorlxeXj/qCJ2R6gL9rZ2C0bWOL0FZq7e90/IFeJ5ZqsFk9EFxS3EjA73
         K12n8SksGVd3mnMmZSnbWMpWu/ez8C6KsSFNJ0U8tvZr0+o7siAS3fYeirOBWqRioQ
         7OgGJ0S+LxOOoeMy0KaWJ1u0I0JPaPXaZTPuHmVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrzej Hajda <andrzej.hajda@intel.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Marek Vasut <marex@denx.de>, Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0313/1157] drm/bridge: tc358767: Handle dsi_lanes == 0 as invalid
Date:   Mon, 15 Aug 2022 19:54:29 +0200
Message-Id: <20220815180452.170706172@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Vasut <marex@denx.de>

[ Upstream commit 0d662350928e6787d29ab205e47e5aa6f1f792f9 ]

Handle empty data-lanes = < >; property, which translates to
dsi_lanes = 0 as invalid.

Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Fixes: bbfd3190b6562 ("drm/bridge: tc358767: Add DSI-to-DPI mode support")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220519095137.11896-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/tc358767.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/tc358767.c b/drivers/gpu/drm/bridge/tc358767.c
index 485717c8f0b4..466b8fc9836a 100644
--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1871,7 +1871,7 @@ static int tc_mipi_dsi_host_attach(struct tc_data *tc)
 	of_node_put(host_node);
 	of_node_put(endpoint);
 
-	if (dsi_lanes < 0 || dsi_lanes > 4)
+	if (dsi_lanes <= 0 || dsi_lanes > 4)
 		return -EINVAL;
 
 	if (!host)
-- 
2.35.1



