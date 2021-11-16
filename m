Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C96453AB6
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 21:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbhKPUNt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 15:13:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbhKPUNs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 15:13:48 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15B8CC061570;
        Tue, 16 Nov 2021 12:10:51 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id x7so412041pjn.0;
        Tue, 16 Nov 2021 12:10:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KdcGOkW+vODS8YjJzlYB6MaeKscu9R51SItMSFekfDo=;
        b=Cqakr5q22PEsv1mYPMx5IhDnCTuaT66Pe18hzLQHoYmZrR92ryLCROLAKneNy8qJh9
         QUvWrcV/B9vrdM5prZY4hgfXebryh8HZ58/Vdt4uD46BlhXlYl4ondn8wglJmH2Dh27M
         gCl65XqtFMEPRCTemlxChTsILZ+Y0sFbeMQIY2HCqrPPnEOSkHQUU7YVJY4DeGopGMTC
         W+nRMiZKHU/AWk1rG+3MZMpu6tZ63C+AoIC/OTBv3EZYC+pgbeifdtGV6UrevZVBycQW
         +s17f5R3eLuxdoj6OUd3Mgb5ogv/UEbUCi/r9FT537lg18KIOLgHq9h9h/IcJl3oe0Fo
         EfNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KdcGOkW+vODS8YjJzlYB6MaeKscu9R51SItMSFekfDo=;
        b=pw3qPX+0rlxBmuYNE/Eu3y6LnkF+Ig5P6e9yDdBgiPr4ZdSWTw6pJ+AkoUARvdPNgc
         HaU/Bssbd2auxOaufZv50xmrCD4+/g+9vMlFDk8wlUS5xs7z8ftYDVDA2tXc1rmV+6Sg
         3OwlK9Viw74znJFceWL5CjQCk/tSXu7hOA7jDLiYCsvtiPZrd5U/ghmyg2PQu4oX48i5
         WRzQTeUy4enGIQqW9u9GThkaHzZJ19HUkdw8fc1sZQB1tQinXK++XnhyL9SBgfxyZHpR
         sdQQtLxt7w1DA92XZFnV2ITVizhPiE8bk7g+sXmI5f73kqCdJ0/qwFTAy5SDIa+AyEyl
         UZDQ==
X-Gm-Message-State: AOAM531gHxyoTT6yFVpOyrC3UOKHv8gbabgWyP/ePfBs8gi4WHnU+bIo
        qoaxwjf+iz/YhuFVYiqKv8gKSma1Hio=
X-Google-Smtp-Source: ABdhPJwRUAki6YPlTb9IjyoV07ezFARDZ33fMpjSU6XIOFlfp4/i2KIiwY8dVXgNC1DbFlWLOsA13A==
X-Received: by 2002:a17:90a:312:: with SMTP id 18mr2345541pje.178.1637093450191;
        Tue, 16 Nov 2021 12:10:50 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id q10sm2523564pjd.0.2021.11.16.12.10.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Nov 2021 12:10:49 -0800 (PST)
Subject: Re: [PATCH 5.14 000/857] 5.14.19-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
References: <20211116142622.081299270@linuxfoundation.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <cb957d8a-8afc-0d65-e40d-209781925501@gmail.com>
Date:   Tue, 16 Nov 2021 12:10:48 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211116142622.081299270@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/16/21 7:01 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.14.19 release.
> There are 857 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Nov 2021 14:24:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.14.19-rc2.gz
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
