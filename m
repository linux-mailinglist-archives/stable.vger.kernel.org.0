Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D60C4571041
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 04:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230234AbiGLCgD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 22:36:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbiGLCgB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 22:36:01 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 722028AED1
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:36:00 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id z81so6713991iof.0
        for <stable@vger.kernel.org>; Mon, 11 Jul 2022 19:36:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6dStcjUawOzmeYedfzMYHwAovV8lFwvzlevqMQneF8w=;
        b=H/49HHk54cGMt4RLpQc5tm3hRsKbNBqABxLfolfp58ETP8Jp2sy6AdQNiYBDRp9Xl4
         jqowebDfqJZdUd67DAUaWE1SZ4kntGheP2agODKwVN4NPLsRG+NnrBhNJ3jiDzU7rHE9
         jcNQ92rsVYpEe9TcDIULMmCoOR/wLAOy//4Ew=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6dStcjUawOzmeYedfzMYHwAovV8lFwvzlevqMQneF8w=;
        b=U4oL+UF7FZQTQ5P0uRN1+FgcEHtMGrMm6TTi8ZpeXHj6WV8Do4ehN4eFekUCxYEbq0
         uGeUsZnL1nODTz0tqwneJ3GRlZEm2JgTBkSlVDvVPksh2JXZE7wPyMLTbf+17BmOJ45H
         Q+YFjoBY13SSXnl4bjP45+WNvpxhO6EIk226+vIWOmqloo3hOUqNZT/roytpMgFZ7IiM
         mWXPdgPXOb2fmi6CfNc7vTpZ4iEuLmICa+v5QVsRaOq6ZKISyEjCessPD8mJSiCsk2Hg
         FF9xpZ+scJpOmqV/0GhckkPxsi6NuvjZwxSuXRWAQfKSnvzPq/0F/ZvJRMqa7VhdS9hl
         j3Rg==
X-Gm-Message-State: AJIora8/7CZxKg7ZeWlPc4OdS94TPhok/zzipP7T7uXTtdbw108cK0xD
        XaWj6tq48CkKsiR8iDuLtnYJqA==
X-Google-Smtp-Source: AGRyM1uLrsNcwBh8mrH0rbufFEmJNnJzhcjJRZvngWI8pJsNdT8kszZBbb3CW7vwWBAu+u68YXb8QA==
X-Received: by 2002:a05:6638:4194:b0:33f:4795:5c68 with SMTP id az20-20020a056638419400b0033f47955c68mr6776493jab.193.1657593359874;
        Mon, 11 Jul 2022 19:35:59 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r2-20020a02b102000000b00339d892cc89sm3625256jah.83.2022.07.11.19.35.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 19:35:59 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/229] 5.15.54-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220711145306.494277196@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <48af6096-f587-74b3-6365-c650c99bb555@linuxfoundation.org>
Date:   Mon, 11 Jul 2022 20:35:58 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220711145306.494277196@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/11/22 8:54 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.54 release.
> There are 229 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 14:51:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.54-rc2.gz
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
