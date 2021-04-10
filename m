Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FDC235ADDF
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234548AbhDJN7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:59:15 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:60799 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234376AbhDJN7P (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:59:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 538CE1940F5F;
        Sat, 10 Apr 2021 09:59:00 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 09:59:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=c0Oo9F
        a6qMegIDwGxIS+m20SDFGU+SjKDVFwsrlVbVI=; b=UqyLREARyF/OcKWAIFI5OV
        AC6kF2pKAeVtZjz5n67HVPGq2mTGuqJA5EwqjRDQASZBKumwoQGAAB/e430/ShNU
        NVR61/IODQjcFpOcheJDfnA4CNznfTGqn9rDA82ShNx/49JrjiNldA1DHw4OL233
        33G19OIspJNsR5qFI+v0HVDKOqeyXTdP87AAZ4ukSQNa3nqTt2fWau8h+d1k9y3d
        7F13k+dY1WmuZ2SITAl+ZrWmpKWMczoDMgeCAkJWX5JK8jQFn+krbomI8b9DHXZ+
        VuFuWv7x5AJm0M3BaEjiTNjw329+Yig+b+loVtNj0h9n07h+3dNU4gz3LLVz05VA
        ==
X-ME-Sender: <xms:JK9xYEDFJI7qqYOc5VEOmx2uSatQVL7c4QCfa8qzCBDbylkNAGeCqQ>
    <xme:JK9xYGiY1S0AJFNRXnC1VmKG3dF8tw6DqHZyIws9II1trlvVsGwAIhhzQrrmeN3kI
    0tvEHK23IijFg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepgeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:JK9xYHmsHxIn5d-7Wpd5Fb7yaOhDnXFlUMvshuDwJ6JRB27Smd6UcQ>
    <xmx:JK9xYKyR4F4oHaa0ZvqC6qiZccaF_3ceJJMd8a4JwI2nIK2fAyXn4Q>
    <xmx:JK9xYJRSUtci0iZuOdq7mTlDH3IUA0F5bY_B0iSu2ybSaz33MPSFeQ>
    <xmx:JK9xYIKmn7L0Jy008pZf7vFaXppdsPSgcT9Unvbo24epsBAcLJmVRA>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 02B771080057;
        Sat, 10 Apr 2021 09:58:59 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ice: prevent ice_open and ice_stop during reset" failed to apply to 5.4-stable tree
To:     krzysztof.goreczny@intel.com, anthony.l.nguyen@intel.com,
        tonyx.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:58:50 +0200
Message-ID: <161806313022028@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From e95fc8573e07c5e4825df4650fd8b8c93fad27a7 Mon Sep 17 00:00:00 2001
From: Krzysztof Goreczny <krzysztof.goreczny@intel.com>
Date: Fri, 26 Feb 2021 13:19:26 -0800
Subject: [PATCH] ice: prevent ice_open and ice_stop during reset

There is a possibility of race between ice_open or ice_stop calls
performed by OS and reset handling routine both trying to modify VSI
resources. Observed scenarios:
- reset handler deallocates memory in ice_vsi_free_arrays and ice_open
  tries to access it in ice_vsi_cfg_txq leading to driver crash
- reset handler deallocates memory in ice_vsi_free_arrays and ice_close
  tries to access it in ice_down leading to driver crash
- reset handler clears port scheduler topology and sets port state to
  ICE_SCHED_PORT_STATE_INIT leading to ice_ena_vsi_txq fail in ice_open

To prevent this additional checks in ice_open and ice_stop are
introduced to make sure that OS is not allowed to alter VSI config while
reset is in progress.

Fixes: cdedef59deb0 ("ice: Configure VSIs for Tx/Rx")
Signed-off-by: Krzysztof Goreczny <krzysztof.goreczny@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice.h b/drivers/net/ethernet/intel/ice/ice.h
index 357706444dd5..1d4518638215 100644
--- a/drivers/net/ethernet/intel/ice/ice.h
+++ b/drivers/net/ethernet/intel/ice/ice.h
@@ -642,6 +642,7 @@ int ice_fdir_create_dflt_rules(struct ice_pf *pf);
 int ice_aq_wait_for_event(struct ice_pf *pf, u16 opcode, unsigned long timeout,
 			  struct ice_rq_event_info *event);
 int ice_open(struct net_device *netdev);
+int ice_open_internal(struct net_device *netdev);
 int ice_stop(struct net_device *netdev);
 void ice_service_task_schedule(struct ice_pf *pf);
 
diff --git a/drivers/net/ethernet/intel/ice/ice_lib.c b/drivers/net/ethernet/intel/ice/ice_lib.c
index 8d4e2ad4328d..7ac2beaed95c 100644
--- a/drivers/net/ethernet/intel/ice/ice_lib.c
+++ b/drivers/net/ethernet/intel/ice/ice_lib.c
@@ -2620,7 +2620,7 @@ int ice_ena_vsi(struct ice_vsi *vsi, bool locked)
 			if (!locked)
 				rtnl_lock();
 
-			err = ice_open(vsi->netdev);
+			err = ice_open_internal(vsi->netdev);
 
 			if (!locked)
 				rtnl_unlock();
@@ -2649,7 +2649,7 @@ void ice_dis_vsi(struct ice_vsi *vsi, bool locked)
 			if (!locked)
 				rtnl_lock();
 
-			ice_stop(vsi->netdev);
+			ice_vsi_close(vsi);
 
 			if (!locked)
 				rtnl_unlock();
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 53e053c997eb..255a07c1e33a 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -6632,6 +6632,28 @@ static void ice_tx_timeout(struct net_device *netdev, unsigned int txqueue)
  * Returns 0 on success, negative value on failure
  */
 int ice_open(struct net_device *netdev)
+{
+	struct ice_netdev_priv *np = netdev_priv(netdev);
+	struct ice_pf *pf = np->vsi->back;
+
+	if (ice_is_reset_in_progress(pf->state)) {
+		netdev_err(netdev, "can't open net device while reset is in progress");
+		return -EBUSY;
+	}
+
+	return ice_open_internal(netdev);
+}
+
+/**
+ * ice_open_internal - Called when a network interface becomes active
+ * @netdev: network interface device structure
+ *
+ * Internal ice_open implementation. Should not be used directly except for ice_open and reset
+ * handling routine
+ *
+ * Returns 0 on success, negative value on failure
+ */
+int ice_open_internal(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
@@ -6712,6 +6734,12 @@ int ice_stop(struct net_device *netdev)
 {
 	struct ice_netdev_priv *np = netdev_priv(netdev);
 	struct ice_vsi *vsi = np->vsi;
+	struct ice_pf *pf = vsi->back;
+
+	if (ice_is_reset_in_progress(pf->state)) {
+		netdev_err(netdev, "can't stop net device while reset is in progress");
+		return -EBUSY;
+	}
 
 	ice_vsi_close(vsi);
 

