Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1119B46B604
	for <lists+stable@lfdr.de>; Tue,  7 Dec 2021 09:32:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232950AbhLGIgF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Dec 2021 03:36:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232952AbhLGIgE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Dec 2021 03:36:04 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18EC6C061746;
        Tue,  7 Dec 2021 00:32:35 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i12so12754833pfd.6;
        Tue, 07 Dec 2021 00:32:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Pv4Kn/kXpuqms5hUdvFbWbbJ/CjSdzb1UQVcC4I7FOo=;
        b=pEvLhStOo/tODPkiZGv+Snpf+9MmQOahulOyGnOpuvqNN0hyy0yswfJZKZIpy7U4zq
         7S3TfBjTrCuiWD81gz0wUe3KuFYECMaVrk83bGoRhNd7vtECoPOhxofQyn6syQ0ceLZB
         vy9SZVVYV73Ee8upzUt+lDGWZByrbg6cp6tTFhpuZEKVuRO6fCMZG2gumMIgXuA8YieE
         OrTUCwtRgyk+mlO4POnW4g0c3ljksz1aEt3S7vZVmZ0ElVP+YYAUBc3qJO3zc8v+3sgB
         bMZAvXljsupE7Z6J4xTb3yQeD/yso11lFU34g8o4dTGVSHjOTU8m0Wr5LFIrG+LjnXil
         PeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=Pv4Kn/kXpuqms5hUdvFbWbbJ/CjSdzb1UQVcC4I7FOo=;
        b=o3Hkb0VQTCNhbUbKH6DGEEiFJa4zWpFUeHcyo8DgogLPdV5W0cxgSvG4RcCsplJcmQ
         Hu5EyDwgfedHGBcJaNSqEML8jAPJYx9HqSqYmpzOkccw9SmUSHskuAk9JTEU6Y6UYWoh
         wnAfvx8vEXTCV8q4TOR00C+QTDeyjR/SYjHeU2UkAlrnGRoUonoyqby5ylH38H7V8Rz9
         HhMFskKMMRuZGtLXjGl/EeUaiM3zmUm7Ro5YBUOx2IqytRcaf0Iu5y0BczdRY5unkEl3
         vKam/y/42TcFtXA7tqQBAr16O319Ldd02mDyMmamH4D7JOIQtTnii3oT1bnwbGHX1W+k
         ZyZg==
X-Gm-Message-State: AOAM531Qd3unmFi+EdMALrLVvNI1/fzRV9QcUrYVNvctlqt3XRRJJrRe
        pLYebEyBNiNNsnOManupHD4dql7AZKO4rkgiRKE=
X-Google-Smtp-Source: ABdhPJyKNxVXzYeeCXbPlt2jybk10zQrYRsiCxmVnsjUPXowhLbRPr6BVfqJRTTbW25doSqgbv/kEg==
X-Received: by 2002:a63:d008:: with SMTP id z8mr19280753pgf.623.1638865954089;
        Tue, 07 Dec 2021 00:32:34 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id j7sm15657903pfc.74.2021.12.07.00.32.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Dec 2021 00:32:33 -0800 (PST)
Message-ID: <61af1c21.1c69fb81.6f938.c5b1@mx.google.com>
Date:   Tue, 07 Dec 2021 00:32:33 -0800 (PST)
X-Google-Original-Date: Tue, 07 Dec 2021 08:32:27 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/207] 5.15.7-rc1 review
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

On Mon,  6 Dec 2021 15:54:14 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.7 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Dec 2021 14:55:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.7-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

