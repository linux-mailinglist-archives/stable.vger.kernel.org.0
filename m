Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CDCCCC8B1
	for <lists+stable@lfdr.de>; Sat,  5 Oct 2019 10:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727108AbfJEICN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Oct 2019 04:02:13 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33054 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725927AbfJEICN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Oct 2019 04:02:13 -0400
Received: by mail-wr1-f66.google.com with SMTP id b9so9680762wrs.0;
        Sat, 05 Oct 2019 01:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9Y7BCdKfF42C/Nu4DmZI0go32skY7iFtS+PHT8KquHk=;
        b=lnZ5s8qbvATDvfkDAGH9QXGUHLzVfRIhHxTTf3zYlkGtxecNmJvhy4Pi6hTKQjnVha
         6hSugYX8AsLa2dGymYKg1F+8Itzby0IrP0HqxBlw4LFWPUaQlWfCV4uDZTfgdqyUxq5P
         FGRkFIsnmz0LGkUeOaciiaduVJdvlLSMeE7rHDl8hEQLw4HQY6kM+miPXbCtjLoSfpZS
         szFPKqXJU1gcJbjbBL22WR8TGY1B2Wtk0I4aoarLoHXjWjbz1fnHjFU3bKTeRNz29dUm
         fTcRuKjznBhNyUGmj8P2wEkM4rICjNxRDfKbmaCZRWX34gI3Gcykt59XjYmazA7LZ9vy
         LZPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Y7BCdKfF42C/Nu4DmZI0go32skY7iFtS+PHT8KquHk=;
        b=kVExF2BX6Ts3OA5wnVPTKveJOfnaQ5m40Bk5Pzl1xXUxoVjvEW64caV5iApOG+p3xs
         gOIAxeynQ9ik1EC2lW9TpSAei5+rgGdaY4WY0Z1WykrpHbRrfaLb34JHXnaHCCSqkZ3J
         bVp+/zUEDdFxz09Tt/CX5C6yLPcJXLwF2ggur3zya/6YZPFgoeaq6PmHJra+ToJR89Ce
         kKnv69TSjQNW0bhpUC+OIEpoyPNnjzjiRYLIlkFngq59zS9Tnq6l314TAdHBas5vWo35
         9U8yKqpwqszJ37vrBRAhokhp4O/BGPBfliiPCB8NDFlyxiwvTwgyyYvX3eDDJNFJPj8b
         qmng==
X-Gm-Message-State: APjAAAU6Tsa+IGzKKMpIS2bu7Y74AqJYp0u0vHrAEpKMuVDQ6nBbV8PM
        XTwRnvxvpt661mlX2tsHJCw=
X-Google-Smtp-Source: APXvYqyLe93o8VDkGupD7Nb7RzULRgbdVO/KAfRYPzld3ZlPF/Nf/o9ggcYWHCRWU6ftX04owCdZYA==
X-Received: by 2002:adf:f691:: with SMTP id v17mr9222636wrp.81.1570262529967;
        Sat, 05 Oct 2019 01:02:09 -0700 (PDT)
Received: from lt530 (p200300C1CF1FCE00BF22FF9D719792AD.dip0.t-ipconnect.de. [2003:c1:cf1f:ce00:bf22:ff9d:7197:92ad])
        by smtp.gmail.com with ESMTPSA id e3sm7878146wme.39.2019.10.05.01.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Oct 2019 01:02:09 -0700 (PDT)
Date:   Sat, 5 Oct 2019 10:02:05 +0200
From:   Daniel Scheller <d.scheller.oss@gmail.com>
To:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc:     Linux Media Mailing List <linux-media@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Sergey Kozlov <serjk@netup.ru>, Abylay Ospan <aospan@netup.ru>,
        stable@vger.kernel.org
