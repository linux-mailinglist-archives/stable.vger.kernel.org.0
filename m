Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDFE94F3A29
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:58:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379231AbiDELkg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:40:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354467AbiDEKOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:14:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C63C6A41D;
        Tue,  5 Apr 2022 03:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC67E61673;
        Tue,  5 Apr 2022 10:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC47C385A4;
        Tue,  5 Apr 2022 10:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152817;
        bh=e/XM4T8kGA8YmUSl+7zxZN4nqVNClbVOAqagp52YUXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z0mHGU3/3lq+DAgz1/eWWkB3Bz2cqhFQXvzzlIzywvijRfQp6eos40bss/0j8sJ2t
         FzBCfD3GxoZJLO4TBR9oFJViI/tvDYotX7jMn81tIDx0ioSLEVMcTaiiwBfIkAS4Mz
         /zhvOkr9GhWXMHI4sU5yor/hsxvtRPYnMF7/awu0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Ripard <maxime@cerno.tech>,
        Simon Ser <contact@emersion.fr>
Subject: [PATCH 5.15 864/913] drm/connector: Fix typo in documentation
Date:   Tue,  5 Apr 2022 09:32:06 +0200
Message-Id: <20220405070405.722836555@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

commit dca384a3bf5af1c781cfa6aec63904bdb5018c36 upstream.

Commit 4adc33f36d80 ("drm/edid: Split deep color modes between RGB and
YUV444") introduced two new variables in struct drm_display_info and
their documentation, but the documentation part had a typo resulting in
a doc build warning.

Fixes: 4adc33f36d80 ("drm/edid: Split deep color modes between RGB and YUV444")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Reviewed-by: Simon Ser <contact@emersion.fr>
Link: https://patchwork.freedesktop.org/patch/msgid/20220202094340.875190-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/drm_connector.h |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -566,13 +566,13 @@ struct drm_display_info {
 	bool rgb_quant_range_selectable;
 
 	/**
-	 * @edid_hdmi_dc_rgb444_modes: Mask of supported hdmi deep color modes
+	 * @edid_hdmi_rgb444_dc_modes: Mask of supported hdmi deep color modes
 	 * in RGB 4:4:4. Even more stuff redundant with @bus_formats.
 	 */
 	u8 edid_hdmi_rgb444_dc_modes;
 
 	/**
-	 * @edid_hdmi_dc_ycbcr444_modes: Mask of supported hdmi deep color
+	 * @edid_hdmi_ycbcr444_dc_modes: Mask of supported hdmi deep color
 	 * modes in YCbCr 4:4:4. Even more stuff redundant with @bus_formats.
 	 */
 	u8 edid_hdmi_ycbcr444_dc_modes;


