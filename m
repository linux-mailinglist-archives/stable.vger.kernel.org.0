Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B854B2B31D2
	for <lists+stable@lfdr.de>; Sun, 15 Nov 2020 02:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726477AbgKOBoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 Nov 2020 20:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726391AbgKOBoP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 Nov 2020 20:44:15 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF16C0613D1
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 17:44:15 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id b3so6371322pls.11
        for <stable@vger.kernel.org>; Sat, 14 Nov 2020 17:44:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+cLqzEUbvbWgtJoVDxCAuwdVIFsXOnQNyzZGIcrzdC4=;
        b=vP70TlyB7dPBhbfWOy1dDjptqNrJNeRCm3Mu7uXLkBGDNI/ZPCSusIym9xanfEk+nT
         KGiqNNBL/cd+2V3givfM0+gdA+aLB7abet4LpFgxHAJKFAq7l+baf9Z9cP63+mGPExb0
         ICX4jO3skIsJCS6QIjhqPJlgkYunA9hiB4TtEELxMoa1umjkq9Dx0Oe78SVW4dNzGA6N
         GQu3HrIUdPB+JRsqF2DTE88nAqAKX9IHb6ra6oBj46VZOfnPlKQIO//TEScgdqvN9n0h
         1EJmoa7l4STSdnjF8Wv4ABE03HwmAhG38EHWReE3S2/jB8n9l1z71NYC8FvVUPc7hsTf
         BmSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+cLqzEUbvbWgtJoVDxCAuwdVIFsXOnQNyzZGIcrzdC4=;
        b=N72Sc/4Y54Yu03vLNg4tLj3Y3XXdK5v6GHoU/rA55IdZK+Qpa4gM7zgAoQ0MtxUKHH
         ErWkG+vQluQDhnzHn9Dz/zxdF5BwgIFo5+IYkhclVug1UayTKdK+PLa4l8zaI61p0C1k
         Kb4ke3IJ+vZvw/pg3YTZ/DBbHDSZB6Nt8ZRj2JwPCW8R39uNb1s9BI6XL+vwkeXBI87V
         YIMEhVprnfL9Yqh1q6nDRxaeO6P2FZSo6AgNnjMj0lMZMc41uD4xM8D4ACuSrRVUokSY
         hQa5EPvsBPNwsJ+fSCpT2psc6zVnEY/xpI9b1hnW4P4t0X4eQT6LBZYtc0IbvIldwzNd
         S+5w==
X-Gm-Message-State: AOAM530bL3wJViUnJR2vqXidTy/YLFsEO6cBl8tIk0pg/i/khZeqJqd/
        IcNZwmEoeCyrqzwRY33tiNAmtebDEzbLXg==
X-Google-Smtp-Source: ABdhPJwWbg27Hg6+5CmUuPhEwp3uan3s51DiJfkCI4Ul9Y1V9PIy3GXzJuDw8AzAQBcSgUKJcCdiYw==
X-Received: by 2002:a17:902:9a48:b029:d6:e0ba:f301 with SMTP id x8-20020a1709029a48b02900d6e0baf301mr7892895plv.30.1605404654551;
        Sat, 14 Nov 2020 17:44:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g7sm2226921pjl.4.2020.11.14.17.44.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2020 17:44:13 -0800 (PST)
Message-ID: <5fb087ed.1c69fb81.47dda.4b26@mx.google.com>
Date:   Sat, 14 Nov 2020 17:44:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.77-45-g5b01778bd66a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 109 runs,
 6 regressions (v5.4.77-45-g5b01778bd66a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 109 runs, 6 regressions (v5.4.77-45-g5b01778b=
d66a)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.77-45-g5b01778bd66a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.77-45-g5b01778bd66a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5b01778bd66ab25d9eaf866379d38914142b90a9 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb04dfa6592101c8679b8a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb04dfa6592101c8679b=
8a6
        failing since 1 day (last pass: v5.4.77-44-gce6b18c3a8969, first fa=
il: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb049011f75300d7a79b8a3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb049011f75300d7a79b=
8a4
        failing since 1 day (last pass: v5.4.77-44-gce6b18c3a8969, first fa=
il: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb048fabe9bbac4d479b897

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb048fabe9bbac4d479b=
898
        failing since 1 day (last pass: v5.4.77-44-gce6b18c3a8969, first fa=
il: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb049041f75300d7a79b8a8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb049041f75300d7a79b=
8a9
        failing since 1 day (last pass: v5.4.77-44-gce6b18c3a8969, first fa=
il: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-collabora   | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb048ac7f17eb8d2879b897

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb048ac7f17eb8d2879b=
898
        failing since 1 day (last pass: v5.4.77-44-gce6b18c3a8969, first fa=
il: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fb048d11f75300d7a79b897

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.77-45=
-g5b01778bd66a/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fb048d11f75300d7a79b=
898
        failing since 1 day (last pass: v5.4.77-44-gce6b18c3a8969, first fa=
il: v5.4.77-45-gfd610189f77e1) =

 =20
