Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907201BD547
	for <lists+stable@lfdr.de>; Wed, 29 Apr 2020 09:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgD2HA5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Apr 2020 03:00:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726158AbgD2HA5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Apr 2020 03:00:57 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63656C03C1AD
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 00:00:57 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id q124so577853pgq.13
        for <stable@vger.kernel.org>; Wed, 29 Apr 2020 00:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qZXsCr3o2RA5JehQvIaspnv7QcHasaMxtPPwAf+Cims=;
        b=xwdcWrb+VKRJmOpS+Ek+OMts7JgeWszmglDsIk4ja0VLeQZZT/HZBhD/DvS9CruaEi
         WnPcL+04MUlh3vNjPWMNjyBUQQ2R0W7Az1rbotfIx5YR3tXuNh+ZUwh39ZLxG/q2nTo8
         mjH983ZzcNdKGBFL117jsAMD05RxZ3EGimBZOeAT0hrrOfzb6BLTdmp8ZvUOfUWpCCx1
         cTRFkGREzJtUrG2QcIlpzRP7Odyusb+seGLZT83LUTUYv19/2pz7NJx4e3NDiuOEzOb2
         Xmnd4TacUuD+1dOqvch0ZSTseODyIVKJKsNy6/73w78gB7+FtV28RGYUiB727fCWhJH1
         TmEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qZXsCr3o2RA5JehQvIaspnv7QcHasaMxtPPwAf+Cims=;
        b=WGueqBlCUslU5Fr21uhcbNPeX5b2bPWf9SEI6yh2IKpgzDye41anTZaPqF189EnYHM
         GG2mKU2cvZ0OBc96kXnUUvhL/r+TPwRbollh4ti/4VU/2icu4oVPMf7Ul2/PgrPcFm9P
         t2Niu2bbfrssVr/UDNy2xq/o1Gx4eUZX0dG+MAC3619REr5CGbx2RR7X7NxvKcRGmIRu
         CtmtdRZxjRZWNfmRAqPSe/BvRHHnEnNPbJeDgfCJXyqKG4exbwPl8203jzwNSFx22IHU
         S1Bs1TxtbzCXd7A7TtOoZ/CJrN9ZtKtHk+paaaJhXChPUFUGlPKv2ETiYQ+f8nMXUKCP
         NMCw==
X-Gm-Message-State: AGi0PuZeCz13QtDWkUMTJqicR9XUlbnTd/jVIi0RlcSbynPmzOzLXaVi
        qxi65mWankFZCN0d1d3lqvR1mMOwcwc=
X-Google-Smtp-Source: APiQypJNCS5o0xUGBb0sVmbp06aFoLVSLY+buc5abXifzc+v1W1QSJ3ER5cAHDSb9bnXrUSTEspn6Q==
X-Received: by 2002:a63:4c08:: with SMTP id z8mr31234278pga.175.1588143655525;
        Wed, 29 Apr 2020 00:00:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 71sm304511pfw.111.2020.04.29.00.00.54
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 00:00:54 -0700 (PDT)
Message-ID: <5ea92626.1c69fb81.f51b3.0c1d@mx.google.com>
Date:   Wed, 29 Apr 2020 00:00:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.35-169-g388ff47a1fba
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-5.4.y boot: 172 boots: 3 failed,
 155 passed with 6 offline, 8 untried/unknown (v5.4.35-169-g388ff47a1fba)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y boot: 172 boots: 3 failed, 155 passed with 6 offline,=
 8 untried/unknown (v5.4.35-169-g388ff47a1fba)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-5.4.y/kernel/v5.4.35-169-g388ff47a1fba/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-5.4.y=
/kernel/v5.4.35-169-g388ff47a1fba/

Tree: stable-rc
Branch: linux-5.4.y
Git Describe: v5.4.35-169-g388ff47a1fba
Git Commit: 388ff47a1fba8fa27be759acc4f846a75df6bde0
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 105 unique boards, 26 SoC families, 22 builds out of 200

Boot Regressions Detected:

arc:

    hsdk_defconfig:
        gcc-8:
          hsdk:
              lab-baylibre: new failure (last pass: v5.4.35-168-g0e134cd8e4=
2d)

arm:

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 80 days (last pass: v5.4.=
17-99-gbd0c6624a110 - first fail: v5.4.17-238-gbffcaa93483d)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 21 days (last pass: v5.4.30-37-g4=
0da5db79b55 - first fail: v5.4.30-39-g23c04177b89f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v5.4.35-168-g0e134cd8e=
42d)

arm64:

    defconfig:
        gcc-8:
          meson-axg-s400:
              lab-baylibre-seattle: new failure (last pass: v5.4.35-168-g0e=
134cd8e42d)
          sun50i-a64-pine64-plus:
              lab-baylibre: new failure (last pass: v5.4.35-168-g0e134cd8e4=
2d)

i386:

    i386_defconfig:
        gcc-8:
          qemu_i386:
              lab-baylibre: new failure (last pass: v5.4.35-168-g0e134cd8e4=
2d)
              lab-collabora: new failure (last pass: v5.4.35-168-g0e134cd8e=
42d)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 2 failed labs

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

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

---
For more info write to <info@kernelci.org>
