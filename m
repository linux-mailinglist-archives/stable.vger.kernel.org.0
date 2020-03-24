Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDED0191ABD
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 21:17:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgCXURx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 16:17:53 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:44182 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725941AbgCXURx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Mar 2020 16:17:53 -0400
Received: by mail-pg1-f194.google.com with SMTP id 142so4361786pgf.11
        for <stable@vger.kernel.org>; Tue, 24 Mar 2020 13:17:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CADAcQ/yKguJQMgNnz3WhGhlfzPoKau1QXrKIPhj4cQ=;
        b=cKVZdZ8f14DTJccW05yv6pZgoha02QjQFVmNPn/a+W4E5sUiYbnJ3K5oplSsRPJFdq
         KR5++kjsYbqfZm4/oXclcFVLUvivracjrDdpmdNVAR3I6MiBZdurtaukxFum5k4MTa/A
         bxjsBKoj5p+End6rEkdX6ItEMblqn9HdQ7LjKkS8OW6n7JP9gyOXR1b1pPPmKECZ0vS4
         V4B4qHCTvhCn+2YW3EYKzG1jB3IbwsUuVENz90WgUsdq3oPT2zGinlUwyN32EmIQAAdy
         HSh1MWKx9GrZaSrOD6hxzqYG8+RzNt5izVh17LpyTfA516hUonwNNLr/Vcz/pu6l+nSs
         QKSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CADAcQ/yKguJQMgNnz3WhGhlfzPoKau1QXrKIPhj4cQ=;
        b=ToKpkzHgZSn/UMDEIw5h88uc+cPgyi6xyTIjywmbxt0DBkzGh1KD8w7EnLrdkRhBGL
         uT0SbcCMs0cb9tXi8D8eOo5sQ3SwGyI7diAWDAFJ3l1Uk2ujpF64ISKGqLdxa724oK6m
         /wjQ1x5p5PJw49STdN89UOHQDkRQtrsLByOOCIOLb56GctTO3MppduXu5jntXFU3ZAYo
         BS/i946elGUYiDyotQI4oU/f7N1+f2LmR7RGr4ZaqUjFmZeNyWvvnmSJq3g+HaL+bmEG
         fobWRezbIiOAWEeDSphVJqP3+rV/epDbTW15xnEk5ufHKDdvp/xhwYGypxF6TVElfo4Z
         RJdg==
X-Gm-Message-State: ANhLgQ30vSp1efZ/A80VREbjp1yj/VvZ0yG6WlRtBpQ2IUZJdXTAnXLQ
        MFhVv2ZJvfpMbDuJbpxuJbnFPU5Z3fo=
X-Google-Smtp-Source: ADFU+vu/dYHwduYPs/mYCsI+R15kOHKmuterhWlc54bkafega45jMjme2QiGPoG7HqTqh6n3JBLfjA==
X-Received: by 2002:a62:ea1a:: with SMTP id t26mr30524371pfh.84.1585081072001;
        Tue, 24 Mar 2020 13:17:52 -0700 (PDT)
Received: from [10.0.9.4] ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e3sm15264883pgm.15.2020.03.24.13.17.51
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2020 13:17:51 -0700 (PDT)
Message-ID: <5e7a6aef.1c69fb81.a8ffc.b6e0@mx.google.com>
Date:   Tue, 24 Mar 2020 13:17:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.173-155-g78d092884075
X-Kernelci-Report-Type: boot
Subject: stable-rc/linux-4.14.y boot: 130 boots: 2 failed,
 118 passed with 4 offline, 6 untried/unknown (v4.14.173-155-g78d092884075)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 130 boots: 2 failed, 118 passed with 4 offline=
, 6 untried/unknown (v4.14.173-155-g78d092884075)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.173-155-g78d092884075/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.173-155-g78d092884075/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.173-155-g78d092884075
Git Commit: 78d0928840755f57ccd0fbd12e39d346519807db
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 73 unique boards, 21 SoC families, 18 builds out of 201

Boot Regressions Detected:

arm:

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.173-145-gfd0aa3aa=
cb6f)
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-145-g=
fd0aa3aacb6f)

    qcom_defconfig:
        gcc-8:
          qcom-apq8064-cm-qs600:
              lab-baylibre-seattle: failing since 45 days (last pass: v4.14=
.169-92-gb4137330c582 - first fail: v4.14.170-62-gd6856e4a2c23)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre: failing since 33 days (last pass: v4.14.170-141=
-g00a0113414f7 - first fail: v4.14.171-29-g9cfe30e85240)

    tegra_defconfig:
        gcc-8:
          tegra20-iris-512:
              lab-baylibre-seattle: new failure (last pass: v4.14.173-145-g=
fd0aa3aacb6f)

    versatile_defconfig:
        gcc-8:
          versatile-pb:
              lab-collabora: new failure (last pass: v4.14.173-145-gfd0aa3a=
acb6f)

Boot Failures Detected:

arm:
    sama5_defconfig:
        gcc-8:
            at91-sama5d4_xplained: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            meson-gxm-q200: 1 failed lab

Offline Platforms:

arm:

    multi_v7_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            tegra20-iris-512: 1 offline lab

    tegra_defconfig:
        gcc-8
            tegra20-iris-512: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab

---
For more info write to <info@kernelci.org>
