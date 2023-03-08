Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B5616B12A6
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 21:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbjCHUHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 15:07:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjCHUHS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 15:07:18 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E612FAF2B8;
        Wed,  8 Mar 2023 12:07:16 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id p3-20020a17090ad30300b0023a1cd5065fso21860pju.0;
        Wed, 08 Mar 2023 12:07:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678306036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mxZitMnHBInsSAfz21jq6jIrKSMSSWlzGYGgmxeGrNw=;
        b=G3CKlFhOjkbrYLGH9Z/AJhydbKsD+17OebHrIOAZgVpuKSOEtjwbZKrBe94X0tjOYj
         eUb870pG/I1OhO/KoV3riMmlTssqszJBcyJ0J4y0zzKtOMkHiuxN7UAyt7Z90pXf93nF
         KomtLwDaV0e0cvH3Ss0qx0rHErdPQ35I2n7drKznDO7mUzreD4C1j1VQdgYKeryGcL3Z
         hr3puFGngP1iiLtYtftEq7eJvXB2xUzWOX+c2UdUFVifqDoBIG1tSka1Y057xFT+TB7Z
         nv5JKAre5vfn/T7EK7148hA4xkO98UjPF/bDypUkcYpZRgymiylXPIP+06uqrZ2ztmN6
         waoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678306036;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mxZitMnHBInsSAfz21jq6jIrKSMSSWlzGYGgmxeGrNw=;
        b=dJFT3C6z35I9N9UU4kiHeEQPCbJfaL7dh+QJbTU62CVQujsBuBS3b9oeFzhME0eKy5
         gfYs9vWYXaIA7DfzFA0RU1AwuppcL9wDNVDHqiTC3IckDQxQ0qM65RK7CS7kMJfGDMmD
         YoaHoLKfwo4nK5mC1gZIcnQwCDRX+S9iawJGMCNCrvnvYuokMgTYvGfqg3KzmZFq9kQD
         j0vJrZ6+V0xa6lYO9wkVGukCqRhz+mTlFfiL4WST8keFccCC0yR6DyST/WleIEH3fqPq
         /JZ5lAJTxFLgjbM2vtBd/BWKAgfsX347h+NL3fpdCM/sSbMYmplgVx9gM4PBgYUnNh4J
         vkDA==
X-Gm-Message-State: AO0yUKXUDIqGSjN8S9vehSBZVudLGMbEtld01/daZKfUuX+LT/mnGs+3
        Pilt8T/xMK/vnvpMdNUnGkP9GqY1mEw=
X-Google-Smtp-Source: AK7set+P4rFoToFvYexEZCidnV8t9kTUxg0OQLI4W1PSFOYN2aMv9VMB8E8o+6OFrLjZmiY6O5axDQ==
X-Received: by 2002:a17:902:d48b:b0:19a:7622:23e5 with SMTP id c11-20020a170902d48b00b0019a762223e5mr24297728plg.4.1678306036324;
        Wed, 08 Mar 2023 12:07:16 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s7-20020a170902988700b00198fb25d09bsm10093393plp.237.2023.03.08.12.07.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Mar 2023 12:07:15 -0800 (PST)
Message-ID: <01c752b4-2367-86ce-a852-bd420523f486@gmail.com>
Date:   Wed, 8 Mar 2023 12:07:13 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 0000/1000] 6.2.3-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230308091912.362228731@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230308091912.362228731@linuxfoundation.org>
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

On 3/8/23 01:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.3 release.
> There are 1000 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Mar 2023 09:16:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.3-rc2.gz
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

