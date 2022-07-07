Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 242965696B4
	for <lists+stable@lfdr.de>; Thu,  7 Jul 2022 02:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbiGGADT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 20:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234622AbiGGADT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 20:03:19 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 965682D1E1
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 17:03:18 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id n9so5977945ilq.12
        for <stable@vger.kernel.org>; Wed, 06 Jul 2022 17:03:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pHY+rlhy7XAETynfllgOwshXSKWi6PJ+NgDnuwk5Hks=;
        b=f0O9/kYRDLEaXkzbZJWMzRWE52tXCi5ejtHLOvhaew4aSoV04j5sws/m5cKHadPtMR
         XrkxHx2qd4B2NtKhLmZ20YxRWVZB3EG1nxayXmDFu2uOLnW+EvTs+7B4DuIy06ySZeNL
         82XbaYtxgPAoGs5dVeblqfQ8Nsa+ANKlv5bxQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pHY+rlhy7XAETynfllgOwshXSKWi6PJ+NgDnuwk5Hks=;
        b=xvZMLPC0BjAKvrvsQsJahfYEBwpjcbz7gt7MMhas66FtY36HAMJV/jXBterLK76SCO
         g49iQ4vgRwwDXcAF/ftaAXerLE+Kc5tkT/GYFcdUrV2Z9IQYg5h1R/DDOydz4CBMGP9q
         LUPr9NiYV+LFC8jMlBg63YxmuU3YkwsWf1NMpWq0Y0LKrY05VXwGIvEeAUsWg2+/0a5E
         uI7TR/m54hci5RBCZsCvP1uP+RmXeiIRyzDX/Wy8UBWFZt/Rxi74Q2AA27IU+pQ7VdWy
         iSpcnqndHwrWHAhPL2YAYo4+yjJUeacjXNAUVtokNfnZjZXcIZq0LBdE+XGwI1wCxozh
         lx3Q==
X-Gm-Message-State: AJIora+Vqo+eQX/CmXwP1bnKhcgfODVUwKSyDdaMVipeNLEvZMmkxj3Q
        6N+2ldTuq0eDvMjGeO8YCNMUiQ==
X-Google-Smtp-Source: AGRyM1vcWGc8M412Jbos/h/8sSDbi52g/eKNCOJklynrU//Gg9TCr6WGlZxcc6eZywsRP25B4c32ZQ==
X-Received: by 2002:a05:6e02:12c2:b0:2da:c41e:5aa2 with SMTP id i2-20020a056e0212c200b002dac41e5aa2mr25283844ilm.57.1657152197945;
        Wed, 06 Jul 2022 17:03:17 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id bt6-20020a056638430600b0033c9beb0e19sm13026998jab.22.2022.07.06.17.03.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 Jul 2022 17:03:17 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/33] 4.19.251-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220705115606.709817198@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <0198934e-6160-2d5d-18e5-a3b7209b2e22@linuxfoundation.org>
Date:   Wed, 6 Jul 2022 18:03:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220705115606.709817198@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/5/22 5:57 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.251 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Jul 2022 11:55:56 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.251-rc1.gz
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
