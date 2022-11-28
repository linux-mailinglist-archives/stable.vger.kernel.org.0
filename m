Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4113863B4DE
	for <lists+stable@lfdr.de>; Mon, 28 Nov 2022 23:37:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233836AbiK1Whl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Nov 2022 17:37:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232919AbiK1Whk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Nov 2022 17:37:40 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE315B70;
        Mon, 28 Nov 2022 14:37:37 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id 3-20020a17090a098300b00219041dcbe9so10397761pjo.3;
        Mon, 28 Nov 2022 14:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OyvJmG+hXWLOKHOTgZkR3mwK6h+cOOTU1MyibLq0rL8=;
        b=d1O68c2jREVtAGf4fuehr56UzAoZaqFYlQscerX97Zbtc7zzgV1cGYNJlJxyH0KUUR
         hNXpQWXwdqFZhGX9UhUBg/zDV7wkR92eAeM78G++8vjpZvZnbqHyB7bWie5xWj4/Hoqe
         ZZpa4U3OshBZ0PkYzMAdg8nDedS4H3BhKh18tp31Qiq595CnrDmUj7Yej0ALrymDACSs
         5ZqwfAxBNRz7I12LZ65C2KSWulKoLJBZRwO4SdIugZI0+pZZhaSSG6QrPgOsBPVxPyEy
         Vs+Rz5JtNHDZLWz2ksiedKWvbGU4vs9CO40PuYUTIuJlB9E5xkXM296O2JIFxN4ltxH6
         OFQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OyvJmG+hXWLOKHOTgZkR3mwK6h+cOOTU1MyibLq0rL8=;
        b=CwkrJWBcWAgHUupORDgToDDw/Bhgqe6a5890DYmf8+e9/pF58fve7HX753Q7iKO0sG
         qKqMpCEf9okBDHoMfk+F4m/xyjb7yV27YjI50KNkhKkk3PQMd9Ki+I2MKwWmBGA8Rqco
         2KqnGVqH+280e5h669XfaYsNTVUNwqDULiFNF6g7snoXF+hn1vrLKYU9QfTix2pmcaOp
         TeMZqJlgUnZU7Gm5wGRDnrpT0LfBHCo4/NKsCZhVDG0Z07kabYBh2WoDPJiVHIWKzAV0
         f11U0yuyktvgc5h2UepOCFyhvzxIxVnD9XP6zK8z6eT3Y3JAcX/G7pM3o3acc8BPX2CU
         DQrA==
X-Gm-Message-State: ANoB5pkg6Jo2ZeWGgCpn69geAftkbRrx3Q7gPpkG1ISMCyPqjDtTN1SC
        55RSV3eJSsu7oLD/w3GxiXsGvLzK7p4=
X-Google-Smtp-Source: AA0mqf7kc/v3b9KLCQ9a4qlUbo6+LOHUKgDLH3uwq/67IqdRSiE4NoAz0Lgb6k5EQJ30ADg2sjwldA==
X-Received: by 2002:a17:90a:7d0d:b0:1fa:b51d:8d83 with SMTP id g13-20020a17090a7d0d00b001fab51d8d83mr35354570pjl.169.1669675057266;
        Mon, 28 Nov 2022 14:37:37 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id pc16-20020a17090b3b9000b00212cf2fe8c3sm73446pjb.1.2022.11.28.14.37.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Nov 2022 14:37:36 -0800 (PST)
Message-ID: <d87ecefc-0b71-fca6-2a0a-64f170d3d4d1@gmail.com>
Date:   Mon, 28 Nov 2022 14:37:31 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.10 000/149] 5.10.156-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221123084557.945845710@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/23/22 00:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.156 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.156-rc1.gz
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

