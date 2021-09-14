Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22D5B40BC68
	for <lists+stable@lfdr.de>; Wed, 15 Sep 2021 01:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235972AbhINX7i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 19:59:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233774AbhINX7i (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 19:59:38 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0FFC061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 16:58:20 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id t1so885714pgv.3
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 16:58:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZOF566QSCuK0eTCu3m9ogN5Y2O1V1CmpDNOx9GjTolY=;
        b=L+ksqwkV7IzQOnoz8RWekIb6VuNNPeZSgKVjww+HWaJuGndoo7WmLrhwDgOGflvp4E
         f5IbzccxPm/Uf/ZueGrbJTIrWUKLQnnj1+fgjkFq/qbvXjKgaxYB9SkODa/ZORy8+LjL
         TKeOocKKSR/V1QleYyCkyxpHAbxl20Esyj1SkG2S47wo64BkJliXIhqflmvBJduv1yTV
         MOFaQGKv4w7x7hHr20LwuNmM5SV5ot9PKd+1UQbhcv9fus+k7s1oepqrnmXj1NC1rOu6
         1SxRBiqNbOuq5evasnJCphH6PQSvlnYLAPxpPOJGP6K2CrD2YZ6pvMwXsfEEn4IFHQZZ
         zNgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZOF566QSCuK0eTCu3m9ogN5Y2O1V1CmpDNOx9GjTolY=;
        b=LClalOvr0k6QJ/x3wwrtUlH7Mlyqo/iyDlG8Pu+UzoUcV1IEppijoXh3ccdMM2VNCy
         MlP+y10hh+bpArlg74BTos5j08fKsh2LerBfR8ADLnOeFbIhXcZ6DrpQZnpPLmklfjgq
         5IMgrvLpdof7Pdx/V3iVXp5QPIuWwgftDkN9wJEFUrouRSadJ2iXEbsspLFQOwEVLKWY
         ompze8jhHJkqAzCSB6Mxr0jwYMnmaZa0T/Vhbb+/lPadS7dk5NDGW8G5cVaRy35esWRK
         MPJirkhP++Dg3AycWJ4G/QHk923z0m5jZ19VZKlV5bExU2OUz3xYhUWax2MUzJEWwizz
         iIdA==
X-Gm-Message-State: AOAM530tecFHMaSL/xOl2zpdY1lgIh91gvP/D+uIlQhQo75jo3G4btML
        kVouBTs2UcOhKkkGkzTwCLR2Vc2MuFo7znQS
X-Google-Smtp-Source: ABdhPJwCCVxJvda5jEtZiI2ksAbbEMkveXl5YakEZACuLPCfcyLQyk59RPl5FBVDfs5U5w8LRvH0pw==
X-Received: by 2002:aa7:8887:0:b0:43c:83fe:2c56 with SMTP id z7-20020aa78887000000b0043c83fe2c56mr7377301pfe.82.1631663899791;
        Tue, 14 Sep 2021 16:58:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v25sm11141779pfm.202.2021.09.14.16.58.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 16:58:19 -0700 (PDT)
Message-ID: <6141371b.1c69fb81.2a68b.19b7@mx.google.com>
Date:   Tue, 14 Sep 2021 16:58:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-89-gd86d18435524
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 109 runs,
 4 regressions (v4.9.282-89-gd86d18435524)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 109 runs, 4 regressions (v4.9.282-89-gd86d184=
35524)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-89-gd86d18435524/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-89-gd86d18435524
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d86d18435524994bdbc7e071ba6ffd00b210ece1 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6140fcd7761a347b2899a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6140fcd7761a347b2899a=
2ef
        failing since 304 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614107217e31debaa299a30a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614107217e31debaa299a=
30b
        failing since 304 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6140fce7761a347b2899a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6140fce7761a347b2899a=
2f4
        failing since 304 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6140fc8563b24b4e9a99a2f9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-8=
9-gd86d18435524/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6140fc8563b24b4e9a99a=
2fa
        failing since 304 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
