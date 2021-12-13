Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEBEF473574
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 21:00:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242660AbhLMUAK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 15:00:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242685AbhLMUAG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 15:00:06 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFBEBC061574;
        Mon, 13 Dec 2021 12:00:05 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id u80so15882165pfc.9;
        Mon, 13 Dec 2021 12:00:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=T+v8JxkzxA7oytgSjjFXvjzv7aKmRDN8aF4ox5F3VLs=;
        b=BrouahSjF10Ey1ayjKm5d6H6EbOjReOa09rSrWImBAuhBZChNkWF1i2PEx0wQ27Ymp
         OVADvYlVYkDr9ZUNbIF2Bn+ygvrBPjsDDS2kxlOmkqM5xfHFDgOh4Fcp5GTeuMvWfTbp
         4sY0iEyUdi1ACx0WMUkHQZ0sOL5n/vJEgMU5FGulYxoWM9PMCB6X7z0fcSlDp0yprUEq
         uJn5ylxNcvfc5mxQn/i12v75LArxxO3OSbuj24iGL6WAXwFPlqh4bSsSzPEP/tC6kx7a
         Mu530wVUN11zU8XwWbgMEQFOIdTFk333nGsNK5BwmG/Z98pkUh4HZHR7HMuhz7aSu5Kt
         93Gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=T+v8JxkzxA7oytgSjjFXvjzv7aKmRDN8aF4ox5F3VLs=;
        b=QwZ1B8t4qcnDm5gCE9ERsbCnW26zhpELdUWOnj2Gq7ZW10cvr71Mmg9W1SK4M8ubgw
         WaTIYzIpB0JSqvqvxMJ8RPbZzl80P08BUaqndGJoJ1av94n6tWl9d/Vsq8/XvCk0zjU5
         cradKBszKCi9xBDPFA9HlYXhMZpO0fsYXVxrID+TogbKbnACHrsw7FVxpDZQowUiQAM9
         oYkKwGmVU2hU90dPxbdWVoxhTyeMByek8YL57LC6kYsUXUZ7GrWEWK+8MxJkOqKtZQuT
         DBtmRatDz4V2PCB+M5FV8N4CgJKtYR7DffRrMUUox9Juv/DbEMtq7Hft6P5lSJSH0LR6
         vMcA==
X-Gm-Message-State: AOAM533L6LSyVGeTt8RNeCVv0a/JSGC1FwAKjzb3dJC9FoKKLWa2AttI
        T2/sckqqIfDXsCrDgVlbiakbmzVaD0o=
X-Google-Smtp-Source: ABdhPJw4bOsBbhMyNtTuhs+X36crxIdRCscbl4mHH7oHthAPLMw+RcyVes1Ue2jtZEarMDlSVzxkDA==
X-Received: by 2002:a05:6a00:1906:b0:44c:b35d:71a8 with SMTP id y6-20020a056a00190600b0044cb35d71a8mr329976pfi.51.1639425605096;
        Mon, 13 Dec 2021 12:00:05 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id rm10sm8867689pjb.29.2021.12.13.12.00.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Dec 2021 12:00:04 -0800 (PST)
Subject: Re: [PATCH 4.9 00/42] 4.9.293-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211213092926.578829548@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c4d5f14b-19bb-7420-927e-fdbaf10fc73f@gmail.com>
Date:   Mon, 13 Dec 2021 12:00:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211213092926.578829548@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 12/13/21 1:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.293 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Dec 2021 09:29:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.293-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
