Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5E5305106
	for <lists+stable@lfdr.de>; Wed, 27 Jan 2021 05:40:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239276AbhA0Ej0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 23:39:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390094AbhA0API (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Jan 2021 19:15:08 -0500
Received: from mail-il1-x12a.google.com (mail-il1-x12a.google.com [IPv6:2607:f8b0:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D85FC0698C0
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:38:38 -0800 (PST)
Received: by mail-il1-x12a.google.com with SMTP id e7so51015ili.2
        for <stable@vger.kernel.org>; Tue, 26 Jan 2021 15:38:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uooToYvqh2sVOHaR9hzWQR3Qrrd28Ouy/ti6ajv+180=;
        b=gtmqfi7m/QTlucBnvKmG9Q4nuS/LU2wNR2MhjBkylKcnsJMl4KU3RDBDw/0X2UIsrK
         FTuHelYWOms0OOxdk65ZNNBKxekwblkIexV9MVwZFrr2VegjFLhjIgFxhCBwFQC8U3Rt
         Y72M2F+qkonntpz4110L71Qjrm6t/jlL63z+0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uooToYvqh2sVOHaR9hzWQR3Qrrd28Ouy/ti6ajv+180=;
        b=sQEv0NitvfM/XqpXz61zasDuqHiXicRBCnTQXqGTkXRoHB0K7BufmRnYCb2tdlPa/C
         rar5weh228QsZ4yjphoKfV49uGiJMRjVhKNx7UsdHKrraJVd04l+EsiDhy7qVDrWuXZ7
         jEsKzdLJx6yOAiBLSBVuDHIsVajxw6EiTy/B6eMpkM4mmLXiwPcEaXl3Y4cfxoZp61v4
         DLKSDRyQYqxGELYOGrXiejNJXIUHVOKw4oQcXasWEeY2VAGzsUeM2rtFLKHnPwhNtvTp
         396hYLiyPJnwHr5tmupsPDlSjNgz6hY3+QLhTMfz9wyB3G0KeokHYISCweF1kT6YNFeO
         glxw==
X-Gm-Message-State: AOAM530znmhySjDzN9iTGGscYIQQNkhrAPhvBnYkjn3aMRkHOKHqO99Q
        ib17rChUkSf3qa8bh0Kp1dp+Fw==
X-Google-Smtp-Source: ABdhPJyRO8iB3ybBYHJ533dfOa6Ydkv81yIRkuR4reaYtOZ4dT3oMt8XxKZT38PU7gkV7LxQ7Ixvbw==
X-Received: by 2002:a05:6e02:18c9:: with SMTP id s9mr6819197ilu.265.1611704317819;
        Tue, 26 Jan 2021 15:38:37 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id k11sm102119ilo.8.2021.01.26.15.38.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jan 2021 15:38:37 -0800 (PST)
Subject: Re: [PATCH 4.19 00/58] 4.19.171-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210125183156.702907356@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <faca5e02-cc43-0a14-51dc-2bcb25dafdc0@linuxfoundation.org>
Date:   Tue, 26 Jan 2021 16:38:36 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20210125183156.702907356@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/25/21 11:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.171 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
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
