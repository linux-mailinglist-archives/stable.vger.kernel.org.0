Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F46B1A1783
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 23:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgDGVvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 17:51:13 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:55165 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726380AbgDGVvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 17:51:13 -0400
Received: by mail-pj1-f54.google.com with SMTP id np9so308211pjb.4
        for <stable@vger.kernel.org>; Tue, 07 Apr 2020 14:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pX8HPw6kZcAaA6I6I6wqPFsFzEYf/kKjD7ej3iu5ce8=;
        b=chFkQnQJhsL7pLMrWfcsfpHo8Tx6FX9FtauthaC0QlDqTzB0Z1o1pgxXpd3JTnTdPk
         w0P2vXaU/7Sb/zrm/+SBbA/c0ORNQ8/cRgFE/ZnBRCvMFsVO8WGOfwH/7FCuY9xgXEgk
         O9c94p+IBfDJrIDeNLFiPAp5BwAxbA6Hbb3Spi1LwVhi30lAdIz57SpyGFTHDsEbSL3m
         W5dMZ6T4eajlcG2GCNt56NBHM8y8CJC3wRUVHpfY8mi8PfrlcWOF5jj/qhYP3bDATr3O
         aqfAmpE9yaYb7EHFqKr85zNtFR1tlhJ10NHhFsGIGAMEx+ICGQMbKoZT/9OBWxfuVA8q
         Or0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pX8HPw6kZcAaA6I6I6wqPFsFzEYf/kKjD7ej3iu5ce8=;
        b=OTrJ94nzb0yupdps/qJEfFy7oSH6fhl/qfFnK7A9Xp1943MULSLBXnz3pAvHUtBziU
         yuCiNs5uNayi/a79bY6EI+CGKpIpMm2VuLRIBTGJfgLgCeB2PlqBv+EJ4c8k7B245dd6
         LIiCg/XoVG0V9M/6QoWWoWJGVTNotNYVpLy1IkqjM4dpT/4ha5qS+G/vKdKfjXjbq0xo
         +FHpEllTjmn5qgTYG0NDggbhpXiMCSxaXxkAzuYxzd9Yln+/9wxh2p4YGMukZo+Ts/ZU
         AOzIdlJ6KOwvXfhJDOUyhLnFsDrSHJcOp3XBSOIsGbqaTXRpkCZxra+PipGfaImuQMfS
         G1+w==
X-Gm-Message-State: AGi0PubLntN+rEkvKah8IZODiVSiTkn+3nbp7AbxFQHKfdWxs9Nwvz8u
        6EaHeZfxI2dMpXrBR/ubpAmeevZz/FU=
X-Google-Smtp-Source: APiQypKJvIzwOl3BnAyknrPQyeh+W+DMhVt8de5Q27mMJgtTvbiSM2nxAzgRLA06nySzBThPx8o/qg==
X-Received: by 2002:a17:90a:c583:: with SMTP id l3mr1603272pjt.84.1586296270839;
        Tue, 07 Apr 2020 14:51:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m2sm2450919pjl.21.2020.04.07.14.51.10
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 14:51:10 -0700 (PDT)
Message-ID: <5e8cf5ce.1c69fb81.f96ac.a669@mx.google.com>
Date:   Tue, 07 Apr 2020 14:51:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.6.2-30-g14d42f1aa3c3
X-Kernelci-Report-Type: boot
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.6.y
Subject: stable-rc/linux-5.6.y boot: 164 boots: 3 failed,
 148 passed with 7 offline, 6 untried/unknown (v5.6.2-30-g14d42f1aa3c3)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y boot: 164 boots: 3 failed, 148 passed with 7 offline,=
 6 untried/unknown (v5.6.2-30-g14d42f1aa3c3)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.6.y/kernel/v5.6.2-30-g14d42f1aa3c3/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.6.y=
/kernel/v5.6.2-30-g14d42f1aa3c3/

Tree: stable-rc
Branch: linux-5.6.y
Git Describe: v5.6.2-30-g14d42f1aa3c3
Git Commit: 14d42f1aa3c34cb80141366c231981dff6cdc7cd
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 102 unique boards, 24 SoC families, 20 builds out of 200

Boot Regressions Detected:

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.6.2-29-g9995=
0f10b1ac)
          meson-gxl-s805x-p241:
              lab-baylibre: new failure (last pass: v5.6.2-29-g99950f10b1ac)

Boot Failures Detected:

arm:
    multi_v7_defconfig:
        gcc-8:
            bcm2836-rpi-2-b: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

Offline Platforms:

arm:

    davinci_all_defconfig:
        gcc-8
            da850-evm: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            stih410-b2120: 1 offline lab

    exynos_defconfig:
        gcc-8
            exynos5800-peach-pi: 1 offline lab

arm64:

    defconfig:
        gcc-8
            meson-axg-s400: 1 offline lab

---
For more info write to <info@kernelci.org>
