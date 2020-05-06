Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9991C7A75
	for <lists+stable@lfdr.de>; Wed,  6 May 2020 21:47:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbgEFTrS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 15:47:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgEFTrS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 May 2020 15:47:18 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23EC8C061A0F
        for <stable@vger.kernel.org>; Wed,  6 May 2020 12:47:18 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id f8so965095plt.2
        for <stable@vger.kernel.org>; Wed, 06 May 2020 12:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=IR61ICoe2OoMM6s2fXAmZ+++7bDOLrow07DqcRgfzuo=;
        b=GfrVKTPCd+asrAFcDuEbx07xegGIgI/fN0Vw6MSUZ9tKCo3ZtAxNEI1hzkNf/KRzXb
         UUbGY4NKinl2neKCOQcMwFGuSZkYkxQKOVfymbV2c6iwccuv9rKdApSURysDu6W9NwR8
         GzjL1q3XsQ/B0X0cJVG2gCLrW5E7leBbfovfiAkIvHSxigc5e4syvrql6/JCslfHfXzj
         U0e7nAJzA3u3iTDm2DW8h13ue0jWx4HDAKpiCidQ4ckKe2dhi7czKWc7sjq0fGM4FH2G
         mzihDjhzhOJiPckYwekirTOf5qLGRHI4WDcbFz/NrNXP0cdQAZ0sT8UjH6nbFZmx6UQz
         4Q+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=IR61ICoe2OoMM6s2fXAmZ+++7bDOLrow07DqcRgfzuo=;
        b=WOsrUEygzbHfkQAk1R06/DtrXoTGV5Y0Ji87wUDPqbLBc1M9WjxxjXUtfYKbzL6Lbl
         Bz+CAQiV6AP5rp4PXpWFdV//F+vRZoujIulBU7TgOltdhUfFoSTj/TpmUk7fDuKr4SDs
         icSJ/0+zEdRVEj7pF3Q4XC0ZjQJIY/9qkHiUhng8ij/eUP5Ms6XtCWjzDansBCaUKnTJ
         q+IhVKPaFlGMA48iuFUtlwzEDRhL0gqv3fdKm0fo7qDisEUDXRhe3xYspTO7LJdOvl9d
         4pNPFyAhlFIQriPZX5CP8t/dPSZjelO3AydwKlrCFhLdTtGIspCUFHN51lQNreok3PQN
         S4MA==
X-Gm-Message-State: AGi0PubmA3rpPLQ01qCrVZe2r/eotWc5LwpHtO8wkUTDArXq6Nxc55ZT
        +GcbVr9okO3F7hSKTAspmGfDUOM/KTfB8A==
X-Google-Smtp-Source: APiQypKDUOHUepSCfHMWmUSVe8nD/nTwkqp6ycgvCfZlpzjh6qrfLtLJUBEJQvzOX1gDchaRgV1p2w==
X-Received: by 2002:a17:902:7c97:: with SMTP id y23mr9047913pll.231.1588794436641;
        Wed, 06 May 2020 12:47:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fy21sm5364406pjb.25.2020.05.06.12.47.15
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 12:47:16 -0700 (PDT)
Message-ID: <5eb31444.1c69fb81.25cf3.2d73@mx.google.com>
Date:   Wed, 06 May 2020 12:47:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.39
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 164 boots: 1 failed,
 151 passed with 5 offline, 5 untried/unknown, 2 conflicts (v5.4.39)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 164 boots: 1 failed, 151 passed with 5 offline,=
 5 untried/unknown, 2 conflicts (v5.4.39)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.39/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.39/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.39
Git Commit: 592465e6a54ba8104969f3b73b58df262c5be5f5
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 98 unique boards, 25 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 88 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 28 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.38-58-g29ca49e024=
3b)

Boot Failure Detected:

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

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

Conflicting Boot Failures Detected: (These likely are not failures as other=
 labs are reporting PASS. Needs review.)

i386:
    i386_defconfig:
        qemu_i386:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

x86_64:
    x86_64_defconfig:
        qemu_x86_64:
            lab-baylibre: PASS (gcc-8)
            lab-collabora: FAIL (gcc-8)

---
For more info write to <info@kernelci.org>
