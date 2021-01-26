Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 159B730510E
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233603AbhA0Ei7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:38:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389837AbhA0AKH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 19:10:07 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD0B4C061D7E
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:38:13 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id u17so38371iow.1
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:38:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=54XOQKuBB3DpECUIW8ADUSmvvWpJltyrSvoQiQQyrjk=;
        b=bmRJnKyiVBl4eyoK8srDCR2+8eT7yIdeMlSZiSXFU4a1MieFltCHwlA8H+CpV5SsNf
         WCThyEsyIsAc3pIGj7+aLZ3aeU8TIePZYj+uALCAgZlFfWFN4J9wKyQzropYMJwKE59i
         FNBEJTq0OhdQzjqJN0IHGPxTUeBLS/rKVInAg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=54XOQKuBB3DpECUIW8ADUSmvvWpJltyrSvoQiQQyrjk=;
        b=Ea3+sM2Ixfqr/gdzxWtqNunhOwLtelMWHIzcB+qUrR5WQasLSv8gaYaqPzOCJjV1Rn
         Awd+yt26ibqUIuj2biN0XTf0mDWgPLI9lJQ04avVMMoVsZA0XsMMzJE94P9tyXJYmThG
         nJ9RhHL9xMTJcaKM6oKuDUu8yxWbuP94qJu8M7OQuS1Rq/To4oIJSOMyUwDogYxnJGdR
         TR2bBk7sMo9ZL+zHDGPie+pEcto0sF8iM/dCa9qhycFtAUon0z0/IZR8T8SBKy13tYlh
         5GNb1YWnv67V0d20UrlHbDhr5YVl48+WRx9N2uRI3TfJ1e7yoYBQLNmKNwdmtivGqyt+
         7MVA==
X-Gm-Message-State: AOAM533j2oWchK5g7kEY87A25mUAhIoDdMm7SN3Skv5Mr1Rpvi38N061
        9gK8hgq7DdbNkSbB0/pVNutanQ==
X-Google-Smtp-Source: ABdhPJyytbHgguYdNBANkDHC4wREyoW1jriFp6TIIW/sm0Jfs7O3ChfDhkI/jwcfU749VNih2eRMIQ==
X-Received: by 2002:a02:cce8:: with SMTP id l8mr6761984jaq.64.1611704293106;
        Tue, 26 Jan 2021 15:38:13 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id b3sm201077iob.10.2021.01.26.15.38.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 15:38:12 -0800 (PST)
Subject: Re: [PATCH 5.4 00/87] 5.4.93-rc3 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210126111748.320806573@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <eca15de0-ce0e-0460-5a98-c0b45b77d076@linuxfoundation.org>
Date:   Tue, 26 Jan 2021 16:38:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210126111748.320806573@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/26/21 4:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.93 release.
> There are 87 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 28 Jan 2021 11:17:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.93-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
