Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 998A9A7306
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 21:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725883AbfICTDB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 15:03:01 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:39991 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725882AbfICTDB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 15:03:01 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id E3409210AC;
        Tue,  3 Sep 2019 15:03:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 03 Sep 2019 15:03:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=fUWglh
        eU+MRjrdPqM0UPQ0pXdB7orVFD7lOHxYEbOF0=; b=Q3d6CVd4NO152RmCQVm+ZY
        1404D/hsKO8xzARa1iHfvvIcLIwGGaBv6xQZdlJ6oxD5JeZqDDRZIH3HyJ//g1mj
        AmcJqH1za3Vr39teg1t6oMIsN3rvhb0gd8iAD/HRG3jaJqvWbrq8+Cr+Xx1sKanG
        7c1S9Wu/ohtarLJOa9sWA2ORD04FrRnkWHk2czVqqkOp2stlTKmf6CEvBza7B1kO
        ivLi2uiTRrj6RjpL+CK9XxfSIk4nX7sFR2WIRwxFCnmgfa7h15oJV8oTknraUUHg
        ORpVgJEpnjH5YHNaJlnPow1ns3pIt5tRE6nhCBSdO9/1EhnKjsPOwEMrmc40RF5A
        ==
X-ME-Sender: <xms:47huXTducrSp7ehihdmUzlhiRjsHDbDa4k4rZ9mkdIRaW4-ZidKmOQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudejfedguddtfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghdplhhirghmugdrtg
    homhenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:47huXTRiXImreCYMeRxsisGoWGheIj6j9V4HAnEbenA3TNU1S0XekA>
    <xmx:47huXRfUKiqdwDwGHp11dqpuKgajy65Aa4VBSxshg09HjGNeFLPgPA>
    <xmx:47huXcva6l9X2LojkotIhg4wEzi_0ZOjBJIiZQ8wXAQ6AXFxLKeOCA>
    <xmx:5LhuXTY6cufzPD6_sotefzLrieajtTC8R7aXUinRnfNpXfrBeXzX4A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 48CC280059;
        Tue,  3 Sep 2019 15:02:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915: Do not create a new max_bpc prop for MST connectors" failed to apply to 5.2-stable tree
To:     ville.syrjala@linux.intel.com, daniel.vetter@ffwll.ch,
        jani.nikula@intel.com, jose.souza@intel.com, lyude@redhat.com,
        sean@poorly.run
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 03 Sep 2019 21:02:58 +0200
Message-ID: <156753737870202@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.2-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From ed5fa90660d63bcec4c3a62b03fed9427418b53d Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Tue, 20 Aug 2019 19:16:57 +0300
Subject: [PATCH] drm/i915: Do not create a new max_bpc prop for MST connectors
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

We're not allowed to create new properties after device registration
so for MST connectors we need to either create the max_bpc property
earlier, or we reuse one we already have. Let's do the latter apporach
since the corresponding SST connector already has the prop and its
min/max are correct also for the MST connector.

The problem was highlighted by commit 4f5368b5541a ("drm/kms:
Catch mode_object lifetime errors") which results in the following
spew:
[ 1330.878941] WARNING: CPU: 2 PID: 1554 at drivers/gpu/drm/drm_mode_object.c:45 __drm_mode_object_add+0xa0/0xb0 [drm]
...
[ 1330.879008] Call Trace:
[ 1330.879023]  drm_property_create+0xba/0x180 [drm]
[ 1330.879036]  drm_property_create_range+0x15/0x30 [drm]
[ 1330.879048]  drm_connector_attach_max_bpc_property+0x62/0x80 [drm]
[ 1330.879086]  intel_dp_add_mst_connector+0x11f/0x140 [i915]
[ 1330.879094]  drm_dp_add_port.isra.20+0x20b/0x440 [drm_kms_helper]
...

Cc: stable@vger.kernel.org
Cc: Lyude Paul <lyude@redhat.com>
Cc: sunpeng.li@amd.com
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Sean Paul <sean@poorly.run>
Fixes: 5ca0ef8a56b8 ("drm/i915: Add max_bpc property for DP MST")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190820161657.9658-1-ville.syrjala@linux.intel.com
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
(cherry picked from commit 1b9bd09630d4db4827cc04d358a41a16a6bc2cb0)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/display/intel_dp_mst.c b/drivers/gpu/drm/i915/display/intel_dp_mst.c
index 60652ebbdf61..18e4cba76720 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_mst.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_mst.c
@@ -539,7 +539,15 @@ static struct drm_connector *intel_dp_add_mst_connector(struct drm_dp_mst_topolo
 
 	intel_attach_force_audio_property(connector);
 	intel_attach_broadcast_rgb_property(connector);
-	drm_connector_attach_max_bpc_property(connector, 6, 12);
+
+	/*
+	 * Reuse the prop from the SST connector because we're
+	 * not allowed to create new props after device registration.
+	 */
+	connector->max_bpc_property =
+		intel_dp->attached_connector->base.max_bpc_property;
+	if (connector->max_bpc_property)
+		drm_connector_attach_max_bpc_property(connector, 6, 12);
 
 	return connector;
 

