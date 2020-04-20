Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 822F51B14A7
	for <lists+stable@lfdr.de>; Mon, 20 Apr 2020 20:35:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727776AbgDTSfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Apr 2020 14:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726021AbgDTSfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Apr 2020 14:35:33 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E25C061A0C
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 11:35:32 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id x3so5356078pfp.7
        for <stable@vger.kernel.org>; Mon, 20 Apr 2020 11:35:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LVpzx1DTyznQssnETN0u40lacrbSnqfJ7fVuJMH+SWc=;
        b=LLITbydjYJ41nahhWjbUatTadyL5yQxMCqDJMS0gNkGE8t4eQNeWqeDYZ183GeKiAM
         JiNaFh0I1TtsEjDqUKuL1ZqWu6s3Q0aRltOj2VLBcje/XiP1t1GOtIip3LFM0Wezzzwa
         IdIgWQPJV0PBj+JX/jXYA8tObp8VMxa3By0fED8k0lmh291lheIMRYD3yFWtxWLyzXP4
         4pMMZijpVmCbpeZ5oraX2VNW6a+2q/ol6oslMufbpLoeDd5ZHgvpOcrE6Rj6e+CFV0U2
         RdZRiA5c4ttwvDkGDxlwBeBWDK7Bri3N/jU+hWrItLTeYlVKGnMj2Zcc4aCIqfTvTVqa
         25ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LVpzx1DTyznQssnETN0u40lacrbSnqfJ7fVuJMH+SWc=;
        b=hSmOTCg0Itvfhzm0AjF5Q2wgwpxn5sh5gqHfHWu5mVONRtzaAyi0Kbt4gW5NGIWgZg
         /nCQx9ZHeEHA5Zn970xJgjKPuT3x+3RWsL1uRjvIwONrrBtYO+/ELx8eh7rP8jlzjYZY
         nk7vsBVr/DHEqES9aP7IJRQ0sGaHFAC4dn3hHA4wz4xZwKQHgXPwQaBI0wulcA5mILd/
         tTYzosh5V2kYrWrcB8sRxyzRB7GLgj/77lNnz9EcKYjjkh4Tvec+7mPZcFG/sVStRTcH
         yYUVUEu71qm6mm8Wsb3eRMgbpk2mkHacTl5N7T7wjEcya97rHps96HDSXfTKDPu4V4QM
         ye7w==
X-Gm-Message-State: AGi0Puaje0EJW4Nt7jViUMyjao+gSfE/+m+b7QHvP0ckzzG7uvrO27/U
        rRIMxt6pV/0ErC7awIaOf5GfuSbUH7g=
X-Google-Smtp-Source: APiQypIexp0zFsGwHGpxmIFQEGxjxX4NqFD0sMD3RSsHqwcBsDzARv0+MAvS0DJuZzTxIQyyiPMB3Q==
X-Received: by 2002:a62:6dc3:: with SMTP id i186mr7073951pfc.273.1587407732071;
        Mon, 20 Apr 2020 11:35:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i18sm57030pjx.33.2020.04.20.11.35.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 11:35:31 -0700 (PDT)
Message-ID: <5e9deb73.1c69fb81.61a2d.03a8@mx.google.com>
Date:   Mon, 20 Apr 2020 11:35:31 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.176-136-ge60eb60a661c
Subject: stable-rc/linux-4.14.y boot: 98 boots: 1 failed,
 85 passed with 6 offline, 5 untried/unknown,
 1 conflict (v4.14.176-136-ge60eb60a661c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 98 boots: 1 failed, 85 passed with 6 offline, =
5 untried/unknown, 1 conflict (v4.14.176-136-ge60eb60a661c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.176-136-ge60eb60a661c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.176-136-ge60eb60a661c/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.176-136-ge60eb60a661c
Git Commit: e60eb60a661c0738dafb0907de42ff3ff8ac91d0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 16 SoC families, 16 builds out of 200

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-124-g=
10e2890241f3)
          dm365evm,legacy:
              lab-baylibre-seattle: new failure (last pass: v4.14.176-124-g=
10e2890241f3)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 72 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.176-124-g10e2890=
241f3)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.14.176-124-g10e28902=
41f3)

Boot Failure Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            stih410-b2120: 1 failed lab

Offline Platforms:

arm:

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

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-collabora: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