Subject: Re: [PATCH v3] media: cxd2841er: avoid too many status inquires
Message-ID: <20191005100205.01459123@lt530>
In-Reply-To: <483cecc9f65b03ad3cd54aea09ecd9819c3dc6db.1570197700.git.mchehab+samsung@kernel.org>
References: <deda32250ad32078b98eb41eb09d6d20050a6f9c.1570113429.git.mchehab+samsung@kernel.org>
        <483cecc9f65b03ad3cd54aea09ecd9819c3dc6db.1570197700.git.mchehab+samsung@kernel.org>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am Fri,  4 Oct 2019 11:02:28 -0300
schrieb Mauro Carvalho Chehab <mchehab+samsung@kernel.org>:

> As reported at:
> 	https://tvheadend.org/issues/5625
> 
> Retrieving certain status can cause discontinuity issues.
> 
> Prevent that by adding a timeout to each status logic.
> 
> Currently, the timeout is estimated based at the channel
> bandwidth. There are other parameters that may also affect
> the timeout, but that would require a per-delivery system
> calculus and probably more information about how cxd2481er
> works, with we don't have.
> 
> So, do a poor man's best guess.

Such hardware quirk hack should clearly be enabled by a (new) config
flag (see the bits at the top of cxd2841er.h) which consumer drivers
can set if there are known issues with them. The reported issue is
nothing every piece of hardware with a cxd28xx demod soldered on has -
I believe the JokerTV devices which Abylay originally made this driver
for suffers from this and at least the Digital Devices C/C2/T/T2/I
boards (cxd2837/43/54) definitely don't have any issues (and I use them
regularily in my TVheadend server which is frequently used).

So please hide this behind a flag named ie. "CXD2841ER_STAT_TIMEOUT"
and enable that in the USB drivers which the affected USB sticks use.
 
