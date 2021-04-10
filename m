Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FEA735ADDE
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:58:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234536AbhDJN7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:59:07 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:37865 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234376AbhDJN7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:59:07 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id 07DB91940F5F;
        Sat, 10 Apr 2021 09:58:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 09:58:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=RdPXXy
        UtnWJVo6HtcVpVj+kfu8DVL1xSGaS5RM4QSTU=; b=WqIWTeXv4oD1X1WpQwwNww
        PZjJZdeBSIYD+TWuSV2oovqlurYb3I143/tXxZXPaRw/iQAD9pVrW/vtUszjp/mT
        +R7o5274XOMp641Vamq51LBPYZc4x1eCvqDNTvAnvna9Svx1k5bseGx8DJMaNId/
        3qr5e0pBN7RaktnlvFmlUfIiSB6+PcOdQPsXhPsrlrIT/9xUvguV5A/wIeCyoKO6
        fiBp+o8P5xlzGlthiHQpC3fNS1uekxvefDiiJJ6fdjd3pt0cgidY844jNV7Hqbyh
        Fd//zL4J+WZXf2zRofk0T0HPMJNYVa/DotIdMFyOj1MabJywtP25S+xq0Orsm5rg
        ==
X-ME-Sender: <xms:G69xYOLrCX5zfRYvS_dwzj5lPJEW595nLn2uPsmovPXxaHHRlC4PWQ>
    <xme:G69xYGKXdEx6wTJ6XlOn9p39UfA07hXbTQzMfQib0agiw1qkfpRGr0Qm3u0bBc_PR
    n4Z1XZvAloWBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgepfeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:G69xYOvYXs9kf_R26Of_L6Ox_ykfOjdGctS-COaeU3vioMDHkn6TBg>
    <xmx:G69xYDbqzIl2WvLDT3Ttam13hoZYfeXBqTgPIgx0jtPtu1YtlChdHA>
    <xmx:G69xYFYBuMCwCEnJUEym9QhmanB1X3DD2QjfiezYS1WuPs4jqgKWzA>
    <xmx:HK9xYEzGBoj8zqSu-XpL7srQ8-sZS-bxpVl4QXeU_iAPRFkYF6r85Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8E0FC24005B;
        Sat, 10 Apr 2021 09:58:51 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ice: prevent ice_open and ice_stop during reset" failed to apply to 4.19-stable tree
To:     krzysztof.goreczny@intel.com, anthony.l.nguyen@intel.com,
        tonyx.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:58:50 +0200
Message-ID: <161806313011134@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
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
 

