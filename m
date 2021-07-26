Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3776F3D6944
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 00:11:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232876AbhGZVbJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 17:31:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbhGZVbJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Jul 2021 17:31:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9B7C061757;
        Mon, 26 Jul 2021 15:11:36 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id u9-20020a17090a1f09b029017554809f35so1050576pja.5;
        Mon, 26 Jul 2021 15:11:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=7UArMpOYQ/57tF6ddX1FpjW4+llzkKpXLGbqghIVCAU=;
        b=hUgybZPgpAUWJWynMG/JT0iRlgtJNYMXktnws/ttXdqNcvrGhr8d2+an15w+Inxlus
         nxxdeq99ZZ37714m4ZJTv4870iyAKzkJiwsixiSC26o7l8Z5wAETpCJaapD8gzsUD2dv
         4fF9TDGC3IXHI5ZSVmlFAnEYcoL3BG+unLNkeY4OZ1e+n8/pYEjX+f3Y/L0haWZ/Lpux
         UIKnCvlp/Uu4nrHh++FF+d5Z5BqoiUU9qzCaTwQK49dSGx8MJn5sud2TFALkEAuxzzfn
         VIkyZ9QAR5G5n4FD1Puvng85Z7tyGmj0yeoZos7KbXPcGV3blcSOX4QHxs+OAdnJzMyU
         Kh2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7UArMpOYQ/57tF6ddX1FpjW4+llzkKpXLGbqghIVCAU=;
        b=MSYPQx37MD9YP2+bIIEit+E4/Qia9+pdOh/UJIlyiTdslXoiRBF19wBUUf7QrpM1+O
         8AHArm1B6jGPUikEAFJgWNOuXyG9lBTFYVHxCxTBbj8+PjRM0yinhrIfAEsNtLDg5eEM
         BS6cPmT0WEFjMx2HelXlDFFq98Y6IIyyoa1Y8Y2ErOCUn223qKJD0QzofeI4L26X5qY/
         Y+4tAHKrL7THwsX2SsLIBzGhFmgbkWbR/6Yp65BmTwujwVHnwBph7ztxFlKCBt5Jift3
         3+81mD9+qHgm9q6Xwg+xLNxV+87Lj/iv67xtxDR8wTRKiJMZ/Ik0WGQEmHZtH4nPB6yF
         y6Eg==
X-Gm-Message-State: AOAM533AItBWRZXq2xWJklvWluxhcaIlm0DfNhmZBMuOrImexcm7Z9Rl
        jRuCycba9rXZfEjOpyLPJNhrf+j07PM=
X-Google-Smtp-Source: ABdhPJzodIm4Wv4TeNnMb69Y1YFA05k0IpGH4xWCaTgvMZJm3lc6OQI/4VSUEY8Mo9o8GlprPfU1Aw==
X-Received: by 2002:a17:902:a513:b029:11a:9be6:f1b9 with SMTP id s19-20020a170902a513b029011a9be6f1b9mr15791555plq.55.1627337495599;
        Mon, 26 Jul 2021 15:11:35 -0700 (PDT)
Received: from [10.67.49.104] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id x65sm455377pjj.57.2021.07.26.15.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Jul 2021 15:11:35 -0700 (PDT)
Subject: Re: [PATCH 5.13 000/223] 5.13.6-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210726153846.245305071@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <58165ea7-b682-c657-d751-8538eafe790e@gmail.com>
Date:   Mon, 26 Jul 2021 15:11:33 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/26/21 8:36 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.6 release.
> There are 223 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 28 Jul 2021 15:38:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.13.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, using -rc2:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
