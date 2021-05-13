Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73EC137F27E
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 07:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229780AbhEMFLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 01:11:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEMFLo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 May 2021 01:11:44 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53FFC061574;
        Wed, 12 May 2021 22:10:35 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id s20so13740613plr.13;
        Wed, 12 May 2021 22:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=56VEm54xHwLY+V2BDVpR7DE49CWhm2QXUVKfxbVqbmU=;
        b=EVWxlZcQgucAlHKQ0JzQLugTpUVTkU4MjYiATSIULsBHn/gdvkWCxdvYTQybstZ+nz
         GLqbZAExo5kyr1g/b25BB6f0Z2PMNKoPlGy9gc1HuthJ67SB/PogfsHlpyBgYsvTVlJo
         SduS4Aw7mvkDZt6DM1HfQQi4Oy1M3lS9r+Djkj6+Lsm3y/4WV9x9YxupWJ53QlT1q+zA
         Sbs2jFMgV2X7ZRy7IWuhdQC5aeZ2oCoZ/NQnIwX9sbhe7rt9Dlrnxcudkv2r4FJKHgJY
         7XSvwtinrcyN25g8Zk7beemLAkgKxUeYx6+jitqR6seTiSzvFbpFPrHC9TtpPIjibvr1
         YeCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=56VEm54xHwLY+V2BDVpR7DE49CWhm2QXUVKfxbVqbmU=;
        b=hnorBPxbXOZhWgs7FXnHmt9vcyGLfOmMKMEIC7DQmeOxji+0rQS2PnvGPygVyQfmKS
         PRVIfUI5cm2xdXtDsNSr69bfEEpzh98TwsryPg0YkokWhxJ3VxS+QH3QXmyEYM7tNSrU
         un2emVqg+iU/cVATkblolxTgNRgUlYwu9Gg1/blsH6404CQypovMpsINLoV0xoQ88RvC
         LajUg+suM0x1Us6O84KUk/Soa/R+8pGAQGFOtRNQQdgvH4fBRnmtlb1qsh5POI32og2E
         qUXVLr1wOwGv99NPherzMMZkLfZGACZx3gmcE6/5GzHSE7vgChBk9AubeSP+d/bzWp17
         a+lQ==
X-Gm-Message-State: AOAM533pkXzKr4mB/CA48I9HaPFUnjr5kH6n7DXyFmjaCzEYk0oCo611
        4y0bKTSO8MoFP9vIfPnXXRWtcu9kRn7Axw+YgTw=
X-Google-Smtp-Source: ABdhPJz0VXbp6+ENBi+lH27ELYAQk68vDa+CMveXilJQM9T3Z12VGwghMFyvK4QRBDNFgzVTVx8KjA==
X-Received: by 2002:a17:902:720c:b029:ee:f427:91e9 with SMTP id ba12-20020a170902720cb02900eef42791e9mr39087103plb.72.1620882634920;
        Wed, 12 May 2021 22:10:34 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id a24sm5761320pjh.19.2021.05.12.22.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 22:10:34 -0700 (PDT)
Message-ID: <609cb4ca.1c69fb81.f3abb.3fdd@mx.google.com>
Date:   Wed, 12 May 2021 22:10:34 -0700 (PDT)
X-Google-Original-Date: Thu, 13 May 2021 05:10:28 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
Subject: RE: [PATCH 5.11 000/601] 5.11.21-rc1 review
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

On Wed, 12 May 2021 16:41:17 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.11.21 release.
> There are 601 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.21-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.11.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.11.21-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

