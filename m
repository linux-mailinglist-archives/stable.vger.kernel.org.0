Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE4EA3D706E
	for <lists+stable@lfdr.de>; Tue, 27 Jul 2021 09:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235518AbhG0HcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Jul 2021 03:32:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235832AbhG0HcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Jul 2021 03:32:16 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC7ADC061764
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:32:16 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id mz5-20020a17090b3785b0290176ecf64922so2882639pjb.3
        for <stable@vger.kernel.org>; Tue, 27 Jul 2021 00:32:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UNIrrqM+G+xJsK8NmZ9GVnfTyPbM2qWfcKqlgrbrYgQ=;
        b=BgCaB2WBqdc7aABWh2j3YHbYoWvPxz/WzlKB/z6QVHhQu34XEzT5f+ojQhhqNAeP5a
         cihDXCAR2ineQuXxumv8Rkx8LDVY3vhu1Fu8hEHtJS9hCucCAcRxvd8xnT20lgfpiZ2o
         vPMP4K7nNT27fqr7rsyMccC9um7JnEION0Q3P4KmbRFWL0n042qTrTOcWV2CzaEVQitH
         blelTn9/vl1tt85VpuwloEJpYMSM1J+UZ+n4nkJpJjs9+J1sqDAF2fL9P2XmSquevxWY
         DiYRp6T2vkhUZYeqgcIymyJpryDQpo0MTRrr/aqlA6hHpPunY/tWvB6nbibjJVPRdgJk
         XdFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UNIrrqM+G+xJsK8NmZ9GVnfTyPbM2qWfcKqlgrbrYgQ=;
        b=J0JrQc/UFhwG8lccz4rmWuIZsybtAVikXyNSXYYt61cklOb85XPmvAespIcVbTVp7y
         sGgHmmqoNl8NU/gVvkT/MxzEXj5X8+B15LJbr6UMMliX8tURKSKqquLob/xHPfFkqWK/
         qvsmvk705Crqz0s5UuV3qM6ysXZFs9zTr/xwRCzLeWVdmwrG7dS3lsDeZYM0ht/3G6ZD
         XV+D2ztGtRsvUhfQnnfeND8V/qZTrSSwoNeKa7OA9dfSywl86MRx/WHU49xhgXSY+r9p
         Zjn7SY934E9kJKaLPj2CXDhaUCRI7mRweHmpU2pNGHp6dsO/8EyCFA0bhITGKcXkzoNB
         3G1A==
X-Gm-Message-State: AOAM530/ufxLDMGWEIYp51OC/R+d4pwpjQ9FDhxuaJlCTGAKWX/5/Qqw
        Hk377CMCzlv5sxDNnmud/p2UnxJ2pVNYgTKD
X-Google-Smtp-Source: ABdhPJzEyG8m/EfoeRNzPOQb42UbqipmdDItEqylpy9xjum8o6fteaH0Y+ldDG7I+c25FWElzDrjPA==
X-Received: by 2002:a17:90a:9205:: with SMTP id m5mr2979482pjo.172.1627371136161;
        Tue, 27 Jul 2021 00:32:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g1sm2302175pgs.23.2021.07.27.00.32.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jul 2021 00:32:15 -0700 (PDT)
Message-ID: <60ffb67f.1c69fb81.6bfb0.8185@mx.google.com>
Date:   Tue, 27 Jul 2021 00:32:15 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.13.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.13.5-225-g692072e7b7fa
Subject: stable-rc/linux-5.13.y baseline: 105 runs,
 5 regressions (v5.13.5-225-g692072e7b7fa)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.13.y baseline: 105 runs, 5 regressions (v5.13.5-225-g6920=
72e7b7fa)

Regressions Summary
-------------------

platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =

beagle-xm          | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig =
          | 1          =

beagle-xm          | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig=
          | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =

d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.13.y/ker=
nel/v5.13.5-225-g692072e7b7fa/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.13.y
  Describe: v5.13.5-225-g692072e7b7fa
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      692072e7b7faec65eef9b9fc79b980bd23745b50 =



Test Regressions
---------------- =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
bcm2837-rpi-3-b-32 | arm    | lab-baylibre | gcc-8    | bcm2835_defconfig  =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff7b8a52380416b53a2f38

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff7b8a52380416b53a2=
f39
        new failure (last pass: v5.13.3-508-g80f75a7443c5c) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
beagle-xm          | arm    | lab-baylibre | gcc-8    | multi_v7_defconfig =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff8145ffbef5c2f13a2f3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff8145ffbef5c2f13a2=
f3e
        failing since 6 days (last pass: v5.13.3-350-g6c45a6a40ddee, first =
fail: v5.13.3-349-g1d9dba03aebe5) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
beagle-xm          | arm    | lab-baylibre | gcc-8    | omap2plus_defconfig=
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff83e67913e5a2b53a2f40

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff83e67913e5a2b53a2=
f41
        failing since 11 days (last pass: v5.13.2, first fail: v5.13.2-254-=
g761e4411c50e) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defcon...6-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff88f23a172156473a2f32

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/=
baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff88f23a172156473a2=
f33
        failing since 15 days (last pass: v5.13.1, first fail: v5.13.1-783-=
g664307fdb480) =

 =



platform           | arch   | lab          | compiler | defconfig          =
          | regressions
-------------------+--------+--------------+----------+--------------------=
----------+------------
d2500cc            | x86_64 | lab-clabbe   | gcc-8    | x86_64_defconfig   =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/60ff8a4651337e26773a2f90

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.13.y/v5.13.5=
-225-g692072e7b7fa/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500c=
c.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ff8a4651337e26773a2=
f91
        failing since 15 days (last pass: v5.13.1, first fail: v5.13.1-783-=
g664307fdb480) =

 =20
