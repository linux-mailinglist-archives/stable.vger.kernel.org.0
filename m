Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CD4A597FFA
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 10:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239739AbiHRIRc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 04:17:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239673AbiHRIRb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 04:17:31 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD6237EFDF
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 01:17:30 -0700 (PDT)
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 1F72E41FD4
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 08:17:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1660810646;
        bh=nAL3OU0N2XYH48ZM4NQOXy6U04pGy/lEK4T1iote3O4=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=OldyU/gjskSMiN63xT/AabauVhmkmi4cYCEwUwZVKXqqW7+A2qGQLOLqx1GM/9r3e
         adRmh7VUA8eqJylGJqX3D8rD/eJ5xsYNbC8KGPex+597GmDeHofOdb8Oqm/ESuiP4a
         EB35F0w5/iYrTzr8sWVSXE1dCDqdZSsL3DzA+OOkTf7gVMY19/lEfEEKQ0YLfZYYFP
         O5/qLiZQmX8lbekqTHnrAOSOoxGlKu7FiOGFK1is8lBuswrkrH0GCsh8r6rlyHExxa
         Vcdj3htQBJ4jG8VC7R4qHMpFw0imnZm8Yqao6BefKZdiPALcwRNPuIQwUrr31XSsBs
         XzeIOpjgJbpYw==
Received: by mail-wm1-f71.google.com with SMTP id i132-20020a1c3b8a000000b003a537064611so621441wma.4
        for <stable@vger.kernel.org>; Thu, 18 Aug 2022 01:17:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=nAL3OU0N2XYH48ZM4NQOXy6U04pGy/lEK4T1iote3O4=;
        b=NLYFUjcF7Tv6ByfTzNGZo5dM7oCGEUxXcbxO0s+8zQn4xqYeZ7lxkmoC+bdZZg4t2y
         t1uwsl2WhdNEj9dlsBfmLRug0DA7DJ2gpJvysakkusQa2V2Z6h7WCSse7G1SpXInM5X5
         lc5QOO9TF7t4EM31y+O0gfLhV2k48L6Kxlvs/9XRQYYV6CnWUcikscpJwxdKJ4deBsc5
         7ch44QEUOMORTaYkPrcMIZWPK4S7hJ0oHpHGXiIj6R3V30ZyxsDXGE036coTqIfRBKRa
         T3kH46exbER41cuZy4YyMdAeikxmSZC4IBT6eMkHbAzfgmaw4byZN3vT4wMNOrxwP27K
         /0JQ==
X-Gm-Message-State: ACgBeo3Bafijk3TbnnBCcSCRxp3+EfDVktRtWEWd4gluWvURa9yN0Qc2
        gGf63+xUkRoZzhEetZYvxNDdm0hEh0XfNoiq1UEqx81xf2ppqJRwdZcQFrAHmR0dj7l/pfus8uc
        6xUTESHt9d4i5PFDFbl+I2ovB24dCEIcDcg==
X-Received: by 2002:a05:6000:1ac7:b0:225:1cb4:d443 with SMTP id i7-20020a0560001ac700b002251cb4d443mr894335wry.501.1660810644635;
        Thu, 18 Aug 2022 01:17:24 -0700 (PDT)
X-Google-Smtp-Source: AA6agR7UtRK49PUfX6BblfH4ht1MDEm3+bFgKVoLlKnQBnqzYe1+RlQezcyltukJ4BVVP00eEq4X0g==
X-Received: by 2002:a05:6000:1ac7:b0:225:1cb4:d443 with SMTP id i7-20020a0560001ac700b002251cb4d443mr894310wry.501.1660810644376;
        Thu, 18 Aug 2022 01:17:24 -0700 (PDT)
Received: from [192.168.123.67] (ip-084-118-157-002.um23.pools.vodafone-ip.de. [84.118.157.2])
        by smtp.gmail.com with ESMTPSA id p22-20020a05600c359600b003a35516ccc3sm1415601wmq.26.2022.08.18.01.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Aug 2022 01:17:23 -0700 (PDT)
Message-ID: <00500974-474d-3559-c141-3cc758bc0423@canonical.com>
Date:   Thu, 18 Aug 2022 10:17:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH 1/1] riscv: dts: microchip: correct L2 cache interrupts
Content-Language: en-US
To:     Daire.McNamara@microchip.com
Cc:     linux-riscv@lists.infradead.org,
        emil.renner.berthing@canonical.com, devicetree@vger.kernel.org,
        paul.walmsley@sifive.com, aou@eecs.berkeley.edu,
        palmer@dabbelt.com, geert@linux-m68k.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        atishp@rivosinc.com, krzysztof.kozlowski+dt@linaro.org,
        robh+dt@kernel.org, Conor.Dooley@microchip.com
References: <20220817132521.3159388-1-heinrich.schuchardt@canonical.com>
 <32a72954-c692-6c5d-b07b-266d426c3cb4@microchip.com>
 <ccb5792bfe467dcc5046b7cb4de3a6af14cd3d5a.camel@microchip.com>
