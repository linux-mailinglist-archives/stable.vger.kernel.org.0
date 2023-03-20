Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D7946C2566
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 00:06:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjCTXGN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 19:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCTXGM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 19:06:12 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A14934C15
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:05:49 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id s7so7303273ilv.12
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 16:05:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1679353549;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=KwJX4b+VPStuq284oz9cB+/Udp1QkSmbOh4T1cpR4pg=;
        b=CQQhyhzxFqeKEC8ObG77F4cyUsoPaWdJ+AO9fw9JujjKmlm9DQt9/DFZk7mp3y6t0Q
         17H5HCqlTMi+CCkfYaXyB0oh2DAMhbh64g78gKzJNcQ1yOLLqu0ggWagu9IKTvXZgNzw
         vzDmp6/MeVb2jowwPp6ox7eA0Y0Fke6GjcHYk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679353549;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=KwJX4b+VPStuq284oz9cB+/Udp1QkSmbOh4T1cpR4pg=;
        b=8ApJ8N6afrZT7+HFo1jRMQIcAxYCJjbZrxlXgHxxVW3quEl3Bebox3QhE6RJU0zRW3
         FIkExmz3UTUkiEYgXMXfmU5AbYiYBGi97bBsgZN/P4r8jyEOoPJREBbPzGoEN+PwBmut
         wCiruZoyePXNvN4RAgNg7JB/hlNu6jnYmQM2KxLG3JpP12WL3S/ChmGsyCeJGVvqUgFN
         EpshIPZORle7KfunPpo59jFRSv0R7Vh4ZXh1QWeIdgI85nJ3EI3vyyQ/Yj6knI22aRI5
         QSZZBKDJ5swiC0bRtbDZRe36QQA40gNZ/sq4OMdcSKUSKmT16s50Gv2NTdZ3ZfIZ36HD
         lvjA==
X-Gm-Message-State: AO0yUKV1awPrAFRPVftGX63E0vgpNrHhO/m1bLThi46BSXOMe0tRIMOH
        8lyxnuq2sNUg5q/g+0Up0Eo1dA==
X-Google-Smtp-Source: AK7set+OCd+B5gc9ajXw1DDPfyi7WoLhrSHDcnF2ZsZfQucYQURr55VjtxQuikn+AYFRrV+b76DTwg==
X-Received: by 2002:a05:6e02:16cd:b0:317:9d16:e6c7 with SMTP id 13-20020a056e0216cd00b003179d16e6c7mr793903ilx.3.1679353548872;
        Mon, 20 Mar 2023 16:05:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id o3-20020a056e02114300b003158e48f1e9sm3131882ill.60.2023.03.20.16.05.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 16:05:48 -0700 (PDT)
Message-ID: <2a7a841c-0f5b-9227-0014-fe40afd925f7@linuxfoundation.org>
Date:   Mon, 20 Mar 2023 17:05:47 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
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
References: <20230320145449.336983711@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/20/23 08:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
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
