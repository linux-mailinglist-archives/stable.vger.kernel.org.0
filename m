Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DDD64F31E8
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242523AbiDEJhY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:37:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235787AbiDEJCl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:02:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8472B26C;
        Tue,  5 Apr 2022 01:54:25 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 081A3B81A0C;
        Tue,  5 Apr 2022 08:54:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 560A2C385A1;
        Tue,  5 Apr 2022 08:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148862;
        bh=h2v0DIlqn7MvODtMU7B5duk+eFWQY+7yWPinQ/7cefg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nF2npzTtmp/gmkK43I9f3I+82WRHvIeEGsc5GsPmlcHANv02sBUPGhLgrHm8igSSp
         SXCYSNLiZQW3DNfrjQqSOWV5yX7/NjY3+uQDN1glfkCXAXU1+UjjREgCYQxRkQbCQs
         kuz/GYs+iNRAYHsRBkNbCV0EN/WjuM1e1g6qLKsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0471/1017] mac80211: Remove a couple of obsolete TODO
Date:   Tue,  5 Apr 2022 09:23:04 +0200
Message-Id: <20220405070408.279247446@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit cee04f3c3a00ffd2a2a6ed1028e0ab58a3a28d25 ]

The HE capability IE is an extension IE so remove
an irrelevant comments.

Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Link: https://lore.kernel.org/r/iwlwifi.20211129152938.550b95b5fca7.Ia31395e880172aefcc0a8c70ed060f84b94bdb83@changeid
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/main.c | 13 +++++--------
 net/mac80211/mlme.c |  4 ----
 2 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/net/mac80211/main.c b/net/mac80211/main.c
index 45fb517591ee..5311c3cd3050 100644
--- a/net/mac80211/main.c
+++ b/net/mac80211/main.c
@@ -1131,17 +1131,14 @@ int ieee80211_register_hw(struct ieee80211_hw *hw)
 		local->scan_ies_len +=
 			2 + sizeof(struct ieee80211_vht_cap);
 
-	/* HE cap element is variable in size - set len to allow max size */
 	/*
-	 * TODO: 1 is added at the end of the calculation to accommodate for
-	 *	the temporary placing of the HE capabilities IE under EXT.
-	 *	Remove it once it is placed in the final place.
-	 */
-	if (supp_he)
+	 * HE cap element is variable in size - set len to allow max size */
+	if (supp_he) {
 		local->scan_ies_len +=
-			2 + sizeof(struct ieee80211_he_cap_elem) +
+			3 + sizeof(struct ieee80211_he_cap_elem) +
 			sizeof(struct ieee80211_he_mcs_nss_supp) +
-			IEEE80211_HE_PPE_THRES_MAX_LEN + 1;
+			IEEE80211_HE_PPE_THRES_MAX_LEN;
+	}
 
 	if (!local->ops->hw_scan) {
 		/* For hw_scan, driver needs to set these up. */
diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 404b84650161..13496ba48514 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -650,10 +650,6 @@ static void ieee80211_add_he_ie(struct ieee80211_sub_if_data *sdata,
 	if (!he_cap || !reg_cap)
 		return;
 
-	/*
-	 * TODO: the 1 added is because this temporarily is under the EXTENSION
-	 * IE. Get rid of it when it moves.
-	 */
 	he_cap_size =
 		2 + 1 + sizeof(he_cap->he_cap_elem) +
 		ieee80211_he_mcs_nss_size(&he_cap->he_cap_elem) +
-- 
2.34.1



