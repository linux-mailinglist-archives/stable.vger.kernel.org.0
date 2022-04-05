Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B61CD4F47CC
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240202AbiDEVVI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:21:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1457827AbiDEQvT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 12:51:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AE2E1EEF7;
        Tue,  5 Apr 2022 09:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649177350;
        bh=1vKIY1gt3vNVn9t8j/gQpo9Svf0e2HT6996YcqD20j0=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=Rdvc3SUdaMu6xlV9oRqJf63w+sA/Ev6pmXyhr6xsCvd3u7wJgj5sdBeF+qN7rpwnR
         XmE09JmpVH39ujD0tBH9U6sx95qfQw33fsXbtmlAcryy5QZI+hVFtk0IldxntZGYYa
         VYwiBl/DRlN7gnBwT8rGrVJhVg4ACOJ+zDkLLnt8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost ([62.216.209.249]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1Mwfac-1nwBdU00K2-00yAw9; Tue, 05
 Apr 2022 18:49:10 +0200
Date:   Tue, 5 Apr 2022 18:49:08 +0200
From:   Peter Seiderer <ps.report@gmx.net>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@toke.dk>
Cc:     Kalle Valo <kvalo@kernel.org>, linux-wireless@vger.kernel.org,
        Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH for-5.18 v3] ath9k: Fix usage of driver-private space in
 tx_info
Message-ID: <20220405184908.7fb44111@gmx.net>
In-Reply-To: <20220404204800.2681133-1-toke@toke.dk>
References: <20220404204800.2681133-1-toke@toke.dk>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ceKWhUrIGRqutIOUnCDDKP1g11zL2it54z2JX7OfhXfiQGUXDKo
 onAaeaJSvRSxxI/JYGus9IQpCXIFjLXGZsBgTnqlnYBmXQ0284XKHHqVkh5Pu3KX560NH9A
 C1Uh+J0AYaNE/+yDhPFJRZTz3fBV7cZt0zZAQBXnWPOxt1mu4cBlFWjKxo9OSNw4+ce/Rx5
 JgaOXpGkECgXlUrWTTSWA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Y4mTKqgVeVM=:m5SnoiftRPvZflGXeSlutK
 +Qa7CahFsT41kQLd2kudItf5vW0qCEzYjfeb5T4/Hfq7TtB/XL5TfSUB7H12tEdjNroRLNRBD
 JClwaVBvFd309cfG8ossvKHMXbxlPabQDAniTTTcAIlWn5C+iTEe8yGfbjA6sCEL2hKwrVkH0
 p23GUWuorbFimRX87yU87h/iAKCtmm4ZsmW4sCmZH2EqkLv3CSDEDIIBI7IekYXQQuy+++OTj
 atUnefx6ownpemtoNZZBdqsR9WAg9FflZ9p6OmP882FK2NtnklPPU88EqXbc3rAikLKeUeuUU
 xJgjUZICB0AzDOpvZDw7Vcv4rQw9j+YYHRKRS1b3wQaaYLGLVnk3QOfYpX5wgf8yV8Saqo632
 BPY09nTXsAM8vEmnHGoQ+OgSmiMssetySiOwPG3lGIoFlFjMPTJ7+eBUlSyJOB37vraL2sMST
 MvIMT6OSu48lyCW3UFSefZ9W4t4Q/mwq7r42rJvlU3BsPsTfXNPmVpCK/L/LqsjzFFYVUEI7g
 IPz2/9HGlpdMuoxwNlUR1aY8SjZfMkZ6jPMOThGFR5Z04nnNJ2DVa8EmY5vei0HJbffhcriaW
 UQS9zOXKTYM3PiddQxzIyFCB+87A23HKQ639xwht90Czz/wD1AeZ11NWy2Iqq4oV1EteDvBQ3
 aYDTk/7N3gHbAXflQuNZ1lC3bgVkWRsX48Dt6UFpKftQD3Y52Ji1/f8tnuLDVkzJf5eL40p6B
 KZIOH7AcrxxCs2IDI+5bzVgr4b3Hb6OKx24+mULUdY3qHie3Pz4D5EhZMK3ojJ84aximjdJYl
 9sNAGwiw0eI7Moa/qjrKEVZpXsk1Qq/eCw7jijZr0Ov0MRSR70lZ4gOEtGstIZ3P/wf5ZwvJ3
 BHC8wvsPXJrQbnp/A8BfSByvFeYuRSkGRS455PvJR14xDPS1DJ+8GFau4iRePT0y3VUs8GVhM
 4CM7YbskC2Jt7Qp5V3sZi3NzCnoHWpuMa+J/bIByYSa22y7XgxYu6OJWo2rzD/Jff5wzBpsvR
 hjDDSPneM5dIM8h5PPH16ldAkfqkE2ufpHbCr7u19ekzrj6PeB/tBWya9djRlTE7ns96VeEOH
 x1QXP9oNjvewLw=
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Toke,

On Mon,  4 Apr 2022 22:48:00 +0200, Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
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

And finally found time to test your latest version of the patch, you can ad=
d my

Reviewed-by: Peter Seiderer <ps.report@gmx.net>
Tested-by: Peter Seiderer <ps.report@gmx.net>

Thanks,

Peter Seiderer


> ---
>  drivers/net/wireless/ath/ath9k/main.c |  2 +-
>  drivers/net/wireless/ath/ath9k/xmit.c | 30 ++++++++++++++++++---------
>  2 files changed, 21 insertions(+), 11 deletions(-)
>=20
> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless=
/ath/ath9k/main.c
> index 98090e40e1cf..e2791d45f5f5 100644
> --- a/drivers/net/wireless/ath/ath9k/main.c
> +++ b/drivers/net/wireless/ath/ath9k/main.c
> @@ -839,7 +839,7 @@ static bool ath9k_txq_list_has_key(struct list_head *=
txq_list, u32 keyix)
>  			continue;
> =20
>  		txinfo =3D IEEE80211_SKB_CB(bf->bf_mpdu);
> -		fi =3D (struct ath_frame_info *)&txinfo->rate_driver_data[0];
> +		fi =3D (struct ath_frame_info *)&txinfo->status.status_driver_data[0];
>  		if (fi->keyix =3D=3D keyix)
>  			return true;
>  	}
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

