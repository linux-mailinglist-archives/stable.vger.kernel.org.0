Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6CDF4D8245
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240187AbiCNMCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:02:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240151AbiCNMB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:01:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B05B49F03;
        Mon, 14 Mar 2022 04:59:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B16F3B80DEB;
        Mon, 14 Mar 2022 11:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F58CC340E9;
        Mon, 14 Mar 2022 11:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647259167;
        bh=tlfAzj95ogoP59pLLyQyntAK5OM6zcOaEu3StMhc7GM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jllImPEzMmvZwgTDzh+9UnYwJz4rUS2x4SPhmyNHWSLHenrs5uYlUC9BkE+EgoNwK
         FY/SVy9Y48PYyRC73isdCHnhD5VFKFOQ+g9h9V7+mk/9BC9ZWxvzWUvNzf61bYeuul
         7msFMFmQBWkzCgpnuucIZIwn0fSnGrtXua2xKUJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/71] ice: Align macro names to the specification
Date:   Mon, 14 Mar 2022 12:53:11 +0100
Message-Id: <20220314112738.442613555@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112737.929694832@linuxfoundation.org>
References: <20220314112737.929694832@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>

[ Upstream commit d6730a871e68f10c786cdee59aebd6f92d49d249 ]

For get PHY abilities AQ, the specification defines "report modes"
as "with media", "without media" and "active configuration". For
clarity, rename macros to align with the specification.

