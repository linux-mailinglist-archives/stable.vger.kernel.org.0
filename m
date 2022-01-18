Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2BF5492C89
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 18:38:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244158AbiARRi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 12:38:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244133AbiARRi1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 12:38:27 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5024AC06161C
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 09:38:27 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id a5so13653140pfo.5
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 09:38:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=QJWd1khAstY0x93rwrGIBjaegCyTJ/dAFVARXocXpuM=;
        b=gC+QQkDkloGrkehE2AMrT0DqlcBVU9Xuf5Clh9Ncc4QNmFi94txNhGoQgEPmZqoO/U
         /cP2aFWN4GSSuqRvBsncAnzkC+XipwdPUDVgyptM0Lb6NaQA8bP1Jj5fz9JP1OzvERe2
         Mj9yGxAqkHGz1wUafQ0ySCnc1zgBOBZDm5lt1tLTcdSswcCuTkDKeqWnxst/UuhazoUK
         m6c+Pkj6XS8Iuxn9AScFMnHC4XXse25nb+qu+qewCxZwBOHQFKAaU1MsWW7oU4yPE4no
         edUYMpKqO0a8kSP+PIM0l4BSQs0zipiguELuqzPiO4GI64PAEOlOYmCavasO+e7vc/z+
         RoCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=QJWd1khAstY0x93rwrGIBjaegCyTJ/dAFVARXocXpuM=;
        b=u7dgHxJ7RGny6z3pmsDSu6M28gap4QXZvVEMUYSYSnJiTrzQvmAOMRW8IxZlD6oDvI
         Jakei/10yh6f7ZWWTyES8Jj4rAWc8UZg7L3Kf0HR/HdZPq78JtdEt1iOVEvmrWfQ2QSG
         5/DNl+NTOKVJshKhbqkXCxE18oQBkagL3CFlEmvVbgyW+DoseHRVF8hlTEeXu0ZQXm44
         XQ+AsW2VMTM2AWItPrWqu9gICkpiWDq8Jd8tuNMTBipACKSjdCr9u1akI+049EQz2mMJ
         cp0Km6iDI3Yhog8p1I8YTkfLRzOz1GUy3gzJTM7/N/a67d6TeuKU5KzOYsfTUtNpr3Rk
         R8Yw==
X-Gm-Message-State: AOAM531MR5ZIGK5VHaUelINq2v+f8J0nWyTJOQELNJbYUNjQysxf/Inf
        dJEi7Phjz6+TrNTxx1sTInuW8g==
X-Google-Smtp-Source: ABdhPJy1yhVOt0VFuq/zcJmfQrui2AtwBnQsidJlo3pCchU2ZsEk0dHXMtBmmLUbecfrle3G6icG7g==
X-Received: by 2002:a63:6b46:: with SMTP id g67mr23965410pgc.482.1642527506841;
        Tue, 18 Jan 2022 09:38:26 -0800 (PST)
Received: from [192.168.1.32] ([122.183.149.79])
        by smtp.gmail.com with ESMTPSA id j3sm2704439pjs.1.2022.01.18.09.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 09:38:26 -0800 (PST)
Message-ID: <96ad6c6f0346c466a7e65ef93bc0a072cf6de10b.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.16 00/28] 5.16.2-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Date:   Tue, 18 Jan 2022 23:08:21 +0530
In-Reply-To: <20220118160452.384322748@linuxfoundation.org>
References: <20220118160452.384322748@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.1-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-18 at 17:05 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.16.2 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Jan 2022 16:04:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
 hello ,

Compiled  and booted  5.16.2-rc1+ on VivoBook 15_ASUS Laptop X507UAR
.No Regression  from dmesg, except an old warning
 
Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous
