Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05C1D4E9B2B
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 17:31:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237822AbiC1PdF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 11:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238282AbiC1Pcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 11:32:51 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2D25D18B
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 08:31:11 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id k14so12558767pga.0
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 08:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=IPFzIjgbZDtA5zvK2Bb6ObyLkIWss8RT/ZsHLBaqe60=;
        b=ViZ/ZJg9u1lfcWG0XtsZfG6oeG/okx0iuiRucQ9SZapGw9pN8SeCXqoq8vUwqM5lux
         tFMfldFoe3jIk1oDULHBI5bi6cr/IQIdvWRJHtKjQ/psxC7/znfC0CngLcKTBBjPf5eR
         I6li+wAh7rikC3K4gJdkJfRLI1/IoX3dF6sgEm4JSIFIslIB9srSgiOqs/xFO1gV+FGH
         uCzemgTPaRxCLNu+tAZey3p8Erv2L2wp7TPkqG7Y710P380TGab5xxhgITjGzjK3A8qN
         Oj3TWqJX63wf6oeEBLH+Te9QE50j44ry7UmQEq5Ro5dVen8+xmnhDYQprsgiFPoX8ih2
         wDDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IPFzIjgbZDtA5zvK2Bb6ObyLkIWss8RT/ZsHLBaqe60=;
        b=1F5CtW4M6dpFBQAcYX2EZhxInRkY2ym51VRzcG/+1nOGfTZ2/2YeNeteuFcndlBkT0
         VFCAGda0VOD8RXoTEGif3qircZ2ksSQwZKqYbJuH66ts84COmTRpInr2yCvgJ3r+c4gq
         JXEXJTHVKXieJkSEpget8BhlkNSzTisFkSTsNL0Gunvaky83C/+wCxrM9hTKkwjXbl76
         WbxWFQnHUwQ92HCcsrQt6o0rAT2M6EL9IDwsvcl7JHX/ZfhWzKdfN+h5//g8BhGsGmkC
         9CpqrJTVP94rEBLGsiWzEFMcOWR2fgHRt386Ya4PZBVmgLBHxE4aHCViztU7ZlTNF/Tu
         PPcQ==
X-Gm-Message-State: AOAM530faSI/JBn4M65HsqbUpCfsgXnrSyRS/rX1UAX1DbxWxoPEHbeq
        GjXGCW8Cx/7/3eE9pXXMpIE=
X-Google-Smtp-Source: ABdhPJxwDKw25veifk3+CNVyrtsZV2T0QhMljfZp8fVPUPWRrq1TDk0nFmklxNbZFHgjsQR/mOgFEw==
X-Received: by 2002:a63:2a97:0:b0:398:6e01:d565 with SMTP id q145-20020a632a97000000b003986e01d565mr1007643pgq.119.1648481470375;
        Mon, 28 Mar 2022 08:31:10 -0700 (PDT)
Received: from ?IPV6:240b:10:2720:5500:1b5:6130:7e8a:99b6? ([240b:10:2720:5500:1b5:6130:7e8a:99b6])
        by smtp.gmail.com with ESMTPSA id j7-20020a056a00130700b004b9f7cd94a4sm16241406pfu.56.2022.03.28.08.31.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Mar 2022 08:31:09 -0700 (PDT)
Message-ID: <01be7616-a610-db18-124d-865ef1d4e61c@gmail.com>
Date:   Tue, 29 Mar 2022 00:31:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v7 0/4] mtd: cfi_cmdset_0002: Use chip_ready() for write
 on S29GL064N
Content-Language: en-US
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>, miquel.raynal@bootlin.com
Cc:     richard@nod.at, vigneshr@ti.com, linux-mtd@lists.infradead.org,
        stable@vger.kernel.org,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20220323170458.5608-1-ikegami.t@gmail.com>
 <c807ca8c-3065-cdec-8e2b-5d5a77529c69@pengutronix.de>
From:   Tokunori Ikegami <ikegami.t@gmail.com>
In-Reply-To: <c807ca8c-3065-cdec-8e2b-5d5a77529c69@pengutronix.de>
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

Hi Ahmad-san,

On 2022/03/28 19:50, Ahmad Fatoum wrote:
> Hello Tokunori-san,
>
> On 23.03.22 18:04, Tokunori Ikegami wrote:
>> Since commit dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to
>> check correct value") buffered writes fail on S29GL064N. This is
>> because, on S29GL064N, reads return 0xFF at the end of DQ polling for
>> write completion, where as, chip_good() check expects actual data
>> written to the last location to be returned post DQ polling completion.
>> Fix is to revert to using chip_good() for S29GL064N which only checks
>> for DQ lines to settle down to determine write completion.
>>
>> Fixes: dfeae1073583("mtd: cfi_cmdset_0002: Change write buffer to check correct value")
>> Signed-off-by: Tokunori Ikegami <ikegami.t@gmail.com>
>> Cc: stable@vger.kernel.org
>> Link: https://lore.kernel.org/r/b687c259-6413-26c9-d4c9-b3afa69ea124@pengutronix.de/
> For this series,
>
> Tested-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
Thank you for your support.
>
> Thanks a lot for taking care of this. Could you keep me Cc'd
> on future revisions? Convention is via a Reported-by tag
> in the regression fix.

Sorry for this. Yes I will do cc on next time and also consider to add 
the Reported-by tag also.

Regards,
Ikegami

>
> Cheers,
> Ahmad
>
>
>> Tokunori Ikegami (4):
>>    mtd: cfi_cmdset_0002: Move and rename
>>      chip_check/chip_ready/chip_good_for_write
>>    mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N
>>    mtd: cfi_cmdset_0002: Add S29GL064N ID definition
>>    mtd: cfi_cmdset_0002: Rename chip_ready variables
>>
>>   drivers/mtd/chips/cfi_cmdset_0002.c | 112 ++++++++++++++--------------
>>   include/linux/mtd/cfi.h             |   1 +
>>   2 files changed, 55 insertions(+), 58 deletions(-)
>>
>
