Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8565E394CA2
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:14:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbhE2PPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:15:37 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:59219 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2PPg (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:15:36 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id A4EE91940DB3;
        Sat, 29 May 2021 11:13:58 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 29 May 2021 11:13:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=AHSVZO
        KYEGAjVpmSjta8HUXRV237O0mgeC6Njfb5Sws=; b=R+9zjFEZXHCBB/aTnG5JJ5
        K+DU4/cS4f2ZXAdYyLh6QEWKYFNed4JqZLcI1zG3TMjyUGZi9PjKTD2aw/fl6ZSr
        1IEt1INQgZB5pG7U13KbWZUNqqEY4WojwBlMotlggleCKpHxqsHcLrGz08B9LER6
        DLDQSfwysIW9G0p4QJkkEy8wCKKDhM9dKZlmyeUQvkYJv3iWpcHY7Oq6S/SimiBV
        vO+nJIyV66TBs7H93Wq4iEeSqoejteYb6QB18Cet3wYG6rHPBacJ0YNpCrQ9/LNH
        P+847mXBLrvonxhdnm5oPXQM//rledigATR6rKn09cRmeG/1L5LDHO+gukYWCxnQ
        ==
X-ME-Sender: <xms:NlqyYL5jU7-9GgGU8ZXcNFJRQLu6nfNqTcw21dgO2wbUqv2exP_gOQ>
    <xme:NlqyYA5IPGEpmVhfFNiTD0QfLAFq60py4knHA2kPIIobdU93TewiwpVCpm2pE3OWG
    LlUWukBJTz0_g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:NlqyYCearxcO8vQl22tuhfr3Ki3Vae6fnSo2oXj-ehvTfKbObHE66Q>
    <xmx:NlqyYMIYGw34lsLP0jRnYuGYYcd08zrLhho3Yz3GR79bw35KQGM_sA>
    <xmx:NlqyYPKa4zedwjVSHbgJ1QTfQLELxKPJb-I5GQLEyaPceB9x9tDTCQ>
    <xmx:NlqyYFi6P7Kqv0EoXXXQTeaST_GdJPgk9R1oJdsb7Np-u8k15YjtPQ>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:13:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: extend protection against mixed key and fragment" failed to apply to 4.4-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:13:56 +0200
Message-ID: <162230123622641@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3edc6b0d6c061a70d8ca3c3c72eb1f58ce29bfb1 Mon Sep 17 00:00:00 2001
From: Wen Gong <wgong@codeaurora.org>
Date: Tue, 11 May 2021 20:02:51 +0200
Subject: [PATCH] mac80211: extend protection against mixed key and fragment
 cache attacks

For some chips/drivers, e.g., QCA6174 with ath10k, the decryption is
done by the hardware, and the Protected bit in the Frame Control field
is cleared in the lower level driver before the frame is passed to
mac80211. In such cases, the condition for ieee80211_has_protected() is
not met in ieee80211_rx_h_defragment() of mac80211 and the new security
validation steps are not executed.

Extend mac80211 to cover the case where the Protected bit has been
cleared, but the frame is indicated as having been decrypted by the
hardware. This extends protection against mixed key and fragment cache
attack for additional drivers/chips. This fixes CVE-2020-24586 and
CVE-2020-24587 for such cases.

Tested-on: QCA6174 hw3.2 PCI WLAN.RM.4.4.1-00110-QCARMSWP-1

Cc: stable@vger.kernel.org
Signed-off-by: Wen Gong <wgong@codeaurora.org>
Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
Link: https://lore.kernel.org/r/20210511200110.037aa5ca0390.I7bb888e2965a0db02a67075fcb5deb50eb7408aa@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 22a925899a9e..1bb43edd47b6 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2229,6 +2229,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	unsigned int frag, seq;
 	struct ieee80211_fragment_entry *entry;
 	struct sk_buff *skb;
+	struct ieee80211_rx_status *status = IEEE80211_SKB_RXCB(rx->skb);
 
 	hdr = (struct ieee80211_hdr *)rx->skb->data;
 	fc = hdr->frame_control;
@@ -2287,7 +2288,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 				     sizeof(rx->key->u.gcmp.rx_pn[queue]));
 			BUILD_BUG_ON(IEEE80211_CCMP_PN_LEN !=
 				     IEEE80211_GCMP_PN_LEN);
-		} else if (rx->key && ieee80211_has_protected(fc)) {
+		} else if (rx->key &&
+			   (ieee80211_has_protected(fc) ||
+			    (status->flag & RX_FLAG_DECRYPTED))) {
 			entry->is_protected = true;
 			entry->key_color = rx->key->color;
 		}
@@ -2332,13 +2335,19 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 			return RX_DROP_UNUSABLE;
 		memcpy(entry->last_pn, pn, IEEE80211_CCMP_PN_LEN);
 	} else if (entry->is_protected &&
-		   (!rx->key || !ieee80211_has_protected(fc) ||
+		   (!rx->key ||
+		    (!ieee80211_has_protected(fc) &&
+		     !(status->flag & RX_FLAG_DECRYPTED)) ||
 		    rx->key->color != entry->key_color)) {
 		/* Drop this as a mixed key or fragment cache attack, even
 		 * if for TKIP Michael MIC should protect us, and WEP is a
 		 * lost cause anyway.
 		 */
 		return RX_DROP_UNUSABLE;
+	} else if (entry->is_protected && rx->key &&
+		   entry->key_color != rx->key->color &&
+		   (status->flag & RX_FLAG_DECRYPTED)) {
+		return RX_DROP_UNUSABLE;
 	}
 
 	skb_pull(rx->skb, ieee80211_hdrlen(fc));

