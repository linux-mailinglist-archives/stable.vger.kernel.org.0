Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B5923DE2C
	for <lists+stable@lfdr.de>; Thu,  6 Aug 2020 19:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgHFRXA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Aug 2020 13:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbgHFRFS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Aug 2020 13:05:18 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5425BC03461A
        for <stable@vger.kernel.org>; Thu,  6 Aug 2020 06:21:52 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id p3so26699494pgh.3
        for <stable@vger.kernel.org>; Thu, 06 Aug 2020 06:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OMJEGc9VFR6XX6XuE5i75QGTzVgxqvt25JpT31W6gRc=;
        b=kXOwvl5C/K1I8TRSWWfcPU/DMJMneqoUCSAiyu/lAoitja0JbYyi7ekVmdB4GnSpkk
         8vrMUziLO/HcpkZkO9QmO8jy/J3VnuDE9xCn4pEqyNTzUUEgOshl90OLoJLra/AUDFbR
         tttNkmGQHoJWJ5lXTCa0JMB64o8iJaYMN1reDVcnuRGfJgxglJ/uBS9NX9qg055lhKXp
         TeYJnSty3128SH14SLl+H/YmJluGaWnzdZH8tt6807wD8NPDiugxsoRBiXpYJxMEv1bL
         lML9er0qZpPNIpKwdXsXSjBMnMOYg8ci3zgSRsk0QnVuyyA4FN/kgGjsxmatP5AHmiFl
         jIKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OMJEGc9VFR6XX6XuE5i75QGTzVgxqvt25JpT31W6gRc=;
        b=thgzltUP263iBcW4+qTr8Npn7p3hJmwblQGkSpgEmo/rKEAdXUiNU8qH3DA4aOwcL4
         krf3QYI56v9uBbz+POahuaKTC1/98hwQryi2Q9SO+fr60Fxw9A99kADWYEOlfwKED0Br
         WChFk8UYUiasZL72r/H4NMue5TzHlbp8TSV7wgJu8BnzqsPbE9N0MlvN94k7pOD7ZlsE
         uM6DP2h150WufgF4K9Z8cxQ/GlQl3Hay+NfpOhnA+whCxScx68Q2kYKZ/f3/uo5tLAk4
         yBQKmTS1k5SdB80jgA5PxM2RdRn2I6VTNC4xxvRQprJNDVn679Ax9Jl4eYl0AiQKLALs
         BCoQ==
X-Gm-Message-State: AOAM533Fi04Ai36ieDoE/Sl2ifp0Sr+PqC3LtXB1W4SDpttWurgW0gp+
        v26B2lo5KnMbDbshw2syilRgu3ZzICY=
X-Google-Smtp-Source: ABdhPJy6728Lbpfhd4ID+zBXW1IKZa3H8z3kC/fN1aHrvXEb9XOlOsBmB8h22wRWRphQePEIy+F7yw==
X-Received: by 2002:a63:69c6:: with SMTP id e189mr7203561pgc.170.1596720107764;
        Thu, 06 Aug 2020 06:21:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c15sm7996506pfo.115.2020.08.06.06.21.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 06:21:46 -0700 (PDT)
Message-ID: <5f2c03ea.1c69fb81.5af5.38c6@mx.google.com>
Date:   Thu, 06 Aug 2020 06:21:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.232-32-g22cd589cd66a
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 107 runs,
 6 regressions (v4.4.232-32-g22cd589cd66a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 107 runs, 6 regressions (v4.4.232-32-g22cd5=
89cd66a)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig           |=
 results
-----------------+--------+--------------+----------+---------------------+=
--------
omap3-beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2/5    =

qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 0/1    =

qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 0/1    =

qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 0/1    =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.232-32-g22cd589cd66a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.232-32-g22cd589cd66a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      22cd589cd66a3d9cc765d57003fe1deaff256b1f =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig           |=
 results
-----------------+--------+--------------+----------+---------------------+=
--------
omap3-beagle-xm  | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 2/5    =


  Details:     https://kernelci.org/test/plan/id/5f2bd3054e39d34dc652c1be

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-omap3=
-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f2bd3054e39d34d=
c652c1c1
      new failure (last pass: v4.4.232-30-g52247eb98ebe)
      1 lines* baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f2b=
d3054e39d34dc652c1c3
      new failure (last pass: v4.4.232-30-g52247eb98ebe)
      28 lines =



platform         | arch   | lab          | compiler | defconfig           |=
 results
-----------------+--------+--------------+----------+---------------------+=
--------
qemu_i386        | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2bf8238a986b218552c1b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2bf8238a986b218552c=
1b4
      failing since 2 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig           |=
 results
-----------------+--------+--------------+----------+---------------------+=
--------
qemu_i386-uefi   | i386   | lab-baylibre | gcc-8    | i386_defconfig      |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2bf8108a986b218552c1b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386=
-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2bf8108a986b218552c=
1b1
      failing since 2 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig           |=
 results
-----------------+--------+--------------+----------+---------------------+=
--------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2bf77cf44ce540c552c1a9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2bf77cf44ce540c552c=
1aa
      failing since 2 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =



platform         | arch   | lab          | compiler | defconfig           |=
 results
-----------------+--------+--------------+----------+---------------------+=
--------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig    |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f2bf6ebca697b064252c1a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.232=
-32-g22cd589cd66a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f2bf6ebca697b064252c=
1a7
      failing since 2 days (last pass: v4.4.232, first fail: v4.4.232-33-g1=
91818eb5a46) =20
