Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F2A636FFB2
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 19:35:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231264AbhD3RgR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 13:36:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231178AbhD3RgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Apr 2021 13:36:16 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2CFC06174A;
        Fri, 30 Apr 2021 10:35:27 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id d14so19726190edc.12;
        Fri, 30 Apr 2021 10:35:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=tPDS2D22rwXWws+Y8XJI8512tkIXRC3MZ9HOlTsZiy4=;
        b=U3439mmhZ4Ak97M5/Ia+jb+TDAGWJ8Hsfg5z5FcnwSkdo+ACQQezVqzs7b4xjNetG0
         VGW/jgBFgO1X0PG9Ap5wM5c2/vUaLPJwoviCX5PB6TZWC+kRvpEvf3sAjdP/Sq9h4J5+
         hsc6SLDJE930DbyQtXnu9TBnJYZztIihzp/A7PxpnrBD1hua1g9aEb/bKp0kZ3D49pP8
         +/1FP82veVYLhwoLoClCxkfHa9JoHwktZMqo6mbvQKnQUkiyfOEBBnFoMd4GQ+nxvnv8
         0DRvWwAZN/2bSCMmWed7bH8MZSG9onPQdRco3NGDcyeUbf/GD+DQVUCIzf2rwfzXbTAb
         Zj7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=tPDS2D22rwXWws+Y8XJI8512tkIXRC3MZ9HOlTsZiy4=;
        b=BcyI0KH8yMkk8Tx1XQFd+PBJ9LJB/5PBdildrnyiA+JcWvqtz5vyRftCsNdC7+yo/g
         2tA0ldv/SollGnAuYNysuopkIZ7h9wMnhZ81gUgs/ZuRhWTzDSqNOmjraZ2sTgjxPxVf
         sqvKM0DjDSRD8Wk2SEs93WFI3U4XplOH9E4Ucu505PH4QY04uE1f2cokr4DkaxkLL5nJ
         diAMmUewMJRlpQuof9i/X89Kz6/TQShnEjxkqiN74oPBBDMmMbb+p9VdBRfYxpNB121a
         TECM3mGU+wuZId3yuG6zE5VATI/A8ldvElfBH0bhWPFbv6Pueqeq+2I49tM2pYPJRJQ/
         rzPg==
X-Gm-Message-State: AOAM5332a/yrQd4sc3rsd+oz5BG065Nfxfb2Yxo5hOxFormJpqKf3KXt
        rsjy9sBKRLqgZz/zWQopViF6294FEITRoGbw3G853Q==
X-Google-Smtp-Source: ABdhPJy1PMHuKFQxpWi7H0OYElixThscYwv46io+aKS3XWP/mqP5uxM46xSTw5eY7aoyQ+S2Dli0fQ==
X-Received: by 2002:a05:6402:144d:: with SMTP id d13mr7433488edx.101.1619804125726;
        Fri, 30 Apr 2021 10:35:25 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id v26sm2463444ejk.66.2021.04.30.10.35.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Apr 2021 10:35:25 -0700 (PDT)
Message-ID: <608c3fdd.1c69fb81.6db8d.7b5d@mx.google.com>
Date:   Fri, 30 Apr 2021 10:35:25 -0700 (PDT)
X-Google-Original-Date: Fri, 30 Apr 2021 17:35:21 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210430141910.473289618@linuxfoundation.org>
Subject: RE: [PATCH 5.10 0/2] 5.10.34-rc1 review
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

On Fri, 30 Apr 2021 16:20:41 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.34 release.
> There are 2 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 02 May 2021 14:19:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.34-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.34-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

