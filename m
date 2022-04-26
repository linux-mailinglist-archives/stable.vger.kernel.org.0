Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98C73510A09
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:13:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354764AbiDZUQz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:16:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354749AbiDZUQy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:16:54 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBC01869D7
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:13:42 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r28so3114971iot.1
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IAIRf7wmDsqtTWP91Bh/6PLFaaR8oVKSXpRixKZukWE=;
        b=HjbCjDRpwInaHveCXL4TfXVTElo75iks9DT0sBEnzysNp5IWxXZU8e2QwZXM2Fbkne
         chq2U1esa5GQ5NyiOCwk354OYQuaJWyCeGXNlZPQTOUs4d5s431lWtesg7qp/+y27wGi
         7kX/WFTkztvvABEaakypQ26RycXmO5Qe/W4q8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IAIRf7wmDsqtTWP91Bh/6PLFaaR8oVKSXpRixKZukWE=;
        b=YMoBAb89EfkiavVG6C4I4ECPvyazNklaMrPk2JN0N0NnAcnj/gCwULTKKhvW7OZJzj
         +RRJJIOIm9A6wMWc4lJXK5ZvPyRt2JttYobz3T29eqd4WmNZ63USES8axrJSKpYIXpn5
         bsSiYOC3a22Qa+xFUyntCeMe0fC1AO5dPTJFFQIaJrUVy/UzOHysq7hCy/MWlRUz5P/m
         z+5LjgAYsli5/6S6JT4hDwyyvJl8ySFt1nIFWLr2br1qL95NXRttUWx//KvYeKEJ7tr2
         rRjyw7s5uaRVOjJWScCfciwv8Eq7l9hU3H1iYcFdpHNLxgPss+rZvC/nU1wXiypayb3P
         Ap6Q==
X-Gm-Message-State: AOAM531muF2TPIChyQ6nFKXgxjAKn5ix/Lp/gU3Mk1JXSSqTF1DJvT0b
        84msPmwx39zx0XGcezHlezuelA==
X-Google-Smtp-Source: ABdhPJy3KCpdjXhRKBJlZVPax9KVUARAcQZrZKKHfYftIz77ziSnpBa9U8G+en4tXdaNhGdRYfY1Bg==
X-Received: by 2002:a05:6638:25ca:b0:32a:f917:30ab with SMTP id u10-20020a05663825ca00b0032af91730abmr4167763jat.268.1651004021751;
        Tue, 26 Apr 2022 13:13:41 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id x2-20020a92d302000000b002c5fdff3087sm8494930ila.29.2022.04.26.13.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 13:13:41 -0700 (PDT)
Subject: Re: [PATCH 5.17 000/146] 5.17.5-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220426081750.051179617@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <669406b1-ca02-7a0d-68a1-240c2d814aba@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 14:13:39 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220426081750.051179617@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/26/22 2:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.5 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.17.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.17.y
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
