Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE104975C0
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 22:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240232AbiAWVjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 16:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240187AbiAWVjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 16:39:35 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ECDC06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 13:39:35 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id d15-20020a17090a110f00b001b4e7d27474so14583750pja.2
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 13:39:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DhPyZH5yVE5yG4DT12vSyYZfXjVbCiZwyA6lf21W30c=;
        b=skHEynXu2PDW8sj5HrABz7NAb01/GMPtbJ4oKAVu2zkrN7tpXkTJOFNcIXUCFcosh0
         dewuMJBANlvVmVYgwt+gFPSb00NWCFm8T30Pi9a+FlJrF0B9ik0ZgcGA0ket7hJqqkjT
         wjHaZbKy00GIwVDrudkAeYA70qVm09BgdQWvXXS9OndIB064OQjjXN09XKhU+1s5B4pJ
         /40kBsIi1slLXuBkVNmTJ5cF+C9KG9OyUVV+GP7LjdEI2LpRybCuFuLictDsjnwNoTcf
         7Zs3r97CH9BJP3j39Qwt4HBNwjYS5GE0saw9l7CuSJn184RKn6q1rj0YnS1QFHzIiZj/
         XAEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DhPyZH5yVE5yG4DT12vSyYZfXjVbCiZwyA6lf21W30c=;
        b=dVFvmHShP0W9rxZPZRFL3/NwnoPpc8x+FNhNKpjKWDbyqhUr4z7rfx3K/uL91z21Md
         8EHC4+kABRThHQdHQI3rS3rJngwk8cAY/HKsk4vXD1K/vABySeSU8xDMI//Ppi9TYltn
         0nvgwAivqUJnbajYIPfns4YtlaQZq8dLaOsmKJc51bq5CHHGdBaZc/WBT81TYs0U/SQq
         lqYrH9MSIXWFQo0wEbWY6T47OUB3ogq8SDJY9w5NM+z6YnBx2NnWEHm1p9iCE27vD/fu
         JICYK7/C4VthJDMTOYgI3mJkESa1V1Uw2/i66Oo/ANNK01yhyus1SX9oi4n3N+ueYFHf
         Qj2Q==
X-Gm-Message-State: AOAM532Lkv22QJ7OzQklJKPVuql/Pc49bsJ/9xzzsf+cbT2rB+GVBza8
        t/DH8wo+jaJeiIklNE4Vl4LgEy33REHIlf2z
X-Google-Smtp-Source: ABdhPJygIAWjLc6MkFL03JALUcO2mJnR7PNCT3PNx4TWyQiAo3cWT1/p1fPdmrrHjV9ii93tMlH0Yg==
X-Received: by 2002:a17:902:d682:b0:14a:ec57:26fb with SMTP id v2-20020a170902d68200b0014aec5726fbmr12127440ply.114.1642973973424;
        Sun, 23 Jan 2022 13:39:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g8sm13208243pfc.57.2022.01.23.13.39.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 13:39:33 -0800 (PST)
Message-ID: <61edcb15.1c69fb81.4ac1b.3fce@mx.google.com>
Date:   Sun, 23 Jan 2022 13:39:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-249-gdd287e5d6211
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 186 runs,
 4 regressions (v5.4.173-249-gdd287e5d6211)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 186 runs, 4 regressions (v5.4.173-249-gdd287e=
5d6211)

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
el/v5.4.173-249-gdd287e5d6211/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.173-249-gdd287e5d6211
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      dd287e5d621151bd30318ffb45994d6340c60113 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ed92dda19a734775abbd4d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ed92dda19a734775abb=
d4e
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ed92e99531d6bbc2abbd26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ed92e99531d6bbc2abb=
d27
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ed92dea19a734775abbd51

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ed92dea19a734775abb=
d52
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ed92ed1e039fe529abbd11

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.173-2=
49-gdd287e5d6211/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ed92ed1e039fe529abb=
d12
        failing since 38 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
