Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ECFF65171E
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 01:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232541AbiLTATM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 19:19:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiLTATJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 19:19:09 -0500
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B07651581C
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 16:19:06 -0800 (PST)
Received: by mail-io1-xd2f.google.com with SMTP id q190so5600814iod.10
        for <stable@vger.kernel.org>; Mon, 19 Dec 2022 16:19:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gc3hWzYWnwxE0KxM3PiNn4ggv+l8ysEvnTXP4M8gEZQ=;
        b=YcWERSawby9HLFUaDofFiqJzjtWuQQAV8Bl+fepedaQ1d9EZ70C9z8QkDjUBQB+PNU
         VZC4qDjIwalMd7bTkNNCQz7SrhRiptA87TzW1AfI2UsfgeqDuZ1nlUkuIOsvqYngyXyt
         5idFkzqWLBbDopUyg5fYV4Ych4BjZgtXS+VNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gc3hWzYWnwxE0KxM3PiNn4ggv+l8ysEvnTXP4M8gEZQ=;
        b=TNSklG/GMx6LDqKZhNMFumcHdwpBRBd0HprebGYCo37IapYWs0p0IXWF0YFtEFJ3rY
         0Zj3jtPfo1clKAvKNkXSkj02yjJwuKpGYDZAo6I80kRnesuNYWe+kFCIlKqFmAKiQgnV
         /e3PAy4oN2pkWhf+m4X/8VeOK0dPKc7vB6IeedIYqHCi1K8NHC971S2f4sNjMKgoNTPS
         kBEHf8fUJInHbz4KSWVQ76+p2YV+sZLPDJ7zJ19N4UR+5Sg4ZyMiqt+KZaSwYwOH3uW5
         gpvSkJ7pE40bq8+/rQb9eU5zufbU2jq+70q49X8p84yoZ3ri9ZE5ZEvMKg/Fecj42LIv
         E4Tw==
X-Gm-Message-State: ANoB5pmml7r4gz51YHc7kkBGUfKKoIik7AjhKeMoKxVJ7lDw7tjCQnTI
        wWvejYflK83HbVxswosMt8Y4gw==
X-Google-Smtp-Source: AA0mqf6R8XlJpG3NHFCje5qyDPzOlJZOb1SXv7X2p+7WpO9xBGKQIDDqaHDJbW/l5NpYWHcWNYbyXw==
X-Received: by 2002:a6b:500e:0:b0:6e2:d3f7:3b60 with SMTP id e14-20020a6b500e000000b006e2d3f73b60mr4534593iob.2.1671495546007;
        Mon, 19 Dec 2022 16:19:06 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r2-20020a028802000000b0038a5b8d79basm3984074jai.106.2022.12.19.16.19.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:19:05 -0800 (PST)
Message-ID: <74cad41d-e088-f8c3-3bda-d9e2843ae9f2@linuxfoundation.org>
Date:   Mon, 19 Dec 2022 17:19:04 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20221219182940.739981110@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 12:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.85-rc1.gz
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
