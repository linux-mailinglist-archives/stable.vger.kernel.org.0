Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871D14767C7
	for <lists+stable@lfdr.de>; Thu, 16 Dec 2021 03:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbhLPCQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 21:16:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbhLPCQJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 21:16:09 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33D64C061574
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 18:16:09 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id m24so18163641pls.10
        for <stable@vger.kernel.org>; Wed, 15 Dec 2021 18:16:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=R0ZJWkA8AFl1/WNvIvekXLiHrsrAw1p6bTdj/3P3tSg=;
        b=LajvMCnAfMKYe2tiOZCWZl5EZs0uNYiKflpU5QonWQ8k2e3e1QJOO2sFOZIv+cmX9o
         Ywr/0P7DoPEMWhuKBBzgMTrxuNZNmcMoGbSeRK1NHp/Hf4nQk1gGwE1pROqRqC6SI9pj
         VK0gKWdAZ2XdnVviQterE8WoLzmcpoZfydumb1LcdwXVgooQVuAkHPaxmHYgKKYoL/kj
         OeqX7QsMcFDdi8V4qasMnMzXLrj1chsDkBJ+VscFSQJNzyUnwVveaE8pCbjSohiigNlx
         oiIpKDE8/XyEyjXVVD84zPOvXhhvTSsWBwVP35DHxCN5L5tD7fcHXvzGPRwFnMLGRGzn
         +Ssg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=R0ZJWkA8AFl1/WNvIvekXLiHrsrAw1p6bTdj/3P3tSg=;
        b=LNVmRViP7BZwtLVD5GcGK6qwwhXQkK63vK6ioKhPIB0Z/UPUHJB5MMjE0WMtyKQ7RP
         L+qBMQM40Z2W4WDTqzb/isa9VqTJfT75RCMVVe6gerK3Uciu8T0qeQnMUc6oJT5ORhyU
         hSAU9Q2182cDNv1mSb3Sa0y5w6v7ecNiRqDEDb5I9G6RRlR9KecCu/0JzRZw8Pmx81m8
         KSlHSW4EJ1c19wQwd1lmvahd95SqC0bGqsOP32hjTkrCzmK/avyI741U7cOLQ7pYoJ82
         jGAlkR7YpNCoQdLx2B2zttuayx8OupnSIIkbYRu5bvOhBuQquYE/xcR0P/C+AhFNEVZ1
         zTdw==
X-Gm-Message-State: AOAM532vwtHIydd3wmEs103RoIvMEiOIVuF3wgC3SWz6mnRl3aAxFvn3
        hT4vI2HksTNcm6IV7qo06B907diiLuoPn2RF
X-Google-Smtp-Source: ABdhPJzmy0ezZu69V7aiV0YfwOVQNUaB8Nrz3wOR+kLaMTY9uxbzlyPCfmoVpPNw/UVEYAeJqpdcAA==
X-Received: by 2002:a17:903:30cd:b0:141:c6dd:4d03 with SMTP id s13-20020a17090330cd00b00141c6dd4d03mr14668223plc.16.1639620968505;
        Wed, 15 Dec 2021 18:16:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b16sm3450963pgi.36.2021.12.15.18.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Dec 2021 18:16:08 -0800 (PST)
Message-ID: <61baa168.1c69fb81.ff1f0.a672@mx.google.com>
Date:   Wed, 15 Dec 2021 18:16:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.165-18-ge938927511cb
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 5 regressions (v5.4.165-18-ge938927511cb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 5 regressions (v5.4.165-18-ge938927=
511cb)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.165-18-ge938927511cb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.165-18-ge938927511cb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e938927511cbb0cedd19cca64d2550e48bb5ed2d =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba67a01390fd84b8397120

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba67a01390fd84b8397=
121
        new failure (last pass: v5.4.165-9-g27d736c7bdee) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba69d8aadc1ba2d439711e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba69d8aadc1ba2d4397=
11f
        new failure (last pass: v5.4.165-9-g27d736c7bdee) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba71c09f7a7be8f339713a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba71c09f7a7be8f3397=
13b
        new failure (last pass: v5.4.165-9-g27d736c7bdee) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba69c5592454ae06397127

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba69c5592454ae06397=
128
        new failure (last pass: v5.4.165-9-g27d736c7bdee) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config           | 1          =


  Details:     https://kernelci.org/test/plan/id/61ba71c3dc0df63795397126

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.165-1=
8-ge938927511cb/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ba71c3dc0df63795397=
127
        new failure (last pass: v5.4.165-9-g27d736c7bdee) =

 =20
