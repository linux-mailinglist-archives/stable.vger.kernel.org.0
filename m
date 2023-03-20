Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7AC46C18C2
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbjCTP1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232835AbjCTP0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:26:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A05742E0D5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:20:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 545E46158F
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:19:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37029C433EF;
        Mon, 20 Mar 2023 15:19:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325575;
        bh=KDyJvZwQ6Jbby6eTS7ddgA4tlvl/NbCzVlisNvgM2vY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTOIfn/jfeD5eELuvit89LbmUKMTzij57xTkyxr7OvFayKglDr4Q/oJkNY8PH9w33
         szawUafoH9Gbn4akxQBeZxHriFQe6mK1OnYa1U6DXkYU5i5N8kqDTWkVUTY1jFD1VV
         3ov89u6Zs1tysH6os0bFai+sEG8Rwrxt9T+cVAB4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Liu Ying <victor.liu@nxp.com>,
        Robert Foss <rfoss@kernel.org>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 064/211] drm/bridge: Fix returned array size name for atomic_get_input_bus_fmts kdoc
Date:   Mon, 20 Mar 2023 15:53:19 +0100
Message-Id: <20230320145515.910022806@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit 0d3c9333d976af41d7dbc6bf4d9d2e95fbdf9c89 ]

The returned array size for input formats is set through
atomic_get_input_bus_fmts()'s 'num_input_fmts' argument, so use
'num_input_fmts' to represent the array size in the function's kdoc,
not 'num_output_fmts'.

Fixes: 91ea83306bfa ("drm/bridge: Fix the bridge kernel doc")
Fixes: f32df58acc68 ("drm/bridge: Add the necessary bits to support bus format negotiation")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Robert Foss <rfoss@kernel.org>
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20230314055035.3731179-1-victor.liu@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_bridge.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/drm/drm_bridge.h b/include/drm/drm_bridge.h
index 6b65b0dfb4fb4..288c6feda5de2 100644
--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -447,11 +447,11 @@ struct drm_bridge_funcs {
 	 *
 	 * The returned array must be allocated with kmalloc() and will be
 	 * freed by the caller. If the allocation fails, NULL should be
-	 * returned. num_output_fmts must be set to the returned array size.
+	 * returned. num_input_fmts must be set to the returned array size.
 	 * Formats listed in the returned array should be listed in decreasing
 	 * preference order (the core will try all formats until it finds one
 	 * that works). When the format is not supported NULL should be
-	 * returned and num_output_fmts should be set to 0.
+	 * returned and num_input_fmts should be set to 0.
 	 *
 	 * This method is called on all elements of the bridge chain as part of
 	 * the bus format negotiation process that happens in
-- 
2.39.2



