Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337AA3C3C4D
	for <lists+stable@lfdr.de>; Sun, 11 Jul 2021 14:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbhGKM3o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 08:29:44 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:36981 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232544AbhGKM3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 08:29:43 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailforward.west.internal (Postfix) with ESMTP id E02A01AC0D0B;
        Sun, 11 Jul 2021 08:26:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sun, 11 Jul 2021 08:26:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=YUQnho
        +Mm+XiLqXS9E9aDEpYpcpydSFP9ZNkTDc4PCk=; b=aT8Yd0AGqMVEkClmuj+RB/
        MNvliydSjWOqYnKHq74V8ggrHdc2CRhKD2tk2haECl5XF1QdSPC31q9oUOiqtWBy
        fLbFM+A5PipdY8hkWZ6PVb56JvkbUwJudiiqNCOklvegC8uAo8VkwN9PQuBi/tvM
        Nz2gS8UUrvXl6JvD93va7AWKBV+3i6P/ObVprt1RkXJ1VOm7TmteC+wvD4ord6cu
        57ABjVGiWEJ+hzqK6Zz3jGEQejsp5Vdpe570Nnq+hyqf3eNZojmLGaeIgUIp3Vdk
        9PJ3hjUqpoY2EmDZ6O0GZOmDHYoUXg0ATiLUG0HfsuIA+RcmAxpSmUboR8FBatEw
        ==
X-ME-Sender: <xms:j-PqYJqEKkNPCwo1lOqVk9P6S4CrAqZT2kPfX0MbnFKivtCtskdBSQ>
    <xme:j-PqYLrtKt5ddJh04sdR-zjeoigiVPdxWpajIppwXqOL11Vg615ZX8LeGyJjZxWhr
    8CobJO_zN22cw>
X-ME-Received: <xmr:j-PqYGOstJSI1wKY7FQMKQeomJ-iDlJBrEPVh-inEY9-6n996M7xXfyT9HWrmz3yyS8cn8j0aGfAXfiSvFdhOgG2Sg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddtgdehvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepuffvhfffkfggtgfgsehtkeertddttd
    flnecuhfhrohhmpeeoghhrvghgkhhhsehlihhnuhigfhhouhhnuggrthhiohhnrdhorhhg
    qeenucggtffrrghtthgvrhhnpeelleelvdegfeelledtteegudegfffghfduffduudekge
    efleegieegkeejhfelveenucffohhmrghinhepkhgvrhhnvghlrdhorhhgnecuvehluhhs
    thgvrhfuihiivgepvdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:kOPqYE7E9a2662w18hGIngINepZvujbedCUWoZ2dkIEydGDmn2qLxg>
    <xmx:kOPqYI5tLrheO-IzbsMKOc9avqvQg-mlo6W2T2LyrEsIYF8DpwXQKg>
    <xmx:kOPqYMjVAMZEG7aiqnBw02LDJ_N6E4hr13vzD-jAAynouaIDaTa7lA>
    <xmx:kOPqYGTLN_4qbPDloWrH5RqXOJ8TrtcFr-cpAsU3C-ngd_zdraZBR0qrS7k>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 11 Jul 2021 08:26:55 -0400 (EDT)
Subject: FAILED: patch "[PATCH] mac80211: remove iwlwifi specific workaround that broke sta" failed to apply to 4.19-stable tree
To:     nbd@nbd.name, johannes.berg@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 11 Jul 2021 14:26:54 +0200
Message-ID: <1626006414162219@kroah.com>
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

From e41eb3e408de27982a5f8f50b2dd8002bed96908 Mon Sep 17 00:00:00 2001
From: Felix Fietkau <nbd@nbd.name>
Date: Sat, 19 Jun 2021 12:15:17 +0200
Subject: [PATCH] mac80211: remove iwlwifi specific workaround that broke sta
 NDP tx

Sending nulldata packets is important for sw AP link probing and detecting
4-address mode links. The checks that dropped these packets were apparently
added to work around an iwlwifi firmware bug with multi-TID aggregation.

Fixes: 41cbb0f5a295 ("mac80211: add support for HE")
Cc: stable@vger.kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Link: https://lore.kernel.org/r/20210619101517.90806-1-nbd@nbd.name
Signed-off-by: Johannes Berg <johannes.berg@intel.com>

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
index 1ad621d13ad3..0a13c2bda2ee 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/tx.c
@@ -1032,6 +1032,9 @@ static int iwl_mvm_tx_mpdu(struct iwl_mvm *mvm, struct sk_buff *skb,
 	if (WARN_ON_ONCE(mvmsta->sta_id == IWL_MVM_INVALID_STA))
 		return -1;
 
+	if (unlikely(ieee80211_is_any_nullfunc(fc)) && sta->he_cap.has_he)
+		return -1;
+
 	if (unlikely(ieee80211_is_probe_resp(fc)))
 		iwl_mvm_probe_resp_set_noa(mvm, skb);
 
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 3f2aad2e7436..b1c44fa63a06 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -1094,11 +1094,6 @@ void ieee80211_send_nullfunc(struct ieee80211_local *local,
 	struct ieee80211_hdr_3addr *nullfunc;
 	struct ieee80211_if_managed *ifmgd = &sdata->u.mgd;
 
-	/* Don't send NDPs when STA is connected HE */
-	if (sdata->vif.type == NL80211_IFTYPE_STATION &&
-	    !(ifmgd->flags & IEEE80211_STA_DISABLE_HE))
-		return;
-
 	skb = ieee80211_nullfunc_get(&local->hw, &sdata->vif,
 		!ieee80211_hw_check(&local->hw, DOESNT_SUPPORT_QOS_NDP));
 	if (!skb)
@@ -1130,10 +1125,6 @@ static void ieee80211_send_4addr_nullfunc(struct ieee80211_local *local,
 	if (WARN_ON(sdata->vif.type != NL80211_IFTYPE_STATION))
 		return;
 
-	/* Don't send NDPs when connected HE */
-	if (!(sdata->u.mgd.flags & IEEE80211_STA_DISABLE_HE))
-		return;
-
 	skb = dev_alloc_skb(local->hw.extra_tx_headroom + 30);
 	if (!skb)
 		return;

