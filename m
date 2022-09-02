Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF1C5ABAA3
	for <lists+stable@lfdr.de>; Sat,  3 Sep 2022 00:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiIBWGi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 18:06:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiIBWGh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 18:06:37 -0400
Received: from mail-oa1-x2c.google.com (mail-oa1-x2c.google.com [IPv6:2001:4860:4864:20::2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0140CFAC57
        for <stable@vger.kernel.org>; Fri,  2 Sep 2022 15:06:37 -0700 (PDT)
Received: by mail-oa1-x2c.google.com with SMTP id 586e51a60fabf-11eab59db71so8018111fac.11
        for <stable@vger.kernel.org>; Fri, 02 Sep 2022 15:06:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=9qX6YCyjku8qBakOUeq0M8NNGw+W8PvXfjDjCS9/wbw=;
        b=J29oYpZsXnj37dG8L9ul3xK8uzaagnFAZ/npfTNYvlZ1WyVC/t2c8ADpzlX6xQCfx3
         LZ7EHrnc1moUFJtS6TZtaS01SKRT+m4tOcdP+X5NhctzdpQKxv4ZrNRUXn2V9rJ4/Upo
         m+M2pfEclBg6hoS274KVBR9cEkMmQTxFrc1K4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=9qX6YCyjku8qBakOUeq0M8NNGw+W8PvXfjDjCS9/wbw=;
        b=RCmJBB+Ag5J7Pg3ZsO53ZaB152KW4hqZqzyHFumNk4yUriwValdEN5j4/F4/VWGebq
         wd2gmoQm2P6MAtayccYBGZn2TnTwCLjKYdLi7QBsCODleZ3aCBiTJOqeslQ3vZsGYFJw
         bC0rF9jUhzXzQsV0etz6F7O+evD+/Ma7dbXPmEY+F64lMY73aTwv5FSfJUEUPj7MfIzg
         l59Yg/XhxxDVs5LEZG6gMtthE8jQKy3mG0Y96wC23F0pREx2Cjx9j0eV6jhdZ/qtQcdZ
         urY5RZpQrL90HzO69x4QJ/IJW9SRrq78LhlDzqoRu1Rf1iLG5W4D70fSoHv2Os40tPJV
         0o5A==
X-Gm-Message-State: ACgBeo2pCYp94IWPC8f5lm28MwCmJcGnW913GGPi8+N5sinFpeNTD/8g
        Rk2JW0ZUudlOgO0LhHB5xyDA9Q==
X-Google-Smtp-Source: AA6agR5kxnVqV73hZs6Gu7xLKLu1xRYo2knIa65HIfeDbG8oCQdGVG3qYJ6GjYIobLQP4/gTaxU8aA==
X-Received: by 2002:a05:6808:58:b0:343:2a77:cdc7 with SMTP id v24-20020a056808005800b003432a77cdc7mr2686420oic.160.1662156396366;
        Fri, 02 Sep 2022 15:06:36 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n26-20020a4ac71a000000b0044528e04cdasm1096776ooq.23.2022.09.02.15.06.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Sep 2022 15:06:35 -0700 (PDT)
Message-ID: <567c27f4-643d-6134-f8a1-d77c51061eac@linuxfoundation.org>
Date:   Fri, 2 Sep 2022 16:06:33 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.15 00/73] 5.15.65-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/2/22 06:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.65 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 04 Sep 2022 12:13:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
