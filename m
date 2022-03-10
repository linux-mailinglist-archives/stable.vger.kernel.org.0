Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B8B94D5450
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 23:12:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344291AbiCJWMX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 17:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344288AbiCJWMW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 17:12:22 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FF1959FD;
        Thu, 10 Mar 2022 14:11:19 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id h5so4738103plf.7;
        Thu, 10 Mar 2022 14:11:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sJtRQWdq4waWAK78t+Qlr4uvVn6+TVA/NXnkQKyCfR0=;
        b=XEjjVvVPHj8Bi47L6m7zQ0HyWoha6Q/crhLzG5MOnom3tpRvkwpJc2VmO8VcQavi+O
         nRE4TIvwqxYinENPuk6mTDHWo+6e/USFk2AjcX1XGBSusmeNGIyJEmqGdc15VqyAeMYl
         UxIWiNatr3axUkqovzi73Od3BZIYt+Bl14E5pAc7TI/Vmuyto1le/WlYy5jF1urwk8Zt
         7xIh0vI5hFuuzBBNVcFIvkPHAkX0BeIsgzXUKYhMIm7dLmkhnN0rUNVpWgVSkstlajHQ
         8YHHDQ0cvH3D8m7B8AnGfrygRIxQjibY5D5DbUp5v6FIhyAXYl2OLSQTuqK3E1crUSOd
         W89g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sJtRQWdq4waWAK78t+Qlr4uvVn6+TVA/NXnkQKyCfR0=;
        b=IjC/Qwjyw4/0VLQF5pcukb623vGs9Dt2tiCEeqsBD3YHornyvunMecD7FrBCGUqez9
         IEJk1xdmjMKtK9zFDDrka6Kf/XrQZKYuyUQh+JGYAdRjafOIhqNsABGmcHdOEzmBdz6a
         pRut0T7z0fi4cbMYHkP+uTiH/aQATvf++n1o6MESKAiSxMEeolG/FSFhkPO/Cjw+gDzo
         8rjGFsB54bMXZjbJQwIXQb0Z1gCxTVXodGX+QqexhTwyyst7NNRb5M7CmBvvCWq2Lc0j
         +JEw3jlBHwaqWabxnNI0mA9Jfe3o+FiV9DoeGHqSUo2CsKr2qXyKlCI/w+5YqbG4lXp+
         rKaA==
X-Gm-Message-State: AOAM533BO26girR3Wchb+u0qr3wPVbs1FP1JW3nhjvdDf9/VjOv7slao
        MQJDgQUg7nn2n0eX6A2w/n8=
X-Google-Smtp-Source: ABdhPJzultsm+nDhb1Qnt9FcYy/+0XeEVWqdvDZKv00JQ3LhVIvUy410SkMjInlDd0UL9xsA8FbIIA==
X-Received: by 2002:a17:902:b490:b0:14c:da4a:deca with SMTP id y16-20020a170902b49000b0014cda4adecamr7520334plr.134.1646950278331;
        Thu, 10 Mar 2022 14:11:18 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m17-20020a639411000000b0038011819be9sm6532708pge.41.2022.03.10.14.11.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 14:11:17 -0800 (PST)
Subject: Re: [PATCH 5.4 00/33] 5.4.184-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220310140808.741682643@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ca649916-3948-2564-5a37-62028b15b77b@gmail.com>
Date:   Thu, 10 Mar 2022 14:11:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220310140808.741682643@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
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

On 3/10/22 6:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.184 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 12 Mar 2022 14:07:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.184-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
