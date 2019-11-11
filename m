Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99856F80C7
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 21:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727022AbfKKUGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 15:06:17 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33114 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKUGR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Nov 2019 15:06:17 -0500
Received: by mail-wr1-f67.google.com with SMTP id w9so9241068wrr.0
        for <stable@vger.kernel.org>; Mon, 11 Nov 2019 12:06:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Z1fHuETOnhAQ8T5tT4QDSPuukK4Ri/GbRy/82ovi0sY=;
        b=FCHY37q/onzlMCzdfLoZZus2SJ+7oD8o9j94CoyVCjsiFHIyJeaeb3VIrh+0+cAVWn
         /OYuF2V0PhRT/W322bh9GMEhvcTAe/LEejyuFJTEmKKe4ziZCXvgh5VaBbg+CJuYY6Hd
         LOTdleGsYEd9KOc99ntFIa9cT7dFccHuymrlg7J18xCCOgBvUvcYjWcFmRCTobbQ1aeu
         ojIPSnBJw+ZAYIUu2mtBBbi7dLOPm7Q8aeoXHJcI0tKdidBjn2zb9tqYe1/plgZ11cQv
         Qc3SJdq0+j6Q2YXZaQx9LImtG3MNRolZrrm06p0ZAajdy4sagz0iafHG3NM2vQ744UKx
         Dvow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Z1fHuETOnhAQ8T5tT4QDSPuukK4Ri/GbRy/82ovi0sY=;
        b=kScIH2F2giMyQwmsVBYICdr9z+0MBWDvW+vuhh1r8dUN0nCebHanAjlmxrwxbnpPlW
         +unXGhCOQ4TD7cl9ESQ2agOYq85AaxmQlhtEzxIbK4A0AToe0v+wQ9/yPoFR+ZEvHvYU
         vL0W1emm3U8Prn2khNOPgOQuxaSYVKPAl2hvco/Lgm62QDeuVt2IPIwlrNEr8y7NcQY8
         PHMhzrXDteY+Ephq+H7uWXJ5bmtKE3L87sI2RizOlgwZ84+2NqK5K7V1LEOB85sCmWV0
         mAmb7DYL8+2Jk0ktcnnetZHUwrgffEJdn/43ZW/QrIEQfbqc5dULywEANWu3KORtdJSa
         vm1A==
X-Gm-Message-State: APjAAAVt003NQVWcDw1jpgJAwZeKKocIqSadpCoaEalTwHPYvTHYZyWs
        R8nYLfw4HyWaAN3oHrG8rJ8TnMt6+d8f9g==
X-Google-Smtp-Source: APXvYqzJYMoDMjcJ7GminosI8or1LfoQhnJawLj8FR0wf5s4agVyz58VjgAc7OrdQRBukdHXsSctyg==
X-Received: by 2002:a5d:6104:: with SMTP id v4mr21334920wrt.36.1573502773183;
        Mon, 11 Nov 2019 12:06:13 -0800 (PST)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id n13sm643926wmi.25.2019.11.11.12.06.12
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2019 12:06:12 -0800 (PST)
Message-ID: <5dc9bf34.1c69fb81.36a13.36b7@mx.google.com>
Date:   Mon, 11 Nov 2019 12:06:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Kernel: v4.14.153-68-g0d12dcf336c6
Subject: stable-rc/linux-4.14.y boot: 34 boots: 34 failed,
 0 passed (v4.14.153-68-g0d12dcf336c6)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y boot: 34 boots: 34 failed, 0 passed (v4.14.153-68-g0=
d12dcf336c6)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.14.y/kernel/v4.14.153-68-g0d12dcf336c6/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.14.=
y/kernel/v4.14.153-68-g0d12dcf336c6/

Tree: stable-rc
Branch: linux-4.14.y
Git Describe: v4.14.153-68-g0d12dcf336c6
Git Commit: 0d12dcf336c606a37cf2ad4319bc59f69eb6c255
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 23 unique boards, 9 SoC families, 8 builds out of 201

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    multi_v7_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.151)
          imx6q-sabrelite:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson8b-odroidc1:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          qemu_arm-virt-gicv2:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          qemu_arm-virt-gicv3:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    omap2plus_defconfig:
        gcc-8:
          am335x-boneblack:
              lab-baylibre: new failure (last pass: v4.14.151)
          omap4-panda:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

    sunxi_defconfig:
        gcc-8:
          sun5i-a13-olinuxino-micro:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun7i-a20-cubieboard2:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-a33-olinuxino:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-a83t-bananapi-m3:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
          sun8i-h2-plus-orangepi-zero:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)

arm64:

    defconfig:
        gcc-8:
          bcm2837-rpi-3-b:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxbb-p200:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-khadas-vim:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          meson-gxl-s905x-libretech-cc:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          qemu_arm64-virt-gicv2:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          r8a7795-salvator-x:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          r8a7796-m3ulcb:
              lab-baylibre: failing since 1 day (last pass: v4.14.153 - fir=
st fail: v4.14.153-40-gf7fb2676f8a6)
          sun50i-a64-bananapi-m64:
              lab-clabbe: failing since 1 day (last pass: v4.14.153 - first=
 fail: v4.14.153-40-gf7fb2676f8a6)

Boot Failures Detected:

i386:
    i386_defconfig:
        gcc-8:
            qemu_i386: 1 failed lab

arm:
    omap2plus_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            omap4-panda: 1 failed lab

    multi_v7_defconfig:
        gcc-8:
            am335x-boneblack: 1 failed lab
            exynos5422-odroidxu3: 1 failed lab
            imx6q-sabrelite: 1 failed lab
            meson8b-odroidc1: 1 failed lab
            omap4-panda: 1 failed lab
            qemu_arm-virt-gicv2: 1 failed lab
            qemu_arm-virt-gicv3: 1 failed lab
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun5i-a13-olinuxino-micro: 1 failed lab
            sun7i-a20-cubieboard2: 2 failed labs
            sun8i-a33-olinuxino: 1 failed lab
            sun8i-a83t-bananapi-m3: 1 failed lab
            sun8i-h2-plus-orangepi-zero: 1 failed lab

    exynos_defconfig:
        gcc-8:
            exynos5422-odroidxu3: 1 failed lab

    bcm2835_defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab

x86_64:
    x86_64_defconfig:
        gcc-8:
            qemu_x86_64: 1 failed lab

arm64:
    defconfig:
        gcc-8:
            bcm2837-rpi-3-b: 1 failed lab
            meson-gxbb-p200: 1 failed lab
            meson-gxl-s905x-khadas-vim: 1 failed lab
            meson-gxl-s905x-libretech-cc: 2 failed labs
            qemu_arm64-virt-gicv2: 1 failed lab
            qemu_arm64-virt-gicv3: 1 failed lab
            r8a7795-salvator-x: 1 failed lab
            r8a7796-m3ulcb: 1 failed lab
            sun50i-a64-bananapi-m64: 1 failed lab

---
For more info write to <info@kernelci.org>
