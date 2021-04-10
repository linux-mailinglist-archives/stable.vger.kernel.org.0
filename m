Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E01D35ADE2
	for <lists+stable@lfdr.de>; Sat, 10 Apr 2021 15:59:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234733AbhDJOAC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Apr 2021 10:00:02 -0400
Received: from forward3-smtp.messagingengine.com ([66.111.4.237]:38959 "EHLO
        forward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234376AbhDJOAC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Apr 2021 10:00:02 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id BDB7E194112B;
        Sat, 10 Apr 2021 09:59:47 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Sat, 10 Apr 2021 09:59:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=n4OEBo
        JyHGFLCc2P91QNfIvgKCEtjgu5I+YPobcA7TA=; b=gIzY8XodD5KpvW/JfQH1RP
        lj4vv1E9WmHIXC3/1kdM2W7Cd0/Yxhzzbxy32GvEmKNZvBMynJE3A0Liye9rhLdr
        +PC9GoJCoRtPETUjWO/245HijrE8cR+62pAVRVTH9eDxzNoTXAIgWPo7iy2hf1T+
        qYG47znZuPcKnEwibIT2ODP8EFT7b2XJtwlUwCy/s89wM2/xtLgTty2dUPszQJuu
        Wr3i80ObhB4XnuwaI9FOXiIoJc2D6QSUMVgnSP5W9pucqDfGuJKDrmIakXo6u0eq
        qlvdu1s0MvYHM2uFAlNMikbWKBGYPfaxhy1C11vEF6MOMDlBqx/ytpBU495MnulA
        ==
X-ME-Sender: <xms:U69xYN7U6sfR2kNhKWf4s3G-JbkbwARG0-k1malR9B9GexNMzhcL8w>
    <xme:U69xYPILCXyfcpIUEtoBC002G8nAlfJsw5M5a26qtWVm8_FADKarP5AvkC67zPxEs
    ZT4QN5og5vVtQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekfedgjedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtjeenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepheeggfeuvdehjeffieehheeuvdejfefhgeevgfegvd
    euudefveegffeuvdetleeunecukfhppeekfedrkeeirdejgedrieegnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:U69xYPduWJHioOaUDUi5TM8IYldEMR8h8JnA_h08AT7etDVe83VSXg>
    <xmx:U69xYKcyDOPEcVyUoZSxclNVbyYeyNvNyCY2sbaUhVCpGpfZOM9AqQ>
    <xmx:U69xYKM6O_6xFP6JKIKc8Nv1g_2UMK3KvNGG_ccwr0J19WoY-1aNyQ>
    <xmx:U69xYLLSh7zOXV1QFQnlwuachGcPE167E9WdwI3JBNTKHj9UF6BBlQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2278C108005F;
        Sat, 10 Apr 2021 09:59:47 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ice: Fix for dereference of NULL pointer" failed to apply to 4.19-stable tree
To:     jacekx.bulatek@intel.com, anthony.l.nguyen@intel.com,
        haiyue.wang@intel.com, tonyx.brelinski@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Apr 2021 15:59:45 +0200
Message-ID: <1618063185234184@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From 7a91d3f02b04b2fb18c2dfa8b6c4e5a40a2753f5 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Jacek=20Bu=C5=82atek?= <jacekx.bulatek@intel.com>
Date: Fri, 26 Feb 2021 13:19:29 -0800
Subject: [PATCH] ice: Fix for dereference of NULL pointer
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add handling of allocation fault for ice_vsi_list_map_info.

Also *fi should not be NULL pointer, it is a reference to raw
data field, so remove this variable and use the reference
directly.

Fixes: 9daf8208dd4d ("ice: Add support for switch filter programming")
Signed-off-by: Jacek Bułatek <jacekx.bulatek@intel.com>
Co-developed-by: Haiyue Wang <haiyue.wang@intel.com>
Signed-off-by: Haiyue Wang <haiyue.wang@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>

diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 67c965a3f5d2..387d3f6cd71e 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1238,6 +1238,9 @@ ice_add_update_vsi_list(struct ice_hw *hw,
 			ice_create_vsi_list_map(hw, &vsi_handle_arr[0], 2,
 						vsi_list_id);
 
+		if (!m_entry->vsi_list_info)
+			return ICE_ERR_NO_MEMORY;
+
 		/* If this entry was large action then the large action needs
 		 * to be updated to point to FWD to VSI list
 		 */
@@ -2220,6 +2223,7 @@ ice_vsi_uses_fltr(struct ice_fltr_mgmt_list_entry *fm_entry, u16 vsi_handle)
 	return ((fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI &&
 		 fm_entry->fltr_info.vsi_handle == vsi_handle) ||
 		(fm_entry->fltr_info.fltr_act == ICE_FWD_TO_VSI_LIST &&
+		 fm_entry->vsi_list_info &&
 		 (test_bit(vsi_handle, fm_entry->vsi_list_info->vsi_map))));
 }
 
@@ -2292,14 +2296,12 @@ ice_add_to_vsi_fltr_list(struct ice_hw *hw, u16 vsi_handle,
 		return ICE_ERR_PARAM;
 
 	list_for_each_entry(fm_entry, lkup_list_head, list_entry) {
-		struct ice_fltr_info *fi;
-
-		fi = &fm_entry->fltr_info;
-		if (!fi || !ice_vsi_uses_fltr(fm_entry, vsi_handle))
+		if (!ice_vsi_uses_fltr(fm_entry, vsi_handle))
 			continue;
 
 		status = ice_add_entry_to_vsi_fltr_list(hw, vsi_handle,
-							vsi_list_head, fi);
+							vsi_list_head,
+							&fm_entry->fltr_info);
 		if (status)
 			return status;
 	}

