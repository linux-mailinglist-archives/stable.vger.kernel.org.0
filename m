Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24C8649BE1D
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 23:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233460AbiAYWAq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 17:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233449AbiAYWAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 17:00:46 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 323FEC06173B
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:00:46 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so4211393pja.2
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 14:00:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GHCZA7OTo2UhnjUc+B7joTi5kIxSbgQmfeOoFb9ings=;
        b=qZdH7ja78bVrPMah/0qh9oBPRuattOofhsLs04KHmiXyNvmWDM9ZDsWgPkSfG2HFLC
         RVBROlZZtl5MR6tDR2dbGbAnopbtawkIfPycDdWf4ANR9f50Qk5+/VopPnJ4o3V3XS3H
         sxVZYtw9gtF2O/R0p2yPollpnqX6szjQARfHm2zz8lqtnQ/Vxrr6oUWTib1Apbd8JBh4
         ngyqXwxUV87NqY6vYPvNNvPaZVkN2xNcmBJTlJoWFzkQkUljKMemV2m3G/UZsgc1XZKw
         TGTh64t0giglsGznY1U79EXUSFvjWtPejTf4p7jaf1vQgLt/RUsp4YSNno/fKhyTHu2b
         70Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GHCZA7OTo2UhnjUc+B7joTi5kIxSbgQmfeOoFb9ings=;
        b=qYp+IG3l3pVyjUFTs0ILqlil4rc/4X+1+LYpoRKp2ltQ+YiCHpt1GNWRLvMwDrkSls
         yyFp6JMdJAdMyHDwEF1q/JuMEaWNZmwJQX27j5QhwkXHnd84GITezK1+jKM26bRYa8lK
         CihpwfPCxSM//oP7N3L2mEt8cWlH5Ss5hYbYuw3+4wdv5rfER46RbGdltvkoyUbDqCcz
         7KcStb632j0xFcc1rQP6dxXMDUHthhuBiiifdR4zDimtzwvQzOLBZUlpaZri8tjRQctl
         J1uqbXDH7wpkti0kOlzzrcJ8lZg76MiB3RWx9EOJsEuvzVMhtxDUWhplGwxamYYCC06V
         Ymgw==
X-Gm-Message-State: AOAM531BhbIMp29w0iBTgjVPeDVLLCuTqD0GfR13mV87Mf7rzv7BnzF3
        bZnltNuq/Xjzj64FuOEK8BqBAeKl6Xju1WyG
X-Google-Smtp-Source: ABdhPJyDhboCAxTJIx7rGzjrYlryBj5qCfIYlyIlLQXvgkxx9NePsPr5nW2PBV4EwbBU9VoHVy+VQA==
X-Received: by 2002:a17:90a:5d07:: with SMTP id s7mr5609122pji.226.1643148045503;
        Tue, 25 Jan 2022 14:00:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5sm1417695pjf.34.2022.01.25.14.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 14:00:45 -0800 (PST)
Message-ID: <61f0730d.1c69fb81.2588d.464b@mx.google.com>
Date:   Tue, 25 Jan 2022 14:00:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-316-ga98244ea2a01
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 134 runs,
 4 regressions (v5.4.173-316-ga98244ea2a01)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 134 runs, 4 regressions (v5.4.173-316-ga98244=
ea2a01)

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
el/v5.4.173-316-ga98244ea2a01/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-316-ga98244ea2a01
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a98244ea2a011a9dbd52e1f3a2936bf0361b6fbe =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f03d6881cc5c4b58abbd2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f03d6881cc5c4b58abb=
d2b
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f03b36dff1d4e191abbd26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f03b36dff1d4e191abb=
d27
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f03d3f2856a41f03abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f03d3f2856a41f03abb=
d12
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f03b34dff1d4e191abbd20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-3=
16-ga98244ea2a01/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f03b34dff1d4e191abb=
d21
        failing since 40 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
