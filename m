Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541C81CCD11
	for <lists+stable@lfdr.de>; Sun, 10 May 2020 20:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgEJSu1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 May 2020 14:50:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728756AbgEJSu0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 10 May 2020 14:50:26 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2268C061A0C
        for <stable@vger.kernel.org>; Sun, 10 May 2020 11:50:26 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x15so3095870pfa.1
        for <stable@vger.kernel.org>; Sun, 10 May 2020 11:50:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/QhS5M3rYpJkNWEywCh4gwpzqqnOt6PREEBM06bPDGo=;
        b=BwxOuzs2Dx5N+IkXqP55E9v2ToGVpNJ57cXF84qbzx1IFiPgSaVGcg91aKBv4Dwk9X
         ksB3Q+dhKx614Gmp/GWS/r+2aJIOd/aNNtPkbzkT10FZBWZD9g7YhkiERSxZ+zWVS0mH
         FwBdJEVadgmMudainSY+WVlHPJfdE4BAX/xPAwg58PfiCDxLJCisz1sR8i/iPwnsABoG
         c8VEJ65nqlofaxvO9LdtfiFpzdvLZrt1LSUYgnj6YxMHI8iy60XpVTADEkGnGza11IIY
         nWcP1ZCNDHUGLssXJQMhT5Im9QbbkvbSaLMY2OxoqbOm0nps6FsHs5qxDvflTjtxbtGN
         2/Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/QhS5M3rYpJkNWEywCh4gwpzqqnOt6PREEBM06bPDGo=;
        b=pcyprNQJUWckv05fM18YBlnB1IQhvZFHdsIcjI+RlvSH5b5QZl5xdKgZEBUNPIAh/l
         +nuP4x9FypDg+RshP4LwLb8/ZUvlaQX5a/1Z9k6iMzVwjeh6yt+Gz5C28jVf463Yob6J
         yDJzaNpqWE+ICahWRamma3/zBYlfp6Yviagwk7xHjdyaSoVMchfYJnZGJEQnr6bS7pIE
         Dt6REFRR7G0Fqtaribwd3s5QucnuhCkh2LBybaIdSF0+rnh4t3Dj5C1hQFfJ9Zw4rTWn
         yAvkx+6cWaftkW1Xy0ZZra3WuF3KRk0mv+MQuFc6CEJtIhUORAEAKHwDUUU00g+dAd5S
         m0ow==
X-Gm-Message-State: AGi0PuYU0l2HLS1/bof/rf59PqIILIB2AK8X3cVVSLW6vTJmRkWFvICZ
        Ihd9Q8M8ywdmZpR0Uc26rQA51ueXgP0=
X-Google-Smtp-Source: APiQypJIHT2TjFfMOOrJLyGEKXLueRBPRXhayrcxq9PVcpwSVIJUuX7KARa3oDxLzQclsaU5h4n7Lg==
X-Received: by 2002:a62:ae13:: with SMTP id q19mr13289144pff.310.1589136625833;
        Sun, 10 May 2020 11:50:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gz14sm7824248pjb.42.2020.05.10.11.50.24
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 May 2020 11:50:25 -0700 (PDT)
Message-ID: <5eb84cf1.1c69fb81.a1823.b607@mx.google.com>
Date:   Sun, 10 May 2020 11:50:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.6.12
X-Kernelci-Report-Type: boot
Subject: stable/linux-5.6.y boot: 112 boots: 4 failed,
 103 passed with 5 untried/unknown (v5.6.12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.6.y boot: 112 boots: 4 failed, 103 passed with 5 untried/unk=
nown (v5.6.12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable/branch/linux-5.=
6.y/kernel/v5.6.12/
Full Build Summary: https://kernelci.org/build/stable/branch/linux-5.6.y/ke=
rnel/v5.6.12/

Tree: stable
Branch: linux-5.6.y
Git Describe: v5.6.12
Git Commit: c4bbda210077280030b01adf17d2a5fb39ace668
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e.git
Tested: 71 unique boards, 16 SoC families, 17 builds out of 196

Boot Regressions Detected:

arm:

    exynos_defconfig:
        gcc-8:
          exynos5422-odroidxu3:
              lab-collabora: new failure (last pass: v5.6.11)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.11)

arm64:

    defconfig:
        gcc-8:
          apq8096-db820c:
              lab-bjorn: failing since 19 days (last pass: v5.6.5 - first f=
ail: v5.6.6)
          meson-gxm-q200:
              lab-baylibre: new failure (last pass: v5.6.11)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            apq8096-db820c: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

---
For more info write to <info@kernelci.org>
