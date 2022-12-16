Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 734F264F256
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 21:26:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231295AbiLPU0k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 15:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230389AbiLPU0i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 15:26:38 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E441B3947E;
        Fri, 16 Dec 2022 12:26:36 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id z12so3626436qtv.5;
        Fri, 16 Dec 2022 12:26:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rcRx1iOzeEHZanYkE8bGhrElsG764GjfvNJrIdjSpSE=;
        b=EH9sGORcrxPkpJIGgXTqF0bnLJRWC1tzRxwIw+Q8Whlrje0bhyAePt4u67Tg6vzTxK
         satVJ9y6zXFvImMyMjYekSi2prcvcLgdEMYd4SKJGa1uD88pfJK/xXIU1Is1T+VXdg7C
         GPJU+15+hJNMeAbbl80VSF+T6dsHUfYYhvc57ct5ZSjm93vUe0cEbekFdnx0CF736RaD
         mw/v4XQY0T9EZvHT/SBc8Jl/GpF3En61LQMbIIo51RP1AHtXcV4kR+S3qP5Z1j11LDt+
         4r9bKXof6XKdoh+qKRRrQVbuLuXV/XvTlAMWSlxwp1UVHFQkzNL8pmKeiltFwYOX5BxF
         Optw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rcRx1iOzeEHZanYkE8bGhrElsG764GjfvNJrIdjSpSE=;
        b=atlIgBUR0400y6b4wRsdXFUiw4pnEaUJiesoTFRUEq1hh7kzDoQGfHoenWOBe5o1zv
         dc6vPxD/apvotWMbs1InwKE6KYjIE81EW79FKoBdvvLHZVm7yBvURbnUqueaY4X0xlFn
         JTR6IOBNYXiu4lAsmsoglHc0zWdVX34IeUQ6TWfReyHm3Y2l+S5EcHi/UUsfUlVPXsd2
         OXuTKuYzKQ5/TIssP5jJdmjiq55KWZA1GOnDmmEzAIzp6CHtH3cspTd8sPr3apFupWFq
         Z10EkPm3J5SUAQ2SrKK2yxwYsYY71T2PHTuS6h2M3dK1Kx/8MQibmTnb+KkQln7ck4sg
         ukhQ==
X-Gm-Message-State: ANoB5plgOjraHkmr0JuLgL2WSyj08ZprwOEfXWCL6hKd9y8WeUYTbZA7
        vJzbGsysGPUvOQsQU+y4B9g=
X-Google-Smtp-Source: AA0mqf68KfR/QxmkWifs6d/s8rQecBbb0g1rZ1GJPSQzTpEY2hwym72KmjU2IHEfpwMYDOcwNUZTEA==
X-Received: by 2002:ac8:4d01:0:b0:3a8:28d1:4541 with SMTP id w1-20020ac84d01000000b003a828d14541mr17595036qtv.66.1671222395956;
        Fri, 16 Dec 2022 12:26:35 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f1-20020a05620a280100b006ee949b8051sm2170694qkp.51.2022.12.16.12.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Dec 2022 12:26:35 -0800 (PST)
Message-ID: <925e3609-7bba-2045-1184-a6b0bf8f2b45@gmail.com>
Date:   Fri, 16 Dec 2022 12:26:30 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221215172906.338769943@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
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

On 12/15/22 10:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.84-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

