Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD8C740B4
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 23:13:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbfGXVNP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 17:13:15 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39888 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726591AbfGXVNP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jul 2019 17:13:15 -0400
Received: by mail-wm1-f67.google.com with SMTP id u25so32464119wmc.4
        for <stable@vger.kernel.org>; Wed, 24 Jul 2019 14:13:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ukpC78czdPBdGCQpiCmIbDu5k2kKhYmB7WCyDLvkYOw=;
        b=hjTghpVKXTqHY/DuDMRqPH4MSMtK+88i0hBsrka2Qr2nOOTe8UrmP8ycE4E9p//HhG
         n4o+LhS8mdRH1lqgIC3gCFvTgSeJ/A3hwNfp4CrurL+/WJFN217K7xowd6ODe8/HJpiL
         NpuoxJXB6tXxL4l2xxlwbZVnZCpTIG9hbiOij1Eni7c07oc2wbz9vSsj25r5OWFJzexP
         anI7hUlfrPb+eBw0iyA1s/YsKvMnvQD36WhWdcIcbTz8S3ODOExS+Ya3yUS5eFgVHoBv
         R7V0ZMJCrysftI1sPIgBSgHBVdFBDGU/3RjOG1Hz8/JvUyXZrxSKqJGogywN8Xonl5pk
         URrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ukpC78czdPBdGCQpiCmIbDu5k2kKhYmB7WCyDLvkYOw=;
        b=Aps+Bm4cq65ec9z7cr0YasGsDNq1bLNChHQmphWFk6tzFYK/GgHoLcroyhZdzJHPPa
         6UwtqRdOEDU2vPBbuh5LK+LCHHgRFtMruHfRKpQjKjnBi13QeRotD6DoApqYWdLK2KzV
         cnlxSvaZv5nQTx2sC2YFnDmiC2ftKMS4+RqX/oKxKVshBRkqDJuneGdM4huT37A2XTRd
         EJDMtysuPwUOJfJrE1e+sl+XiqbVDbUOTxZztbmRBYLnVJ9fj7QrzcX290lj68FUbAqy
         IDPAZtlTCtUXo2LOGiOkHfqOqZjxLZvGRCCZa3TPEjH8aH8r9C68/FLdEArtTUrk9xVD
         /cpQ==
X-Gm-Message-State: APjAAAU/92L6IweFC5mfm2EHMm8oFD+H4MbRLki1Nw6u2tQmHYhXJzes
        pVrjx4wM9CEqo/RLLON++wOzZkAyOG0=
X-Google-Smtp-Source: APXvYqyRjKBC+6OiGKPGrknNWXzgjJZX0gs4uEqAoeP2rcV7GCuyOmbG1ux1dGAG0d8F0rD4GNmu/A==
X-Received: by 2002:a1c:a503:: with SMTP id o3mr72289960wme.37.1564002792837;
        Wed, 24 Jul 2019 14:13:12 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t6sm52015717wmb.29.2019.07.24.14.13.10
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 14:13:11 -0700 (PDT)
Message-ID: <5d38c9e7.1c69fb81.8aec5.45df@mx.google.com>
Date:   Wed, 24 Jul 2019 14:13:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.186-87-gb978d23daf7c
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y boot: 98 boots: 1 failed,
 87 passed with 9 offline, 1 conflict (v4.4.186-87-gb978d23daf7c)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y boot: 98 boots: 1 failed, 87 passed with 9 offline, 1=
 conflict (v4.4.186-87-gb978d23daf7c)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.4.y/kernel/v4.4.186-87-gb978d23daf7c/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.4.y=
/kernel/v4.4.186-87-gb978d23daf7c/

Tree: stable-rc
Branch: linux-4.4.y
Git Describe: v4.4.186-87-gb978d23daf7c
Git Commit: b978d23daf7c66c7408125ca96994e79442d0ba7
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 45 unique boards, 20 SoC families, 14 builds out of 190

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.4.186-76-gf1=
f6aa1c598f)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.4.186-76-gf1=
f6aa1c598f)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: new failure (last pass: v4.4.186-76-gf1=
f6aa1c598f)

Boot Failure Detected:

arm64:
    defconfig:
        gcc-8:
            qcom-qdf2400: 1 failed lab

Offline Platforms:

arm:

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            stih410-b2120: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)
            lab-linaro-lkft: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-baylibre: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
