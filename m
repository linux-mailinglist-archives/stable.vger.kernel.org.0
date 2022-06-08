Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811CD5424EB
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:53:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347812AbiFHBRr convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Tue, 7 Jun 2022 21:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350103AbiFHBMK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 21:12:10 -0400
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF7CF3F89
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 17:04:13 -0700 (PDT)
Received: from omf14.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay08.hostedemail.com (Postfix) with ESMTP id 656FF20FE2;
        Wed,  8 Jun 2022 00:04:12 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf14.hostedemail.com (Postfix) with ESMTPA id F305D34;
        Wed,  8 Jun 2022 00:04:09 +0000 (UTC)
Message-ID: <ff5d5283af74576f65545399851a40cb4f16a85c.camel@perches.com>
Subject: Re: [PATCH AUTOSEL 5.15 24/51] staging: rtl8723bs: Fix alignment to
 match open parenthesis
From:   Joe Perches <joe@perches.com>
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Soumya Negi <soumya.negi97@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        fabioaiuto83@gmail.com, hdegoede@redhat.com,
        straube.linux@gmail.com, linux@roeck-us.net,
        linux-staging@lists.linux.dev
Date:   Tue, 07 Jun 2022 17:04:08 -0700
In-Reply-To: <20220607175552.479948-24-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
         <20220607175552.479948-24-sashal@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.1-0ubuntu1 
MIME-Version: 1.0
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: F305D34
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,FORGED_SPF_HELO,
        KHOP_HELO_FCRDNS,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=no
        autolearn_force=no version=3.4.6
X-Stat-Signature: pnfos8g8zpnt97ykr4brkpj7d7bm7d1h
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18P40btaGeuEf3McqHiLYo0TAdcxzePTJw=
X-HE-Tag: 1654646649-63006
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-06-07 at 13:55 -0400, Sasha Levin wrote:
> From: Soumya Negi <soumya.negi97@gmail.com>
> 
> [ Upstream commit f722d67fad290b0c960f27062adc8cf59488d0a7 ]
> 
> Adhere to Linux coding style. Fixes checkpatch warnings:
> CHECK: Alignment should match open parenthesis
> CHECK: line length of 101 exceeds 100 columns

why should this be backported?  It's only whitespace changes.

And beyond that, it's incomplete as it only realigns the second line of
statements that span 3 lines.

