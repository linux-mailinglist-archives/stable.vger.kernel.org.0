Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 123BC484C62
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 03:17:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237029AbiAECRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jan 2022 21:17:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236005AbiAECRU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Jan 2022 21:17:20 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D6A2C061761
        for <stable@vger.kernel.org>; Tue,  4 Jan 2022 18:17:20 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id q6so29775886ilt.6
        for <stable@vger.kernel.org>; Tue, 04 Jan 2022 18:17:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eKDVCHJqIqFvkjnCbGyKQ8C1rwDSmPjlWz9f1rI4f2M=;
        b=L1Pxr7ycYMrpQpNBmhB0GI2eZ5DWUXLe/My1eh1Vku84mRHpnke42qDPR8U2D5Ga3O
         BYNi2mq8/T7MDGXN5dAaOwHbz1VtMzsmGDmM0pCSW2K9mTW63i1sd8c5Hyti7+HqORxl
         MOxz2GRhpn5u1EJbmEKYezIQzzU2Ri4n119kE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eKDVCHJqIqFvkjnCbGyKQ8C1rwDSmPjlWz9f1rI4f2M=;
        b=FMk4ux+XkLuNq4pSnx8SR2wRZtdf/fuqYBsZWjek2xSasiLqC1rJzs7t+Fwm9nJme8
         z3qwy8lHrMSyLa46BqrEqQpogPG9JncBe5o+L8e28/1zXwqqbSdprI9zF+5oTagLfgHJ
         VaeV2H74uoVsd+prN4brrSrdaPhZkW4Il0QRvcRtUdAGUm3VSPSuGokpBB1lvwQGrmF9
         rNBT0mlELB27Cavq8gVEEzl4+yO9VtLsk/aJMAxZa+O234Iq9AI1bhtGWc0XfJ5U/xSO
         GqbxKkei9UEHVQ+kz2z8a5hVrlH+/KS0nqR/SFek2++gzAreb5CzY/J0gT0HSPVyn69e
         lzPw==
X-Gm-Message-State: AOAM531ERGs/Yq0qMKmNvL7yYQMYvjvJoeOYrV0FyJMTzwDqCr6fjfPg
        L2lYLY1fSNM2CyRaYGqfwOBxMg==
X-Google-Smtp-Source: ABdhPJy+NC6V4xTkSM2Ce8/yHBbyHEsYtIF4ds0WwnKP1Suq0954giPqBhRBcXYM18u5o2ts1gL9vg==
X-Received: by 2002:a92:3f07:: with SMTP id m7mr25084265ila.115.1641349039689;
        Tue, 04 Jan 2022 18:17:19 -0800 (PST)
Received: from [192.168.1.128] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id o12sm19470422ilu.86.2022.01.04.18.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 18:17:19 -0800 (PST)
Subject: Re: [PATCH 5.4 00/36] 5.4.170-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20220104073839.317902293@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <9d638cb1-7e3b-b957-550f-e73e32abc9ce@linuxfoundation.org>
Date:   Tue, 4 Jan 2022 19:17:17 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20220104073839.317902293@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/4/22 12:40 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.170 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 06 Jan 2022 07:38:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.170-rc2.gz
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

