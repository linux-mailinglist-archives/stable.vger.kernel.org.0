Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0976B4F1B00
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:18:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379382AbiDDVTX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380561AbiDDU3C (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 16:29:02 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 365602DAB8;
        Mon,  4 Apr 2022 13:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649104016;
        bh=XggQYTpjN29EI0QjAnHOe3ojzFB98P+s1JIYmSPGk9U=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=ThKAfcYrMWNYG16aaEl7ZRsDrLM4SVnjF5K+SJtNnFJh70z2dgZn1s53AOmgc6ZTD
         Fa6PxL22P7QuCf9AY2ToRfYnL/iB/dJA/ENpkSJo+j1NoSk5TLj/bu6UXw/Y0K9HIv
         gjz9Zb/z/DkD/WMNG8G37oWNZ4dwhUMS98WezkKg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.4]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MacOQ-1o84Da1gOQ-00c8A6; Mon, 04
 Apr 2022 22:26:56 +0200
Date:   Mon, 4 Apr 2022 22:26:55 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-5.18 v2] ath9k: Fix usage of driver-private space in
 tx_info
Message-ID: <20220404222655.7276fb9d@gmx.net>
In-Reply-To: <20220404181151.2669173-1-toke@toke.dk>
References: <20220404181151.2669173-1-toke@toke.dk>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:g2JO7qtxRijOzCMvLyLpiuT0DSkEt0W5n6Fj0oAkN8j9mcpybzC
 dIYcyWTK/nygio3h4a7cghpRCxNv8rpmp7J9QYQm4CeVCsASDLnDC2GSkRTIqfpFwhaHCOt
 Lgv/y7XabokVXRHz6geZBpq5rMmWDOXIgGYwfERBRWstJYzNPFKkz4E3qDXAItd+onrEyxs
 B43JWW6jaLg5OIB0Cj1pw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:rCLng7hsjQU=:1UXbxvYAbBhbTksDA6p29k
 2YseSNNykNlFX0juF75gqDR1Z9lKtsO0B/4/ghi8XHry6i4vmh9WtjZTmVM9twe1qBYhH+i2E
 L1njqaecMEmEnDBHhxLALBhwI7VEFgyNMFFTHdvVKdrGGq8s24b30u4jTVsiJgF3G/Z8qO1Bh
 Tn0//BtmLyLVZ6VTVSVAJ48xCHfEbSBzBhLVwUSsh21mt5qdIeKe3oWYx//EpA4fqWXTxuM8O
 iXv1utCFZmoy+FCf54STambStvk5YoPGU8kyYAhcDA+dP/V0YIQWJiaTaWBcTlZJOBpVc2Il6
 RN1FXrBZ/vsY4sNAdpLragfWeIJCxEvOMg3AEw6I4D1UKDBpRNfPF0U68A+eJrd4UADeFQmXZ
 g1q8wFlMx6V2Nyh1bTaTVwGcOdV8Z9QOcLkVopO5bfqAhgpd2GKESR3OiSr7JbTVe2e89lh8j
 Xfb5SmeDsaB/pyjTubuRZeutVAw0B/a3z4MNTIRPqUxRxr/kSZVkPIV3VEYwS37A9sC342PTK
 W7UNSUCPdFLSm6+RSKKv1NlByh5f8Kvgnl+GStZ9AgPCaLgM+y6+L9goOF/zPCx7Do6GI5G9x
 OGuplwu19CVez+cVzV5ETUHIkJQlqeni5pPxtB9N7aFyt8C8hyIbrZxec/pt+o5xDPDCEZq79
 HgnzNBJtxoZZXcVDdjLEmxpc09U+dhRb3Rprb1CtrDhJ4mqozvxcOl+oFU44tkZjtfoS/Ncu4
 Th+cTCAH+jRz072XKOmtBp9atbbi4Ti04hh5XHyPbOTHJP5aKLm6X7y1mbZXGLsFSpdSeQXlS
 WOz9eFjxMQPohm5gD+rZECZxDhFuHgKIoyzVylQQj9J6Rmnl+IzeD3MZxVssCdgJEMHbjNrTN
 MrNRB6jgxAK77rzdYKf/8eqz4iH8ek84UWC/D2UNk7bUe4yp8uyCr96xlpFTACtIYSD4PYL2C
 tWOV6jmzIe3eGbq7P3wJbNda52PLIBAKpKrV7VqIDb7kVQGaJX5FzbHFA0+qWqGtlfTjsYCyD
 Q90uHugKwt1xWPA+rIFBrptT17PwOAaI1qkuyXyZqwO+rJpHIs5BafQnLD46hHbHgkNhSgvTz
 CiKVA28IdYA9KY=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Toke,

On Mon,  4 Apr 2022 20:11:51 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
toke.dk> wrote:

> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>=20
> The ieee80211_tx_info_clear_status() helper also clears the rate counts a=
nd
> the driver-private part of struct ieee80211_tx_info, so using it breaks
> quite a few other things. So back out of using it, and instead define a
> ath-internal helper that only clears the area between the
> status_driver_data and the rates info. Combined with moving the
> ath_frame_info struct to status_driver_data, this avoids clearing anything
> we shouldn't be, and so we can keep the existing code for handling the ra=
te
> information.
>=20
> While fixing this I also noticed that the setting of
> tx_info->status.rates[tx_rateindex].count on hardware underrun errors was
> always immediately overridden by the normal setting of the same fields, so
> rearrange the code so that the underrun detection actually takes effect.
>=20
> The new helper could be generalised to a 'memset_between()' helper, but
> leave it as a driver-internal helper for now since this needs to go to
> stable.
>=20
> Cc: stable@vger.kernel.org
> Reported-by: Peter Seiderer <ps.report@gmx.net>
> Fixes: 037250f0a45c ("ath9k: Properly clear TX status area before reporti=
ng to mac80211")
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  drivers/net/wireless/ath/ath9k/xmit.c | 30 ++++++++++++++++++---------
>  1 file changed, 20 insertions(+), 10 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless=
/ath/ath9k/xmit.c
> index cbcf96ac303e..db83cc4ba810 100644
> --- a/drivers/net/wireless/ath/ath9k/xmit.c
> +++ b/drivers/net/wireless/ath/ath9k/xmit.c
> @@ -141,8 +141,8 @@ static struct ath_frame_info *get_frame_info(struct s=
k_buff *skb)
>  {
>  	struct ieee80211_tx_info *tx_info =3D IEEE80211_SKB_CB(skb);
>  	BUILD_BUG_ON(sizeof(struct ath_frame_info) >
> -		     sizeof(tx_info->rate_driver_data));
> -	return (struct ath_frame_info *) &tx_info->rate_driver_data[0];
> +		     sizeof(tx_info->status.status_driver_data));
> +	return (struct ath_frame_info *) &tx_info->status.status_driver_data[0];
>  }

Would be too easy if all locations would use get_frame_info()..., at least =
one location
in drivers/net/wireless/ath/ath9k/main.c uses direct access:

 841                 txinfo =3D IEEE80211_SKB_CB(bf->bf_mpdu);
 842                 fi =3D (struct ath_frame_info *)&txinfo->rate_driver_d=
ata[0];
 843                 if (fi->keyix =3D=3D keyix)
 844                         return true;

Regards,
Peter


> =20
>  static void ath_send_bar(struct ath_atx_tid *tid, u16 seqno)
> @@ -2542,6 +2542,16 @@ static void ath_tx_complete_buf(struct ath_softc *=
sc, struct ath_buf *bf,
>  	spin_unlock_irqrestore(&sc->tx.txbuflock, flags);
>  }
> =20
> +static void ath_clear_tx_status(struct ieee80211_tx_info *tx_info)
> +{
> +	void *ptr =3D &tx_info->status;
> +
> +	memset(ptr + sizeof(tx_info->status.rates), 0,
> +	       sizeof(tx_info->status) -
> +	       sizeof(tx_info->status.rates) -
> +	       sizeof(tx_info->status.status_driver_data));
> +}
> +
>  static void ath_tx_rc_status(struct ath_softc *sc, struct ath_buf *bf,
>  			     struct ath_tx_status *ts, int nframes, int nbad,
>  			     int txok)
> @@ -2553,7 +2563,7 @@ static void ath_tx_rc_status(struct ath_softc *sc, =
struct ath_buf *bf,
>  	struct ath_hw *ah =3D sc->sc_ah;
>  	u8 i, tx_rateindex;
> =20
> -	ieee80211_tx_info_clear_status(tx_info);
> +	ath_clear_tx_status(tx_info);
> =20
>  	if (txok)
>  		tx_info->status.ack_signal =3D ts->ts_rssi;
> @@ -2569,6 +2579,13 @@ static void ath_tx_rc_status(struct ath_softc *sc,=
 struct ath_buf *bf,
>  	tx_info->status.ampdu_len =3D nframes;
>  	tx_info->status.ampdu_ack_len =3D nframes - nbad;
> =20
> +	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
> +
> +	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
> +		tx_info->status.rates[i].count =3D 0;
> +		tx_info->status.rates[i].idx =3D -1;
> +	}
> +
>  	if ((ts->ts_status & ATH9K_TXERR_FILT) =3D=3D 0 &&
>  	    (tx_info->flags & IEEE80211_TX_CTL_NO_ACK) =3D=3D 0) {
>  		/*
> @@ -2590,13 +2607,6 @@ static void ath_tx_rc_status(struct ath_softc *sc,=
 struct ath_buf *bf,
>  			tx_info->status.rates[tx_rateindex].count =3D
>  				hw->max_rate_tries;
>  	}
> -
> -	for (i =3D tx_rateindex + 1; i < hw->max_rates; i++) {
> -		tx_info->status.rates[i].count =3D 0;
> -		tx_info->status.rates[i].idx =3D -1;
> -	}
> -
> -	tx_info->status.rates[tx_rateindex].count =3D ts->ts_longretry + 1;
>  }
> =20
>  static void ath_tx_processq(struct ath_softc *sc, struct ath_txq *txq)

