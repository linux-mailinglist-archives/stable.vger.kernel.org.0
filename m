Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3FF5297EF
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 05:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233495AbiEQDZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 23:25:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233454AbiEQDZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 23:25:16 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0245539;
        Mon, 16 May 2022 20:25:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id nk9-20020a17090b194900b001df2fcdc165so1255389pjb.0;
        Mon, 16 May 2022 20:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=nB6jgOd/J/xUjMRjA6sPWneaJIXIlrqm192YJ0L32WM=;
        b=fXAxASUYI64DNbhYNhST8qNUkz9LxbvVnSuoxlfM01/iAoVv7ZutcIJSpvZTc1qf/v
         L4A1GMAl94OunjE7NznwPa6dUIbyoQ9f4RZJRk4DwJBPi8rQd+kHftytIbaFlT3m1URv
         vxz6pnmgRAhPGhdIRGOUNS4zaxf3PDdpuIeMMUePOqMK19CxCkFnBycgfLVTBkRFnU22
         YH+SH6/ZKmRTHfZQVi4snKLlHb3hN13sKCa2be0EssipTJihgKJlmOmfi1+CVuF63pG/
         6azy5Tb13qUGgJg1jlTp2T7tkB0Y4ElXkTXRZh9dqcyOoa0f6Bda4z49UPVmqEhAsWsJ
         vVVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=nB6jgOd/J/xUjMRjA6sPWneaJIXIlrqm192YJ0L32WM=;
        b=uZKpWplFu5IRnLcvXg/jv/egNmZzjyrh1gQRfoxmYdlBt9A8fKngRsqpCHm/CNP9Rf
         c1LvDYzRpFhXohC11i3k5F7pj1CWW9XfCn0o5C2oNArnobOqpwAb4a8hSjY6UO8lCKqg
         ko3EC/7QHHO4fl2gFudrHrxV7VQrcrQss7JlGQbKF+kOJ7lx3OurgozaGkn6DfsqKUAr
         pZZqYPfpudPVWvSWH3gWRRRf5jPS77nzvTb9mpcOoMo7kKRkR78S3+4PXH/KmzlmJT0b
         l24JNrUkOvrtm3iK4ivEk1oLpNjV1usbyOME045/juoy8WTUi0b4UnUBHWGlsrAQBbpC
         AEEw==
X-Gm-Message-State: AOAM5306whh2HOlvvar0hO5mYfQEiu5I1lp2uRBqxoX7t8eVrIZj8u7v
        4FgmWocZh4Kq6AsEcd+BngU=
X-Google-Smtp-Source: ABdhPJzwltPTZYnOVJgVwKCzchv+qSZSmr6Ozj5Iny9NQGFlHiXGthAnLNtaGp3iiBoy63xHzLVVFw==
X-Received: by 2002:a17:90b:4d0c:b0:1dc:d293:148c with SMTP id mw12-20020a17090b4d0c00b001dcd293148cmr34009500pjb.75.1652757915522;
        Mon, 16 May 2022 20:25:15 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id v16-20020aa799d0000000b0050dc7628191sm37001pfi.107.2022.05.16.20.25.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 16 May 2022 20:25:15 -0700 (PDT)
Message-ID: <ed05dd20-ffd8-7929-b72d-5d904e831395@gmail.com>
Date:   Mon, 16 May 2022 20:25:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 5.4 00/43] 5.4.195-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220516193614.714657361@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 5/16/2022 12:36 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.195 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.195-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
