Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 335C36210D0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 13:33:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbiKHMde (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 07:33:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233880AbiKHMdc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 07:33:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50FA92AE4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 04:33:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E20A661530
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 12:33:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0CBC433D6;
        Tue,  8 Nov 2022 12:33:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667910810;
        bh=56xwM1VTMlKA9zt+6loanwajN0M7ZDyLSBvdDb0KpgU=;
        h=Subject:To:Cc:From:Date:From;
        b=SuITVbkPGq6YMQIYRXKluLjpYmWWSkRFXDOyQ645Non9fIXGEaLTwd4PBP11SV5XL
         MuA7oYuCtdPxk5aQZx9jNSNCXBsYByyhmhKpf+lW4s0FcMOvNCJJyTP1ZjGkvFd3cq
         VbLn6ozLQhuyatEZ5edBAcN+XljBHcSm1IcLpQ5w=
Subject: FAILED: patch "[PATCH] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to" failed to apply to 5.10-stable tree
To:     ville.syrjala@linux.intel.com, jani.nikula@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Nov 2022 13:33:15 +0100
Message-ID: <1667910795194149@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

12caf46cf4fc ("drm/i915/sdvo: Grab mode_config.mutex during LVDS init to avoid WARNs")
d372ec94a018 ("drm/i915: Simplify intel_panel_add_edid_alt_fixed_modes()")
a5810f551d0a ("drm/i915: Allow more varied alternate fixed modes for panels")
6e939738da20 ("drm/i915: Accept more fixed modes with VRR panels")
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

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 12caf46cf4fc92b1c3884cb363ace2e12732fd2f Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Wed, 26 Oct 2022 13:11:29 +0300
Subject: [PATCH] drm/i915/sdvo: Grab mode_config.mutex during LVDS init to
 avoid WARNs
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

drm_mode_probed_add() is unhappy about being called w/o
mode_config.mutex. Grab it during LVDS fixed mode setup
to silence the WARNs.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7301
Fixes: aa2b88074a56 ("drm/i915/sdvo: Fix multi function encoder stuff")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026101134.20865-4-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit a3cd4f447281c56377de2ee109327400eb00668d)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_sdvo.c b/drivers/gpu/drm/i915/display/intel_sdvo.c
index 8ee7b05ab733..774c1dc31a52 100644
--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2900,8 +2900,12 @@ intel_sdvo_lvds_init(struct intel_sdvo *intel_sdvo, int device)
 	intel_panel_add_vbt_sdvo_fixed_mode(intel_connector);
 
 	if (!intel_panel_preferred_fixed_mode(intel_connector)) {
+		mutex_lock(&i915->drm.mode_config.mutex);
+
 		intel_ddc_get_modes(connector, &intel_sdvo->ddc);
 		intel_panel_add_edid_fixed_modes(intel_connector, false);
+
+		mutex_unlock(&i915->drm.mode_config.mutex);
 	}
 
 	intel_panel_init(intel_connector);

