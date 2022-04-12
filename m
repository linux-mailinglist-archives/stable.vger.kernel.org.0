Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 839024FC965
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 02:44:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242001AbiDLAqk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 20:46:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241618AbiDLAqi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 20:46:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B751117F;
        Mon, 11 Apr 2022 17:44:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1E76B819B5;
        Tue, 12 Apr 2022 00:44:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E291C385A3;
        Tue, 12 Apr 2022 00:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649724258;
        bh=tGzXzQhqgL+alx1Q6zWeqj7q4zL1AuwH2it+jAec/5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MsS52rJ37rg9vOoBEfnvEhm/FVDNEWPn6lYGzvi2Vco3LctP0hLorYXF04MqhSYG8
         pxdMkk597No9uZS3Z43zTSNI+VTuSL5ap9VT9MgAGH4LQqQweQ/htzt+ZojU4kzq4j
         394eWH8u9HgXYfBDdJVTQS6yqUv7eTWfiSM3UUzvdxWNYZPxuDVe1ZFxW7YDSlht9J
         vKyFiFgUu/6T168eUoioHqayia5RsWBaloPGcjZnGlbWDecUDzJZX1WInRb4hjCi/r
         QPXmqs9djjGZR48xwZOlbKhda1xA4r0eUj9X0Jx3LRuqZw6q4c1gs3W22Y9sJsxo7c
         XurLSu2ldIaUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 02/49] drm/amd: Add USBC connector ID
Date:   Mon, 11 Apr 2022 20:43:20 -0400
Message-Id: <20220412004411.349427-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412004411.349427-1-sashal@kernel.org>
References: <20220412004411.349427-1-sashal@kernel.org>
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

From: Aurabindo Pillai <aurabindo.pillai@amd.com>

[ Upstream commit c5c948aa894a831f96fccd025e47186b1ee41615 ]

[Why&How] Add a dedicated AMDGPU specific ID for use with
newer ASICs that support USB-C output

Signed-off-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/ObjectID.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/ObjectID.h b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
index 5b393622f592..a0f0a17e224f 100644
--- a/drivers/gpu/drm/amd/amdgpu/ObjectID.h
+++ b/drivers/gpu/drm/amd/amdgpu/ObjectID.h
@@ -119,6 +119,7 @@
 #define CONNECTOR_OBJECT_ID_eDP                   0x14
 #define CONNECTOR_OBJECT_ID_MXM                   0x15
 #define CONNECTOR_OBJECT_ID_LVDS_eDP              0x16
+#define CONNECTOR_OBJECT_ID_USBC                  0x17
 
 /* deleted */
 
-- 
2.35.1

