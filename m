Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B5F60601600
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 20:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231130AbiJQSIZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 14:08:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230525AbiJQSIX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 14:08:23 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF7974BA3
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 11:08:22 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id n73so9745725iod.13
        for <stable@vger.kernel.org>; Mon, 17 Oct 2022 11:08:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d4TF7+Z1A8XeysBeXXZa3fUzVWa8MiYnq70t4PNHYyY=;
        b=WTXr8RL3himxuY9YvNiHGoTkuXHR+d/op/hA25RYgpdWAM+hq+P2kWcebEKCTs5vHA
         1WLK8rgPDE1Hku6qGcmRaE0aJJgIPI7DWRflPuLHR5Jzczo7n/0COYUGpbPy9OSrWBRj
         bY/UIZj02+OBKp2qwCdEDF4aFrYusIB/EPIXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d4TF7+Z1A8XeysBeXXZa3fUzVWa8MiYnq70t4PNHYyY=;
        b=n9Uj7wnL1Gz+kFLwMyh5ofAMy3YF9uh8ndqnr8TMO6iSGb5eo8zLT3xRqCgDfGUZeR
         5g8t6da3WlF5Iug/oeEHl4UeE+KX1ljFFUYC/UuZq85y2SXaV21EETrDMV4HKlWEBqf4
         TaAG5BTxPaKMcsMy3eatgjkhXV+2SQrxOWKtWUJHvARlkxMmQi9lDB/Oc2bHSQZzGlAV
         DjbwBEfhQcRHTgPgSBQMHvN9t1Gyd7YiZt2Ce9nYa4R/oh9d3g8zER61AwqsqhgoB99B
         b73V3Ly1DakfaTduqjiehZ3S4ZTvCHv4YjTmYX8Rk4AZCSZlA15eHtu7xNXj5CL6yT3p
         huAw==
X-Gm-Message-State: ACrzQf352qY8cQbNIF7cRDOoywOKrRHA0Q4AKmto6Uju+S3xvPGmJy5l
        uJnIgyt4/+tA5hCvf8MhUWD+wg==
X-Google-Smtp-Source: AMsMyM7OMOAQNLhRI4M5flG2+tdv2ZV9CDUkt700Xd1YKQlzJMqjKE7DI/5B0e3TNZy7o1w0E8G9CQ==
X-Received: by 2002:a05:6638:148d:b0:363:f28c:61a0 with SMTP id j13-20020a056638148d00b00363f28c61a0mr6174831jak.268.1666030101344;
        Mon, 17 Oct 2022 11:08:21 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r12-20020a02c84c000000b0035a9b0050easm188105jao.18.2022.10.17.11.08.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Oct 2022 11:08:20 -0700 (PDT)
Message-ID: <0690ec36-7315-a8ca-a6d0-921a61c66c05@linuxfoundation.org>
Date:   Mon, 17 Oct 2022 12:08:19 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221016064454.382206984@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/16/22 00:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.149-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
