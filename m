Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDEA5EDF43
	for <lists+stable@lfdr.de>; Wed, 28 Sep 2022 16:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231167AbiI1Oya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Sep 2022 10:54:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbiI1Oy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Sep 2022 10:54:27 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B976C86FDA
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 07:54:26 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id a80so12754140pfa.4
        for <stable@vger.kernel.org>; Wed, 28 Sep 2022 07:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Tv1jgaCC/A2LyQHQf8Sy5YgSoYUrFvMtkplzYQppOVk=;
        b=hB3xXx4vwek6rRMLV3c11GoW0fUt8aDNM3xUgfRaH+CQBdkhrzTCWkoenfPjJGNcgh
         i8KD8G+CvICZqCbTu/4ByDRX4uZv/huU9w2mPmcz3aA7mH/PadltSIqLH7UvCh7kbHoM
         zW1mbUKp8ali6ErO9MAeIeswSCHURQUXq2looh/Xa2TeS5ShCEaxBo9Df5EQWFERJ5tu
         dlKcB+t1BvakvPhYOuQJ0kG8TqIaM8UY/S2ZXUJxN3qhbELqvBZmXkHV4UjxDQco7DVY
         nw8jS/+FsKOrGgl9YhMN1mNxlxvuw8wdM/yGjKIr8i1/BT4QaMBsjPbfwESJsfzPOxsY
         9KuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Tv1jgaCC/A2LyQHQf8Sy5YgSoYUrFvMtkplzYQppOVk=;
        b=ZAVEgNUt8EZYLhDSIrueiy4n0JF3Ty4YGn5PmyYWnjoeUWzzLVoKxzBkQrD4qhiFAk
         F9j6QlRoS5wJaYrJM9bkMfaWkFeil78bD3qrjsHDA+Fmnw5Yoj1Do1mahc8KN8gWN8Oj
         mbuY1rGvuWQTNQeoHhLqTvvXSSKhSuwTptR5ChiHssxZeWgvxbjV6lNdSS/9Em6EqVsq
         Q990MUoYVAnlTZWN2iqmuuQKvvs6R85ZLUIkVesHCHY+6NStFnuMu6I462w3cAieC/Ix
         FUCEPhleVNk2gMOwEXDWO4gy2OSAMq6RZ5tce2tWhyOTWr12ncnHzf++aFpSKw4a5vdG
         CdVg==
X-Gm-Message-State: ACrzQf22R86fTrtztq22J/rJv7m2Q7sYerta61cAn7IoV8V9IN07Ai+Q
        rjqUvabmOaGVXj8+LXd2M4UBvnAHQ8n7yXy/
X-Google-Smtp-Source: AMsMyM67R64SnuImE8FRvsQNGvnxPBbq065tiBMVQWGKCxqmReH8qgN5IeJSVQO4IAtnPJUR7R2yqw==
X-Received: by 2002:a63:154b:0:b0:42c:60ce:8bd3 with SMTP id 11-20020a63154b000000b0042c60ce8bd3mr29789338pgv.372.1664376866009;
        Wed, 28 Sep 2022 07:54:26 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y68-20020a623247000000b0053e7293be0bsm4066751pfy.121.2022.09.28.07.54.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 07:54:25 -0700 (PDT)
Message-ID: <63346021.620a0220.9dc4f.7232@mx.google.com>
Date:   Wed, 28 Sep 2022 07:54:25 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.71
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 194 runs, 5 regressions (v5.15.71)
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

stable/linux-5.15.y baseline: 194 runs, 5 regressions (v5.15.71)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

imx7ulp-evk        | arm    | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g          | 1          =

panda              | arm    | lab-baylibre  | gcc-10   | multi_v7_defconfig=
           | 1          =

panda              | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =

rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.71/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.71
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      90c7e9b400c751dbd73885f494f421f90ca69721 =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-x360-14-G1-sona | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6334292d924d26d34aec4ed4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360=
-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-hp-x360=
-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6334292d924d26d34aec4=
ed5
        new failure (last pass: v5.15.70) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
imx7ulp-evk        | arm    | lab-nxp       | gcc-10   | imx_v6_v7_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/633428009b3995c850ec4eb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633428009b3995c850ec4=
eb4
        new failure (last pass: v5.15.67) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
panda              | arm    | lab-baylibre  | gcc-10   | multi_v7_defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/63342c1c870a838507ec4ec5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63342c1c870a838507ec4=
ec6
        failing since 41 days (last pass: v5.15.59, first fail: v5.15.61) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
panda              | arm    | lab-baylibre  | gcc-10   | omap2plus_defconfi=
g          | 1          =


  Details:     https://kernelci.org/test/plan/id/6334286f134b2c8599ec4eb3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6334286f134b2c8599ec4=
eb4
        failing since 27 days (last pass: v5.15.62, first fail: v5.15.64) =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
rk3399-gru-kevin   | arm64  | lab-collabora | gcc-10   | defconfig+arm64-ch=
romebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/63342d0136e05d2369ec4eb1

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.71/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/63342d0136e05d2369ec4ed7
        failing since 203 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-09-28T11:16:00.446160  /lava-7437002/1/../bin/lava-test-case   =

 =20