> Cc: stable@vger.kernel.org
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
> ---
>  drivers/media/dvb-frontends/cxd2841er.c | 68 +++++++++++++++++++++++++
>  1 file changed, 68 insertions(+)
> 
> diff --git a/drivers/media/dvb-frontends/cxd2841er.c b/drivers/media/dvb-frontends/cxd2841er.c
> index 1b30cf570803..218da631df19 100644
> --- a/drivers/media/dvb-frontends/cxd2841er.c
> +++ b/drivers/media/dvb-frontends/cxd2841er.c
> @@ -60,6 +60,13 @@ struct cxd2841er_priv {
>  	enum cxd2841er_xtal		xtal;
>  	enum fe_caps caps;
>  	u32				flags;
> +
> +	unsigned long			ber_interval;
> +	unsigned long			ucb_interval;
> +
> +	unsigned long			ber_time;
> +	unsigned long			ucb_time;
> +	unsigned long			snr_time;
>  };
>  
>  static const struct cxd2841er_cnr_data s_cn_data[] = {
> @@ -1941,6 +1948,10 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
>  	struct cxd2841er_priv *priv = fe->demodulator_priv;
>  	u32 ret, bit_error = 0, bit_count = 0;
>  
> +	if (priv->ber_time &&
> +	   (!time_after(jiffies, priv->ber_time)))
> +		return;
> +
>  	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
>  	switch (p->delivery_system) {
>  	case SYS_DVBC_ANNEX_A:
> @@ -1953,9 +1964,15 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
>  		break;
>  	case SYS_DVBS:
>  		ret = cxd2841er_mon_read_ber_s(priv, &bit_error, &bit_count);
> +
> +		if (!priv->ber_interval && p->symbol_rate)
> +			priv->ber_interval = (10000000) / (p->symbol_rate / 1000);
>  		break;
>  	case SYS_DVBS2:
>  		ret = cxd2841er_mon_read_ber_s2(priv, &bit_error, &bit_count);
> +
> +		if (!priv->ber_interval && p->symbol_rate)
> +			priv->ber_interval = (10000000) / (p->symbol_rate / 1000);
>  		break;
>  	case SYS_DVBT:
>  		ret = cxd2841er_read_ber_t(priv, &bit_error, &bit_count);
> @@ -1978,6 +1995,21 @@ static void cxd2841er_read_ber(struct dvb_frontend *fe)
>  		p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  		p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  	}
> +
> +	/*
> +	 * If the per-delivery system doesn't specify, set a default timeout
> +	 * that will wait for ~12.5 seconds for 8MHz channels
> +	 */
> +	if (!priv->ber_interval && p->bandwidth_hz)
> +		priv->ber_interval = (100000000) / (p->bandwidth_hz / 1000);
> +
> +	if (priv->ber_interval < 1000)
> +		priv->ber_interval = 1000;
> +
> +// HACK:
> +dev_info(&priv->i2c->dev, "BER interval: %d ms", priv->ber_interval);
> +
> +	priv->ber_time = jiffies + msecs_to_jiffies(priv->ber_interval);
>  }
>  
>  static void cxd2841er_read_signal_strength(struct dvb_frontend *fe)
> @@ -2037,6 +2069,16 @@ static void cxd2841er_read_snr(struct dvb_frontend *fe)
>  	struct dtv_frontend_properties *p = &fe->dtv_property_cache;
>  	struct cxd2841er_priv *priv = fe->demodulator_priv;
>  
> +	if (priv->snr_time &&
> +	   (!time_after(jiffies, priv->snr_time)))
> +		return;
> +
> +	/* Preventing asking SNR more than once per second */
> +	priv->snr_time = jiffies + msecs_to_jiffies(1000);
> +
> +// HACK
> +dev_info(&priv->i2c->dev, "SNR interval: %d ms", 1000);
> +
>  	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
>  	switch (p->delivery_system) {
>  	case SYS_DVBC_ANNEX_A:
> @@ -2081,6 +2123,10 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
>  	struct cxd2841er_priv *priv = fe->demodulator_priv;
>  	u32 ucblocks = 0;
>  
> +	if (priv->ucb_time &&
> +	   (!time_after(jiffies, priv->ucb_time)))
> +		return;
> +
>  	dev_dbg(&priv->i2c->dev, "%s()\n", __func__);
>  	switch (p->delivery_system) {
>  	case SYS_DVBC_ANNEX_A:
> @@ -2105,6 +2151,21 @@ static void cxd2841er_read_ucblocks(struct dvb_frontend *fe)
>  
>  	p->block_error.stat[0].scale = FE_SCALE_COUNTER;
>  	p->block_error.stat[0].uvalue = ucblocks;
> +
> +	/*
> +	 * If the per-delivery system doesn't specify, set a default timeout
> +	 * that will wait 20-30 seconds
> +	 */
> +	if (!priv->ucb_interval && p->bandwidth_hz)
> +		priv->ucb_interval = (100 * 204 * 1000 * 8) / p->bandwidth_hz;
> +
> +	if (priv->ucb_interval < 1000)
> +		priv->ucb_interval = 1000;
> +
> +// HACK:
> +dev_info(&priv->i2c->dev, "UCB interval: %d ms", priv->ucb_interval);
> +
> +	priv->ucb_time = jiffies + msecs_to_jiffies(priv->ucb_interval);
>  }
>  
>  static int cxd2841er_dvbt2_set_profile(
> @@ -3360,6 +3421,13 @@ static int cxd2841er_set_frontend_s(struct dvb_frontend *fe)
>  	p->post_bit_error.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  	p->post_bit_count.stat[0].scale = FE_SCALE_NOT_AVAILABLE;
>  
> +	/* Reset the wait for jiffies logic */
> +	priv->ber_interval = 0;
> +	priv->ucb_interval = 0;
> +	priv->ber_time = 0;
> +	priv->ucb_time = 0;
> +	priv->snr_time = 0;
> +
>  	return ret;
>  }
>  




Best regards,
Daniel Scheller
-- 
https://github.com/herrnst
