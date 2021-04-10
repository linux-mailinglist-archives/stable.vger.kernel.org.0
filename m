Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49A135ADDB
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:58:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDJN6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 09:58:44 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:52069 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234376AbhDJN6n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 09:58:43 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.nyi.internal (Postfix) with ESMTP id C92C11940F5F;
        Sat, 10 Apr 2021 09:58:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sat, 10 Apr 2021 09:58:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=ytsdYL
        Q6k8YqRjJ4cceq5YcY+GqW2ue1sxEMHkNUam8=; b=olFZU8SUpSDNwZwlBaTRK1
        gFirH0kg6X3nB/Uw0IqlhlW3lvTvJ8ssTA+Zt2T2j2esBD9I1nfGCCt+cY7OvErW
        F1PP1qbp3NBMJ3FhtCyiLOuRVXkhKNPq6f3/tulyRa7JVK6NMXgtPh/ahgnKX00A
        ynMFyG/MlU/KRarNDfF9QcLIhWLPnsww/pr7subE9M+VR8XVGnD9RIH5qagWQ+H7
        LAtwF3HNNsBynEyPtuTpnvquJTHPdIB4rK17RI/a2bfGmDeQ3oN5L1AYHH9hOEeR
        SkKJeixSLCFc6/J+M0hoab+yTIn9ftj/kytidw8c43x3eLljxT6cyB/bzNmjl2lw
        ==
X-ME-Sender: <xms:BK9xYLAh-IXuQ4LBhql616GOqG81LkorYZHUipfmy3Kw4UBLKFnwCg>
    <xme:BK9xYBiUIO9oi_JYDV28uvlMQXowFL2eMfVNVM_UpF4MSWG1D-pelzBuYGRH3FaFQ
    4aNKYvS0vK_Gg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepieetveehuedvhfdtgfdvieeiheehfeelveevheejud
    etveeuveeludejjefgteehnecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:BK9xYGn2bGMRx9nUXIvzndY7H7rUascbdWKjXlLZPa-OVKpDwxUJog>
    <xmx:BK9xYNysdrahikrQ9eEzRknUZzbdBtlu8VEGrRZ-ibk07nODvmwJEA>
    <xmx:BK9xYAQG6a7fPM4M0sQun8GbDukamtEKu3hpwikImtwwedsYg5AglA>
    <xmx:BK9xYLL3y_VweypU8uZe-NHUMNfsX0FaBAG3nE2Fs6UrLj_uROmO6w>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 43986108005F;
        Sat, 10 Apr 2021 09:58:28 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ice: Recognize 860 as iSCSI port in CEE mode" failed to apply to 5.11-stable tree
To:     chinh.t.cao@intel.com, anthony.l.nguyen@intel.com,
        tonyx.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:58:26 +0200
Message-ID: <1618063106234155@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.11-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aeac8ce864d9c0836e12ed5b5cc80f62f3cccb7c Mon Sep 17 00:00:00 2001
From: Chinh T Cao <chinh.t.cao@intel.com>
Date: Fri, 26 Feb 2021 13:19:25 -0800
Subject: [PATCH] ice: Recognize 860 as iSCSI port in CEE mode

iSCSI can use both TCP ports 860 and 3260. However, in our current
implementation, the ice_aqc_opc_get_cee_dcb_cfg (0x0A07) AQ command
doesn't provide a way to communicate the protocol port number to the
AQ's caller. Thus, we assume that 3260 is the iSCSI port number at the
AQ's caller layer.

Rely on the dcbx-willing mode, desired QoS and remote QoS configuration to
determine which port number that iSCSI will use.

