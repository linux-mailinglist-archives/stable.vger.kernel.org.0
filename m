Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA7B74F3248
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245107AbiDEIyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241122AbiDEIcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:32:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A898115FC2;
        Tue,  5 Apr 2022 01:28:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B913B81BB1;
        Tue,  5 Apr 2022 08:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5706C385A2;
        Tue,  5 Apr 2022 08:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147280;
        bh=k5faAOJ40OTa0COWongLuNACNXMXAEZdrOZeJQ1+P5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aUhlxnDO1kIaVt4G2YVsKsCV3YITfLhnkX3MtncRP8OEH34+kqKmxcseRAntLSwYS
         NieMckk7RUqEA5uvP/5nLILdo9XRuhtVOtvJwG3DNFbAcAonJXBJOJGG2JhwlSCYzt
         GYrvuRYZKxP8Lw+frlqdb4+EpnP+4ArdLcoIMjzs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Ripard <maxime@cerno.tech>,
        Simon Ser <contact@emersion.fr>
Subject: [PATCH 5.17 1067/1126] drm/connector: Fix typo in documentation
Date:   Tue,  5 Apr 2022 09:30:14 +0200
Message-Id: <20220405070438.775851380@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -592,13 +592,13 @@ struct drm_display_info {
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


