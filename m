Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 204646B5F7B
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 19:02:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbjCKSCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 13:02:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230243AbjCKSCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 13:02:15 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34E6C2CFE2;
        Sat, 11 Mar 2023 10:02:14 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id i5so8843175pla.2;
        Sat, 11 Mar 2023 10:02:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678557733;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sEp3Uao+18suIe2B4esuVKp1Lfv3V9UcEhPWB7SNWIY=;
        b=J4xWgp8aqQa8ujZWXlVHi1TZKwYIPszE7Rf08eD1K/KOE1fOIz8XlOecLtJjKbkJgy
         IPJi6JnI2JE/HeCl2OPDR4ixptuvdC9ZFb9w4vYYeSmFkBMzrjX7ZjMp3nXBeBmlKxRJ
         l3DKWmkLp+jJP/Hqfr/WQBfR9FGG9xJR/S8h0vjIGu1bZwYx2gfYitBiOnlmQKnPxPil
         uvzVs8P6Y3MMRF6FtA7OSBmQLxsxR3a5S3OF8eL0BkXGP+DzSlEUvB6o1vl5ov4V78xX
         ZP45U+5MJRmbTKzb6cNmSiGQ51H/qLq0de9mKcqijC20ytTg/Sa8xmsKdd3UbG5Hdpt9
         ijxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678557733;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sEp3Uao+18suIe2B4esuVKp1Lfv3V9UcEhPWB7SNWIY=;
        b=idV0GFRNS5Lcg6rYMZZLw7Zt7ob7pAluily+nPxThC2sy8DudCsT1fBlypYiwEZuMj
         mis7UCEH3xIsuHn8JfjYgAf71AfscWbxDu2uzGfyke9PopqRiIAw4SFG5UP5Gb9Aj/Ro
         v8AqKesOfM+s6cF34sUnfD7JN94NQuWK2DkaFK1WmwpnDD7oD+3hS9BWjbxpIArlD7Gu
         cVIPwHTKw52eWz0Jinj0q9E7O0EidPK48gZxveP02KGWOY2NIo2Hjcdzl8RsfEZ8EEO6
         r+xcawEg2xj4JoUhgS1knOMb5iabMDMRj4C0UA1y5t8Hr52jv9K8XxTCUUoWR8RtUav6
         160g==
X-Gm-Message-State: AO0yUKVEyh3s5IqWV4AMXpRhPl3GUiGXqIdZ8vyid3WSJYUQVm4ux7+D
        8VvZ+8kcOb2yojFdM0CL6YI=
X-Google-Smtp-Source: AK7set/sQt5TqWkuMbCi/8OWDahL2G4jm31zfGbllabOeTkQ8Pruijdv+DSUPSdyuStcfiKYFFdiMg==
X-Received: by 2002:a17:90b:4b0a:b0:237:f925:f63 with SMTP id lx10-20020a17090b4b0a00b00237f9250f63mr30319565pjb.13.1678557733514;
        Sat, 11 Mar 2023 10:02:13 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id u33-20020a631421000000b004e28be19d1csm1801091pgl.32.2023.03.11.10.02.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 10:02:12 -0800 (PST)
Message-ID: <8bdeef04-c636-59e9-020c-6cb12d0af9bb@gmail.com>
Date:   Sat, 11 Mar 2023 10:02:11 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230310133717.050159289@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
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

On 3/10/23 05:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.17-rc1.gz
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

