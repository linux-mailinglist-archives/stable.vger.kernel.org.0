Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720583885E2
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 06:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232105AbhESEQ6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 00:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231893AbhESEQ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 00:16:58 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79875C06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 21:15:38 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id ep16-20020a17090ae650b029015d00f578a8so2732385pjb.2
        for <stable@vger.kernel.org>; Tue, 18 May 2021 21:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/l4axUsLruF3uxyyMeQHGqFqmAu3ZP39tFaZQe6G/7g=;
        b=eD9mJXiJfxZc2LpAU4ztXsX2clNmInY/Ql6XpEdUnsJaGqh/VkJnClGGL8ctMoQvjS
         crl5vd/DMu7vuxomcfqcX0MV56kprrpQNwGRn163+DY1+dsX06vktZl7Wyo2QaTszXHz
         BqWGMLkrZpUcemz4T8voQ0UJ2J+8BGc3EIapO/owwmh+Hj6jua5iUxKuUNZTHan48oDm
         LFh1bIk2M68Jd7ckpzjw2eJ5wNNFubtijmiCLMJHKj/lImtN0OHjDXwMlyZNjQdeOyeb
         sDDa0+8t9xTGSPnxcY2P3EFFmpjV7g557hnePHvU4AeVGOi2GgniqiBTMKa86pWH0jtL
         bpNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/l4axUsLruF3uxyyMeQHGqFqmAu3ZP39tFaZQe6G/7g=;
        b=h5+idhUp/XN8OZrZRyyAbUSuzqdDm8Qwa8lA0dK8oHK23/2IuXuyX2bpM+hJQuZcHg
         UGYTFL3VnCvJ0O+48ECZYVq2N6pMVLzPz+2sJ9caHe2PY20OSpyA1uVmCNqidGLLpoR4
         E4piUmERinMG5g4JlNR/SRSblDkBDK1ropgHMzy0OY4rqo7Z8BqyKvObTZVpu26eEP4p
         OEJtEB42CQU2h3F9raHCFy4Gsba5hxNvVUxxXsFAbKWMdwOQXTC1yrn5XtsSLNgdWzFd
         8eDljOxVcWprAs+BasB4aBTu1EkI07kpic8kortFsLX/+KZcdBId73QoHhoJsyphKYWN
         iy1Q==
X-Gm-Message-State: AOAM531p2XdZ1sZEqm3G3VQqFtmGKZ4zZ2GblUvqAPMuaVBI4grikzZI
        avmxFdERzlyni1JYBXcNzi7tT01oxgkeZXm6
X-Google-Smtp-Source: ABdhPJzHkYmraD8CAkpXP4gb3daXxuTlZLM97ZQ7jGUB9KnG5yEWXB0TzVgjGetLM7fqEy1X6IP8Lw==
X-Received: by 2002:a17:90a:510d:: with SMTP id t13mr9146861pjh.97.1621397737737;
        Tue, 18 May 2021 21:15:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x19sm11933675pgj.66.2021.05.18.21.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 21:15:37 -0700 (PDT)
Message-ID: <60a490e9.1c69fb81.657a1.962f@mx.google.com>
Date:   Tue, 18 May 2021 21:15:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.11.21-329-gc58bf3153f0d
X-Kernelci-Branch: queue/5.11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.11 baseline: 166 runs,
 4 regressions (v5.11.21-329-gc58bf3153f0d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.11 baseline: 166 runs, 4 regressions (v5.11.21-329-gc58bf=
3153f0d)

Regressions Summary
-------------------

platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
bcm2837-rpi-3-b-32       | arm  | lab-baylibre    | gcc-8    | bcm2835_defc=
onfig   | 1          =

imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =

imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.11/ker=
nel/v5.11.21-329-gc58bf3153f0d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.11
  Describe: v5.11.21-329-gc58bf3153f0d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c58bf3153f0da4e1d2c53ba68cb5b9778ead6b45 =



Test Regressions
---------------- =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
bcm2837-rpi-3-b-32       | arm  | lab-baylibre    | gcc-8    | bcm2835_defc=
onfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/60a45ddbe129889c2ab3af98

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
329-gc58bf3153f0d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
329-gc58bf3153f0d/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a45ddbe129889=
c2ab3af9f
        new failure (last pass: v5.11.21-329-gbb5fbf7284df)
        1 lines

    2021-05-19 00:37:27.133000+00:00  <8>[   15.560919] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2021-05-19 00:37:27.133000+00:00  + set +x   =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6q-var-dt6customboard | arm  | lab-baylibre    | gcc-8    | multi_v7_def=
config  | 2          =


  Details:     https://kernelci.org/test/plan/id/60a462d8b0b26ed93ab3b04f

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
329-gc58bf3153f0d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
329-gc58bf3153f0d/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60a462d8b0b26ed=
93ab3b055
        failing since 1 day (last pass: v5.11.19-48-gd53cc5ac4f922, first f=
ail: v5.11.21-308-ge37d6a211413)
        4 lines

    2021-05-19 00:56:54.348000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-05-19 00:56:54.349000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-05-19 00:56:54.349000+00:00  kern  :alert : [<8>[   39.066827] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-05-19 00:56:54.350000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60a462d8b0b26ed=
93ab3b056
        failing since 1 day (last pass: v5.11.19-48-gd53cc5ac4f922, first f=
ail: v5.11.21-308-ge37d6a211413)
        26 lines

    2021-05-19 00:56:54.408000+00:00  kern  :emerg : Process kworker/1:2 (p=
id: 81, stack limit =3D 0x(ptrval))
    2021-05-19 00:56:54.408000+00:00  kern  :emerg : Stack: (0xc363beb0 to<=
8>[   39.114127] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail U=
NITS=3Dlines MEASUREMENT=3D26>
    2021-05-19 00:56:54.408000+00:00   0xc363c000)
    2021-05-19 00:56:54.408000+00:00  kern  :emerg : bea0<8>[   39.125262] =
<LAVA_SIGNAL_ENDRUN 0_dmesg 347979_1.5.2.4.1>
    2021-05-19 00:56:54.409000+00:00  :                                    =
 00000001 00000000 c363a000 cec60217   =

 =



platform                 | arch | lab             | compiler | defconfig   =
        | regressions
-------------------------+------+-----------------+----------+-------------=
--------+------------
imx6ul-pico-hobbit       | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a4619b2cd9fb75d9b3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
329-gc58bf3153f0d/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.11/v5.11.21-=
329-gc58bf3153f0d/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a4619b2cd9fb75d9b3a=
f98
        new failure (last pass: v5.11.21-329-gbb5fbf7284df) =

 =20
