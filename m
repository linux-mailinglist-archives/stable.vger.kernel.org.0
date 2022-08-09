Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9707C58E119
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 22:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244418AbiHIUaU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 16:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234339AbiHIUaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 16:30:18 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92D3622C;
        Tue,  9 Aug 2022 13:30:17 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id d8so5026389qkk.1;
        Tue, 09 Aug 2022 13:30:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=VABtMJN7tisUIXWgC/PrkMNOK/rCOhhAphpCFIG94Cs=;
        b=EmPL3Vo0aKY1TK0UBdgSf7hyYfbmUg+UasqeVtvbmaJGrt2TzYVvTq+YqCpUF+PuKy
         3rXxeP2TpHcS+GECuPW0j156eTgCLcjcVIPQEux4fOwvRcaInPAVrv3x/XHl4oMqLXwN
         Ah6muH43XcPcNqgK1Qv/mwhdZDw9DOvCVrW+NVPP6sd4fhm8fjqzJoT0g3bM72Lqs9tk
         XLh28r7WStf/KcXWL7DHa5YVIEELMFaGlhiyDRf6CO1Es0uNrXU3oqfvaJhgDLu5rGnE
         UD+ZY64p5DhAbxHTvz2C1G7wH06lbB2HizgNY/dmBvSbjUSfKuV+VGBcQp1WX9UXfikF
         Imtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=VABtMJN7tisUIXWgC/PrkMNOK/rCOhhAphpCFIG94Cs=;
        b=F44CC0nM2cNIR8nEVKjKZVtYSUHPAXMfvNcQ3v0U6N5d9TOUmNOsjNs+zSLN/y7K+f
         41FsaTPtjOCNia0Wuk5Dyv8NOB0Uu6CfkQ9mzTeTaliXulA61sfIN1caDIjqLt2VA129
         hNKXY0TDbQSg676NRZWYmvUIoAoXxV8ziUDhnR3+GIpWYIbM3w4WvL7GNIVe6fEdHYkf
         am5uyRQcbDVepgd2oQts9+Zk0DQjJOfCYx3c6wFCaSzSdLXD0a1IFNJO2Fw5kS5f/Jx/
         KZy1YKqOTTxMnI4RC1S3p2rZbjqUM49ibEbPz002tju8G/E5zuIi9mdTpBrUYgLSqFIM
         eBxw==
X-Gm-Message-State: ACgBeo39rYAiWmIPr+IHHjUOj/XVVio6Yzt982l2UfDNqibNQDVreWhS
        tP7fYC19vERI17tzNRjjuXoP5JKotyY=
X-Google-Smtp-Source: AA6agR47oABw8dxC8+WkaAm4tivxaQFKotFxYDpTU3o0+VEhwOaXzUcATq9uXuEF8fIeUTBs1CjXMA==
X-Received: by 2002:a37:5481:0:b0:6b9:573e:a813 with SMTP id i123-20020a375481000000b006b9573ea813mr7740798qkb.197.1660077016435;
        Tue, 09 Aug 2022 13:30:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id k19-20020ae9f113000000b006b5e50057basm11800784qkg.95.2022.08.09.13.30.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 13:30:15 -0700 (PDT)
Message-ID: <3f550fcc-4dc6-f0fa-d9be-d5e88f37edc8@gmail.com>
Date:   Tue, 9 Aug 2022 13:30:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 5.10 00/23] 5.10.136-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220809175512.853274191@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220809175512.853274191@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 8/9/22 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.136 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Aug 2022 17:55:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested 
with BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
