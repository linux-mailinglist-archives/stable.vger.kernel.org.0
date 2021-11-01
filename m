Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 210BB44228C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 22:22:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232145AbhKAVZE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 17:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232147AbhKAVZD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 17:25:03 -0400
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D16AC061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 14:22:29 -0700 (PDT)
Received: by mail-io1-xd29.google.com with SMTP id g8so21893853iob.10
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 14:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=nGW8nl21iI5LDzOTUwXlXYNhT6V+ZOAoH43lRn2DH9I=;
        b=DyEW1hB1z+iWsJGw5oP6yG70uEMcyZNuiNAKTfa32NL/1r8R1dvFJS8OSZzsg3QKWk
         DwrHxNPE2ey7Pi/xV3pzHDyrZT3gEU+9F8k989CHvPA8P6P/5xa980dY0wK8FaxcCEsB
         QB2B/CKrSxtkkG2MjWeWlL+CfLFFpTqRIAUmE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nGW8nl21iI5LDzOTUwXlXYNhT6V+ZOAoH43lRn2DH9I=;
        b=hyfGV1xe4bwWELw8q/kQQIM7LcBXmv+a1Nn72/qc3+YvYetN60RpAjPjKoXpq2hjS2
         LfGXlXoFswIRYGyyTsCIUVZ2+TItn83GlPznr9+3ZDghXD00u0lqhSQmB4mgese8zMEm
         sGT1K0m6vFSbl98E7mjOHJp7T0w2sYrZ+ugzYwX/DiqIpcCvmFmnOMxMmH3/KbSLA6P7
         CKtFkeQUjPV7HE7N5xTYXt8z9lYM3DIAwEFPrAy0KhD61pYUvAwmFkfhVw20T4MRC1xp
         F4He9UL1DDWOTZe8tg7oN5jpOvJoIY48P8YgDuGKEjvbgU3jjI3xRHgFTSkNEloz9bS4
         Cdbw==
X-Gm-Message-State: AOAM5333kBnzgOW4cw8L1Z3eal/noiOSGpfWEn1eH5rW2H+9ok85Rwr3
        AiunCXOKVIGGtnWnnHEH8JwOyA==
X-Google-Smtp-Source: ABdhPJzy9VMCNLIr3nrcUAhhUxmL3DXGH2CL6HSc/3ZRakAeySDy95CmOd8xM2ewlMNj1fXYdXClaQ==
X-Received: by 2002:a5d:80d6:: with SMTP id h22mr23265827ior.152.1635801748779;
        Mon, 01 Nov 2021 14:22:28 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id i4sm9257535ilv.67.2021.11.01.14.22.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Nov 2021 14:22:28 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/35] 4.19.215-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20211101114224.924071362@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <432420a0-ef1d-0363-5717-d7a744d2846f@linuxfoundation.org>
Date:   Mon, 1 Nov 2021 15:22:27 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20211101114224.924071362@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/21 5:43 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.215 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Nov 2021 11:41:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.215-rc2.gz
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
