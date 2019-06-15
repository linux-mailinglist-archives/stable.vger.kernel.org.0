Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E93F47151
	for <lists+stable@lfdr.de>; Sat, 15 Jun 2019 18:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726405AbfFOQwp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Jun 2019 12:52:45 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:40703 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725944AbfFOQwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Jun 2019 12:52:45 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7DB44402;
        Sat, 15 Jun 2019 12:52:43 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Sat, 15 Jun 2019 12:52:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DU4vJr
        4xvtQKPz+zckft5FmGyTfUUDXdt+hmB0gyjl0=; b=TGfFSQWpZqZYhvs+pgS3pf
        XixSlguh1SK+38AhXZhyPFMqKUYq7ipw+YfI13cDiK4F7p73Lm/hdi/JUbnf8YXV
        sngWwYKISYKFa6wL5C+xF169gwxg1jbZAtrLyBSFPgSV5Z+YDZR9hyUyAonK4Ulk
        bumgsG54ucuHoj6JdLIwKsBP5I9KmP5x2F4QJv6I0XHx30gwWhsbcY/gHmtmyTxE
        4VtW4oXGOZ4h/T1x7L4FcZtjSisaOazZvh4ns3mwdbbuYhRlvyFQiF1h2gixg4hl
        54ZteckNpGomOMBkdWtwBKA8qbNsZsZGwAs8DNHYNYRQSenkj+EJiKAUiMSVEynw
        ==
X-ME-Sender: <xms:WSIFXYpb4aAPMnESur80HtIRiPZedwVpcQ48Db-T0KoVpRAk_M3zZA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeifedguddtjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghdpmhgrihhlqdgrrh
    gthhhivhgvrdgtohhmnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehm
    rghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivg
    eptd
X-ME-Proxy: <xmx:WSIFXR86Q1y0xkdk2E8SHfblmlsu6AmUwyW9vNFmAIKbukiKVnKQJg>
    <xmx:WSIFXZCH_Rv_Lub-NdKpTaE6jg0-aQ63ly0_9OmeDlYWJ4K5Y2Nf4g>
    <xmx:WSIFXTHCtZkCzzdFpHvB400s9o6TlU-sHOk_yzrJbqehVOxzsj-K4Q>
    <xmx:WiIFXXKBBjmncxduCPSPmblFqDNh_GoE1yQkzG0UZiFeiXJdQbMICQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C359A380086;
        Sat, 15 Jun 2019 12:52:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm: add fallback override/firmware EDID modes workaround" failed to apply to 5.1-stable tree
To:     jani.nikula@intel.com, daniel.vetter@ffwll.ch,
        harish.chegondi@intel.com, ilpo.jarvinen@cs.helsinki.fi,
        pabs3@bonedaddy.net, stable@vger.kernel.org,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 15 Jun 2019 18:52:38 +0200
Message-ID: <156061755857126@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.1-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 48eaeb7664c76139438724d520a1ea4a84a3ed92 Mon Sep 17 00:00:00 2001
From: Jani Nikula <jani.nikula@intel.com>
Date: Mon, 10 Jun 2019 12:30:54 +0300
Subject: [PATCH] drm: add fallback override/firmware EDID modes workaround
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We've moved the override and firmware EDID (simply "override EDID" from
now on) handling to the low level drm_do_get_edid() function in order to
transparently use the override throughout the stack. The idea is that
you get the override EDID via the ->get_modes() hook.

Unfortunately, there are scenarios where the DDC probe in drm_get_edid()
called via ->get_modes() fails, although the preceding ->detect()
succeeds.

In the case reported by Paul Wise, the ->detect() hook,
intel_crt_detect(), relies on hotplug detect, bypassing the DDC. In the
case reported by Ilpo Järvinen, there is no ->detect() hook, which is
interpreted as connected. The subsequent DDC probe reached via
->get_modes() fails, and we don't even look at the override EDID,
resulting in no modes being added.

Because drm_get_edid() is used via ->detect() all over the place, we
can't trivially remove the DDC probe, as it leads to override EDID
effectively meaning connector forcing. The goal is that connector
forcing and override EDID remain orthogonal.

Generally, the underlying problem here is the conflation of ->detect()
and ->get_modes() via drm_get_edid(). The former should just detect, and
the latter should just get the modes, typically via reading the EDID. As
long as drm_get_edid() is used in ->detect(), it needs to retain the DDC
probe. Or such users need to have a separate DDC probe step first.

The EDID caching between ->detect() and ->get_modes() done by some
drivers is a further complication that prevents us from making
drm_do_get_edid() adapt to the two cases.

Work around the regression by falling back to a separate attempt at
getting the override EDID at drm_helper_probe_single_connector_modes()
level. With a working DDC and override EDID, it'll never be called; the
override EDID will come via ->get_modes(). There will still be a failing
DDC probe attempt in the cases that require the fallback.

