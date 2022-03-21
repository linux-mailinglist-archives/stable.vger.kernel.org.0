Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04A604E3441
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:28:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232816AbiCUX2p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:28:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232946AbiCUX2j (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:28:39 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07ED772E0F
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:25:30 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id e18so2454291ilr.2
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:25:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0Z9hf47FCUhB4Ed21Dfbu3ZNH8whXBtGYD4rATeAyNk=;
        b=B1eFzCx+Zi6fcOFpcxakEt7lV9tMpboo4o/CZNHZ6kv3UYDS+vAZ0mos2FvCgbJP3+
         /ozp9ilzqahy47hLxE75A7H0lQzL33rzczHa3HCJiKdfjbvScZ87ONgU1O6TnSkOiJr1
         4Gdx9/HlYzTar5EBnqZh4xBQ8JQ9xihu25JDk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0Z9hf47FCUhB4Ed21Dfbu3ZNH8whXBtGYD4rATeAyNk=;
        b=1iT9WZUv/bj1GM8Qi5CUaqL3SiYOHxG6iaRsrZDM8pez9HVZ7rto7TJc6mQ1UGVznu
         r3nSN16Gl8vgy4KlDUL+wlusTGMci499Sfxi2zPRErFn/1GrGNs8bm8uZ6u8jSgA/BY6
         LySlOakpDvI1gVzYgNY/8C8SFM9WkcBOiQFSFkqmt4FqIJpbhGrETFMQaDjKoyhZqGco
         S9B5fmk+4edBBSN4AMyO8FMeHa1iRHO1YCJPqb+IGqy/UHpa5xgIux6gPnXj6ZhOspJB
         4jALqDGBrlqsH59j6I3fICtsPdaAGHAkZlJRVnrMCCQaPYlx2XoO62LieVK2gaI61+hT
         1Ggw==
X-Gm-Message-State: AOAM533FMZ1+Ih8wxfZC7qUr7QF7qGVEUoVMjx0SKPfUqEq9MLA6RLdK
        G5fpCt4LROmtIfKv+RBH+mVYqA==
X-Google-Smtp-Source: ABdhPJxP0FtXW11lI7XRojVqhv/vPGGed7Auyf4UKsOUwX4+7rcjmTuhOJa+zIuUl7sCWJuP36gxjw==
X-Received: by 2002:a92:d1c9:0:b0:2c7:e18d:ff42 with SMTP id u9-20020a92d1c9000000b002c7e18dff42mr10667097ilg.63.1647905129958;
        Mon, 21 Mar 2022 16:25:29 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id k1-20020a056e021a8100b002c64cf94399sm10579857ilv.44.2022.03.21.16.25.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:25:29 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/16] 4.9.308-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220321133216.648316863@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6ee12bd1-7791-5b2f-6ce7-fc788a2b6cb5@linuxfoundation.org>
Date:   Mon, 21 Mar 2022 17:25:28 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220321133216.648316863@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/21/22 7:51 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.308 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.308-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
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
