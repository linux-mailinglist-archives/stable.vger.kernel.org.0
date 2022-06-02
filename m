Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F4BD53B5E6
	for <lists+stable@lfdr.de>; Thu,  2 Jun 2022 11:22:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbiFBJW0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jun 2022 05:22:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbiFBJWR (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jun 2022 05:22:17 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A48E6B3C
        for <stable@vger.kernel.org>; Thu,  2 Jun 2022 02:22:15 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id t25so6848846lfg.7
        for <stable@vger.kernel.org>; Thu, 02 Jun 2022 02:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=27GAf5ohkl6/h/QYZPkEEPoMd8JAKAbRbQzpH5Y2OQg=;
        b=L8w8u3gOwbBmBTZq6Ji/iB4oXcWX0h7FAXYWCAf1TT1dno2DafgVUHtmLSnsQJ74UZ
         9sIx6EQ1BXA3YvJoazHaFj4lN1Xl2Znyo/LJYz03MbRRHw00OceZxxHqa5VU0lE8ujDn
         3MZ03obG2Dvijv47W3Z7YEzYCA7tAhnX9zKdoNsfsU8x0zmXrQ1b0ZtyxA6Qinu7eEAI
         osJ8JWi2jLBXmAKblUQOKsjITaayDaEdPsLtssbV0JI+IRyl5OiQl489ldUag1vcB0ad
         +jSUIZGexC1fnEU7PQEbU0VecFSKjX8L1xrlJLZ9jGjV3ZNcZ3SGBVcEnlihbfOw9FIr
         sYeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=27GAf5ohkl6/h/QYZPkEEPoMd8JAKAbRbQzpH5Y2OQg=;
        b=w7K4+I/kValSlVxknC0ozsTULer5vkJrgv0WPsZl9WrMvuJvFof0fbP6/XhYQg9wlO
         ybA6kPEx1gHk5saKUt+VF64CAlkYOJ1j6tLZqfeeFG4JxLPw6wMU2jKHCJ5XA4NKk3zo
         OYn3nwgPjpXGc0mFPLq1AC6SxKGRfiw2PN2RMS7R78MTPmh+Ka81mcL2oTZDnSYFLCpW
         njI/C4rWdxLaegVWTGWOv91X2K59iJaggmrDYiuo373cmlfIQ8pSwSMpJ+IdqDCsx4A4
         //gHzGXW57uaGeoZ1gq0bdoPZs/+GwzVkPF4OtVC2ayu2udrrwmwaXWAlg0eDwALpfrA
         wDyA==
X-Gm-Message-State: AOAM5327UI1cyicfpGRwa8j897fN6cztSjP3zoFw6MHlViz0DSAm3CeX
        6S2Dr8L9OSQoBBSE16WeUDmgfA==
X-Google-Smtp-Source: ABdhPJwq8oOk2W7/YK7Iq4ei3Ek4KjgIp8D6sIys9vmLtaAoErsGbrcrAu+Bu6zQj7jryMx/4o3I5Q==
X-Received: by 2002:a05:6512:158d:b0:479:a44:9fef with SMTP id bp13-20020a056512158d00b004790a449fefmr2837105lfb.78.1654161733944;
        Thu, 02 Jun 2022 02:22:13 -0700 (PDT)
Received: from [192.168.16.143] (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id a6-20020ac25206000000b0047255d211d8sm922360lfl.263.2022.06.02.02.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jun 2022 02:22:13 -0700 (PDT)
Message-ID: <a4866c5a-5516-06cb-fa1a-83e5014f6d36@kvaser.com>
Date:   Thu, 2 Jun 2022 11:22:31 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 1/2] can: kvaser_usb: kvaser_usb_leaf: Fix CAN clock
 frequency regression
Content-Language: en-US
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     linux-can@vger.kernel.org,
        Jimmy Assarsson <jimmyassarsson@gmail.com>,
        stable@vger.kernel.org
References: <20220602063031.415858-1-extja@kvaser.com>
 <20220602063031.415858-2-extja@kvaser.com>
 <20220602080257.243x4brmkjgve5kr@pengutronix.de>
From:   Jimmy Assarsson <extja@kvaser.com>
In-Reply-To: <20220602080257.243x4brmkjgve5kr@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 6/2/22 10:02, Marc Kleine-Budde wrote:
> On 02.06.2022 08:30:30, Jimmy Assarsson wrote:
>> The firmware of M32C based Leaf devices expects bittiming parameters
>> calculated for 16MHz clock.
>> Since we use the actual clock frequency of the device, the device may end
>> up with wrong bittiming parameters, depending on user requested parameters.
>>
>> This regression affects M32C based Leaf devices with non-16MHz clock.
> 
> Oh. Thanks for the patch!
> 
>> Fixes: fb12797ab1fe ("can: kvaser_usb: get CAN clock frequency from device")
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
>> ---
>>   drivers/net/can/usb/kvaser_usb/kvaser_usb.h   |  4 +++
>>   .../net/can/usb/kvaser_usb/kvaser_usb_core.c  | 20 +++++++++++----
>>   .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 25 ++++++++++++-------
>>   3 files changed, 35 insertions(+), 14 deletions(-)
>>
>> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
>> index 3a49257f9fa6..cb588228d7a1 100644
>> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
>> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb.h
>> @@ -44,6 +44,9 @@
>>   #define KVASER_USB_CAP_EXT_CAP			0x02
>>   #define KVASER_USB_HYDRA_CAP_EXT_CMD		0x04
>>   
>> +/* Quriks */
>        ^^^^^^
> Typo

Oops!

>> +#define KVASER_USB_QUIRK_IGNORE_CLK_FREQ BIT(0)
>> +
>>   struct kvaser_usb_dev_cfg;
>>   
>>   enum kvaser_usb_leaf_family {
>> @@ -65,6 +68,7 @@ struct kvaser_usb_dev_card_data_hydra {
>>   struct kvaser_usb_dev_card_data {
>>   	u32 ctrlmode_supported;
>>   	u32 capabilities;
>> +	u32 quirks;
>>   	union {
>>   		struct {
>>   			enum kvaser_usb_leaf_family family;
>> diff --git a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
>> index e67658b53d02..5880e9719c9d 100644
>> --- a/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
>> +++ b/drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c
>> @@ -94,10 +94,14 @@
>>   
>>   static inline bool kvaser_is_leaf(const struct usb_device_id *id)
>>   {
>> -	return (id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
>> -		id->idProduct <= USB_CAN_R_PRODUCT_ID) ||
>> -		(id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
>> -		 id->idProduct <= USB_LEAF_PRODUCT_ID_END);
>> +	return id->idProduct >= USB_LEAF_DEVEL_PRODUCT_ID &&
>> +	       id->idProduct <= USB_CAN_R_PRODUCT_ID;
>> +}
>> +
>> +static inline bool kvaser_is_leafimx(const struct usb_device_id *id)
>> +{
>> +	return id->idProduct >= USB_LEAF_LITE_V2_PRODUCT_ID &&
>> +	       id->idProduct <= USB_LEAF_PRODUCT_ID_END;
>>   }
> 
> Is this getting a bit complicated now?
> In this driver we have:
> 
> 1) struct usb_device_id::driver_info
> 2) kvaser_is_*()
> 
> which is used to set
> 
> 3) dev->card_data.leaf.family
> 4) dev->ops
> 
> and now you're adding:
> 
> 5) dev->card_data.quirks
> 
> which then affects
> 
> 6) dev->cfg
> 
> The straight forward way would be to define a struct that describes the
> a device completely:
> 
> struct kvaser_driver_info {
>         u32 quirks;        /* KVASER_USB_HAS_ */
>         enum kvaser_usb_leaf_family;
>         const struct kvaser_usb_dev_*ops;
>         const struct kvaser_usb_dev_*cfg;
> };
> 
> and then assign that to every device listed in the kvaser_usb_table.

Thanks for the feedback!
I agree, but I prefer if we can keep assigning dev->cfg based on the 
information that we get from the device.
So we get:
struct kvaser_driver_info {
         u32 quirks;        /* KVASER_USB_HAS_ */
         enum kvaser_usb_leaf_family;
         const struct kvaser_usb_dev_*ops;
};
And quirks and family still affect dev->cfg.

Do you think this is OK?

Best regards,
jimmy

> Marc 
