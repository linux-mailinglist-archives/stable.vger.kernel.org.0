Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A66BC5BD456
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 20:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbiISSFC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 14:05:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiISSFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 14:05:00 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98AB564F9
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 11:04:59 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id l65so354742pfl.8
        for <stable@vger.kernel.org>; Mon, 19 Sep 2022 11:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=vQzD6Y+/4S+Pa3EYH//3qk4BwaCYJvS4nh9v+LGidpg=;
        b=wFX+CiGGB5/3x/RsRmwMYpCmb1qQBc3GSi+PTYxJO6IvYNfue4ZTb8vEuZng/JOu/l
         C4OthWilucFqtqe9W0VGpVJc4mryPdMAQKvtzreg+LvHpY4JdE6Dk5THmqG/E5SWHApC
         lpE7xSSDSpZinkKMtl7NaYN6GsQ8azliMXlpSnAc2JAxF5YeXgEJAI5zQb0z7K7OIb1Y
         mmC/mC3tuXPJrJzm/+VlrG3OEZxSAQ5BSPyVLF0WuNyUQ6rF/5Q5/WmW2mgPThimMYJ1
         bj5pgY33i4s0wMGwLK8KlCAtuLAyjXK9Htcap+p9zg9yRX+6Hoq38w5s4LJiHzmpNelf
         vIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=vQzD6Y+/4S+Pa3EYH//3qk4BwaCYJvS4nh9v+LGidpg=;
        b=kc6Pk5cP7oKSx83ekaYquRL0oBRn6lPd/fItuOJDY/GhxnEYAVEEiwXz8b7utmbzsE
         cMi77QseCXjwx2zuWg8e0nr1pBc46+5FGOe2EprqBVjgCySb4iTUR3RFJ2S5UprmwX87
         FzBnhS48wqdcBa3StwO11ng/wkUcfwphO4E5qkT0BNvvdf+bH1W26QzIRTNHzj8uIGg8
         2fUMyUVNKYnCtWaiX/6oh8u2r1TssGOAsnyDUGpPyW3VCNSnKxN84kPDHFuWHifRKxOT
         tdA8SZJFa1xQH+CVVtfmPwPkU5mDCAcFk0gnykaC86K65VuEE3yx0dEcePCNqC3iM3e5
         yGJg==
X-Gm-Message-State: ACrzQf2jCAD8mVU7dUcNPdp3OhTDNOq8vvP7GWnXXRqDwKUN8h6ludba
        +4Gm3NOdjWzz/4r7FX6BN6X9uD1oyabd/e+HA8g=
X-Google-Smtp-Source: AMsMyM4Il1ykKzwbUpj+RE6TBZl6BNM/sCSoDJofEOVDBc/NRJnx7natzNlBktnKoinkwLhyf7KqjA==
X-Received: by 2002:a05:6a00:174f:b0:537:6845:8b1a with SMTP id j15-20020a056a00174f00b0053768458b1amr20336664pfc.68.1663610698988;
        Mon, 19 Sep 2022 11:04:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 75-20020a62164e000000b005499599ed30sm10058388pfw.10.2022.09.19.11.04.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Sep 2022 11:04:58 -0700 (PDT)
Message-ID: <6328af4a.620a0220.f4c6a.1739@mx.google.com>
Date:   Mon, 19 Sep 2022 11:04:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9-37-g42f0e52f05d4
Subject: stable-rc/queue/5.19 baseline: 162 runs,
 4 regressions (v5.19.9-37-g42f0e52f05d4)
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

stable-rc/queue/5.19 baseline: 162 runs, 4 regressions (v5.19.9-37-g42f0e52=
f05d4)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =

imx8mn-ddr4-evk    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
   | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =

odroid-xu3         | arm   | lab-collabora   | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.9-37-g42f0e52f05d4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.9-37-g42f0e52f05d4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      42f0e52f05d45ca2cf4e0392fc1cbf24a6b3830a =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx6ul-pico-hobbit | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63287fd5b1c6e98c9d355649

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63287fd5b1c6e98c9d355=
64a
        failing since 33 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
imx8mn-ddr4-evk    | arm64 | lab-baylibre    | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63287b56ec8ce0f12635567d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63287b56ec8ce0f126355=
67e
        failing since 0 day (last pass: v5.19.9-55-g7dbe36eefdad, first fai=
l: v5.19.9-56-g29b6ff678b0e) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63287b47d1c121eed035565c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63287b47d1c121eed0355=
65d
        new failure (last pass: v5.19.9-56-g29b6ff678b0e) =

 =



platform           | arch  | lab             | compiler | defconfig        =
   | regressions
-------------------+-------+-----------------+----------+------------------=
---+------------
odroid-xu3         | arm   | lab-collabora   | gcc-10   | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/6328890de1e15b2666355648

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g42f0e52f05d4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-odroid=
-xu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6328890de1e15b2666355=
649
        new failure (last pass: v5.19.9-56-g29b6ff678b0e) =

 =20
