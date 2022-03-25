Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75A374E7C27
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 01:21:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiCYXZ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 19:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234134AbiCYXZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 19:25:25 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CBDF344F2
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:23:50 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id i1so6208048ila.0
        for <stable@vger.kernel.org>; Fri, 25 Mar 2022 16:23:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=E0Za359ReI0RRBjVwPJRtdWCaWLOO+OOZnvlhNziPCw=;
        b=UXrSMVMUDKIuMKmJmFgCJWo3lzBLy6HvmXPsiemRIsOuGpF9NdgCUCw+nWWT/3u9r3
         RuGVv+GavkLXPGVEKxyh1VU8lV3vGo+mEl9lHv9ybetjo1MD1IlCifV8xgnzSiS/vMxL
         8WKP/7nJkLqTPH2ukJq+QcII7pgVR+AwNpFlc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=E0Za359ReI0RRBjVwPJRtdWCaWLOO+OOZnvlhNziPCw=;
        b=prZKQ5xlAGB7kefXDNJsRkVbS6RFTI51/AJt4dlcDWfWyoHprdUYrb0UaNLQbDheNB
         xcEXpHtVZP7YOez1++CkDgZp5hvO+pvlQdtwneyi9fjD8wOYudYfGDNFo4QZTUlok+17
         JDBfoXCzuCkXjRe7SRF9ucACsJSXlt/NAijptPKF48eBdWTz+9wqOxFKPR9Dmr/n0lqP
         Zn7Nb+OXWWlK1kmaJQb2IAPuH+N9kCK9NUOsmvhUmbzLvoasfpqllGZIuW+G2p119LhO
         gcsRUfR3h00IXEbDWMQj5hYgJMcZr35tTWqNQFL7GJzhdbDVZgAUI0yY2RjEKeOKRsGw
         GyQg==
X-Gm-Message-State: AOAM530hJtGZLAZthi9PrfZNZkvA9/oRCckky5HB7B7rQyHUh2YDPjhU
        EnL+bqb8Za0wftGQNI/CCYndFQ==
X-Google-Smtp-Source: ABdhPJzCBBQFjHqCq6oVZenMyKokfGse4//snHJiLCxuBt9AEYnyUkFpMoIKdVIkJyCeQViwbiA0tw==
X-Received: by 2002:a05:6e02:190a:b0:2c8:e23:27ad with SMTP id w10-20020a056e02190a00b002c80e2327admr616882ilu.142.1648250629754;
        Fri, 25 Mar 2022 16:23:49 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id t7-20020a5e9907000000b00649d6bd1ec5sm3652484ioj.31.2022.03.25.16.23.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 16:23:49 -0700 (PDT)
Subject: Re: [PATCH 5.15 00/37] 5.15.32-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220325150419.931802116@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <30d7a9d8-41ce-e331-787c-23c358ee7a89@linuxfoundation.org>
Date:   Fri, 25 Mar 2022 17:23:48 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220325150419.931802116@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/25/22 9:14 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.32 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 27 Mar 2022 15:04:08 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.32-rc1.gz
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