> 
> Signed-off-by: Soumya Negi <soumya.negi97@gmail.com>
> Link: https://lore.kernel.org/r/20220513025553.13634-1-soumya.negi97@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/staging/rtl8723bs/core/rtw_ap.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/staging/rtl8723bs/core/rtw_ap.c b/drivers/staging/rtl8723bs/core/rtw_ap.c
> index 6064dd6a76b4..43cd90dc9017 100644
> --- a/drivers/staging/rtl8723bs/core/rtw_ap.c
> +++ b/drivers/staging/rtl8723bs/core/rtw_ap.c
> @@ -519,12 +519,12 @@ void update_sta_info_apmode(struct adapter *padapter, struct sta_info *psta)
>  
>  		/*  B0 Config LDPC Coding Capability */
>  		if (TEST_FLAG(phtpriv_ap->ldpc_cap, LDPC_HT_ENABLE_TX) &&
> -			      GET_HT_CAPABILITY_ELE_LDPC_CAP((u8 *)(&phtpriv_sta->ht_cap)))
> +		    GET_HT_CAPABILITY_ELE_LDPC_CAP((u8 *)(&phtpriv_sta->ht_cap)))
>  			SET_FLAG(cur_ldpc_cap, (LDPC_HT_ENABLE_TX | LDPC_HT_CAP_TX));
>  
>  		/*  B7 B8 B9 Config STBC setting */
>  		if (TEST_FLAG(phtpriv_ap->stbc_cap, STBC_HT_ENABLE_TX) &&
> -			      GET_HT_CAPABILITY_ELE_RX_STBC((u8 *)(&phtpriv_sta->ht_cap)))
> +		    GET_HT_CAPABILITY_ELE_RX_STBC((u8 *)(&phtpriv_sta->ht_cap)))
>  			SET_FLAG(cur_stbc_cap, (STBC_HT_ENABLE_TX | STBC_HT_CAP_TX));
>  	} else {
>  		phtpriv_sta->ampdu_enable = false;
> @@ -1064,10 +1064,12 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
>  		);
>  
>  		if ((psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_CCMP) ||
> -		     (psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_CCMP)) {
> -			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY & (0x07 << 2));
> +		    (psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_CCMP)) {
> +			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY &
> +						       (0x07 << 2));
>  		} else {
> -			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY & 0x00);
> +			pht_cap->ampdu_params_info |= (IEEE80211_HT_CAP_AMPDU_DENSITY &
> +						       0x00);
>  		}
>  
>  		rtw_hal_get_def_var(
> @@ -1115,7 +1117,7 @@ int rtw_check_beacon_data(struct adapter *padapter, u8 *pbuf,  int len)
>  	pmlmepriv->htpriv.ht_option = false;
>  
>  	if ((psecuritypriv->wpa2_pairwise_cipher & WPA_CIPHER_TKIP) ||
> -	     (psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
> +	    (psecuritypriv->wpa_pairwise_cipher & WPA_CIPHER_TKIP)) {
>  		/* todo: */
>  		/* ht_cap = false; */
>  	}
> @@ -1724,7 +1726,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
>  			pmlmepriv->num_sta_no_short_preamble--;
>  
>  			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
> -				(pmlmepriv->num_sta_no_short_preamble == 0)) {
> +			    (pmlmepriv->num_sta_no_short_preamble == 0)) {
>  				beacon_updated = true;
>  				update_beacon(padapter, 0xFF, NULL, true);
>  			}
> @@ -1762,7 +1764,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
>  			pmlmepriv->num_sta_no_short_slot_time++;
>  
>  			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
> -				 (pmlmepriv->num_sta_no_short_slot_time == 1)) {
> +			    (pmlmepriv->num_sta_no_short_slot_time == 1)) {
>  				beacon_updated = true;
>  				update_beacon(padapter, 0xFF, NULL, true);
>  			}
> @@ -1774,7 +1776,7 @@ void bss_cap_update_on_sta_join(struct adapter *padapter, struct sta_info *psta)
>  			pmlmepriv->num_sta_no_short_slot_time--;
>  
>  			if ((pmlmeext->cur_wireless_mode > WIRELESS_11B) &&
> -				 (pmlmepriv->num_sta_no_short_slot_time == 0)) {
> +			    (pmlmepriv->num_sta_no_short_slot_time == 0)) {
>  				beacon_updated = true;
>  				update_beacon(padapter, 0xFF, NULL, true);
>  			}
> @@ -2023,7 +2025,7 @@ void rtw_ap_restore_network(struct adapter *padapter)
>  	start_bss_network(padapter);
>  
>  	if ((padapter->securitypriv.dot11PrivacyAlgrthm == _TKIP_) ||
> -		(padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)) {
> +	    (padapter->securitypriv.dot11PrivacyAlgrthm == _AES_)) {
>  		/* restore group key, WEP keys is restored in ips_leave() */
>  		rtw_set_key(
>  			padapter,
> @@ -2061,7 +2063,7 @@ void rtw_ap_restore_network(struct adapter *padapter)
>  			/* pairwise key */
>  			/* per sta pairwise key and settings */
>  			if ((psecuritypriv->dot11PrivacyAlgrthm == _TKIP_) ||
> -				(psecuritypriv->dot11PrivacyAlgrthm == _AES_)) {
> +			    (psecuritypriv->dot11PrivacyAlgrthm == _AES_)) {
>  				rtw_setstakey_cmd(padapter, psta, true, false);
>  			}
>  		}

