Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B816D59F7
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 09:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233555AbjDDHuL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 03:50:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233481AbjDDHuJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 03:50:09 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F62F198A
        for <stable@vger.kernel.org>; Tue,  4 Apr 2023 00:50:05 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id ek18so126953945edb.6
        for <stable@vger.kernel.org>; Tue, 04 Apr 2023 00:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680594603;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kezhv9d6QR0moLZQZLP59cWk9hdbDvemawNvVPcvO0o=;
        b=ONPiOtXvw1WnROZZyuU6NhflgQtZrMnPFIM1ATOgixvqvJVKrbT/s/29p3XJN4lfpP
         dyRBaSA5Zbs4YtQAD0nn8d0J+RrnuBW+fbZuz/U4eLJ5R/ZOhAhfU4V3DUyg6GRpoY4W
         37OnZQYEYAmju68Blguz33UsbghEA4XFvZJC7BGLN46F784iuAo/qdxaskoYm4u4ocCv
         cLyulkzzaFLEC/Gv90MK/tlA5FRVkH2ohjEkVTJ2gaWMUCj4VJG0jhv279ebGUb1j2oB
         LviWeTa8lofl2+S9argZR2KgW/St6himvqr6BNmgLV3EvJhiFwU0fhxQVNT0RoPD/XE9
         Bq2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680594603;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kezhv9d6QR0moLZQZLP59cWk9hdbDvemawNvVPcvO0o=;
        b=EiF+1W7aTHJsGTliLqfHJNQ+EPPekvdxxXNXYp07MuHzBW0uv5n0lOWTYub9bjE0Ft
         w8ewUcinFnLl7WrlS+cITaQ0pylyKyMj748lRiQ72UBhJtOPMDR5bHowAJb5ZQduXvh1
         q6riUtVTwRzzKUmkWLAC1At7mC16wFrfQUXhr5GmWuoNqKrmoZXqyaQiK3/pJ+mvQlXu
         xfOquHzmtKmHZqk2cFiXCHnoQc/Z/5utkiuWj1UjfMszOLxFaPq0gJWOvsdXC9ADKtBn
         jhv6RWvo4KIhrrF22pip5lEUeN1aA4f2778alXvoT2+hV3AjGfG9x824PFsEKcb+mRIU
         LmpQ==
X-Gm-Message-State: AAQBX9dCL7U30pKEV11RfgsV1WMOpq7Nj16A4NIb6gIburrIIum0yuGw
        v4B7ByE2fPzdIUqkFI2j+/hP6Q==
X-Google-Smtp-Source: AKy350ZBpn2yyLhTTc5gkoowZegpKLha1L/WSbCfyVM+Z0Ucu2CGAHQQ0RBLDa22iUcU9yCTpWqYSQ==
X-Received: by 2002:a17:907:1622:b0:930:18f5:d016 with SMTP id hb34-20020a170907162200b0093018f5d016mr1718523ejc.15.1680594603729;
        Tue, 04 Apr 2023 00:50:03 -0700 (PDT)
Received: from [192.168.2.173] ([79.115.63.91])
        by smtp.gmail.com with ESMTPSA id r3-20020a170906350300b00930876176e2sm5541252eja.29.2023.04.04.00.50.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 00:50:03 -0700 (PDT)
Message-ID: <6460dd2a-2aed-99a0-0e42-d65d26b39d36@linaro.org>
Date:   Tue, 4 Apr 2023 10:50:01 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v2] mtd: spi-nor: spansion: Enable JFFS2 write buffer for
 Infineon SEMPER flash
Content-Language: en-US
From:   Tudor Ambarus <tudor.ambarus@linaro.org>
To:     tkuw584924@gmail.com, linux-mtd@lists.infradead.org
Cc:     pratyush@kernel.org, michael@walle.cc, miquel.raynal@bootlin.com,
        richard@nod.at, vigneshr@ti.com, d-gole@ti.com,
        Bacem.Daassi@infineon.com,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        stable@vger.kernel.org
References: <20230404071715.27147-1-Takahiro.Kuwano@infineon.com>
 <86b0ce12-0933-1fd7-d9c6-6e18ad7a9c56@linaro.org>
In-Reply-To: <86b0ce12-0933-1fd7-d9c6-6e18ad7a9c56@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 04.04.2023 10:45, Tudor Ambarus wrote:
> 
> 
> On 04.04.2023 10:17, tkuw584924@gmail.com wrote:
>> From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
>>
>> Infineon(Cypress) SEMPER NOR flash family has on-die ECC and its program
>> granularity is 16-byte ECC data unit size. JFFS2 supports write buffer
>> mode for ECC'd NOR flash. To activate it, MTD_BIT_WRITEABLE needs to be
>> unset in mtd->flags.
>>
>> A new SNOR_F_ECC flag is introduced to determine if the part has on-die
>> ECC and if it has, MTD_BIT_WRITEABLE is unset.
>>
>> In vendor specific driver, a common cypress_nor_ecc_init() helper is
>> added. This helper takes care for ECC related initialization for SEMPER
>> flash family by setting up params->writesize and SNOR_F_ECC.
>>
>> Fixes: 6afcc84080c4 ("mtd: spi-nor: spansion: Add support for Infineon S25FS256T")
>> Fixes: b6b23833fc42 ("mtd: spi-nor: spansion: Add s25hl-t/s25hs-t IDs and fixups")
>> Fixes: c3266af101f2 ("mtd: spi-nor: spansion: add support for Cypress Semper flash")
> 
> Would you please split this in 3 patches, first fixing c3266af101f2,
> then b6b23833fc42 and then 6afcc84080c4? It will help stable team
> backport each for each flash affected.
> 
> Looks good otherwise.

Here's how you can specify patch prerequisites:
https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-1

'''
Additionally, some patches submitted via Option 1 may have additional
patch prerequisites which can be cherry-picked. This can be specified in
the following format in the sign-off area:

Cc: <stable@vger.kernel.org> # 3.3.x: a1f84a3: sched: Check for idle
Cc: <stable@vger.kernel.org> # 3.3.x: 1b9508f: sched: Rate-limit newidle
Cc: <stable@vger.kernel.org> # 3.3.x: fd21073: sched: Fix affinity logic
Cc: <stable@vger.kernel.org> # 3.3.x
Signed-off-by: Ingo Molnar <mingo@elte.hu>
'''
