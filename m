Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B55C16BB1A9
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:29:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232469AbjCOM3d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:29:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbjCOM3Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:29:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 336E9222D5
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:28:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4BC4B81DFC
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062B9C433D2;
        Wed, 15 Mar 2023 12:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883295;
        bh=DMW5dEtCKmCNGsUcCp/IspbgbDF6mcgfe3Ow21qoQfY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wsY3zcqn43wYd3bjh6Kpu7uXyjs4vS9ViB+cfaRNNlReipdmHqgShL6eqdZmN2uG9
         uDygH2PI8itYLcU/VHtkZaVErBLvGwHmxYicToQWtcC1TwcGxsW6JdUueV5ZNhEFrQ
         MLCufkEOlow2YGgUX4ftaMk8Xe4Wn2Q8g2izmbJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hannes Braun <hannesbraun@mail.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 090/145] staging: rtl8723bs: fix placement of braces
Date:   Wed, 15 Mar 2023 13:12:36 +0100
Message-Id: <20230315115741.939100946@linuxfoundation.org>
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

From: Hannes Braun <hannesbraun@mail.de>

[ Upstream commit a8b088d6d98dafddda9874f98ac2a7cefc51639b ]

This patch should eliminate the following errors/warnings emitted by
checkpatch.pl:
- that open brace { should be on the previous line
- else should follow close brace '}'
- braces {} are not necessary for single statement blocks

Signed-off-by: Hannes Braun <hannesbraun@mail.de>
Link: https://lore.kernel.org/r/20220528123115.13024-1-hannesbraun@mail.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 05cbcc415c9b ("staging: rtl8723bs: Fix key-store index handling")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../staging/rtl8723bs/os_dep/ioctl_cfg80211.c | 223 +++++-------------
 1 file changed, 65 insertions(+), 158 deletions(-)

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index 2404f7f84d82a..b7a3f3df72723 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -366,9 +366,8 @@ void rtw_cfg80211_ibss_indicate_connect(struct adapter *padapter)
 	int freq = (int)cur_network->network.configuration.ds_config;
 	struct ieee80211_channel *chan;
 
-	if (pwdev->iftype != NL80211_IFTYPE_ADHOC) {
+	if (pwdev->iftype != NL80211_IFTYPE_ADHOC)
 		return;
-	}
 
 	if (!rtw_cfg80211_check_bss(padapter)) {
 		struct wlan_bssid_ex  *pnetwork = &(padapter->mlmeextpriv.mlmext_info.network);
@@ -544,9 +543,8 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			goto exit;
 		}
 
-		if (wep_key_len > 0) {
+		if (wep_key_len > 0)
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
-		}
 
 		if (psecuritypriv->bWepDefaultKeyIdxSet == 0) {
 			/* wep default key has not been set, so use this key index as default key. */
@@ -582,9 +580,8 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-				if (param->u.crypt.key_len == 13) {
+				if (param->u.crypt.key_len == 13)
 						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-				}
 
 			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
@@ -626,24 +623,16 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 	}
 
-	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X && psta) /*  psk/802_1x */
-	{
-		if (check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		{
-			if (param->u.crypt.set_tx == 1) /* pairwise key */
-			{
+	if (psecuritypriv->dot11AuthAlgrthm == dot11AuthAlgrthm_8021X && psta) { /*  psk/802_1x */
+		if (check_fwstate(pmlmepriv, WIFI_AP_STATE)) {
+			if (param->u.crypt.set_tx == 1) { /* pairwise key */
 				memcpy(psta->dot118021x_UncstKey.skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
-				if (strcmp(param->u.crypt.alg, "WEP") == 0)
-				{
+				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 					psta->dot118021XPrivacy = _WEP40_;
 					if (param->u.crypt.key_len == 13)
-					{
 						psta->dot118021XPrivacy = _WEP104_;
-					}
-				}
-				else if (strcmp(param->u.crypt.alg, "TKIP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 					psta->dot118021XPrivacy = _TKIP_;
 
 					/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
@@ -653,14 +642,10 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 					psecuritypriv->busetkipkey = true;
 
-				}
-				else if (strcmp(param->u.crypt.alg, "CCMP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 
 					psta->dot118021XPrivacy = _AES_;
-				}
-				else
-				{
+				} else {
 					psta->dot118021XPrivacy = _NO_PRIVACY_;
 				}
 
@@ -670,21 +655,14 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 				psta->bpairwise_key_installed = true;
 
-			}
-			else/* group key??? */
-			{
-				if (strcmp(param->u.crypt.alg, "WEP") == 0)
-				{
+			} else { /* group key??? */
+				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 					psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 					if (param->u.crypt.key_len == 13)
-					{
 						psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
-					}
-				}
-				else if (strcmp(param->u.crypt.alg, "TKIP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 					psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
 					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
@@ -696,15 +674,11 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 
 					psecuritypriv->busetkipkey = true;
 
-				}
-				else if (strcmp(param->u.crypt.alg, "CCMP") == 0)
-				{
+				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 					psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
 					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
-				}
-				else
-				{
+				} else {
 					psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
 				}
 
@@ -717,8 +691,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 				rtw_ap_set_group_key(padapter, param->u.crypt.key, psecuritypriv->dot118021XGrpPrivacy, param->u.crypt.idx);
 
 				pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-				if (pbcmc_sta)
-				{
+				if (pbcmc_sta) {
 					pbcmc_sta->ieee8021x_blocked = false;
 					pbcmc_sta->dot118021XPrivacy = psecuritypriv->dot118021XGrpPrivacy;/* rx will use bmc_sta's dot118021XPrivacy */
 				}
@@ -746,20 +719,16 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
 
-	if (param_len < (u32) ((u8 *) param->u.crypt.key - (u8 *) param) + param->u.crypt.key_len)
-	{
+	if (param_len < (u32) ((u8 *) param->u.crypt.key - (u8 *) param) + param->u.crypt.key_len) {
 		ret =  -EINVAL;
 		goto exit;
 	}
 
 	if (param->sta_addr[0] == 0xff && param->sta_addr[1] == 0xff &&
 	    param->sta_addr[2] == 0xff && param->sta_addr[3] == 0xff &&
-	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff)
-	{
+	    param->sta_addr[4] == 0xff && param->sta_addr[5] == 0xff) {
 		if (param->u.crypt.idx >= WEP_KEYS
-			|| param->u.crypt.idx >= BIP_MAX_KEYID
-		)
-		{
+			|| param->u.crypt.idx >= BIP_MAX_KEYID) {
 			ret = -EINVAL;
 			goto exit;
 		}
@@ -770,19 +739,16 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 	}
 	}
 
-	if (strcmp(param->u.crypt.alg, "WEP") == 0)
-	{
+	if (strcmp(param->u.crypt.alg, "WEP") == 0) {
 		wep_key_idx = param->u.crypt.idx;
 		wep_key_len = param->u.crypt.key_len;
 
-		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0))
-		{
+		if ((wep_key_idx >= WEP_KEYS) || (wep_key_len <= 0)) {
 			ret = -EINVAL;
 			goto exit;
 		}
 
-		if (psecuritypriv->bWepDefaultKeyIdxSet == 0)
-		{
+		if (psecuritypriv->bWepDefaultKeyIdxSet == 0) {
 			/* wep default key has not been set, so use this key index as default key. */
 
 			wep_key_len = wep_key_len <= 5 ? 5 : 13;
@@ -791,8 +757,7 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 			psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
 			psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 
-			if (wep_key_len == 13)
-			{
+			if (wep_key_len == 13) {
 				psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
 				psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 			}
@@ -809,13 +774,11 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 		goto exit;
 	}
 
-	if (padapter->securitypriv.dot11AuthAlgrthm == dot11AuthAlgrthm_8021X) /*  802_1x */
-	{
+	if (padapter->securitypriv.dot11AuthAlgrthm == dot11AuthAlgrthm_8021X) { /*  802_1x */
 		struct sta_info *psta, *pbcmc_sta;
 		struct sta_priv *pstapriv = &padapter->stapriv;
 
-		if (check_fwstate(pmlmepriv, WIFI_STATION_STATE | WIFI_MP_STATE) == true) /* sta mode */
-		{
+		if (check_fwstate(pmlmepriv, WIFI_STATION_STATE | WIFI_MP_STATE) == true) { /* sta mode */
 			psta = rtw_get_stainfo(pstapriv, get_bssid(pmlmepriv));
 			if (psta) {
 				/* Jeff: don't disable ieee8021x_blocked while clearing key */
@@ -824,18 +787,15 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 
 
 				if ((padapter->securitypriv.ndisencryptstatus == Ndis802_11Encryption2Enabled) ||
-						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled))
-				{
+						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled)) {
 					psta->dot118021XPrivacy = padapter->securitypriv.dot11PrivacyAlgrthm;
 				}
 
-				if (param->u.crypt.set_tx == 1)/* pairwise key */
-				{
+				if (param->u.crypt.set_tx == 1) { /* pairwise key */
 
 					memcpy(psta->dot118021x_UncstKey.skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
-					if (strcmp(param->u.crypt.alg, "TKIP") == 0)/* set mic key */
-					{
+					if (strcmp(param->u.crypt.alg, "TKIP") == 0) { /* set mic key */
 						/* DEBUG_ERR(("\nset key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len)); */
 						memcpy(psta->dot11tkiptxmickey.skey, &(param->u.crypt.key[16]), 8);
 						memcpy(psta->dot11tkiprxmickey.skey, &(param->u.crypt.key[24]), 8);
@@ -845,11 +805,8 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 					}
 
 					rtw_setstakey_cmd(padapter, psta, true, true);
-				}
-				else/* group key */
-				{
-					if (strcmp(param->u.crypt.alg, "TKIP") == 0 || strcmp(param->u.crypt.alg, "CCMP") == 0)
-					{
+				} else { /* group key */
+					if (strcmp(param->u.crypt.alg, "TKIP") == 0 || strcmp(param->u.crypt.alg, "CCMP") == 0) {
 						memcpy(padapter->securitypriv.dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 						memcpy(padapter->securitypriv.dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
 						memcpy(padapter->securitypriv.dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
@@ -857,9 +814,7 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 
 						padapter->securitypriv.dot118021XGrpKeyid = param->u.crypt.idx;
 						rtw_set_key(padapter, &padapter->securitypriv, param->u.crypt.idx, 1, true);
-					}
-					else if (strcmp(param->u.crypt.alg, "BIP") == 0)
-					{
+					} else if (strcmp(param->u.crypt.alg, "BIP") == 0) {
 						/* save the IGTK key, length 16 bytes */
 						memcpy(padapter->securitypriv.dot11wBIPKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 						/*
@@ -873,25 +828,19 @@ static int rtw_cfg80211_set_encryption(struct net_device *dev, struct ieee_param
 			}
 
 			pbcmc_sta = rtw_get_bcmc_stainfo(padapter);
-			if (!pbcmc_sta)
-			{
+			if (!pbcmc_sta) {
 				/* DEBUG_ERR(("Set OID_802_11_ADD_KEY: bcmc stainfo is null\n")); */
-			}
-			else
-			{
+			} else {
 				/* Jeff: don't disable ieee8021x_blocked while clearing key */
 				if (strcmp(param->u.crypt.alg, "none") != 0)
 					pbcmc_sta->ieee8021x_blocked = false;
 
 				if ((padapter->securitypriv.ndisencryptstatus == Ndis802_11Encryption2Enabled) ||
-						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled))
-				{
+						(padapter->securitypriv.ndisencryptstatus ==  Ndis802_11Encryption3Enabled)) {
 					pbcmc_sta->dot118021XPrivacy = padapter->securitypriv.dot11PrivacyAlgrthm;
 				}
 			}
-		}
-		else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)) /* adhoc mode */
-		{
+		} else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)) { /* adhoc mode */
 		}
 	}
 
@@ -949,39 +898,29 @@ static int cfg80211_rtw_add_key(struct wiphy *wiphy, struct net_device *ndev,
 
 
 	if (!mac_addr || is_broadcast_ether_addr(mac_addr))
-	{
 		param->u.crypt.set_tx = 0; /* for wpa/wpa2 group key */
-	} else {
+	else
 		param->u.crypt.set_tx = 1; /* for wpa/wpa2 pairwise key */
-	}
 
 	param->u.crypt.idx = key_index;
 
 	if (params->seq_len && params->seq)
-	{
 		memcpy(param->u.crypt.seq, (u8 *)params->seq, params->seq_len);
-	}
 
-	if (params->key_len && params->key)
-	{
+	if (params->key_len && params->key) {
 		param->u.crypt.key_len = params->key_len;
 		memcpy(param->u.crypt.key, (u8 *)params->key, params->key_len);
 	}
 
-	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) == true)
-	{
+	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE) == true) {
 		ret =  rtw_cfg80211_set_encryption(ndev, param, param_len);
-	}
-	else if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true)
-	{
+	} else if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true) {
 		if (mac_addr)
 			memcpy(param->sta_addr, (void *)mac_addr, ETH_ALEN);
 
 		ret = rtw_cfg80211_ap_set_encryption(ndev, param, param_len);
-	}
-        else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) == true
-                || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true)
-        {
+	} else if (check_fwstate(pmlmepriv, WIFI_ADHOC_STATE) == true
+                || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE) == true) {
                 ret =  rtw_cfg80211_set_encryption(ndev, param, param_len);
         }
 
@@ -1007,8 +946,7 @@ static int cfg80211_rtw_del_key(struct wiphy *wiphy, struct net_device *ndev,
 	struct adapter *padapter = rtw_netdev_priv(ndev);
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 
-	if (key_index == psecuritypriv->dot11PrivacyKeyIndex)
-	{
+	if (key_index == psecuritypriv->dot11PrivacyKeyIndex) {
 		/* clear the flag of wep default key set. */
 		psecuritypriv->bWepDefaultKeyIdxSet = 0;
 	}
@@ -1024,16 +962,14 @@ static int cfg80211_rtw_set_default_key(struct wiphy *wiphy,
 	struct adapter *padapter = rtw_netdev_priv(ndev);
 	struct security_priv *psecuritypriv = &padapter->securitypriv;
 
-	if ((key_index < WEP_KEYS) && ((psecuritypriv->dot11PrivacyAlgrthm == _WEP40_) || (psecuritypriv->dot11PrivacyAlgrthm == _WEP104_))) /* set wep default key */
-	{
+	if ((key_index < WEP_KEYS) && ((psecuritypriv->dot11PrivacyAlgrthm == _WEP40_) || (psecuritypriv->dot11PrivacyAlgrthm == _WEP104_))) { /* set wep default key */
 		psecuritypriv->ndisencryptstatus = Ndis802_11Encryption1Enabled;
 
 		psecuritypriv->dot11PrivacyKeyIndex = key_index;
 
 		psecuritypriv->dot11PrivacyAlgrthm = _WEP40_;
 		psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
-		if (psecuritypriv->dot11DefKeylen[key_index] == 13)
-		{
+		if (psecuritypriv->dot11DefKeylen[key_index] == 13) {
 			psecuritypriv->dot11PrivacyAlgrthm = _WEP104_;
 			psecuritypriv->dot118021XGrpPrivacy = _WEP104_;
 		}
@@ -1071,9 +1007,7 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 
 	/* for infra./P2PClient mode */
 	if (check_fwstate(pmlmepriv, WIFI_STATION_STATE)
-		&& check_fwstate(pmlmepriv, _FW_LINKED)
-	)
-	{
+		&& check_fwstate(pmlmepriv, _FW_LINKED)) {
 		struct wlan_network  *cur_network = &(pmlmepriv->cur_network);
 
 		if (memcmp((u8 *)mac, cur_network->network.mac_address, ETH_ALEN)) {
@@ -1099,9 +1033,7 @@ static int cfg80211_rtw_get_station(struct wiphy *wiphy,
 	if ((check_fwstate(pmlmepriv, WIFI_ADHOC_STATE)
  || check_fwstate(pmlmepriv, WIFI_ADHOC_MASTER_STATE)
  || check_fwstate(pmlmepriv, WIFI_AP_STATE))
-		&& check_fwstate(pmlmepriv, _FW_LINKED)
-	)
-	{
+		&& check_fwstate(pmlmepriv, _FW_LINKED)) {
 		/* TODO: should acquire station info... */
 	}
 
@@ -1121,8 +1053,7 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 	struct mlme_ext_priv *pmlmeext = &(padapter->mlmeextpriv);
 	int ret = 0;
 
-	if (adapter_to_dvobj(padapter)->processing_dev_remove == true)
-	{
+	if (adapter_to_dvobj(padapter)->processing_dev_remove == true) {
 		ret = -EPERM;
 		goto exit;
 	}
@@ -1141,8 +1072,7 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 
 	old_type = rtw_wdev->iftype;
 
-	if (old_type != type)
-	{
+	if (old_type != type) {
 		pmlmeext->action_public_rxseq = 0xffff;
 		pmlmeext->action_public_dialog_token = 0xff;
 	}
@@ -1164,8 +1094,7 @@ static int cfg80211_rtw_change_iface(struct wiphy *wiphy,
 
 	rtw_wdev->iftype = type;
 
-	if (rtw_set_802_11_infrastructure_mode(padapter, networkType) == false)
-	{
+	if (rtw_set_802_11_infrastructure_mode(padapter, networkType) == false) {
 		rtw_wdev->iftype = old_type;
 		ret = -EPERM;
 		goto exit;
@@ -1230,9 +1159,7 @@ void rtw_cfg80211_surveydone_event_callback(struct adapter *padapter)
 
 		/* report network only if the current channel set contains the channel to which this network belongs */
 		if (rtw_ch_set_search_ch(padapter->mlmeextpriv.channel_set, pnetwork->network.configuration.ds_config) >= 0
-			&& true == rtw_validate_ssid(&(pnetwork->network.ssid))
-		)
-		{
+			&& true == rtw_validate_ssid(&(pnetwork->network.ssid))) {
 			/* ev =translate_scan(padapter, a, pnetwork, ev, stop); */
 			rtw_cfg80211_inform_bss(padapter, pnetwork);
 		}
@@ -1249,13 +1176,10 @@ static int rtw_cfg80211_set_probe_req_wpsp2pie(struct adapter *padapter, char *b
 	u8 *wps_ie;
 	struct mlme_priv *pmlmepriv = &(padapter->mlmepriv);
 
-	if (len > 0)
-	{
+	if (len > 0) {
 		wps_ie = rtw_get_wps_ie(buf, len, NULL, &wps_ielen);
-		if (wps_ie)
-		{
-			if (pmlmepriv->wps_probe_req_ie)
-			{
+		if (wps_ie) {
+			if (pmlmepriv->wps_probe_req_ie) {
 				pmlmepriv->wps_probe_req_ie_len = 0;
 				kfree(pmlmepriv->wps_probe_req_ie);
 				pmlmepriv->wps_probe_req_ie = NULL;
@@ -1307,10 +1231,8 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 	pwdev_priv->scan_request = request;
 	spin_unlock_bh(&pwdev_priv->scan_req_lock);
 
-	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true)
-	{
-		if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS|_FW_UNDER_SURVEY|_FW_UNDER_LINKING) == true)
-		{
+	if (check_fwstate(pmlmepriv, WIFI_AP_STATE) == true) {
+		if (check_fwstate(pmlmepriv, WIFI_UNDER_WPS|_FW_UNDER_SURVEY|_FW_UNDER_LINKING) == true) {
 			need_indicate_scan_done = true;
 			goto check_need_indicate_scan_done;
 		}
@@ -1333,15 +1255,13 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 		goto check_need_indicate_scan_done;
 	}
 
-	if (pmlmepriv->LinkDetectInfo.bBusyTraffic == true)
-	{
+	if (pmlmepriv->LinkDetectInfo.bBusyTraffic == true) {
 		static unsigned long lastscantime = 0;
 		unsigned long passtime;
 
 		passtime = jiffies_to_msecs(jiffies - lastscantime);
 		lastscantime = jiffies;
-		if (passtime > 12000)
-		{
+		if (passtime > 12000) {
 			need_indicate_scan_done = true;
 			goto check_need_indicate_scan_done;
 		}
@@ -1380,9 +1300,7 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 	} else if (request->n_channels <= 4) {
 		for (j = request->n_channels - 1; j >= 0; j--)
 			for (i = 0; i < survey_times; i++)
-		{
 			memcpy(&ch[j*survey_times+i], &ch[j], sizeof(struct rtw_ieee80211_channel));
-		}
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, ch, survey_times * request->n_channels);
 	} else {
 		_status = rtw_sitesurvey_cmd(padapter, ssid, RTW_SSID_SCAN_AMOUNT, NULL, 0);
@@ -1391,14 +1309,11 @@ static int cfg80211_rtw_scan(struct wiphy *wiphy
 
 
 	if (_status == false)
-	{
 		ret = -1;
-	}
 
 check_need_indicate_scan_done:
 	kfree(ssid);
-	if (need_indicate_scan_done)
-	{
+	if (need_indicate_scan_done) {
 		rtw_cfg80211_surveydone_event_callback(padapter);
 		rtw_cfg80211_indicate_scan_done(padapter, false);
 	}
@@ -1424,9 +1339,7 @@ static int rtw_cfg80211_set_wpa_version(struct security_priv *psecuritypriv, u32
 
 
 	if (wpa_version & (NL80211_WPA_VERSION_1 | NL80211_WPA_VERSION_2))
-	{
 		psecuritypriv->ndisauthtype = Ndis802_11AuthModeWPAPSK;
-	}
 
 	return 0;
 
@@ -1585,8 +1498,7 @@ static int rtw_cfg80211_set_wpa_ie(struct adapter *padapter, u8 *pie, size_t iel
 	if (pairwise_cipher == 0)
 		pairwise_cipher = WPA_CIPHER_NONE;
 
-	switch (group_cipher)
-	{
+	switch (group_cipher) {
 		case WPA_CIPHER_NONE:
 			padapter->securitypriv.dot118021XGrpPrivacy = _NO_PRIVACY_;
 			padapter->securitypriv.ndisencryptstatus = Ndis802_11EncryptionDisabled;
@@ -1609,8 +1521,7 @@ static int rtw_cfg80211_set_wpa_ie(struct adapter *padapter, u8 *pie, size_t iel
 			break;
 	}
 
-	switch (pairwise_cipher)
-	{
+	switch (pairwise_cipher) {
 		case WPA_CIPHER_NONE:
 			padapter->securitypriv.dot11PrivacyAlgrthm = _NO_PRIVACY_;
 			padapter->securitypriv.ndisencryptstatus = Ndis802_11EncryptionDisabled;
@@ -1731,8 +1642,7 @@ static int cfg80211_rtw_leave_ibss(struct wiphy *wiphy, struct net_device *ndev)
 
 		rtw_wdev->iftype = NL80211_IFTYPE_STATION;
 
-		if (rtw_set_802_11_infrastructure_mode(padapter, Ndis802_11Infrastructure) == false)
-		{
+		if (rtw_set_802_11_infrastructure_mode(padapter, Ndis802_11Infrastructure) == false) {
 			rtw_wdev->iftype = old_type;
 			ret = -EPERM;
 			goto leave_ibss;
@@ -1792,9 +1702,8 @@ static int cfg80211_rtw_connect(struct wiphy *wiphy, struct net_device *ndev,
 		ret = -EBUSY;
 		goto exit;
 	}
-	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true) {
+	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
 		rtw_scan_abort(padapter);
-	}
 
 	psecuritypriv->ndisencryptstatus = Ndis802_11EncryptionDisabled;
 	psecuritypriv->dot11PrivacyAlgrthm = _NO_PRIVACY_;
@@ -2287,9 +2196,8 @@ static int rtw_cfg80211_add_monitor_if(struct adapter *padapter, char *name, str
 	mon_ndev->ieee80211_ptr = mon_wdev;
 
 	ret = cfg80211_register_netdevice(mon_ndev);
-	if (ret) {
+	if (ret)
 		goto out;
-	}
 
 	*ndev = pwdev_priv->pmon_ndev = mon_ndev;
 	memcpy(pwdev_priv->ifname_mon, name, IFNAMSIZ+1);
@@ -2402,11 +2310,10 @@ static int rtw_add_beacon(struct adapter *adapter, const u8 *head, size_t head_l
 	rtw_ies_remove_ie(pbuf, &len, _BEACON_IE_OFFSET_, WLAN_EID_VENDOR_SPECIFIC, P2P_OUI, 4);
 	rtw_ies_remove_ie(pbuf, &len, _BEACON_IE_OFFSET_, WLAN_EID_VENDOR_SPECIFIC, WFD_OUI, 4);
 
-	if (rtw_check_beacon_data(adapter, pbuf,  len) == _SUCCESS) {
+	if (rtw_check_beacon_data(adapter, pbuf,  len) == _SUCCESS)
 		ret = 0;
-	} else {
+	else
 		ret = -EINVAL;
-	}
 
 
 	kfree(pbuf);
-- 
2.39.2



