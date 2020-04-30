Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653E11BEF6D
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 06:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgD3Evh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 00:51:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726180AbgD3Evh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 00:51:37 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC6DC035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 21:51:34 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id h11so1788411plr.11
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 21:51:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e0pdvlLqQiLJFuP5YzrLcyZV1CLWbmiToSy3WIiWZUU=;
        b=pWOgb8aj7C5BKCmjLzY+HfROoBgDKDVmORCMO3VO9wTNTOOO6SkFf+sUW6rJ0eb4rW
         IZTf2mGvYDHw+ChNM/uIF3J7zYBFFedRwWBDSxWrPH8zVeQXXzsZoZUCtzWbN1Boun0a
         3y4jEzBHSkaC3Pk4qEEGMRcL37goBvYzIAyn/vjHualIwr5coDDlyJ8OeQY0HZE2VSo4
         lb05pBktzx+fMR4ZsCdnUO39s/2tBkdH8/XSz1TTxY6Uk8MpJB58+VG14+dSSm7yg0DX
         uPKhUzrtF6rgJsKcPt4u64R9vmxK2SnrmviJZjKu7mI07Rk6M7rXQBedy32wz1aIuaQQ
         XLnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e0pdvlLqQiLJFuP5YzrLcyZV1CLWbmiToSy3WIiWZUU=;
        b=sPwHjfSEE8vW5jXrmeDwEaENf+jeok3ABoOArBUo8LUHeDk9hYJgGUtkcF27vW9sdk
         qJ4SYhqvU3tp0WJb8kGGkHi+wDBoeS/PGsOOpIaWKIr/XDGxsQwyF0J6uN0VpNelK0l/
         CE/ZDfQpZvOA0B6WEWdprjoJYa6k8q9mdQAdBeMziSfY/x0MUK+p2eIpjstNKCMEWndz
         4PctN40qxX+hXbgCcgIRA/mFaEAyaM2XE5FaZcpk2yRV6Vw7Rlh3zS1Ao+eVsuqkVZZA
         80W53qqC1hn2bT6GgJDCzRLH2C1vrLU4wGC2UKKrg4m+1KnhscJV4Jo7DzuFHYPZbmLk
         xepw==
X-Gm-Message-State: AGi0PuZwSwOnodmzPVEOLaLSHPb2ePSrhewy2ajaQiGZk0EvMmDZbUed
        gSuuiZ3q1QYywmSWUr5k/mVm/exwED4=
X-Google-Smtp-Source: APiQypKUjy2cKhWR7lQJtPbV8zyRjb7u4jxRPw3B15imWs3jcCNqZnaXPwYsly+ahIru8VNs7mZA4w==
X-Received: by 2002:a17:90a:d24a:: with SMTP id o10mr902530pjw.18.1588222294009;
        Wed, 29 Apr 2020 21:51:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f64sm654794pjd.5.2020.04.29.21.51.33
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 21:51:33 -0700 (PDT)
Message-ID: <5eaa5955.1c69fb81.edc06.39ed@mx.google.com>
Date:   Wed, 29 Apr 2020 21:51:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.177
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 133 boots: 3 failed,
 118 passed with 6 offline, 5 untried/unknown, 1 conflict (v4.14.177)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 3 failed, 118 passed with 6 offline=
, 5 untried/unknown, 1 conflict (v4.14.177)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.177/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.177/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.177
Git Commit: 050272a0423e68207fd2367831ae610680129062
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 75 unique boards, 20 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-199-g=
a7097ef0ff82)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-199-g=
a7097ef0ff82)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 77 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 65 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab
            dm365evm,legacy: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
