Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1AFC764BB94
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 19:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236361AbiLMSHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 13:07:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbiLMSHq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 13:07:46 -0500
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13159E4D;
        Tue, 13 Dec 2022 10:07:37 -0800 (PST)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-3bfd998fa53so203612257b3.5;
        Tue, 13 Dec 2022 10:07:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=C89klaJYnYqVPt72HuSAj6C0KHKkDw4EdmizFmt/dYY=;
        b=QZNinhaUVjRgKa73IrmjBKG7NReEZV4m1uchhSGuGYFpetecMcx2J9lCjlWLDAwvQ1
         INXFmcEVYPOKVf8frp0GI1qjR/ASnDRpo8UOHOH9oNXMocDdLrJTy823WkqwC20ZEmcP
         KYN85fSzWc0odgZKO+Q/GfjFozhdK4nAHZmEu1TUAfmF3Ee86372btH/So7Eozz6ZXRu
         X7XWaLv6BrJhOj0HbznsJMBTkLQaKbil8j9Lizoqtzl7yzLHFOzvpTDAP16bODKTuC3r
         jJQgmfEzzpVEx68JVA5aqKKnPOwN7DTmuAAU1of8eWa3cZCOx3aBiAFn9+TZRmDZjn9B
         Xa6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=C89klaJYnYqVPt72HuSAj6C0KHKkDw4EdmizFmt/dYY=;
        b=cBOXpEM2I3LzpUxIPwblRwvWOSOTXOH5mGNWzP1tMRNCUh51/P87bbZm6S5FODid0r
         m5c6V0frzl8kMQS2TX94384LG7Zhp5HfoQMDhFHIMXxxmVqGI8crhvr7XIe2F4vGSb3a
         WRFX3G0e0BtPraE2ayQ1SkB3zzG5anaUyKkv9A/3/PxN83EQs3N5dHbI401R1xsRbKU0
         uLvsqrYRaU9rDNSlfTFxQWV3hzvZV9udxFIyPVj0Gxbsj6kJyMv1Ac6Oa+YsMKin/1T/
         G+vuFKx9PGu5b0Lg9Wu/LmGEDTKj8FbaxeFdTp61vmhCgUH42GUYmqFSWgFq7V/CqF8l
         g5lA==
X-Gm-Message-State: ANoB5pn/eueHw0rcnLiOUX/AGoEVfewKynb+mYlUTRHUJZzRYJVoCruh
        qzeZHIgY9wdwd3Srk9JgqeY=
X-Google-Smtp-Source: AA0mqf6ZOKTYxzndQpxZP3egcIfH1WZvDNMa8114teS8rzLykaNhY1IS/MMVtWXYhlkxmUih4iBQEQ==
X-Received: by 2002:a05:7500:2c0d:b0:ea:3678:ead5 with SMTP id ep13-20020a0575002c0d00b000ea3678ead5mr2180795gab.0.1670954856032;
        Tue, 13 Dec 2022 10:07:36 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i8-20020a05620a404800b006feea093006sm8382944qko.124.2022.12.13.10.07.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Dec 2022 10:07:35 -0800 (PST)
Message-ID: <87f7c713-3dae-daa2-d72a-3df8f77a614d@gmail.com>
Date:   Tue, 13 Dec 2022 10:07:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 00/98] 5.10.159-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221213150409.357752716@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221213150409.357752716@linuxfoundation.org>
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

On 12/13/22 07:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.159 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Dec 2022 15:03:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.159-rc2.gz
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

