Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D41BE564545
	for <lists+stable@lfdr.de>; Sun,  3 Jul 2022 07:29:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiGCF3O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Jul 2022 01:29:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiGCF3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Jul 2022 01:29:13 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC4E5FB0
        for <stable@vger.kernel.org>; Sat,  2 Jul 2022 22:29:12 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id ju17so1251257pjb.3
        for <stable@vger.kernel.org>; Sat, 02 Jul 2022 22:29:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k6Ydsu53w5SRORSDMT9SJEIq/0mzkiKqKVPWw2ZPnII=;
        b=wglHrzAXB0Ih1z+icrFwGr+z3uC/t9bMESHEeG6OVZWmURHfMJj1W/Byj+XxSuYOl9
         hw1frHjpZGGu2I92u4r0qYPgMpYzmU4gHHwpGdMuOUy01DQxVpsPfHXwn+P9I+Efyr0/
         gKkkWBumeiVFOCO54Rni2JEgzLsCq6lQoMibsn+jzXzTfY9YsefEDGhWzUC2FvauRw6I
         xPk3L7o29+vTaJr9SsgEyaVb5dJPrdTJRsupsUK90AFBNE7sLA4NAj6vgAjT1bZukvon
         fma+3/AJmgAzqqbcPXp09z/yy2X1k1G0kNbDl6U9fgl/RqoYnohE1JI0BEs910O/6kjB
         6Mcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k6Ydsu53w5SRORSDMT9SJEIq/0mzkiKqKVPWw2ZPnII=;
        b=4fBnFKdGtrE5ycgoae0OqAX1TeMvV//bNkDohXcIuyWSTKGq9BegV7yT29VMa+W4+Y
         WHOJvnUk+Yje1w/Nwgtnb7akHlGWHj6e+s/CCHs2EVhTlnNQ15Hop2AJxxbgiZ8YjTsM
         lZt0NVBKfADJDgB7VJkQhjFt6ZO+rzcdKH1duWeSrOk3xYIS8d5hyoUxe2NMMKI5gFJR
         cc79/aRmVHyuwDPWP8E4msewP1bYjTPBvpArztKiL7pxht/5K/iZGrcU1WD0nUO0nhNV
         irTl1ogBYod2SNrw7+xsy6i4llsqrA9XE3ZPhHMBSqNkAUZ54jqKq5ig/lckJjCP/MJ7
         TdjA==
X-Gm-Message-State: AJIora8+wSuqiBR1++9SPwSqLHrwp6hBdb4A7Xu2UXu2JhAD0chdmezW
        pyTQ2mRRxS0BF9iu5IM9UCVOlQ67ibgc6FwI
X-Google-Smtp-Source: AGRyM1t+LQ+7B988EXtuvNSk15m92SJQUhfHCzujNYreB4El6KClyDJCVxOYUaJjCQYowyyOhq0+/A==
X-Received: by 2002:a17:90a:5ae1:b0:1db:d0a4:30a4 with SMTP id n88-20020a17090a5ae100b001dbd0a430a4mr26932442pji.128.1656826151771;
        Sat, 02 Jul 2022 22:29:11 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u16-20020a170902e5d000b0016bd16f8acbsm2154864plf.114.2022.07.02.22.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jul 2022 22:29:10 -0700 (PDT)
Message-ID: <62c12926.1c69fb81.144b3.2cff@mx.google.com>
Date:   Sat, 02 Jul 2022 22:29:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51-27-g0db722373e0d
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 163 runs,
 4 regressions (v5.15.51-27-g0db722373e0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 163 runs, 4 regressions (v5.15.51-27-g0db722=
373e0d)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =

jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.51-27-g0db722373e0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.51-27-g0db722373e0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0db722373e0d1199bef0c93542a4234df29bc877 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
beagle-xm        | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig  =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0f430afed7affeea39bea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0f430afed7affeea39=
beb
        failing since 94 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig   =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0f611f6c6dc1210a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0f611f6c6dc1210a39=
bd0
        failing since 21 days (last pass: v5.15.45-667-g99a55c4a9ecc0, firs=
t fail: v5.15.45-798-g69fa874c62551) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0f41dcf1fca471fa39c68

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c0f41dcf1fca471fa39=
c69
        failing since 19 days (last pass: v5.15.45-833-g04983d84c84ee, firs=
t fail: v5.15.45-880-g694575c32c9b2) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62c0f22e3fa662954ba39be6

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.51-=
27-g0db722373e0d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62c0f22e3fa662954ba39c08
        failing since 117 days (last pass: v5.15.26-42-gc89c0807b943, first=
 fail: v5.15.26-257-g2b9a22cd5eb8)

    2022-07-03T01:34:27.690780  /lava-6736280/1/../bin/lava-test-case
    2022-07-03T01:34:27.701484  <8>[   33.350879] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
