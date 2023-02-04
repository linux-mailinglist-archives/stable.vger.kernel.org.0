Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E18468AC35
	for <lists+stable@lfdr.de>; Sat,  4 Feb 2023 20:59:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbjBDT7K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Feb 2023 14:59:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230222AbjBDT7K (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Feb 2023 14:59:10 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C2A4EC9
        for <stable@vger.kernel.org>; Sat,  4 Feb 2023 11:59:08 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id o68so4649470pfg.9
        for <stable@vger.kernel.org>; Sat, 04 Feb 2023 11:59:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=lWLM4aQZxMAGRVItx5KXq2ipr62nWkKcNK7HKR2CACQ=;
        b=NYUT60jVkfVNW5efLllfdpK92doBkxchVK3F4A/l/HNwqgQyaH4pYEixjJ7BTKkVe1
         KPpp2Tuy9oSoB2f7zexfw3PIFLlSvucz3T8bWsS114en2NhLGULKlffqSwKWpJBdhTFM
         Pu8un+8/MsZbLTMarorPYoWtaO6PoyfJy6LksAPnP0TzljE2XIhGEzzpbRNf8UFJfH2Z
         nGPyh4byJQU/PjovXg5M+Bb5KVkioFy5KQwy5cAn9ppypDSXIQRVuByBP4gw7Cn3cCuR
         6+ZAC3M8TtJ/Q1v+4aOeZhXY93oJ8Sw8fHiwMzQ4GUNe4TvAyBIIc8X1zcnG7ahaX8Vj
         u4OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWLM4aQZxMAGRVItx5KXq2ipr62nWkKcNK7HKR2CACQ=;
        b=vpSYr4lLTZ0ZLrzO8ASXBt/rhTgi7hKx17W2r7AN0uqeUIA5vkbXEN4yscVDworMsU
         vjWZW/53zFqcp9AOj/qL+Gtb1iyuUvagvK755ykvCypgmTzrVxRREdAv+/PqY2d3n/wy
         lmtwK5o7cSs1XbkNLv/7aPZetidLsBtXwTYaln/YmAdI1g/XKraXkr+IubLYJYXLRkmc
         tfEz4z8LWhTxq728o5HxrqE6bIfMIAFk+G5J3fV7dAR+HO4o6zrfJbxonZxXLtGQTd1B
         Rjr1fQFtsSrU1Ty+JfyrzYnHwfpkPwtKJAOELaHq8sHIRrnfTUbPQbWgG8XIrK0XCDzs
         spIg==
X-Gm-Message-State: AO0yUKWTzYPQvgPXknM8LLAPcpE63NHY34LinOIL/YDMwtAbJ3Rr7Icn
        r9eAWr96xgf29iZkiYA9HBgglQRpl5LUSGEcjw9fvw==
X-Google-Smtp-Source: AK7set+Rc1QGjjqLvO4cW/CZfc6ZaU1dlJXfo8DJU75JACzGDR+OkY2vY/vcGumhUgdLe71jvE79pg==
X-Received: by 2002:aa7:84d7:0:b0:593:cade:6376 with SMTP id x23-20020aa784d7000000b00593cade6376mr11888340pfn.2.1675540748016;
        Sat, 04 Feb 2023 11:59:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a1-20020aa780c1000000b00592591d1634sm4163409pfn.97.2023.02.04.11.59.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Feb 2023 11:59:07 -0800 (PST)
Message-ID: <63deb90b.a70a0220.8d1b7.724f@mx.google.com>
Date:   Sat, 04 Feb 2023 11:59:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Kernel: v5.10.166-10-g34c96ff6b629e
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 172 runs,
 4 regressions (v5.10.166-10-g34c96ff6b629e)
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

stable-rc/linux-5.10.y baseline: 172 runs, 4 regressions (v5.10.166-10-g34c=
96ff6b629e)

Regressions Summary
-------------------

platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

stm32mp157c-dk2        | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.166-10-g34c96ff6b629e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.166-10-g34c96ff6b629e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      34c96ff6b629e921f52b9f3adae8a3275042d6a6 =



Test Regressions
---------------- =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
cubietruck             | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63de85e6de92e0be66915ec6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cu=
bietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de85e6de92e0be66915ecb
        failing since 17 days (last pass: v5.10.158-107-gd2432186ff47, firs=
t fail: v5.10.162-852-geeaac3cf2eb3)

    2023-02-04T16:20:23.803526  <8>[   10.994799] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288433_1.5.2.4.1>
    2023-02-04T16:20:23.914378  / # #
    2023-02-04T16:20:24.017895  export SHELL=3D/bin/sh
    2023-02-04T16:20:24.019335  #
    2023-02-04T16:20:24.121597  / # export SHELL=3D/bin/sh. /lava-3288433/e=
nvironment
    2023-02-04T16:20:24.122804  =

    2023-02-04T16:20:24.123349  / # . /lava-3288433/environment<3>[   11.29=
1634] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-02-04T16:20:24.225382  /lava-3288433/bin/lava-test-runner /lava-32=
88433/1
    2023-02-04T16:20:24.226949  =

    2023-02-04T16:20:24.231985  / # /lava-3288433/bin/lava-test-runner /lav=
