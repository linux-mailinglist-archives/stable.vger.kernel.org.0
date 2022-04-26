Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43A28510A10
	for <lists+stable@lfdr.de>; Tue, 26 Apr 2022 22:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242013AbiDZURT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Apr 2022 16:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354295AbiDZURR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Apr 2022 16:17:17 -0400
Received: from mail-io1-xd34.google.com (mail-io1-xd34.google.com [IPv6:2607:f8b0:4864:20::d34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BA48187B78
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:14:08 -0700 (PDT)
Received: by mail-io1-xd34.google.com with SMTP id m13so8251189iob.4
        for <stable@vger.kernel.org>; Tue, 26 Apr 2022 13:14:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=abgy5fRKq9r2YU6bCVGzHdkj9O0LUE9XrxLObfY5iAA=;
        b=T7zk67gE5JfB4KU5fLOxaF1QFOpanhJnC77V1pFGFIu8Jlw4RxTUXWsgS4TLeSZmYJ
         hI7Wl0Vr71BzR2oJMkL6rhlcPCDs+rh/ODxrQrXSUPsWuZ0Nq1Fmc1wYHfDXONIdKpAn
         OSMgUk+xXTphdoEfvEZuOO81YuTdWg7++eZOw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=abgy5fRKq9r2YU6bCVGzHdkj9O0LUE9XrxLObfY5iAA=;
        b=o7xsqCHFYHwsoWvO8i7KTlej1OEVAQLifBMJgGoocV5qXQwiBUWo459ZmrEx9X9noV
         SdlCykdCOhFnJtiZi5g5hlbd6mPWCq6+7yvZ6eZaB/+pAZ0cSEMXqlFUBgW0tOs8y2qJ
         2hoqSfmMh+ZoMc4ogAPBl6xjeAEFq6bqsJ5J68aWKX+sZR+GcRECF5ZP02eXNDiAr5Lt
         tthmPYbUxg52Gx9Xge/VUH8DmU4z+fjtjHQrfUtZry5cwM2Mw7HlsStufAFVzBhtxMZp
         mQG2UyOi74NZwiVIgV3LiI37Z1sFb75DF9Lq/mUm6hfHdQlcB8KqmXP3CMND/ZcTKpsM
         1vVw==
X-Gm-Message-State: AOAM533Bu7EWDLs+rGS7MWxvlUbmMWEd4uwF/8n36EAR2HVxndX9uvRF
        8WmWZF0pVyM31gGoYmescNZkTw==
X-Google-Smtp-Source: ABdhPJwJQZkvDEw68T5ZCUeqXK7jL07nM0ghfdZ5wIyBNXZabgm3oDJ9ZJfM6o5B+Ltrnp73wsr7yg==
X-Received: by 2002:a05:6638:2195:b0:31a:8815:f0c0 with SMTP id s21-20020a056638219500b0031a8815f0c0mr10530093jaj.301.1651004047624;
        Tue, 26 Apr 2022 13:14:07 -0700 (PDT)
Received: from [192.168.1.128] ([71.205.29.0])
        by smtp.gmail.com with ESMTPSA id b11-20020a6be70b000000b00654b3a46b5esm9811498ioh.53.2022.04.26.13.14.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Apr 2022 13:14:07 -0700 (PDT)
Subject: Re: [PATCH 5.15 000/124] 5.15.36-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220426081747.286685339@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <2f8a0edc-01b4-3ea8-eabd-9646ca73ad18@linuxfoundation.org>
Date:   Tue, 26 Apr 2022 14:14:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220426081747.286685339@linuxfoundation.org>
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

On 4/26/22 2:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.36 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Apr 2022 08:17:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.36-rc1.gz
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
