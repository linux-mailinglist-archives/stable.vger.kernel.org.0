Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 825DF6D22B3
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 16:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbjCaOcU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 10:32:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232091AbjCaOcT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 10:32:19 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F8320638;
        Fri, 31 Mar 2023 07:31:56 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id hf2so21820092qtb.3;
        Fri, 31 Mar 2023 07:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680273087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=440qBp43gi8X2uwc+bRf63vxVx1+aUWgu7h2VYig2Z8=;
        b=GqHv/lNVIwa5C1VT6q2RliejvYDeNtklQwkjdaSGOV5/QnvxcGQrkhqUgxv449CTos
         4msIqKhsM0gq+9eCvtaYTEYBDeg0sOKSEajLjTizdxMYjNrq/6ewYy5Xfb/kv1qm5BQP
         /AxHZ2Wt4cDIKmq5LQgj2jcj4FAHzvDFajR8sSWnKq9Ziu5gAnmJERUR+0X9/94I75Ux
         8+A2KbuR3Hy81aDLZu0zZnQQ4RJZKA74PooVTOa5ZNSgn0h29b2KlR6Ek5XFkz8/w6Xe
         K+wKXvfDCI3flnDJiXBf3HkcNUi3RXCTBArQt5hVJBfkWC6O0xruiAKZPv48JGUSnIdP
         ia5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680273087;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=440qBp43gi8X2uwc+bRf63vxVx1+aUWgu7h2VYig2Z8=;
        b=5hAcVHoAeaA+K6uFJ4eYtNspcYVOkMGsVS4EpsOainIwDz6ctVLEpMamIaPFwS2bF6
         ZzkzUXN1dIhJp2BKjz3YLeEkpSIgM+3/Rzqu/Dvo+hi6lZbXlHaf8e5X3Ahh2YQpiw5X
         6XChtwZ63ottFZV9KfRmx4dhGSWP2aLClg0m8ioT0UXI5eUzKcEGa0E5S+4O6E7vWNVu
         XchEfz6VL7kuWbOC3lFNXMDIfJ/81ll10vJuxOKpgzEA1q/waV7ysAMW78t/9yc9awxw
         pegUv+XfaL07M7azQRyGK7BGkGOctXoNcwYZ8hsze9BxDiz1V5g1K3v6owFpK/sM8df7
         Xvpg==
X-Gm-Message-State: AO0yUKWIv3b1fGtFUNYE0Hi+VJHRI8QXdPPdfcmfOowf0n0CFiVKIscK
        MYHT+IovrokSgwd20whmLFd6i5fon2C6jA==
X-Google-Smtp-Source: AK7set/b7maW+CiGN6k0kI1H9ZMiYwH2brN/s/b5VdeRkieXFTFlv3lO4oUTrGIHDy4Y8hukm+oNzA==
X-Received: by 2002:a05:622a:454:b0:3b8:6a92:c8d6 with SMTP id o20-20020a05622a045400b003b86a92c8d6mr42719099qtx.60.1680273086849;
        Fri, 31 Mar 2023 07:31:26 -0700 (PDT)
Received: from ?IPV6:2001:470:8:94a::245? ([2001:470:8:94a::245])
        by smtp.googlemail.com with ESMTPSA id p4-20020ac87404000000b003e390b48958sm646887qtq.55.2023.03.31.07.31.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Mar 2023 07:31:26 -0700 (PDT)
Message-ID: <cb5980b4-1e0e-57f8-e680-44e14fa0b02c@gmail.com>
Date:   Fri, 31 Mar 2023 10:31:25 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 1/2] wifi: rtw88: usb: fix priority queue to endpoint
 mapping
Content-Language: en-US
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        "Alex G ." <mr.nuke.me@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>,
        ValdikSS <iam@valdikss.org.ru>, kernel@pengutronix.de,
        stable@vger.kernel.org
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
 <20230331121054.112758-2-s.hauer@pengutronix.de>
