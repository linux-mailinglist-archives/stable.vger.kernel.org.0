Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932DD5AE6ED
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232406AbiIFLx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiIFLx1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:53:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7057A57219
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10594614E0
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11B65C433C1;
        Tue,  6 Sep 2022 11:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465205;
        bh=JYiS/DrAEaJBDDgPZawbfE7X+k2JE6KWCSXPHLt79Vw=;
        h=Subject:To:Cc:From:Date:From;
        b=j+LkKRswzjR/ZSHHzaXA4aL3Mqcm64y49Siuk/TzgLponohMz6RMrs3gnc8A5n2FO
         fHUG+I5S+kySyWedvdCV6c3TEqVMR8/H4C89DFHIwYcTyIeV453JxaU7bifXXZJ3IU
         3bQ8i9OzmEQo0AB4XQsvL/91z9oZuSYTkYT/DtLU=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: fix dual-link DSI backlight and CABC ports for" failed to apply to 5.10-stable tree
To:     jani.nikula@intel.com, rodrigo.vivi@intel.com,
        stanislav.lisovskiy@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:53:14 +0200
Message-ID: <16624651940113@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

875c6d2711f6 ("drm/i915/dsi: fix dual-link DSI backlight and CABC ports for display 11+")
3cf050762534 ("drm/i915/bios: Split VBT data into per-panel vs. global parts")
c2fdb424d322 ("drm/i915/bios: Split VBT parsing to global vs. panel specific parts")
c3fbcf60bc74 ("drm/i915/bios: Split parse_driver_features() into two parts")
75bd0d5e4ead ("drm/i915/pps: Split pps_init_delays() into distinct parts")
822e5ae701af ("drm/i915: Extract intel_edp_fixup_vbt_bpp()")
949665a6e237 ("drm/i915: Respect VBT seamless DRRS min refresh rate")
790b45f1bc67 ("drm/i915/bios: Parse the seamless DRRS min refresh rate")
901a0cad2ab8 ("drm/i915/bios: Get access to the tail end of the LFP data block")
13367132a7ad ("drm/i915/bios: Reorder panel DTD parsing")
5ab58d6996d7 ("drm/i915/bios: Validate the panel_name table")
58b2e3829ec6 ("drm/i915/bios: Trust the LFP data pointers")
514003e1421e ("drm/i915/bios: Validate LFP data table pointers")
918f3025960f ("drm/i915/bios: Use the copy of the LFP data table always")
e163cfb4c96d ("drm/i915/bios: Make copies of VBT data blocks")
d58a3d699797 ("drm/i915/bios: Use the cached BDB version")
ca2a3c9204ec ("drm/i915/bios: Extract struct lvds_lfp_data_ptr_table")
001b6169a920 ("drm/i915: Allow static DRRS on LVDS")
1159c8339278 ("drm/i915: Allow static DRRS on all eDP ports")
f244cdfa72b8 ("drm/i915: Move intel_drrs_compute_config() into intel_dp.c")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 875c6d2711f6c97e58c52288b4231f3072711d61 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Tue, 16 Aug 2022 18:37:21 +0300
Subject: [PATCH] drm/i915/dsi: fix dual-link DSI backlight and CABC ports for
 display 11+

The VBT dual-link DSI backlight and CABC still use ports A and C, both
in Bspec and code, while display 11+ DSI only supports ports A and
B. Assume port C actually means port B for display 11+ when parsing VBT.

Bspec: 20154
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6476
Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/8c462718bcc7b36a83e09d0a5eef058b6bc8b1a2.1660664162.git.jani.nikula@intel.com
(cherry picked from commit ab55165d73a444606af1530cd0d6448b04370f68)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 51dde5bfd956..198a2f4920cc 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1596,6 +1596,8 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
 				      struct intel_panel *panel,
 				      enum port port)
 {
+	enum port port_bc = DISPLAY_VER(i915) >= 11 ? PORT_B : PORT_C;
+
 	if (!panel->vbt.dsi.config->dual_link || i915->vbt.version < 197) {
 		panel->vbt.dsi.bl_ports = BIT(port);
 		if (panel->vbt.dsi.config->cabc_supported)
@@ -1609,11 +1611,11 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
 		panel->vbt.dsi.bl_ports = BIT(PORT_A);
 		break;
 	case DL_DCS_PORT_C:
-		panel->vbt.dsi.bl_ports = BIT(PORT_C);
+		panel->vbt.dsi.bl_ports = BIT(port_bc);
 		break;
 	default:
 	case DL_DCS_PORT_A_AND_C:
-		panel->vbt.dsi.bl_ports = BIT(PORT_A) | BIT(PORT_C);
+		panel->vbt.dsi.bl_ports = BIT(PORT_A) | BIT(port_bc);
 		break;
 	}
 
@@ -1625,12 +1627,12 @@ static void parse_dsi_backlight_ports(struct drm_i915_private *i915,
 		panel->vbt.dsi.cabc_ports = BIT(PORT_A);
 		break;
 	case DL_DCS_PORT_C:
-		panel->vbt.dsi.cabc_ports = BIT(PORT_C);
+		panel->vbt.dsi.cabc_ports = BIT(port_bc);
 		break;
 	default:
 	case DL_DCS_PORT_A_AND_C:
 		panel->vbt.dsi.cabc_ports =
-					BIT(PORT_A) | BIT(PORT_C);
+					BIT(PORT_A) | BIT(port_bc);
 		break;
 	}
 }

