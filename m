Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C886B415255
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 23:04:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237797AbhIVVGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Sep 2021 17:06:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237796AbhIVVGG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Sep 2021 17:06:06 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44222C061574
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 14:04:36 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id k17so3794493pff.8
        for <stable@vger.kernel.org>; Wed, 22 Sep 2021 14:04:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QcchiHP17vxzfOBdFBf7kdxVjvBX9BnHvrqr6HiSS4g=;
        b=mc03Re6ruRSbO0lYBiyBINtPrVMmuQM2Zni2CY+VTLRCxrd0pXC8lynirqpBuXpUPK
         VPR4KPY+9P5FRAqH5wMOYc3o+TlclQb0Gy01YjrgNz/0Q/+hcYAPK3iLWq0aC8jV3ppj
         czIVO9dXLWiPcGBJ/MuWjC9WHPrkyMhUDLyt50SaGAkCVH13xdnse1csS94HsT9zTyiD
         qMXZNqiZLogq7K6mwTob18N7c3kPqV0h4O2PXwgpefnnLtqRgdzb0skOadLtXwC3/Txm
         A6TImwqDEK4wnRUCkaQPMNSxKWsaC5Gxjh9ZgwgMy82rxUxrClUo4VGPiQGj81KPBH0t
         9HPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QcchiHP17vxzfOBdFBf7kdxVjvBX9BnHvrqr6HiSS4g=;
        b=lZApp8LOPeD8MjBUOOqzY96ql7GjG7++zheFFgKUJHuGy7JV1pXGXG7MBEnzqcIswM
         xWbJkj/a3+pTL4Z1ixrBKnVbekkuVWv49ztp7PG4K5JVyQLJ0C0Ti9CbhT/j88t7KGPJ
         5vgQh8Y5pODbHyPK+8g0+rtJ4NNd6XOBAKu0yp+aQKiBjV5CsznEkaXIbVq+WERiUIDS
         J4tNa0bqpl7YAijlcQC6qiVkmIEIUOOZvAMnXS1BsD7rPWzM1ldZdD0MfB0th7ZIlhnf
         FyGMpYSWV3g12z9xbKK3R6cn7UjYPa2ZXkBBiQVzbDEJ4+QrdTZbfbthD5uefVrg6xng
         Aexg==
X-Gm-Message-State: AOAM530Y0NT0XOk1N7JvF013SVyBKrvpyKOWK1CSqT3sx10nOYRHxr44
        ZlScxYZ82ahrXrP7Zr4lnw2mwgrj2o/JKVcD
X-Google-Smtp-Source: ABdhPJxz9Z4QLxdMZmoSSBnj7VZbAGzdVvXOE9wm/PMwBOOXVZDo7ixWQMnS63s3sxzQ+E4xobZxtw==
X-Received: by 2002:a63:fe41:: with SMTP id x1mr881443pgj.272.1632344675647;
        Wed, 22 Sep 2021 14:04:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fy11sm244067pjb.32.2021.09.22.14.04.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Sep 2021 14:04:35 -0700 (PDT)
Message-ID: <614b9a63.1c69fb81.72400.1539@mx.google.com>
Date:   Wed, 22 Sep 2021 14:04:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.206-296-gc6d39ece03f1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 116 runs,
 3 regressions (v4.19.206-296-gc6d39ece03f1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 116 runs, 3 regressions (v4.19.206-296-gc6d3=
9ece03f1)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.206-296-gc6d39ece03f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.206-296-gc6d39ece03f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c6d39ece03f12b27061e47b1edbc8c98841d45e2 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b7d9e552f3350d599a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-gc6d39ece03f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-gc6d39ece03f1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b7d9e552f3350d599a=
2db
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b6200ba59f4866599a2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-gc6d39ece03f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-gc6d39ece03f1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b6200ba59f4866599a=
2ee
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/614b61fd400bcf932e99a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-gc6d39ece03f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.206=
-296-gc6d39ece03f1/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614b61fd400bcf932e99a=
2dd
        failing since 312 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
