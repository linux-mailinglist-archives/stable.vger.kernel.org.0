Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C043CC6F3
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 01:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230318AbhGQX6L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 19:58:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230259AbhGQX6K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 19:58:10 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D057C061762;
        Sat, 17 Jul 2021 16:55:12 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id i14so729172pfd.5;
        Sat, 17 Jul 2021 16:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=b2op3mkk2MCHF98+VW/bu+eiOjzGo/Vvil6HUQyZCWQ=;
        b=VFfmIVtkrb2cEfy5C9tlUBzKYbnMkAZIn2E7YIQ01hutPpexV+wDYYsgc2jspw5bvB
         zWliS21GYXV+XRlZnGlbgDagocjuQBjBDPDetW9bUFQR47l2SIxMlx7ILQ4jHuf/aXH0
         NHkCkowgpbMRnWokuSdb5UxRl0XAalt9WZnjQlCYETNNnSd0STU/Gqjb6eOadyDPZFjj
         9lQrqJF0TGiTEv9czMThKwRWqIhun97Vn+uBZ8nj3akdls7YmZstXOa+EMOlesfpoW+d
         ID7RKwlVGJzE1LF8RvIUEE3Amb9RRj1zcgOr6W+WZsrf1DQ9gp+Jt4MFVMjAsAFcit6J
         83Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=b2op3mkk2MCHF98+VW/bu+eiOjzGo/Vvil6HUQyZCWQ=;
        b=UDGn4c7ZjDYlQoYNnTcaUGznaL2lhMU876bhU/hKrnYQMQswbxn3lozSAoA2cpSaGL
         pN9+wcTumR9LXaTb5MLoiJb9gz4K74N5QGDRW1cvLxX82zzXg+82IZWf2QE/UAC2nfAs
         lRUkrFc9nWzHUuAPrtl39tlbaF4ymx2DdbkJ1LFnT9eH2pkG/1+Vk0lzbROQJeZs+4LG
         bzfTLl/BpggfkdDG0gBVgRWr/DJBNc6qveZ5jMvOH8wdGSZsZWuxLxP9m+xfKuigCuQe
         LbMRVvOXszwbeX5eZR2sJ1edIB7lVGMFbn5baDVECPmNeSI0DLM/Nt/TbyGVxdPSUPVs
         rUCA==
X-Gm-Message-State: AOAM532qiUbBgG/uCOVGEfDZenUY/vpnlZkCYZvAYtQjc8I7r3+Y2z5P
        K4XabVGAhwRxf2mpueoYk0tfL9Ew8SrKIg==
X-Google-Smtp-Source: ABdhPJxU29IYfmbPd7swJe3fDfkAHWj1PV0Nm6xz5iW7Gxt/WCREDy5y1hC28jPdBnmlIcWjesF3NQ==
X-Received: by 2002:aa7:9ae4:0:b029:32e:b1:78e8 with SMTP id y4-20020aa79ae40000b029032e00b178e8mr17800176pfp.46.1626566111463;
        Sat, 17 Jul 2021 16:55:11 -0700 (PDT)
Received: from [10.230.31.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o3sm15615200pjp.27.2021.07.17.16.55.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 16:55:10 -0700 (PDT)
Subject: Re: [PATCH 5.12 000/235] 5.12.18-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210716182137.994236340@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <71213f74-8101-e40b-2a24-79ab5db1d6ba@gmail.com>
Date:   Sat, 17 Jul 2021 16:55:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210716182137.994236340@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 7/16/2021 11:29 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.18-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
