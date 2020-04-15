Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 036661A9C4D
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897001AbgDOLbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:31:49 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:57261 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2897002AbgDOLbl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:31:41 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 871B45C0148;
        Wed, 15 Apr 2020 07:31:40 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:31:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=vdodH+
        LcWHOGzjJl6glN0K4AgCfbClcf5XbUAf2vOkU=; b=GYu8Heo6nD17+pZTcYsC8s
        JYGkyxFkcA7TVgCqW+IyLL3zYu6HwPA8zoMIeX/dWt9ohHa4e5uSesNX/1msPGgk
        nvzR8YpGXyHDYJY+2oaarcxdJ9fi+ZLYOK/N98Y3LyKox1ifEfqy0HZD2va4t4zD
        6ke0XPNMxg5LEcgUXX+AtqAhVSJ84IyDQPzkJcuRMrc2qypIQ6Fiq3lD5PKXyG/a
        tgbjLK1yT7Mjie8gWAR88yRt2j96nTBIN+ph7nT0wjgsP4NGhWJJR/LbWe0XUaRw
        747GskX2tvBUeaZrkscx4LTXX9LBb6sGQP2AFz7NAhnqEwRfuCZ3SArIyWd9pDyA
        ==
X-ME-Sender: <xms:nPCWXqmFfSjGmuYggOTbdj7xcGkNvDfOT9hKbX1uHLMJLzn_V-fdvg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepheenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:nPCWXsfu00ooAGMILhX8zYUKwH8sD9LerZnMmOu9l3LTui5mfD_P0g>
    <xmx:nPCWXuoq2Qf_kBcKS9Bm-xoptXlDyHFzE9VRol0haS3R9o6QSRqe3Q>
    <xmx:nPCWXuN9xLhyt5ZyIx9ng3wNAwe4nr9zigDmYLDhOayWwT82n_oqmw>
    <xmx:nPCWXh53f-UZktTECimVxrH6VxjiOBYMqA3oaQQ7V4jwPaYyXOF66w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1C03F306005E;
        Wed, 15 Apr 2020 07:31:40 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/dp_mst: Fix clearing payload state on topology disable" failed to apply to 5.5-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, sean@poorly.run,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:31:36 +0200
Message-ID: <1586950296110251@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.5-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 8732fe46b20c951493bfc4dba0ad08efdf41de81 Mon Sep 17 00:00:00 2001
From: Lyude Paul <lyude@redhat.com>
Date: Wed, 22 Jan 2020 14:43:20 -0500
Subject: [PATCH] drm/dp_mst: Fix clearing payload state on topology disable
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

The issues caused by:

commit 64e62bdf04ab ("drm/dp_mst: Remove VCPI while disabling topology
mgr")

Prompted me to take a closer look at how we clear the payload state in
general when disabling the topology, and it turns out there's actually
two subtle issues here.

The first is that we're not grabbing &mgr.payload_lock when clearing the
payloads in drm_dp_mst_topology_mgr_set_mst(). Seeing as the canonical
lock order is &mgr.payload_lock -> &mgr.lock (because we always want
&mgr.lock to be the inner-most lock so topology validation always
works), this makes perfect sense. It also means that -technically- there
could be racing between someone calling
drm_dp_mst_topology_mgr_set_mst() to disable the topology, along with a
modeset occurring that's modifying the payload state at the same time.

The second is the more obvious issue that Wayne Lin discovered, that
we're not clearing proposed_payloads when disabling the topology.

I actually can't see any obvious places where the racing caused by the
first issue would break something, and it could be that some of our
higher-level locks already prevent this by happenstance, but better safe
then sorry. So, let's make it so that drm_dp_mst_topology_mgr_set_mst()
first grabs &mgr.payload_lock followed by &mgr.lock so that we never
race when modifying the payload state. Then, we also clear
proposed_payloads to fix the original issue of enabling a new topology
with a dirty payload state. This doesn't clear any of the drm_dp_vcpi
structures, but those are getting destroyed along with the ports anyway.

Changes since v1:
* Use sizeof(mgr->payloads[0])/sizeof(mgr->proposed_vcpis[0]) instead -
  vsyrjala

Cc: Sean Paul <sean@poorly.run>
Cc: Wayne Lin <Wayne.Lin@amd.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: stable@vger.kernel.org # v4.4+
Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200122194321.14953-1-lyude@redhat.com

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index e78c73e975ed..4104f15f4594 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -3447,6 +3447,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 	int ret = 0;
 	struct drm_dp_mst_branch *mstb = NULL;
 
+	mutex_lock(&mgr->payload_lock);
 	mutex_lock(&mgr->lock);
 	if (mst_state == mgr->mst_state)
 		goto out_unlock;
@@ -3505,7 +3506,10 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 		/* this can fail if the device is gone */
 		drm_dp_dpcd_writeb(mgr->aux, DP_MSTM_CTRL, 0);
 		ret = 0;
-		memset(mgr->payloads, 0, mgr->max_payloads * sizeof(struct drm_dp_payload));
+		memset(mgr->payloads, 0,
+		       mgr->max_payloads * sizeof(mgr->payloads[0]));
+		memset(mgr->proposed_vcpis, 0,
+		       mgr->max_payloads * sizeof(mgr->proposed_vcpis[0]));
 		mgr->payload_mask = 0;
 		set_bit(0, &mgr->payload_mask);
 		mgr->vcpi_mask = 0;
@@ -3514,6 +3518,7 @@ int drm_dp_mst_topology_mgr_set_mst(struct drm_dp_mst_topology_mgr *mgr, bool ms
 
 out_unlock:
 	mutex_unlock(&mgr->lock);
+	mutex_unlock(&mgr->payload_lock);
 	if (mstb)
 		drm_dp_mst_topology_put_mstb(mstb);
 	return ret;

