Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DAE43826D6
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 10:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231334AbhEQIZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 04:25:31 -0400
Received: from wforward1-smtp.messagingengine.com ([64.147.123.30]:45221 "EHLO
        wforward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230188AbhEQIZa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 04:25:30 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailforward.west.internal (Postfix) with ESMTP id 4340E9FE;
        Mon, 17 May 2021 04:24:14 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 17 May 2021 04:24:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=6WnEDL
        nm80arPK7XvRgar8QrLfYvp/Sl0Wa9CIiIUjc=; b=Vftw6AQx81d02x2VjP7tad
        9m+rMCqZAREghpiSmRbJIsR8DDchgVDzouRebK0M9GcZHCFwdKM4zJnFphDdeKQ0
        0Qb9fr95DTnFrwkAtITwWrKHFtTTy2Kcqn09zU87Ga7E5+qyOHlvdzumEqlavYDk
        4/NCGP0SI1RqNOgyksfE0uyUOoXUZTdFeoWC5Nh4bB6XeYxiEQZpsc+D5NvHksJH
        BQWQhXi3xvUuLmIl5QDUDvPudjOXN64axKfZlcVSD2uRCiXTT9IKzmkc6FEwrSvE
        JpTpG3GZoodFbzQHNb1hvBxLzqo7qW5hsutgkfiUW8PoaFFpqOWdcMhpX7dhX7cg
        ==
X-ME-Sender: <xms:LSiiYG_vKm9a-ZznI2HO2bs7xdmL1MlyeqCfhUYEC_XU0hGity2-Kg>
    <xme:LSiiYGvIryzjvZqyQ8RC7XwAwMNNImm0CCT0VnhmKnT0g9HakdV9TV4erxTqJnkSr
    fNvctcAwJY3KA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdeihedgtdefucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuggftrfgrthhtvghrnhepgeegkeeludekgeeglefhfefgveejgfeiudfhhfetle
    euheeliedtudegueetudeinecuffhomhgrihhnpehgnhhurdhorhhgpdhkvghrnhgvlhdr
    ohhrghenucfkphepkeefrdekiedrjeegrdeigeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:LSiiYMDP7HjZRj3Fx_fg2gUffhKFQXsdPjaKHuJxVjeciTEYKISJVA>
    <xmx:LSiiYOdgXol6jqzlWHBJS5ZTFIvacQlOWS6MJL8pqUF208N0-MyH9g>
    <xmx:LSiiYLOQdit8G5gi5u4QrBx7L8AEB0VC20ncLGN4S9lGIPIh9BOmOw>
    <xmx:LSiiYB0CFOnlHBohxbf2_nEH1YhXugry6Om6PcghvumXtl5n_p4NR3_B89U>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 17 May 2021 04:24:13 -0400 (EDT)
Subject: FAILED: patch "[PATCH] staging: rtl8723bs: avoid bogus gcc warning" failed to apply to 5.12-stable tree
To:     arnd@arndb.de, gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 17 May 2021 10:24:11 +0200
Message-ID: <162123985190222@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 14b6cff54edaca5740068e9ed070152727ed7718 Mon Sep 17 00:00:00 2001
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 22 Apr 2021 17:26:19 +0200
Subject: [PATCH] staging: rtl8723bs: avoid bogus gcc warning

gcc gets confused by some of the type casts and produces an
apparently senseless warning about an out-of-bound memcpy to
an unrelated array in the same structure:

drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c: In function 'rtw_cfg80211_ap_set_encryption':
cc1: error: writing 8 bytes into a region of size 0 [-Werror=stringop-overflow=]
In file included from drivers/staging/rtl8723bs/include/drv_types.h:32,
                 from drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c:10:
drivers/staging/rtl8723bs/include/rtw_security.h:98:15: note: at offset [184, 4264] into destination object 'dot11AuthAlgrthm' of size 4
   98 |         u32   dot11AuthAlgrthm;         /*  802.11 auth, could be open, shared, 8021x and authswitch */
      |               ^~~~~~~~~~~~~~~~
cc1: error: writing 8 bytes into a region of size 0 [-Werror=stringop-overflow=]
drivers/staging/rtl8723bs/include/rtw_security.h:98:15: note: at offset [264, 4344] into destination object 'dot11AuthAlgrthm' of size 4

This is a known gcc bug, and the patch here is only a workaround,
but the approach of using a temporary variable to hold a pointer
to the key also improves readability in addition to avoiding the
warning, so overall this should still help.

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99673
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Link: https://lore.kernel.org/r/20210422152648.2891996-1-arnd@kernel.org
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
index c1dac6eec59f..a6d731e959a2 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_cfg80211.c
@@ -527,6 +527,9 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct security_priv *psecuritypriv =  &(padapter->securitypriv);
 	struct sta_priv *pstapriv = &padapter->stapriv;
+	char *grpkey = padapter->securitypriv.dot118021XGrpKey[param->u.crypt.idx].skey;
+	char *txkey = padapter->securitypriv.dot118021XGrptxmickey[param->u.crypt.idx].skey;
+	char *rxkey = padapter->securitypriv.dot118021XGrprxmickey[param->u.crypt.idx].skey;
 
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
@@ -609,7 +612,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 		{
 			if (strcmp(param->u.crypt.alg, "WEP") == 0)
 			{
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 				if (param->u.crypt.key_len == 13)
@@ -622,12 +625,12 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			{
 				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
 				/* set mic key */
-				memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
-				memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
+				memcpy(txkey, &(param->u.crypt.key[16]), 8);
+				memcpy(rxkey, &(param->u.crypt.key[24]), 8);
 
 				psecuritypriv->busetkipkey = true;
 
@@ -636,7 +639,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			{
 				psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 			}
 			else
 			{
@@ -713,7 +716,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 			{
 				if (strcmp(param->u.crypt.alg, "WEP") == 0)
 				{
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 					psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 					if (param->u.crypt.key_len == 13)
@@ -725,12 +728,12 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 				{
 					psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 					/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
 					/* set mic key */
-					memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
-					memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
+					memcpy(txkey, &(param->u.crypt.key[16]), 8);
+					memcpy(rxkey, &(param->u.crypt.key[24]), 8);
 
 					psecuritypriv->busetkipkey = true;
 
@@ -739,7 +742,7 @@ static int rtw_cfg80211_ap_set_encryption(struct net_device *dev, struct ieee_pa
 				{
 					psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 				}
 				else
 				{
diff --git a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
index e98e5388d5c7..5088c3731b6d 100644
--- a/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/ioctl_linux.c
@@ -2963,6 +2963,9 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 	struct mlme_priv *pmlmepriv = &padapter->mlmepriv;
 	struct security_priv *psecuritypriv = &(padapter->securitypriv);
 	struct sta_priv *pstapriv = &padapter->stapriv;
+	char *txkey = padapter->securitypriv.dot118021XGrptxmickey[param->u.crypt.idx].skey;
+	char *rxkey = padapter->securitypriv.dot118021XGrprxmickey[param->u.crypt.idx].skey;
+	char *grpkey = psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey;
 
 	param->u.crypt.err = 0;
 	param->u.crypt.alg[IEEE_CRYPT_ALG_NAME_LEN - 1] = '\0';
@@ -3064,7 +3067,7 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 	if (!psta && check_fwstate(pmlmepriv, WIFI_AP_STATE)) { /*  group key */
 		if (param->u.crypt.set_tx == 1) {
 			if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 				if (param->u.crypt.key_len == 13)
@@ -3073,11 +3076,11 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 			} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 				/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
 				/* set mic key */
-				memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
+				memcpy(txkey, &(param->u.crypt.key[16]), 8);
 				memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
 
 				psecuritypriv->busetkipkey = true;
@@ -3086,7 +3089,7 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 			else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 				psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
-				memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+				memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 			} else {
 				psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
 			}
@@ -3142,7 +3145,7 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 
 			} else { /* group key??? */
 				if (strcmp(param->u.crypt.alg, "WEP") == 0) {
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 					psecuritypriv->dot118021XGrpPrivacy = _WEP40_;
 					if (param->u.crypt.key_len == 13)
@@ -3150,19 +3153,19 @@ static int rtw_set_encryption(struct net_device *dev, struct ieee_param *param,
 				} else if (strcmp(param->u.crypt.alg, "TKIP") == 0) {
 					psecuritypriv->dot118021XGrpPrivacy = _TKIP_;
 
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 
 					/* DEBUG_ERR("set key length :param->u.crypt.key_len =%d\n", param->u.crypt.key_len); */
 					/* set mic key */
-					memcpy(psecuritypriv->dot118021XGrptxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[16]), 8);
-					memcpy(psecuritypriv->dot118021XGrprxmickey[param->u.crypt.idx].skey, &(param->u.crypt.key[24]), 8);
+					memcpy(txkey, &(param->u.crypt.key[16]), 8);
+					memcpy(rxkey, &(param->u.crypt.key[24]), 8);
 
 					psecuritypriv->busetkipkey = true;
 
 				} else if (strcmp(param->u.crypt.alg, "CCMP") == 0) {
 					psecuritypriv->dot118021XGrpPrivacy = _AES_;
 
-					memcpy(psecuritypriv->dot118021XGrpKey[param->u.crypt.idx].skey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
+					memcpy(grpkey, param->u.crypt.key, (param->u.crypt.key_len > 16 ? 16 : param->u.crypt.key_len));
 				} else {
 					psecuritypriv->dot118021XGrpPrivacy = _NO_PRIVACY_;
 				}

