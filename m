Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96E6D483750
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 20:02:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235946AbiACTCH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 14:02:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235930AbiACTCG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 14:02:06 -0500
Received: from mail-vk1-xa2d.google.com (mail-vk1-xa2d.google.com [IPv6:2607:f8b0:4864:20::a2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1123C061761;
        Mon,  3 Jan 2022 11:02:06 -0800 (PST)
Received: by mail-vk1-xa2d.google.com with SMTP id s72so3603184vks.9;
        Mon, 03 Jan 2022 11:02:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=GNIpy9RQ4x4PwLUuHcv96h7/jXsqh4G7X36M5tDW0gU=;
        b=bsORjued5Oy7trclTEscVi8UzKmV9bbJPNctZFgQjnu3wczcsdkjCr/qWABkC8kbxx
         gaZcqfK+yiZFeHJLrm2tm4OhH/nACkRVI9dqbDk+ZJZvHjK7iPDJJ0ba2DOtm+UxYuel
         nO8MSJ38cm7zOKFWHm+nWnp2YANAP17rkwd+J0d94YoJv/5j/hD2lpUG1tpol5rnggBL
         XdrERx3m2kX89g1dK42H4U8ge8snK0xK/9xth0Dpj+sktXQrtyVVAgIUUrYUHePiSHGO
         /+r3AK51zAnCHVbvIkazIYH2o+LryjvMIwNDlUz/fihd4pQzON4ArVguuyNOxhKrxAqI
         G40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=GNIpy9RQ4x4PwLUuHcv96h7/jXsqh4G7X36M5tDW0gU=;
        b=S3Xx0ipUow/bJl3PcluHvhL4RTPJv+6VucPRoSzcg4qV3gpTf+meIhtRNXUuWUYqzZ
         IVHmDP8LGlqiHAekrJt9FWqgrs2IhDloUezJ2X6jyvheAOlGtpwgUjH5rVkcFm1FRfnf
         vwGtzOodAslMZYQx/vEaa4qRtUEx97eQes8TYuD0Ryap2Xni/Cy94OGelVrR1Eg4//vN
         eMSsDvzjZWkxb8L6YKAdVSynKCtChTcPMoPbD88yLCV+WdWCDsksgAgUCi92UtwRnjFn
         0d24x7IR/isVGdkar9TlsKH5LBNctqDseOvBGrVzrMg1JKZ/2bBJ7v9T3MtPF3xjRSKO
         o+Pg==
X-Gm-Message-State: AOAM532pAWfAeZ2YVA5ZJJay36lBj3BDQCUUoLgE5bEZW+IbjHaFXx7l
        2JpM0QV9vpKrxnUMwNQRsKXMkw2B0DU=
X-Google-Smtp-Source: ABdhPJwSG0Buy3HIZZ1H/Za5Ncl+5yLGWuOMHW17tjDMfl6EDURgz/QgRLkRHCsayd2o3Uaem8cGJQ==
X-Received: by 2002:ac5:c5c7:: with SMTP id g7mr14816431vkl.29.1641236525688;
        Mon, 03 Jan 2022 11:02:05 -0800 (PST)
Received: from [10.230.2.158] ([192.19.161.250])
        by smtp.gmail.com with ESMTPSA id b8sm7254646vsl.19.2022.01.03.11.02.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 11:02:05 -0800 (PST)
Message-ID: <f5a6c584-6894-ff2e-d4cb-2af9f5fdaf55@gmail.com>
Date:   Mon, 3 Jan 2022 11:02:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.1
Subject: Re: [PATCH 5.4 00/37] 5.4.170-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220103142051.883166998@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220103142051.883166998@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 1/3/2022 6:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Jan 2022 14:20:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.170-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

See my regression report about patch "net: phy: fixed_phy: Fix NULL vs 
IS_ERR() checking in __fixed_phy_register", other than that, the rest 
worked OK.
-- 
Florian
