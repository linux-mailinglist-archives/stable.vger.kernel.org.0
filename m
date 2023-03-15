Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4574B6BB1AF
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:29:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232499AbjCOM3m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:29:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232462AbjCOM3V (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:29:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 943BD8F533
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:28:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A35D61D69
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:28:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68500C4339C;
        Wed, 15 Mar 2023 12:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883292;
        bh=BAKGO2Z9sbSog0ZLrQln6uqC1SWs561N9TKyc3Y0T8w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VAaiVvQKojYAyF4nPDpMwfLJRxYOBSCRLxGwONXgP+Qw0cuuD2nle2VA+THhLN3R
         UogqpX9T99a2f++onpq+s39SbW6Rz5s/gvsOzqdi1xX4F4ZgSWsL+vXv6Q7lpZ/8cq
         5PT+CYdfF4JamLULVuCjhlJOounjYBih0ARgITcU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hans de Goede <hdegoede@redhat.com>,
        Jagath Jog J <jagathjog1996@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 089/145] Staging: rtl8723bs: Placing opening { braces in previous line
Date:   Wed, 15 Mar 2023 13:12:35 +0100
Message-Id: <20230315115741.910825200@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115738.951067403@linuxfoundation.org>
References: <20230315115738.951067403@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagath Jog J <jagathjog1996@gmail.com>

[ Upstream commit 1d7280898f683ca824fc5eab5c486a583a81473b ]

Fix following checkpatch.pl error by placing opening {
braces in previous line
ERROR: that open brace { should be on the previous line

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jagath Jog J <jagathjog1996@gmail.com>
Link: https://lore.kernel.org/r/20220124034456.8665-2-jagathjog1996@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 05cbcc415c9b ("staging: rtl8723bs: Fix key-store index handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 98 ++++++-------------
 1 file changed, 32 insertions(+), 66 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 20d05b4ee63e2..2404f7f84d82a 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -113,13 +113,10 @@ static struct ieee80211_supported_band *rtw_spt_band_alloc(
 	struct ieee80211_supported_band *spt_band = NULL;
 	int n_channels, n_bitrates;
 
-	if (band == NL80211_BAND_2GHZ)
-	{
+	if (band == NL80211_BAND_2GHZ) {
 		n_channels = RTW_2G_CHANNELS_NUM;
 		n_bitrates = RTW_G_RATES_NUM;
-	}
-	else
-	{
+	} else {
 		goto exit;
 	}
 
@@ -135,8 +132,7 @@ static struct ieee80211_supported_band *rtw_spt_band_alloc(
 	spt_band->n_channels = n_channels;
 	spt_band->n_bitrates = n_bitrates;
 
-	if (band == NL80211_BAND_2GHZ)
-	{
+	if (band == NL80211_BAND_2GHZ) {
 		rtw_2g_channels_init(spt_band->channels);
 		rtw_2g_rates_init(spt_band->bitrates);
 	}
@@ -235,8 +231,7 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 	{
 		u16 wapi_len = 0;
 
-		if (rtw_get_wapi_ie(pnetwork->network.ies, pnetwork->network.ie_length, NULL, &wapi_len) > 0)
-		{
+		if (rtw_get_wapi_ie(pnetwork->network.ies, pnetwork->network.ie_length, NULL, &wapi_len) > 0) {
 			if (wapi_len > 0)
 				goto exit;
 		}
@@ -244,8 +239,7 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 
 	/* To reduce PBC Overlap rate */
 	/* spin_lock_bh(&pwdev_priv->scan_req_lock); */
-	if (adapter_wdev_data(padapter)->scan_request)
-	{
+	if (adapter_wdev_data(padapter)->scan_request) {
 		u8 *psr = NULL, sr = 0;
 		struct ndis_802_11_ssid *pssid = &pnetwork->network.ssid;
 		struct cfg80211_scan_request *request = adapter_wdev_data(padapter)->scan_request;
@@ -258,14 +252,12 @@ struct cfg80211_bss *rtw_cfg80211_inform_bss(struct adapter *padapter, struct wl
 		if (wpsie && wpsielen > 0)
 			psr = rtw_get_wps_attr_content(wpsie,  wpsielen, WPS_ATTR_SELECTED_REGISTRAR, (u8 *)(&sr), NULL);
 
-		if (sr != 0)
-		{
-			if (request->n_ssids == 1 && request->n_channels == 1) /*  it means under processing WPS */
-			{
+		if (sr != 0) {
+			/* it means under processing WPS */
+			if (request->n_ssids == 1 && request->n_channels == 1) {
 				if (ssids[0].ssid_len != 0 &&
 				    (pssid->ssid_length != ssids[0].ssid_len ||
-				     memcmp(pssid->ssid, ssids[0].ssid, ssids[0].ssid_len)))
-				{
+				     memcmp(pssid->ssid, ssids[0].ssid, ssids[0].ssid_len))) {
 					if (psr)
 						*psr = 0; /* clear sr */
 				}
@@ -374,8 +366,7 @@ void rtw_cfg80211_ibss_indicate_connect(struct adapter *padapter)
 	int freq = (int)cur_network->network.configuration.ds_config;
 	struct ieee80211_channel *chan;
 
-	if (pwdev->iftype != NL80211_IFTYPE_ADHOC)
-	{
+	if (pwdev->iftype != NL80211_IFTYPE_ADHOC) {
 		return;
 	}
 
@@ -383,14 +374,11 @@ void rtw_cfg80211_ibss_indicate_connect(struct adapter *padapter)
 		struct wlan_bssid_ex  *pnetwork = &(padapter->mlmeextpriv.mlmext_info.network);
 		struct wlan_network *scanned = pmlmepriv->cur_network_scanned;
 
-		if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true)
-		{
+		if (check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true) {
 
 			memcpy(&cur_network->network, pnetwork, sizeof(struct wlan_bssid_ex));
 			rtw_cfg80211_inform_bss(padapter, cur_network);
-		}
-		else
-		{
+		} else {
 			if (!scanned) {
 				rtw_warn_on(1);
 				return;
@@ -473,9 +461,7 @@ void rtw_cfg80211_indicate_connect(struct adapter *padapter)
 		roam_info.resp_ie_len =
 			pmlmepriv->assoc_rsp_len-sizeof(struct ieee80211_hdr_3addr)-6;
 		cfg80211_roamed(padapter->pnetdev, &roam_info, GFP_ATOMIC);
-	}
-	else
-	{
+	} else {
 		cfg80211_connect_result(padapter->pnetdev, cur_network->network.mac_address
 			, pmlmepriv->assoc_req+sizeof(struct ieee80211_hdr_3addr)+2
 			, pmlmepriv->assoc_req_len-sizeof(struct ieee80211_hdr_3addr)-2
@@ -527,24 +513,19 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
 
-	if (param_len !=  sizeof(struct ieee_param) + param->u.crypt.key_len)
-	{
+	if (param_len !=  sizeof(struct ieee_param) + param->u.crypt.key_len) {
 		ret =  -EINVAL;
 		goto exit;
 	}
 
 	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
 	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff)
-	{
-		if (param->u.crypt.idx >= WEP_KEYS)
-		{
+	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
+		if (param->u.crypt.idx >= WEP_KEYS) {
 			ret = -EINVAL;
 			goto exit;
 		}
-	}
-	else
-	{
+	} else {
 		psta = rtw_get_stainfo(pstapriv, param->sta_addr);
 		if (!psta)
 			/* ret = -EINVAL; */
@@ -554,24 +535,20 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 	if (strcmp(param->u.crypt.alg, "none") == 0 && !psta)
 		goto exit;
 
-	if (strcmp(param->u.crypt.alg, "WEP") == 0 && !psta)
-	{
+	if (strcmp(param->u.crypt.alg, "WEP") == 0 && !psta) {
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0))
-		{
+		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
 			ret = -EINVAL;
 			goto exit;
 		}
 
-		if (wep_key_len > 0)
-		{
+		if (wep_key_len > 0) {
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
 		}
 
-		if (psecuritypriv->bWepDefaultKeyIdxSet == 0)
-		{
+		if (psecuritypriv->bWepDefaultKeyIdxSet == 0) {
 			/* wep default key has not been set, so use this key index as default key. */
 
 			psecuritypriv->dot11AuthAlgrthm = dot11AuthAlgrthm_Auto;
@@ -579,8 +556,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
 			psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 
-			if (wep_key_len == 13)
-			{
+			if (wep_key_len == 13) {
 				psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
 				psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 			}
@@ -598,24 +574,19 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 	}
 
-
-	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) /* group key */
-	{
-		if (param->u.crypt.set_tx == 0) /* group key */
-		{
-			if (strcmp(param->u.crypt.alg, "WEP") == 0)
-			{
+	/* group key */
+	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
+		/* group key */
+		if (param->u.crypt.set_tx == 0) {
+			if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-				if (param->u.crypt.key_len == 13)
-				{
+				if (param->u.crypt.key_len == 13) {
 						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 				}
 
-			}
-			else if (strcmp(param->u.crypt.alg, "TKIP") == 0)
-			{
+			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
@@ -627,15 +598,11 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 				psecuritypriv->busetkipkey = true;
 
-			}
-			else if (strcmp(param->u.crypt.alg, "CCMP") == 0)
-			{
+			} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-			}
-			else
-			{
+			} else {
 				psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
 			}
 
@@ -648,8 +615,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			rtw_ap_set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
 
 			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (pbcmc_sta)
-			{
+			if (pbcmc_sta) {
 				pbcmc_sta->ieee8021x_blocked = false;
 				pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
 			}
-- 
2.39.2



