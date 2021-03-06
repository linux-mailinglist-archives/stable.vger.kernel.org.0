Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D46F332F851
	for <lists+stable@lfdr.de>; Sat,  6 Mar 2021 06:18:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbhCFFR3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 6 Mar 2021 00:17:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbhCFFRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 6 Mar 2021 00:17:03 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0DB3C06175F;
        Fri,  5 Mar 2021 21:17:03 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id c16so2463774ply.0;
        Fri, 05 Mar 2021 21:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cErAmnOra7kRX450Lrj5VD5Ge9IfSo97gVGl7j0r8Jw=;
        b=p9I5FTk2MN88XacQMMzfhBgOYaQJRhgRbwqYKUxsUhRgCqapErjum3BQ98Qj1HMFiz
         8vdzYiPiU+N7ySE9Vh9o4ySwvc9/+nGceshudA1q7Hf6V0D4rnJvJ60PSJzlX0UPXKc2
         YXmMuyzWlSVfg35CoRre2uoymVxa1CJ4Z9E2H9nSsw6FXFv19ULFPRUYgQQ5S9aqzUBJ
         2aEI4ZFIixTYc5E0hL2Bil1pgiHTT3PXaQQnrP2NSlw9W80tvGFBF3WLHXqWPQZfEvsI
         YNpBgJ7c6LaHCJfjJDMDwghJT+DwH7PqmjK2MjEcayrIbrCJnb4CxayrsK+wiFuk/3Is
         qFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cErAmnOra7kRX450Lrj5VD5Ge9IfSo97gVGl7j0r8Jw=;
        b=k/7LeySC13j9f0aZUBulXiIUtCt4QKEebWAzsZNOpQdrtN2Yp4AFvvi9wpGNT+5bgr
         T31+Gt9hszJFpIoSpvukNRGZ/jVZULoy+cOb5WlROtVNdjL4/E7NOP9Eo/bpKwrd2veH
         fRaSlKWDpx2iED1mqvfc+SRMT+N9PUwSo/HMbAM+o0MIzplXybA7YBh3EPIULJ3LJpmu
         PjRzwz61oyFR4sKg9H8HhbmrHkTMtcGLfjNEKgWPaGui6p+pfQplLg9DAw1DoZHAXgxD
         W0D4Jqxcx+sLb5uTcxhldUB4uHhJr53UkMF0onBprxTY9ikGN38PSroke1q0iM7gnTWt
         zkyA==
X-Gm-Message-State: AOAM533SoFLI8Z78X753+HG+WNQNo5m4OknT+vkkTwMvXeklz9YHGgFn
        FVi7SXfLVSX4ELADLib174qxuyEcP2w=
X-Google-Smtp-Source: ABdhPJyHbqjwRbXfOWubYLVkl/+97bZ6UXdYtUo5LO0Zy9Ez3IPmnnH4A8v+2ctjFMvt2n+WGZ0qbA==
X-Received: by 2002:a17:90b:806:: with SMTP id bk6mr13818884pjb.16.1615007820670;
        Fri, 05 Mar 2021 21:17:00 -0800 (PST)
Received: from [10.230.70.25] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id o1sm3676438pgq.1.2021.03.05.21.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 05 Mar 2021 21:17:00 -0800 (PST)
From:   Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 4.9 00/41] 4.9.260-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210305120851.255002428@linuxfoundation.org>
Message-ID: <64442e2d-c0ef-2400-a9d9-039b264ddcc3@gmail.com>
Date:   Fri, 5 Mar 2021 21:16:54 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210305120851.255002428@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 3/5/2021 4:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.260 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 07 Mar 2021 12:08:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.260-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian


