Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 960741D3DCC
	for <lists+stable@lfdr.de>; Thu, 14 May 2020 21:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgENTnb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 May 2020 15:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727769AbgENTnb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 May 2020 15:43:31 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C26CC061A0C
        for <stable@vger.kernel.org>; Thu, 14 May 2020 12:43:30 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id z1so1817535pfn.3
        for <stable@vger.kernel.org>; Thu, 14 May 2020 12:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=chdzY7UP/ZqXIaMMsS6cQGzrIh0ThpGhzntTgyAVFp8=;
        b=RBw0Uj42PnxQFr9RocjEm8Ea0hFXyInH7HY6L0paqyHRmSEjBF3XXVCauXo+fnrtcE
         NUXTSUhJKl6A3cgSHL5ljCX0bHXON6mQePlDje53DLbxrKxJ/cFs27VKdP55ogzvJhZO
         /RnEm1H4qORum7VPPaER5kx9gr5pBW0KAZ2N2lrJhSnUkjCJrHU7kbV9ITz/ofATUMsM
         Jy6hNNgbK9CDyrIZfeq6tJgHNjahb37iwYKhBwhNH36Lzk/LtwuOaCALkVqerMoswuG/
         tDtUAicHubhEI6tz9jGTCQ2PRRz81wlwVzLFOCLab8k+LFXus3Q+eP+yo4c2oDPLmfcd
         ncmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=chdzY7UP/ZqXIaMMsS6cQGzrIh0ThpGhzntTgyAVFp8=;
        b=TfvACFEDEdLZ7MbDRJXAOUkQ69e8WGrqAfLeqFpEYyCaY3IMsc56WQXVoASLvgnxRD
         UTIkYws1A3dOpKA8P9PkIcDMoMi4G/uVR+WZi2CqZmCdzfBhhYxpPjRR5Mbld9qRQVY6
         T05kCEyQCrZaFuOXK6IBV4UxLGh5MJwkST948bjgYpO2z55TTaQ1tlT1b3LCrqAFv+m3
         +5/jR5rNiGKW8grffVIeAE98N2/IHYWuT0RA3tIdzQ0Zx04npbml9GbnQas2M0WlxNGV
         2rckWNP4YZyvzYKciByqvo3FspMBwGkem2AGg8PNsxVEDMtqC1f2i/1YBxXwcOEgnHof
         VY3w==
X-Gm-Message-State: AOAM533dPmIy5haA2XKOXGuJosh/rpu4UiJnXTYLlTft86tGsMI+oxil
        7UyhE9/TMeIZDI6EYk8Y/PYA+pqj3Wg=
X-Google-Smtp-Source: ABdhPJxQ56NXxtLWJ9SYZtVovy2xo5w3UQrBoJjf0vTiaWHpS0UFi6J5zGw/wvUtUOVz7XTpZp3uCA==
X-Received: by 2002:a63:ef05:: with SMTP id u5mr5307707pgh.237.1589485409839;
        Thu, 14 May 2020 12:43:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q201sm21374pfq.40.2020.05.14.12.43.28
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 May 2020 12:43:29 -0700 (PDT)
Message-ID: <5ebd9f61.1c69fb81.23e4d.01b7@mx.google.com>
Date:   Thu, 14 May 2020 12:43:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.223-41-g1ec0b5b2a219
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.9.y boot: 111 boots: 2 failed,
 97 passed with 5 offline, 7 untried/unknown (v4.9.223-41-g1ec0b5b2a219)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 111 boots: 2 failed, 97 passed with 5 offline, =
7 untried/unknown (v4.9.223-41-g1ec0b5b2a219)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.223-41-g1ec0b5b2a219/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.223-41-g1ec0b5b2a219/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.223-41-g1ec0b5b2a219
Git Commit: 1ec0b5b2a21953a0c2a78b9379ddfc62152f044b
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 59 unique boards, 19 SoC families, 19 builds out of 197

Boot Regressions Detected:

arm:

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.9.223-41-g2d1298010c=
4a)
          omap3-beagle-xm:
              lab-baylibre: new failure (last pass: v4.9.223-41-g2d1298010c=
4a)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.22=
3 - first fail: v4.9.223-25-g6dfb25040a46)

    sunxi_defconfig:
        gcc-8:
          sun4i-a10-olinuxino-lime:
              lab-baylibre: new failure (last pass: v4.9.223-41-g2d1298010c=
4a)

Boot Failures Detected:

arm:
    omap2plus_defconfig:
        gcc-8:
            omap3-beagle-xm: 1 failed lab

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

---
For more info write to <info@kernelci.org>
