Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2C245FB45F
	for <lists+stable@lfdr.de>; Tue, 11 Oct 2022 16:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJKOOV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Oct 2022 10:14:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229662AbiJKOOU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Oct 2022 10:14:20 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94B3C84E7B
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 07:14:18 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id u2so7206135ilv.6
        for <stable@vger.kernel.org>; Tue, 11 Oct 2022 07:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tpquxaAWxYU62p2jBAKSLjdmHZvRmKBWXbuDsxjCZS0=;
        b=GhjjH6cb3boSLsw2I0dJdrLeCKBxXWO1t/AqMQj6hRbOft9EnAvUm+Ou4V2xat1Lsp
         TjqgdS/orSPaAQJee+a2At10/TY8ee9fElPVdRRyJLDMj/9vWvIDXTYDC3XfGtGYqvFj
         gxtHWuAd0QaN0b4cHaVF5b9D1uyP3GTHaawRA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tpquxaAWxYU62p2jBAKSLjdmHZvRmKBWXbuDsxjCZS0=;
        b=nIbQJ7W8Z2qGOttLXL29nqDNBanmTCqSCofE+Lhpu43RcFAsDrQxZPXwl19LM0EPSH
         YbIojTzJdfu5f7d7nWa3Dubty9a2RtSJE/G23++akhlk3Ttdm4B1UrMcASSP8aMLd30/
         j5Exk/WjFiaZwI4bM48JvEJ5KhxsqAvfpq8KRqhqsyqZEGFQnHO355Lm+ShRn372G4tF
         Ohiol0PhfIZedZeLvX2OB3wCd9X2KrEurk64piLs4CLDbzgacvYxWzt/bkj979WEjpir
         yUWDpVtyvvDraZaiLAabAPJwAg3LYyGDyoF0uEzX994oozLLjbb2ch/9MAyz8t1YPcoX
         aCcw==
X-Gm-Message-State: ACrzQf2LlIJmeEybMkpqBmwcr40ac8NvqyUNCi0Z5GMdbMVLEFGLVOtf
        6UW64ERqSPvYXyNM3kgW+IOLdw==
X-Google-Smtp-Source: AMsMyM6n5Lx8v8QAVGkWrBAtKWXCW5MXtkakjBDTOeMfTCaTdmKeEJ3NWHhrmI/bSL+RdvsCJJeZmg==
X-Received: by 2002:a05:6e02:1be7:b0:2f9:b795:e298 with SMTP id y7-20020a056e021be700b002f9b795e298mr12949106ilv.117.1665497657615;
        Tue, 11 Oct 2022 07:14:17 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n27-20020a02a19b000000b00349deda465asm5072506jah.39.2022.10.11.07.14.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Oct 2022 07:14:17 -0700 (PDT)
Message-ID: <eb474c72-2fd2-2286-99c9-1cd1bcc3ec43@linuxfoundation.org>
Date:   Tue, 11 Oct 2022 08:14:14 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 00/35] 5.15.73-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221010191226.167997210@linuxfoundation.org>
Content-Language: en-US
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221010191226.167997210@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 13:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.73 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 19:12:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.73-rc2.gz
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
