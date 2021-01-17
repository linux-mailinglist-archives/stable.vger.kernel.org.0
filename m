Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D4A42F92C2
	for <lists+stable@lfdr.de>; Sun, 17 Jan 2021 15:13:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728812AbhAQONL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Jan 2021 09:13:11 -0500
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:60349 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728709AbhAQONK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Jan 2021 09:13:10 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id B447B19515C8;
        Sun, 17 Jan 2021 09:12:03 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sun, 17 Jan 2021 09:12:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zpYh23
        281Ql4PNtAu3w0GihaTgWaPmNWyqgwYELIoMk=; b=f1QdzIZzTF3gVzvWZoG9/D
        sLE2LuuBHaNAjYynrPmion0b+gDWub5sLc9kUEC00X1L8+v+9RX8BGnF/jSB5Q9P
        +MrK4FKNhy61eSwANBaQCuRqUiocX2zBIkUUczJTzWKEp1uXXjKQIprlY1L3xCN0
        XiA3QcIagdX4+vsE/a4coWvsc8IhK69IcAnhMpmFgXP/WniZ/SnlreNOw3LjXc8S
        gnG5M/c06brO3SEKOzGtfR8QlMb7fXqIfJ9qRlvDyFRoZqJ3Y3hDPL5rtoaOOI5I
        24hWDQOzgsGkkU/wTUhjdtPb5qNfF0NuC3247LiicdojsBLXx0Bm9+sW1wntcJ7w
        ==
X-ME-Sender: <xms:s0UEYOlIVR075nWdmxchnZyUK4ssKmce0w1ifJd1UBe4lCMzXuSvNg>
    <xme:s0UEYF19k6m98hVsF0Wov09_i5bEO7GGKJrdK9jz-ajH8iwdL1SZRPvXNtLzxk24A
    m-d2CH7yrr8jg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrtdeigdeigecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpedvffegjeejiedtieffjeeijeffgfehvdeiudejheefge
    evhffhvedvfeeuheekleenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghen
    ucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:s0UEYMpGiuV1OZADsf46SoP23ZXv-_MOFAQdq-1lHA9rc2ap1qR6qQ>
    <xmx:s0UEYCkMlao7oZXhl_-HbNotaT3BL3Z3s61svfOjppk4vU1Q1MEH4Q>
    <xmx:s0UEYM3HcopEUls5F8PApph-ra4mMCuoyu6yV5LlCBKgwLBqfzkb1g>
    <xmx:s0UEYKAhUBNi3Aqw3SzA6-WGONJZpBbc4uB0st5DBKbu7Sxo3devUQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id C543924005A;
        Sun, 17 Jan 2021 09:12:02 -0500 (EST)
Subject: FAILED: patch "[PATCH] drm/i915/backlight: fix CPU mode backlight takeover on LPT" failed to apply to 5.4-stable tree
To:     jani.nikula@intel.com, lyude@redhat.com,
        maarten.lankhorst@linux.intel.com, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 17 Jan 2021 15:12:01 +0100
Message-ID: <161089272111136@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From bb83d5fb550bb7db75b29e6342417fda2bbb691c Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Fri, 8 Jan 2021 17:28:41 +0200
Subject: [PATCH] drm/i915/backlight: fix CPU mode backlight takeover on LPT
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The pch_get_backlight(), lpt_get_backlight(), and lpt_set_backlight()
functions operate directly on the hardware registers. If inverting the
value is needed, using intel_panel_compute_brightness(), it should only
be done in the interface between hardware registers and
panel->backlight.level.

The CPU mode takeover code added in commit 5b1ec9ac7ab5
("drm/i915/backlight: Fix backlight takeover on LPT, v3.") reads the
hardware register and converts to panel->backlight.level correctly,
however the value written back should remain in the hardware register
"domain".

This hasn't been an issue, because GM45 machines are the only known
users of i915.invert_brightness and the brightness invert quirk, and
without one of them no conversion is made. It's likely nobody's ever hit
the problem.

Fixes: 5b1ec9ac7ab5 ("drm/i915/backlight: Fix backlight takeover on LPT, v3.")
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Lyude Paul <lyude@redhat.com>
Cc: <stable@vger.kernel.org> # v5.1+
Reviewed-by: Lyude Paul <lyude@redhat.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210108152841.6944-1-jani.nikula@intel.com
(cherry picked from commit 0d4ced1c5bfe649196877d90442d4fd618e19153)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 9f23bac0d792..d64fce1a17cb 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -1650,16 +1650,13 @@ static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unus
 		val = pch_get_backlight(connector);
 	else
 		val = lpt_get_backlight(connector);
-	val = intel_panel_compute_brightness(connector, val);
-	panel->backlight.level = clamp(val, panel->backlight.min,
-				       panel->backlight.max);
 
 	if (cpu_mode) {
 		drm_dbg_kms(&dev_priv->drm,
 			    "CPU backlight register was enabled, switching to PCH override\n");
 
 		/* Write converted CPU PWM value to PCH override register */
-		lpt_set_backlight(connector->base.state, panel->backlight.level);
+		lpt_set_backlight(connector->base.state, val);
 		intel_de_write(dev_priv, BLC_PWM_PCH_CTL1,
 			       pch_ctl1 | BLM_PCH_OVERRIDE_ENABLE);
 
@@ -1667,6 +1664,10 @@ static int lpt_setup_backlight(struct intel_connector *connector, enum pipe unus
 			       cpu_ctl2 & ~BLM_PWM_ENABLE);
 	}
 
+	val = intel_panel_compute_brightness(connector, val);
+	panel->backlight.level = clamp(val, panel->backlight.min,
+				       panel->backlight.max);
+
 	return 0;
 }
 