v2:
- Call drm_connector_update_edid_property (Paul)
- Update commit message about EDID caching (Daniel)

Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=107583
Reported-by: Paul Wise <pabs3@bonedaddy.net>
Cc: Paul Wise <pabs3@bonedaddy.net>
References: http://mid.mail-archive.com/alpine.DEB.2.20.1905262211270.24390@whs-18.cs.helsinki.fi
Reported-by: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Cc: Ilpo Järvinen <ilpo.jarvinen@cs.helsinki.fi>
Suggested-by: Daniel Vetter <daniel.vetter@ffwll.ch>
References: 15f080f08d48 ("drm/edid: respect connector force for drm_get_edid ddc probe")
Fixes: 53fd40a90f3c ("drm: handle override and firmware EDID at drm_do_get_edid() level")
Cc: <stable@vger.kernel.org> # v4.15+ 56a2b7f2a39a drm/edid: abstract override/firmware EDID retrieval
Cc: <stable@vger.kernel.org> # v4.15+
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Harish Chegondi <harish.chegondi@intel.com>
Tested-by: Paul Wise <pabs3@bonedaddy.net>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190610093054.28445-1-jani.nikula@intel.com

diff --git a/drivers/gpu/drm/drm_edid.c b/drivers/gpu/drm/drm_edid.c
index c1952b6e5747..e804ac5dec02 100644
--- a/drivers/gpu/drm/drm_edid.c
+++ b/drivers/gpu/drm/drm_edid.c
@@ -1584,6 +1584,36 @@ static struct edid *drm_get_override_edid(struct drm_connector *connector)
 	return IS_ERR(override) ? NULL : override;
 }
 
+/**
+ * drm_add_override_edid_modes - add modes from override/firmware EDID
+ * @connector: connector we're probing
+ *
+ * Add modes from the override/firmware EDID, if available. Only to be used from
+ * drm_helper_probe_single_connector_modes() as a fallback for when DDC probe
+ * failed during drm_get_edid() and caused the override/firmware EDID to be
+ * skipped.
+ *
+ * Return: The number of modes added or 0 if we couldn't find any.
+ */
+int drm_add_override_edid_modes(struct drm_connector *connector)
+{
+	struct edid *override;
+	int num_modes = 0;
+
+	override = drm_get_override_edid(connector);
+	if (override) {
+		drm_connector_update_edid_property(connector, override);
+		num_modes = drm_add_edid_modes(connector, override);
+		kfree(override);
+
+		DRM_DEBUG_KMS("[CONNECTOR:%d:%s] adding %d modes via fallback override/firmware EDID\n",
+			      connector->base.id, connector->name, num_modes);
+	}
+
+	return num_modes;
+}
+EXPORT_SYMBOL(drm_add_override_edid_modes);
+
 /**
  * drm_do_get_edid - get EDID data using a custom EDID block read function
  * @connector: connector we're probing
diff --git a/drivers/gpu/drm/drm_probe_helper.c b/drivers/gpu/drm/drm_probe_helper.c
index 6fd08e04b323..dd427c7ff967 100644
--- a/drivers/gpu/drm/drm_probe_helper.c
+++ b/drivers/gpu/drm/drm_probe_helper.c
@@ -479,6 +479,13 @@ int drm_helper_probe_single_connector_modes(struct drm_connector *connector,
 
 	count = (*connector_funcs->get_modes)(connector);
 
+	/*
+	 * Fallback for when DDC probe failed in drm_get_edid() and thus skipped
+	 * override/firmware EDID.
+	 */
+	if (count == 0 && connector->status == connector_status_connected)
+		count = drm_add_override_edid_modes(connector);
+
 	if (count == 0 && connector->status == connector_status_connected)
 		count = drm_add_modes_noedid(connector, 1024, 768);
 	count += drm_helper_probe_add_cmdline_mode(connector);
diff --git a/include/drm/drm_edid.h b/include/drm/drm_edid.h
index 9d3b5b93102c..c9ca0be54d9a 100644
--- a/include/drm/drm_edid.h
+++ b/include/drm/drm_edid.h
@@ -471,6 +471,7 @@ struct edid *drm_get_edid_switcheroo(struct drm_connector *connector,
 				     struct i2c_adapter *adapter);
 struct edid *drm_edid_duplicate(const struct edid *edid);
 int drm_add_edid_modes(struct drm_connector *connector, struct edid *edid);
+int drm_add_override_edid_modes(struct drm_connector *connector);
 
 u8 drm_match_cea_mode(const struct drm_display_mode *to_match);
 enum hdmi_picture_aspect drm_get_cea_aspect_ratio(const u8 video_code);

