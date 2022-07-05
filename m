Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9AC5674DC
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 18:53:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbiGEQxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 12:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiGEQxq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 12:53:46 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06162BA9;
        Tue,  5 Jul 2022 09:53:46 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id c13so14520683qtq.10;
        Tue, 05 Jul 2022 09:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=vE8gOSGjTQeY5cTYe8BghySgChpBQ8oRPHekrCEoNIU=;
        b=bCT7wiRdwLro7eGVHflSPR4et9p+6/lRWLvVnS2hWmNS3xTu0O0FrHfGLTAGKEPYzu
         FYbhUDlUN8JXqYcmBTNa84BHuUDXpoG5PM3LF71zH9tZ1AnKJB+EqvaZTayxxdqh/NuB
         8rgkMDCmlNKkaDwbaWmaA7P/Dhec/kPpsFLB+lf/LHv6WFXhAUKmHhONUqc5UutGw7lR
         y1vAgLCdL4XgoRTNNedXar+MSs+FVARRGyB137YgP30J4Z+bDJ36q0rS1S5jTW20wCmD
         MdTYBc52CbArlDA1Q95kyqJ1D2cFJ4zoyPXsf9oN1I7vDuK/Ez/hvRdG1r1NH8fXxxWe
         EcAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=vE8gOSGjTQeY5cTYe8BghySgChpBQ8oRPHekrCEoNIU=;
        b=YM53TqLMLeLYzgPsd2MZHBsKZ/mHc9DjMuoy8gmqYcs45zbFvJDwSJuILEtQz2/jhD
         vjTB6nmV8a4t1CRf/mKN87UwFg6ALu9BXX6coyzaoihtYr9VxMBadtXRQLgG7KKV1PZL
         JIVt2cPfEtUy4Lu2xS4moPJdopMplleK20V9TqsHGPJZMpSbhHx6xgMAyXbWNPplcmfn
         UO97OuucFeF+AFMW9Pg5OwFirVxCldLcARncdM6JeOg0XHpcZTR+r/lCu2HdUOtulAeA
         wsfgbPvPoMNQnF/7xb/1/mQh1FofSLZwYOpOPLMvubW4qepawdbZcGN1bhLnILj5voxj
         uejw==
X-Gm-Message-State: AJIora/Tcb6T9ntSBXPwGiIQObaKClpkpnRaFKDczmLesIcp6KiGv9sz
        /DUxg5gkKHq22u7tXqSvagA=
X-Google-Smtp-Source: AGRyM1ulXlrDUQgRSNMjF0riRZGeZrpeN8DyXuYTAazz+rRhrdHqPijKJOD5oUiAmFVtTZ7j/AO9mA==
X-Received: by 2002:a05:6214:27e7:b0:472:f1de:a4f6 with SMTP id jt7-20020a05621427e700b00472f1dea4f6mr10643950qvb.28.1657040025152;
        Tue, 05 Jul 2022 09:53:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id o16-20020a05620a2a1000b006a68fdc2d18sm24399999qkp.130.2022.07.05.09.53.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Jul 2022 09:53:44 -0700 (PDT)
Message-ID: <b1ede90f-035b-d40f-7a78-c699cbbf3900@gmail.com>
Date:   Tue, 5 Jul 2022 09:53:42 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 5.4 00/58] 5.4.204-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220705115610.236040773@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220705115610.236040773@linuxfoundation.org>
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

On 7/5/22 04:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.204 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.204-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
