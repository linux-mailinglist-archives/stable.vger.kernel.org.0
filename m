Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7044E3430
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:25:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233115AbiCUX0q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:26:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233213AbiCUX0e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:26:34 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B2CA37490D
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:21:25 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id z7so18547394iom.1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rfhdkicib0U/85KHEI2dlAxTiISoo2Wo3fR7SPHcWtw=;
        b=PxvV9pU628OdzWF5D3My9VeG9CcuSrs5mHcrTuv+N6K/weEXCD29bawMR5B1gGnsrj
         Y0yDUcL2CF2JsVIcFiCYCcQtiLa92fcCTXjBCeuQshDoI66ogpwSx4AYtklx7PsZhqry
         SLI4HzTwBu6UQjEwG+fL9oaaBCmnW+ObhRTC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rfhdkicib0U/85KHEI2dlAxTiISoo2Wo3fR7SPHcWtw=;
        b=5XDu7AFnHisVBy6dIDKQi4nrSBjtic0aV16DbBLUZsEnq4yaEmyoJZ8JiJPagxB4Bd
         EevavkrSBxhLbLuGwwqedVUMEu8iqo/u9bRNIGs0zNmp0sZ3vVp0mhgNs7zfvyXrXbbb
         ZhWTaY5xjnpthRoNeExnMn/Eq5y/EX3ud4ABL8IX6OhzChPml2zWQRlMKdOJu9uQcNQz
         YEFSWB/l4rRhWMqQAu1jvDJTAtLuuvjAP64EktLCteSJBANZrDPiqfIWzh5vO8lV3t8W
         SlwePe0wyH4o7THEMcSbX6eEVR8x9L72wimbje88yVRWexrex8250995drP7dc+vjGaG
         lmvQ==
X-Gm-Message-State: AOAM532I9nMrj1mheauGExtKPfHhFiuCsT+O/zIg8HLE0kv4WcTvNdg0
        iW/FGKABm5bZfUoACy177GyBVQ==
X-Google-Smtp-Source: ABdhPJwsJ7rLpryy+dyOPLoPKx2AaqcLjGpVmMRJ/Eeu6GNxHWNGIfT8AqzF1RDGQI85KGtX4QdcCQ==
X-Received: by 2002:a02:a081:0:b0:317:b141:29ca with SMTP id g1-20020a02a081000000b00317b14129camr10965627jah.275.1647904884418;
        Mon, 21 Mar 2022 16:21:24 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id v1-20020a92d241000000b002c82ba9d58esm2267499ilg.9.2022.03.21.16.21.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 16:21:24 -0700 (PDT)
Subject: Re: [PATCH 5.16 00/37] 5.16.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220321133221.290173884@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <06751c62-015e-e269-3644-8ef7eaacc941@linuxfoundation.org>
Date:   Mon, 21 Mar 2022 17:21:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
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

On 3/21/22 7:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
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
