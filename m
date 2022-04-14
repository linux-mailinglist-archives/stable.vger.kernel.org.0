Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB713501069
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345385AbiDNNuK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:50:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344437AbiDNNl1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:41:27 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58A63120;
        Thu, 14 Apr 2022 06:39:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0CCB1B82983;
        Thu, 14 Apr 2022 13:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B11C385A5;
        Thu, 14 Apr 2022 13:38:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943539;
        bh=OATxwHjtFo3IrGZjFy003V5Bk3dUVf5PciYaRg5jQlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xjQ6nG39UiiRuiv0yqyW+TnguPAetm3Z9gmTnDKj7daiPKQlnCPA017fi9LFQuYUd
         rfeH/vX/zgDfUS66Wi4x8sZpu+XgU1xwCsou0oM1aWc4uvJ7gCQwbwKex14Avvyvey
         ST+RIxKuV3AGS65xhS30H4Y4ntA3dKQsvaDnPDdk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/475] drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt
Date:   Thu, 14 Apr 2022 15:09:38 +0200
Message-Id: <20220414110900.531391416@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Nishanth Menon <nm@ti.com>

[ Upstream commit ffb5c099aaa13ab7f73c29ea6ae26bce8d7575ae ]

Add MODULE_DEVICE_TABLE to the device tree table to create required
aliases needed for module to be loaded with device tree based platform.

Fixes: e19233955d9e ("drm/bridge: Add Cadence DSI driver")
Signed-off-by: Nishanth Menon <nm@ti.com>
Reviewed-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210921174059.17946-1-nm@ti.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/cdns-dsi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/cdns-dsi.c b/drivers/gpu/drm/bridge/cdns-dsi.c
index 0cb9dd6986ec..9c3f9110895e 100644
--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -1284,6 +1284,7 @@ static const struct of_device_id cdns_dsi_of_match[] = {
 	{ .compatible = "cdns,dsi" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, cdns_dsi_of_match);
 
 static struct platform_driver cdns_dsi_platform_driver = {
 	.probe  = cdns_dsi_drm_probe,
-- 
2.34.1



