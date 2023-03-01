Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 479736A771A
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 23:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229451AbjCAWu0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 17:50:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCAWuZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 17:50:25 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6FDC3D083;
        Wed,  1 Mar 2023 14:50:24 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id i10so15630462plr.9;
        Wed, 01 Mar 2023 14:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677711024;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hJIzTpqGYq1aPwE6q4LWD693tsN62qj8hDcVerLovGw=;
        b=SdtqRQYKi88YwXrnI9JHaUREr154AOdkMxR3d1xEM3PX5LEF5QKr5qO7KTjBNlHrxW
         Nz+Q56a264rxNWyAFAAFnh6T4TDm88mWoipcYvQehXCmGswwUtNHviHDnk48p/egquv9
         Eu4mbC/lz4KsBROXWAQJxmBjgghxt6HDyNuGcUKcoeSBds1zejbeT1I9JvECYsUc01GK
         Id42xVgZg5ckZ+bPsKRKPDBBGq5nfrY3kMcUL7L9QBSlcFHU26GTiLeWwQRQTIWS1m5Z
         ziWpBs6LSUBMEPMhzyBpc550yuoyFuwsGO2AY3gqyeSYZfBsXiqgKe/ekT+jJnDjdTX+
         eIOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677711024;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hJIzTpqGYq1aPwE6q4LWD693tsN62qj8hDcVerLovGw=;
        b=oEXt3e8NqWJtRY77JMGuL7BL359bt3+HIFW7TZPk/FgNamqE/1E7V1NKGKizjUrDuU
         UH+e2Jo8p5cS4bzcjdmvLVEePiQEsGP1LQwoQZ2t3R4CxxdCgTbW7OlSk9Bw5eWCu50x
         4Uk1lvctBFUh6cn/xg1FbVU5qseYFcE5ZfPTwpre0B6eDGDrzCY50DPUded6JYg5jVjn
         AJPvtBirnbJLHlyh70YHK4ymoPx0s6R3Oz5shHe5OqxqowtSwjeiMqXlzW85jmLmafxD
         zeJY3dW/XA149PjGB5rpKJhILCRYVFgtXLY7fL55h2Pyv5UiXHDvzZjCnN6wxxV15CHb
         KQGg==
X-Gm-Message-State: AO0yUKUefWNxTHeR/cM3rVIbGZShdTLuhL8hEkr6m5xUHEoE9TWc2nxK
        aOz9nWYY5LV8HtiKEdK/9P8=
X-Google-Smtp-Source: AK7set8pPodOgFB0ymahSr5nfFgchcZ1ITY6rEzD5E6dobC9i0nxO328qmEyJY6OUjHZDmTWMDTKnw==
X-Received: by 2002:a05:6a20:7da6:b0:cc:4118:75f4 with SMTP id v38-20020a056a207da600b000cc411875f4mr139633pzj.0.1677711024289;
        Wed, 01 Mar 2023 14:50:24 -0800 (PST)
Received: from [10.69.40.170] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id b20-20020a656694000000b00503006d9b50sm7781120pgw.92.2023.03.01.14.50.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 14:50:23 -0800 (PST)
Message-ID: <2f4e0dd1-d428-3196-9315-5204a5a38263@gmail.com>
Date:   Wed, 1 Mar 2023 14:50:22 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230301180653.263532453@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/1/2023 10:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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

