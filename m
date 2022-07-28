Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8FD5835FC
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 02:27:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234414AbiG1A1Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 20:27:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbiG1A1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 20:27:15 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9B251437;
        Wed, 27 Jul 2022 17:27:10 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id z19so422632plb.1;
        Wed, 27 Jul 2022 17:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:from:subject:to:cc
         :references:content-language:in-reply-to:content-transfer-encoding;
        bh=dN6+hbCpNVEtFdh+UTl4teb0BkVDP0gUnbSAIwdUwlE=;
        b=NCtg7HqmoeuPIjEE3sTg+dYPDg983/HKHDs5iexH2qMJ+5v99QySqbEMfoV5iYIB/3
         Wg9qqgoG37icS5zwEG2Ue4uZtUJccPxrAOyEK0QKqE3KPSqIHhJmyxZVLI4t5nX8Tl1e
         VfB5TmFr1HNeNO3W/lq8iX79GnVilK+7wqiwvKEsCvFbH9YfJHBzRzlahkZwhP+KNDs1
         UY2hIfkYl+83QJDKLIvjJo6gU/U1gz276YIUjPrblyXwXC9T1usFsAYg6AYXhBrU4pCw
         O9tLONtbGn/Txnn1R4qXovR9paESTHVBmqEWhYGNic071PTsfZrxjOTdabvJZgq6mgMw
         Xfxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:from
         :subject:to:cc:references:content-language:in-reply-to
         :content-transfer-encoding;
        bh=dN6+hbCpNVEtFdh+UTl4teb0BkVDP0gUnbSAIwdUwlE=;
        b=n8a+gLs3zxPtgqFeM/f2l+iY8JYA08iUmqTKAjuQLJ3VRYGEX6QHpmkAhRj2w6ckBS
         oxB187LM/hSdVlBhQaZNx4ImCexwaCPRFID0WPHZCa/alyRK3XRWuWuWayhfBlYVpBVk
         2YicJfCoqxJJ4fu0a8R8jdPWFZ40gBYVFar5CsZ/k6+E3jmsCqaQT3JB/uucmqkvOh51
         LYkkzbXm03fQ7VGEHBjDOLJdXw9gJ+hTKDK1xRQeMP01n8sEtgTpT5lXOlKgAgqOLbq1
         6/STMt2hzxgYKHtkDBJGiX1Uec55uEsucnd5EgohgghvAYxvOCJx7FzMS3Ttw7LNlIti
         89Ig==
X-Gm-Message-State: AJIora8IULbUfs5G0wH7lDW777eRV1qwG1d3WPVbwKP3AfjSOuUKroZm
        K4V4yENjfNdu4hRXcUG1sN4=
X-Google-Smtp-Source: AGRyM1vLLcjt/7/kvFZhLmdTinjfQWi1K7u7Iroh7ynh26KHxoBhO+S/xaU3vsgC2iPhtLpTF9wKNg==
X-Received: by 2002:a17:90a:c402:b0:1f2:ca71:93a5 with SMTP id i2-20020a17090ac40200b001f2ca7193a5mr7380356pjt.34.1658968030089;
        Wed, 27 Jul 2022 17:27:10 -0700 (PDT)
Received: from [192.168.1.102] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id 202-20020a6302d3000000b003db7de758besm12815153pgc.5.2022.07.27.17.27.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Jul 2022 17:27:09 -0700 (PDT)
Message-ID: <98fa1c28-b782-6b59-b78f-38c960a839ed@gmail.com>
Date:   Wed, 27 Jul 2022 17:27:08 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.3
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.15 000/201] 5.15.58-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220727161026.977588183@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
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

On 7/27/22 09:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 29 Jul 2022 16:09:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.58-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels and build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
