Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B0F402CDA
	for <lists+stable@lfdr.de>; Tue,  7 Sep 2021 18:30:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245162AbhIGQbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Sep 2021 12:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237074AbhIGQbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Sep 2021 12:31:47 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00F72C061575;
        Tue,  7 Sep 2021 09:30:41 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id bg1so6142124plb.13;
        Tue, 07 Sep 2021 09:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=0uCU6jftNqJD3l39b7qCaEfL2/1m28WxrM//5n/3W3s=;
        b=afjGTzGwr4FJjD3Hh7/H5qgamciuBnZ+yQ7xQPeceIIv68BwzaS5uQx8rHnwevS6tO
         Um16OG8RSxyti0i8RucXLw9l0U2TPfLnQcoSUFzXPmelK/EpBsEtCbU4qb65PqmxtEsa
         5XSSYpiYoxioOINPhSNz/aQhRVGGJ1wv0miGQ1WpqOvYt6qUaT1SdbhFotwW4RsbGVen
         UhR3MZp97VgArDvNTviA5BzCnsuScQGL6FBVoIBFSM1MOzweJfqKYaoeS3QTHMAqiix3
         ktWpgYVNXpC0s4W6GT1RbS0gJHWLpQOeNQindsdY2qq7wMSyG9Z1At8WdFYFjnR2wtcZ
         Accw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=0uCU6jftNqJD3l39b7qCaEfL2/1m28WxrM//5n/3W3s=;
        b=NGq9cnlk1MnviWakeBhEXTyJq710gBe+Czb4E1cdQlitvLuKkaIDlO3ybt6rFWawhD
         fbumEv/Wz+KHIF0vRpOpG/pTg7E5OyCxylkwUpzcyIU5M79yBv4Rv/yJPfjXbgHz4Rwx
         nXjomww/83EdaS8cCnPpKysxSCJTM13NQriLGLN+Ve3xD0F2BOMVFi10eJDJzNyYtwDb
         IppqfYVSBqWM0+B+95/MAjwSJU40MBYpZ+KKzfQn4gLKXzq6/+O5TdHx3T1rZZLM7Ru5
         TO91rdBS/dL/y2diYvdO23PRD4l6ALf8PAtTujnaXumpXtLewUd6k93uw8v48RDlweNi
         9bpw==
X-Gm-Message-State: AOAM5331qoKvIycGPshhBE1qnM62CPar4N8up4dl/4bbnEWcC+mSVJ+N
        4N0rH2Ax+zW4fmbfeyz5A2Za0yFg9tk=
X-Google-Smtp-Source: ABdhPJxxKdi2yxkEci5oG+JTEc0V5aR+NAxNICfIWQYWGhBGO1R/g09kxw9Le7/WbS5VSkJD4M8NKg==
X-Received: by 2002:a17:90a:de04:: with SMTP id m4mr5381482pjv.187.1631032240447;
        Tue, 07 Sep 2021 09:30:40 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y1sm13067154pga.50.2021.09.07.09.30.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Sep 2021 09:30:40 -0700 (PDT)
Message-ID: <25f6625d-7157-20af-5de0-c2b56bdf1c71@gmail.com>
Date:   Tue, 7 Sep 2021 09:30:38 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.0.3
Subject: Re: [PATCH 5.14 00/14] 5.14.2-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210906125448.160263393@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20210906125448.160263393@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 9/6/2021 5:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.2 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Sep 2021 12:54:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.14.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
