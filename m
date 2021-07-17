Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0343CC6E7
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 01:47:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhGQXum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 19:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhGQXul (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 19:50:41 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE8CBC061762;
        Sat, 17 Jul 2021 16:47:43 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p9so9110138pjl.3;
        Sat, 17 Jul 2021 16:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=jqm9bADBTjXarUNO7zNvEPBe57n8l0U81FwrzNRCVBU=;
        b=o0/CU2otK+wkGdWL2VfOksB2vsd8J/gWqCz+Prs2K9Hk0LtWTYBDOH83WnzvNyKnWg
         n6ADZDOM1iZpEjKHLMv3NTaEqi1RVxVkEgYyiYRtXmnqCRS1r/ig1eRWEg555uW7pCbu
         Rjkp1ouZz9g7u3UDkL7hmfFyYKmcY0g5zrUGZ0cOW4aS01BjBGEtmqOxLAF/Knt3Dlgg
         IPhnPXi+5CSdyUkNIftkfF71f+tlOacz1o0Uk3HcHYCRB6L/PVs9IUcwJjw71rmMOeGk
         K2H5TA0Es0blKeeWACaO9ltlyzMAlcBqgMojV5LRLvbAZeYpE4Nd8xzkCX84VUsNqM4A
         T7iQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=jqm9bADBTjXarUNO7zNvEPBe57n8l0U81FwrzNRCVBU=;
        b=PlwXKEWhMPyQt0IVhjo1CGPkHb/zQRKEc5GfqUiWL0y8fBZs6WH8qiUFwCXPj2w2oq
         hyg00MtoFGjMxIZIhh7vjdwArPpMAs5NUpFy5S6HECqhqg4M2gH8Zkrhvy1jPO6NN0X2
         hNd90ww9jEFRURF8mUp3pucR5u5fMev1U10pacc+z9/hiFeiD9JYndcQ38RoxlL7dXCC
         hMgLZJ7As0IDNjr+6k6c8t4XmEDDhm0RMBpZtm6+JDuZWFgrWXWV/fG0+UQG7rFJSaLn
         vl/8eW+fh2Kj61VXSam2cq8XMiuw79r54bz0UaT6dYEheNOA2OwsWJhGDPMYw+NWvGhe
         gpZA==
X-Gm-Message-State: AOAM53264ph93mFcQQ1Y8Hgw6JoKmhYf0SUTHJn+mGtvBgDncymr8QX8
        RFshqYpKklVLIq23GGOg7PrSWEqZruU+7g==
X-Google-Smtp-Source: ABdhPJxEVxLytbsBKYrYydTqlTJiGCIbb+nTfdQ3fKy/Dmj1Qk14so2vhwdwZhUssi3kivAk9Vv0Rw==
X-Received: by 2002:a17:902:ecd2:b029:12b:25f7:9d52 with SMTP id a18-20020a170902ecd2b029012b25f79d52mr13514529plh.18.1626565662745;
        Sat, 17 Jul 2021 16:47:42 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x10sm15384814pgj.73.2021.07.17.16.47.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 16:47:41 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/212] 5.10.51-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210716182126.028243738@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fbac9104-b01d-4336-69ec-a53daa12c1db@gmail.com>
Date:   Sat, 17 Jul 2021 16:47:39 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716182126.028243738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/16/2021 11:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.51 release.
> There are 212 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.51-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
