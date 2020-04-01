Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A4319B8E9
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 01:25:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733182AbgDAXZz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 19:25:55 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36348 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732503AbgDAXZz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Apr 2020 19:25:55 -0400
Received: by mail-pf1-f194.google.com with SMTP id n10so811432pff.3
        for <stable@vger.kernel.org>; Wed, 01 Apr 2020 16:25:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=w9NVPP43uzq/uZGvOeYitHzOkPrEA4MKI1blhnSuSHM=;
        b=yvLnBOTH/A/TOwFnv20TQKyp1pFx9/kl0GGyyKr5Pixw0UXkHSQ1K/btMIkMY+dG+M
         7yb3MuWWD/J6TbWVA9Npaw0Mcv+LBXp1Ay+BLPARhe3yDEaLtMhIQ2uj23ksqAog7p+W
         OUaHFhuQ1i1iE6TUZrxP5UEd9icL0386cNNNPQoxRXSWnrUe2Hxpdbe6GIoIMCwMUSkD
         XYbfKErrokgUn9tBsUBtIkHGrUCrCsQzoAa49hz2uD0JqEKdqnqEx9xsfcZ5wa0cuFAa
         PtlzM9j2ZOXXdRZbSEa8ozl3bjtoJqKpUYbnSfUHeT7zHFAoAAC8q1N024sm2p1Sy25v
         YTvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=w9NVPP43uzq/uZGvOeYitHzOkPrEA4MKI1blhnSuSHM=;
        b=Kbrn+YQE/Pw7v2/eSWc5sFghQ/CPNtYKJqAzCI3fiH4H6s3RqNoQ9sniMaW3YGk4vA
         cj7INWw2REu/TFB8LjJ7BR5X87Zsi4uc2VJaQeXmYxyKnI4BlEnIYNvgo0slB0Vl16U7
         qYBAHBmdyZfUweXYF3QukZZ4TClESNujN40nzRMAgPLyq8mond9f36U0Wdc9cHBzr3Ab
         UPkVlTpvCTIPm2To4jOrderBsdXAB+6+jIdavQorZZJPFwo3XC/NBP4l2mDxpW0/vwal
         Ms2h5BU8Z4XQBpyIyAydWBu/HwlUmAEN7gaRh1m0BKE7a3Ce3lLxzF4GJHHN22ictsex
         GTlw==
X-Gm-Message-State: AGi0PuY9UuMsfvUUKYs7DKNmXNgcJVKKDiC/lWRIgrKvWwBAahBOFz+O
        ZUbWY9OkNhOS+7C1bALXUHmLVrXp5dY=
X-Google-Smtp-Source: APiQypKO91oNcRqxCkHOgzIdBlNqHwsPRg1AdvQLhbzAF5hbYXlWJHFevcSKTu3QQFj+jaIAtZlWVA==
X-Received: by 2002:a63:1862:: with SMTP id 34mr619715pgy.191.1585783554185;
        Wed, 01 Apr 2020 16:25:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v5sm2342883pfn.105.2020.04.01.16.25.53
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Apr 2020 16:25:53 -0700 (PDT)
Message-ID: <5e852301.1c69fb81.db0d2.bd8f@mx.google.com>
Date:   Wed, 01 Apr 2020 16:25:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.174-149-gbc03924ca6ea
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
Subject: stable-rc/linux-4.14.y boot: 133 boots: 3 failed,
 122 passed with 2 offline, 6 untried/unknown (v4.14.174-149-gbc03924ca6ea)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 133 boots: 3 failed, 122 passed with 2 offline=
, 6 untried/unknown (v4.14.174-149-gbc03924ca6ea)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.174-149-gbc03924ca6ea/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.174-149-gbc03924ca6ea/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.174-149-gbc03924ca6ea
Git Commit: bc03924ca6eab72bec9fb6f455ea41bca1fa5ccc
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 74 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 53 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 41 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.174-131-g234ce78=
cac23)

arm64:

    defconfig:
        gcc-8:
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.14.172-114-g=
734382e2d26e - first fail: v4.14.174-131-g234ce78cac23)
          r8a7796-m3ulcb:
              lab-baylibre: new failure (last pass: v4.14.174-131-g234ce78c=
ac23)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxbb-p200: 1 failed lab
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
