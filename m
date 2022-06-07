Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 50C2D540C39
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352001AbiFGSeb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:34:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352005AbiFGSdJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:33:09 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AFD7E45;
        Tue,  7 Jun 2022 10:57:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C7178CE2422;
        Tue,  7 Jun 2022 17:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1996C3411C;
        Tue,  7 Jun 2022 17:57:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624629;
        bh=e78sSn6tXbYpiOQJQUghVopGsX48IMqHG0LCvyMggys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJQHwwshn9jKO4MjOvvpEnpK5T9YliHa1ExAvcJaXzC/Jb+DfWUuavEdGOczJr8TO
         HJdJwe0c3/t7QElnFndljQNBHUCGjkBolPnXCbls3WWzsWnH+d8ZdLaag+0J8Nt1qf
         ekvixjijTSK9XHpKlQjwQKoRnz38KpsF+uYj3xiASw9CF7toBvg6qR2KdmvaIBmihR
         YFWcnT1LUAmHfh2teOKvHYnvD6urP2tAuN8+KoKKG7zqAK5So9xKMxmVEIOHJVM1me
         OueIE7Q7n+Sd/YtmgmLDkUTbiZ24m48PSeDUk6o9DVlycUpT2vfD3JpGppCG7Svric
         ZISkdRv9sTrDA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Soumya Negi <soumya.negi97@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, fabioaiuto83@gmail.com,
        hdegoede@redhat.com, straube.linux@gmail.com, linux@roeck-us.net,
        linux-staging@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 24/51] staging: rtl8723bs: Fix alignment to match open parenthesis
Date:   Tue,  7 Jun 2022 13:55:23 -0400
Message-Id: <20220607175552.479948-24-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
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
index 6064dd6a76b4..43cd90dc9017 100644
--- a/drivers/staging/rtl8723bs/core/rtw_ap.c
+++ b/drivers/staging/rtl8723bs/core/rtw_ap.c
@@ -519,12 +519,12 @@ void update_sta_info_apmode(struct adapter *padapter, struct sta_info *psta)
 
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
@@ -1064,10 +1064,12 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
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
@@ -1115,7 +1117,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
 	pmlmepriv->htpriv.ht_option = false;
 
 	if ((psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_TKIP) ||
-	     (psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
+	    (psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
 		/* todo: */
 		/* ht_cap = false; */
 	}
@@ -1724,7 +1726,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
 			pmlmepriv->num_sta_no_short_preamble--;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				(pmlmepriv->num_sta_no_short_preamble == 0)) {
+			    (pmlmepriv->num_sta_no_short_preamble == 0)) {
 				beacon_updated = true;
 				update_beacon(padapter, 0xFF, NULL, true);
 			}
@@ -1762,7 +1764,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
 			pmlmepriv->num_sta_no_short_slot_time++;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				 (pmlmepriv->num_sta_no_short_slot_time == 1)) {
+			    (pmlmepriv->num_sta_no_short_slot_time == 1)) {
 				beacon_updated = true;
 				update_beacon(padapter, 0xFF, NULL, true);
 			}
@@ -1774,7 +1776,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
 			pmlmepriv->num_sta_no_short_slot_time--;
 
 			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
-				 (pmlmepriv->num_sta_no_short_slot_time == 0)) {
+			    (pmlmepriv->num_sta_no_short_slot_time == 0)) {
 				beacon_updated = true;
 				update_beacon(padapter, 0xFF, NULL, true);
 			}
@@ -2023,7 +2025,7 @@ void rtw_ap_restore_network(struct adapter *padapter)
 	start_bss_network(padapter);
 
 	if ((padapter->securitypriv.dot11PrivacyAlgrthm == _TKIP_) ||
-		(padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)) {
+	    (padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)) {
 		/* restore group key, WEP keys is restored in ips_leave() */
 		rtw_set_key(
 			padapter,
@@ -2061,7 +2063,7 @@ void rtw_ap_restore_network(struct adapter *padapter)
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