From:   Jonathan Bither <jonbither@gmail.com>
In-Reply-To: <20230331121054.112758-2-s.hauer@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/31/23 08:10, Sascha Hauer wrote:
> The RTW88 chipsets have four different priority queues in hardware. For
> the USB type chipsets the packets destined for a specific priority queue
> must be sent through the endpoint corresponding to the queue. This was
> not fully understood when porting from the RTW88 USB out of tree driver
> and thus violated.
>
> This patch implements the qsel to endpoint mapping as in
> get_usb_bulkout_id_88xx() in the downstream driver.
>
> Without this the driver often issues "timed out to flush queue 3"
> warnings and often TX stalls completely.
>
> Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
> ---
>   drivers/net/wireless/realtek/rtw88/usb.c | 70 ++++++++++++++++--------
>   1 file changed, 47 insertions(+), 23 deletions(-)
>
> diff --git a/drivers/net/wireless/realtek/rtw88/usb.c b/drivers/net/wireless/realtek/rtw88/usb.c
> index 2a8336b1847a5..a10d6fef4ffaf 100644
> --- a/drivers/net/wireless/realtek/rtw88/usb.c
> +++ b/drivers/net/wireless/realtek/rtw88/usb.c
> @@ -118,6 +118,22 @@ static void rtw_usb_write32(struct rtw_dev *rtwdev, u32 addr, u32 val)
>   	rtw_usb_write(rtwdev, addr, val, 4);
>   }
>   
> +static int dma_mapping_to_ep(enum rtw_dma_mapping dma_mapping)
> +{
> +	switch (dma_mapping) {
> +	case RTW_DMA_MAPPING_HIGH:
> +		return 0;
> +	case RTW_DMA_MAPPING_NORMAL:
> +		return 1;
> +	case RTW_DMA_MAPPING_LOW:
> +		return 2;
> +	case RTW_DMA_MAPPING_EXTRA:
> +		return 3;
> +	default:
> +		return -EINVAL;
> +	}
> +}
Would it be beneficial to use defines for the returns? Would the 
USB_ENDPOINT_XFER_ defines be applicable?
> +
>   static int rtw_usb_parse(struct rtw_dev *rtwdev,
>   			 struct usb_interface *interface)
>   {
> @@ -129,6 +145,8 @@ static int rtw_usb_parse(struct rtw_dev *rtwdev,
>   	int num_out_pipes = 0;
>   	int i;
>   	u8 num;
> +	const struct rtw_chip_info *chip = rtwdev->chip;
> +	const struct rtw_rqpn *rqpn;
>   
>   	for (i = 0; i < interface_desc->bNumEndpoints; i++) {
>   		endpoint = &host_interface->endpoint[i].desc;
> @@ -183,31 +201,34 @@ static int rtw_usb_parse(struct rtw_dev *rtwdev,
>   
>   	rtwdev->hci.bulkout_num = num_out_pipes;
>   
> -	switch (num_out_pipes) {
> -	case 4:
> -	case 3:
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 2;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 2;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 2;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 2;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID4] = 1;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID5] = 1;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID6] = 0;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID7] = 0;
> -		break;
> -	case 2:
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = 1;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = 1;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = 1;
> -		rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = 1;
> -		break;
> -	case 1:
> -		break;
> -	default:
> -		rtw_err(rtwdev, "failed to get out_pipes(%d)\n", num_out_pipes);
> +	if (num_out_pipes < 1 || num_out_pipes > 4) {
> +		rtw_err(rtwdev, "invalid number of endpoints %d\n", num_out_pipes);
>   		return -EINVAL;
>   	}
>   
> +	rqpn = &chip->rqpn_table[num_out_pipes];
> +
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID0] = dma_mapping_to_ep(rqpn->dma_map_be);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID1] = dma_mapping_to_ep(rqpn->dma_map_bk);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID2] = dma_mapping_to_ep(rqpn->dma_map_bk);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID3] = dma_mapping_to_ep(rqpn->dma_map_be);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID4] = dma_mapping_to_ep(rqpn->dma_map_vi);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID5] = dma_mapping_to_ep(rqpn->dma_map_vi);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID6] = dma_mapping_to_ep(rqpn->dma_map_vo);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID7] = dma_mapping_to_ep(rqpn->dma_map_vo);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID8] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID9] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID10] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID11] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID12] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID13] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID14] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_TID15] = -EINVAL;
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_BEACON] = dma_mapping_to_ep(rqpn->dma_map_hi);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_HIGH] = dma_mapping_to_ep(rqpn->dma_map_hi);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_MGMT] = dma_mapping_to_ep(rqpn->dma_map_mg);
> +	rtwusb->qsel_to_ep[TX_DESC_QSEL_H2C] = dma_mapping_to_ep(rqpn->dma_map_hi);
> +
>   	return 0;
>   }
>   
> @@ -250,7 +271,7 @@ static void rtw_usb_write_port_tx_complete(struct urb *urb)
>   static int qsel_to_ep(struct rtw_usb *rtwusb, unsigned int qsel)
>   {
>   	if (qsel >= ARRAY_SIZE(rtwusb->qsel_to_ep))
> -		return 0;
> +		return -EINVAL;
>   
>   	return rtwusb->qsel_to_ep[qsel];
>   }
> @@ -265,6 +286,9 @@ static int rtw_usb_write_port(struct rtw_dev *rtwdev, u8 qsel, struct sk_buff *s
>   	int ret;
>   	int ep = qsel_to_ep(rtwusb, qsel);
>   
> +	if (ep < 0)
> +		return ep;
> +
>   	pipe = usb_sndbulkpipe(usbd, rtwusb->out_ep[ep]);
>   	urb = usb_alloc_urb(0, GFP_ATOMIC);
>   	if (!urb)
