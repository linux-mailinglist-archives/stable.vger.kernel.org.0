Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91DA9187823
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 04:25:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726982AbgCQDZN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 23:25:13 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:44976 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725837AbgCQDZN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 23:25:13 -0400
Received: by mail-pf1-f193.google.com with SMTP id b72so11115088pfb.11
        for <stable@vger.kernel.org>; Mon, 16 Mar 2020 20:25:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=kCao7YiIIy11+eP5hhskeeq3bo9Hpr7M0eQWyKAYU5M=;
        b=ntS+caURSkX2d88pIDk2epniOJrFuQz51x96gWwP+LWr+KrrAWqYXp9ShrLqwBSrVY
         /i15/X4T99sMyUFZYkDAN9gelyLbvEkIIQ9gOGGt/fNXElp9E90U2PnvN7+gQCYZc0Am
         2clTgZrev1eH0uecnkQf1khXgiwKQ3zEHW9itPNG1dL1+OJVPppM+N8khx7926ofi8RQ
         qOVFVUwrqwjDC53aJtFNmVuK3uSunglo1L4D/VE1/El8wPZ8G+3LD0XuyWeY4wG2quSR
         mD9yYCsMqOWC/rfE+wfzhWm9OC/DzmVQ+XwVB9mVFs2D75UfpPltIfWbUV30ziqHe43Z
         cg2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=kCao7YiIIy11+eP5hhskeeq3bo9Hpr7M0eQWyKAYU5M=;
        b=HNXO+rWnxhu7fqfqtjpUFWSYbChokPf9ZKMqdmrZ1BPANl1AJ93zEV8666dJOS+QYJ
         /0Ee2wnlX/DEUOU/o/T8q9/mNq7Ed+c+Nm3EdsBdByOWjQLE9I2CeR4PSEehGnznIIQO
         AoFz4vtQYHUJi7d7oMKQ6TzdufG+G4N9PRa0LjTxLZScXfR2sr2fNElxFMQoKGjLrROW
         v4ULYF8l629TE7WauOHQ3pDzZvYYqVE6uoYZuLx8dihtqvxMi1rxd8fxzjQd6+GkH6y9
         BoYp7U6naZqJn0JRtWEGKmEH9cA0knuAnKcGGzOaV0wTdz7PzrgfG1fhH/3UxasS9rm6
         gbJA==
X-Gm-Message-State: ANhLgQ2HA8iyOOlYfufw1UNpws2+cQgP+uO0NOHZCYXMyWmp6Wa2XS2D
        6YZEtd9ug7pDRhPVPfRMDUTq1xrGDX8=
X-Google-Smtp-Source: ADFU+vs1hU6qnz/7RHIj6Khqj2RGOZ4iC5T1NFKFjzi6Znnctghk6BitigebRoFd3MtnzF8o9rlVwQ==
X-Received: by 2002:a63:f13:: with SMTP id e19mr2882664pgl.135.1584415512393;
        Mon, 16 Mar 2020 20:25:12 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x10sm70718pjq.29.2020.03.16.20.25.11
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Mar 2020 20:25:11 -0700 (PDT)
Message-ID: <5e704317.1c69fb81.3f55d.0505@mx.google.com>
Date:   Mon, 16 Mar 2020 20:25:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.216-38-gde8c7dfeb84e
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.4.y boot: 96 boots: 5 failed,
 82 passed with 4 offline, 4 untried/unknown,
 1 conflict (v4.4.216-38-gde8c7dfeb84e)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 96 boots: 5 failed, 82 passed with 4 offline, 4=
 untried/unknown, 1 conflict (v4.4.216-38-gde8c7dfeb84e)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.216-38-gde8c7dfeb84e/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.216-38-gde8c7dfeb84e/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.216-38-gde8c7dfeb84e
Git Commit: de8c7dfeb84e46ca3605e713bcb385f85b7070f3
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 49 unique boards, 17 SoC families, 17 builds out of 190

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 37 days (last pass: v4.4.=
212-56-g758a39807529 - first fail: v4.4.213-28-ga3b43e6eae91)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-cubieboard:
              lab-baylibre-seattle: failing since 6 days (last pass: v4.4.2=
15-62-g1ef447a18aac - first fail: v4.4.215-73-g836f82655232)

    vexpress_defconfig:
        gcc-8:
          vexpress-v2p-ca9:
              lab-baylibre: failing since 1 day (last pass: v4.4.216 - firs=
t fail: v4.4.216-22-g0acb20f67a41)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v4.4.216-22-g0acb20f67a=
41)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    imx_v4_v5_defconfig:
        gcc-8:
            imx27-phytec-phycard-s-rdk: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun4i-a10-cubieboard: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

    qcom_defconfig:
        gcc-8
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
