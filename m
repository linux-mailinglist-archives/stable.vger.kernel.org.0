Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F2523AD54B
	for <lists+stable@lfdr.de>; Sat, 19 Jun 2021 00:36:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhFRWiK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Jun 2021 18:38:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhFRWiJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Jun 2021 18:38:09 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F933C061574
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 15:35:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id m17so2261113plx.7
        for <stable@vger.kernel.org>; Fri, 18 Jun 2021 15:35:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iNdAbGgL/YcMah6RfQi/rOht+YdtJljz+Md3HYJzEO0=;
        b=D9Ab2PqHBNel4xaXGpZ3/MBNqyXkupbHCpKPPY/crXXwaPXUFH9YxQJEjutV9ZDfCt
         XBh//bS9Y4TPsbCQjsf6EFl+Lm9Ie/96NlCEjKCCMIldQRHqsTTd7LECf5NZhcoxGR7W
         Ivohj3YuDSikkeaUYGnowVWlpzw2NfmP0EeEzI52xSS/dMvGKT7nWNI0ssI7FmJ6ycFB
         gY+ZyGl1aDRClXziooBKlR/7fFBI6zbjL59E3BsAk54QMHBA5hpTK5UOMDuo+kT7Z9Io
         tgX2jNG5rRL/q5iHuPsuCU2dwt9nFmJDw5zG0/WDB1r6duC1duvG8UxYBwxmIxVIJO12
         TdbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iNdAbGgL/YcMah6RfQi/rOht+YdtJljz+Md3HYJzEO0=;
        b=YOlyW3zpAtHJYZdXay1EdyKTcJtk8Yxb/ShSondx/WdHdLq3JaiXvNs4vEdOgABwfz
         E+X6MLxbr27H5Xel3dsgIwp4tKlOgmvXk6oCnRGMUKbfVqGWjvQIf8pZ+jnMtNcZG1Ad
         q+2WAnwOH9Jl7bfDh451irllMxpde3AGYC8bu36eqIXZwmF7eQVU3H2wmfXTAaXjniTE
         deFxlOGWx+7V6SsJltoPhhd3IZdtIM1vNRfqewvQBGsaQ4Qv1JLb7GSzqeM7Wd8jLmUO
         qwAS/UqFmFqvgpQ4e+Pkv4VXBPefGjp8WSKGDfuT+fDHb2GGHDPaJRLiT5b3zEeopjeI
         D0RA==
X-Gm-Message-State: AOAM533uZkWX1jjQUmF9Iahr3XotaUgIIchIJc+jjcMKsElkrFFpBDCH
        U0y6JaLdXSoYHQT5LvTAZWyi1rrTaTtJd67r
X-Google-Smtp-Source: ABdhPJw3UhAwU0zhlXa2DcRm7aaFonzi5bkBzdhquNp7ad4cegiQnwovONMWGkK3SYTxyna4wBAi0w==
X-Received: by 2002:a17:90a:db8a:: with SMTP id h10mr2599958pjv.50.1624055758490;
        Fri, 18 Jun 2021 15:35:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g13sm8508746pfv.65.2021.06.18.15.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Jun 2021 15:35:58 -0700 (PDT)
Message-ID: <60cd1fce.1c69fb81.1bea1.8d36@mx.google.com>
Date:   Fri, 18 Jun 2021 15:35:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.127
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 152 runs, 7 regressions (v5.4.127)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 152 runs, 7 regressions (v5.4.127)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 2          =

hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =

qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.127/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.127
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a82d4d5e9fe6e6448fb5885a184460864c2f14a5 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
bcm2837-rpi-3-b-32   | arm   | lab-baylibre    | gcc-8    | bcm2835_defconf=
ig   | 2          =


  Details:     https://kernelci.org/test/plan/id/60cce7b1583bc73ff441326a

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60cce7b1583bc73=
ff441326e
        new failure (last pass: v5.4.125)
        4 lines

    2021-06-18T18:36:05.452798  kern  :alert : 8<--- cut here ---
    2021-06-18T18:36:05.484318  kern  :alert : Unable to handle kernel pagi=
ng request at virtual address 2eaaeaaa
    2021-06-18T18:36:05.485116  kern  :ale<8>[   12.890021] <LAVA_SIGNAL_TE=
STCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D4>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60cce7b1583bc73=
ff441326f
        new failure (last pass: v5.4.125)
        35 lines

    2021-06-18T18:36:05.488507  rt : pgd =3D a4f36da0
    2021-06-18T18:36:05.489276  kern  :alert : [2eaaeaaa] *pgd=3D00000000
    2021-06-18T18:36:05.534987  kern  :emerg : Internal error: Oops: 800000=
05 [#1] ARM
    2021-06-18T18:36:05.536152  kern  :emerg : Process mount (pid: 125, sta=
ck limit =3D 0x2b3c63dd)
    2021-06-18T18:36:05.536891  kern <8>[   12.933836] <LAVA_SIGNAL_TESTCAS=
E TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D35>   =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/60cce56dd6bf41983a413273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cce56dd6bf41983a413=
274
        failing since 210 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-baylibre    | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cce75d30ab8d1ad3413273

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cce75d30ab8d1ad3413=
274
        failing since 216 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-broonie     | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ccf101208f814e26413268

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ccf101208f814e26413=
269
        failing since 216 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-cip         | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cce7373ced70d515413266

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cce7373ced70d515413=
267
        failing since 216 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
qemu_arm-versatilepb | arm   | lab-linaro-lkft | gcc-8    | versatile_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60cd1756df0ed5149b413272

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.127=
/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilep=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60cd1756df0ed5149b413=
273
        failing since 216 days (last pass: v5.4.77-44-g28fe0e171c204, first=
 fail: v5.4.77-46-ga3e34830d912) =

 =20
