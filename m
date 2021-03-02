Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF2832B1F7
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241182AbhCCAvH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:51:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442202AbhCBRaF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 12:30:05 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE7EC0698DA
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 09:22:53 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d2so2462494pjs.4
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 09:22:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LmPJ2Ehf4DELlZA+HgC95T0zFAKKQjMjcJ9yZH2is5Y=;
        b=ituW1exKaTcHdTIuivqAn68SfcEzHcNB339A7KV5+4rEdTPcO8UmTwV+ApFQTpxMOg
         aNQ8gkZbzJrBz1b5ZUxzpJZHm4uo0dNtdukPGSYggcWkdpCC4TRw/yjtV0bSZQOIuP4M
         iOrLEXJFp2uwr5toMKXKPdN45tDDL1s1IeGbTSy7x0pzw2FnPH25gkbm06cH9QHNxdQi
         HomJsyqdJGZtkU69TDNFhnC+P5mLGXQsdQaVlD8CK+KHB/JMYlWISR9FsndBh9uZmHR8
         4kQjSeyPBPxhaDVv3q53Wn9XIurNEq+Uf0bOopFv2ORHMisVd5o8tVQi1BgtzEWQELvd
         B8pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LmPJ2Ehf4DELlZA+HgC95T0zFAKKQjMjcJ9yZH2is5Y=;
        b=cqt7ExA8IdTZj6Y8hWEjUW8Sac9J3AnhRDAe3anQbruXBRL8snSwqwLLjxh7qAcR21
         1QlfbAzieuYKI/wgxcbvD0kv7hEnRMy+/v+y+Axz2SLW+R+e8eSUiezcBIRhrNbRNNtw
         kpEsV3A0csgBWHVu9IcH2px2bP2HV+ScQh/2m3VYYX9IqoLr4DEQNco7oKPZ7n79v4Tv
         wcl0RfCUDPD7WGUUVGiHxEUGIaFH8wlbzBDryr2s2HhKcz4zI7W+S6RQWthlxYxFidvn
         irLagyljBxivVEaxDf92pwKJhw4wVlPXayRBx2R4ZW/BCkUWh7sL93ULgXHgj1QfE58N
         xcOQ==
X-Gm-Message-State: AOAM533VOFHmeDL4A+jtEgQpnF5wzUoSpAFyA4KZQRpeJAWh9sSu+APn
        YODbAvfi3sBhufx3I8+PtPkyx96qZ3deAA==
X-Google-Smtp-Source: ABdhPJyLmdZi8MkwBj0sTQKfqLAWTluHsRnTr8u7Jfct1/0ABQNbYpkvNZ+aSlkSIXbKPIIzcRvwjg==
X-Received: by 2002:a17:902:b7cb:b029:e4:55cd:ddf0 with SMTP id v11-20020a170902b7cbb02900e455cdddf0mr4293739plz.45.1614705772620;
        Tue, 02 Mar 2021 09:22:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q64sm8806619pfb.6.2021.03.02.09.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 09:22:52 -0800 (PST)
Message-ID: <603e746c.1c69fb81.81e37.417d@mx.google.com>
Date:   Tue, 02 Mar 2021 09:22:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.101-339-gfc16823099a3b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 174 runs,
 5 regressions (v5.4.101-339-gfc16823099a3b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 174 runs, 5 regressions (v5.4.101-339-gfc16=
823099a3b)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.101-339-gfc16823099a3b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.101-339-gfc16823099a3b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fc16823099a3b9f92cdd37b0bd83de3aa6fda140 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxm-q200       | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/603e433da20a60adf7addcdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q=
200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e433da20a60adf7add=
cdd
        new failure (last pass: v5.4.101-13-gfb2c1a9e8644) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e4054769cbf93e6addce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e4054769cbf93e6add=
ce2
        failing since 107 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e4046769cbf93e6addcc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e4046769cbf93e6add=
cc3
        failing since 107 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e402e273896b3bbaddcb5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e402e273896b3bbadd=
cb6
        failing since 107 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e3ff95018ebccbbaddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.101=
-339-gfc16823099a3b/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e3ff95018ebccbbadd=
cb2
        failing since 107 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
