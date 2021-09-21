Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26174137A9
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 18:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229456AbhIUQgl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 12:36:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbhIUQgk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 12:36:40 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C5BC061574;
        Tue, 21 Sep 2021 09:35:11 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id me1so6121690pjb.4;
        Tue, 21 Sep 2021 09:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1mHqMJ7iQuPIKVNp8+6cAbDcnUVExMYOvuByo+J8zZI=;
        b=MSt+pbgnh57VWFeON0e149mtBVh7CVfzrOAM1tac4N09bHVgIX4bOo+Zm2SmReIjlm
         TJYk5O9tvwo+iE/gk6Tps3qRCcJx3vz6b5jwYHVX+ncoDid6K11M64vqmJ7HIGkiy0rj
         +W6kiM1LG5JlKg39K8hfTyGlO/oCl/XorhjoGq6c3GNLKaOQo8eZd4g0N3qg8hBul+Nq
         C8sHPiHmG3zURcjoYTYZXQJzzue51VtvqF/MOQUucpEv2pyT+kRJQbUuGDOpK9BoXVaV
         2QkaPf7kFFGaDrEAi03XyP8hGuco8x9jV6kfCol8APtVvapB7qNHjJ005mNPv83HF7sf
         hYhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1mHqMJ7iQuPIKVNp8+6cAbDcnUVExMYOvuByo+J8zZI=;
        b=tEUuzl3WncppW14rTWv3ePsrIOAMZ3eLPHiRz7OK85IuzvUKkTJK8FqIw7GeLnH0mf
         H+N+fZXRC6/utQK29hVjjrHe7gVboQUhJWKUunbHaw05H98g/CmAEIA266722KiC/p7a
         CTJ1PffigRqvlUIw97OXoz099ByatYPryZxDvpb9DUO5bdy5XXb5GfdNvF8BJrNs9QK0
         0gXs5BklleRYSGLlAeKyUoghcmZtNyU/1AOSyTT5NYR66K9WI7AFLlixWh4ln6wAZUUF
         Jta2KLz0Oc1+mpzPH2Okg4KcJjti97gpslpIuWO9V5apOxH/FGLVMQHf97jWo7KhOvc6
         XHPA==
X-Gm-Message-State: AOAM532meyImsBVRtO9HFBiDtM5TBampMkKmzq7PTCJv859qByULtHHt
        JuDrPZxXWFEFdMsY4fglQIu7U56rCZQ=
X-Google-Smtp-Source: ABdhPJzp4hHIKqE8OYBiSeIddV39YaIiO+aEeDajaunWJajaQPKSaR9QGhGDWWIH8Whw+RpnaacyOw==
X-Received: by 2002:a17:90b:30b:: with SMTP id ay11mr6266144pjb.192.1632242110478;
        Tue, 21 Sep 2021 09:35:10 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id y7sm3102432pjt.40.2021.09.21.09.35.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Sep 2021 09:35:09 -0700 (PDT)
Subject: Re: [PATCH 5.10 000/122] 5.10.68-rc1 review
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210920163915.757887582@linuxfoundation.org>
 <87001227-a271-e9bb-38bc-059279caaf3b@gmail.com>
 <513b55c6-0f1f-4a84-65b7-fd05e99c0bcb@gmail.com>
Message-ID: <5949f5ac-b6ac-d538-28ab-e0a2499957cb@gmail.com>
Date:   Tue, 21 Sep 2021 09:35:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <513b55c6-0f1f-4a84-65b7-fd05e99c0bcb@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/20/21 12:00 PM, Florian Fainelli wrote:
> On 9/20/21 11:39 AM, Florian Fainelli wrote:
>> On 9/20/21 9:42 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.10.68 release.
>>> There are 122 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed, 22 Sep 2021 16:38:49 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.68-rc1.gz
>>> or in the git tree and branch at:
>>> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>
>> On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:
>>
>> Tested-by: Florian Fainelli <f.fainelli@gmail.com>
>>
> 
> Sorry taking that back, the merge did not really happen so I was not
> testing 5.10.68 but 5.10.67, see my other comment about one of the
> patches causing a regression, thanks!

With the updated v5.10.68-rc1 tag at:

commit bb6d31464809e017d8cfd65963f6e802d7d1c66b
(linux-stable-rc/linux-5.10.y)
Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date:   Tue Sep 21 08:59:30 2021 +0200

    Linux 5.10.68-rc1


Tested-by: Florian Fainelli <f.fainelli@gmail.com>

Thanks Greg!
-- 
Florian
