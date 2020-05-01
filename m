Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B56C11C1DE6
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 21:30:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726649AbgEATap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 15:30:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726377AbgEATap (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 May 2020 15:30:45 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23827C061A0C
        for <stable@vger.kernel.org>; Fri,  1 May 2020 12:30:45 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id d184so1986538pfd.4
        for <stable@vger.kernel.org>; Fri, 01 May 2020 12:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=RiOM9aeCaVajMvDkeRc0afWzRq8+Gt0jqzt+u5W/xsY=;
        b=YtDnCX66p7jgIjhZ+pGLIiqxMTv95/yONQ8KHofBv+KGP1+mqel2B2h78yuwNf5P88
         /n4x62GSqZKGH2pSUtC6sQ97sOFpcAfs0zps84s3qruFYMaN9kfDq+j8b9v1Wmjp+cmo
         do0cKDFcpL/cydN6nYyZpV7S3rjMKyHJnaUfj/EbnHTwZZpSO6JV5dL1VnDBrDYJnnNQ
         OSp21Ko/uUaSqG6Q3MdkKAbrDqfclm1tC6shMnG9HoK1yL/uFodyMBX4aEIUBmGuXWYh
         9QI9EqRsq81an6QN5uUmc9/dfNDfgbXjOVt4Y6TN3jTFE0pTBlNbPCjmvgt9Vsl/f1CF
         jErA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=RiOM9aeCaVajMvDkeRc0afWzRq8+Gt0jqzt+u5W/xsY=;
        b=WQ+9i3CFDUdmWwXX1A8KSvpGwT+ydPB2aSfe2z6Hmu7Fl8ttrwcJ4xN+GK59f+3YpQ
         GHLluES5Ovcnus1I59zaTIOTvkrewldhHbrfqmZz2Wo0v0Idp7+uubwL+hGf3Gt+dwAq
         w2UiUqmV1KY71l0yRs8K2Gg6EAZaSnc3JAUBz4Rfc/vWyflRY7d+iwTK3l3FTDiTWtDz
         2ecqOqntbDZImhtTl9iIDjRDdjnZM9m/O4+KJohu1QeUL6S/hmYvvp/g2RZzEqT+HpCp
         wMZbfZjVl7aEiBjjkk7ovK+kf2n5QGGJ6/U8s5s7KlJbWKmmXBwC7Wgnnnfzp+BgnutB
         sbSQ==
X-Gm-Message-State: AGi0PuYLIhfju1lB2iz8yM78zZhVWOFAoa0ovvdxyn7rgY1JGC8V6cnA
        J6wfLhLlw5i6iTdk3Sb+ikuHq4bbs9c=
X-Google-Smtp-Source: APiQypKCgX4eORgv0pOLStmohApBiBeJqCgSHMJqlyRQ0MLiswlYX1hxnWIRsxnMYI/ePagVFu43lA==
X-Received: by 2002:a62:6585:: with SMTP id z127mr5628285pfb.217.1588361444312;
        Fri, 01 May 2020 12:30:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a129sm2980283pfb.102.2020.05.01.12.30.43
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 12:30:43 -0700 (PDT)
Message-ID: <5eac78e3.1c69fb81.7e271.ac26@mx.google.com>
Date:   Fri, 01 May 2020 12:30:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.220-71-gbe0a2ec77b53
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 92 boots: 3 failed,
 79 passed with 4 offline, 4 untried/unknown,
 2 conflicts (v4.4.220-71-gbe0a2ec77b53)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 92 boots: 3 failed, 79 passed with 4 offline, 4=
 untried/unknown, 2 conflicts (v4.4.220-71-gbe0a2ec77b53)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.220-71-gbe0a2ec77b53/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.220-71-gbe0a2ec77b53/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.220-71-gbe0a2ec77b53
Git Commit: be0a2ec77b5371fbc2ab490082d65ac7796b7392
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 83 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 36 days (last pass: v4.4.216-127-=
g955137020949 - first fail: v4.4.217)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: failing since 1 day (last pass: v4.4.220-54-g00=
dcb2acee8d - first fail: v4.4.220-61-gf597674b96ad)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
