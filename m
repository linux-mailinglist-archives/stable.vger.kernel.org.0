Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F40C1C0CAF
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 05:38:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728101AbgEADiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 23:38:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728071AbgEADiw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Apr 2020 23:38:52 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4FA5C035494
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 20:38:51 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id l20so4015555pgb.11
        for <stable@vger.kernel.org>; Thu, 30 Apr 2020 20:38:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+lCaT09KDzBAPdDtxpQpkPGkZ0Vcog+QklcJyQ2rUOY=;
        b=WjeS4lV3TDG7GqPibhpnCiFS+m6i4Yjz3BS1GvFbY7uGEHmCLRxueENNcaM/1fvu9W
         9I05P2ySorh+cUr912fh8ARKy95dkHSKFu0G2AMXKPIlRS5wZcRVibMcpRj1YkA8rPQx
         V+mdLLtZsCg5WbsmOHemIQFaCOMqQjWJb//+64S06Cxb8weL9MwNRTAJnQWCr+iWhFS0
         KJeoWV1GNyHyqxws3iYGUkQqeBHwXsyXwsrthZ3KYayeTtyxhThEhTmOlXnzNdprqyKA
         7+IGNsI0cGWTTIpgVEa0YScDx4GczpKYUIfgr3jLAsfwGjW/mbf53zW3IjYkGyADGx/d
         yAUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+lCaT09KDzBAPdDtxpQpkPGkZ0Vcog+QklcJyQ2rUOY=;
        b=uL4bxgV9E4v2tnjIkL+J6rI/GWvNom5N0+2ySg0GfDex0+YXcFRiDb/aCa4XJqo5c8
         4P+nAQDdnAAFc69uYFW6BPId20D7wB7SHq3k+Uvnt0jdRUlRY9bJd9BAK4kVUnNdzXl1
         +EJv4OGRj6eqnRUt3EZCjGKn/Y7BWZFvJXnA1oyOSS8csK1hfXB42GBGdht/R8UR+qY8
         7eCdmhJXEdBTUFgso0kTP2d/ZyJOjGRnqjimsPINDXEZt4jdV+O33tfsd++Dt5/+PCo8
         wnUpjM+c0q3N2uhj56GtObhqQIHLxdSuBj+hDGBr1L2RSWRxq1PXiTmzxmVaiat9Wu7o
         39gQ==
X-Gm-Message-State: AGi0Pub45FNGr3lwRX58Ca5+HBL8LEYXXa0qoZUp5XYXkD2t6Phba8Qx
        zRPC+8mKlxOPU3/xAirq64uHMzhUA6k=
X-Google-Smtp-Source: APiQypLfuYAW7magovPZP59X2Bhjd7PHVeJgiCwTcCht8s3gRXtqZbINgLEztSvWyenoJTOVFT3Ccg==
X-Received: by 2002:a63:175c:: with SMTP id 28mr2109568pgx.44.1588304330779;
        Thu, 30 Apr 2020 20:38:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i185sm1023592pfg.14.2020.04.30.20.38.49
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2020 20:38:50 -0700 (PDT)
Message-ID: <5eab99ca.1c69fb81.540db.59eb@mx.google.com>
Date:   Thu, 30 Apr 2020 20:38:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.177-98-gc52cc9360302
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 134 boots: 3 failed,
 118 passed with 7 offline, 5 untried/unknown,
 1 conflict (v4.14.177-98-gc52cc9360302)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 134 boots: 3 failed, 118 passed with 7 offline=
, 5 untried/unknown, 1 conflict (v4.14.177-98-gc52cc9360302)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.177-98-gc52cc9360302/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.177-98-gc52cc9360302/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.177-98-gc52cc9360302
Git Commit: c52cc93603020587316e9e59fc455acdf1ac4a6e
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 76 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    davinci_all_defconfig:
        gcc-8:
          da850-evm:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
176-199-ga7097ef0ff82 - first fail: v4.14.177)
          dm365evm,legacy:
              lab-baylibre-seattle: failing since 5 days (last pass: v4.14.=
176-199-ga7097ef0ff82 - first fail: v4.14.177)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 82 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 70 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.177-85-gd7d12b87=
f9ba)

x86_64:

    x86_64_defconfig:
        gcc-8:
          qemu_x86_64:
              lab-baylibre: new failure (last pass: v4.14.177-85-gd7d12b87f=
9ba)

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: FAIL (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
