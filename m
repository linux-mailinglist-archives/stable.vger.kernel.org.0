Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D024FCA52
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244014AbiDLAxm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:53:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244622AbiDLAvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:51:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAB0333344;
        Mon, 11 Apr 2022 17:47:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85E50B819BC;
        Tue, 12 Apr 2022 00:47:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70370C385A4;
        Tue, 12 Apr 2022 00:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724454;
        bh=LCkqVqIIGOi/CenhiiJdU9IaJN8JgKTltB9UEL1EcZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A7MTpMpD4FXybfjekWQmFoDzAr30X1gHa7mc9ewUpZx+hi3jTBNqjX10+03a0gJxx
         oUoniXeMsBqjtdDBW+9DZrXA8DAmJLs3zvX9oJri662jYtIWlsaRUfwbcIZXq9kH6I
         UFBg+baE5g+iLpvKIe/S9Dpg4XpJR2uqKAJycgLa3iq106Hm1pyN4T5i511sKcH4mr
         GSfdC4NKw0sPhpC3JPjcKcPNnKIPGgwzMEkAgf86JjqWDEgUcX4nIdBZSimIRDc6lT
         +mu6bicVrBaGVVbOhjQ7nVuKKP5CvMwx11L1NjZlWQ3VkzaCbk/ogrc4rQchmUVlms
         7eJARREyu2S/Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Leo (Hanghong) Ma" <hanghong.ma@amd.com>,
        Chris Park <Chris.Park@amd.com>, Alex Hung <alex.hung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Krunoslav.Kovac@amd.com, Reza.Amini@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 08/41] drm/amd/display: Update VTEM Infopacket definition
Date:   Mon, 11 Apr 2022 20:46:20 -0400
Message-Id: <20220412004656.350101-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004656.350101-1-sashal@kernel.org>
References: <20220412004656.350101-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: "Leo (Hanghong) Ma" <hanghong.ma@amd.com>

[ Upstream commit c9fbf6435162ed5fb7201d1d4adf6585c6a8c327 ]

[Why & How]
The latest HDMI SPEC has updated the VTEM packet structure,
so change the VTEM Infopacket defined in the driver side to align
with the SPEC.

Reviewed-by: Chris Park <Chris.Park@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Leo (Hanghong) Ma <hanghong.ma@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/modules/info_packet/info_packet.c    | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
index 57f198de5e2c..4e075b01d48b 100644
--- a/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
+++ b/drivers/gpu/drm/amd/display/modules/info_packet/info_packet.c
@@ -100,7 +100,8 @@ enum vsc_packet_revision {
 //PB7 = MD0
 #define MASK_VTEM_MD0__VRR_EN         0x01
 #define MASK_VTEM_MD0__M_CONST        0x02
-#define MASK_VTEM_MD0__RESERVED2      0x0C
+#define MASK_VTEM_MD0__QMS_EN         0x04
+#define MASK_VTEM_MD0__RESERVED2      0x08
 #define MASK_VTEM_MD0__FVA_FACTOR_M1  0xF0
 
 //MD1
@@ -109,7 +110,7 @@ enum vsc_packet_revision {
 //MD2
 #define MASK_VTEM_MD2__BASE_REFRESH_RATE_98  0x03
 #define MASK_VTEM_MD2__RB                    0x04
-#define MASK_VTEM_MD2__RESERVED3             0xF8
+#define MASK_VTEM_MD2__NEXT_TFR              0xF8
 
 //MD3
 #define MASK_VTEM_MD3__BASE_REFRESH_RATE_07  0xFF
-- 
2.35.1

