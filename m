Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFDC64A35CC
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 11:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236940AbiA3Ks1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 05:48:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiA3KsZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 05:48:25 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 260EFC061714
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 02:48:25 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id r59so10892462pjg.4
        for <stable@vger.kernel.org>; Sun, 30 Jan 2022 02:48:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6ObEMmxxZYuwaVxeANII11w1/VtYm6rWoqziSMVJuFM=;
        b=AsW70jba9NwF4pmLZ4LYr8zAr6ehPBEzKeI55XTB5q6ADuTrrlwG5CZ0gpHd5Hxl+3
         x5C6ibkXRWcdeAOPlmDYN+cOg+NFpzTb9STztVeBcx2S5yO76C6BNq3GALi2mYSErcMy
         tcs5oHoIbqLbXqCaCVsHaG4pgPh3O2SI22R7jq8WlG7MfcwJJfSMdeNTOq8gZIAV5J1o
         UGqCVH0LqN8QleiJq5ECWNi7Lpv7UzrKVQgl8mmjOhmQWPmJKSCGP1ozmR3NFBTUgzG6
         wOXGVQAufH+LOaaUxAOxh9bibNYD5kkfc3mheCfEnJgLVA51UwW4x/NKKLwLMKAQIOjR
         BSBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6ObEMmxxZYuwaVxeANII11w1/VtYm6rWoqziSMVJuFM=;
        b=urHqGWnkyZ6M50CGmPNOgPmvsX0O395faGa6B4kWaWYBmeqNRS+12FP6P+nVyLQEav
         rSaEIQqNpsD7w1jFQDa6rJl4ZN+FIotjkr+GEvxTRXjnZLNpL9cccMNHdbg/bTpP/rBW
         cjhkDBMgHDoov13w9JwifdOo2/1S1kDwl42+6eQPGupTcyjxLhPX/2CLpkTSQf15jvwD
         zkJyjLtz7vVJ4opb0Znael+PZMCILdzowsM10V63lMKkPeKCBxyQ/N1qmIplSsKHqgPA
         k/omEWGQqvsqZ8vjUf25mnZwdJ0EuxyC2IXJdj2jx7br0xVxzjnvNPL+S0duetBrz5HV
         OU0A==
X-Gm-Message-State: AOAM530Yeb8IA2O4pi8vuUvTTzwMIlLOPPN5SrJ+IbStGSUCtQlYgYyJ
        +zD3PlU0P+yGi+7II0J0THsVR7DygJsoNolM
X-Google-Smtp-Source: ABdhPJyg+OELsQfCVzaBNxlIU2c0QXI5TkkGRt94qKzpls5Cq7Ybi6mKwXPkT92mznwgz29M8dwjxw==
X-Received: by 2002:a17:90b:1883:: with SMTP id mn3mr28787184pjb.153.1643539704515;
        Sun, 30 Jan 2022 02:48:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19sm14045686pfv.62.2022.01.30.02.48.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Jan 2022 02:48:24 -0800 (PST)
Message-ID: <61f66cf8.1c69fb81.636c6.5042@mx.google.com>
Date:   Sun, 30 Jan 2022 02:48:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.175-60-g4deb674204891
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 122 runs,
 4 regressions (v5.4.175-60-g4deb674204891)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 122 runs, 4 regressions (v5.4.175-60-g4deb674=
204891)

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
el/v5.4.175-60-g4deb674204891/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.175-60-g4deb674204891
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4deb674204891125d8c0793fba609aa98747f953 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f632bc99c93e1c41abbd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f632bc99c93e1c41abb=
d2d
        failing since 45 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f632e3be7222ed80abbd2c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f632e3be7222ed80abb=
d2d
        failing since 45 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f632bdd6ad431db6abbd12

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f632bdd6ad431db6abb=
d13
        failing since 45 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f632e67db0d8cf85abbd41

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.175-6=
0-g4deb674204891/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f632e67db0d8cf85abb=
d42
        failing since 45 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