a-3288433/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
stm32mp157c-dk2        | arm   | lab-baylibre | gcc-10   | multi_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/63de853de71eac5ac1915f3d

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-st=
m32mp157c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-st=
m32mp157c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de853de71eac5ac1915f42
        failing since 1 day (last pass: v5.10.147, first fail: v5.10.166-10=
-g6278b8c9832e)

    2023-02-04T16:17:55.492533  <8>[   12.588671] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288435_1.5.2.4.1>
    2023-02-04T16:17:55.598450  / # #
    2023-02-04T16:17:55.700866  export SHELL=3D/bin/sh
    2023-02-04T16:17:55.701621  #
    2023-02-04T16:17:55.803426  / # export SHELL=3D/bin/sh. /lava-3288435/e=
nvironment
    2023-02-04T16:17:55.803804  =

    2023-02-04T16:17:55.905233  / # . /lava-3288435/environment/lava-328843=
5/bin/lava-test-runner /lava-3288435/1
    2023-02-04T16:17:55.906278  =

    2023-02-04T16:17:55.910641  / # /lava-3288435/bin/lava-test-runner /lav=
a-3288435/1
    2023-02-04T16:17:55.977476  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63de8b057ec9b91caf915ef7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a6=
4-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a6=
4-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de8b057ec9b91caf915efc
        failing since 5 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-04T16:42:19.563177  <8>[   17.051517] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3288514_1.5.2.4.1>
    2023-02-04T16:42:19.683221  / # #
    2023-02-04T16:42:19.788828  export SHELL=3D/bin/sh
    2023-02-04T16:42:19.790337  #
    2023-02-04T16:42:19.893793  / # export SHELL=3D/bin/sh. /lava-3288514/e=
nvironment
    2023-02-04T16:42:19.895349  =

    2023-02-04T16:42:19.998796  / # . /lava-3288514/environment/lava-328851=
4/bin/lava-test-runner /lava-3288514/1
    2023-02-04T16:42:20.001531  =

    2023-02-04T16:42:20.004759  / # /lava-3288514/bin/lava-test-runner /lav=
a-3288514/1
    2023-02-04T16:42:20.046505  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (11 line(s) more)  =

 =



platform               | arch  | lab          | compiler | defconfig       =
   | regressions
-----------------------+-------+--------------+----------+-----------------=
---+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie  | gcc-10   | defconfig       =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/63de8836229f6e847f915f51

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64=
-pine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
66-10-g34c96ff6b629e/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64=
-pine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230127.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63de8836229f6e847f915f56
        failing since 5 days (last pass: v5.10.158-107-g6b6a42c25ed4, first=
 fail: v5.10.165-144-g930bc29c79c4)

    2023-02-04T16:30:39.329347  + set +x
    2023-02-04T16:30:39.333401  <8>[   17.093102] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 251474_1.5.2.4.1>
    2023-02-04T16:30:39.444299  / # #
    2023-02-04T16:30:39.547287  export SHELL=3D/bin/sh
    2023-02-04T16:30:39.547885  #
    2023-02-04T16:30:39.650417  / # export SHELL=3D/bin/sh. /lava-251474/en=
vironment
    2023-02-04T16:30:39.651086  =

    2023-02-04T16:30:39.753671  / # . /lava-251474/environment/lava-251474/=
bin/lava-test-runner /lava-251474/1
    2023-02-04T16:30:39.755746  =

    2023-02-04T16:30:39.760146  / # /lava-251474/bin/lava-test-runner /lava=
-251474/1 =

    ... (12 line(s) more)  =

 =20
