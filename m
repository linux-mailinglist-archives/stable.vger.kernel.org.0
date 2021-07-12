Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D38923C405A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 02:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbhGLAfv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Jul 2021 20:35:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbhGLAfu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Jul 2021 20:35:50 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BD46C0613DD
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 17:33:03 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id cu14so3813032pjb.0
        for <stable@vger.kernel.org>; Sun, 11 Jul 2021 17:33:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8jR+Ri82tMy0so4GjU/NHh3Qxns4oRWYkIoSig1Lb2U=;
        b=IH32gMVFNxrrTvXSW6s46oyxb4ib76DFeBzwHTW8RtCOUv1AOdQdX/SRmz8UUp34Ei
         JY/julahdqt6VV7kJb0N1fmbSaVPoeNJHCUbQM8O7pfQ5EaIL1oCw/WjfYMWskq4XPBh
         oSQSMW/C3zkXXcmWnVl3LrZiTdwJwyB2V1JzLrEW05dQ7B0/OGxU+8XkfRoeX9MTnHLN
         CZyIW9AkkwWYiM5MWgXJSjr+t/lJQnEHRx5WW7nRrEf2f/eVVQq1QOOBxX5RdKzMpaLr
         XwVk+5N+LG5ed0RY5QSSkIRjERt807ksrHDZ+EUmQIYvoYnqH45tzTIs7UMPYCAXV6BH
         zthA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8jR+Ri82tMy0so4GjU/NHh3Qxns4oRWYkIoSig1Lb2U=;
        b=MjXyg7UtINeHa2dbV1HV109G/zPj7SkpTJd8uk3zW8gtLQHNsWmxLj+vwkValoOWqf
         oGGkFy6NSP1VewY0iNa0NO1fZg2L4qpXf2DKGgEuOC5SWUGK5Blslh1Jf0kdhcJoRwxz
         7Kaw/ikcRrW0ueHG+Cn9tvilPg78/QDqvR+mfkQAcUKLmGX0gPbdHy8hFTV9/KZgOE46
         RpIA5U/E/ILeltPgaGmLA9bWYHJBUn4iOFOqsxRxhSVz+HXsLymxsJrlqFS/BLSL+b2c
         1r9XYlWp5EqFIrOKfQL5Eys/OHW9Z1sjIUW4vyCUrfk6seEcro39Ru6zExIcNvtMDrtC
         6YMQ==
X-Gm-Message-State: AOAM530RopvF81d+EBvHsaUr3Y5ug/QUYVEgBl9fWIGkEWhOH6H7vDBo
        OuRtTN+fSPW/ZTSA9wR/Jj2B9Tphu5K3R6Da
X-Google-Smtp-Source: ABdhPJzfThQJmfrSyCWIWJ5/1ZvGfkBMTYOC9UAeclo4FOD+szbGcb/m4GKlgbYDx852L48X2mcJgw==
X-Received: by 2002:a17:90a:e992:: with SMTP id v18mr11437977pjy.138.1626049982408;
        Sun, 11 Jul 2021 17:33:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c10sm13007018pfo.129.2021.07.11.17.33.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jul 2021 17:33:02 -0700 (PDT)
Message-ID: <60eb8dbe.1c69fb81.1f9a4.775a@mx.google.com>
Date:   Sun, 11 Jul 2021 17:33:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.12.16-702-gd61ecea7819e8
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 185 runs,
 7 regressions (v5.12.16-702-gd61ecea7819e8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 185 runs, 7 regressions (v5.12.16-702-gd61=
ecea7819e8)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
bcm2837-rpi-3-b-32  | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig=
            | 2          =

d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =

d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig =
            | 1          =

hip07-d05           | arm64  | lab-collabora | gcc-8    | defconfig        =
            | 1          =

imx8mp-evk          | arm64  | lab-nxp       | gcc-8    | defconfig        =
            | 1          =

r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.16-702-gd61ecea7819e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.16-702-gd61ecea7819e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d61ecea7819e83a8ccc67ebba5f8609afaa1eb67 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
bcm2837-rpi-3-b-32  | arm    | lab-baylibre  | gcc-8    | bcm2835_defconfig=
            | 2          =


  Details:     https://kernelci.org/test/plan/id/60eb5af7215ed861c5117978

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2=
837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2=
837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/60eb5af7215ed861=
c511797e
        new failure (last pass: v5.12.16)
        1 lines

    2021-07-11T20:55:54.408719  / # #
    2021-07-11T20:55:54.411293  =

    2021-07-11T20:55:54.521743  / # #
    2021-07-11T20:55:54.523617  =

    2021-07-11T20:55:55.798903  / # #export SHELL=3D/bin/sh
    2021-07-11T20:55:55.810314  =

    2021-07-11T20:55:55.811064  / # ex<3>[    7.587124] brcmfmac: brcmf_sdi=
o_htclk: HT Avail timeout (1000000): clkctl 0x50
    2021-07-11T20:55:55.811679  port SHELL=3D/bin/sh
    2021-07-11T20:55:57.453202  / # . /lava-547794/environment
    2021-07-11T20:56:00.449522  /lava-547794/bin/lava-test-runner /lava-547=
794/0 =

    ... (11 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60eb5af7215ed86=
1c5117980
        new failure (last pass: v5.12.16)
        15 lines

    2021-07-11T20:56:00.695259  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] ARM
    2021-07-11T20:56:00.696523  kern  :emerg : Process S50pnp_networki (pid=
: 144, stack l<8>[   13.547754] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg =
RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D15>
    2021-07-11T20:56:00.697317  imit =3D 0x17e2dadc)   =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defcon...6=
-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb598b4fdb4b3030117970

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabb=
e/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb598b4fdb4b3030117=
971
        failing since 0 day (last pass: v5.12.15, first fail: v5.12.16) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
d2500cc             | x86_64 | lab-clabbe    | gcc-8    | x86_64_defconfig =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5bcfe800fe5eef11799c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/x86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d250=
0cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5bcfe800fe5eef117=
99d
        new failure (last pass: v5.12.16) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
hip07-d05           | arm64  | lab-collabora | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb6df02519faceca117991

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb6df02519faceca117=
992
        failing since 10 days (last pass: v5.12.13-11-g6645d6f022e7, first =
fail: v5.12.14) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
imx8mp-evk          | arm64  | lab-nxp       | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5d8a662db1172811799b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5d8a662db11728117=
99c
        failing since 3 days (last pass: v5.12.14, first fail: v5.12.15) =

 =



platform            | arch   | lab           | compiler | defconfig        =
            | regressions
--------------------+--------+---------------+----------+------------------=
------------+------------
r8a77950-salvator-x | arm64  | lab-baylibre  | gcc-8    | defconfig        =
            | 1          =


  Details:     https://kernelci.org/test/plan/id/60eb5e353a9f57fc8d11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-s=
alvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
6-702-gd61ecea7819e8/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77950-s=
alvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60eb5e353a9f57fc8d117=
96b
        new failure (last pass: v5.12.16) =

 =20
