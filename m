Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A83158EEAA
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 16:45:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232597AbiHJOpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Aug 2022 10:45:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232321AbiHJOpW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Aug 2022 10:45:22 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E47E1201A8
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:45:21 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id l9so8393808ilq.1
        for <stable@vger.kernel.org>; Wed, 10 Aug 2022 07:45:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc;
        bh=9n+0K75R7EZoV92OS1ZV/e4z3S1vV3ZMEes9Tlr0Pvo=;
        b=J502nKl7nyY3BeHobHmwvEG+5l1dlpWjpCPBg6L95+90AoLVHXZfHmxJJX5fLvUHTf
         SUq3Dlq4eyVriCwDYMZJ4yvZOcOte9QFj5cGCXifcsi4BBMm6wjKGkkMp6kyWVyeAmR7
         AW7TDw0AAAN/CESK1hUuR1T5WEgzpCeqeMFBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc;
        bh=9n+0K75R7EZoV92OS1ZV/e4z3S1vV3ZMEes9Tlr0Pvo=;
        b=JZJRDuJtrUWWrTersYUTYqwhlINnIrTEZB6LeC8MAofwz/fLWcxLkyYvACnBM9Bhdo
         XCqwGAfrREW9ePHooArBVRFN4TpruzJ08LAv5FTb/Uc3PdVA1DAxc7X4qumQH9W395LC
         sVsC+RqJpgEmwAPj3BWuXn5hX+i8y+byzilqnnEvhxo94kg4jOfNbvSvcyTQOnfZfnZ+
         1OjxFjTSo3xxNziiCT0jQhS0AfWY/DXz76/CHLuXJjt/f8ODQcyXPUtkyzLlvbI14DDP
         0O2O72Y+HVkxfRVLo7EcYWnr6ZEm/GVHPWh6XWiapFndFS8L+IElT5+9vI47A/EY64g+
         EWrw==
X-Gm-Message-State: ACgBeo0LBupprrJeRzJsYV/Cuqy41Bt3/MNEARLU6CghmW4IGS0rwIlR
        O5607G45ymKCaroRpG9HWn5a1w==
X-Google-Smtp-Source: AA6agR5KM9HV4UMVJEXj/JAKryjBS2AmfoPfOr2M8U/nnmZ8cMDnm/XeQVESlipSKZVj3O89+pFPYg==
X-Received: by 2002:a92:cc04:0:b0:2de:1abf:7414 with SMTP id s4-20020a92cc04000000b002de1abf7414mr12868204ilp.119.1660142721273;
        Wed, 10 Aug 2022 07:45:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u132-20020a02238a000000b0033ee1e67c6esm7503211jau.79.2022.08.10.07.45.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 07:45:21 -0700 (PDT)
Subject: Re: [PATCH 5.4 00/15] 5.4.210-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220809175510.312431319@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <58175928-37ea-1a58-1382-4fe88ccedc69@linuxfoundation.org>
Date:   Wed, 10 Aug 2022 08:45:20 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220809175510.312431319@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 12:00 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.210 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.210-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
