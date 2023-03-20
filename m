Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39FAA6C2344
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:58:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbjCTU6S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCTU6R (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:58:17 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E20E7B74B;
        Mon, 20 Mar 2023 13:58:12 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id r16so14828318qtx.9;
        Mon, 20 Mar 2023 13:58:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679345892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yoeChtzo2lWFrH5XgwNuAkfFSV3nOpgGzq4XPO44Eas=;
        b=FLFjbErCI/z0z3nasBQdIVv++X8I+lvgdo6KFZY8MG+S++cUNeUH9WXuJh7zj/kYYp
         qE0hqtTUBLa1nxmTd65+gbqd57y4ae9tz1+NkucBA2W3/e49NUPquTy5mS7L61iL/BDQ
         b2ckWuZqxfzkjwlR4BlwAFLFXKcUenV0Es5xCX34ZgkgvD8eLzQIsBW1JJxrOCcAavmm
         A78BoiYyYaAe3x9wkgNqunABRINWV+yRDPuQtz9SfkZW0NmyjQe2BY1CQzWUNcZYuj8K
         iCkgDwXfvOHjJHsW2FEnoO32vf5XwV5/XwkPvKMw29GU3vcCUC/LxNefV94kTv76N4J+
         WJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679345892;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yoeChtzo2lWFrH5XgwNuAkfFSV3nOpgGzq4XPO44Eas=;
        b=va5fK8PvMuFCow+4XCeWgyIqvZLASUCTACmyGi0p5x9lXg642mtjMlTG0LXQPK+4IA
         n+nDe1PBzptKgIbqHxR+nc8EGXwSIswrJpY02i32Spt9fE6ewWPEYdrJQWgBzxs5nwyk
         uKi9+JswsBy8aSDiCefT2nKJRZrfbKJr6OUbBDOXTO8wIfB0B4njaDCbnsJglQuCVonh
         ailmHLTRSw/6NAsqltXsolqCPSTOfQSkCZafA1jyrB0aHNk4YO16oDYhGMFW5MyCtFOU
         YAvKGn1+yS69/BkDMduJHouOFiF9nnD2XTIEwDSDdWhTEBknWc284IWR3ZFI28LFDV6i
         QROQ==
X-Gm-Message-State: AO0yUKX1G+yMVY6r/BTyc5BsfCy3LmdKCuFucTgeszvXF+TmHg6jdwoE
        txcp85VtCQBaFWlNmk4aoSI=
X-Google-Smtp-Source: AK7set89AGEw+qpi24l+uwt6mCVUfwsoNeY8Skw29NjmzPV/ZzgoHOZXSfzRZ2CV2terbeLji1FPCw==
X-Received: by 2002:a05:622a:511:b0:3d4:3d6c:a62b with SMTP id l17-20020a05622a051100b003d43d6ca62bmr1081294qtx.27.1679345892078;
        Mon, 20 Mar 2023 13:58:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m64-20020a375843000000b0073b8512d2dbsm7943235qkb.72.2023.03.20.13.58.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:58:11 -0700 (PDT)
Message-ID: <a3ed86fd-ac5e-3692-abcc-9e7849e176c1@gmail.com>
Date:   Mon, 20 Mar 2023 13:58:03 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145507.420176832@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/20/23 07:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian

