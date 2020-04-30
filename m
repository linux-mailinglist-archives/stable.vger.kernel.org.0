Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 672901BED37
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 02:52:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgD3Aw5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 20:52:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726431AbgD3Aw5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 20:52:57 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3338EC035494
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 17:52:57 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x77so2040389pfc.0
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 17:52:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bfoqJoTwPYrAZRseNTf55UFHbbJS3723+u3bMowKpTY=;
        b=0mg5FCVf4tPygOutFULOh8Fqh5UkBUpzyg/80EAbSDGKvigvvPtcf5tlqUyAMcljFj
         GGIZzQntmVJd+09t/vgbDhL8t5U5ebssees8CIOhuejyn5rgVLyQSy9g4w7Nw7IhzoV/
         1um8iFYDF0xteM08zO5dGvB6+F+gJIhzVqH2YaAR0s0WIuJZw7EraMqNY9rGWMxP4yYR
         RXMRpMqYHGD1YqUsi1nQjLk0WdZUcwcmNIuRzUaru3IK9Ee3/quXCafkGujR81mAnCbX
         QXnE+Il5E5PYm5aVmutHRjpNtYJcRy4v18AEkXWwuH/d4lnil+wkdCDu+ho3R3Sm0bu4
         l3bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bfoqJoTwPYrAZRseNTf55UFHbbJS3723+u3bMowKpTY=;
        b=AeO0NkeToqHkS3OvYjLak1YOYvNElPAPq/hhvZjbYEuwhtsdMtLm2U2QS5Mhat8+ik
         JK/OFCO5/s1wpvKrYcyUxX+NXxD9IYb2aQNtS+EG+jSl5aFF+9bvL6GenYdFVV3oQqDR
         N1TMRQnkRi0pn3uxVdXmdH9X2mNERdC6wpN0nuKr6dCKdy8ODcagxdK0jkQhATFueHk3
         8WsiOR109hrml1Qc9IaqIw6f5sp3qHx/qEYRR/CQCwk3SRl+kjsempm3H+DoWDtL4wpE
         S0rHvVuvV8YCVm/IJ/8cLIqnFSInh5HUVqTGbMsEtk3xZrXe2H6oCL0FUa4AOwOXJ2GU
         UNgQ==
X-Gm-Message-State: AGi0PuYqmm+E03mD7mRq6JENpc1AkgAJPB3huxQznZ4yUOr/IfLDMUjN
        mb78K4fc1KT6gcFcXMJhDQA+TmpJhOo=
X-Google-Smtp-Source: APiQypL+vP1KWSBLLugBR1aD/TZwCaFpDs1MRY5Wugk+j8kWOf3gtG6XgkqL498sbmhQQKLTjcw0Cw==
X-Received: by 2002:a63:1705:: with SMTP id x5mr922559pgl.12.1588207976448;
        Wed, 29 Apr 2020 17:52:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a136sm2011911pfa.99.2020.04.29.17.52.55
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 17:52:55 -0700 (PDT)
Message-ID: <5eaa2167.1c69fb81.213e7.6f00@mx.google.com>
Date:   Wed, 29 Apr 2020 17:52:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.8
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.6.y boot: 170 boots: 3 failed,
 154 passed with 6 offline, 6 untried/unknown, 1 conflict (v5.6.8)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 170 boots: 3 failed, 154 passed with 6 offline,=
 6 untried/unknown, 1 conflict (v5.6.8)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.8/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.8/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.8
Git Commit: 63c3d497410788af1804579f0cded007318c5991
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 104 unique boards, 25 SoC families, 22 builds out of 200

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          sun8i-h2-plus-orangepi-r1:
              lab-baylibre: new failure (last pass: v5.6.7-168-g853ae83af7c=
c)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.6.7-168-g853ae83af7=
cc)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.7-168-g853=
ae83af7cc)
          sun50i-a64-pine64-plus:
              lab-baylibre: failing since 1 day (last pass: v5.6.7-167-g9a3=
7d69c8170 - first fail: v5.6.7-168-g853ae83af7cc)

Boot Failures Detected:

arm64:
    defconfig:
        gcc-8:
            sun50i-a64-pine64-plus: 1 failed lab

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

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

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
