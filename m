Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B92701D4238
	for <lists+stable@lfdr.de>; Fri, 15 May 2020 02:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728264AbgEOAmz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 20:42:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728243AbgEOAmz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 20:42:55 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C34BC061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 17:42:55 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id 9so178093pgr.3
        for <stable@vger.kernel.org>; Thu, 14 May 2020 17:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ci6D9++m4Um8VxI7rxYEeD2LYkxrGR/P4Dm5inzV8ec=;
        b=DH86eTpAc0fOCzx5J967iYYz6CIe3i22tQRaM3KFV0m68C+gtKmuCrPuAsGblPRMB3
         TjaqG1W35uE2ewLD5nGoeAcY9JW6EF/EW6j0tzsasxW0Lcetd1uAn13l7SFGrDaqSX9x
         uwv0qhgokUdckojjO9JtVD3ukC75R248X4oLYQTQz0Yk3j77IIM7J6GhH4tM9VYCYsU4
         kayz2j/MZnnjqvdUZXCSrAk6lYlz97da17vRujDOiHd9TuNZU3LcKUqREXeUfLrYU2Y1
         t2vkcAr/UzjPYVeceCDxbGIPJQF206nSY3PFRz+6TgA5/Ne45PA7lNlDm0HnSQwTCe6A
         nyjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ci6D9++m4Um8VxI7rxYEeD2LYkxrGR/P4Dm5inzV8ec=;
        b=huqwCcou+lx3hwuOzkC0mJuhzuqnSH2sIF3z5dizXMFYCjKfdu5kR4HP50SZPHZkO9
         DLAb0NPqii8Eu2aiRtgdCYGAmIgeUd1Tla2dyZYjoxkfLtt/dEJ4aKiiorTADFUgENpS
         4U9oujQ60HHq5U4DE3mqAZ9pWGnR72WkFyYQfp8+r110rvcSGsl4nKK8TVGoLWlFxlln
         fGwbz8BWmtqs2V9iM6jgfp6PeoSNqYUZEbK5FWxRS94fMlhzDzVTudcpjWa/qvn7+Pvh
         95gcwJsgofQBJXVyqHHgyZhm6dKm7SlR9LYMebO5wObLrh6rrRuGqGcOXW+5FxKlpwuR
         k36A==
X-Gm-Message-State: AOAM532KeJAboRktsDfXe8COZ5NhuqHQvc4ZxO6cXqLiHVV/6v5KuR6G
        ZkLA7R5KVeJtly6qcSQa+F4gHM2F3GA=
X-Google-Smtp-Source: ABdhPJzCHyIhtBneN7J+36EPou35DxMaiDmyXbD9gP/62nznIJ1+TRHVEaUEtO8TvkoFCaraWltKNA==
X-Received: by 2002:a63:e90e:: with SMTP id i14mr698911pgh.173.1589503374808;
        Thu, 14 May 2020 17:42:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g184sm340561pfb.80.2020.05.14.17.42.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 17:42:54 -0700 (PDT)
Message-ID: <5ebde58e.1c69fb81.c49df.1a75@mx.google.com>
Date:   Thu, 14 May 2020 17:42:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.13
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 164 boots: 3 failed,
 150 passed with 5 offline, 6 untried/unknown (v5.6.13)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 164 boots: 3 failed, 150 passed with 5 offline,=
 6 untried/unknown (v5.6.13)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.13/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.13/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.13
Git Commit: 5821a5593fa9f28eb6fcc95c35d00454d9bb8624
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 101 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.12-119-gf1d28d1c7=
608)

arm64:

    defconfig:
        gcc-8:
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.6.12-119-gf1d28d1c76=
08)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    imx_v6_v7_defconfig:
        gcc-8:
            imx7s-warp: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

---
For more info write to <info@kernelci.org>
