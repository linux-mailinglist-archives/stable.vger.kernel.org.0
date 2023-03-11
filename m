Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94C7C6B5F77
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 18:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbjCKR7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 12:59:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbjCKR7F (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 12:59:05 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 519A328E47;
        Sat, 11 Mar 2023 09:59:03 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id cf14so9210827qtb.10;
        Sat, 11 Mar 2023 09:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678557542;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=rE4HnyETP2RR7uOaxlRacNKgRmbneF4OnXDmFOUFZJo=;
        b=Sz6rypFNzvGlVO2uD3ZEWRkUWzYQDe1hjwgnk60FnkXFGvsxQOeDGQ6zBQ6xgBHOZV
         IOdEfCR7qUCPhSyPUY9S5v1OhZe+oFIMAOtIWylXnEjNdp1gu2Hs1cNaiuiKRun1WU1K
         YhPWfkijPhwCst1hqFWmivCjUc2no3lG+wq0Mfx16LA6lvx7CYrgqoiaqrA7oZ7fjONd
         5AoEyA37+4KYLhB3uwUlfcdzUNgDe/9XcuV9Jam8X4owuBE4tX80qKRmAer5ixRlVoLU
         b4e59H1cdh1J2YoEM0xW/CZ+Kmnv9B9cvhdloruXjbMrzUvC/vr9nAbIJMSJyLWN2I7w
         s1ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678557542;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rE4HnyETP2RR7uOaxlRacNKgRmbneF4OnXDmFOUFZJo=;
        b=71KQJ6sga+U6lI0/vciqeiya84nk9cJ8US9y8XPkX3qEicLvVgWgnVYB5QSsZi+ZDz
         L7KwOdnsrvYDGej8GUVVOSoUGZu5AcYP+tPrccK9iXzQ8MXUs2vxYnG/PIUu6j+61aAr
         nd7aBCvtVkn2ePtiHO7MIhnG1YEx4KQGVTpelBiZbMSqaQgD2P9xCPU8VofGSaAx3PVH
         bBKgMJnJGkMnd8ZtVDqfAF364JQy5xDhnwmP7qbt+5X4fC052CDQ4o1nEZgagFfEKxNa
         dFREL3K8k5F9Y+8lPMecux4kgRrxluZtTpb5RETKLdTRK5EORpUN5rE8yQXUHjyVEpx2
         edEg==
X-Gm-Message-State: AO0yUKWWY0aJJ/HMKZRWDkCFHATGt/QGeJ8CLx8IQO2IlygsM7qgW36p
        zwLERYdzkzNNgiC700i2Mh0=
X-Google-Smtp-Source: AK7set+9RnKhwLn3w3dn4/d2c7YNxBroVlVEfe/w+ome36LdUn3ACh/bkZepmHeqXJqhUILqLNhhmg==
X-Received: by 2002:ac8:7dcb:0:b0:3bd:1647:9333 with SMTP id c11-20020ac87dcb000000b003bd16479333mr16153036qte.28.1678557542360;
        Sat, 11 Mar 2023 09:59:02 -0800 (PST)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id h4-20020ac87d44000000b003b9bca1e093sm2277945qtb.27.2023.03.11.09.58.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 11 Mar 2023 09:59:01 -0800 (PST)
Message-ID: <e1b9d23e-b76f-65b5-9086-60542bbbc9f4@gmail.com>
Date:   Sat, 11 Mar 2023 09:58:58 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 5.4 000/357] 5.4.235-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230310133733.973883071@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
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

On 3/10/23 05:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.235 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.235-rc1.gz
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

