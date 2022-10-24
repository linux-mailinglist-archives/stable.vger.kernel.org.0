Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05B2760BD94
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230469AbiJXWkJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:40:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbiJXWjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:39:43 -0400
Received: from mail-io1-xd2b.google.com (mail-io1-xd2b.google.com [IPv6:2607:f8b0:4864:20::d2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB101AA24B
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:03:27 -0700 (PDT)
Received: by mail-io1-xd2b.google.com with SMTP id d142so8777760iof.7
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:03:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sKryykcG5gZ39R1yufMDTzo/98b0P0/5aNXJDHrylrw=;
        b=SzO2wQL0oSGw7FFXBqDUbD/PqHJolN39gNyqgxkSheSChI8kh++o3bBmLH5zbAZL2+
         AVJJ0EDcx0GSrJf3AHcvjDgrgFWDWsLkNiNZjH2aXmeHju0zTvPL/3wGzEh5a9I+yNct
         ORj0S5m/S0zY4qLdoYQ/Ktb89iG6Km3Wjlwr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sKryykcG5gZ39R1yufMDTzo/98b0P0/5aNXJDHrylrw=;
        b=QR3y2HUocjebq2NO4HcdLLTvdO3IXP3Orc+/5xxvCw60TxSMXSKgzTlmyVnJt0NEGb
         MbTnUIWHikF3As4BOzywm6gghWFMW98KZyKyrqb9R7wnHqIgfCo2cLpbpdP8FzKIjr1Z
         msLTy1Q5ol4hsyIGgZMB7rP+Ne6SDQMdwJb9rxMIBCExphX8uEJRMQKT3JOhQqkQKXZs
         CZXEEUZxOgGmsRx5dbs3cdQneiiZzZjMr/oYziva3L31ZjGwS3WuNN61BEu1SjMn6zms
         SxoVzgsBsVMdlplAUORqk4uX9NcupP3KhimKnjdMakPjHzuqlGaWvmpgc/dvnXnZzpQn
         ANlw==
X-Gm-Message-State: ACrzQf1hnI7QMJEHBQlZzOwJOQHIAYWs8nc3oW/hYKzdPowBZFv2JqY8
        bwWnlDstbIDV6XZY3RCH1j9K1g==
X-Google-Smtp-Source: AMsMyM70jS8bdoPmXdZIvX5yBIDCDMV1JGx4zRtAKCXI/UWbc+dfxBO1WlDZzwWs5OtL/9NqZL9mCw==
X-Received: by 2002:a05:6638:2494:b0:363:db50:7655 with SMTP id x20-20020a056638249400b00363db507655mr24341322jat.76.1666645328581;
        Mon, 24 Oct 2022 14:02:08 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id v5-20020a92cd45000000b002f1a7929d67sm322292ilq.72.2022.10.24.14.02.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Oct 2022 14:02:07 -0700 (PDT)
Message-ID: <8db28337-ce04-99a6-40c0-9b5edfca7385@linuxfoundation.org>
Date:   Mon, 24 Oct 2022 15:02:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.15 000/530] 5.15.75-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/24/22 05:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.75 release.
> There are 530 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Oct 2022 11:29:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.75-rc1.gz
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
