Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A64AC24238F
	for <lists+stable@lfdr.de>; Wed, 12 Aug 2020 03:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726255AbgHLBEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 21:04:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgHLBEj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 21:04:39 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26442C06174A
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 18:04:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ep8so289146pjb.3
        for <stable@vger.kernel.org>; Tue, 11 Aug 2020 18:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5pGGqgWLpzFG4RxolVndZs6mTYhJjUUNCTJYCLemPt4=;
        b=c7MK4nN+Fdz1kYz0joA2UUvnJI3u8DAy1wLfaDc+Js7X0Rw5g0kLXOTljQhdzNIReW
         ciJqyQV7UAABK6f40gZ5gclgwCzScm6G56cx/7L2xNPQR+b9TN8TCUgENdbdxEuPum0A
         PnvfPEIduS253R2P8cwJ3xFgGHwwpM4Fhwl8Qch37KW5pArzvyJGbMvdaraQXHuvkbUI
         AGILHY6bMkciC1UHJD5rD59UDlvJyMreoHwZgJD+YUjYUrWOxw8sHS7EljnbErrT+PDa
         A8BkfTeh+VQH9naBvBX12LXXeeap6MJESy1UN8c9un6jKTDjXFcenfi9jeRN9tTnII5r
         0R2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5pGGqgWLpzFG4RxolVndZs6mTYhJjUUNCTJYCLemPt4=;
        b=PZiTypN052uqsWXVeDjf77R3LA9eF1bed+PLcIK/Y60e33dFFaBbEsvANV/BMcIxO2
         evDPyagDCiNfK3xKb8T0cZldqBlxEmWMxslcHyQ4ev3Ogmu4JfzMW0ptH0kEbu7Y69Fz
         /GxG6fK+GKPoYu9vnDBDduRqHdYAr2zJhuKb9ro7nMVcROJ5wv7NWkY26w+VGZ0aTcwd
         q3nocuv5KKAn+jOFkNNKBiOo9MVT+UAxSRU/HPbbpX1qN6y5RV/AU45X06uVtMD493oh
         L17QlbMQax0l0Zay2+d2d8SbyxyWG2XNjOiRe5tM4h1VVjdnQ/vU5BpZLX+HyepHus70
         d5Gw==
X-Gm-Message-State: AOAM530/9mca4K+if13XyWT0iCw/T6ngWbkzrFQcuFVP9VPo7MB4o1++
        j/Eaar7R6L5qRhbFt88nSCNogCkkRes=
X-Google-Smtp-Source: ABdhPJyyjmfhSSeGVELY+olUmFD36tvI8A3KMN5y+x4JTLe5+l7JXp+A7xwFiy126R8LbZlc2/gheA==
X-Received: by 2002:a17:90a:c394:: with SMTP id h20mr3945494pjt.22.1597194277282;
        Tue, 11 Aug 2020 18:04:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r134sm316509pfc.1.2020.08.11.18.04.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Aug 2020 18:04:36 -0700 (PDT)
Message-ID: <5f334024.1c69fb81.200fe.1649@mx.google.com>
Date:   Tue, 11 Aug 2020 18:04:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.139
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 174 runs, 6 regressions (v4.19.139)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 174 runs, 6 regressions (v4.19.139)

Regressions Summary
-------------------

platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =

bcm2837-rpi-3-b       | arm64  | lab-baylibre | gcc-8    | defconfig       =
 | 4/5    =

hsdk                  | arc    | lab-baylibre | gcc-8    | hsdk_defconfig  =
 | 0/1    =

qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 0/1    =

qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =

qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.139/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.139
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c14d30dc9987047b439b03d6e6db7d54d9f7f180 =



Test Regressions
---------------- =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
at91-sama5d4_xplained | arm    | lab-baylibre | gcc-8    | sama5_defconfig =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f330bbf7e01f7b1cb52c1cb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f330bbf7e01f7b1cb52c=
1cc
      failing since 56 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
bcm2837-rpi-3-b       | arm64  | lab-baylibre | gcc-8    | defconfig       =
 | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f3305ee2b5170941952c1d3

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f3305ee2b517094=
1952c1d6
      new failure (last pass: v4.19.138-49-gb0e1bc72f7dd)
      1 lines =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
hsdk                  | arc    | lab-baylibre | gcc-8    | hsdk_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f330d6ab65e3a687552c1aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f330d6ab65e3a687552c=
1ab
      failing since 22 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_i386             | i386   | lab-baylibre | gcc-8    | i386_defconfig  =
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f330be3f0782ea70c52c1ca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f330be3f0782ea70c52c=
1cb
      new failure (last pass: v4.19.138-49-gb0e1bc72f7dd) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_x86_64           | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f330b8dbb24a7f97b52c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f330b8dbb24a7f97b52c=
1a7
      new failure (last pass: v4.19.138-49-gb0e1bc72f7dd) =



platform              | arch   | lab          | compiler | defconfig       =
 | results
----------------------+--------+--------------+----------+-----------------=
-+--------
qemu_x86_64-uefi      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig=
 | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f330b90bb24a7f97b52c1ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
39/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f330b90bb24a7f97b52c=
1ac
      new failure (last pass: v4.19.138-49-gb0e1bc72f7dd) =20
