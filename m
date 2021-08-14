Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B8B03EC374
	for <lists+stable@lfdr.de>; Sat, 14 Aug 2021 17:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbhHNPI7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Aug 2021 11:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234654AbhHNPI7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Aug 2021 11:08:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7255C061764;
        Sat, 14 Aug 2021 08:08:30 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id j12-20020a17090aeb0c00b00179530520b3so4803956pjz.0;
        Sat, 14 Aug 2021 08:08:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=XMF/oNxkox6j6WayZ+IvJ9qMAcyG7XB6Wyw1ESeG0qQ=;
        b=W8NJnlsuR4vVItclEtfC3bdt/EfrfUesqBYbuFoyESW3AYsaXuZ6CqMEUgZZTMCj4r
         uiWYkwFEKu+mgaATS7yvZXO1sWuuqyI3++tmgImonXm4jF+i22jdyxPzox2hgXDyh30S
         eQ0RA3Xh4djqE6zFsLxel8iXN9r47FCmkgcTtui34xaUQXp2o/A1FyBz5Bx6Byzw2J8x
         60/am+8PzKPMt5E+T8l6QIVB1KxB87GNufPMBGa8+OSQXVSe/ta10P3bEqGiqX9XA2tN
         u38ES2tdhqMNfzhfBjOTLOiLEvHPSpHtB5xkGBMsjUXPJmzFv6KFxjNpMLrtfa7hqbt9
         HTYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=XMF/oNxkox6j6WayZ+IvJ9qMAcyG7XB6Wyw1ESeG0qQ=;
        b=dUJ4bWWIWjlwklukEJZKBR0AHHjebjXdFytsld51feU3L4H//DTwvhtwyDjnBQWoip
         yZatkEyFNZG3n8Bv713uLWLldr68a+icuHjzahajBfQtVtzg/3KDEXH4lcar65j4ncGo
         Vwa530A8ZcE3zeSRmGUO85EgRkpdVSs/qQy5AeoVAUXio1jillYl3BhQcUpTVzJbSQCt
         XeEjTLlLE0mpRp1yLwFekLl3rkozagPPtmxbwQ/t1e9o807L3m/m7dDUNSkWmkwxzZA6
         gutA84+8TLWHNc2BZnap9Rxcq0GwdGeBnJvX/cxNbiagLwhIAO16G8NoawnA22jTVwLc
         v/QA==
X-Gm-Message-State: AOAM531My6+rQyn9dQymsnB+RYMmVJMs9ApdfOahaV6PfEQ0e+5Eh1Fd
        7P853l/CNbfg2NCpVBUKcNJFCgCSTCdwEwYd27Q=
X-Google-Smtp-Source: ABdhPJwNMDQB/UoFIwgMd4qbDX3QCxFfZkd7lijbKFQTFDb7LLpLW+Saq/ZqLLRdXXi6Oyfl2f4pyQ==
X-Received: by 2002:a05:6a00:ac6:b029:374:a33b:a74 with SMTP id c6-20020a056a000ac6b0290374a33b0a74mr7566754pfl.51.1628953709870;
        Sat, 14 Aug 2021 08:08:29 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id c15sm5841553pfl.181.2021.08.14.08.08.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Aug 2021 08:08:29 -0700 (PDT)
Message-ID: <6117dc6d.1c69fb81.5eef3.ecbd@mx.google.com>
Date:   Sat, 14 Aug 2021 08:08:29 -0700 (PDT)
X-Google-Original-Date: Sat, 14 Aug 2021 15:08:23 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210813150522.623322501@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/19] 5.10.59-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 13 Aug 2021 17:07:17 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.59 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 Aug 2021 15:05:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.59-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.59-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

