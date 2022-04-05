Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5EFF4F37D5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359572AbiDELUF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:20:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349223AbiDEJt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9F722BC7;
        Tue,  5 Apr 2022 02:42:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8676C6164D;
        Tue,  5 Apr 2022 09:42:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92736C385A2;
        Tue,  5 Apr 2022 09:42:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151775;
        bh=UHezyPlQDh8jzw+GjdXmv1AOyTSaSsM0PNBwAPPBQA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cn7LjAO+foJT53v8gY01jSAiL8j8veb6e8k2QvelmjPVSCe11T5jwsD8/gfR3V49T
         z13/s5+pg1+bomtdlcr3e6w80abGfJ+eHHqKFrIOSFotnGhPZ6AcpgdWeEJ7YgM2RR
         eAcwpHoEWGSrrLuJcwVdFfK6dhmytsk1PX84RlcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishanth Menon <nm@ti.com>,
        Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/913] drm/bridge: cdns-dsi: Make sure to to create proper aliases for dt
Date:   Tue,  5 Apr 2022 09:26:00 +0200
Message-Id: <20220405070354.782587344@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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
index e6e331071a00..dd57b104aec3 100644
--- a/drivers/gpu/drm/bridge/cdns-dsi.c
+++ b/drivers/gpu/drm/bridge/cdns-dsi.c
@@ -1286,6 +1286,7 @@ static const struct of_device_id cdns_dsi_of_match[] = {
 	{ .compatible = "cdns,dsi" },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, cdns_dsi_of_match);
 
 static struct platform_driver cdns_dsi_platform_driver = {
 	.probe  = cdns_dsi_drm_probe,
-- 
2.34.1



