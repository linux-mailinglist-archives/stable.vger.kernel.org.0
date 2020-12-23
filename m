Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24A62E1DAA
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 15:59:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbgLWO7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Dec 2020 09:59:02 -0500
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:57689 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725536AbgLWO7C (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Dec 2020 09:59:02 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailforward.west.internal (Postfix) with ESMTP id 3E5CB1E4C;
        Wed, 23 Dec 2020 09:58:16 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 23 Dec 2020 09:58:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=Tp6Khc
        fln+kYYY8kxicnODL8jwmB5hVEqcBpqiV+N/0=; b=een3NV8if0jVoafOblHYQd
        vnUfVrcwSQraSY5hwQ9ApxyQ2sDXFpP0feecE6x5iPuCyuVV94tW05Qb5GwGnEND
        n1yNuUQGy5pmIgS8x6VCbysDl+OIinwUEK9o7cPMA/rGbX2hGtoIhVQUIWUIo9Q5
        VG4hVT3Tt+n7F2bqRhAJnX5aLZJeknq/ek03RIbHsgBBx4UgHAOQJNceAstOivF2
        SR7aBfu8iuHN53kj5X77QmcpCgwDcaeY3rwhD2peq0vJpwMvMb7QEnv0qvdefvW3
        6u29kMe65VOP9ZS4rpUnTiDEGb56Ff0ODz8+BJrC2bz6INjJMt5yuWimxQRtwApg
        ==
X-ME-Sender: <xms:B1vjX4H2q-B7MvxxxQiCBbuQZFEjbpXDTMLt-tHxmJCg48ZNtT66Rw>
    <xme:B1vjXxX3kY2XJ2QIPUzwtLq05Gl-PFUHbz2ow-wtDewSCmV8KvET57t9U0b3Gy84g
    ZbEgH4qlNSOKA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrvddtjedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepleelledvgeefleeltdetgedugeffgffhudffudduke
    egfeelgeeigeekjefhleevnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghenucfkphep
    keefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmh
    grihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:B1vjXyJq3196MWqLen8o24ADs94I4JuHJtHjDmhqbJnbkXTMtHsfOg>
    <xmx:B1vjX6EotiM-xZ5_npc-RKUAxFk9a3LTmHo0yk6B8_BGWHDxZrxOOw>
    <xmx:B1vjX-W2vys34cuB8HtF6ME9t-O5vJOykZ56vEyz7rcnqx7-R6_HSQ>
    <xmx:B1vjXxdHU7fOqwdUQOLPU_KLmZS1gUMlWSRh2OS2k9HHv-COAR6Jzl9QYIU>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 8928C1080057;
        Wed, 23 Dec 2020 09:58:15 -0500 (EST)
Subject: FAILED: patch "[PATCH] nl80211: validate key indexes for cfg80211_registered_device" failed to apply to 4.19-stable tree
To:     anant.thazhemadam@gmail.com, johannes.berg@intel.com,
        johannes@sipsolutions.net
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 23 Dec 2020 15:59:19 +0100
Message-ID: <1608735559179151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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

From 2d9463083ce92636a1bdd3e30d1236e3e95d859e Mon Sep 17 00:00:00 2001
From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Sat, 5 Dec 2020 03:28:25 +0530
Subject: [PATCH] nl80211: validate key indexes for cfg80211_registered_device

syzbot discovered a bug in which an OOB access was being made because
an unsuitable key_idx value was wrongly considered to be acceptable
while deleting a key in nl80211_del_key().

Since we don't know the cipher at the time of deletion, if
cfg80211_validate_key_settings() were to be called directly in
nl80211_del_key(), even valid keys would be wrongly determined invalid,
and deletion wouldn't occur correctly.
For this reason, a new function - cfg80211_valid_key_idx(), has been
created, to determine if the key_idx value provided is valid or not.
cfg80211_valid_key_idx() is directly called in 2 places -
nl80211_del_key(), and cfg80211_validate_key_settings().

Reported-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Tested-by: syzbot+49d4cab497c2142ee170@syzkaller.appspotmail.com
Suggested-by: Johannes Berg <johannes@sipsolutions.net>
Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Link: https://lore.kernel.org/r/20201204215825.129879-1-anant.thazhemadam@gmail.com
Cc: stable@vger.kernel.org
[also disallow IGTK key IDs if no IGTK cipher is supported]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/net/wireless/core.h b/net/wireless/core.h
index e3e9686859d4..7df91f940212 100644
--- a/net/wireless/core.h
+++ b/net/wireless/core.h
@@ -433,6 +433,8 @@ void cfg80211_sme_abandon_assoc(struct wireless_dev *wdev);
 
 /* internal helpers */
 bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher);
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise);
 int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
 				   struct key_params *params, int key_idx,
 				   bool pairwise, const u8 *mac_addr);
diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index c8d31181a660..910872974f2d 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -4239,9 +4239,6 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	if (err)
 		return err;
 
-	if (key.idx < 0)
-		return -EINVAL;
-
 	if (info->attrs[NL80211_ATTR_MAC])
 		mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
@@ -4257,6 +4254,10 @@ static int nl80211_del_key(struct sk_buff *skb, struct genl_info *info)
 	    key.type != NL80211_KEYTYPE_GROUP)
 		return -EINVAL;
 
+	if (!cfg80211_valid_key_idx(rdev, key.idx,
+				    key.type == NL80211_KEYTYPE_PAIRWISE))
+		return -EINVAL;
+
 	if (!rdev->ops->del_key)
 		return -EOPNOTSUPP;
 
diff --git a/net/wireless/util.c b/net/wireless/util.c
index 79c5780e3033..b4acc805114b 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -272,18 +272,53 @@ bool cfg80211_supported_cipher_suite(struct wiphy *wiphy, u32 cipher)
 	return false;
 }
 
-int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
-				   struct key_params *params, int key_idx,
-				   bool pairwise, const u8 *mac_addr)
+static bool
+cfg80211_igtk_cipher_supported(struct cfg80211_registered_device *rdev)
 {
-	int max_key_idx = 5;
+	struct wiphy *wiphy = &rdev->wiphy;
+	int i;
+
+	for (i = 0; i < wiphy->n_cipher_suites; i++) {
+		switch (wiphy->cipher_suites[i]) {
+		case WLAN_CIPHER_SUITE_AES_CMAC:
+		case WLAN_CIPHER_SUITE_BIP_CMAC_256:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_128:
+		case WLAN_CIPHER_SUITE_BIP_GMAC_256:
+			return true;
+		}
+	}
+
+	return false;
+}
 
-	if (wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
-	    wiphy_ext_feature_isset(&rdev->wiphy,
-				    NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
+bool cfg80211_valid_key_idx(struct cfg80211_registered_device *rdev,
+			    int key_idx, bool pairwise)
+{
+	int max_key_idx;
+
+	if (pairwise)
+		max_key_idx = 3;
+	else if (wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_BEACON_PROTECTION) ||
+		 wiphy_ext_feature_isset(&rdev->wiphy,
+					 NL80211_EXT_FEATURE_BEACON_PROTECTION_CLIENT))
 		max_key_idx = 7;
+	else if (cfg80211_igtk_cipher_supported(rdev))
+		max_key_idx = 5;
+	else
+		max_key_idx = 3;
+
 	if (key_idx < 0 || key_idx > max_key_idx)
+		return false;
+
+	return true;
+}
+
+int cfg80211_validate_key_settings(struct cfg80211_registered_device *rdev,
+				   struct key_params *params, int key_idx,
+				   bool pairwise, const u8 *mac_addr)
+{
+	if (!cfg80211_valid_key_idx(rdev, key_idx, pairwise))
 		return -EINVAL;
 
 	if (!pairwise && mac_addr && !(rdev->wiphy.flags & WIPHY_FLAG_IBSS_RSN))

