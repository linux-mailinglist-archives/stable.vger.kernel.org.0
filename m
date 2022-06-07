Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16AB3541A4E
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:33:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378901AbiFGVch (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380153AbiFGVaR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:30:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D16152D8A;
        Tue,  7 Jun 2022 12:02:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EFD46B822C0;
        Tue,  7 Jun 2022 19:02:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63D29C385A2;
        Tue,  7 Jun 2022 19:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628561;
        bh=x7PO9lUovco5p9SZ7ZNCeyJS7CjTegdASYQEK9GNgtA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2TGc3/7imuNAC6VCXXIZ9VhnTbIxmz/j4KzouXm+Jps4WZvriWdTOcjz65ts3cEiY
         7kEAvotLEXmt4G7rb0GcpQZckZNQp5EKvSUtYsHV0oVpPFPEVcv35kQqEz+bctt/OX
         ahWTOgXOw6eSpZOVRqTtmnkRIEcwkQ7r7AVopWyk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Randy Dunlap <rdunlap@infradead.org>,
        Robert Foss <robert.foss@linaro.org>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 334/879] drm/bridge: Fix it6505 Kconfig DRM_DP_AUX_BUS dependency
Date:   Tue,  7 Jun 2022 18:57:32 +0200
Message-Id: <20220607165012.552236678@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robert Foss <robert.foss@linaro.org>

[ Upstream commit c5060b09f460fc83846d361018a124fcade1b9e9 ]

it6505 depends on DRM_DP_AUX_BUS, the kconfig for it6505 should
reflect this dependency using 'select'.

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220421131415.1289469-1-robert.foss@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/Kconfig b/drivers/gpu/drm/bridge/Kconfig
index becd9867f3a0..be2fc4791c1d 100644
--- a/drivers/gpu/drm/bridge/Kconfig
+++ b/drivers/gpu/drm/bridge/Kconfig
@@ -77,6 +77,7 @@ config DRM_DISPLAY_CONNECTOR
 config DRM_ITE_IT6505
         tristate "ITE IT6505 DisplayPort bridge"
         depends on OF
+        select DRM_DP_AUX_BUS
 	select DRM_DP_HELPER
         select DRM_KMS_HELPER
         select DRM_DP_HELPER
-- 
2.35.1