Signed-off-by: Anirudh Venkataramanan <anirudh.venkataramanan@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 10 +++++-----
 drivers/net/ethernet/intel/ice/ice_common.c     | 13 +++++++------
 drivers/net/ethernet/intel/ice/ice_ethtool.c    | 12 ++++++------
 drivers/net/ethernet/intel/ice/ice_main.c       | 12 ++++++------
 4 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index b06fbe99d8e9..b6dd8f81d699 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -870,11 +870,11 @@ struct ice_aqc_get_phy_caps {
 	 * 01b - Report topology capabilities
 	 * 10b - Report SW configured
 	 */
-#define ICE_AQC_REPORT_MODE_S		1
-#define ICE_AQC_REPORT_MODE_M		(3 << ICE_AQC_REPORT_MODE_S)
-#define ICE_AQC_REPORT_NVM_CAP		0
-#define ICE_AQC_REPORT_TOPO_CAP		BIT(1)
-#define ICE_AQC_REPORT_SW_CFG		BIT(2)
+#define ICE_AQC_REPORT_MODE_S			1
+#define ICE_AQC_REPORT_MODE_M			(3 << ICE_AQC_REPORT_MODE_S)
+#define ICE_AQC_REPORT_TOPO_CAP_NO_MEDIA	0
+#define ICE_AQC_REPORT_TOPO_CAP_MEDIA		BIT(1)
+#define ICE_AQC_REPORT_ACTIVE_CFG		BIT(2)
 	__le32 reserved1;
 	__le32 addr_high;
 	__le32 addr_low;
diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 2b0d0373ab2c..ecdc467c4f6f 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -193,7 +193,7 @@ ice_aq_get_phy_caps(struct ice_port_info *pi, bool qual_mods, u8 report_mode,
 	ice_debug(hw, ICE_DBG_LINK, "   module_type[2] = 0x%x\n",
 		  pcaps->module_type[2]);
 
-	if (!status && report_mode == ICE_AQC_REPORT_TOPO_CAP) {
+	if (!status && report_mode == ICE_AQC_REPORT_TOPO_CAP_MEDIA) {
 		pi->phy.phy_type_low = le64_to_cpu(pcaps->phy_type_low);
 		pi->phy.phy_type_high = le64_to_cpu(pcaps->phy_type_high);
 		memcpy(pi->phy.link_info.module_type, &pcaps->module_type,
@@ -924,7 +924,8 @@ enum ice_status ice_init_hw(struct ice_hw *hw)
 
 	/* Initialize port_info struct with PHY capabilities */
 	status = ice_aq_get_phy_caps(hw->port_info, false,
-				     ICE_AQC_REPORT_TOPO_CAP, pcaps, NULL);
+				     ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
+				     NULL);
 	devm_kfree(ice_hw_to_dev(hw), pcaps);
 	if (status)
 		goto err_unroll_sched;
@@ -2682,7 +2683,7 @@ enum ice_status ice_update_link_info(struct ice_port_info *pi)
 		if (!pcaps)
 			return ICE_ERR_NO_MEMORY;
 
-		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
+		status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 					     pcaps, NULL);
 
 		devm_kfree(ice_hw_to_dev(hw), pcaps);
@@ -2842,8 +2843,8 @@ ice_set_fc(struct ice_port_info *pi, u8 *aq_failures, bool ena_auto_link_update)
 		return ICE_ERR_NO_MEMORY;
 
 	/* Get the current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
-				     NULL);
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG,
+				     pcaps, NULL);
 	if (status) {
 		*aq_failures = ICE_SET_FC_AQ_FAIL_GET;
 		goto out;
@@ -2989,7 +2990,7 @@ ice_cfg_phy_fec(struct ice_port_info *pi, struct ice_aqc_set_phy_cfg_data *cfg,
 	if (!pcaps)
 		return ICE_ERR_NO_MEMORY;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
 				     NULL);
 	if (status)
 		goto out;
diff --git a/drivers/net/ethernet/intel/ice/ice_ethtool.c b/drivers/net/ethernet/intel/ice/ice_ethtool.c
index 14eba9bc174d..be02f8f4d854 100644
--- a/drivers/net/ethernet/intel/ice/ice_ethtool.c
+++ b/drivers/net/ethernet/intel/ice/ice_ethtool.c
@@ -1081,7 +1081,7 @@ ice_get_fecparam(struct net_device *netdev, struct ethtool_fecparam *fecparam)
 	if (!caps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 				     caps, NULL);
 	if (status) {
 		err = -EAGAIN;
@@ -1976,7 +1976,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		return -ENOMEM;
 
 	status = ice_aq_get_phy_caps(vsi->port_info, false,
-				     ICE_AQC_REPORT_SW_CFG, caps, NULL);
+				     ICE_AQC_REPORT_ACTIVE_CFG, caps, NULL);
 	if (status) {
 		err = -EIO;
 		goto done;
@@ -2013,7 +2013,7 @@ ice_get_link_ksettings(struct net_device *netdev,
 		ethtool_link_ksettings_add_link_mode(ks, advertising, FEC_RS);
 
 	status = ice_aq_get_phy_caps(vsi->port_info, false,
-				     ICE_AQC_REPORT_TOPO_CAP, caps, NULL);
+				     ICE_AQC_REPORT_TOPO_CAP_MEDIA, caps, NULL);
 	if (status) {
 		err = -EIO;
 		goto done;
@@ -2225,7 +2225,7 @@ ice_set_link_ksettings(struct net_device *netdev,
 		return -ENOMEM;
 
 	/* Get the PHY capabilities based on media */
-	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP,
+	status = ice_aq_get_phy_caps(p, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA,
 				     abilities, NULL);
 	if (status) {
 		err = -EAGAIN;
@@ -2954,7 +2954,7 @@ ice_get_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		return;
 
 	/* Get current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				     NULL);
 	if (status)
 		goto out;
@@ -3021,7 +3021,7 @@ ice_set_pauseparam(struct net_device *netdev, struct ethtool_pauseparam *pause)
 		return -ENOMEM;
 
 	/* Get current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				     NULL);
 	if (status) {
 		kfree(pcaps);
diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index 6c75df216fa7..20c9d55f3adc 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -726,7 +726,7 @@ void ice_print_link_msg(struct ice_vsi *vsi, bool isup)
 	}
 
 	status = ice_aq_get_phy_caps(vsi->port_info, false,
-				     ICE_AQC_REPORT_SW_CFG, caps, NULL);
+				     ICE_AQC_REPORT_ACTIVE_CFG, caps, NULL);
 	if (status)
 		netdev_info(vsi->netdev, "Get phy capability failed.\n");
 
@@ -1645,7 +1645,7 @@ static int ice_force_phys_link_state(struct ice_vsi *vsi, bool link_up)
 	if (!pcaps)
 		return -ENOMEM;
 
-	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	retcode = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				      NULL);
 	if (retcode) {
 		dev_err(dev, "Failed to get phy capabilities, VSI %d error %d\n",
@@ -1705,7 +1705,7 @@ static int ice_init_nvm_phy_type(struct ice_port_info *pi)
 	if (!pcaps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_NVM_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_NO_MEDIA, pcaps,
 				     NULL);
 
 	if (status) {
@@ -1821,7 +1821,7 @@ static int ice_init_phy_user_cfg(struct ice_port_info *pi)
 	if (!pcaps)
 		return -ENOMEM;
 
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
 				     NULL);
 	if (status) {
 		dev_err(ice_pf_to_dev(pf), "Get PHY capability failed.\n");
@@ -1900,7 +1900,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 		return -ENOMEM;
 
 	/* Get current PHY config */
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_SW_CFG, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_ACTIVE_CFG, pcaps,
 				     NULL);
 	if (status) {
 		dev_err(dev, "Failed to get PHY configuration, VSI %d error %s\n",
@@ -1918,7 +1918,7 @@ static int ice_configure_phy(struct ice_vsi *vsi)
 
 	/* Use PHY topology as baseline for configuration */
 	memset(pcaps, 0, sizeof(*pcaps));
-	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP, pcaps,
+	status = ice_aq_get_phy_caps(pi, false, ICE_AQC_REPORT_TOPO_CAP_MEDIA, pcaps,
 				     NULL);
 	if (status) {
 		dev_err(dev, "Failed to get PHY topology, VSI %d error %s\n",
-- 
2.34.1



