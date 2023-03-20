Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 542E76C221E
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 21:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230495AbjCTUA4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 16:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230415AbjCTUAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 16:00:50 -0400
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E366025973;
        Mon, 20 Mar 2023 13:00:36 -0700 (PDT)
Received: by mail-qv1-xf30.google.com with SMTP id c26so2520477qvz.5;
        Mon, 20 Mar 2023 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679342436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ncz9Qy4DSOSCtDPPMkaguFx8M2v82pbbx+KqBVH+Vb0=;
        b=gAPOvuv09IB4axFEdbyMK3ydCNXCZXJtfNDpwG6dRc0HQr2dSuf305SgVyvjMnYc1R
         YbaB8kQebWgxMOjcDa1aHm5yngb4QshND5iFZTzhsx9I3vxym2vxn3x9P75UQ7gTMlya
         4y6ewvkqMy/pPKtgOhGEEV1S+BeNyEsle27jf76KrZyDV+4tfoX3jEIWtAP0LJHLbezh
         jOnAArgxUw9M76LDMDHPuXtb12b8xK6jxb9lPxP6z9iZfTUyk+hUr9rM4mHwBGn1oQU5
         KGN8BqEcoeFvdZR0rFG2TzTbvou6SPzgu3lkbb4NiXcF7z5s6TpUpP5tRAb82T6xhHae
         t4lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679342436;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ncz9Qy4DSOSCtDPPMkaguFx8M2v82pbbx+KqBVH+Vb0=;
        b=oRMayfOpLBZBG6DooWeEnW/LQ/8dtdzQ9/lrIGzvtoyDtJIm4oGmMID268KgbRhbAh
         00eAsgz5Rind2Tch0WPKSi0zL2nOxu/JkcXqA2x2UuwgAnZP8d6zQcNoQy3f8g0P06un
         ZO2kSgpiZ/bGPNDTjdt/5t+Jm+LDVgda0XL4F5ZUrcUdEybKy3lTOVI9TUSlFnXU9hRW
         HbggrXUVmDzyZKtNhMLI9BYGf41caPWAXqNEdyJ9iQSdBJaYCsLN90hIyLFOsYHbCImx
         56q1v5ZXaUeftqXl+T4sMhKGyBmXFN71/cBm12a7f4eSqj6cZ6gv4/hnhvJXy2YG57mb
         9t+Q==
X-Gm-Message-State: AO0yUKVsEQUlVohjcB/FLtbZIZmdvvNPwQi5bmZZrVqyw++G7USv+oMh
        ZAaKWBew6brLP2drbwQ7JOs=
X-Google-Smtp-Source: AK7set8Q76Ke19mD1eHBAf6ZxetIGPmwhUCjXNxaGno2+4Ts2TcGIxYnSIxXmeU5A5fFxWpUoZSzVA==
X-Received: by 2002:ad4:5bce:0:b0:5ab:c25f:9791 with SMTP id t14-20020ad45bce000000b005abc25f9791mr225772qvt.29.1679342435939;
        Mon, 20 Mar 2023 13:00:35 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id bk12-20020a05620a1a0c00b0074357a6529asm7960294qkb.105.2023.03.20.13.00.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Mar 2023 13:00:35 -0700 (PDT)
Message-ID: <f6679e32-3c77-dcfd-cf34-2b41a845d71c@gmail.com>
Date:   Mon, 20 Mar 2023 13:00:27 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 000/115] 5.15.104-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230320145449.336983711@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230320145449.336983711@linuxfoundation.org>
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

On 3/20/23 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.104 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Mar 2023 14:54:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.104-rc1.gz
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

