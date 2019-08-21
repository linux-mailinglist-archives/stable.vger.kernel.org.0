Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7801197479
	for <lists+stable@lfdr.de>; Wed, 21 Aug 2019 10:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726513AbfHUINV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Aug 2019 04:13:21 -0400
Received: from mail-wm1-f54.google.com ([209.85.128.54]:53177 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726217AbfHUINR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Aug 2019 04:13:17 -0400
Received: by mail-wm1-f54.google.com with SMTP id o4so1149817wmh.2
        for <stable@vger.kernel.org>; Wed, 21 Aug 2019 01:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1LsdYuCVxtL54AIcCRnwHe0dtBkzpAiOWFn7y/BLtL4=;
        b=KXiC44uwMtpXZLAsdoezxREXZH5MBcvRDuWNgunalXzZM7raDy4B2TXZBXGGkxaNBC
         MJbC4WTcQZp4CltkwM8nyQWuA2TdWQgQrSDgNpW2O/94E2ErjFmQDcfZG7U3t0rvq9a7
         iY61Svojbx4JBpL5KXAxxCRbJy+tiXazG+eSBIDhJLTk89PUMaDzHnJI9deW2iMulG01
         4Dex7F+is2Xaq9q5sUvvjAvhd7lj//I6YszsRwJyEwCrHJMYyxRqT1WKjrQjQNL+ELS5
         t0WBsFxxHvsvjU8gxHDuaZ3vZrtMIeeOYnUmjy4AaO3B+LQ4Gs0CpOEa73pKGnZTKpQp
         g2JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1LsdYuCVxtL54AIcCRnwHe0dtBkzpAiOWFn7y/BLtL4=;
        b=j91dBZuddaiZNqN5w74enOFXYjmBSbSCHpPhonl//8c+NQIWX5EDiBAAz03vT14Ppx
         uC80iauQnnI8aGxwn4e/U8vk/r3fCpaNaxnXcbnqbE+Aaph7f/bjRzPJw4LnkWj3WmZF
         LkRv0kEF+OM8myB5X8YkPYuMgy1LNCHXgqopfoIeP4sb/ybFogXgJ4G+CaM/6cdomW3E
         gXgcF0CA7gdwoQoVgqX0tLxWcIDoiwq1VMUTN5ls2s+59UlABinSixMjA8VQNLRjCl3/
         XkpSNRVflYsfnYFhOyn3hpm/c+kYeQ4PYtlNDmK/Dmvezdc38rGQdGx/k/QsPesCI7o4
         XgXg==
X-Gm-Message-State: APjAAAX7+xFUZhlUZLz3FCtjpOCQ24/mltvQ+JhF1HDuSbZy12B0RKUH
        gbSMUbnUrByOFBHJtfhURiwgNpIW1ZkZ6Q==
X-Google-Smtp-Source: APXvYqyZbEUNFImt2cvmbx5Q0Q3IH+m45gMq6zRZyd8rP4Q2qqoddqMiWfm/5Lq6+iAJZ7aO6X0ziw==
X-Received: by 2002:a7b:c928:: with SMTP id h8mr4635464wml.93.1566375194574;
        Wed, 21 Aug 2019 01:13:14 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id c201sm5850160wmd.33.2019.08.21.01.13.13
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 21 Aug 2019 01:13:14 -0700 (PDT)
Message-ID: <5d5cfd1a.1c69fb81.107c0.8870@mx.google.com>
Date:   Wed, 21 Aug 2019 01:13:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.189-97-g6971d2d959e5
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 106 boots: 0 failed,
 91 passed with 15 offline (v4.9.189-97-g6971d2d959e5)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 106 boots: 0 failed, 91 passed with 15 offline =
(v4.9.189-97-g6971d2d959e5)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.189-97-g6971d2d959e5/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.189-97-g6971d2d959e5/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.189-97-g6971d2d959e5
Git Commit: 6971d2d959e5319d600ba42319ef91d4a043cbde
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 52 unique boards, 21 SoC families, 15 builds out of 197

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-96-g4c=
d56b7fcd6f)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-96-g4c=
d56b7fcd6f)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-96-g4c=
d56b7fcd6f)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-96-g4c=
d56b7fcd6f)
          juno-r2:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-96-g4c=
d56b7fcd6f)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: new failure (last pass: v4.9.189-96-g4c=
d56b7fcd6f)

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

---
For more info write to <info@kernelci.org>
