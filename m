Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 010492C8E82
	for <lists+stable@lfdr.de>; Mon, 30 Nov 2020 20:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388298AbgK3T4J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Nov 2020 14:56:09 -0500
Received: from mout.web.de ([212.227.15.3]:56581 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388205AbgK3T4J (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 30 Nov 2020 14:56:09 -0500
X-Greylist: delayed 470 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Nov 2020 14:56:08 EST
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1606766057;
        bh=yF9sdWgdpN9rBm+i1Z5YIQ4TmpTjsO4HYklAVP13A78=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=aW/LV8a5TLllruwfNq+pZEpTf1RQ7Bu86F4SU13qD3DSOcOvZIqPjurvmcY/y+OXN
         sUmROLlVJW/kZMosQppcF0+v1JnaVN8Gzh5y3xLQ39tNsqu/PC6UbAzKF/okNVO7r8
         42HPQFLJu8u1Pk0rnQHomhAiMEMd7y2MBd7eEqDc=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [10.0.0.110] ([185.159.157.20]) by smtp.web.de (mrweb004
 [213.165.67.108]) with ESMTPSA (Nemesis) id 0MH2Fm-1kxcui3Zys-00DrsI; Mon, 30
 Nov 2020 20:46:22 +0100
Subject: Re: [PATCH v2] Input: atmel_mxt_ts - Fix lost interrupts
To:     Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc:     Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>, stable@vger.kernel.org
References: <20201129212415.1167540-1-linus.walleij@linaro.org>
From:   Andre Muller <andre.muller@web.de>
Message-ID: <889a691f-2157-730e-5866-8a1c4e81eb35@web.de>
Date:   Mon, 30 Nov 2020 20:47:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201129212415.1167540-1-linus.walleij@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:rEaCyzYBjgB/iGsIrIQKX/Zrd3zdWbubMVJMIjUTHhM04U71lAx
 nSFzRhRd2xIiCAh7awGu/arYCzCYhLmjBi4QkEH2URpIhEAMEdkIYA999L1LYs9g1IoGahZ
 37nTVZ6OhXTGF2ZdrU9eqLYrhoyBjQg2E1DBAazV8vMH7uObDAm/UtX0MnHkjK1flTvjmBp
 gT07Odw/rSMNoA+IA+OiA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:2eU/qNgSSdY=:l5BDJXNFYpcTYYwfE6+RDs
 ACeFQxjex64SkVAfc9Lv1pCTtoap5sM8FcF5T5mPLa71kSvyfix7kl1OBi1CQ/nOpzLnXVYZQ
 CfwGNkLpGVl4fXqm/2uQsPjggC5nvhqvzJzTIBqiwM9IXk7o7hFlBzMjTNPqpjIjDYO7KB17n
 2hh0GXsfLqT2Jje+LbLTYmXuBWr+5mrxRdrhfSqMF8m0j2/bF38/bgtsIvo+JuKgLQX0mDxZ1
 6j+XVSBTG8Ym6OJoHy/0zxc2Mg47Q13JrgD7xhVtnBOXFCgPXXQ1JKrJU/cnh7mCKkWG3mlEP
 dIvQ6GqUejCtBBoEGSzLMniUtmRpNw5zeFf6YdQVZH38ErSBG14WNUIA9DXorgQ7LpNEtHdgi
 Dz7nGxSSvaobl0LAN5SbsxPQq5rHW5vQxH+hDzaN8ALB2c+YZRvqFukJesm0NitsKLVE87/Ev
 kU3B8iAmUQluKa96AYznkynDp6OOmiaJ9JbrSEmyGO6FTIivLcQscLgwzLCM8ZUSxSIx//Wgs
 USgQmLb6ypOO7bvW5zq7DW38n9oAcOGyJW36w9CDdKSI801jI64czHUsqJo7+iO9pWeGrU9Qb
 O4PCYVXTFrU1zfaJuV4+0Qr+jVr/4Dm8jcScTN0BuLH275+0/UQIeeKxc7dqfkki+VQ2OjWlH
 Fhz0MEYWDN7gtvhwOXZW1MdNUpntaB01BaB5TnoVI3HSCtKXCs8uRn8mgyKl9vNkp89wO1lPc
 I91e/65jIfYvBaSja/bPkhy7qZdF3i1UpsvLzNY3NRwbvPQv1++kj3remcT2dPS71ddGBIsd7
 vlBK/O5jRAnQgMDDB6U4UE9OntP1ZCNnowKFya9PKciVL4187aB8mcGUvYGY6yuIYowSlRW3S
 108QLlM2f1Mo1A3aTLDA==
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The patch works for me:

[    0.205866] atmel_mxt_ts i2c-ATML0000:01: Family: 164 Variant: 17 Firmw=
are V1.0.AA Objects: 32
[    0.221638] atmel_mxt_ts i2c-ATML0000:01: Leaving RETRIGEN workaround e=
nabled
[    0.221692] atmel_mxt_ts i2c-ATML0000:01: Direct firmware load for maxt=
ouch.cfg failed with error -2
[    0.223165] atmel_mxt_ts i2c-ATML0000:01: Touchscreen size X960Y540
[    0.223206] input: Atmel maXTouch Touchpad as /devices/pci0000:00/INT34=
32:00/i2c-0/i2c-ATML0000:01/input/input4
[    0.229177] atmel_mxt_ts i2c-ATML0001:01: Family: 164 Variant: 13 Firmw=
are V1.0.AA Objects: 41
[    0.248909] atmel_mxt_ts i2c-ATML0001:01: Leaving RETRIGEN workaround e=
nabled
[    0.248992] atmel_mxt_ts i2c-ATML0001:01: Direct firmware load for maxt=
ouch.cfg failed with error -2
[    0.250396] atmel_mxt_ts i2c-ATML0001:01: Touchscreen size X2559Y1699

Tested-by: Andre M=C3=BCller <andre.muller@web.de>

Thank you!

On 29/11/2020 22.24, Linus Walleij wrote:
> After commit 74d905d2d38a devices requiring the workaround
> for edge triggered interrupts stopped working.
>
> This is because the "data" state container defaults to
> *not* using the workaround, but the workaround gets used
> *before* the check of whether it is needed or not. This
> semantic is not obvious from just looking on the patch,
> but related to the program flow.
>
> The hardware needs the quirk to be used before even
> proceeding to check if the quirk is needed.
>
> This patch makes the quirk be used until we determine
> it is *not* needed. It is determined as not needed when
> we either have a level-triggered interrupt or the
> firmware claims that it has enabled retrigging.
>
> Cc: Andre M=C3=BCller <andre.muller@web.de>
> Cc: Nick Dyer <nick.dyer@itdev.co.uk>
> Cc: Jiada Wang <jiada_wang@mentor.com>
> Cc: stable@vger.kernel.org
> Reported-by: Andre M=C3=BCller <andre.muller@web.de>
> Fixes: 74d905d2d38a ("Input: atmel_mxt_ts - only read messages in mxt_ac=
quire_irq() when necessary")
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> ChangeLog v1->v2:
> - Explicitly disable the retrig workaround also if the
>    IRQ descriptor says we have a level triggered interrupt.
> - Drop the second explicit assigning of "true" to the
>    use_retrigen_workaround bool, it is already enabled.
> - Augment debug text to say that we leave it enabled
>    rather than enable it.
> ---
>   drivers/input/touchscreen/atmel_mxt_ts.c | 18 ++++++++++++------
>   1 file changed, 12 insertions(+), 6 deletions(-)
>
> diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/to=
uchscreen/atmel_mxt_ts.c
> index e34984388791..c822db8dbd02 100644
> --- a/drivers/input/touchscreen/atmel_mxt_ts.c
> +++ b/drivers/input/touchscreen/atmel_mxt_ts.c
> @@ -1297,14 +1297,18 @@ static int mxt_check_retrigen(struct mxt_data *d=
ata)
>   	int val;
>   	struct irq_data *irqd;
>
> -	data->use_retrigen_workaround =3D false;
> -
>   	irqd =3D irq_get_irq_data(data->irq);
>   	if (!irqd)
>   		return -EINVAL;
>
> -	if (irqd_is_level_type(irqd))
> +	if (irqd_is_level_type(irqd)) {
> +		/*
> +		 * We don't need the workaround if we have level trigged
> +		 * interrupts. This will just work fine.
> +		 */
> +		data->use_retrigen_workaround =3D false;
>   		return 0;
> +	}
>
>   	if (data->T18_address) {
>   		error =3D __mxt_read_reg(client,
> @@ -1313,12 +1317,13 @@ static int mxt_check_retrigen(struct mxt_data *d=
ata)
>   		if (error)
>   			return error;
>
> -		if (val & MXT_COMMS_RETRIGEN)
> +		if (val & MXT_COMMS_RETRIGEN) {
> +			data->use_retrigen_workaround =3D false;
>   			return 0;
> +		}
>   	}
>
> -	dev_warn(&client->dev, "Enabling RETRIGEN workaround\n");
> -	data->use_retrigen_workaround =3D true;
> +	dev_warn(&client->dev, "Leaving RETRIGEN workaround enabled\n");
>   	return 0;
>   }
>
> @@ -3117,6 +3122,7 @@ static int mxt_probe(struct i2c_client *client, co=
nst struct i2c_device_id *id)
>   	data =3D devm_kzalloc(&client->dev, sizeof(struct mxt_data), GFP_KERN=
EL);
>   	if (!data)
>   		return -ENOMEM;
> +	data->use_retrigen_workaround =3D true;
>
>   	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
>   		 client->adapter->nr, client->addr);
>

