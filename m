Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 144EB494F95
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 14:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240716AbiATNxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 08:53:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230115AbiATNx3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 08:53:29 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95017C061574
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 05:53:28 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id 192so2174138pfz.3
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 05:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9fFZgkWENo6Vi8DFnjddjHzMcXzCSQRFuyuIe9t/+cU=;
        b=7Rb337TTbzmLbBTCUNzQeUwLOMBLZTS8LRkBFsVhKO9RxZp5EqM4WcQEnOAX03cLm4
         ckyp+MdLObhDhxpOgggaG+6sPyu0D7Rb/tbQDtoqt9xta/huzS5mnXztl4jziB16co9K
         oHi/SPj5WIqFEfAn8P4+MObej1Fw5DgL7eI4W+odc7csd2IA3B3GmCfXu2KA10XwfUxj
         jCVKIB1pdxhlOh0nkDdxntbv7klqFYV8lnjbuT19mdR8Hz2paRAF2Hubh1RvdH5iUpKa
         MWvKcHEA0C+mOY/08wzeeWggHiERDfiqfkw/i1siDc99PIDIh+xz4zol7Vp7q2yrRm+7
         i1YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9fFZgkWENo6Vi8DFnjddjHzMcXzCSQRFuyuIe9t/+cU=;
        b=k3JmcQrGwFmb3H3Sd8JzSQs6cD/t1sJWw3g8rcDum+U407bbCLqST4iGAoICku6/In
         uV+Xc0Wt3bPBBKpP25r0svYCYsSK1Tz+OFJg5WXLDU6AKL3ZM3hHNhAXJkK9nzg+fr/9
         qOPVR4QhskEeTHxKhLz+S9NRYFIIIuLNksN7KrAvoNEkMrF3kNvMM5wclCXZ1OyJr8/T
         W3ZkKenvRscfqVGFTf3X9uG0LO6vmwlkhP8+pBYYpODuSVwvuR5IUlNFbp/lnG2qvlTG
         wHQ7ge1T29VLblhKvTvxuNe67uhEAPyj+o0OVuIqxaHaMJvuTzTAJL0k0pT3Qq1Pj3kX
         Dt+w==
X-Gm-Message-State: AOAM531gcYdrT2RU5W3Ctt1q52K354NBFlEuZp5wwhLlNZVLhf4RN0qZ
        XvwMlrcqh0IW9nUOEgBFmYRSR1bi+uLz6Y5M
X-Google-Smtp-Source: ABdhPJwxR3FK+dhhj8k9tgyfoPXrl3oR2cWdMjzy5gvx7XCzEihAWYK2p6ZPp7IMuIJIEeSCeugbjA==
X-Received: by 2002:a63:5b63:: with SMTP id l35mr12050529pgm.406.1642686807898;
        Thu, 20 Jan 2022 05:53:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p12sm8734023pjj.55.2022.01.20.05.53.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 05:53:27 -0800 (PST)
Message-ID: <61e96957.1c69fb81.12818.769f@mx.google.com>
Date:   Thu, 20 Jan 2022 05:53:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.172-15-g62a953fabccd
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 164 runs,
 4 regressions (v5.4.172-15-g62a953fabccd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 164 runs, 4 regressions (v5.4.172-15-g62a953f=
abccd)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.172-15-g62a953fabccd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.172-15-g62a953fabccd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62a953fabccddeaec66875ef1a45a552f06c5f55 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9377d4986a0d9e5abbd15

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9377d4986a0d9e5abb=
d16
        failing since 35 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e9379de37e07b0baabbd1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e9379de37e07b0baabb=
d20
        failing since 35 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e937904986a0d9e5abbd3c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e937904986a0d9e5abb=
d3d
        failing since 35 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e937b1ea3bb07c46abbd4e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.172-1=
5-g62a953fabccd/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e937b1ea3bb07c46abb=
d4f
        failing since 35 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
