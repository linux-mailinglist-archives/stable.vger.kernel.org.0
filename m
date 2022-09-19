Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9675BD422
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 19:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiISRw7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 13:52:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231403AbiISRwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 13:52:42 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01D574507F
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 10:52:17 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id a5-20020a17090aa50500b002008eeb040eso6924392pjq.1
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 10:52:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=hk/hVIXCPyMDsZ1gvK+5BdfzvrcX0XrAVr9d7xrPINM=;
        b=mz8G6p3HEp+AelXtgypMxeD9eWADPC18bArx7lqBPd4eQxLCnFXVOPB/BvlU24n7O/
         g7/GdLAS6GAGzbQlK2VN6Qzs3zRUMol8fvcYaleL7n0lIN8az1kSdlG92fMv7AQrBl2H
         RAWg9xJXIjzFtb0gm3nBu40N1hPygGfRy5bPCGP6Nqz5Kw/Y8TakK9zq0mP7nZjgWFoT
         xcOcHY3BklziR0KBcYRJk1ONOJvDXzgCwPsS3m7M15RUrPdvNhDB57CEPpNFGKcAn4ZN
         WzEU4H6HpCDJ2jRsUM179MfpGGXXIWzhhGg66qSgpGC1/75asjQbJFfdMY8OS8XxFy2G
         4PfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=hk/hVIXCPyMDsZ1gvK+5BdfzvrcX0XrAVr9d7xrPINM=;
        b=aMQ3bJGLg1Cg79hkKDhyxj0DfuUP3QPcAtXWfOkdoDOoTkeo2lkoYQZmoPLA9ZYMvf
         bGNQTaysUttNwxRVEpbp7oI+xF7DjmftktnOWOJZbSuEBX6hqgnfifRJNpYDZTTlc7uH
         +jiyB2UzykrbQzNSP9j3zaEuPDrMCvL2eTdxojwZbQGF2OwD5KIFvkrgzo3ML9RVfVfe
         8lzjo2zDIkwZuL7RUFLPMJDa6E986py7IPNPY9gkFF7+qu1I+9qUglFy4zv7KsPAbcNJ
         aqSR5wq6xgyBA7MU/nPWS9Xjk1wbgjMt6POh7fJXoaQbeIp8wHRLhfZOfNSY51c6g+H+
         bxvw==
X-Gm-Message-State: ACrzQf2Y16Ks1ULgQw/hBRDbqvY0rFy7Ql8cEumL8e+npiKDa9iuaSab
        BKQ6fx8TCkM3nFIF1rQshK1M2JpESlBRNWbLQ4M=
X-Google-Smtp-Source: AMsMyM7MjJhECfgk7RyctMJVfsQcWi7dD6ENZyCOJKalrCRKDy43tdBNaronOzP0UhuDytlWYIAEJQ==
X-Received: by 2002:a17:90a:b00a:b0:203:87a3:9e70 with SMTP id x10-20020a17090ab00a00b0020387a39e70mr8151090pjq.218.1663609937153;
        Mon, 19 Sep 2022 10:52:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9-20020a170902e54900b00174be817124sm21001964plf.221.2022.09.19.10.52.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 10:52:16 -0700 (PDT)
Message-ID: <6328ac50.170a0220.5fd04.5be1@mx.google.com>
Date:   Mon, 19 Sep 2022 10:52:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.19-1-gc95d56eff5e4
Subject: stable-rc/queue/5.18 baseline: 173 runs,
 7 regressions (v5.18.19-1-gc95d56eff5e4)
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

stable-rc/queue/5.18 baseline: 173 runs, 7 regressions (v5.18.19-1-gc95d56e=
ff5e4)

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

beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =

odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =

rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.19-1-gc95d56eff5e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.19-1-gc95d56eff5e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c95d56eff5e4bb7c23801bb9708ed1297dda9a17 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2835-rpi-b-rev2           | arm   | lab-broonie     | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/6328787a8541eec416355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6328787a8541eec416355=
654
        failing since 33 days (last pass: v5.18.16-7-g7fc5e6c7e4db1, first =
fail: v5.18.17-1094-g906dae830019d) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
bcm2836-rpi-2-b              | arm   | lab-collabora   | gcc-10   | bcm2835=
_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/63287b39d1c121eed0355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/bcm2835_defconfig/gcc-10/lab-collabora/baseline-bcm2836=
-rpi-2-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63287b39d1c121eed0355=
648
        failing since 35 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
beagle-xm                    | arm   | lab-baylibre    | gcc-10   | omap2pl=
us_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/63287ad42c7ac307bd35564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63287ad42c7ac307bd355=
64c
        failing since 13 days (last pass: v5.18.18-6-gad8a0ac8e472, first f=
ail: v5.18.19-1-g1330c8c8f8f63) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63287bed9937d309e0355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx6=
ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63287bed9937d309e0355=
643
        failing since 75 days (last pass: v5.18.9-96-g91cfa3d0b94d, first f=
ail: v5.18.9-102-ga6b8287ea0b9) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
odroid-xu3                   | arm   | lab-collabora   | gcc-10   | exynos_=
defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/632881785f83bacab2355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/exynos_defconfig/gcc-10/lab-collabora/baseline-odroid-x=
u3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632881785f83bacab2355=
659
        failing since 36 days (last pass: v5.18.17-41-g6a725335d402d, first=
 fail: v5.18.17-134-g620d3eac5bbd1) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
rk3288-veyron-jaq            | arm   | lab-collabora   | gcc-10   | multi_v=
7_defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/63288ab42843ba788635565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63288ab42843ba7886355=
65d
        failing since 35 days (last pass: v5.18.17-134-g620d3eac5bbd1, firs=
t fail: v5.18.17-1078-g5c55e4c4afa02) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632879ebcbba72a566355650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.19-=
1-gc95d56eff5e4/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632879ebcbba72a566355=
651
        failing since 0 day (last pass: v5.18.19-1-g3cc7eb2847e1, first fai=
l: v5.18.19-1-g1e27be8389f7) =

 =20
