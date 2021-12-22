Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2612D47CA73
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 01:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234715AbhLVAh2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 19:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231443AbhLVAh2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 19:37:28 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7595C061574;
        Tue, 21 Dec 2021 16:37:27 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id a37so968113ljq.13;
        Tue, 21 Dec 2021 16:37:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=vGrAySuUzxD0BQvD64Hlfi61XCJ/LYMEkHQTzWhrAZU=;
        b=NUZXWqrqssrla9HN/ToHcjAiHXMnfDRlyLy9HTDCh3YI2O3pPA9EgAeJaJjLUyWIto
         VRc0LD76gJsWL9FsI5fmsgzklx1MiHPFwceKx8rDE1CHNNP7LnchJDQzmKClOGrDz1H7
         6JgGWuCZPzaqKgEyGD0BcntQLEwt8nk1h9ZlWGA3t+xzdGZxz1+PhVwCGyMu6eaplyQR
         RImKs32OcuBmP+Losv5c84eBKA//OWBmZnqnEQCwPj4GqIfE5TOR/Lv0kbt+DDZsihCa
         VxArjRRwYCf2fgiPfxZgFFscRWvEpDtT4nFsxbBS8LPCrF2YR/fHMi+Gs/UzbMAoyjYt
         Z//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vGrAySuUzxD0BQvD64Hlfi61XCJ/LYMEkHQTzWhrAZU=;
        b=3yq749ODz9cYIb0fXRatKNj/vGWYfEV4JadrgEgwuVev2UfytqhEbdJJ/N7FkRDhXl
         T1rc6+WpuSX7x/ccW+PEuUWvJYqk2HYbPJWzkM8tUFPW1nkSSLoJb0Xj4Ski/enTkeEE
         O9MPNbEsVvCVsgsDVEPysM+YU4UYezhDbFNOJniPqAkNz3/D0rHRh6kX6vPno8CehsI0
         vrNW2Ox7dK3XBDp8Ju8hEsPIc5IHClIv8VnZbFr5xfvyOTRAoQyZmfF3Bf1Dw4idyGvc
         eOZIGrSyC4KkVFD1exhnxKMFKwsi6jf/W5pQcRvpGEc5hzgtQQ/qlG0n8H+7YSSwEK1b
         6sUA==
X-Gm-Message-State: AOAM530hGqwyHUp+p3e2ML2ORsMUf7KciGtWHLcwdYpUzkNAwPfjZAXa
        x6wAWR5S9h92J4NZlJ01k8FHu5ORpow=
X-Google-Smtp-Source: ABdhPJyx1D6nw5zSpPwc62QFD9x1SfUbxNPfqyY3OLro3ga6wi0+2FPfiv6oOabTRwf7Nd262Z7ACQ==
X-Received: by 2002:a2e:908b:: with SMTP id l11mr551531ljg.299.1640133445988;
        Tue, 21 Dec 2021 16:37:25 -0800 (PST)
Received: from [192.168.16.196] (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.googlemail.com with ESMTPSA id j16sm47711lfg.174.2021.12.21.16.37.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Dec 2021 16:37:25 -0800 (PST)
Subject: Re: [PATCH] can: kvaser_usb: get CAN clock frequency from device
To:     Jimmy Assarsson <extja@kvaser.com>, linux-can@vger.kernel.org,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
References: <20211222002826.1398761-1-extja@kvaser.com>
From:   Jimmy Assarsson <jimmyassarsson@gmail.com>
Message-ID: <eaefb340-6677-1fcc-83c2-dacc17360b92@gmail.com>
Date:   Wed, 22 Dec 2021 01:37:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20211222002826.1398761-1-extja@kvaser.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

I'm not familiar with the tag conventions used in the stable tree.
This is a backport of upstream commit fb12797ab1fef480ad8a32a30984844444eeb00d,
for stable 4.4, 4.9 and 4.14.
How to properly specify this?

Best regards,
jimmy

On 2021-12-22 01:28, Jimmy Assarsson wrote:
> commit fb12797ab1fef480ad8a32a30984844444eeb00d upstream.
> 
> The CAN clock frequency is used when calculating the CAN bittiming
> parameters. When wrong clock frequency is used, the device may end up
> with wrong bittiming parameters, depending on user requested bittiming
> parameters.
> 
> To avoid this, get the CAN clock frequency from the device. Various
> existing Kvaser Leaf products use different CAN clocks.
> 
> Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
> Link: https://lore.kernel.org/all/20211208152122.250852-2-extja@kvaser.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
> [backport note: kvaser_usb was split into multiple files in 4.19]
> ---
>   drivers/net/can/usb/kvaser_usb.c | 41 ++++++++++++++++++++++++++++----
>   1 file changed, 36 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
> index 9991ee93735a..81abb30d9ec0 100644
> --- a/drivers/net/can/usb/kvaser_usb.c
> +++ b/drivers/net/can/usb/kvaser_usb.c
> @@ -31,7 +31,10 @@
>   #define USB_SEND_TIMEOUT		1000 /* msecs */
>   #define USB_RECV_TIMEOUT		1000 /* msecs */
>   #define RX_BUFFER_SIZE			3072
> -#define CAN_USB_CLOCK			8000000
> +#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
> +#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
> +#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
> +#define KVASER_USB_CAN_CLOCK_32MHZ	32000000
>   #define MAX_NET_DEVICES			3
>   #define MAX_USBCAN_NET_DEVICES		2
>   
> @@ -139,6 +142,12 @@ static inline bool kvaser_is_usbcan(const struct usb_device_id *id)
>   #define CMD_LEAF_USB_THROTTLE		77
>   #define CMD_LEAF_LOG_MESSAGE		106
>   
> +/* Leaf frequency options */
> +#define KVASER_USB_LEAF_SWOPTION_FREQ_MASK 0x60
> +#define KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK 0
> +#define KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK BIT(5)
> +#define KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK BIT(6)
> +
>   /* error factors */
>   #define M16C_EF_ACKE			BIT(0)
>   #define M16C_EF_CRCE			BIT(1)
> @@ -469,6 +478,8 @@ struct kvaser_usb {
>   	bool rxinitdone;
>   	void *rxbuf[MAX_RX_URBS];
>   	dma_addr_t rxbuf_dma[MAX_RX_URBS];
> +
> +	struct can_clock clock;
>   };
>   
>   struct kvaser_usb_net_priv {
> @@ -646,6 +657,27 @@ static int kvaser_usb_send_simple_msg(const struct kvaser_usb *dev,
>   	return rc;
>   }
>   
> +static void kvaser_usb_get_software_info_leaf(struct kvaser_usb *dev,
> +					      const struct leaf_msg_softinfo *softinfo)
> +{
> +	u32 sw_options = le32_to_cpu(softinfo->sw_options);
> +
> +	dev->fw_version = le32_to_cpu(softinfo->fw_version);
> +	dev->max_tx_urbs = le16_to_cpu(softinfo->max_outstanding_tx);
> +
> +	switch (sw_options & KVASER_USB_LEAF_SWOPTION_FREQ_MASK) {
> +	case KVASER_USB_LEAF_SWOPTION_FREQ_16_MHZ_CLK:
> +		dev->clock.freq = KVASER_USB_CAN_CLOCK_16MHZ;
> +		break;
> +	case KVASER_USB_LEAF_SWOPTION_FREQ_24_MHZ_CLK:
> +		dev->clock.freq = KVASER_USB_CAN_CLOCK_24MHZ;
> +		break;
> +	case KVASER_USB_LEAF_SWOPTION_FREQ_32_MHZ_CLK:
> +		dev->clock.freq = KVASER_USB_CAN_CLOCK_32MHZ;
> +		break;
> +	}
> +}
> +
>   static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
>   {
>   	struct kvaser_msg msg;
> @@ -661,14 +693,13 @@ static int kvaser_usb_get_software_info(struct kvaser_usb *dev)
>   
>   	switch (dev->family) {
>   	case KVASER_LEAF:
> -		dev->fw_version = le32_to_cpu(msg.u.leaf.softinfo.fw_version);
> -		dev->max_tx_urbs =
> -			le16_to_cpu(msg.u.leaf.softinfo.max_outstanding_tx);
> +		kvaser_usb_get_software_info_leaf(dev, &msg.u.leaf.softinfo);
>   		break;
>   	case KVASER_USBCAN:
>   		dev->fw_version = le32_to_cpu(msg.u.usbcan.softinfo.fw_version);
>   		dev->max_tx_urbs =
>   			le16_to_cpu(msg.u.usbcan.softinfo.max_outstanding_tx);
> +		dev->clock.freq = KVASER_USB_CAN_CLOCK_8MHZ;
>   		break;
>   	}
>   
> @@ -1925,7 +1956,7 @@ static int kvaser_usb_init_one(struct usb_interface *intf,
>   	kvaser_usb_reset_tx_urb_contexts(priv);
>   
>   	priv->can.state = CAN_STATE_STOPPED;
> -	priv->can.clock.freq = CAN_USB_CLOCK;
> +	priv->can.clock.freq = dev->clock.freq;
>   	priv->can.bittiming_const = &kvaser_usb_bittiming_const;
>   	priv->can.do_set_bittiming = kvaser_usb_set_bittiming;
>   	priv->can.do_set_mode = kvaser_usb_set_mode;
> 
