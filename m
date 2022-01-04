Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3875648397D
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 01:37:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbiADAhS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 19:37:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiADAhR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 19:37:17 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B87B1C061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 16:37:17 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id z9-20020a17090a7b8900b001b13558eadaso39106361pjc.4
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 16:37:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uLP55Bf/ZBUcJrFkvSymfx9WPk9ld0FwUVsTVbCWzME=;
        b=vQiX1EUGF/sJxbbxdzQ0+6FVEiZN08QqrZlAqoEiDYnyjrPihmC324W6o8a0TdpaAq
         24/V1ysThUm50DUjpRwTnCljIowA1Q+YmXsK80hDCN2URmZp6iXh5uoQ4ygvnkwTzmhL
         x7H96RwZVVLGSDem3ourD5UU0ObHaVSLObMffpPCy0HTwS6BWiVcLc0Ak83LeH41yT2W
         ftKepVjipY3GmDIiumThUZtPhHCL2/lCZ+nrxiCD5flDYGdY5rMQMWkbSpGy9w+J5K8p
         1SWQuySo1aiN5H3DkHxAAssPEJSgqysSv9R8w4Yh1g3FjAVkPNqAbP8h5hT6v8uAuHEs
         uNjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uLP55Bf/ZBUcJrFkvSymfx9WPk9ld0FwUVsTVbCWzME=;
        b=1qWf6ojZousFQQIiQItgEsnrQl9hJeqaJ6OX2yWaU+RK+nn5HzplEjuw+jOa/BjjKG
         FHkScTrFKpa+tWTGlrzFWKg9nh0ltnMfv1lL7L8xnCFzlz+driGut9elpsDhr1F8JoGq
         5XEFhrC5ORDmoQu40bpQn1LCWPnXDcEt0Hpgfa/qG6zeiysN/5PLOWMdL5FBpxeuImB9
         qrM7nzyYX5DvptYjCEinFjEpEIH5A6v9kTq4JmROHDD6MvGBvDOmKo6tR57XMrfVdOs7
         AAwTAjQfJwK78oNaIObfiYBb3UGWrWfehaXZM0kwYoMmHk6lTM2iQGephWW8qdrb5FIr
         gTJw==
X-Gm-Message-State: AOAM531OPZoU6c1lWkqJzE3Wxvqbxqmj7DVynhBO0+ehDO6yGxg4mT5h
        CBUIB8Qhcr8iv1Z/zdjNC261YG/Izj2qq11k
X-Google-Smtp-Source: ABdhPJzhrjww1Flg1rNb+OuCta3cC9gxP0qT8iFWAXF/Seg0nPx05jHJx4Mu5hr5TeLPzIsP8JseBA==
X-Received: by 2002:a17:902:d50e:b0:148:b614:54a1 with SMTP id b14-20020a170902d50e00b00148b61454a1mr47048192plg.163.1641256637102;
        Mon, 03 Jan 2022 16:37:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l6sm34005459pjt.54.2022.01.03.16.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 16:37:16 -0800 (PST)
Message-ID: <61d396bc.1c69fb81.800bf.c5e2@mx.google.com>
Date:   Mon, 03 Jan 2022 16:37:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-37-g0110bda99c63
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 152 runs,
 4 regressions (v5.4.169-37-g0110bda99c63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 152 runs, 4 regressions (v5.4.169-37-g0110bda=
99c63)

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
el/v5.4.169-37-g0110bda99c63/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.169-37-g0110bda99c63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0110bda99c636d63ea1b149ac617d387607c82b4 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d3645be16e15f9e7ef6782

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d3645be16e15f9e7ef6=
783
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d36460e16e15f9e7ef678f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d36460e16e15f9e7ef6=
790
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d3645ae16e15f9e7ef677f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d3645ae16e15f9e7ef6=
780
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d3645fe16e15f9e7ef678c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-3=
7-g0110bda99c63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d3645fe16e15f9e7ef6=
78d
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
