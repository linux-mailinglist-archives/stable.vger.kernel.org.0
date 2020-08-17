Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A24DF24777A
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 21:49:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729243AbgHQTtk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 15:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732778AbgHQTth (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Aug 2020 15:49:37 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2039AC061342
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:49:37 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id a79so8737653pfa.8
        for <stable@vger.kernel.org>; Mon, 17 Aug 2020 12:49:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=y3rNw5849pF0ub5+x7IDKad5HNQPjwKH++4mnM5vpjE=;
        b=pqshLm+NLHBt4XU4O3iLK1KdDBwhukiznfCqVHR8QUQxLkw/gv7Y0SIv9rt/lbAlg8
         9VaYnQPYqR5BSv2zIsZR8q8klpiWemMAxJNDGPwIxO+tBqBnYTtufRJWOlgDgkqSQGM8
         PE3jvrd6iuCj1PZsHVBcmrQZQXbMsEwaRUzyrdRd8CltBtNjzeimCst4TGAOp1S2xzaO
         R4n2cwHglkiWJbfsfRAc8WyqAFhS6F+BIjuTpcga7Fvqb4OEFw7kJ8eGcEQzKVYYaOD0
         /sNbDn5W4iIFAX6xrvn5fzy1BGgjgyxFwfNoNcP3xTtsJY0rPngKdeSBBbilaip8oiDp
         2Gog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=y3rNw5849pF0ub5+x7IDKad5HNQPjwKH++4mnM5vpjE=;
        b=MMXe5St8kM8BC16tWH665il1o8brenp7hZEX9VQCzLVXRgVE4hCqMMAS3bz7/Qacio
         cRcNLWyrHt81SbbW/z4rqvDBhbtxsL9tfXkhX1bhg8W/+Ko7OP43rrwgDX6kUHszs62Y
         t+Te1Fy6NYbE3pqkUvDNe91T1i/iB19RzQSD973Ukf0ODhb93/B2UDo679T5rzB0ynIw
         bwwBmksDoJ/bWsejYbA9+IPwn3M0qiV86VrpEZMLC+G/6ZV3xghFzm1Xs2YWEi01FJ/0
         S+dcDEry+yjO9BKo9uG23tZLN5zznOIRX8rSWtbOvYrZEFwBKI6hYR0+GahqHuCcFLgA
         Zatg==
X-Gm-Message-State: AOAM533vLhxDSxFoQqhzvG/Tko9ir0yyVNVRWmlnvp7gcLzRzm0L5lEw
        dTeSxXYGeCLF2bYe5HuVrEBHyT3x2+oXsg==
X-Google-Smtp-Source: ABdhPJxt4oCpQK1ileNmI/HH6BDQQqU4W5VnYeO9EBFhvIWjIPsDYjtd4Q/5jIqC59SRqAxpr8wgfg==
X-Received: by 2002:aa7:93a6:: with SMTP id x6mr12628425pff.37.1597693775597;
        Mon, 17 Aug 2020 12:49:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13sm20274210pfo.49.2020.08.17.12.49.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2020 12:49:34 -0700 (PDT)
Message-ID: <5f3adf4e.1c69fb81.81d36.1fb5@mx.google.com>
Date:   Mon, 17 Aug 2020 12:49:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.139-169-g9950f9b4d350
X-Kernelci-Branch: linux-4.19.y
Subject: stable-rc/linux-4.19.y baseline: 183 runs,
 4 regressions (v4.19.139-169-g9950f9b4d350)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 183 runs, 4 regressions (v4.19.139-169-g99=
50f9b4d350)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 4/5    =

hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig   =
  | 0/1    =

omap3-beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.139-169-g9950f9b4d350/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.139-169-g9950f9b4d350
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9950f9b4d350ca9b4f05daa2d16b090000b1d2d7 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig  =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3aad2ba8902682dfd99a5d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-s=
ama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3aad2ba8902682dfd99=
a5e
      failing since 62 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88)  =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig        =
  | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f3aa9eff86774ae33d99a6c

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3aa9eff86774ae=
33d99a6f
      failing since 5 days (last pass: v4.19.138-49-gb0e1bc72f7dd, first fa=
il: v4.19.139)
      1 lines

    2020-08-17 16:01:35.154000  / # =

    2020-08-17 16:01:35.165000  =

    2020-08-17 16:01:35.269000  / # #
    2020-08-17 16:01:35.278000  #
    2020-08-17 16:01:36.536000  / # export SHELL=3D/bin/sh
    2020-08-17 16:01:36.547000  export SH[   16.490183] brcmfmac: brcmf_sdi=
o_htclk: HT Avail timeout (1000000): clkctl 0x50
    2020-08-17 16:01:36.547000  ELL=3D/bin/sh[   17.149235] hwmon hwmon1: U=
ndervoltage detected!
    2020-08-17 16:01:36.547000  =

    2020-08-17 16:01:38.167000  / # . /lava-286204/environment
    2020-08-17 16:01:38.178000  . /[   17.405179] Bluetooth: hci0: command =
0xfc18 tx timeout
    ... (12 line(s) more)
      =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
hsdk                  | arc   | lab-baylibre | gcc-8    | hsdk_defconfig   =
  | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3aad2c868277c17bd99a65

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3aad2c868277c17bd99=
a66
      failing since 27 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24)  =



platform              | arch  | lab          | compiler | defconfig        =
  | results
----------------------+-------+--------------+----------+------------------=
--+--------
omap3-beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfi=
g | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3aaf6e4556e3d9f9d99a68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-oma=
p3-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39-169-g9950f9b4d350/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-oma=
p3-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3aaf6e4556e3d9f9d99=
a69
      new failure (last pass: v4.19.139)  =20
