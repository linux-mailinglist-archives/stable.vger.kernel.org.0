Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3E4B5AC098
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 20:22:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbiICSWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Sep 2022 14:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232017AbiICSWI (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Sep 2022 14:22:08 -0400
Received: from mail-lf1-x133.google.com (mail-lf1-x133.google.com [IPv6:2a00:1450:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87C1B4E874
        for <stable@vger.kernel.org>; Sat,  3 Sep 2022 11:22:07 -0700 (PDT)
Received: by mail-lf1-x133.google.com with SMTP id q7so7681528lfu.5
        for <stable@vger.kernel.org>; Sat, 03 Sep 2022 11:22:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kvaser.com; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=Q2prn5n6newbXXuJ8BZvUmVYF/i8jBG0q25CnLkH4Nc=;
        b=PLiLs7HkOLwViGixLW5/dqW5QWftgjsNsNA9XhBfpIpHH8xZO6V7QEyfB+ajTRqIqH
         l0EejjN+d/g01qsJH1jyrQLkk+EmyQuykbHW0FrwOAAqU0r1vYltpUbWiEMGxYfwg+HU
         Aytwg4hu3KE310I7jyhB60w2d/X3jDNWcfgg5oDwSJJdPgijms90g5c22k9jtIIwhyQ6
         T4NZEDill6IqGNFDP0twX9B1tHKjYwWJlJs6x2l5wwgOpsH8QFbmu7O74Kb/b2hvm2rL
         vahBcVMwzEgtWxSc4E167FZHWPrkcXRvv8scrto0RPbnYDLofU73qP+TioDdSx26D8PU
         z7CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=Q2prn5n6newbXXuJ8BZvUmVYF/i8jBG0q25CnLkH4Nc=;
        b=jFVJ0vA2xhMH7zdxU1/iuf1HsDKgfAt2r6JErkMzQ/gjpkNJWuXqsHbWE2+MWaZfoJ
         om1AYFwOlPww6gYDcSUVcb716nSQMusmOrsXsbmK1jWP3Pbl9dOFE8ERJWePoQBz628f
         FKZyGkX04z4UuA9siH+AO+KLA2KR/ewdrDVsb0z8THJ7Z7DCbe9p0KZrF2VJHHbXIkTt
         vtZFmnV6V+OeiAORByGOoPiIgFwTfJ/Xp8BXA6ocJMtY363gklc6UZLSdUf6rof9k47I
         rUAanj3aUU9BMmqwe5Kq0Bc7ZSjC8Qls5Ga/dh6/MkyDaFBdBtDXoPcW5LIQA+IjoyFX
         SChg==
X-Gm-Message-State: ACgBeo0ZY5MIVlakx7X9K/Ugbyt743D32F4GG5JIfKxBcQOloJQI2uE1
        g7WQEonPlkvrHH4m9jtL3TzyTzIuKHK2Sg==
X-Google-Smtp-Source: AA6agR55O0d5r9d7AxS3IPcHoBFGJUeAVagfXYsLXWpZUBoedkNkDVsMflBDdYuJ7JWQ0lMtQY/YPA==
X-Received: by 2002:a05:6512:33d5:b0:48b:17a:6b86 with SMTP id d21-20020a05651233d500b0048b017a6b86mr15315782lfg.671.1662229325880;
        Sat, 03 Sep 2022 11:22:05 -0700 (PDT)
Received: from [192.168.16.196] (h-155-4-68-234.A785.priv.bahnhof.se. [155.4.68.234])
        by smtp.gmail.com with ESMTPSA id u4-20020ac258c4000000b0048b03ec561fsm655685lfo.150.2022.09.03.11.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Sep 2022 11:22:05 -0700 (PDT)
Message-ID: <43824cd0-a25f-5d3b-ca85-7b8488201ef2@kvaser.com>
Date:   Sat, 3 Sep 2022 20:21:09 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v3 04/15] can: kvaser_usb: kvaser_usb_leaf: Get
 capabilities from device
Content-Language: en-US
To:     Anssi Hannula <anssi.hannula@bitwise.fi>,
        linux-can@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Jimmy Assarsson <jimmyassarsson@gmail.com>, stable@vger.kernel.org
References: <20220901122729.271-1-extja@kvaser.com>
 <20220901122729.271-5-extja@kvaser.com>
 <e1c06d77-9758-49e3-f772-084d2df365b9@bitwise.fi>
From:   Jimmy Assarsson <extja@kvaser.com>
In-Reply-To: <e1c06d77-9758-49e3-f772-084d2df365b9@bitwise.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 13:40, Anssi Hannula wrote:
> Hi,
> 
> On 1.9.2022 15.27, Jimmy Assarsson wrote:
>> Use the CMD_GET_CAPABILITIES_REQ command to query the device for certain
>> capabilities. We are only interested in LISTENONLY mode and wither the
>> device reports CAN error counters.
>>
>> And remove hard coded capabilities for all Leaf devices.
> 
> I think the second paragraph is no longer accurate.

Oops, will fix this in v4.

> But the patch itself works for me now with no regressions that I can see.
> 
> Tested-by: Anssi Hannula <anssi.hannula@bitwise.fi>
> 
> Thanks for taking care of the patchset!
Thanks again for testing!

>> Cc: stable@vger.kernel.org
>> Fixes: 080f40a6fa28 ("can: kvaser_usb: Add support for Kvaser CAN/USB devices")
>> Reported-by: Anssi Hannula <anssi.hannula@bitwise.fi>
>> Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
>> ---
>> Changes in v3
>>   - Rebased on 1d5eeda23f36 ("can: kvaser_usb: advertise timestamping capabilities and add ioctl support")
>>   - Add stable to CC
>>   - Re-add hard coded capabilities for Leaf M32C devices, to fix regression
>>     found by Anssi Hannula in v2 [1].
>>
>> Changes in v2:
>>    - New in v2. Replaces [PATCH 04/12] can: kvaser_usb: Mark Mini PCIe 2xHS as supporting
>>   error counters
>>    - Fixed Anssi's comments; https://lore.kernel.org/linux-can/9742e7ab-3650-74d8-5a44-136555788c08@bitwise.fi/
>>
>> [1] https://lore.kernel.org/linux-can/b25bc059-d776-146d-0b3c-41aecf4bd9f8@bitwise.fi/
>>
>>   .../net/can/usb/kvaser_usb/kvaser_usb_leaf.c  | 144 +++++++++++++++++-
>>   1 file changed, 143 insertions(+), 1 deletion(-)
>>
> [...]
