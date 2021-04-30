Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCACB370420
	for <lists+stable@lfdr.de>; Sat,  1 May 2021 01:34:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhD3Xfh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 19:35:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230508AbhD3Xfg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 19:35:36 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17411C06174A;
        Fri, 30 Apr 2021 16:34:47 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id v20so10151416plo.10;
        Fri, 30 Apr 2021 16:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=z5MEJIfnUuZf3h4x5ft3MtT7K4Gf6BSH59Vn5CIL5xc=;
        b=Bd0YGG2wLtKewm6lKneBy8kva4rIn3wnzvWQu6HMW2pUSqRd/ArQaqSZSjX5P3DaVW
         etFmIgxI47gfMoQK/RWNjd285K1teMdUtmjP8fdOYDEaRJDJmNrZHBthPSSrlM1LGT92
         ZgdccCAMB/KTe8tAv2GyeZdy3m5Klo9ViCIDX7tjdTUwoa/2M9W8GDby1hT/YUtR5Zfv
         pTn5rNYDgpbCI/LdEoiOeL8G7YOQiIzAbDoCqt9HpJezt2eKYH3WKBk1uLdLYujGnoJT
         JgDabB1CLguRHxRnNcDpYvuttT/qkTreME6wv4MDCC7A++1+m+TD52OeCraaWecLV6Wd
         S7Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=z5MEJIfnUuZf3h4x5ft3MtT7K4Gf6BSH59Vn5CIL5xc=;
        b=XlKGTs6y45cresY72+JIN6qvuW7jpNUR+ei+8xmf2xwyrdqndjwTziG4NS3bG16Dps
         /fpiQrPGrMaJAhciTMMXWsKLCSEKqnzgAVWab2YnuagUGzK9qcELrM4tEypJfwQq+zrk
         9wp/aN+7oDVJ4sF7iR6w4fBZr/GO0NlOoW0aEzUi5FCSY5YG09zvr7xa4PtxrteGORu1
         1uTSzTyoKReifzcrn3FZEoRQWdOo4SoOfj/zRWzMWbWAiV93qqG5t3T7XMLNAE54Q5rD
         aAioR9Zg7iHjMjDInkGkY7px21w4x3m9y9NLemYgKTiEvz9OPl6fz5pexFp7D0ZX3A25
         IHxg==
X-Gm-Message-State: AOAM5317At8G+xSj4Eb/eRmJe88JKTY2LTx4yO4NCVuDRMimnzy+bRO3
        rHQ+XtEQqaE54Tb8rVZUAQCwOI0P1sg=
X-Google-Smtp-Source: ABdhPJwKBR0hDGbIs8MOf0oFV2ajHTrSCQNuwAopZyRvbn2BlHq00ahXWeLzIPeTfVAQdZg8E7j9yw==
X-Received: by 2002:a17:902:6b02:b029:e9:8e2:d107 with SMTP id o2-20020a1709026b02b02900e908e2d107mr7593459plk.61.1619825686201;
        Fri, 30 Apr 2021 16:34:46 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id i123sm3323156pfc.53.2021.04.30.16.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Apr 2021 16:34:45 -0700 (PDT)
Subject: Re: [PATCH 5.4 0/8] 5.4.116-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210430141911.137473863@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <31baf1c1-a13c-bd97-65de-5719f72676c2@gmail.com>
Date:   Fri, 30 Apr 2021 16:34:41 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210430141911.137473863@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/30/2021 7:20 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.116 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
