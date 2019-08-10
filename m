Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29FB188845
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 06:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725554AbfHJExK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 00:53:10 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35452 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725497AbfHJExK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 00:53:10 -0400
Received: by mail-wm1-f66.google.com with SMTP id l2so7287563wmg.0
        for <stable@vger.kernel.org>; Fri, 09 Aug 2019 21:53:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TE626OF7ps8WUE97ci/gUNr7eXf/F0v8GP5SopSyxTM=;
        b=aRKbt+5WfkeseaT/uQNXGR5/AcDkwf5XCanqUHg/BV4xy92XCbZbmce6/dk5YbwlAf
         PnYoRlNz9W8gNPznerDEQ/jcWiZUvB/hKwcFOe5K3Yn05MyrlzPekgdBpar2ORyjHkzS
         fltaX8+FSnmTCfn61rHItDwoY3Uizh5xNxIdqCGaTgEM5mL1tpY3bbx9Rkt0n4kOWCj1
         wjXCS3X7dk5sM9WCDr3rtRHNopvjk2Kbm16eor0kkFnwiQY36CZsHnaVOaYCy8KrdcPW
         XkYrRSbphN166Z6xxgjd7nbHzAFFZFkite8IBtGFJ0EzHWzSA0tuoCehExDWidSLPk5O
         lcFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TE626OF7ps8WUE97ci/gUNr7eXf/F0v8GP5SopSyxTM=;
        b=KfMdLEGGELSJmeheSTQROHIJj5NXYHhP9XzNF00cU5of5kYPUlqTTNnJDx+ofVXg2N
         kyfq2DpVQGEzi2L6QZzW8MXraq/Ptr2Z2zpWtgyKlVkC+TTJ+zslT98ploKMfBIKi4dd
         rvbLtU9PNG2Km+XHjbM9u18zq8mHNOj2TrBFwBN3Bo68mtZ1+PLYp+olK4WwqszLGef2
         uJOcnsXDL7t+UtTySu1uFvO1rQ4kIN4AAM7S2wL1t1G26apyXT5yOfLeDDCpLCXJ58UP
         T8tFAEZpu9qGjABYR8eQykp/abTItQruwAI1A4r7QsbBAUzn/h+Z1T4/CUkAx+1Pb3XG
         ApcQ==
X-Gm-Message-State: APjAAAXnQB2H7iZzsJTAozwmw1WaUg37yw5z2CgKwoM7OL+MbWoX3Bq4
        Icx24K1hkT/vUSLpl5A9rbzQTg1OnT/lDA==
X-Google-Smtp-Source: APXvYqw9YJRe8mhh6/QNbuIZx+sf7c/QkGHimev3HgFEQDmSJgW+sDUgdlZ58kaKXdCQlBMtqr7tDA==
X-Received: by 2002:a7b:c8c3:: with SMTP id f3mr15072695wml.124.1565412787550;
        Fri, 09 Aug 2019 21:53:07 -0700 (PDT)
Received: from [148.251.42.114] ([2a01:4f8:201:9271::2])
        by smtp.gmail.com with ESMTPSA id f134sm16472191wmg.20.2019.08.09.21.53.06
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Aug 2019 21:53:07 -0700 (PDT)
Message-ID: <5d4e4db3.1c69fb81.bf958.2703@mx.google.com>
Date:   Fri, 09 Aug 2019 21:53:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.188-33-g260869840af4
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: boot
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y boot: 102 boots: 0 failed,
 90 passed with 12 offline (v4.9.188-33-g260869840af4)
To:     stable@vger.kernel.org
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y boot: 102 boots: 0 failed, 90 passed with 12 offline =
(v4.9.188-33-g260869840af4)

Full Boot Summary: https://kernelci.org/boot/all/job/stable-rc/branch/linux=
-4.9.y/kernel/v4.9.188-33-g260869840af4/
Full Build Summary: https://kernelci.org/build/stable-rc/branch/linux-4.9.y=
/kernel/v4.9.188-33-g260869840af4/

Tree: stable-rc
Branch: linux-4.9.y
Git Describe: v4.9.188-33-g260869840af4
Git Commit: 260869840af4f3d7b3b46c4047642a931535c196
Git URL: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stabl=
e-rc.git
Tested: 51 unique boards, 22 SoC families, 15 builds out of 196

Boot Regressions Detected:

arm:

    bcm2835_defconfig:
        gcc-8:
          bcm2835-rpi-b:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    sama5_defconfig:
        gcc-8:
          at91-sama5d4_xplained:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

    socfpga_defconfig:
        gcc-8:
          socfpga_cyclone5_de0_sockit:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

arm64:

    defconfig:
        gcc-8:
          apq8016-sbc:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)
          juno-r2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)
          meson-gxbb-odroidc2:
              lab-baylibre-seattle: failing since 1 day (last pass: v4.9.18=
7-43-g228fba508ff1 - first fail: v4.9.187-71-g399cf2b4ebf0)

Offline Platforms:

arm64:

    defconfig:
        gcc-8
            apq8016-sbc: 1 offline lab
            juno-r2: 1 offline lab
            meson-gxbb-odroidc2: 1 offline lab

arm:

    bcm2835_defconfig:
        gcc-8
            bcm2835-rpi-b: 1 offline lab

    sama5_defconfig:
        gcc-8
            at91-sama5d4_xplained: 1 offline lab

    multi_v7_defconfig:
        gcc-8
            alpine-db: 1 offline lab
            at91-sama5d4_xplained: 1 offline lab
            bcm4708-smartrg-sr400ac: 1 offline lab
            socfpga_cyclone5_de0_sockit: 1 offline lab
            sun5i-r8-chip: 1 offline lab

    socfpga_defconfig:
        gcc-8
            socfpga_cyclone5_de0_sockit: 1 offline lab

    sunxi_defconfig:
        gcc-8
            sun5i-r8-chip: 1 offline lab

---
For more info write to <info@kernelci.org>
