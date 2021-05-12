Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFB5037EF90
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 01:21:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235114AbhELXNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 19:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443364AbhELWR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 18:17:59 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CBECC061760
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:11:42 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id w13so9326192ilv.11
        for <stable@vger.kernel.org>; Wed, 12 May 2021 15:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=wd5poDVqqrt844UWauNsfektEm86G6CzkvN9l1L/+qE=;
        b=Uh6yk/qxYZm2SBcb/PJlFqKOLmH6dqqG7aeGF/hA2fp6m8BdpRcTbGuRIYpiDgNbPe
         JeXWJN/Ifjb85TxO0tnPZy6PZQecl1TJ4IgJcWt5EHeFAymTX4Hv3OckiooYL3c1Xb0p
         REcNqah+qDjXAmG+NWOgQ94QaYqCVoSftFvaE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=wd5poDVqqrt844UWauNsfektEm86G6CzkvN9l1L/+qE=;
        b=e3TsNvvA+GiqS216nMwaAAiHTAWxcFGfJoDU3D/JyLEco1UT51WODkeh/kecrPwMJV
         1uYyq+agPHMlsC4QQyu7DucEfjNUN1F8QIbNoKVwZfcTcxb/abEMpcnoa91eBRMeUfi2
         T0NQ3fGWXnSsk/CwisWYnmkDX8Ve1SbHpVOm6PELQfnsufWhzsvirEbnvur8ZtlUX1j9
         qIebULwAdSfH7HaqvX4dwQBy6z5MpcRm4VmlxQW0hf1r/C5LRLCIBTX1vObFivj8/pZe
         izWSTR9oHjzyA1Y3fo+a5Z7yu3W0aFKO3bkwbRAHX0QXXb3oBXiLqn+zGbB6sLi8j+th
         I8bg==
X-Gm-Message-State: AOAM532Ygp78NRc7/BTVLy4tjhmi3GY1iIXJ6wiwVGVmm+oq2XxkykFs
        s3/E+2tGy+O4ZiE2A9z7PmSCgQ==
X-Google-Smtp-Source: ABdhPJxH0KVtyh+mxdvprNA0Najz8wcViLeYtRPadRLv1ni4smpV17PexyYtLqBwZaQkqsd9cVaEKQ==
X-Received: by 2002:a05:6e02:e0a:: with SMTP id a10mr31320571ilk.271.1620857501471;
        Wed, 12 May 2021 15:11:41 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o6sm443432ioa.21.2021.05.12.15.11.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 May 2021 15:11:41 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/677] 5.12.4-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <e23f72a7-080b-56c4-dc1d-3c24190c0d66@linuxfoundation.org>
Date:   Wed, 12 May 2021 16:11:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 5/12/21 8:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.4 release.
> There are 677 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
