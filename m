Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A29D394CAF
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbhE2PRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:17:11 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:39281 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229698AbhE2PRK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:17:10 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 3F5C71940DB6;
        Sat, 29 May 2021 11:15:33 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 29 May 2021 11:15:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=EQ4Lfa
        x7GlCF8x3guO6f+8P6Dm35KdOlrY5QGT3CbDQ=; b=qqLOHe+ZrJTNWd2v0V1j9m
        vKJ6QRXFeTQ6B2DdWTYkek0nUhwmMrcf+uryox4bF1GPJyM1kPlEaNSU9KA8TAIz
        NIFkJSKG4S8pcKgKnFx3z6iImYvOPUwkFMWBCp1imG1NgB1fm/U7ZM378cnKGvmM
        ETqxlUZpKvs9TPr2Fm02boy0Hg/VFeg9u07XQjLGiZo9L9UcSA9hyyZaITJhZD2C
        rwrqFedLEGFOrP1WF9jhH7ezgQXtnnZTwHPEj18cKiYLrrtSQfnu7MLPd3lyntlE
        kBKsN6GbNbnuVLggIsupette6eDuUvJ1G7vPA5yk9LDGb9mZQssf92Vxa5iEFatA
        ==
X-ME-Sender: <xms:lVqyYNSY3P3q0OocEWFkMszJyPGhWkKZ-qMBn4eb7Q0L4KzQ7Lw4Dg>
    <xme:lVqyYGymoUtANxqjBNA7oFFQUxDtgqb6FF9ZX3vU61zOX_KWmotI-rsY2eXP_pFZp
    rCfKs11e39dWA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:lVqyYC08SXrR_Tskw6qwdikzenMajuHKDibAdsYjBM6d5OWuPGEeWA>
    <xmx:lVqyYFB5nqE4ySTC6TaXVNxtHSjAgAWeOHnPfo7OOkth5SfIdcs69g>
    <xmx:lVqyYGhLe6NMs0LcwyKr9f38v4a2VB9zoKKVTAe2cJmyOiYMPaduLg>
    <xmx:lVqyYKZerZb9B05ggY0PdWCSrmjwW2U40aKIJGuWZy8jC83C7Vdd-g>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:15:32 -0400 (EDT)
Subject: FAILED: patch "[PATCH] ath10k: add CCMP PN replay protection for fragmented frames" failed to apply to 4.14-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:15:22 +0200
Message-ID: <1622301322101175@kroah.com>
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

From a1166b2653db2f3de7338b9fb8a0f6e924b904ee Mon Sep 17 00:00:00 2001
From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 11 May 2021 20:02:52 +0200
Subject: [PATCH] ath10k: add CCMP PN replay protection for fragmented frames
 for PCIe

PN replay check for not fragmented frames is finished in the firmware,
but this was not done for fragmented frames when ath10k is used with
QCA6174/QCA6377 PCIe. mac80211 has the function
ieee80211_rx_h_defragment() for PN replay check for fragmented frames,
but this does not get checked with QCA6174 due to the
ieee80211_has_protected() condition not matching the cleared Protected
bit case.

