Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CACB6EE7A8
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 20:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234382AbjDYSno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 14:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbjDYSnn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 14:43:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493FA16F30;
        Tue, 25 Apr 2023 11:43:33 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id 98e67ed59e1d1-2472dc49239so5528600a91.1;
        Tue, 25 Apr 2023 11:43:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682448213; x=1685040213;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=seaqzbM0T/KT5lN1ikdO/NY3x70xGuSLmb6mU7SK/YM=;
        b=KJUOKnpyLl12Ao33o+U9l4yG/YF2rQoOGSX8Ru0D3qtPj4GF8E+IZhAqBWCqWrurFF
         oqaSQskVH8lS6fZFBhk72MqhveAxfMrksTsYEECFL6fl6NlJiDTILsvuCUMC4dk6Iu1O
         CTJ6SYLuXah5HUGZiahuzPthpXw5rd1Q4uBBy138fSBbV5oCoCJz9f9BDKQAl7n3c8ja
         g5EIrWT4+j0wrkY6yC6e25ukXTzaEzgJ1j2tnbc2qBqNUVKEolABunj/NtYC6iZxHC8D
         1AkKSw7NOPAiNeQNMA6gJhoNN6rQUt4KwlYJrvcUaTwPA5jtHtbGzkM/AphoxFDs9KBN
         TqfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682448213; x=1685040213;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=seaqzbM0T/KT5lN1ikdO/NY3x70xGuSLmb6mU7SK/YM=;
        b=PGRb/PYditni/xsGx/CzsowvMdNASmzKGS/k2upg/mHiEa2sxH6FDko3Clx1f34gJo
         cs+BSj1c4wNSZlj+2BUauuT+LiXWlP0jLT3YTH/M5Dofd7sbs67sFiB4QAUg1MiAVnYq
         Rdq/J+ordc+oBSgTTJT1rz8cuSycj8pKj74tYsCCpPwyWU5wuKFND+T9yDgKkRjghbLN
         gh+pbBf4rdhogIf4ZXoM/5MCg348opQh4Y2+soY/ZoYXt1/2iIcqnrHp4lF88EvRsmeh
         d/Adv0uKsU3LmcFw6KV05Ny1ffpUul/rh7ZIVFRYLIBBhq+/y1hUKBZmeDiT/7vpnz+K
         WZSw==
X-Gm-Message-State: AAQBX9c90Rt3pBfEoKqAC/D3PS0Hzr1GqevgumHKoCLt3L/jsldjQivK
        t06TM2hiDTwU3vpv/HOAKE0PtAbtmA9WdA==
X-Google-Smtp-Source: AKy350bSwSyUk4TsW4BLeOlQheixISlHJlK24ZtPBWlG9l5rQ9DJ9Nj1z/Y5lO4vM6WsXJgNa1OWaA==
X-Received: by 2002:a17:90a:7783:b0:24b:5a08:5cb6 with SMTP id v3-20020a17090a778300b0024b5a085cb6mr17214810pjk.19.1682448212565;
        Tue, 25 Apr 2023 11:43:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pw12-20020a17090b278c00b00246ba2b48f3sm11843465pjb.3.2023.04.25.11.43.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 11:43:31 -0700 (PDT)
Message-ID: <7b13bdf0-bb18-8f3e-0a4c-064ac47eb45e@gmail.com>
Date:   Tue, 25 Apr 2023 11:43:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.179-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131127.653885914@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/24/2023 6:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.179 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.179-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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

