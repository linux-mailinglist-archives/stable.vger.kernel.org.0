Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B2C1C0EE6
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 09:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728253AbgEAHje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 03:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728212AbgEAHjd (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 03:39:33 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CCFCC035494
        for <stable@vger.kernel.org>; Fri,  1 May 2020 00:39:33 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id e6so2070754pjt.4
        for <stable@vger.kernel.org>; Fri, 01 May 2020 00:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tJPHcc7ZXMshwaXgkNAXac9S4mIKsiObEkH4+ylXbKI=;
        b=SqQwumv7orIBiNEcUYb2Erecx/9Fno0R2ulRI6riuVM/efDKv+hySN9rT+K32rDxvz
         cdKQt6dRk7QJqkFN7QkX4nzPD19XL3figPLC+/XGoi1MDckipTQZWre92gcUgZVJVxFg
         QdfR0hCpTK9BqzRL3bRyRhhoPEpP853pivtYzg5oF1T8Z9EPsAbsGlLjSTfhutOLG+vI
         mJZMwJZEy+6F2bGp8QiGQ3C1xO/7MKyp0NkuMs767H1D0/UJxybkLSOl5DfyahCvre15
         be5ZFlPCpljqXGWPtPwHTw3lWOKyuJSSHIZX4OAcHn8pVTcgjJ7FyUvCoH/Nt+XW9rVr
         UrAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tJPHcc7ZXMshwaXgkNAXac9S4mIKsiObEkH4+ylXbKI=;
        b=qxu0/49V8RDE58sUihZpRq6SksvCV5Ywc2zSJ8QQfQG7hbgKNxK2Yc3Zt+jaNq5kp7
         6LiqN7qQQp/G4h+xkvU7vKWMF6wrLcB2aWXqR3yHYUA1IJqU5HtQEGToQQ/Ws1tfSQ/r
         Dez/3HPkCU9xp6X1bPGu2HPGpNkSAm/ee3v2w8D6htia+hi9NWd4DaeSUp6n6PZvTC6C
         qSledy/s336Gd1EuXa0k1k65r/vVznlNFFqc02QyKPDEUXLPMF6Yfj11lvPeyLQw7krA
         /rysZHeZqZv3pe2wL05/cwHQwDkVREHKJ6DTJXzTkICYcZ5oW//NWl/CLSCkMz0Fcap4
         +DMg==
X-Gm-Message-State: AGi0Puayuy8H+7HfIqhl8XU8LpsorNGprYrMNNdrOVBTz5yxuByNCjXd
        +jtj5M9zx3j8HVGggsVb4QMhzoK/iY0=
X-Google-Smtp-Source: APiQypKuOR9TnOosCs4M22vp5uCpUzT7hO/zOVurzxg9kZhdD2CGvFBc4eYhTZdyfDjzxk5xvwUVdw==
X-Received: by 2002:a17:90a:d56:: with SMTP id 22mr2964275pju.187.1588318772645;
        Fri, 01 May 2020 00:39:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id dw12sm1371340pjb.31.2020.05.01.00.39.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 00:39:31 -0700 (PDT)
Message-ID: <5eabd233.1c69fb81.a8b2a.5f62@mx.google.com>
Date:   Fri, 01 May 2020 00:39:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.36-52-g35bbc55d9e29
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 172 boots: 2 failed,
 155 passed with 9 offline, 6 untried/unknown (v5.4.36-52-g35bbc55d9e29)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 172 boots: 2 failed, 155 passed with 9 offline,=
 6 untried/unknown (v5.4.36-52-g35bbc55d9e29)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.36-52-g35bbc55d9e29/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.36-52-g35bbc55d9e29/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.36-52-g35bbc55d9e29
Git Commit: 35bbc55d9e296d37cf01555d415338b84a70d4c5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 105 unique boards, 27 SoC families, 22 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.36)

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v5.4.36)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v5.4.36)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 82 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 23 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)
          at91-sama5d4ek:
              lab-baylibre-seattle: new failure (last pass: v5.4.36)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.36)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.35-169-g38=
8ff47a1fba)
          meson-g12b-a311d-khadas-vim3:
              lab-baylibre: new failure (last pass: v5.4.36)
          meson-g12b-odroid-n2:
              lab-baylibre: new failure (last pass: v5.4.36)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            meson-g12b-odroid-n2: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4ek: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

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

---
For more info write to <info@kernelci.org>
