Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC222D0740
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 22:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgLFVI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 16:08:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727828AbgLFVI5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Dec 2020 16:08:57 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8CCC0613D1
        for <stable@vger.kernel.org>; Sun,  6 Dec 2020 13:08:17 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id e23so7123895pgk.12
        for <stable@vger.kernel.org>; Sun, 06 Dec 2020 13:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=GXO966ED6tQiuIi8XWRbC20Roa+9X+ISK1xYWdljls8=;
        b=fgrZALlk1iIYafdU6BMq3PLhWjGwBDY/LRN2cP98OkxIa+++nB/u6ZD0QszXr5HC6O
         FklRNEdbzQOvYIy4jMqBJA+GZV3j7kKZx7E2pBr9e9/v2OQ+0r2ouIR3ZG4Gdvd3bond
         hRciyVNjrLriM3R7+kSfux7rKpdKffnTGmYPM+OcXiYWdzilYS0QaZ0RECFpS/bRx3i1
         2rVKGo9EkJT1f03zYuSTt1hGSNgg4xDW5R9+kZwQ38vQrt0JP1CIpYupn1jK2v7knudA
         p34pbP768lp29swtDiGSyF3zlmTEe67DAHPDoWyHThye7WvElDlMrjrzGcwpI+N5PWTc
         AIYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=GXO966ED6tQiuIi8XWRbC20Roa+9X+ISK1xYWdljls8=;
        b=sz/z0x31hy26gQ2Oty28BFAB2YuOwM9cNgULkmhXT+vX/dDPYSGU+Ww+GWvjNb7+9w
         PtQ9lPHfAhV6VB/MEIiwwbB13YOYaVgq8/HlaWiDulAdo2jnMmg/vQp4ij1sl++pSh4i
         cKB83P2gcmtxqoQhfVRhwGqF4dWolKDlay3o1fbKTJlaxJrHlRjWa15VBa7ZsGdFpOFm
         LAOXbdJAaZiNNIonl2ezBnBOrXXPgGqByRWumnpwig+OyyErc0QzFW0Kkt+OZF9ecXip
         yp/RTyfyFaaJI1UQ+OZGzn2uL2dm72FHmASv8pk+czigvSS6F3IK+wKl+aDLWBm8IPbG
         LFkQ==
X-Gm-Message-State: AOAM530kcT1tqWHN/bFAm4dUDQQzDxQ/Ds6Ii8nKXnJPFxBc6LM0ltfi
        KMPIy4Itgy6DLxRA/Ekvrtaclw==
X-Google-Smtp-Source: ABdhPJyjh0V0kk86P2rHPBVoc4VQss4mcyorZdZU8DYcfDgeG2V56uRbZ0o0bYMGFs8khGQIGnbwjQ==
X-Received: by 2002:aa7:8f09:0:b029:18c:4cc6:891d with SMTP id x9-20020aa78f090000b029018c4cc6891dmr13177556pfr.46.1607288896791;
        Sun, 06 Dec 2020 13:08:16 -0800 (PST)
Received: from [192.168.1.9] ([122.164.22.111])
        by smtp.gmail.com with ESMTPSA id a21sm8127596pjq.37.2020.12.06.13.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 13:08:16 -0800 (PST)
Message-ID: <b519bae35dfa11de0b22d9bd35dc780d796d5feb.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.9 00/46] 5.9.13-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Date:   Mon, 07 Dec 2020 02:38:11 +0530
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 2020-12-06 at 12:17 +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.9.13 release.
> There are 46 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Tue, 08 Dec 2020 11:15:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.9.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.9.yo
> and the diffstat can be found below.
> 
> thanks,
> 5.9.13
> greg k-h
hello,

Compiled and booted 5.9.13-rc1+. No typical regression or regressions.

Tested-by: Jeffrin Jose T <jeffrin@rajagiritech.edu.in>

-- 
software engineer
rajagiri school of engineering and technology - autonomous


