Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDD52AFEC8
	for <lists+stable@lfdr.de>; Thu, 12 Nov 2020 06:40:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbgKLFiy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Nov 2020 00:38:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729147AbgKLE5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Nov 2020 23:57:09 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4BDC0613D4
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:57:07 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z3so3360973pfb.10
        for <stable@vger.kernel.org>; Wed, 11 Nov 2020 20:57:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ohtH8VyvWqZBwrDdxhwjAtl2zHpeCt36BNBNPMr+sVM=;
        b=Yfcbk9s1f4tYrnoL7GbFgiwKAJOY+BYo1+OPDPCPvu+MAPieZLZLS6UUEdHqiEYfmF
         3XT/4jy8L+t6v73RCEvM3cRdXIPcik2aun/cfcn5hVaZK9szZq/W0T/TiXUlOW8Pud8k
         yFB5ygyow/fEKBwHUjko5o4RJLb8bf6Qkyxrc0a0NEGKY1xAH+dM8aUPfSrpydjrd0Fb
         1irfLFr/cOzmoPiuQ1ZAhSqXS3U7xmLOCgqLcksHkYfKBrz1jLYwgndF0kvKsd9uWhYA
         ZVb5zKT0bSi4vgaEMXQuPG02m2t/RndjHXMdgLB13s8usm3KWaB2bOsyL6vOT8e1ojeX
         Eyqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ohtH8VyvWqZBwrDdxhwjAtl2zHpeCt36BNBNPMr+sVM=;
        b=rmNzGVqF41K5tC2cUkxXlIVWP8kYtam8Bc3HB8UxONr6+0aqK4Qp5OfS720yXom4Mu
         J242gvrBVQnC1JiscNTviPIRExV4yYMIQO5RSD3cedbVP1Mo7VwAfTCBiDb7gogJJ+42
         IBX8EH/RuHQuypqJ/bI45EFYSKD8224ZuZqk6WLifBG0DEXimB7HNPb0LLcdJrKtFa/I
         kROEcIz0Jxml2P5/I8QkpiK9qDtcMnMLoG4MwNFRKqiU3RHaIvKvOnfeRMr/G0cPE1lZ
         fUn2byi9t9BUTdrccyIpwjILe2ZchReM/gjewh+DqrNhQagtZB4lfonn/GbcT0+SYq5O
         RFUg==
X-Gm-Message-State: AOAM533iO9GhA59SBqWXYMms+nRkadAmcDbDbAZyZuu6iwfDJN4m3isu
        oAMuenIwBtFA0Hoz+YdeTJfEan6yh+dYzw==
X-Google-Smtp-Source: ABdhPJzpyNyxQrvfwSfac2/4dN8X5qj0gKnGEJEs3ow608UJek0wWsQjUKOuZwloxgQrVo7N5+OKkA==
X-Received: by 2002:a17:90a:bd14:: with SMTP id y20mr2331794pjr.107.1605157026785;
        Wed, 11 Nov 2020 20:57:06 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q13sm4627582pfg.64.2020.11.11.20.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Nov 2020 20:57:06 -0800 (PST)
Message-ID: <5facc0a2.1c69fb81.98a1a.a633@mx.google.com>
Date:   Wed, 11 Nov 2020 20:57:06 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.157-26-ga8e7fec1fea1
Subject: stable-rc/linux-4.19.y baseline: 178 runs,
 3 regressions (v4.19.157-26-ga8e7fec1fea1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 178 runs, 3 regressions (v4.19.157-26-ga8e=
7fec1fea1)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.157-26-ga8e7fec1fea1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.157-26-ga8e7fec1fea1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a8e7fec1fea1308f8e88229035715fa5ab2611fc =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
bcm2837-rpi-3-b       | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fac8fe8de84411208db8864

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-26-ga8e7fec1fea1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-26-ga8e7fec1fea1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5fac8fe8de844112=
08db8867
        new failure (last pass: v4.19.157)
        1 lines

    2020-11-12 01:27:12.148000+00:00  Connected to bcm2837-rpi-3-b console =
[channel connected] (~$quit to exit)
    2020-11-12 01:27:12.148000+00:00  (user:khilman) is already connected
    2020-11-12 01:27:28.125000+00:00  =00
    2020-11-12 01:27:28.125000+00:00  =

    2020-11-12 01:27:28.142000+00:00  U-Boot 2018.11 (Dec 04 2018 - 10:54:3=
2 -0800)
    2020-11-12 01:27:28.142000+00:00  =

    2020-11-12 01:27:28.142000+00:00  DRAM:  948 MiB
    2020-11-12 01:27:28.157000+00:00  RPI 3 Model B (0xa02082)
    2020-11-12 01:27:28.246000+00:00  MMC:   mmc@7e202000: 0, sdhci@7e30000=
0: 1
    2020-11-12 01:27:28.278000+00:00  Loading Environment from FAT... *** W=
arning - bad CRC, using default environment =

    ... (371 line(s) more)  =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
meson-gxm-khadas-vim2 | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fac912ab48075fdd7db885f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-26-ga8e7fec1fea1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-26-ga8e7fec1fea1/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-k=
hadas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fac912ab48075fdd7db8=
860
        new failure (last pass: v4.19.157) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fac8efb87d30b0c0bdb889f

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-26-ga8e7fec1fea1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
57-26-ga8e7fec1fea1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fac8efb87d30b0=
c0bdb88a4
        failing since 1 day (last pass: v4.19.155-42-g97cf958a4cd1, first f=
ail: v4.19.157)
        2 lines

    2020-11-12 01:25:06.693000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/107
    2020-11-12 01:25:06.702000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
