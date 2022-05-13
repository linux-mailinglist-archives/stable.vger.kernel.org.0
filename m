Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A194E526BA9
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 22:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383203AbiEMUh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 16:37:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241145AbiEMUh6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 16:37:58 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2928C8CCD2
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:37:57 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i5so6565036ilv.0
        for <stable@vger.kernel.org>; Fri, 13 May 2022 13:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1mAXHhGt2+q3q7YPZbq4GuNPZRmrBrblgr5+4ptqYbM=;
        b=EZy7RWnf5MrDQtXqqwBK+0gwqiYh9dOfya+dffSVMMKgW84GboRoYWw9FAedvlq8bo
         fyxpJwLOVHgZiGm7T8akVxkgphOY7Ze7VnYAjaB3X6VqXGgFrsT6hnb9tv82ocCSYmjQ
         f5Z2Tn/SSMoQQbWyH496y7NdTfkwfVYv6MorU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1mAXHhGt2+q3q7YPZbq4GuNPZRmrBrblgr5+4ptqYbM=;
        b=Z5SNhr8h6dVlxEqUUZ0FYjb6zY/VZG2YjiR16YyVdpukDCqzBYNqSTPmXHAXjVlgYh
         11hFbsCtpN5smL3119q+YrvOMS2xGPSHcBt3zzLTUF+J58rE0FXRNPoEqy4zwtIiWSUT
         9b6ERhj1/IyV1SBgdxpC4/ItEr7W4sWuyN/TkHkpy0QhZelSexhqr2VuCkyB+y3e33Xy
         5MtLq1e/WBJY9/szE4j/Y621qp6P60BQWurINl2KptD1ThEDDTUfhLiBghlKSRiTkKX3
         fDFhkoRoocxXt7LgIBCrpO5Ld50M53kDEB42c+Zmzl+CUoKVJL/kCRIwlBWTYQPZyNtz
         lm4w==
X-Gm-Message-State: AOAM530mj0IZ8OfB3KudlV9gMP0p3ronT/kXr9i/bAeIXzmKpiaibTXq
        oqzuOzvpiGwO8FhZ2LRCQjlJgA==
X-Google-Smtp-Source: ABdhPJy7SZYLJKKcWDZAGzigP2fslGeDW0G2dHYT1oJT2sR4TpWOU5nfMgUABtXz6xXJ0FRLrx0FOg==
X-Received: by 2002:a05:6e02:8ae:b0:2c7:90a5:90b8 with SMTP id a14-20020a056e0208ae00b002c790a590b8mr3670961ilt.19.1652474276560;
        Fri, 13 May 2022 13:37:56 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id p15-20020a6b8d0f000000b0065a47e16f3fsm944453iod.17.2022.05.13.13.37.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 13:37:56 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/21] 5.15.40-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220513142229.874949670@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <ca76d742-b86e-e50d-a011-1353cd2e095c@linuxfoundation.org>
Date:   Fri, 13 May 2022 14:37:55 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220513142229.874949670@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/13/22 8:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.40 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.40-rc1.gz
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
