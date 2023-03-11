Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3D406B57B1
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 03:05:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbjCKCFo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 21:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229655AbjCKCFm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 21:05:42 -0500
Received: from mail-il1-x12d.google.com (mail-il1-x12d.google.com [IPv6:2607:f8b0:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2429142DFC
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 18:05:41 -0800 (PST)
Received: by mail-il1-x12d.google.com with SMTP id y9so4085077ill.3
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 18:05:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678500341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUthFU/x3amSOzypKTrD2gVEBI2imuppYYPDhIEirzA=;
        b=E3dpNBsUziGq4vwTAQRWdoT0OG2Ym6oUke+3ulKaQ2pxUjoQOEZrFYWK0UUxF+t9jz
         l3fuxqfBjkpZFkRQkK81FJR7cpZaf1soAwUY3uv89+TWfqTf11aY/SAUqzWxQfIm8ABM
         XfnlIn+jk6y+K3B2hDdb6pSyi8IxOwmb18ym0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678500341;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hUthFU/x3amSOzypKTrD2gVEBI2imuppYYPDhIEirzA=;
        b=MHjmNmMgt9Vk4k0CoBgkTtveBC+ForxcMn6xzT0fPTwdUFY/R9TcoBbOibb4vYMYyC
         3udX2LIJ5wqQecJZVZybCgayxqs4SKwTTI9cZac/QDwJOWD/6qzRVtIvL/KgUnYTiFR2
         NxRMGy49WgPhVtyRqMev8OY2lPM+gitzWdqhFcSdOeHqh0ec59bnAPvCvb1yDaGsyurI
         nLXjJf6gSpa3/2OyAysVi++AbnYsi5a3Hv9RJcghnFxCHuSTxiH5Z5QqegoFSQe1CTK+
         1Gw2vQ35a+fJ7NzeVGDJ8sRfKc51B8g74B7iMiz8c2Lx+UPyniFIXGJhmeJuo6Vs5axa
         ptyA==
X-Gm-Message-State: AO0yUKWi4b29x85R7p6V1IYBMTZvZ8yLQgerXA499tNcU6yhSX34Oist
        d3pEw62hk0x9iyfL4PAYVozT9Q==
X-Google-Smtp-Source: AK7set9G3bdapXBs2La7WWwmdEHcBJmTVLiAned0+h7dNql8Zi0bGVzBnDZObTrNNAiHc63hwGkhgw==
X-Received: by 2002:a92:d704:0:b0:317:943c:2280 with SMTP id m4-20020a92d704000000b00317943c2280mr2370619iln.0.1678500341309;
        Fri, 10 Mar 2023 18:05:41 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id y8-20020a02ce88000000b003f8765183cesm474399jaq.87.2023.03.10.18.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 18:05:40 -0800 (PST)
Message-ID: <1837c3ab-3136-463b-c379-43c1dd8b71c9@linuxfoundation.org>
Date:   Fri, 10 Mar 2023 19:05:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
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
References: <20230310133733.973883071@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/10/23 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
