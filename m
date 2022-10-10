Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 203105FA3A8
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 20:52:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbiJJSwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 14:52:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiJJSwA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 14:52:00 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6827733D2;
        Mon, 10 Oct 2022 11:51:54 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id i9so7651800qvu.1;
        Mon, 10 Oct 2022 11:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5SY/whMwtNZagNhth9q7erfAKU/W73YJ3jiwNclH4UA=;
        b=nOm/w8lYF8rPYhEJ6ORXeYEoPAfeXpJraAdI3+nVb8pNpiwLuKqfvrMC3WDvgUwhCp
         7Kal4fMZlvM+DW3RwfHIcs6B9CfUdRJswiMc7f72vHo6sttSg6rRXBXi+hgXU/3qkiyj
         pEuQf3OZQxwPZQz+lIzlnor+U6i/EY5qkv69JVHs80W1cn80tDHiUU7lUf5m3IyleCyW
         3n20fjUnUNtaHFRKJ76OsTDheWRVvrT+ETtn8oIve16xb7QhEkTFESfWp0bVnQEjxy0n
         WCd/Eypkw79wLvfPjhcGFJsEnkAepfekQ1sCIfF4Kk5DwwW4IqZp+j/tRQYzyAPMvExq
         8PmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5SY/whMwtNZagNhth9q7erfAKU/W73YJ3jiwNclH4UA=;
        b=bu2S+W13/Yt5kD2ZezNaLY8UMFXMxA8DX/vvl3J0bBA4bXP8qmi101WNrbZeoWmRTS
         jjZHPREHs2D/tZQe4hEvKMI17M6jTm3O8ffOsQ/TYghcohCzxDY7vtZInt9MBotB9H7I
         lSXDsem8KGXCJnaHyAvXeQi8e5GnW8NFtdVueP5bWHaZ7mplvZzQwiwyVIsFwNw8PadC
         arRjF6XIFOOw/FGT+FZrRJbE8P3oaGCFNHyF+l39ouPYfs+wS+op8eX3hC2I000Jn3pC
         nFg9/nhFhbdJ508F72TLhKU7fXJkAaUIFonNqFAzoVH6fwfFhakFAn/PybW+6f5pOI1Q
         /qLQ==
X-Gm-Message-State: ACrzQf0r2roQq/qebU29MccKxOM9oAyIwalK9fCt8IMOrDudnYlC1G5w
        F2zmW/hsvZwzqYzKWlckokA=
X-Google-Smtp-Source: AMsMyM5AE+KGlDFRkBUZJZeUbXeSKE95YdKgxyRoT5DHJUt9CdE6iJinCFYhCjdZMnSgTaXZuPGqbg==
X-Received: by 2002:a05:6214:1d09:b0:4b1:cd48:c95d with SMTP id e9-20020a0562141d0900b004b1cd48c95dmr16133214qvd.73.1665427913946;
        Mon, 10 Oct 2022 11:51:53 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id e124-20020a37b582000000b006ceb933a9fesm10820810qkf.81.2022.10.10.11.51.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 11:51:53 -0700 (PDT)
Message-ID: <48316d68-420d-e700-4e04-62beb6285705@gmail.com>
Date:   Mon, 10 Oct 2022 11:51:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.19 00/48] 5.19.15-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010070333.676316214@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221010070333.676316214@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 00:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.19.15 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.19.15-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
