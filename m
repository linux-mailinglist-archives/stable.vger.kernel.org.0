Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65524651725
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 01:21:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232739AbiLTAVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Dec 2022 19:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231860AbiLTAVV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Dec 2022 19:21:21 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D096228;
        Mon, 19 Dec 2022 16:21:20 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id s7so10654818plk.5;
        Mon, 19 Dec 2022 16:21:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FaK6z3GrOP0OER65BMHomvnlNSQmxSYdORpZuG0pagA=;
        b=e8/N4LJyB7BHMSYTtZ8iOTuZ8R7DVv0z7VuE9DQ0nbPp+tetGwMcDrnIxW3CSymell
         7IeZujNbYNUoKSI5UNIX6Xzq370Svem1Ec8on9zzt8Rq7HBKgHi8U+2KQmQKYKhBLckm
         Qx8hVeNAb8g2B/i7wTdmaDtCARm8nKk+y+F/rpC/qdCU/OC0cASOQr4Lk6euxYzDsYqM
         Mec3Ytsi0JdtwSdvjvQaaw7jOeBirIywMyYkvoBlayaSinQKfaCvtY9irnyIoCyOrdm1
         Gy7ZdOWFNqKLaIgVjSe2mc/sIGw7irkqKzjogqEycchqwWP6zTK8FhzYEzNRKmlGYG6v
         aaqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FaK6z3GrOP0OER65BMHomvnlNSQmxSYdORpZuG0pagA=;
        b=xiiihhfFEGRYgphCDLpIAGQxRvAGe9om1Wf+58LKyMslBuoSVjXTb+/GSVUgErlpSl
         p+oJNNVovwhZJsPCA6lvJ8y8dDWqTZ5QTIg3C44VoKBKe3CzRqynFSra7pxZPBNfBU04
         k3FVAkp0qSWJilt33iJ4O5MVD5nPAS3h1P4KuFZnWgN+87Sdj3WiUSblEhNIhdfaQNbY
         HpOoR0tOK31dMmJnnT9Xu4c7ccALUHD89IuyvM+OHFiZcxP3neZUhUaOd9bvXCZTSTyv
         kCX2CulOgafbaN4cDGgMcD/Brr9xAlhd8rzuBVVuQ7Goq6YvtvG6mVUHWW9ex9RqyiBK
         R9cw==
X-Gm-Message-State: ANoB5pm/Bybcqkt57rNtoJEV5pfDbkNXG4zpvG+HQb9ThFZcWdqtuPNY
        fGmcDj4aQeHv/c/YdeKhELI=
X-Google-Smtp-Source: AA0mqf4asHePCzJlxD4MPUU/8AE/RF08E4I9Vdi3on0Hz0v8fFVMf7L1GhK413Ftj6MrZm7Zvc3r8g==
X-Received: by 2002:a05:6a21:789e:b0:a4:4578:8caf with SMTP id bf30-20020a056a21789e00b000a445788cafmr64431166pzc.43.1671495679854;
        Mon, 19 Dec 2022 16:21:19 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id om7-20020a17090b3a8700b001fde655225fsm34989pjb.2.2022.12.19.16.21.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Dec 2022 16:21:19 -0800 (PST)
Message-ID: <423d222b-5b71-a179-b2f8-f4231aa03270@gmail.com>
Date:   Mon, 19 Dec 2022 16:21:16 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221219182943.395169070@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/19/22 11:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
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

