Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9153E5AE6E8
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 13:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232245AbiIFLxS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 07:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230215AbiIFLxS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 07:53:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F87E5725C
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 04:53:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CF54C614E0
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 11:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DA2C433C1;
        Tue,  6 Sep 2022 11:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465196;
        bh=PdmMRq4lBbNEUfo1CUMptVM5Xpckp7xu3uKkDeUFayQ=;
        h=Subject:To:Cc:From:Date:From;
        b=1uY3ZTdogf6OD/FqY/oLwU4h6lBrKZomwtPYHYlj0M+sJPjhk7nlt8xY44tHct7e/
         iP1fZkKIpzDWQhV+HwteRkBPGkZUXRr8cQnCIOMuiC6ipthHcAk8xB3KsLoW7yfb3Z
         f8jdZfulM3c3Y7MGIaNNs69VKc4W+RUkp7rP3Ab0=
Subject: FAILED: patch "[PATCH] drm/i915/dsi: filter invalid backlight and CABC ports" failed to apply to 5.10-stable tree
To:     jani.nikula@intel.com, rodrigo.vivi@intel.com,
        stanislav.lisovskiy@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:53:07 +0200
Message-ID: <166246518720961@kroah.com>
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

e5e6886f4d7e ("drm/i915/dsi: filter invalid backlight and CABC ports")
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

From e5e6886f4d7e34b6539abddb591d515271caa634 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Tue, 16 Aug 2022 18:37:20 +0300
Subject: [PATCH] drm/i915/dsi: filter invalid backlight and CABC ports

Avoid using ports that aren't initialized in case the VBT backlight or
CABC ports have invalid values. This fixes a NULL pointer dereference of
intel_dsi->dsi_hosts[port] in such cases.

Cc: stable@vger.kernel.org
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/b0f4f087866257d280eb97d6bcfcefd109cc5fa2.1660664162.git.jani.nikula@intel.com
(cherry picked from commit f4a6c7a454a6e71c5ccf25af82694213a9784013)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/display/icl_dsi.c b/drivers/gpu/drm/i915/display/icl_dsi.c
index 5dcfa7feffa9..885c74f60366 100644
--- a/drivers/gpu/drm/i915/display/icl_dsi.c
+++ b/drivers/gpu/drm/i915/display/icl_dsi.c
@@ -2070,7 +2070,14 @@ void icl_dsi_init(struct drm_i915_private *dev_priv)
 	else
 		intel_dsi->ports = BIT(port);
 
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
+
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
 
 	for_each_dsi_port(port, intel_dsi->ports) {
diff --git a/drivers/gpu/drm/i915/display/vlv_dsi.c b/drivers/gpu/drm/i915/display/vlv_dsi.c
index b9b1fed99874..35136d26e517 100644
--- a/drivers/gpu/drm/i915/display/vlv_dsi.c
+++ b/drivers/gpu/drm/i915/display/vlv_dsi.c
@@ -1933,7 +1933,14 @@ void vlv_dsi_init(struct drm_i915_private *dev_priv)
 	else
 		intel_dsi->ports = BIT(port);
 
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.bl_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.bl_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_backlight_ports = intel_connector->panel.vbt.dsi.bl_ports;
+
+	if (drm_WARN_ON(&dev_priv->drm, intel_connector->panel.vbt.dsi.cabc_ports & ~intel_dsi->ports))
+		intel_connector->panel.vbt.dsi.cabc_ports &= intel_dsi->ports;
+
 	intel_dsi->dcs_cabc_ports = intel_connector->panel.vbt.dsi.cabc_ports;
 
 	/* Create a DSI host (and a device) for each port. */

