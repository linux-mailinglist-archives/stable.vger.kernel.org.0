Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B662D69B9
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404847AbgLJV0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:26:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404827AbgLJVZo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:25:44 -0500
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AC20C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:25:04 -0800 (PST)
Received: by mail-pf1-x442.google.com with SMTP id s21so5330111pfu.13
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:25:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=T0qHaJxQItRcBeQuTRGLu38MgS/WWkEnPH3u4lvek6s=;
        b=IsmX5H/i7INq6kiNroVXSQ97M0pVLPUwhmwVu5ZzrDehL+H7ypeoSFEt2oOAG5Ugwk
         y76OwYVXC64cAFtyFPLKYk62L8JYkDQdoojFd6YNiGpVU8LuXLOlK0mtzZO8izxSzSac
         SOleqhoqblc9SoG/Uv00Kux3I0umHQphZwLvfFAjis93/nywnTH3KBAlNjHzSvkHKSlA
         f2wUQvn/hBSR5wAL/8HTfJt/dxGbSh4+Cz+rU/aefta9VhuloXvX3SKU12pCp/uE+dN5
         lX+Kcpn5bsGrsL2i1YriwLsmBB/GvqJM6HuENcMg/f50TMEIj5oTnll4C+ieaU4Cz/2j
         Q6dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=T0qHaJxQItRcBeQuTRGLu38MgS/WWkEnPH3u4lvek6s=;
        b=t62pMjRJp30wzBzbp7+rC/aHcivh7LZpMGeoM03kT9kwSoHyNJ2ZeYHuf4dfO6xjaS
         +Edv3vAe2hlhgxIqfLMEAKZoD+Bs04mpeM80c48+WuF5XPjS2x/+EYk5ZDCkxYu7C6Ud
         5wyW10h6v7J0tXIrrxpzmBTWmQ1G/7qMDwxXtdXbJHv2xqAPVl+otFZvcdZqixE1aI/9
         dv7BDjSty2jiM4v1XK00jFj6+LBKlAU6mTzHnnfhgxEoiDFFeI1dVZM3lrlFeyPRtPRV
         fhdq7gWX4NNSaCiVaBgWtMfeac79K8Ki3hSldM5Nh0nAINhfspX8Wl680Jg1gx7RTzfG
         e4rA==
X-Gm-Message-State: AOAM5338cfxQ4uzUnbvYUvH2thgFthzu4jKb65DqNDeJvG+EZoA/RNnE
        tqHzZC9VVVAzEO6GNmpg9VPS5w==
X-Google-Smtp-Source: ABdhPJw1I8C75E6Wv7HJhkwI1bJWiPs1xBvCUrmkn47DoPZVvfQxSVQ8biidbzUDrhKqSQUI3Jxp9A==
X-Received: by 2002:a17:90a:1b29:: with SMTP id q38mr9545188pjq.223.1607635503841;
        Thu, 10 Dec 2020 13:25:03 -0800 (PST)
Received: from [192.168.0.4] ([122.174.195.73])
        by smtp.gmail.com with ESMTPSA id j9sm7171772pfa.58.2020.12.10.13.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 13:25:03 -0800 (PST)
Message-ID: <8c81c3d9e115976a2f70b148211c152b28ea2696.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 00/75] 5.9.14-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Fri, 11 Dec 2020 02:54:58 +0530
In-Reply-To: <20201210142606.074509102@linuxfoundation.org>
References: <20201210142606.074509102@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 2020-12-10 at 15:26 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.14 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Sat, 12 Dec 2020 14:25:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
hello,

Compiled and  booted 5.9.14-rc1+. No typical dmesg regression or
regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>


-- 
software engineer
rajagiri school of engineering and technology - autonomous

