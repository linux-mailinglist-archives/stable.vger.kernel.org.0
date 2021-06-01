Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71269394C95
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 16:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229709AbhE2O76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 10:59:58 -0400
Received: from forward4-smtp.messagingengine.com ([66.111.4.238]:32885 "EHLO
        forward4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229693AbhE2O76 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 10:59:58 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.nyi.internal (Postfix) with ESMTP id A13F31940E1A;
        Sat, 29 May 2021 10:58:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Sat, 29 May 2021 10:58:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=f89YFP
        B7Yd8yRTOQ9w7XOsLUENJsmYceQ7FOilAeWl4=; b=AiLMH6uDtksrNA6YsOlamY
        Sl4nxRFbLQU902i8ohTS2hECTEIEEFL0wdaNejw5eLVHjBtboE2kCYK+qefojaB9
        hhvyodoLnxw/juhWBlvrYrS2vn7ejIpYUnWtLAjpnT9sssQy9/Gvzhhawxg2ebP4
        6Nm1vR1Z69PeQdUkEC9n8/27mGxsaH6l7j+qvdV6XMorCtcO1H+ZEZdDgzOfh6Cl
        TO5NhVGKN+JyUOvBU9iuQaMvVMmKEGWLJbhMCpvR3/pDcKr3i4P6+DD/uQG7Q7Br
        OXNPbqdqdl7gWFJmGWegoPAtBrCr4ew/1sfpaXKbEO6gfd0VDgeAg63AR/26XQ6A
        ==
X-ME-Sender: <xms:jFayYPYLtq3nKr4GsheUXNxE3TITMbMD30mczuxVgczWvDlirDKz2A>
    <xme:jFayYOY3ACioeGUMD20mZeJV8dJ9FZbxJkSNEigdju-bL_VvLrxrUChpLf-csh_ll
    -I-7zF79n2LfA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdekledgkeefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:jFayYB_JuC3RaOCf8dyFaEYD8pUdX2tqIxCmJx-WcmiTSIMkR4Dmag>
    <xmx:jFayYFro1gspE8kq8MSZepcJwS5FQUVMz5Iapl32T2HUmULJQBZtbw>
    <xmx:jFayYKqOfZqYcT4eGcPKDQzEUVql51byygbXoU5rjzql1FCkPqOS6A>
    <xmx:jFayYIFBwaigxmJ1SX06wKnKfN0H77UdyfmiaBbZ5LrxInFz6E6RTg>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Sat, 29 May 2021 10:58:20 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: add fragment cache to sta_info" failed to apply to 4.14-stable tree
To:     johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 29 May 2021 16:58:09 +0200
Message-ID: <162230028924174@kroah.com>
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

From 3a11ce08c45b50d69c891d71760b7c5b92074709 Mon Sep 17 00:00:00 2001
From: Johannes Berg <johannes.berg@intel.com>
Date: Tue, 11 May 2021 20:02:47 +0200
Subject: [PATCH] mac80211: add fragment cache to sta_info

Prior patches protected against fragmentation cache attacks
by coloring keys, but this shows that it can lead to issues
when multiple stations use the same sequence number. Add a
fragment cache to struct sta_info (in addition to the one in
the interface) to separate fragments for different stations
properly.

This then automatically clear most of the fragment cache when a
station disconnects (or reassociates) from an AP, or when client
interfaces disconnect from the network, etc.

On the way, also fix the comment there since this brings us in line
with the recommendation in 802.11-2016 ("An AP should support ...").
Additionally, remove a useless condition (since there's no problem
purging an already empty list).

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210511200110.fc35046b0d52.I1ef101e3784d13e8f6600d83de7ec9a3a45bcd52@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
index 874ffe7819e5..4c714375bad0 100644
--- a/net/mac80211/ieee80211_i.h
+++ b/net/mac80211/ieee80211_i.h
@@ -50,12 +50,6 @@ struct ieee80211_local;
 #define IEEE80211_ENCRYPT_HEADROOM 8
 #define IEEE80211_ENCRYPT_TAILROOM 18
 
-/* IEEE 802.11 (Ch. 9.5 Defragmentation) requires support for concurrent
- * reception of at least three fragmented frames. This limit can be increased
- * by changing this define, at the cost of slower frame reassembly and
- * increased memory use (about 2 kB of RAM per entry). */
-#define IEEE80211_FRAGMENT_MAX 4
-
 /* power level hasn't been configured (or set to automatic) */
 #define IEEE80211_UNSET_POWER_LEVEL	INT_MIN
 
@@ -88,19 +82,6 @@ extern const u8 ieee80211_ac_to_qos_mask[IEEE80211_NUM_ACS];
 
 #define IEEE80211_MAX_NAN_INSTANCE_ID 255
 
-struct ieee80211_fragment_entry {
-	struct sk_buff_head skb_list;
-	unsigned long first_frag_time;
-	u16 seq;
-	u16 extra_len;
-	u16 last_frag;
-	u8 rx_queue;
-	bool check_sequential_pn; /* needed for CCMP/GCMP */
-	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
-	unsigned int key_color;
-};
-
-
 struct ieee80211_bss {
 	u32 device_ts_beacon, device_ts_presp;
 
@@ -903,9 +884,7 @@ struct ieee80211_sub_if_data {
 
 	char name[IFNAMSIZ];
 
-	/* Fragment table for host-based reassembly */
-	struct ieee80211_fragment_entry	fragments[IEEE80211_FRAGMENT_MAX];
-	unsigned int fragment_next;
+	struct ieee80211_fragment_cache frags;
 
 	/* TID bitmap for NoAck policy */
 	u16 noack_map;
@@ -2321,4 +2300,7 @@ u32 ieee80211_calc_expected_tx_airtime(struct ieee80211_hw *hw,
 #define debug_noinline
 #endif
 
+void ieee80211_init_frag_cache(struct ieee80211_fragment_cache *cache);
+void ieee80211_destroy_frag_cache(struct ieee80211_fragment_cache *cache);
+
 #endif /* IEEE80211_I_H */
diff --git a/net/mac80211/iface.c b/net/mac80211/iface.c
index 7032a2b59249..2e2f73a4aa73 100644
--- a/net/mac80211/iface.c
+++ b/net/mac80211/iface.c
@@ -8,7 +8,7 @@
  * Copyright 2008, Johannes Berg <johannes@sipsolutions.net>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (c) 2016        Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 #include <linux/slab.h>
 #include <linux/kernel.h>
@@ -677,16 +677,12 @@ static void ieee80211_set_multicast_list(struct net_device *dev)
  */
 static void ieee80211_teardown_sdata(struct ieee80211_sub_if_data *sdata)
 {
-	int i;
-
 	/* free extra data */
 	ieee80211_free_keys(sdata, false);
 
 	ieee80211_debugfs_remove_netdev(sdata);
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		__skb_queue_purge(&sdata->fragments[i].skb_list);
-	sdata->fragment_next = 0;
+	ieee80211_destroy_frag_cache(&sdata->frags);
 
 	if (ieee80211_vif_is_mesh(&sdata->vif))
 		ieee80211_mesh_teardown_sdata(sdata);
@@ -1930,8 +1926,7 @@ int ieee80211_if_add(struct ieee80211_local *local, const char *name,
 	sdata->wdev.wiphy = local->hw.wiphy;
 	sdata->local = local;
 
-	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++)
-		skb_queue_head_init(&sdata->fragments[i].skb_list);
+	ieee80211_init_frag_cache(&sdata->frags);
 
 	INIT_LIST_HEAD(&sdata->key_list);
 
diff --git a/net/mac80211/rx.c b/net/mac80211/rx.c
index 8a72d48ad6e0..7212a1bebd0c 100644
--- a/net/mac80211/rx.c
+++ b/net/mac80211/rx.c
@@ -2123,19 +2123,34 @@ ieee80211_rx_h_decrypt(struct ieee80211_rx_data *rx)
 	return result;
 }
 
+void ieee80211_init_frag_cache(struct ieee80211_fragment_cache *cache)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cache->entries); i++)
+		skb_queue_head_init(&cache->entries[i].skb_list);
+}
+
+void ieee80211_destroy_frag_cache(struct ieee80211_fragment_cache *cache)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(cache->entries); i++)
+		__skb_queue_purge(&cache->entries[i].skb_list);
+}
+
 static inline struct ieee80211_fragment_entry *
-ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
+ieee80211_reassemble_add(struct ieee80211_fragment_cache *cache,
 			 unsigned int frag, unsigned int seq, int rx_queue,
 			 struct sk_buff **skb)
 {
 	struct ieee80211_fragment_entry *entry;
 
-	entry = &sdata->fragments[sdata->fragment_next++];
-	if (sdata->fragment_next >= IEEE80211_FRAGMENT_MAX)
-		sdata->fragment_next = 0;
+	entry = &cache->entries[cache->next++];
+	if (cache->next >= IEEE80211_FRAGMENT_MAX)
+		cache->next = 0;
 
-	if (!skb_queue_empty(&entry->skb_list))
-		__skb_queue_purge(&entry->skb_list);
+	__skb_queue_purge(&entry->skb_list);
 
 	__skb_queue_tail(&entry->skb_list, *skb); /* no need for locking */
 	*skb = NULL;
@@ -2150,14 +2165,14 @@ ieee80211_reassemble_add(struct ieee80211_sub_if_data *sdata,
 }
 
 static inline struct ieee80211_fragment_entry *
-ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
+ieee80211_reassemble_find(struct ieee80211_fragment_cache *cache,
 			  unsigned int frag, unsigned int seq,
 			  int rx_queue, struct ieee80211_hdr *hdr)
 {
 	struct ieee80211_fragment_entry *entry;
 	int i, idx;
 
-	idx = sdata->fragment_next;
+	idx = cache->next;
 	for (i = 0; i < IEEE80211_FRAGMENT_MAX; i++) {
 		struct ieee80211_hdr *f_hdr;
 		struct sk_buff *f_skb;
@@ -2166,7 +2181,7 @@ ieee80211_reassemble_find(struct ieee80211_sub_if_data *sdata,
 		if (idx < 0)
 			idx = IEEE80211_FRAGMENT_MAX - 1;
 
-		entry = &sdata->fragments[idx];
+		entry = &cache->entries[idx];
 		if (skb_queue_empty(&entry->skb_list) || entry->seq != seq ||
 		    entry->rx_queue != rx_queue ||
 		    entry->last_frag + 1 != frag)
@@ -2207,6 +2222,7 @@ static bool requires_sequential_pn(struct ieee80211_rx_data *rx, __le16 fc)
 static ieee80211_rx_result debug_noinline
 ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 {
+	struct ieee80211_fragment_cache *cache = &rx->sdata->frags;
 	struct ieee80211_hdr *hdr;
 	u16 sc;
 	__le16 fc;
@@ -2228,6 +2244,9 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 		goto out_no_led;
 	}
 
+	if (rx->sta)
+		cache = &rx->sta->frags;
+
 	if (likely(!ieee80211_has_morefrags(fc) && frag == 0))
 		goto out;
 
@@ -2246,7 +2265,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 
 	if (frag == 0) {
 		/* This is the first fragment of a new frame. */
-		entry = ieee80211_reassemble_add(rx->sdata, frag, seq,
+		entry = ieee80211_reassemble_add(cache, frag, seq,
 						 rx->seqno_idx, &(rx->skb));
 		if (requires_sequential_pn(rx, fc)) {
 			int queue = rx->security_idx;
@@ -2274,7 +2293,7 @@ ieee80211_rx_h_defragment(struct ieee80211_rx_data *rx)
 	/* This is a fragment for a frame that should already be pending in
 	 * fragment cache. Add this fragment to the end of the pending entry.
 	 */
-	entry = ieee80211_reassemble_find(rx->sdata, frag, seq,
+	entry = ieee80211_reassemble_find(cache, frag, seq,
 					  rx->seqno_idx, hdr);
 	if (!entry) {
 		I802_DEBUG_INC(rx->local->rx_handlers_drop_defrag);
diff --git a/net/mac80211/sta_info.c b/net/mac80211/sta_info.c
index ec6973ee88ef..f2fb69da9b6e 100644
--- a/net/mac80211/sta_info.c
+++ b/net/mac80211/sta_info.c
@@ -4,7 +4,7 @@
  * Copyright 2006-2007	Jiri Benc <jbenc@suse.cz>
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright (C) 2015 - 2017 Intel Deutschland GmbH
- * Copyright (C) 2018-2020 Intel Corporation
+ * Copyright (C) 2018-2021 Intel Corporation
  */
 
 #include <linux/module.h>
@@ -392,6 +392,8 @@ struct sta_info *sta_info_alloc(struct ieee80211_sub_if_data *sdata,
 
 	u64_stats_init(&sta->rx_stats.syncp);
 
+	ieee80211_init_frag_cache(&sta->frags);
+
 	sta->sta_state = IEEE80211_STA_NONE;
 
 	/* Mark TID as unreserved */
@@ -1102,6 +1104,8 @@ static void __sta_info_destroy_part2(struct sta_info *sta)
 
 	ieee80211_sta_debugfs_remove(sta);
 
+	ieee80211_destroy_frag_cache(&sta->frags);
+
 	cleanup_single_sta(sta);
 }
 
diff --git a/net/mac80211/sta_info.h b/net/mac80211/sta_info.h
index 78b9d0c7cc58..5c56d29a619e 100644
--- a/net/mac80211/sta_info.h
+++ b/net/mac80211/sta_info.h
@@ -3,7 +3,7 @@
  * Copyright 2002-2005, Devicescape Software, Inc.
  * Copyright 2013-2014  Intel Mobile Communications GmbH
  * Copyright(c) 2015-2017 Intel Deutschland GmbH
- * Copyright(c) 2020 Intel Corporation
+ * Copyright(c) 2020-2021 Intel Corporation
  */
 
 #ifndef STA_INFO_H
@@ -438,6 +438,33 @@ struct ieee80211_sta_rx_stats {
 	u64 msdu[IEEE80211_NUM_TIDS + 1];
 };
 
+/*
+ * IEEE 802.11-2016 (10.6 "Defragmentation") recommends support for "concurrent
+ * reception of at least one MSDU per access category per associated STA"
+ * on APs, or "at least one MSDU per access category" on other interface types.
+ *
+ * This limit can be increased by changing this define, at the cost of slower
+ * frame reassembly and increased memory use while fragments are pending.
+ */
+#define IEEE80211_FRAGMENT_MAX 4
+
+struct ieee80211_fragment_entry {
+	struct sk_buff_head skb_list;
+	unsigned long first_frag_time;
+	u16 seq;
+	u16 extra_len;
+	u16 last_frag;
+	u8 rx_queue;
+	bool check_sequential_pn; /* needed for CCMP/GCMP */
+	u8 last_pn[6]; /* PN of the last fragment if CCMP was used */
+	unsigned int key_color;
+};
+
+struct ieee80211_fragment_cache {
+	struct ieee80211_fragment_entry	entries[IEEE80211_FRAGMENT_MAX];
+	unsigned int next;
+};
+
 /*
  * The bandwidth threshold below which the per-station CoDel parameters will be
  * scaled to be more lenient (to prevent starvation of slow stations). This
@@ -531,6 +558,7 @@ struct ieee80211_sta_rx_stats {
  * @status_stats.last_ack_signal: last ACK signal
  * @status_stats.ack_signal_filled: last ACK signal validity
  * @status_stats.avg_ack_signal: average ACK signal
+ * @frags: fragment cache
  */
 struct sta_info {
 	/* General information, mostly static */
@@ -639,6 +667,8 @@ struct sta_info {
 
 	struct cfg80211_chan_def tdls_chandef;
 
+	struct ieee80211_fragment_cache frags;
+
 	/* keep last! */
 	struct ieee80211_sta sta;
 };

