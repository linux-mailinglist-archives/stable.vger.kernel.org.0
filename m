Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C1CE5BC275
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 07:15:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiISFP1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 01:15:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbiISFPZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 01:15:25 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1A1DF12
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 22:15:23 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s206so25773785pgs.3
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 22:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=1B8vcpuqUKZU5z2JX8Sdn+JDioXBxt9j3N/3f7WWhOY=;
        b=oG9j7LdUBRtEf2iKyeJmcJE0R788JgB8CyPcvb16PoCTGHX1YfyR++8USKL/BW+MQV
         A/wkTkhrcRIjrWSLIhAton4CV08cCTd1VO6MpODRzljJfnTgUryHsSGIrBcaVcHtOSvo
         Iru19WMj3e5FNno6YiBBXpCZgxQSXkjZ01DoyMaTPVLLAEfaQrs20ifVQlw1ue+aMJD2
         8XTwPHYhZ6M+9j9w4oA9AOCfiF0Kzy3JRP6cTE0OzP1UtAuwfGwpR1m4h3KE0Rc1LROj
         aJCWH4Dtm/xRqb/vzfuUgFJtZjfHd4snCxQ0yF80B+BaxrUtD/Z0Ur33MxfXxuZSk2bn
         zQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=1B8vcpuqUKZU5z2JX8Sdn+JDioXBxt9j3N/3f7WWhOY=;
        b=UqTmhbvSa/y8N+dfY9+pIAVZPqJZQINvupCTe7tLm/3oj3gfzAiPXM404y1xAKxeGO
         qS5E3Z3Cj/zSYse7J28a7SM09yjDjnLBm9yTOxpTSHNHXJr43jrs+gv9etNygkfv1Pq2
         N3UceiAdzg6WpHpMoe2PIkY2HcLy6f8syGtpoRRT7sa4iDBhaIgkwn2RzruiBtZ5qKG7
         gm2Tc3FFQMZF7XNP05WEgPK+IfvMgqmbEc1M91dQ2V36s5AyRtI6f8Ih4HbonRBig+Dl
         r0TupgjJEppkaO7YBB5PAJBJV8VHrmEa5h8Pln4ITCd4tvA8F8yChmZxU/9O3Gae5Wzp
         pQYQ==
X-Gm-Message-State: ACrzQf0dLarrQ9lY8RiF/yCznXaz9gAwAK2ZkWSuJv22ritX84LwvLAY
        KjmhC80v8E+D1sMdiRgeS+tTeaEHQRfZrxH7lKM=
X-Google-Smtp-Source: AMsMyM77MI37tlOQYd6iNjkxfwLMHnMrzLZUVeZD3bmzjsjRCAMsVWoIc0wAf/YXQJ5biqz3x7TiJQ==
X-Received: by 2002:a63:d0b:0:b0:439:72d7:ef81 with SMTP id c11-20020a630d0b000000b0043972d7ef81mr14079677pgl.605.1663564522146;
        Sun, 18 Sep 2022 22:15:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14-20020a170902654e00b0017541ecdcfesm19600692pln.229.2022.09.18.22.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 22:15:21 -0700 (PDT)
Message-ID: <6327fae9.170a0220.d5702.2ecd@mx.google.com>
Date:   Sun, 18 Sep 2022 22:15:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-g8961940d2668
Subject: stable-rc/queue/5.18 baseline: 177 runs,
 7 regressions (v5.18.19-1-g8961940d2668)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 177 runs, 7 regressions (v5.18.19-1-g8961940=
d2668)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie     | gcc-10   | bcm2835=
_defconfig          | 1          =

bcm2836-rpi-2-b              | arm   | lab-collabora   | gcc-10   | bcm2835=
_defconfig          | 1          =

hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-g8961940d2668/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-g8961940d2668
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8961940d26681809a33da3cb2c0ad853150ea58f =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie     | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6327c701fee6c18031355646

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327c701fee6c18031355=
647
        failing since 33 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2836-rpi-2-b              | arm   | lab-collabora   | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d1dcdbee8ab363355666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d1dcdbee8ab363355=
667
        failing since 34 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327c88e990ad814b5355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327c88e990ad814b5355=
672
        failing since 6 days (last pass: v5.18.19-1-g935d5e1a94dd, first fa=
il: v5.18.19-1-g05c6ce2df587) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6327cb0b058dd42fd3355686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327cb0b058dd42fd3355=
687
        failing since 75 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/6327dc6dd0f50ee1d8355671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327dc6dd0f50ee1d8355=
672
        failing since 36 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6327e0307cb3fb3f1935564e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327e0307cb3fb3f19355=
64f
        failing since 34 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6327c7f51d5dd41113355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-g8961940d2668/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327c7f51d5dd41113355=
659
        failing since 0 day (last pass: v5.18.19-1-g3cc7eb2847e1, first fai=
l: v5.18.19-1-g1e27be8389f7) =

 =20
