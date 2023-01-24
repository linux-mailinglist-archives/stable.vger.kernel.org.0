Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6337F678D1D
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 02:05:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231493AbjAXBFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 20:05:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAXBFv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 20:05:51 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08226303C8
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 17:05:51 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id h15so6543237ilh.4
        for <stable@vger.kernel.org>; Mon, 23 Jan 2023 17:05:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s93ZKJi/eyAuvTHK5GSRYNYk2jtuLDZoKO9TCFwwVLQ=;
        b=Fg+kpPe+pheuW1fV4nyazNl4T2zPM0uBxI/8MU8sMc0Tq0v9TuEyQ1l6KUxXZW+pr8
         KLY2Xmir95LDiU57+//hr4EfiuEZeVpIYsRKRwV6VNQ8Dw8YAXhlbHXZ+sCj4qe1GKeJ
         6AdmbRXMVrR3NidbR9kVTigJY1KrhSaRuFKBo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s93ZKJi/eyAuvTHK5GSRYNYk2jtuLDZoKO9TCFwwVLQ=;
        b=BhpY/v3GF1MT0J59326XnZ8zJu3izgaMvbXLKdDWK7laEqZjwpvO5YVp84vzb94hPB
         CbJPzG/KssNN8dsAzQAqgMsOHnDhOQOAMQRjB82QGyFXNPLBV+/bmtiJCXPbgVB9P76C
         f+/Cc6sVcdoS6+ynktITlJ87kTdKL4ZcO3c8uXVZu/udyulVoDsH49rSgw/muoDNeNpp
         R4y3ZBu52ubrG+d1+fIodV0w4LeqE1qD6aKzD9C8Q9PU15HmDaew91mkhsmk16DjOj00
         d9vE+/qTfbmTZlfAPZZKoGU9tJKWHsfs0NTkQ+gMVvAgkDjpSrjCvw0jx5gN8nFz52T7
         0JIg==
X-Gm-Message-State: AO0yUKVFNVJ7ADYR2/nPIS4gG9UxgBzKmLOzcJt8GXz48024HvCYFIj4
        ezfUUJQUw0t2fsUw/riAdQWxtQ==
X-Google-Smtp-Source: AK7set/40nqpQdiITXp6tF4Med5qx27LNaaTtVfCmd0pU4hd5Ibomho1jstcrmf9F/fBrhsUMyudrA==
X-Received: by 2002:a05:6e02:1184:b0:30f:a889:2145 with SMTP id y4-20020a056e02118400b0030fa8892145mr207150ili.2.1674522350241;
        Mon, 23 Jan 2023 17:05:50 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ce21-20020a0566381a9500b003a484df1652sm223150jab.55.2023.01.23.17.05.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 17:05:49 -0800 (PST)
Message-ID: <6570e849-aedd-245f-163c-208a9bdfaf9d@linuxfoundation.org>
Date:   Mon, 23 Jan 2023 18:05:48 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
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
References: <20230123094918.977276664@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/23/23 02:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
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
