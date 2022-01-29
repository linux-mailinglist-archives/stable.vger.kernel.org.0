Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222B64A3027
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 16:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235499AbiA2O76 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 09:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231262AbiA2O74 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 09:59:56 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87198C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:59:56 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so6298272pjq.3
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:59:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FwUxstmspX0wM3Ht1J8rf9oxjJ4srQ5ClYSx1YKOqvA=;
        b=XNWmkkZDWfzQQKgIlo6+kzLQU1kz6pTIzG+OzXcF2x6XzSzurPM2SqOd6YXw7HoEG7
         6yfNsUfhfsZBoh5iw6s8UCop7MDZM3SYd/iCN+fvd2v+J7ju5PZ9gHz1sNoa44bIWyih
         7OuXbSNKpKAfkTRCyPbTvVFDrDlR9gNfRBkXn79nHEyjU0gH7ZRFGSZU7U2lOfIdTNMx
         ZIjfMFSqpvVDzW+pT5fqzoo906L6T0fsRI9Y/F04of5kwBUDyW+nPv/PnLVM85Qm13aN
         3jmNu10BKL3d3nPgGgLnyOYoT+/MbCw6IGI+F2Q/hslI7JN8q1wqFgimeN+jx/KehN6q
         EpGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FwUxstmspX0wM3Ht1J8rf9oxjJ4srQ5ClYSx1YKOqvA=;
        b=kcaFQpJQGenzYB702gaFDqEy07vgUmpK5hifwiF6oyxY0iRKKY7+gl0Tpttbkmr69A
         8HYsB9Q5xJ3WsBuXSGg+ilO0tBaiMQlLqZX57ZmreNRL1Hb1D4foq8ifxJj+MhTi5UvU
         fiNODcXJpYrQWG7eF9OUoHRaZ28HE6GrVPCrQ5ZZ3H3XwgD0teGqVzAyMNy+UXAiOTQ4
         0k2kWVw0TdNhxJxa5bFIcMxzcbbCDBsUpgIQLORuj515WwqxchduaZ46Uj1R64ds685n
         nu/MApA+CghBzL7ikGgfaB9rDQbcgfB0P5E0VYEjfvU6AldsBgnl/7NntUtoHCMiT5Y7
         0fpw==
X-Gm-Message-State: AOAM5318LM+xevyL0AFljDyrld4up8t64GtpTk1vEM08DuoMwieo8Sap
        p3+kCnSHufGC2gxu9aL6HA9eXBxg7I08+Hkp
X-Google-Smtp-Source: ABdhPJzKcKRLE5tml1VCtG2ruiNybYBAkRBWrd0akPFKTTQvUXrW3+yw1LtDH9kj9KUbVeKBzyMM3g==
X-Received: by 2002:a17:902:8490:: with SMTP id c16mr13387905plo.129.1643468395891;
        Sat, 29 Jan 2022 06:59:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm13949423pfk.110.2022.01.29.06.59.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 06:59:55 -0800 (PST)
Message-ID: <61f5566b.1c69fb81.ab983.4b7f@mx.google.com>
Date:   Sat, 29 Jan 2022 06:59:55 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.174-12-gc12cbebe2e95d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 138 runs,
 4 regressions (v5.4.174-12-gc12cbebe2e95d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 138 runs, 4 regressions (v5.4.174-12-gc12cbeb=
e2e95d)

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
el/v5.4.174-12-gc12cbebe2e95d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.174-12-gc12cbebe2e95d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c12cbebe2e95d366fc888194c5903d18e6ba9eec =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f522344a2b4e7d39abbd14

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f522344a2b4e7d39abb=
d15
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f5224d8d5103c41dabbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f5224d8d5103c41dabb=
d12
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f522334a2b4e7d39abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f522334a2b4e7d39abb=
d12
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f5224c4a2b4e7d39abbd47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.174-1=
2-gc12cbebe2e95d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f5224c4a2b4e7d39abb=
d48
        failing since 44 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
