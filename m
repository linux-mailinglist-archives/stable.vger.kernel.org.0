Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DC56628BC1
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 23:04:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237433AbiKNWE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 17:04:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236124AbiKNWEz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 17:04:55 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD5EE64CD;
        Mon, 14 Nov 2022 14:04:54 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id m6so12392990pfb.0;
        Mon, 14 Nov 2022 14:04:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d2jCM4x0/Tsu7VY/bbamaZRgsKGNu6Ft17DA28cP44Y=;
        b=jNgLQ7fEF1qPFVYF35Amg+RuRI4kaanMBTnQwI9xPcNLpg4FzUrSNB1CUubyvvx7iN
         fYVBVYuJQ6ei9LpGQzOECPO1qqszpLpnVdACfWgh/w1IJjcmMFIu3t5n6Pl69VwRNjEg
         YXRmy8LWtOdxtZ4FjlEOISSRsu79ECnqbFmeUONXXSUJ5TIBeNyF7x5T2zmKlOnUVx4q
         NCpElZ13XaAiRrgaL/ytD8oh5EfXoREdEi14xIA4RhMCAePVZzMLi9zs/OrrTssUPNZA
         HjyeGLsIuyO1QFinhpf4mBzraFntNvYvrfThbGGbpDmyQNIEzJxqJU/ujWTfg+AsCt8/
         PPkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d2jCM4x0/Tsu7VY/bbamaZRgsKGNu6Ft17DA28cP44Y=;
        b=HGVgZVWCYWqvtE8JENdiMPYyLFd6PP8Cm92Omdw+PkQbQiMOWuN9f+YrjvFaoxQ23y
         YlTCN02wjP1I+0FSX8DCdyAeEe0r2mR4p9NkDAphsjlQz4I+ZlBF3JVNTwGQazt85kdX
         sp0s5qGsEFAEgYgWkFQkylSqngor0xUTGUHUEGX5B5fNy//1g8YKazDR3p5TfFgdB1VD
         BlVnVF7s/JWX/2xTgzXZybSZkdjn6ionL8g9qiLQaew+kuDmFwFeyhhugiSojD5hqt8Y
         MwlLLRc3Jg9deXGi7Jhl9EYh/UqaKSB6GxqUESE6jXT1uJNHCp/wV22rTUm2f9RpUKMs
         y9Hw==
X-Gm-Message-State: ANoB5pm/wZl3Mj3A3S0BnZxQfg9xoqoS3t5r/Gi4bztD8T84LDM2P8cM
        iee3qRdsXnn/IhKQmG4UPS8=
X-Google-Smtp-Source: AA0mqf5gZvxJ+PlhS1niYMXC1lJpGF2BmAFtkrU73IonlIMrtJoeDnwaK5eXLlu/bCV53h/bnF/Tfw==
X-Received: by 2002:a65:490d:0:b0:476:aad3:90df with SMTP id p13-20020a65490d000000b00476aad390dfmr1101273pgs.159.1668463494165;
        Mon, 14 Nov 2022 14:04:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id kb6-20020a17090ae7c600b001fde655225fsm122912pjb.2.2022.11.14.14.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Nov 2022 14:04:53 -0800 (PST)
Message-ID: <82e3211f-34e9-976c-98a2-ccbdaf8f4ef6@gmail.com>
Date:   Mon, 14 Nov 2022 14:04:50 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 5.15 000/131] 5.15.79-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20221114124448.729235104@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221114124448.729235104@linuxfoundation.org>
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

On 11/14/22 04:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.79 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.79-rc1.gz
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

