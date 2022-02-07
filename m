Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 275044AB81D
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 11:01:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345251AbiBGJvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 04:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237352AbiBGJry (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 04:47:54 -0500
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 480BDC043187
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 01:47:53 -0800 (PST)
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id 202513F324
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 09:47:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1644227272;
        bh=02twp3uRHoEkWeARZkBktRJlx0WiVnvn489ap38/rX4=;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
         In-Reply-To:Content-Type;
        b=NLDIyJRZBpq0rD0KbrGTL8FcI2/DnWAqee+TtMNsDaJogBbVGya535JpeRvqVnYEX
         PKEV397OPgl+rlCr/tNmFKYf4WDzfhnaAnrYqpyiXLpZLRmYLTBhXD24Zv3Bs6yVR9
         HUo8/zWZiHi4q2AgjnSn96S+3jZShaJKSp2hwRP3c+PFQ9w1mi6r8dgtgnpedw20Mf
         /fl5sgC0mXZPWnE+EVrxAW4AxMzjcji+dOQOU+NhC73rva4DLQC/XiEKgtcT5/BRvM
         lpiubjiYED2ODvihWpotVCcWent/iErniVXdK8WcQYUSdO+DfM5vPsqjdDVIV+80SS
         cmvx5fODLeNng==
Received: by mail-ed1-f70.google.com with SMTP id dn20-20020a05640222f400b0040f8cdfb542so72976edb.3
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 01:47:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=02twp3uRHoEkWeARZkBktRJlx0WiVnvn489ap38/rX4=;
        b=WWGwx5ygwR1yAXbuuwFqcUiiaM3WJ8AsF3yDISPF8IxC//3uuOtikvXC3iYX+nLEE7
         N8jERB7GMkuXtc5hQ6v6sNPmaEVdAJYN+FjMVxw9uZilEHoLFMNpq6N+Rr9E6CciHrAW
         BxpLbiRQRslUGdLZ4tjjoxWoWeMGQm+P5asWzPBYCi93waxdS2uqNhV0rj4TzQj5k0Iw
         3GNp4Dna5jmY3ZmAGj5mr8mRV1o7vVk/kJlla8v0EvI9AVKDYG/TifZwC119kD3RfR3f
         FWRtSTd9jsnW6epOJLlUDvoiwUcD9dSjUY+0QJpPCEKvbkqNy1FsCE+Y700zB+IYiEit
         wgug==
X-Gm-Message-State: AOAM53093U5WcRuJ3S9RVZNTIO88QmdCJiKd3XOfFv1Q3z3nojt/H29e
        7MO3x2pl8n8QaburNETqz4Rs7YUKHtRT5IFfKloAFWhbNj/d/XId/+GKuihG1NmfHt+mndbQ7Ti
        SDLiWTI/wBVP00jxyEMjnu8I80QKt20Jw8Q==
X-Received: by 2002:a17:907:9493:: with SMTP id dm19mr9140716ejc.51.1644227271454;
        Mon, 07 Feb 2022 01:47:51 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxlQkvubOOEp5bPnxeLEugPVpKArS6HCKXpsaxcE4JL2I3U9CU5YCEJ+yy0TDGtA5tgBQyGKQ==
X-Received: by 2002:a17:907:9493:: with SMTP id dm19mr9140706ejc.51.1644227271280;
        Mon, 07 Feb 2022 01:47:51 -0800 (PST)
Received: from [192.168.0.86] (xdsl-188-155-168-84.adslplus.ch. [188.155.168.84])
        by smtp.gmail.com with ESMTPSA id nb16sm307441ejc.136.2022.02.07.01.47.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Feb 2022 01:47:50 -0800 (PST)
Message-ID: <a655b739-f6f5-3e68-4e1a-4be76ebdaef5@canonical.com>
Date:   Mon, 7 Feb 2022 10:47:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] ARM: socfpga: fix missing RESET_CONTROLLER
Content-Language: en-US
To:     Dinh Nguyen <dinguyen@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Nathan Chancellor <nathan@kernel.org>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
References: <20220207084404.212017-1-krzysztof.kozlowski@canonical.com>
 <b5c87b7d-fdb4-2288-5c21-c666fdd40005@kernel.org>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
In-Reply-To: <b5c87b7d-fdb4-2288-5c21-c666fdd40005@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07/02/2022 10:45, Dinh Nguyen wrote:
> 
> 
> On 2/7/22 02:44, Krzysztof Kozlowski wrote:
>> The SocFPGA machine since commit b3ca9888f35f ("reset: socfpga: add an
>> early reset driver for SoCFPGA") uses reset controller, so it should
>> select RESET_CONTROLLER explicitly.  Selecting ARCH_HAS_RESET_CONTROLLER
>> is not enough because it affects only default choice still allowing a
>> non-buildable configuration:
>>
>>    /usr/bin/arm-linux-gnueabi-ld: arch/arm/mach-socfpga/socfpga.o: in function `socfpga_init_irq':
>>    arch/arm/mach-socfpga/socfpga.c:56: undefined reference to `socfpga_reset_init'
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Cc: <stable@vger.kernel.org>
>> Fixes: b3ca9888f35f ("reset: socfpga: add an early reset driver for SoCFPGA")
>> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
>> ---
>>   arch/arm/mach-socfpga/Kconfig | 2 ++
>>   1 file changed, 2 insertions(+)
>>
>> diff --git a/arch/arm/mach-socfpga/Kconfig b/arch/arm/mach-socfpga/Kconfig
>> index 43ddec677c0b..594edf9bbea4 100644
>> --- a/arch/arm/mach-socfpga/Kconfig
>> +++ b/arch/arm/mach-socfpga/Kconfig
>> @@ -2,6 +2,7 @@
>>   menuconfig ARCH_INTEL_SOCFPGA
>>   	bool "Altera SOCFPGA family"
>>   	depends on ARCH_MULTI_V7
>> +	select ARCH_HAS_RESET_CONTROLLER
>>   	select ARCH_SUPPORTS_BIG_ENDIAN
>>   	select ARM_AMBA
>>   	select ARM_GIC
>> @@ -18,6 +19,7 @@ menuconfig ARCH_INTEL_SOCFPGA
>>   	select PL310_ERRATA_727915
>>   	select PL310_ERRATA_753970 if PL310
>>   	select PL310_ERRATA_769419
>> +	select RESET_CONTROLLER
>>   
>>   if ARCH_INTEL_SOCFPGA
>>   config SOCFPGA_SUSPEND
> 
> Acked-By: Dinh Nguyen <dinguyen@kernel.org>

Hi Dinh,

I was expecting you will pick it up. If you only ack, who is going to
take it? Shall I send it directly to soc@?

Best regards,
Krzysztof
