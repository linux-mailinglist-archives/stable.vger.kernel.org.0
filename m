Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D993678797
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 21:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231573AbjAWUVZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 15:21:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjAWUVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 15:21:24 -0500
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C76A367D6;
        Mon, 23 Jan 2023 12:21:23 -0800 (PST)
Received: by mail-qt1-x835.google.com with SMTP id j9so11122501qtv.4;
        Mon, 23 Jan 2023 12:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9kk2z4hYZcGz4xbYVx4jjMxTltcKZUPsKwdwkImhZVc=;
        b=aOpM6krJk1eKUQrl7/wH4IBG62B+p1DdX9FMShdl79bQwKR9B54w47EmLxGOZ38dhg
         FWatn0nK0lW1ZZ9GFMejd5XIvACKh/ozIHQklRf1rubGP23rrE9JYMaaf6NtVyTIq8/1
         uiISkKMbDMd0P9vqWDY1F+7ZKet5aqQbsRGjExzBy++akH9boTpgYh2TGoPAqHaEy7kp
         9RM0Zt011917xnrpQRP8PHDm/DLn3LGyh5gWL4VLeHpFe+SugWKx9VJ0KomHznuwMtpZ
         9TN7Nl7IGBpi3hOlG0mXz4P2ttedpRS8PJ2ENZjKxF/grsZthqRSj1pKQUWHO8m3d/2b
         cYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kk2z4hYZcGz4xbYVx4jjMxTltcKZUPsKwdwkImhZVc=;
        b=0s+uCfVVnJ1S74q8C6Wp2qarbaB3/spZ2mBSh9IrnXJfeL/2NFFXXo8sySDXnB8XSy
         RrIAIbOD7bm9ipV9hBvMqx7Yexv9PzyddxS/zghYtuaObZdg7gx63qL/klDVOj+FCM/2
         m0P2Swi3agXjhbLE0K5APpkgD/NhHVQvOObXJwSi6RhdxcY2aAO7Zq37tEsk8HEECRQf
         jczAbeLLJgY9WSOtBu8QMtNYWcJcto93hXdCnw0RTDM5sNBJ2E50PxeH7obZ8K62aVyD
         eB7/TB426v0iubqxcZSOjcMcXZQXyMTiTECC3pCQz9l49K2kmAiS/fiWcvSSEYBCSnV8
         Vjfg==
X-Gm-Message-State: AFqh2kp12ZcSkpBpAUIUnOW7gI4O/Ii6tgmqvYE7heRJ5S3YYCzo0xTN
        JoeZLaEfaUpepkeIx0WK9FE=
X-Google-Smtp-Source: AMrXdXv+q+08MtyhJXj0L1iFIawGjee2OPNdkTc9+AyVhhMxIBbLvz5ALoGv6SM8oKe+xYSIjOUBGg==
X-Received: by 2002:ac8:6659:0:b0:3ad:f2e1:64e4 with SMTP id j25-20020ac86659000000b003adf2e164e4mr31226674qtp.12.1674505282054;
        Mon, 23 Jan 2023 12:21:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d25-20020ac85459000000b003b630456b8fsm12539830qtq.89.2023.01.23.12.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:21:21 -0800 (PST)
Message-ID: <f00ad162-743a-1ceb-d19f-d89738d1ad9e@gmail.com>
Date:   Mon, 23 Jan 2023 12:20:53 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094931.568794202@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
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

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian

