Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E17161BA950
	for <lists+stable@lfdr.de>; Mon, 27 Apr 2020 17:52:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727801AbgD0Pw3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Apr 2020 11:52:29 -0400
Received: from forward2-smtp.messagingengine.com ([66.111.4.226]:48995 "EHLO
        forward2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726185AbgD0Pw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Apr 2020 11:52:28 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id B870D194022A;
        Mon, 27 Apr 2020 11:52:27 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 27 Apr 2020 11:52:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=L1ya+e
        w12mZZyGveYUaGMbidUkMaVOa56HQ6cKcrucI=; b=hHT/DeND19Z4Vw4k/lreuC
        yank6cG1CXuClMbIOp2dX3RMNJ0x4ZID688PLdSVygMHMa+i/R+26BCxKeRHzKP5
        i027cM7LMec+UrcppvkNKnfexMCJSW59esDW+Vrnzhg2vJEAZ5Rg9rVDS/Uz0bNw
        W/B8vSYMF76hqsa6A2h5MqxjskKycmjxXF5XJmvQrENr/M9fag8dlTKrhNqSBxMc
        S61s8seOvdm5/97K/oxtVyu8iCkR0ZDRl/CoR0TLh/i3fftBavUT3CJAV93uC++w
        9BHmtf1JtBvP80gSKiNz4GO/j/cMqjDFbjvLw+5BrILYY1mipILJbysaQx/MulMQ
        ==
X-ME-Sender: <xms:uv-mXsRgkVO9Z2NA3H1AN9lqCAsHR7GwQTzn2qqwonJyYwM5s-ZwSg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrheelgdeludcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:uv-mXl1em2C4UgX9O3q33piDeu1WK0n_SFUm3Z-ILqvwyGnUQOnK_Q>
    <xmx:uv-mXjPCR4r8ZL5IVMXZ_yo-LJzcoXbehIZG_N9FiGlQ-BKgYpYxzQ>
    <xmx:uv-mXoNYo133CNxmpq7ELxb-ugxEF5cAvje6U1zegu___jWG8_5vwA>
    <xmx:u_-mXhrcKE6ZMRrPphMR_gwIv77q-vxuzw7Euf0mO8Jxh-cXZTVm0w>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id AD70E328005A;
        Mon, 27 Apr 2020 11:52:26 -0400 (EDT)
Subject: FAILED: patch "[PATCH] iwlwifi: mvm: Do not declare support for ACK Enabled" failed to apply to 4.19-stable tree
To:     ilan.peer@intel.com, kvalo@codeaurora.org, luciano.coelho@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 27 Apr 2020 17:52:24 +0200
Message-ID: <1588002744173205@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
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

From 38af8d5a90a8c3b41ff0484855e24bd55b43ce9d Mon Sep 17 00:00:00 2001
From: Ilan Peer <ilan.peer@intel.com>
Date: Fri, 17 Apr 2020 10:08:13 +0300
Subject: [PATCH] iwlwifi: mvm: Do not declare support for ACK Enabled
 Aggregation

As this was not supposed to be enabled to begin with.

Cc: stable@vger.kernel.org # v4.19+
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/iwlwifi.20200417100405.53dbc3c6c36b.Idfe118546b92cc31548b2211472a5303c7de5909@changeid

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
index 9e9810d2b262..ccf0bc16465d 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c
@@ -532,8 +532,7 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 				.mac_cap_info[2] =
-					IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP |
-					IEEE80211_HE_MAC_CAP2_ACK_EN,
+					IEEE80211_HE_MAC_CAP2_32BIT_BA_BITMAP,
 				.mac_cap_info[3] =
 					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
 					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,
@@ -617,8 +616,7 @@ static struct ieee80211_sband_iftype_data iwl_he_capa[] = {
 					IEEE80211_HE_MAC_CAP1_TF_MAC_PAD_DUR_16US |
 					IEEE80211_HE_MAC_CAP1_MULTI_TID_AGG_RX_QOS_8,
 				.mac_cap_info[2] =
-					IEEE80211_HE_MAC_CAP2_BSR |
-					IEEE80211_HE_MAC_CAP2_ACK_EN,
+					IEEE80211_HE_MAC_CAP2_BSR,
 				.mac_cap_info[3] =
 					IEEE80211_HE_MAC_CAP3_OMI_CONTROL |
 					IEEE80211_HE_MAC_CAP3_MAX_AMPDU_LEN_EXP_VHT_2,