Validate the PN of received fragmented frames within ath10k when CCMP is
used and drop the fragment if the PN is not correct (incremented by
exactly one from the previous fragment). This applies only for
QCA6174/QCA6377 PCIe.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.9ba2664866a4.I756e47b67e210dba69966d989c4711ffc02dc6bc@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 956157946106..dbc8aef82a65 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -845,6 +845,7 @@ enum htt_security_types {
 
 #define ATH10K_HTT_TXRX_PEER_SECURITY_MAX 2
 #define ATH10K_TXRX_NUM_EXT_TIDS 19
+#define ATH10K_TXRX_NON_QOS_TID 16
 
 enum htt_security_flags {
 #define HTT_SECURITY_TYPE_MASK 0x7F
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 1a08156d5011..f1e5bce8b14f 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1746,16 +1746,87 @@ static void ath10k_htt_rx_h_csum_offload(struct sk_buff *msdu)
 	msdu->ip_summed = ath10k_htt_rx_get_csum_state(msdu);
 }
 
+static u64 ath10k_htt_rx_h_get_pn(struct ath10k *ar, struct sk_buff *skb,
+				  u16 offset,
+				  enum htt_rx_mpdu_encrypt_type enctype)
+{
+	struct ieee80211_hdr *hdr;
+	u64 pn = 0;
+	u8 *ehdr;
+
+	hdr = (struct ieee80211_hdr *)(skb->data + offset);
+	ehdr = skb->data + offset + ieee80211_hdrlen(hdr->frame_control);
+
+	if (enctype == HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2) {
+		pn = ehdr[0];
+		pn |= (u64)ehdr[1] << 8;
+		pn |= (u64)ehdr[4] << 16;
+		pn |= (u64)ehdr[5] << 24;
+		pn |= (u64)ehdr[6] << 32;
+		pn |= (u64)ehdr[7] << 40;
+	}
+	return pn;
+}
+
+static bool ath10k_htt_rx_h_frag_pn_check(struct ath10k *ar,
+					  struct sk_buff *skb,
+					  u16 peer_id,
+					  u16 offset,
+					  enum htt_rx_mpdu_encrypt_type enctype)
+{
+	struct ath10k_peer *peer;
+	union htt_rx_pn_t *last_pn, new_pn = {0};
+	struct ieee80211_hdr *hdr;
+	bool more_frags;
+	u8 tid, frag_number;
+	u32 seq;
+
+	peer = ath10k_peer_find_by_id(ar, peer_id);
+	if (!peer) {
+		ath10k_dbg(ar, ATH10K_DBG_HTT, "invalid peer for frag pn check\n");
+		return false;
+	}
+
+	hdr = (struct ieee80211_hdr *)(skb->data + offset);
+	if (ieee80211_is_data_qos(hdr->frame_control))
+		tid = ieee80211_get_tid(hdr);
+	else
+		tid = ATH10K_TXRX_NON_QOS_TID;
+
+	last_pn = &peer->frag_tids_last_pn[tid];
+	new_pn.pn48 = ath10k_htt_rx_h_get_pn(ar, skb, offset, enctype);
+	more_frags = ieee80211_has_morefrags(hdr->frame_control);
+	frag_number = le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_FRAG;
+	seq = (__le16_to_cpu(hdr->seq_ctrl) & IEEE80211_SCTL_SEQ) >> 4;
+
+	if (frag_number == 0) {
+		last_pn->pn48 = new_pn.pn48;
+		peer->frag_tids_seq[tid] = seq;
+	} else {
+		if (seq != peer->frag_tids_seq[tid])
+			return false;
+
+		if (new_pn.pn48 != last_pn->pn48 + 1)
+			return false;
+
+		last_pn->pn48 = new_pn.pn48;
+	}
+
+	return true;
+}
+
 static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 				 struct sk_buff_head *amsdu,
 				 struct ieee80211_rx_status *status,
 				 bool fill_crypt_header,
 				 u8 *rx_hdr,
-				 enum ath10k_pkt_rx_err *err)
+				 enum ath10k_pkt_rx_err *err,
+				 u16 peer_id,
+				 bool frag)
 {
 	struct sk_buff *first;
 	struct sk_buff *last;
-	struct sk_buff *msdu;
+	struct sk_buff *msdu, *temp;
 	struct htt_rx_desc *rxd;
 	struct ieee80211_hdr *hdr;
 	enum htt_rx_mpdu_encrypt_type enctype;
@@ -1768,6 +1839,7 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	bool is_decrypted;
 	bool is_mgmt;
 	u32 attention;
+	bool frag_pn_check = true;
 
 	if (skb_queue_empty(amsdu))
 		return;
@@ -1866,6 +1938,24 @@ static void ath10k_htt_rx_h_mpdu(struct ath10k *ar,
 	}
 
 	skb_queue_walk(amsdu, msdu) {
+		if (frag && !fill_crypt_header && is_decrypted &&
+		    enctype == HTT_RX_MPDU_ENCRYPT_AES_CCM_WPA2)
+			frag_pn_check = ath10k_htt_rx_h_frag_pn_check(ar,
+								      msdu,
+								      peer_id,
+								      0,
+								      enctype);
+
+		if (!frag_pn_check) {
+			/* Discard the fragment with invalid PN */
+			temp = msdu->prev;
+			__skb_unlink(msdu, amsdu);
+			dev_kfree_skb_any(msdu);
+			msdu = temp;
+			frag_pn_check = true;
+			continue;
+		}
+
 		ath10k_htt_rx_h_csum_offload(msdu);
 		ath10k_htt_rx_h_undecap(ar, msdu, status, first_hdr, enctype,
 					is_decrypted);
@@ -2071,7 +2161,8 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
 		ath10k_htt_rx_h_unchain(ar, &amsdu, &drop_cnt, &unchain_cnt);
 
 	ath10k_htt_rx_h_filter(ar, &amsdu, rx_status, &drop_cnt_filter);
-	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true, first_hdr, &err);
+	ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status, true, first_hdr, &err, 0,
+			     false);
 	msdus_to_queue = skb_queue_len(&amsdu);
 	ath10k_htt_rx_h_enqueue(ar, &amsdu, rx_status);
 
@@ -3027,7 +3118,7 @@ static int ath10k_htt_rx_in_ord_ind(struct ath10k *ar, struct sk_buff *skb)
 			ath10k_htt_rx_h_ppdu(ar, &amsdu, status, vdev_id);
 			ath10k_htt_rx_h_filter(ar, &amsdu, status, NULL);
 			ath10k_htt_rx_h_mpdu(ar, &amsdu, status, false, NULL,
-					     NULL);
+					     NULL, peer_id, frag);
 			ath10k_htt_rx_h_enqueue(ar, &amsdu, status);
 			break;
 		case -EAGAIN:

