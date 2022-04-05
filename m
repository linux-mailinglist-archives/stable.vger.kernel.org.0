Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 936DA4F2A7C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355969AbiDEKWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:22:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238328AbiDEJ3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:29:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2243FE127A;
        Tue,  5 Apr 2022 02:16:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7FA7B81B75;
        Tue,  5 Apr 2022 09:16:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C89AC385A4;
        Tue,  5 Apr 2022 09:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150195;
        bh=e/XM4T8kGA8YmUSl+7zxZN4nqVNClbVOAqagp52YUXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c5PZZJXzM4+UbKjKweoSE+j7z1xs9qVaKvsLGeUW7F7qWN8R/32zWkyCtKKVFyC86
         r4OUPsC6ewmiQtYpxdoNllHVVXaDPtf8S/6ORfqnRwKoljs3SNaTuzNS0sOnQYQ8l2
         GbDtSrarXC/C4Tg2wsMr8kOt18s8GqH5IHr67PDE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        Maxime Ripard <maxime@cerno.tech>,
        Simon Ser <contact@emersion.fr>
Subject: [PATCH 5.16 0961/1017] drm/connector: Fix typo in documentation
Date:   Tue,  5 Apr 2022 09:31:14 +0200
Message-Id: <20220405070422.733880962@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
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