Fixes: 0ebd3ff13cca ("ice: Add code for DCB initialization part 2/4")
Signed-off-by: Chinh T Cao <chinh.t.cao@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_dcb.c b/drivers/net/ethernet/intel/ice/ice_dcb.c
index e42727941ef5..211ac6f907ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_dcb.c
+++ b/drivers/net/ethernet/intel/ice/ice_dcb.c
@@ -738,22 +738,27 @@ ice_aq_get_cee_dcb_cfg(struct ice_hw *hw,
 /**
  * ice_cee_to_dcb_cfg
  * @cee_cfg: pointer to CEE configuration struct
- * @dcbcfg: DCB configuration struct
+ * @pi: port information structure
  *
  * Convert CEE configuration from firmware to DCB configuration
  */
 static void
 ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
-		   struct ice_dcbx_cfg *dcbcfg)
+		   struct ice_port_info *pi)
 {
 	u32 status, tlv_status = le32_to_cpu(cee_cfg->tlv_status);
 	u32 ice_aqc_cee_status_mask, ice_aqc_cee_status_shift;
+	u8 i, j, err, sync, oper, app_index, ice_app_sel_type;
 	u16 app_prio = le16_to_cpu(cee_cfg->oper_app_prio);
-	u8 i, err, sync, oper, app_index, ice_app_sel_type;
 	u16 ice_aqc_cee_app_mask, ice_aqc_cee_app_shift;
+	struct ice_dcbx_cfg *cmp_dcbcfg, *dcbcfg;
 	u16 ice_app_prot_id_type;
 
-	/* CEE PG data to ETS config */
+	dcbcfg = &pi->qos_cfg.local_dcbx_cfg;
+	dcbcfg->dcbx_mode = ICE_DCBX_MODE_CEE;
+	dcbcfg->tlv_status = tlv_status;
+
+	/* CEE PG data */
 	dcbcfg->etscfg.maxtcs = cee_cfg->oper_num_tc;
 
 	/* Note that the FW creates the oper_prio_tc nibbles reversed
@@ -780,10 +785,16 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 		}
 	}
 
-	/* CEE PFC data to ETS config */
+	/* CEE PFC data */
 	dcbcfg->pfc.pfcena = cee_cfg->oper_pfc_en;
 	dcbcfg->pfc.pfccap = ICE_MAX_TRAFFIC_CLASS;
 
+	/* CEE APP TLV data */
+	if (dcbcfg->app_mode == ICE_DCBX_APPS_NON_WILLING)
+		cmp_dcbcfg = &pi->qos_cfg.desired_dcbx_cfg;
+	else
+		cmp_dcbcfg = &pi->qos_cfg.remote_dcbx_cfg;
+
 	app_index = 0;
 	for (i = 0; i < 3; i++) {
 		if (i == 0) {
@@ -802,6 +813,18 @@ ice_cee_to_dcb_cfg(struct ice_aqc_get_cee_dcb_cfg_resp *cee_cfg,
 			ice_aqc_cee_app_shift = ICE_AQC_CEE_APP_ISCSI_S;
 			ice_app_sel_type = ICE_APP_SEL_TCPIP;
 			ice_app_prot_id_type = ICE_APP_PROT_ID_ISCSI;
+
+			for (j = 0; j < cmp_dcbcfg->numapps; j++) {
+				u16 prot_id = cmp_dcbcfg->app[j].prot_id;
+				u8 sel = cmp_dcbcfg->app[j].selector;
+
+				if  (sel == ICE_APP_SEL_TCPIP &&
+				     (prot_id == ICE_APP_PROT_ID_ISCSI ||
+				      prot_id == ICE_APP_PROT_ID_ISCSI_860)) {
+					ice_app_prot_id_type = prot_id;
+					break;
+				}
+			}
 		} else {
 			/* FIP APP */
 			ice_aqc_cee_status_mask = ICE_AQC_CEE_FIP_STATUS_M;
@@ -892,11 +915,8 @@ enum ice_status ice_get_dcb_cfg(struct ice_port_info *pi)
 	ret = ice_aq_get_cee_dcb_cfg(pi->hw, &cee_cfg, NULL);
 	if (!ret) {
 		/* CEE mode */
-		dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
-		dcbx_cfg->dcbx_mode = ICE_DCBX_MODE_CEE;
-		dcbx_cfg->tlv_status = le32_to_cpu(cee_cfg.tlv_status);
-		ice_cee_to_dcb_cfg(&cee_cfg, dcbx_cfg);
 		ret = ice_get_ieee_or_cee_dcb_cfg(pi, ICE_DCBX_MODE_CEE);
+		ice_cee_to_dcb_cfg(&cee_cfg, pi);
 	} else if (pi->hw->adminq.sq_last_status == ICE_AQ_RC_ENOENT) {
 		/* CEE mode not enabled try querying IEEE data */
 		dcbx_cfg = &pi->qos_cfg.local_dcbx_cfg;
diff --git a/drivers/net/ethernet/intel/ice/ice_type.h b/drivers/net/ethernet/intel/ice/ice_type.h
index a6cb0c35748c..266036b7a49a 100644
--- a/drivers/net/ethernet/intel/ice/ice_type.h
+++ b/drivers/net/ethernet/intel/ice/ice_type.h
@@ -535,6 +535,7 @@ struct ice_dcb_app_priority_table {
 #define ICE_TLV_STATUS_ERR	0x4
 #define ICE_APP_PROT_ID_FCOE	0x8906
 #define ICE_APP_PROT_ID_ISCSI	0x0cbc
+#define ICE_APP_PROT_ID_ISCSI_860 0x035c
 #define ICE_APP_PROT_ID_FIP	0x8914
 #define ICE_APP_SEL_ETHTYPE	0x1
 #define ICE_APP_SEL_TCPIP	0x2

