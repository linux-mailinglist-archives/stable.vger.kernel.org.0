Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A795FA408
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 21:13:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbiJJTNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 15:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbiJJTNS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 15:13:18 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32471140C9;
        Mon, 10 Oct 2022 12:13:17 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id de14so7675168qvb.5;
        Mon, 10 Oct 2022 12:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/51XO9m8Oyexam8JekOOKXmVPNtjy4AadHGtaK6Xzz4=;
        b=EAC9nXvKpXt3yiBRlDRkgThHm8bjeKgs/xQ6uWJgwmQ9GI+agooQoVWl5oMxyynkO6
         u0o9oB2g/2xsr0Mn7fjNFpUP8JVZCfky91sw6kSb0AF+YgQ5QT3qsHMIiVUHDsJ1HV3M
         GkBx5AcvkOC8xEqV6xb1xOMA5HwYOc0y6DcmrZpdQDGjOFxECutkylvGgT4cPlCZ3QO4
         j+iQKZQiIy747EgsqE2AhyJpKf2N/LWNDCEHj7PGXipjTPmiUB+TaR3yx9bUtRiZoJM0
         iYbA2cHQQ6RdZkzjq53l+LQCnazxTRXalxWXViPsd69OeaiSa/t+N47UmUP296SEHwk/
         a7pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/51XO9m8Oyexam8JekOOKXmVPNtjy4AadHGtaK6Xzz4=;
        b=Oa5vwnggtbZe4Pjb8tkDWDmJjVYy6siSf1FgMxzvXEWJzxl5f0mcj8SzswiERdB0c2
         614YcsL+oatEveA6U8/igylw5+rPpqp7tG1uV24fZGtE3FuwUpDCI1GQSnjKJSxntQS0
         d2sjtihRGdS9Js9x2kp2U2tnzbp8x5KNlvPINTakFKWrF3bDuaVRmjyKDNnW0fbO/CdI
         b+GNr2wjoGfvH5jrlw4FX2oNxubFhO4HFEXxJhLYmwo33eD16cc2O6Ai/rL1B3zqcoVt
         6nDVU6/sfLYPQO4J4OxlG+u0IcRaWjBfMC4dSYv+yYBmVQd+Guv9BQSIhVKXy9v+J8MG
         PzOw==
X-Gm-Message-State: ACrzQf0eM6aNOODT2G+qWTFizY4/kXAlj7CXYVMMj43r4ke5Bcibw61/
        eXiWQ+NPqPNuxZSm8bwxuoQ=
X-Google-Smtp-Source: AMsMyM5PbXZ021axodGx8gLaUejSpxDMUhvlXC2NwzABGlijOu67u/ZLH3Lb8QWExWpPiqN7rE8mGw==
X-Received: by 2002:ad4:5b83:0:b0:4b1:8eed:ba3a with SMTP id 3-20020ad45b83000000b004b18eedba3amr16047382qvp.83.1665429196283;
        Mon, 10 Oct 2022 12:13:16 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r9-20020a05620a298900b006b953a7929csm1448486qkp.73.2022.10.10.12.13.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Oct 2022 12:13:15 -0700 (PDT)
Message-ID: <78932e85-acd6-d755-090c-ee5e01fb4e89@gmail.com>
Date:   Mon, 10 Oct 2022 12:13:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 6.0 00/17] 6.0.1-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
References: <20221010070330.159911806@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20221010070330.159911806@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/10/22 00:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.1 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Oct 2022 07:03:19 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
