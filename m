Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13A25529880
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 06:11:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234997AbiEQELa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 00:11:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235064AbiEQEL0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 00:11:26 -0400
Received: from mail-oa1-x30.google.com (mail-oa1-x30.google.com [IPv6:2001:4860:4864:20::30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72988260C
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:11:25 -0700 (PDT)
Received: by mail-oa1-x30.google.com with SMTP id 586e51a60fabf-f189b07f57so9300702fac.1
        for <stable@vger.kernel.org>; Mon, 16 May 2022 21:11:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3ghXKibsGeeDlqXrn4LuB7ZrsZcuzsC/5Mc52ZiE6IY=;
        b=X2ZpXRIxOUFJWP8cFqlix8VfI/5ewDOVJpvbdqsqI/cH3l+2tyxcglWgwwtKu469Lb
         knFr+MY1IbFOx8VHakZWgw/sbftI11qicKdjAhLYfAG+xY6coTJKtjC/SluEG9me4yyH
         OSQiQ1ZtJ6SSEJ3Wr5gURcgkw0Q6z+V+3BTKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3ghXKibsGeeDlqXrn4LuB7ZrsZcuzsC/5Mc52ZiE6IY=;
        b=oa6fZMb+XRVuVqGCJ9UnrRVXTR3PWlMwCsw9wwbkCuT0p4GCyT5E5VVo+puu05B4VI
         LhsbRuUfk9B2R1v8PzHr0B10dEA+nE0ZSU6EvVRL/rvz0Wez6W/esM/8tZ8YutsyL5gB
         0o6vyEeEkfDY4HeJ72WJzRMfCTuXL6QsPYmHoQmZwpkWCI3RVEG8gChvZ9WZiWCt2BP9
         Sd1rXN7beJLyg8Y0BCKxbjjkmwOzcTTDLi3qf3X5yQcYK9qBkS2bPXt7YkkFpJhZ5N+3
         TwYImru3LyJ2/kBXoIwEWIC5shH05LtYVrzfhbqa60IPAZeDGcxgS85ms3eg5K4jp67C
         o/PA==
X-Gm-Message-State: AOAM5326E/sFRiADrmgHJm7Rrw7zTIl8SNBU3CyZmBk4teOCrcxac49C
        onSX9FK+KzqceL98XOoWWI3BAw==
X-Google-Smtp-Source: ABdhPJxKPWYu7Ftpr9i9sph/zyZO0dGM4p2FbrUCRqXFE1pFySMGPV9PIcO+F62Wh6sAl85F4zzAmw==
X-Received: by 2002:a05:6870:ea93:b0:ee:1763:6ed2 with SMTP id s19-20020a056870ea9300b000ee17636ed2mr12099716oap.28.1652760684477;
        Mon, 16 May 2022 21:11:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id 35-20020a9d0da6000000b0060603221263sm4606832ots.51.2022.05.16.21.11.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 21:11:24 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/32] 4.19.244-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220516193614.773450018@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <87bb7e4a-1074-cbbb-2d50-6ef048f5b97e@linuxfoundation.org>
Date:   Mon, 16 May 2022 22:11:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220516193614.773450018@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/16/22 1:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.244 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.244-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
