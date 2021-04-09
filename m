Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A92A35A7E5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233995AbhDIUfA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:35:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233916AbhDIUfA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:35:00 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DDAC061762;
        Fri,  9 Apr 2021 13:34:47 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id b17so4784447pgh.7;
        Fri, 09 Apr 2021 13:34:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sPQDU1XhodcCWmDECE96WdXEWbGwhAYthVhlKL8+9GA=;
        b=o0zmPiKb3N822+O/M0LV1ig5ViiXafrGGHazaFuQHJvYUsHOjpP92O1CzqQEspaC39
         c/hJK3Q2LPn+flNLET7aD/LeJUbLjtor8wDnk7O7bJMVZcyukgC1BOFg5LTnZmObYnys
         jZ/TtRyoF5Yz2UljfYw6o0/eF2aQHjAJfrLL4yCNVSxHZNrrPGB92xms4pMNMbULJGsR
         sBfnPJrlakkXT1z4W4lBCgmrJh/PKwZY8dAqhlcie8LUnFqDmG0RsRKAGJs3LKCGfftg
         /paLNW8X5Anhl3U74DHideLuTWja9x+ANzg2fcUcGJy+y/M94aFcrablS4Tn+uZDI0hW
         hwPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sPQDU1XhodcCWmDECE96WdXEWbGwhAYthVhlKL8+9GA=;
        b=L0NbTNJTuucwsOUw+q06QUE+FfLI1QeQzY+qouF7mAkbGyBaTuFbL0v+3K3ZEmqqFv
         4zgnYuEOwuNWfLibxvDSWTtAvDL2z5ssK5AaxY8sxfGwnYPs14L8kKXzob70E+Tr8ofx
         WPdFEMVdsvmP1rao+94IuIqSgg/Flzqs8IsMSJhiJkTN/5Fuy2Z/+eJnnptWix8RiSqJ
         7IF4nKPn/ONXFve+LD7tHYrIcwQ8NHZG6EBBBn9DXtVI182KklGUxi8hKur3zrQ3tMVc
         izc0aRbz66sbH4HwoD5LjUM5rxgcJcLyo2zEI2YGnz/OWE9n7Zom+n7dbSXBd930PAAG
         tSoQ==
X-Gm-Message-State: AOAM531oPwf9TYeZ0u3lKYwAXWhxBLgicTAOwYTQDdlfZN4go2LQeWaP
        Bf9KgvM4+SPJdsIgQtU0HF42XMBrRgw=
X-Google-Smtp-Source: ABdhPJzXVX/2kGlxTXOv+YFBm2M0n/3LVjbGI2lZV+eXe6737jYUTiVBBQ/SYLM8dlhLR+tVVLY1Mw==
X-Received: by 2002:a63:4c4:: with SMTP id 187mr15106872pge.187.1618000486263;
        Fri, 09 Apr 2021 13:34:46 -0700 (PDT)
Received: from [10.230.2.159] ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id l18sm3015291pjq.33.2021.04.09.13.34.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:34:45 -0700 (PDT)
Subject: Re: [PATCH 4.9 00/13] 4.9.266-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20210409095259.624577828@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ac2133de-f528-b59d-3d74-31b0996df402@gmail.com>
Date:   Fri, 9 Apr 2021 13:34:35 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210409095259.624577828@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 4/9/2021 2:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.266 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.266-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB, using 32-bit and 64-bit ARM kernels:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
