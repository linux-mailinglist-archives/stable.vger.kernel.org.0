Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27F9968A759
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 01:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232774AbjBDAzp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 19:55:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231654AbjBDAzp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 19:55:45 -0500
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C5A39E9D6
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 16:55:44 -0800 (PST)
Received: by mail-il1-x12e.google.com with SMTP id k17so38508ilq.12
        for <stable@vger.kernel.org>; Fri, 03 Feb 2023 16:55:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0pGOmD8iOI8HzwsY4SW9Fn2GAWMZfMvtWAKvd+ESNNg=;
        b=UBeG1iP/p20mEMf6AW4qQrHb3dgSXelmFPpyEWBBc22fYrnLuWN9tSk7FUQw965Iqt
         JWlm2CQXAxspSwPaAFxT6EL193tw3FefP+qLX5Kn/9UVCdSGXSxkVVfBqOAYj9Sa/+qC
         tiouERz/4hWM2dbWLO/Ucu7JU2/DtaZVE0VjI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0pGOmD8iOI8HzwsY4SW9Fn2GAWMZfMvtWAKvd+ESNNg=;
        b=P8qFgNAPqeHl5vwntAKl4473NWRFeAX5qA/cR7dI7Z4IBBUN6TtWkZtnNCIiF8MIaz
         m5DemXMjdsLVzlv4JQ5Ove15ItKQvdu3eW4/savAKI00MrlMQNDnq6ZTfhOqPcZN+C3w
         dIEf5iONRmLK0+lTwOjD52gAFzJrwz3Gzxus9N9CAt9t7Iiy7j4zez104iFuxwACJGCn
         fZFNU2rq7L2FJNzs0Wj3eSHMJh7qf3+jYW/19hSR9dWkzfvnLcgoGw7bxGw3XraGCMhA
         UpFrD63sn8XxV6MzG+E0uLku5fnVoVIdXisN5HLxamSE78efueDXtQvhtIuBsR+kXGtX
         aOyg==
X-Gm-Message-State: AO0yUKVAZjEljWAjFiQaCxnQRg+NMsuQIQoBkH20e1+ZhJwgX6kiYYZO
        Rmxhds/CBxcshmiMgM7aI5RJGw==
X-Google-Smtp-Source: AK7set/Hf/NYzhVNqxYJuB4Wqt3JA9vNvTCYKWTCwV4HUaPrzsbOxWMVVaUsfJnZHx5AlsR/jSdTvQ==
X-Received: by 2002:a05:6e02:110f:b0:30e:f89b:6652 with SMTP id u15-20020a056e02110f00b0030ef89b6652mr5836124ilk.0.1675472143182;
        Fri, 03 Feb 2023 16:55:43 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y12-20020a056e021bec00b0030f46602063sm1243053ilv.2.2023.02.03.16.55.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Feb 2023 16:55:42 -0800 (PST)
Message-ID: <2cde807a-7661-6311-ed96-7b510f286319@linuxfoundation.org>
Date:   Fri, 3 Feb 2023 17:55:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 0/9] 5.10.167-rc1 review
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
References: <20230203101006.422534094@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230203101006.422534094@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/3/23 03:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.167 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.167-rc1.gz
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

