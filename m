Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED92D394CD2
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229723AbhE2PUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:20:46 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:35887 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2PUq (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:20:46 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailforward.nyi.internal (Postfix) with ESMTP id CD5041940DEA;
        Sat, 29 May 2021 11:19:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Sat, 29 May 2021 11:19:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=9mGp3H
        OeCdZDhswPTrOrRWwQM8WPdfkcK9d3UIA+X+g=; b=k8PUmqbXG/Nj7vpwrLe5wf
        hVDmNjtXayMtgqtY7Ex2SalesEFFW2lw1pLeV9IN4wImtu3SFB+X6ce8PX6fPJFW
        BfAdIShEN3X25K+cq0juoM0OUetZ9VE16iTn1AGfgRiuQTC9h4t5dXRuC+WjfOu1
        dKIpjeDK3tLfS+aCZBcXTkeWYIgT0MdP3LLu9N4SRxVdpl/if5E7bCeEdoRp0aqt
        J6myzYz5PRi1v7z3iSLi8fcurE108uia86EOZiihAN/dqVf/fkCd6SghTg2RGCou
        vGuTldW3GDXUGOSCnPkirVs8PZZRAUkL1d6iJ5Y/592pm0WONBkma4/UjiHOd4dw
        ==
X-ME-Sender: <xms:bVuyYIfdn_vYusWp1fJpCOsayuq5paiS6PXD0QRf9UR2IOK53WBpRQ>
    <xme:bVuyYKO4glb2JLDTUvSAp4n_INSeB3hfDwju7KsjG31aSzEMyiQG-nY-k6qHhVw6x
    BZHa6OgizLQKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bVuyYJhnL8-ZTA0dkXit36c52tlcpLyuyGTrnbADQfsD4ZZ-y8eWbQ>
    <xmx:bVuyYN8XRWP21Cb230DvxXmZsLqBbiIv6dTDtRn46bPNOq2SdrnekA>
    <xmx:bVuyYEtItfcj2a8qJP3fjXj3DOXMYIrc5sDuChBcdqtkirzUqB9IOg>
    <xmx:bVuyYBWgTcVbcqOF_nMRJlFW8ENv6uuPFYwOs85-yvThf1y0CQHfHQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:19:09 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath11k: Clear the fragment cache during key install" failed to apply to 4.14-stable tree
To:     srirrama@codeaurora.org, johannes.berg@intel.com,
        jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:18:56 +0200
Message-ID: <162230153611587@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
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

From c3944a5621026c176001493d48ee66ff94e1a39a Mon Sep 17 00:00:00 2001
From: Sriram R <srirrama@codeaurora.org>
Date: Tue, 11 May 2021 20:02:58 +0200
Subject: [PATCH] ath11k: Clear the fragment cache during key install

Currently the fragment cache setup during peer assoc is
cleared only during peer delete. In case a key reinstallation
happens with the same peer, the same fragment cache with old
fragments added before key installation could be clubbed
with fragments received after. This might be exploited
to mix fragments of different data resulting in a proper
unintended reassembled packet to be passed up the stack.

Hence flush the fragment cache on every key installation to prevent
potential attacks (CVE-2020-24587).

Tested-on: IPQ8074 hw2.0 AHB WLAN.HK.2.4.0.1-01734-QCAHKSWPL_SILICONZ-1 v2

Cc: stable@vger.kernel.org
Signed-off-by: Sriram R <srirrama@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.218dc777836f.I9af6fc76215a35936c4152552018afb5079c5d8c@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.c b/drivers/net/wireless/ath/ath11k/dp_rx.c
index 1d9aa1bb6b6e..3382f8bfcb48 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.c
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.c
@@ -852,6 +852,24 @@ static void ath11k_dp_rx_frags_cleanup(struct dp_rx_tid *rx_tid, bool rel_link_d
 	__skb_queue_purge(&rx_tid->rx_frags);
 }
 
+void ath11k_peer_frags_flush(struct ath11k *ar, struct ath11k_peer *peer)
+{
+	struct dp_rx_tid *rx_tid;
+	int i;
+
+	lockdep_assert_held(&ar->ab->base_lock);
+
+	for (i = 0; i <= IEEE80211_NUM_TIDS; i++) {
+		rx_tid = &peer->rx_tid[i];
+
+		spin_unlock_bh(&ar->ab->base_lock);
+		del_timer_sync(&rx_tid->frag_timer);
+		spin_lock_bh(&ar->ab->base_lock);
+
+		ath11k_dp_rx_frags_cleanup(rx_tid, true);
+	}
+}
+
 void ath11k_peer_rx_tid_cleanup(struct ath11k *ar, struct ath11k_peer *peer)
 {
 	struct dp_rx_tid *rx_tid;
diff --git a/drivers/net/wireless/ath/ath11k/dp_rx.h b/drivers/net/wireless/ath/ath11k/dp_rx.h
index bf399312b5ff..623da3bf9dc8 100644
--- a/drivers/net/wireless/ath/ath11k/dp_rx.h
+++ b/drivers/net/wireless/ath/ath11k/dp_rx.h
@@ -49,6 +49,7 @@ int ath11k_dp_peer_rx_pn_replay_config(struct ath11k_vif *arvif,
 				       const u8 *peer_addr,
 				       enum set_key_cmd key_cmd,
 				       struct ieee80211_key_conf *key);
+void ath11k_peer_frags_flush(struct ath11k *ar, struct ath11k_peer *peer);
 void ath11k_peer_rx_tid_cleanup(struct ath11k *ar, struct ath11k_peer *peer);
 void ath11k_peer_rx_tid_delete(struct ath11k *ar,
 			       struct ath11k_peer *peer, u8 tid);
diff --git a/drivers/net/wireless/ath/ath11k/mac.c b/drivers/net/wireless/ath/ath11k/mac.c
index 4df425dd31a2..9d0ff150ec30 100644
--- a/drivers/net/wireless/ath/ath11k/mac.c
+++ b/drivers/net/wireless/ath/ath11k/mac.c
@@ -2779,6 +2779,12 @@ static int ath11k_mac_op_set_key(struct ieee80211_hw *hw, enum set_key_cmd cmd,
 	 */
 	spin_lock_bh(&ab->base_lock);
 	peer = ath11k_peer_find(ab, arvif->vdev_id, peer_addr);
+
+	/* flush the fragments cache during key (re)install to
+	 * ensure all frags in the new frag list belong to the same key.
+	 */
+	if (peer && cmd == SET_KEY)
+		ath11k_peer_frags_flush(ar, peer);
 	spin_unlock_bh(&ab->base_lock);
 
 	if (!peer) {

