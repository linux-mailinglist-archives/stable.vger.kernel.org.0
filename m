Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B272691629
	for <lists+stable@lfdr.de>; Sun, 18 Aug 2019 12:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRKi4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Aug 2019 06:38:56 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:45434 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbfHRKi4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Aug 2019 06:38:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id q12so5700730wrj.12
        for <stable@vger.kernel.org>; Sun, 18 Aug 2019 03:38:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YK6HhRwlsPE9/poVX/wqKFdtISUObpWQAIqZsxObYFU=;
        b=cE4GRQ9EsRCxtJuiiq8zLhpNviWoVgIiyM4burz5jEVx4yYidiYuurUiqz1eVW3HnE
         nsjBtCbuwaM/Nrqv/Xw4tgooWyLLQmNgGUFhbldL8B5AjGzKq71F013iaAqtcKShBoEV
         Ynb5l8A8TagTPNFn8WkJRtblVBNS575BqtttWJz20ySTMXYJSDzT5418QmdJlFfG2H1/
         EF9wy+JzEvBRT3eAGSmdvgf4ttj27aTe/xSEyYBGg0NRJX18Fg1/+V6Hj0lZrwtRyQ5A
         nAMhzY0e3LKr8yC6NxXGosFIKaqBdLUR2/oDKUXAxaHKzudJEAprOIir4Fd/TuUvvr9i
         LXMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YK6HhRwlsPE9/poVX/wqKFdtISUObpWQAIqZsxObYFU=;
        b=XknjoGEoeF6qhVy88gs6ttBi2pxULb3EdqsYruSePlrLce77/vrTzvOKKH+RUFnqke
         xL1+Vi9/ce+/fuY+8wYVVJFcDv9QcIf98JAYgwzE/EKm/flkLQQ+L9Bt1/d6TsS9KreO
         riqVFxqyWZtTdUcUP/HkaE+QE91uXn8em4woV9otGTmIbE5EVZboA/NQ9ZGJ2lIWyxMX
         r8OtvcRLqIi/E0KTA6rlINTB14Y1MTcdfcGuZ55LcaLKRZ083LpQCyxHbWrFdnXKy9ka
         yXS32XUR/MgsjncV5cUq7bEdqLieb5j4o2RrmYwVQlguaa7xL5ShzRf0qnCfD3PrpjZY
         RFZw==
X-Gm-Message-State: APjAAAV8epTOLeslG29Po1btdAOIGZ6wQTgwY22TS9GMpvcVJWH3tEIE
        kY+x6l3IFDm/EmlyeOu9gEzqFZdjEso=
X-Google-Smtp-Source: APXvYqzk0aH7ImYmLr/0m2N6r3uURfApNv5kr3VE12GPvhGi7d1ADLb3VaOVupttFgTXYH1Mifg3PQ==
X-Received: by 2002:a5d:4f91:: with SMTP id d17mr20491286wru.74.1566124734263;
        Sun, 18 Aug 2019 03:38:54 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id t198sm18426495wmt.39.2019.08.18.03.38.52
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 18 Aug 2019 03:38:53 -0700 (PDT)
Message-ID: <5d592abd.1c69fb81.3f2fe.a87d@mx.google.com>
Date:   Sun, 18 Aug 2019 03:38:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-69-g711554dc8b12
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 103 boots: 2 failed,
 84 passed with 15 offline, 1 untried/unknown,
 1 conflict (v4.9.189-69-g711554dc8b12)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 103 boots: 2 failed, 84 passed with 15 offline,=
 1 untried/unknown, 1 conflict (v4.9.189-69-g711554dc8b12)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-69-g711554dc8b12/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-69-g711554dc8b12/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-69-g711554dc8b12
Git Commit: 711554dc8b12a12296caa81eeffa307dc369f68f
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 22 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-44-g75=
5768e31f44)

    multi_v7_defconfig:
        gcc-8:
          exynos5800-peach-pi:
              lab-collabora: new failure (last pass: v4.9.189-44-g755768e31=
f44)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-44-g75=
5768e31f44)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-44-g75=
5768e31f44)

    sunxi_defconfig:
        gcc-8:
          sun7i-a20-cubietruck:
              lab-baylibre: new failure (last pass: v4.9.189-44-g755768e31f=
44)

    tegra_defconfig:
        gcc-8:
          tegra124-nyan-big:
              lab-collabora: new failure (last pass: v4.9.189-44-g755768e31=
f44)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-44-g75=
5768e31f44)
          juno-r2:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-44-g75=
5768e31f44)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-44-g75=
5768e31f44)

Boot Failures Detected:

arm:
    tegra_defconfig:
        gcc-8:
            tegra124-nyan-big: 1 failed lab

    sunxi_defconfig:
        gcc-8:
            sun7i-a20-cubietruck: 1 failed lab

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    qcom_defconfig:
        gcc-8
            qcom-apq8064-cm-qs600: 1 offline lab
            qcom-apq8064-ifc6410: 1 offline lab

Conflicting Boot Failure Detected: (These likely are not failures as other =
labs are reporting PASS. Needs review.)

x86_64:
    x86_64_defconfig:
        qemu:
            lab-baylibre: PASS (gcc-8)
            lab-mhart: PASS (gcc-8)
            lab-linaro-lkft: FAIL (gcc-8)
            lab-drue: PASS (gcc-8)
            lab-collabora: PASS (gcc-8)

---
For more info write to <info@kernelci.org>
