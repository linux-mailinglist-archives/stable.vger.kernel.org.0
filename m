Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D642D69E9
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:31:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404876AbgLJVbi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:31:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404854AbgLJVb1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:31:27 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF103C0613CF
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:30:42 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id s21so5343459pfu.13
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:30:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YgSLdYi7JKgtbWoT1e/gYPqWwmitdrQHBkktbQBMAnM=;
        b=LUh11ejwA4BI0oM3WCNJWffxf4CpYr/mUtioDCtxnLUf0cIdT4v53yvW6sG++Ka5sl
         Ng0W17mRfZnwNUEkDwk9Ov9/wh9rkLV/xraatF2x2tgPMdrYf60xs6FZZGZUdY8haZKX
         +CAMCY/CIRcqdUUGEnqIVvX0Itg8U3fJMyKuxUH4oJ6yg58cWcAvcT+E03cwMbnee+2n
         MCYRQ7aFHePJKvgu19ZhfvxbRvMRzSIno7LAm7XjJnqra4npF7EtcCIC1EY4pKlOo2hv
         EBV3N19MgQxXOFAd59ycTEweWehoKgAR7wnmm4KNAW5DH/p5bziKFy8SGzp/O5bi9mEt
         V0ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YgSLdYi7JKgtbWoT1e/gYPqWwmitdrQHBkktbQBMAnM=;
        b=GGaY4+qqCgP1hIumLR9t7PjrlEmgsaCA2TeHCcgic0QGgoJ040bDZZCDUUMhXbWCKL
         +yw2ov4RmSRLoeAqEF7AplLC1KReSAI1Zxf6TJzYz6HGY/NWBoegsnJ4bIsq3vWO9pY8
         9Ox8Knt2/+OlPOkD99etRtIDWh4hRPWg8SHVJWVWNxyXZZN0El9VWScIW+B2G/PgCi/W
         GQZ8Gv8qmvu0IEc20e3OeieUhbeJ9PwmVjiE4299zch+/E5/CJEJ/uj5GmUrLWcOjK3D
         ZFnf/RNRqwmY9iU2EJ3mk1D936QFgMLLnmN+qtF4BR/AZFf15xhJqKaUdsIlrecAA4Rk
         wH0g==
X-Gm-Message-State: AOAM533buqTYmON84q221Sv9cABSrYEqWxw0weQfEK2xl+Nm5x/fBoaP
        R1eUHiTV80tFYfXCqjFDp24DEy9uF9/F2Q==
X-Google-Smtp-Source: ABdhPJznYpbgQJ/LtIz6qK59Jy0nnRp/zDIlIH7toUGTQT1JD8fTbtiV+9ENqIeJCLrWS5LzQh4qgA==
X-Received: by 2002:aa7:9ac9:0:b029:19e:19b6:6e09 with SMTP id x9-20020aa79ac90000b029019e19b66e09mr8443012pfp.49.1607635842100;
        Thu, 10 Dec 2020 13:30:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm7739043pff.44.2020.12.10.13.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Dec 2020 13:30:41 -0800 (PST)
Message-ID: <5fd29381.1c69fb81.d370d.e465@mx.google.com>
Date:   Thu, 10 Dec 2020 13:30:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.82-55-g42be163bd071
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 178 runs,
 7 regressions (v5.4.82-55-g42be163bd071)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 178 runs, 7 regressions (v5.4.82-55-g42be163b=
d071)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =

rk3288-rock2-square  | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.82-55-g42be163bd071/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.82-55-g42be163bd071
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42be163bd071e1951059edd5185125448a0f9830 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd259d9f4e910c954c94cd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed=
-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd259d9f4e910c954c94=
cd1
        failing since 20 days (last pass: v5.4.78-5-g843222460ebea, first f=
ail: v5.4.78-13-g81acf0f7c6ec) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd259db827a6cad32c94ce1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd259db827a6cad32c94=
ce2
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd259d5f4e910c954c94ccd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd259d5f4e910c954c94=
cce
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd259d133cb764ba2c94cc8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd259d133cb764ba2c94=
cc9
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd259a0481b9cb1f7c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd259a0481b9cb1f7c94=
ce5
        failing since 26 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-rock2-square  | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25d08bad68dc09ec94cfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-r=
ock2-square.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-r=
ock2-square.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd25d08bad68dc09ec94=
cfc
        new failure (last pass: v5.4.82-54-g1eabd0fdb4d4) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
rk3288-veyron-jaq    | arm   | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd25d8a162983dd07c94cbd

  Results:     68 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.82-55=
-g42be163bd071/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-v=
eyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
5fd25d8a162983dd07c94cca
        new failure (last pass: v5.4.82-54-g1eabd0fdb4d4)

    2020-12-10 17:40:21.388000+00:00  <8>[   12.517028] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =

 =20
