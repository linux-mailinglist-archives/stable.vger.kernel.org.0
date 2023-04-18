Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 515796E6E3A
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 23:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbjDRVaj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 17:30:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232827AbjDRVai (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 17:30:38 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B38118DE
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:30:09 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id ca18e2360f4ac-760f040ecccso9226939f.1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 14:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681853407; x=1684445407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gB8I+UhHhGOuAuHo5L3+nLu8vHWaqHmH76dNiolg8CM=;
        b=STaXyj8oWKeJj3jLpzIqHQCtJXp9rVIGTy0iRAEGPPoPgKd1Lj7V5OrnLdXgXjE9YS
         YeUIn+XqAGROG4QfhaL7YqVvJuJygCdnFTTji6fcM/JCrDp3GWdG4EshE9okzbHA49GT
         O1TNwY/ZJfMJ7i3rvNajNuCoDK4I676YCDr8U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681853407; x=1684445407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gB8I+UhHhGOuAuHo5L3+nLu8vHWaqHmH76dNiolg8CM=;
        b=M2aUuAwYHAYvlx7w/Tt1MiXfA3zbNOazZgqq+7XwseTzs+cfVsiaIWmrdp2EwTNOQT
         9BT0YtgtrVM0cPgvVqqWkCsQbjUIMHdrJXEu3iV4uJROlgcDll8KbeHNbUsPlq1gl7g9
         G9mOd59zeyJqwFfhkyv2VbTaQjOY0qm27Yi3KAuqKh5eV5hq5e5pBkJpYyzfN8uRfetT
         tjtsJrhxLWmg0P8XGxVfh5BNCiO9b3/sO6b2mCJNhwSThg4QVPKp89KP1xx9S6Yuw7fY
         OqvsdEf1zLBKTz0Z+3c3sXhHYtvYO5e5UsOKUWRW9LZHqqQQ5jXSTJSXHWSHMCRnLhF4
         5Kfg==
X-Gm-Message-State: AAQBX9eCN6n8BJMHgS7ERayxc7lva3VO9RRUb7wKV4KEP2P1MZNVNYen
        sdF4NQ1WsFs4XWDpCnQ6JjOCqQ==
X-Google-Smtp-Source: AKy350bOIzgxAQK8X8oz2VLS3hpE8SE0ooJ37N3oF6/ZAAktOf8CkVAUHY0StOovLU3EtEU2ly6QoQ==
X-Received: by 2002:a05:6602:360f:b0:763:6aab:9f3e with SMTP id bc15-20020a056602360f00b007636aab9f3emr1434483iob.1.1681853407439;
        Tue, 18 Apr 2023 14:30:07 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id f59-20020a0284c1000000b0040fb20d23a2sm967759jai.93.2023.04.18.14.30.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 14:30:07 -0700 (PDT)
Message-ID: <73dfe11d-d398-cdb0-3ee8-b9d8987afeb7@linuxfoundation.org>
Date:   Tue, 18 Apr 2023 15:30:06 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4.19 00/57] 4.19.281-rc1 review
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
References: <20230418120258.713853188@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/18/23 06:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.281 release.
> There are 57 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.281-rc1.gz
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
