Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D07C454E7F
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240694AbhKQUZY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:25:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240696AbhKQUZX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:25:23 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71A8DC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:22:24 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id z6so1999654plk.6
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:22:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9CShJWuFR5UBrAT3zQyxC9HSFYvK81F4NVkPLY4A+GM=;
        b=4iwWPALT2Xn1g6M7yXQD+Rcn6VTmyySF1kfLp12uBhGh/O1aZz0xs3FvQ8CONQaL0c
         +m1/ljusS6Tqo3fGlvwLbXu7+ZdiEH/ZdHCm3SYUI9rqr73G1RX+fvaaQonqZEJOXSPF
         soN3s/dEpIDPCdmVvDkacOTRGAfuJbDZJqj2RtoPaTUNZI8hM+BY5zAdgFPZgdBzyaKt
         4BVFLiIDpDWav2nNtyC5RpfoAMY7pkukxFRyOx1XLZAwABFzSohyA4EjJevt70Ln0/aB
         jwqBsz6EpIiZRgLkBnkJpeaRDiOl2F8EJgTi0Dy5aFUoyMY0NHB9Y9tOjmPWHolB2LRT
         Doqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9CShJWuFR5UBrAT3zQyxC9HSFYvK81F4NVkPLY4A+GM=;
        b=EqTQRWWEFL0NTRKA1B1PnbSeDEnqzMm5zpg+LMyoZw8DNzqHla7x0CuSrA0FzXJu6N
         z5by/YiaT3j+NVKf9a4yYtHIlPh6mw9VfJmDfrBw0//RzWSnHFhEEQllraBkjdaei3u8
         K1QMfvAXgoTQH/grlNdKS5ksZGxHVfMNd1AQKAwuE3oMD5ej0VRK4bhxriwM1veLvsp0
         SgFR27zCVW13gjITwHNDhiv+dml5oB/U8L0cy4CW2J5gEa7rZAqqLYDdVslR5YEptCmT
         rxp2gUEb43GPEg/VDz9BHoGS4/soFSjhpPj3Y4NgDtb+0gK8rF0wmCBIBewn43RiYgcI
         5dZw==
X-Gm-Message-State: AOAM531+71G7CFIP0L7zJ4Iq9S+TzBJwZpkTEdpdtOd+15zXJXeu6wAU
        PpgZVsyrBA2ixCqBnfEPXQoncDKOpuQzGNia
X-Google-Smtp-Source: ABdhPJzgpI5T4nb1rhL0bbB5vm/sn5dUy+bqmYrLjPZpSWMqWgTw00PNbhX3XGhT/89w7FFrEojWhQ==
X-Received: by 2002:a17:903:22cc:b0:142:d31:bd9 with SMTP id y12-20020a17090322cc00b001420d310bd9mr58412423plg.64.1637180543857;
        Wed, 17 Nov 2021 12:22:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz7sm6083253pjb.7.2021.11.17.12.22.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 12:22:23 -0800 (PST)
Message-ID: <6195647f.1c69fb81.8fb68.231f@mx.google.com>
Date:   Wed, 17 Nov 2021 12:22:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.79-569-g7cba82f768816
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 151 runs,
 2 regressions (v5.10.79-569-g7cba82f768816)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 151 runs, 2 regressions (v5.10.79-569-g7cba8=
2f768816)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.79-569-g7cba82f768816/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.79-569-g7cba82f768816
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7cba82f768816ce2fbcb073efd0e123692d35c1b =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61952c9cc93abb08133358f9

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
569-g7cba82f768816/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.79-=
569-g7cba82f768816/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6=
q-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61952c9cc93abb0=
8133358fd
        new failure (last pass: v5.10.79-577-g36adb8b9fb074)
        4 lines

    2021-11-17T16:23:42.861235  kern  :alert : 8<--- cut here ---
    2021-11-17T16:23:42.861497  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-11-17T16:23:42.861966  kern  :alert : pgd =3D (ptrval)
    2021-11-17T16:23:42.862680  kern  :alert : [<8>[   39.397537] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-11-17T16:23:42.862916  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61952c9cc93abb0=
8133358fe
        new failure (last pass: v5.10.79-577-g36adb8b9fb074)
        26 lines

    2021-11-17T16:23:42.912984  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-11-17T16:23:42.913245  kern  :emerg : Process kworker/1:3 (pid: 75=
, stack limit =3D 0x(ptrval))
    2021-11-17T16:23:42.913717  kern  :emerg : Stack: (0xc3281eb0 to<8>[   =
39.443897] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-11-17T16:23:42.913954   0xc3282000)
    2021-11-17T16:23:42.914170  kern  :emerg : 1ea0<8>[   39.455609] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1093759_1.5.2.4.1>
    2021-11-17T16:23:42.914384  :                                     1e9b1=
0fe f23d6f68 c180ab40 cec60217   =

 =20
