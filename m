Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17804337C30
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 19:13:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229490AbhCKSMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 13:12:38 -0500
Received: from wforward3-smtp.messagingengine.com ([64.147.123.22]:58221 "EHLO
        wforward3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230047AbhCKSMG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Mar 2021 13:12:06 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id A37DA1A4A;
        Thu, 11 Mar 2021 13:12:05 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 11 Mar 2021 13:12:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=Ul5y6q
        t1d8OZEFkqA/sTIvgsuX7lmig/yEZGbOTajEg=; b=wiIS4UEqbAoUOZv9pUeZYH
        o4Tok/bkrphJcTymJ3HLwcdTAWraXjxZFc1eLs8wV9XZodwbnhscUmywyqDKF2c2
        8N0/Zigq7BdmkoPA2ebdSFf52vJHUHyiQGQvubA7JHcNT99ijpRkL570TmCk3gRc
        tvzwDQ0ViWuZtRcFpS1LsF/G/oxqn+l6t2mpz0faTcQZ99rOz6J7Z1cVmcSfV8zp
        zsUyH+JUJ5ZKoQv3dS6efegyhozU2E0XRh+i/ee0zPxdf4W7kqzYfG6lf8QCw9ft
        LyGj7viADr2OtuJ9MrrHKZxEWWpUj77iq8FUYoypzov7i/WKGBWFBtExCHsJcNaw
        ==
X-ME-Sender: <xms:dV1KYBR9l49tDlJY26zn98JyPKutMRM9GAUmEUOw27sOhc_Rf6NEwg>
    <xme:dV1KYKxVRiwO9y9133xrS-XteIVFQqiB873zt8F-d73lEefg_zYysIrdbQPTI3j4v
    bHVQDo0wNQ0WA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledruddvtddguddutdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertd
    dttdflnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdho
    rhhgqeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduud
    ekgeefleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecukfhp
    peekfedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:dV1KYG1a2yT3-bjJV2g7k7zeiDZPhlAi2sxLvd00iKGuBJOUliRLzQ>
    <xmx:dV1KYJDaAuzZ2AO4lBs7kgTu_dO5mdiIsAgT77RS5eUAaKA-5Fvstg>
    <xmx:dV1KYKgzmKYxYh55URTYaINH8pgULuWcpyynN-xv20iVzFDcjXrHMg>
    <xmx:dV1KYAcS5wmO-MZc8P62SY2KR48LfvdK8FGqxaIxptVRdpSZvUbE6Vaf90o>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id B66B124005C;
        Thu, 11 Mar 2021 13:12:04 -0500 (EST)
Subject: FAILED: patch "[PATCH] ath11k: fix AP mode for QCA6390" failed to apply to 5.10-stable tree
To:     kvalo@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 11 Mar 2021 19:12:02 +0100
Message-ID: <1615486322187139@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 77d7e87128d4dfb400df4208b2812160e999c165 Mon Sep 17 00:00:00 2001
From: Kalle Valo <kvalo@codeaurora.org>
Date: Mon, 22 Feb 2021 17:14:09 +0200
Subject: [PATCH] ath11k: fix AP mode for QCA6390

Commit c134d1f8c436 ("ath11k: Handle errors if peer creation fails") completely
broke AP mode on QCA6390:

kernel: [  151.230734] ath11k_pci 0000:06:00.0: failed to create peer after vdev start delay: -22
wpa_supplicant[2307]: Failed to set beacon parameters
wpa_supplicant[2307]: Interface initialization failed
wpa_supplicant[2307]: wlan0: interface state UNINITIALIZED->DISABLED
wpa_supplicant[2307]: wlan0: AP-DISABLED
wpa_supplicant[2307]: wlan0: Unable to setup interface.
wpa_supplicant[2307]: Failed to initialize AP interface

This was because commit c134d1f8c436 ("ath11k: Handle errors if peer creation
fails") added error handling for ath11k_peer_create(), which had been failing
all along but was unnoticed due to the missing error handling. The actual bug
was introduced already in commit aa44b2f3ecd4 ("ath11k: start vdev if a bss peer is
already created").

ath11k_peer_create() was failing because for AP mode the peer is created
already earlier op_add_interface() and we should skip creation here, but the
check for modes was wrong.  Fixing that makes AP mode work again.

This shouldn't affect IPQ8074 nor QCN9074 as they have hw_params.vdev_start_delay disabled.

Tested-on: QCA6390 hw2.0 PCI WLAN.HST.1.0.1-01740-QCAHSTSWPLZ_V2_TO_X86-1

Fixes: c134d1f8c436 ("ath11k: Handle errors if peer creation fails")
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1614006849-25764-1-git-send-email-kvalo@codeaurora.org

diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index b391169576e2..faa2e678e63e 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -5450,8 +5450,8 @@ ath11k_mac_op_assign_vif_chanctx(struct ieee80211_hw *hw,
 	}
 
 	if (ab->hw_params.vdev_start_delay &&
-	    (arvif->vdev_type == WMI_VDEV_TYPE_AP ||
-	    arvif->vdev_type == WMI_VDEV_TYPE_MONITOR)) {
+	    arvif->vdev_type != WMI_VDEV_TYPE_AP &&
+	    arvif->vdev_type != WMI_VDEV_TYPE_MONITOR) {
 		param.vdev_id = arvif->vdev_id;
 		param.peer_type = WMI_PEER_TYPE_DEFAULT;
 		param.peer_addr = ar->mac_addr;

