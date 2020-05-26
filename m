Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA5A1A9C50
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 13:31:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897002AbgDOLbx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 07:31:53 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:53031 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2896999AbgDOLbg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Apr 2020 07:31:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id AA2605C00AF;
        Wed, 15 Apr 2020 07:31:35 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 15 Apr 2020 07:31:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HJl2EE
        AU7TOdP/nGm3230yPGW8WFHNmxmPdJry80g9I=; b=DB+c4Zi/ZfC2hlnw+Vq4zm
        Nz/nMBD3PGUOu9DpGRUC23QqNKtYyB6n2Sm6gZTVkDnZ0Uqd4PoY1Fb/Y1CSRIJf
        wGNwZmJbh1S5E46hl5j6VGMyvFkobmVC6mj1x5putmICgm/BHmOtCpgxJbBqqqTR
        Ilv9QNPLFmeQOpKkSgsNfePeAp+IcKgX5BlRu0XXYxRiSC51GFMMOrEON57HT4Ed
        qgV1UBEA8OILwwtdz4BZtdqrwECaHNg7/52LYRCsecCuWShHVGSP+s3b4B88NQCI
        baUIZMx5bkYm2iADostkBitcR2FrtyQ6F7abCNGH8dvOOKeUASMOEX7BuT2q2M0Q
        ==
X-ME-Sender: <xms:l_CWXrDX_upJtfgrm8UweS3L73CbCvYGng0jZV5ELdklKNWeQZ_csQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrfeefgddvlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    ejnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepfhhrvggvuggvshhkthhophdrohhrghenucfkphepkeefrdekie
    drkeelrddutdejnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:l_CWXgNUcpsPOjuJJ0yGVTPxn1bRjet8a_HdpgKv-piIrDk22u5WMw>
    <xmx:l_CWXp5ZoLRcq3TCWOqsPTUktJupQl4tYIYYEQu5UJNbBYFUNZP3bg>
    <xmx:l_CWXqqDQL-jzSc-9CLD6QqiNBYAYoL2pgisrfh7Q94_ZRCjfZwU_Q>
    <xmx:l_CWXlKR1AVXdXehtVGtMa9fbORcnKn1HqE7fD8T4GJqwYwgNGwLLQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3F4C3306005C;
        Wed, 15 Apr 2020 07:31:35 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/dp_mst: Fix clearing payload state on topology disable" failed to apply to 4.14-stable tree
To:     lyude@redhat.com, Wayne.Lin@amd.com, sean@poorly.run,
        ville.syrjala@linux.intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 15 Apr 2020 13:31:32 +0200
Message-ID: <1586950292161122@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.14-stable tree.
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

