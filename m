Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7116A489FBD
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 19:59:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242845AbiAJS7E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 13:59:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240453AbiAJS7D (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 13:59:03 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4513C06173F;
        Mon, 10 Jan 2022 10:59:03 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id i6so13401272pla.0;
        Mon, 10 Jan 2022 10:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eONA9fQWCD2CePDexyvCKDVMG/estKx+2ErlTjTBZYo=;
        b=ozc+GwFWKryCrHJz9uFZLhUfE0BYlh9Lr3ptsxTp4Ch5p6ZbuE3VeY/8OYXUIKR/sH
         Jc81VHT04CtzCsx49g7S/GlJUI2Z5TcuQQgdmL8WkESz8IPd7h/74AW8WMZ76H63jrpu
         5aifvmsv3UB7cb1w1FLSKZ3z1Ti19m2C5gTkKO/KYu7p9MQtp94EPBu2FvJEfrLtWjV1
         mC4VQ/xU/PP2dSgunvsK/EptC+iQqcmVAYZ9uIuvNt1pvX0LUNf8IZUXGSMxbmcYH1pn
         +EZZ7gIuwZ+LBZhUq0/UIfx+bQ8M18D45nCv2HuzL2kfb6o7q6dqgKPVmLR2UxGOJdUp
         c9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eONA9fQWCD2CePDexyvCKDVMG/estKx+2ErlTjTBZYo=;
        b=o4bheBsKsWDzV9tnjPb57Z5DKXYhtqyagHSb+K5wIzqy1OGvbQekeGf13IQnwGGOgg
         zVWi0GzayXsjYwFTcFuoGv2u2FSxoaNs62JolwO4foLCILv0duCbyxH+oErE2Egvy7kJ
         WWvz93U/j/4qmdEazQU+rfv41aXEHIMY3JrDwvI9sLfKFVmpu4CUXGTWOteYj7K4yA11
         Z7SN+JkurlUvAHzFi7sE6Q48fhLIrJ3Ax6m3iK9x+++SOKClv2j7zdl8YHsd9PljPn8R
         nKRrbhX/FoesDfAw/8ZhI6TAG6GJS+TRgPPkhL6hp2S5sGf4Bdze2PWNBF4CybmsSc7n
         /Jdg==
X-Gm-Message-State: AOAM532OLv+3wrl4a0Jx9qt2jOYgo/5vjE8F4TXz08+NtB0jIxAcO1qj
        9gFBmbsVL6OvEHUVX9HO+Nv73G/3TNc=
X-Google-Smtp-Source: ABdhPJw0VI8OIW8kGcKZc8cnCnQTAmF+9njOkg5Us+xhFME1Qb3byYw56j6cmgX3DPpw5N/GNs+7wg==
X-Received: by 2002:a63:ad02:: with SMTP id g2mr931115pgf.153.1641841143010;
        Mon, 10 Jan 2022 10:59:03 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id f20sm1224582pfc.108.2022.01.10.10.59.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jan 2022 10:59:02 -0800 (PST)
Subject: Re: [PATCH 5.4 00/34] 5.4.171-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20220110071815.647309738@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <2166b308-d738-b555-9789-59f2213d73e2@gmail.com>
Date:   Mon, 10 Jan 2022 10:58:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20220110071815.647309738@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 1/9/22 11:22 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.171 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.171-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
