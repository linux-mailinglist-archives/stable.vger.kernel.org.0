Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1967D394CA5
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 17:14:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229795AbhE2PPq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 11:15:46 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:44961 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229774AbhE2PPp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 11:15:45 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id 37CD01940DBD;
        Sat, 29 May 2021 11:14:09 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Sat, 29 May 2021 11:14:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=pevm81
        TPDMhE5M7vfaoUk4ilkTTklF1U7rOsqj4Q+S0=; b=A2UsbDoWJHQ6Ld45zwoFY5
        18kknspizbirKn2rkaMinf3mKNsprRYSCGnCV7cmwhAq331UyIBbJ3j/zi0cOocE
        YkRC/CDs7dYX+2oUOz/kW6PHVjaEBstLBM7f/D+gi72+iKdRJe+kBkhdkPIaD785
        x2umyxeyG2Aj8kUYUvTMlRjwfN9XYHUPg06lj0qwdcQKab6CTOQUISABpDAAEL4h
        NrMx7Vxor+iGNJOz7vTvXjEqAouxwsui8KxCR5lOtLm60rkN2g8dOtPu3/xY7LgU
        PUtYHQopJdMLy93GDBmzMSIl5/dN540uOJR98eYriCtyhLBU4d//PMB/hBddZqXA
        ==
X-ME-Sender: <xms:QVqyYHLqglxpXzn7tS77jd-uZdq2406n8-MtY7N6T3k3eeSvsMdiZA>
    <xme:QVqyYLJabkfRuMoWnBl1qmCjwmAYHwQn2H46vZ6XuyXeaPO_bb2c9V2c7JdXc-e_X
    o3KjFhZqMBH6Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:QVqyYPvh8H6nsdhRtsZ7_GvWIl-rbQ1P76jad914OaZgxSZRzeYIsQ>
    <xmx:QVqyYAYm37l1jgCfiveaC5VlFaCkIoBYCy5myEgm_TidcyBuqZLtag>
    <xmx:QVqyYOZY-B1K8sYiNMPXFbY53h6u66-1Jhcu-1g0dXfbd2ratXlvVg>
    <xmx:QVqyYBysluJwz0gYemwXgMSJgadGniRlmOC7nIxePHRsAnBvnXVcIg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 11:14:08 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: extend protection against mixed key and fragment" failed to apply to 4.14-stable tree
To:     wgong@codeaurora.org, johannes.berg@intel.com, jouni@codeaurora.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 17:13:58 +0200
Message-ID: <162230123822323@kroah.com>
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

