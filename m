Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F016540AED
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350895AbiFGSYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:24:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352145AbiFGSQ4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:16:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CDF11451;
        Tue,  7 Jun 2022 10:50:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 79BC961650;
        Tue,  7 Jun 2022 17:50:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C377BC385A5;
        Tue,  7 Jun 2022 17:50:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624238;
        bh=9Lp2n8TAUiczV7Wk1h+S5aJI43ikGeidpwIOf4ToTRI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pNUDm40c8RKWhrD6I+oVn5djbceqUm04u5D03qiKMx4u/7QNet4RBnGd4PVoUJxK0
         6YezoPtDemVCDK/nYLkaGgzjq0TtF14FPfTzV+PpTXkGOGWDzI4RmPMDwnfQ4n5Piz
         BhtJWh0fhYQahybZ7xQCHShpyFLCASVJws2kgSwR1q+UrcSqXzrOQEytpXH8QdXbTb
         SYJvHaQQ8LynThTO60qdq88ZRwcCh7O3UmPI35sC3y5k4y8IthBWAEyuAufu2xkd2b
         x0gbiE9FMSfIhCC0oBXWyzh4FBwBjJzx7tJmvz8urep72kJcpmqwQ0GcC31JXmiYPt
         JZS2iLi/7RToQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Soumya Negi <soumya.negi97@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fabioaiuto83@gmail.com,
        hdegoede@redhat.com, straube.linux@gmail.com,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.18 27/68] staging: rtl8723bs: Fix alignment to match open parenthesis
Date:   Tue,  7 Jun 2022 13:47:53 -0400
Message-Id: <20220607174846.477972-27-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607174846.477972-1-sashal@kernel.org>
References: <20220607174846.477972-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Soumya Negi <soumya.negi97@gmail.com>

[ Upstream commit f722d67fad290b0c960f27062adc8cf59488d0a7 ]

Adhere to Linux coding style. Fixes checkpatch warnings:
CHECK: Alignment should match open parenthesis
CHECK: line length of 101 exceeds 100 columns

Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
Link: https://lore.kernel.org/r/20220513025553.13634-1-soumya.negi97@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_ap.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_ap.c b/drivers/staging/rtl8723bs/core/rtw_ap.c
index 5478188be991..d30d6e6bcd07 100644
--- a/drivers/staging/rtl8723bs/core/rtw_ap.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ap.c
@@ -520,12 +520,12 @@ void update_sta_info_apmode(struct adapter *padapter, struct sta_info *psta)
 
 		/*  B0 Config LDPC Coding Capability */
 		if (TEST_FLAG(phtpriv_ap->ldpc_cap, LDPC_HT_ENABLE_TX) &&
-			      GET_HT_CAPABILITY_ELE_LDPC_CAP((u8 *)(&phtpriv_sta->ht_cap)))
+		    GET_HT_CAPABILITY_ELE_LDPC_CAP((u8 *)(&phtpriv_sta->ht_cap)))
 			SET_FLAG(cur_ldpc_cap, (LDPC_HT_ENABLE_TX | LDPC_HT_CAP_TX));
 
 		/*  B7 B8 B9 Config STBC setting */
 		if (TEST_FLAG(phtpriv_ap->stbc_cap, STBC_HT_ENABLE_TX) &&
-			      GET_HT_CAPABILITY_ELE_RX_STBC((u8 *)(&phtpriv_sta->ht_cap)))
+		    GET_HT_CAPABILITY_ELE_RX_STBC((u8 *)(&phtpriv_sta->ht_cap)))
 			SET_FLAG(cur_stbc_cap, (STBC_HT_ENABLE_TX | STBC_HT_CAP_TX));
 	} else {
 		phtpriv_sta->ampdu_enable = false;
@@ -1065,10 +1065,12 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 		);
 
 		if ((psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_CCMP) ||
-		     (psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_CCMP)) {
-			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY & (0x07 << 2));
+		    (psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_CCMP)) {
+			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY &
+						       (0x07 << 2));
 		} else {
-			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY & 0x00);
+			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY &
+						       0x00);
 		}
 
 		rtw_hal_get_def_var(
@@ -1116,7 +1118,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	pmlmepriv->htpriv.ht_option = false;
 
 	if ((psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_TKIP) ||
-	     (psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
+	    (psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
 		/* todo: */
 		/* ht_cap = false; */
 	}
@@ -1725,7 +1727,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
 			pmlmepriv->num_sta_no_short_preamble--;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				(pmlmepriv->num_sta_no_short_preamble == 0)) {
+			    (pmlmepriv->num_sta_no_short_preamble == 0)) {
 				beacon_updated = true;
 				update_beacon(padapter, 0xFF, NULL, true);
 			}
@@ -1763,7 +1765,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
 			pmlmepriv->num_sta_no_short_slot_time++;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				 (pmlmepriv->num_sta_no_short_slot_time == 1)) {
+			    (pmlmepriv->num_sta_no_short_slot_time == 1)) {
 				beacon_updated = true;
 				update_beacon(padapter, 0xFF, NULL, true);
 			}
@@ -1775,7 +1777,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
 			pmlmepriv->num_sta_no_short_slot_time--;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				 (pmlmepriv->num_sta_no_short_slot_time == 0)) {
+			    (pmlmepriv->num_sta_no_short_slot_time == 0)) {
 				beacon_updated = true;
 				update_beacon(padapter, 0xFF, NULL, true);
 			}
@@ -2024,7 +2026,7 @@ void rtw_ap_restore_network(struct adapter *padapter)
 	start_bss_network(padapter);
 
 	if ((padapter->securitypriv.dot11PrivacyAlgrthm == _TKIP_) ||
-		(padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)) {
+	    (padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)) {
 		/* restore group key, WEP keys is restored in ips_leave() */
 		rtw_set_key(
 			padapter,
@@ -2062,7 +2064,7 @@ void rtw_ap_restore_network(struct adapter *padapter)
 			/* pairwise key */
 			/* per sta pairwise key and settings */
 			if ((psecuritypriv->dot11PrivacyAlgrthm == _TKIP_) ||
-				(psecuritypriv->dot11PrivacyAlgrthm == _AES_)) {
+			    (psecuritypriv->dot11PrivacyAlgrthm == _AES_)) {
 				rtw_setstakey_cmd(padapter, psta, true, false);
 			}
 		}
-- 
2.35.1