From:   Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
In-Reply-To: <ccb5792bfe467dcc5046b7cb4de3a6af14cd3d5a.camel@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/18/22 09:03, Daire.McNamara@microchip.com wrote:
> On Wed, 2022-08-17 at 18:04 +0000, Conor Dooley - M52691 wrote:
>> Hey Heinrich,
>> Interesting CC list you got there! Surprised the mailmap didn't sort
>> out Atish & Krzysztof's addresses, but I think I've fixed them up.
>>   I see Daire isn't there either so +CC him too.
>>
>> On 17/08/2022 14:25, Heinrich Schuchardt wrote:
>>> EXTERNAL EMAIL: Do not click links or open attachments unless you
>>> know the content is safe
>>>
>>> The "PolarFire SoC MSS Technical Reference Manual" documents the
>>> following PLIC interrupts:
>>>
>>> 1 - L2 Cache Controller Signals when a metadata correction event
>>> occurs
>>> 2 - L2 Cache Controller Signals when an uncorrectable metadata
>>> event occurs
>>> 3 - L2 Cache Controller Signals when a data correction event occurs
>>> 4 - L2 Cache Controller Signals when an uncorrectable data event
>>> occurs
>>>
>>> This differs from the SiFive FU540 which only has three L2 cache
>>> related
>>> interrupts.
>>>
>>> The sequence in the device tree is defined by an enum:
> in drivers/soc/sifive/sifive_l2_cache.c
>>>
>>>      enum {
>>>              DIR_CORR = 0,
>>>              DATA_CORR,
>>>              DATA_UNCORR,
>>>              DIR_UNCORR,
>>>      };
>>
>> Nit: more accurately by the dt-binding:
>>    interrupts:
>>      minItems: 3
>>      items:
>>        - description: DirError interrupt
>>        - description: DataError interrupt
>>        - description: DataFail interrupt
>>        - description: DirFail interrupt
>>
>> I do find the names in the enum to be a bit more understandable
>> however,
>> and ditto for the descriptions in our TRM... Maybe I should put that
>> on
>> my todo list of cleanups :)
>>
>>
>>> So the correct sequence of the L2 cache interrupts is
>>>
>>>      interrupts = <1>, <3>, <4>, <2>;
>>
>> This looks correct to me. You mentioned on IRC that what you were
>> seeing
>> was a wall of
>> L2CACHE: DataFail @ 0x00000000.0807FFD8
>>  From a quick look at the driver, what seems to be happening here is
>> that
>> at some point (possibly before Linux even comes into the picture)
>> there
>> is an uncorrectable data error. Because the ordering in the dt is
>> wrong,
>> we read the wrong register and so the interrupt is never actually
>> cleared. With this patch applied, I see a single DataFail right as
>> the
>> interrupt gets registed & nothing after that.
>>
>> I am not really sure what value there is in enabling that driver
>> though,
>> mostly just seems like a debugging tool & from our pov we would see
>> the
>> HSS running in the monitor core as being responsible for handling the
>> l2-cache errors.
>>
>> @Daire, maybe you have an opinion here?
> Likewise. The new ordering of the interrupts to what the driver expects
> looks correct - as far as it goes. However, I'm not convinced enabling
> the SiFive l2 cache driver out of the box makes sense. Using l2 cache
> driver doesn't align terribly well with the current MPFS roadmap for
> mgt of ECC errors.
>>
>> Patch LGTM, so I'll likely apply it in the next day or two, would
>> just
>> like to see what Daire has to say first.
> If l2-cache controller is enabled, then interrupts should be connected
> as per TRM.  I think this specific patch lgtm, ideally with a
> 'disabled' stanza and it's up to individual MPFS customers/boards to
> enable l2 cache controller if they want it.

Disabling the device in the device-tree is orthogonal to fixing the 
interrupt sequence. I would suggest that you use a separate patch for 
adding status = "disabled";.

Best regards

Heinrich

>>
>>> Fixes: e35b07a7df9b ("riscv: dts: microchip: mpfs: Group tuples in
>>> interrupt properties")
>>
>> BTW, it isn't really fixing this patch right? This is a dependency
>> for
>> backports to 5.15.
>>
>> Thanks for your patch,
>> Conor.
>>
>>> Fixes: 0fa6107eca41 ("RISC-V: Initial DTS for Microchip ICICLE
>>> board")
>>> Cc: Conor Dooley <conor.dooley@microchip.com>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Heinrich Schuchardt <
>>> heinrich.schuchardt@canonical.com>
>>> ---
>>>   arch/riscv/boot/dts/microchip/mpfs.dtsi | 2 +-
>>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>>
>>> diff --git a/arch/riscv/boot/dts/microchip/mpfs.dtsi
>>> b/arch/riscv/boot/dts/microchip/mpfs.dtsi
>>> index 496d3b7642bd..ec1de6344be9 100644
>>> --- a/arch/riscv/boot/dts/microchip/mpfs.dtsi
>>> +++ b/arch/riscv/boot/dts/microchip/mpfs.dtsi
>>> @@ -169,7 +169,7 @@ cctrllr: cache-controller@2010000 {
>>>                          cache-size = <2097152>;
>>>                          cache-unified;
>>>                          interrupt-parent = <&plic>;
>>> -                       interrupts = <1>, <2>, <3>;
>>> +                       interrupts = <1>, <3>, <4>, <2>;
>>>                  };
>>>
>>>                  clint: clint@2000000 {
>>> --
>>> 2.36.1
>>>

