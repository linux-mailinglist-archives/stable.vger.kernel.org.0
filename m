Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 074AE6EE70A
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 19:39:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234897AbjDYRj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 13:39:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbjDYRjo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 13:39:44 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 036F814466;
        Tue, 25 Apr 2023 10:39:21 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id 41be03b00d2f7-51b5490c6f0so5712691a12.0;
        Tue, 25 Apr 2023 10:39:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682444353; x=1685036353;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=u0GyBkVE1jq6h1UTyHknq9im3hMJEVZDEDB7SjkZ9rE=;
        b=mOHbdCctckLQsK71d6JeznFiHpUgTgoVDfA4I1d4ERl8NzDZm8hw7inSpHfmlKSI1I
         JIHQUMpk+1w5to+mZG7cZhbIKxDf5vNXdZ85VZTxsz92xlArBK7vleB4WVqdod7ZvrYw
         NrA22RXdUELhPhXWCbTYZAdCZqOQX1qwge96e0o4YvlBJgHH2yrHCStyl/dkEwtxv/ns
         V5/10GEEi2txVoI9C+fv+gigHJG9Dvfc2DJQdyBEyt/Gd8FgyKH5718wLCJIQNrWM/zz
         LHMJnPeNsaCSWQ2qS+0e0woFuR4Unkj6i/MivOYXmZpxZ6s7QpextqKKe0GJquwo4Eyy
         VnMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682444353; x=1685036353;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u0GyBkVE1jq6h1UTyHknq9im3hMJEVZDEDB7SjkZ9rE=;
        b=ZzjY2BSnfKCfzQ7yoZO79IYr5fguqLgvzk/Z0WRUbZiagT3T27VeSbeHdI4XALBBIA
         BZGgP9fT7KNEEhKT8Nip5hj5FVzJsEZd4fZboY3xF9A0Vk6HG9c07b6x7HxVyfGkX+MS
         NKvAQIbT4d+d1tJR4fMoSJh670egkPxTdyZCbv0aPArRR0WxEHxfc9xEf2xM2LL3AYqU
         ULwZcRaOueAmYi30K7Sgbh1jd08s3YHGkAYfyHmM+/L5DHiY734SB/5WmtSTKekJhBE5
         8SR0kSdUv/f3DpqOeJDJzyrBLqu1JAwq2OodlW+lVzOluTzIK7gOUhz90hLPcrPBYUNo
         dvqA==
X-Gm-Message-State: AAQBX9dq/ByOOLteuZaZyVgRSlkeaJ7o8ChjTBpTIs2lL73XKnSPis/y
        Xv4qPxv/EO2ouddjl1CKItk=
X-Google-Smtp-Source: AKy350aCYLCu3HEjMHOaSFEpgIEhzjdathjT7KFIU8M/HCjkphQvvS+advWRwcCxk5dR6zvYzEO/iA==
X-Received: by 2002:a17:90a:c687:b0:247:54c7:1bdd with SMTP id n7-20020a17090ac68700b0024754c71bddmr17907988pjt.22.1682444352534;
        Tue, 25 Apr 2023 10:39:12 -0700 (PDT)
Received: from [10.69.71.131] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y9-20020a170902864900b001a800e03cf9sm8486237plt.256.2023.04.25.10.39.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Apr 2023 10:39:11 -0700 (PDT)
Message-ID: <6c695171-739f-4e70-77c2-7ef79ee8f5e4@gmail.com>
Date:   Tue, 25 Apr 2023 10:39:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230424131123.040556994@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/24/2023 6:17 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

