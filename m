Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B5ED56D0C5
	for <lists+stable@lfdr.de>; Sun, 10 Jul 2022 20:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229629AbiGJSlS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jul 2022 14:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229614AbiGJSlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 Jul 2022 14:41:17 -0400
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35282140CC;
        Sun, 10 Jul 2022 11:41:16 -0700 (PDT)
Received: by mail-lj1-x22d.google.com with SMTP id 19so3960620ljz.4;
        Sun, 10 Jul 2022 11:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=kDNBr0d7sr3bD6/9LJRssalA5Q9uqgboJ4YbUUnhl90=;
        b=nixMDEFgetF4NTqiQPaRAnY8pB2LxNhDzqQNiQZM+x+7rPjCo96SCjNo73ZtucKREs
         4DomXt/K4X9l+gqdgy0l/tMyyzLqEgypS5zp0jG7X+7GtjlthVkYKxRwiMQrrmGPkjC+
         z6u6Fiaax0K6v9OFYPjUp3wPGVCBWAyMRB+2LhPQD2Nv8C3OzM0rdPUYto2X0+WxJvzq
         edjPVg7WY7pz2blcWi/ORDaMBTtuV5VcNMW0+jjgaQBIHsxlFz7n34LNVIVH3rXOIdoq
         yEXCVcl5XeBTF34dxPLnTuGQlfDxV1wbq6PVAZmJUXbmDXPmZyFEERH309HsaNav3fLz
         miNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=kDNBr0d7sr3bD6/9LJRssalA5Q9uqgboJ4YbUUnhl90=;
        b=7p4nmO5IG9kfXaud2/Uq3IQPuPxA+27gDaRXoCUhTW+YKwO4fXP3op1hnD2KR/62p0
         bYxJZKL0wnZCy5nSORwAQ4fJ9ka2hcky7E6GUXUVNU76tOWPUjMSVbO356gb8UdmqagQ
         pMmDvAfoes+/qsPIb9Nowaol+179E8sMWDWtXRukqbUX4JmzUu1kLEUnIH6QpgiVB3GL
         oUqZ/unepb8gZBh6mZA9UlNRGuE2bUFhVj5yzvoXpVwG32kIu6NDc7HA8YSectg3eTEI
         RLXoxSWVnxJiXpoMe8FnHMoK0Y74GdXsTQQMQ7adpZwFhYiNXwwtdv8dxyd3zYMSNgAR
         wLMw==
X-Gm-Message-State: AJIora+SUpD8UrJLk5L089dL2GZs2hnhDi2IPgCGrYJvKadePmHbwjtA
        bX7Q/GxtVxljkCYcCe0Jk/E=
X-Google-Smtp-Source: AGRyM1vqZQpxm5rycecwqamCyqWpncRzRJRVims5di3aDXGfRaAnVtSqvJN12pIp1Rbm6skgECufWw==
X-Received: by 2002:a2e:8404:0:b0:250:cde7:e9e3 with SMTP id z4-20020a2e8404000000b00250cde7e9e3mr7771898ljg.289.1657478474488;
        Sun, 10 Jul 2022 11:41:14 -0700 (PDT)
Received: from [192.168.1.70] (90-224-163-144-no555.tbcn.telia.com. [90.224.163.144])
        by smtp.googlemail.com with ESMTPSA id q12-20020a056512210c00b00489daae997fsm394439lfr.10.2022.07.10.11.41.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 10 Jul 2022 11:41:14 -0700 (PDT)
Message-ID: <5059cce9-76b4-b19c-2d97-c1e54c7dd87d@gmail.com>
Date:   Sun, 10 Jul 2022 20:40:30 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 4.14 1/4] can: kvaser_usb: Add struct kvaser_usb_dev_cfg
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Jimmy Assarsson <extja@kvaser.com>
References: <20220708184653.280882-1-extja@kvaser.com>
 <20220708184653.280882-2-extja@kvaser.com> <YsrgbqIFfcxXesWw@kroah.com>
From:   Jimmy Assarsson <jimmyassarsson@gmail.com>
In-Reply-To: <YsrgbqIFfcxXesWw@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/10/22 16:21, Greg KH wrote:
> On Fri, Jul 08, 2022 at 08:46:50PM +0200, Jimmy Assarsson wrote:
>> Add struct kvaser_usb_dev_cfg to ease backporting of upstream commits:
>> 49f274c72357 (can: kvaser_usb: replace run-time checks with struct kvaser_usb_driver_info)
>> e6c80e601053 (can: kvaser_usb: kvaser_usb_leaf: fix CAN clock frequency regression)
>> b3b6df2c56d8 (can: kvaser_usb: kvaser_usb_leaf: fix bittiming limits)
> 
> What upstream commit is this from?

Hi Greg,

The original upstream commit introducing struct kvaser_usb_dev_cfg is
7259124eac7d1b76b41c7a9cb2511a30556deebe
can: kvaser_usb: Split driver into kvaser_usb_core.c and kvaser_usb_leaf.c
And was first merged to 4.19.

This was part of a major restructure of the driver to add support for new type of devices.


And upstream commit
commit fb12797ab1fef480ad8a32a30984844444eeb00d
can: kvaser_usb: get CAN clock frequency from device
introduced kvaser_usb_leaf_dev_cfg_{8,16,24,32}mhz

>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
>> ---
>>   drivers/net/can/usb/kvaser_usb.c | 76 ++++++++++++++++++++++----------
>>   1 file changed, 52 insertions(+), 24 deletions(-)
>>
>> diff --git a/drivers/net/can/usb/kvaser_usb.c b/drivers/net/can/usb/kvaser_usb.c
>> index 9742e32d5cd5..6759868924b2 100644
>> --- a/drivers/net/can/usb/kvaser_usb.c
>> +++ b/drivers/net/can/usb/kvaser_usb.c
>> @@ -31,10 +31,6 @@
>>   #define USB_SEND_TIMEOUT		1000 /* msecs */
>>   #define USB_RECV_TIMEOUT		1000 /* msecs */
>>   #define RX_BUFFER_SIZE			3072
>> -#define KVASER_USB_CAN_CLOCK_8MHZ	8000000
>> -#define KVASER_USB_CAN_CLOCK_16MHZ	16000000
>> -#define KVASER_USB_CAN_CLOCK_24MHZ	24000000
>> -#define KVASER_USB_CAN_CLOCK_32MHZ	32000000
> 
> You also deleted these, you didn't really describe any of this in the
> changelog text at all :(

They where replaced by const struct kvaser_usb_dev_cfg kvaser_usb_leaf_dev_cfg_{8,16,24,32}mhz.
Sorry for not mentioning this.

> Why not just backport the needed commit instead of this unknown one?

Sure, if you prefer it :)
In that case I would also like to backport the rest of the patches related to the
adding of kvaser_usb/kvaser_usb_hydra.c, if you don't mind?

Best regards,
jimmy


> thanks,
> 
> greg k-h
