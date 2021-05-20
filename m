Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE2738B129
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243310AbhETOK4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 10:10:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243905AbhETOKA (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 May 2021 10:10:00 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD162C06138A;
        Thu, 20 May 2021 07:07:35 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso4714962pjq.3;
        Thu, 20 May 2021 07:07:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WHenRI2ddGm4OY+8yUrmHOAW4Grwa2o2iMUUu3tmcd4=;
        b=qK8LqC/+/idRQWyEJXQQVSzpQtSdtzGRuHy9qk++TsJf7VOxoTTzDIt+s4mzRpTjXy
         0tsEFdLn72WXDrZrUreVpk/6OJJNiUpPwyc259CiQe90Q7nUYa2dVHKwUqCiTe43ndU2
         jAXiZgUnBuRgB7fLFT+X53RJJLlcMJdX5hEcxcDU9Xy6q33PBgFowttZeBDj2mq0YVHX
         qU3250MZK4aMmfR9h5gbthtfviSHOUcvyGo7rDoZQ9vyKRd4/KiQ4dWxRJH+Efxn4++0
         /TPiP7YTqjERLFX3trkXkdb4aYwa+pHD6LHDqUJLl8Gnbm896PO+tlFKM/oq39Y+dzSA
         5xHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=WHenRI2ddGm4OY+8yUrmHOAW4Grwa2o2iMUUu3tmcd4=;
        b=WCvDaxnrBnVwHW6WB0ht95oJ9Nn4iYMYPnDoXMxltRgf8KdR8h6dM79Ors2xSI+38/
         0htv4QkyOtapg20U1WPsy8aGG+mynu6lFKl81cWrpUnrq6HX3QhdduOFgtEqzdGuHNbT
         BR1FbxoUGgsa6QZFVrp0VK/E8UMG2qBYf+zcdoGjHUEZ5Iw5yTxHUIrqEsWvwmDa7aJM
         vftf75SM5L0F2sEj7Bw9dV17HKzOxqstk5gvhNN6U+48fbPtmjjNylMecdBiXr0yg0dt
         7FBu8RocAP833fOYnWKYqaeSAF/3ms02enjhlLquX8zOJmqhhjXOG1rUrMBxWmgekPYC
         xrSA==
X-Gm-Message-State: AOAM5329draQ+jn1yOQkJpZZiSeSrAmNU6TWJFrGAWUOAhut8PL7rVHg
        WSG4Y1FmJxD6dzz2rsW3t366B2J6uwXYRxBc0kc=
X-Google-Smtp-Source: ABdhPJzRiTKiHbi+57XIAC/XXmhsMKQm6/kV4++5/tbtyGvbZcuXTr0ljTqz/2fnfT8c1ajTSn2k/w==
X-Received: by 2002:a17:903:3106:b029:e9:15e8:250e with SMTP id w6-20020a1709033106b02900e915e8250emr6049873plc.33.1621519654806;
        Thu, 20 May 2021 07:07:34 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id w74sm2063265pfd.209.2021.05.20.07.07.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 May 2021 07:07:34 -0700 (PDT)
Message-ID: <60a66d26.1c69fb81.1def6.6ee8@mx.google.com>
Date:   Thu, 20 May 2021 07:07:34 -0700 (PDT)
X-Google-Original-Date: Thu, 20 May 2021 14:07:32 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20210520092053.559923764@linuxfoundation.org>
Subject: RE: [PATCH 5.10 00/47] 5.10.39-rc1 review
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

On Thu, 20 May 2021 11:21:58 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.39 release.
> There are 47 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 22 May 2021 09:20:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.39-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.39-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

