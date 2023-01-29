Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AE84680124
	for <lists+stable@lfdr.de>; Sun, 29 Jan 2023 20:12:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230082AbjA2TMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Jan 2023 14:12:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjA2TMR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Jan 2023 14:12:17 -0500
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF03F4EC0
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 11:12:15 -0800 (PST)
Received: by mail-pl1-x630.google.com with SMTP id be8so9538637plb.7
        for <stable@vger.kernel.org>; Sun, 29 Jan 2023 11:12:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=DF5v7PTPnnI3GpN7zTZIGQ/Vd1d9ebu5vqslZHX4dCQ=;
        b=Uc1yKsuR1jv+NCtOm2BJ4+WFLM8UE1/r3sx00lAbeG8es+V5tNYr0ABnE/wbnHd1hl
         RHw+WzWoF6VKDAJ/aC15S7zmfmhF9OTqinPnfXJYg0cq3vg3RGgme20gHk900TLOLNG3
         DsFrdvfWEtONV2HDpHiYwf8Hoejw+dYHoJhHJUZh/k4qTTUEemPPFdn7w6vfCiroQ9xC
         7pz2wfvT4eTAhdX97M92R3QmQQZCW90rvqUi1zWEyrL++npPV0GSwzi7ZaRNB7/W232J
         H5uyEn7i3dVZJ+igUeyelGLEC428BeVugt6SZc8mJQtfqfh6xcK1gWL/JnwDAMlWH5iK
         7VlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DF5v7PTPnnI3GpN7zTZIGQ/Vd1d9ebu5vqslZHX4dCQ=;
        b=3oPYKtBNB9yRunu/tBj5sjhh9RofeMj+Sr3AimuhSriME6RHt2pvCDO4GHWpeYqzqT
         iZpyAj2RPC+94qUaO4sgPK/mn+vQWgNtEGJSRhWcmJ9G7ubv8NWn6LDMDvrHnIDJgJi2
         4mKbo1gharwFQSednPH1/cByXPgpTKraDYHwJyc8XgiKXnWTSO+3Oz9qS98iSnMYnjhK
         vWS9y/ElpUK/inLKHRX3T86iej/PXLUfAIskt1k2OQMw9NnZZMX8WmssU54Od8SafehQ
         JDKrdYyn7y29YivlV86P35r3xiV54cy3C1IVfYet6bOSeVuQXH1+D3XuCDay5w6tB/0q
         kA4w==
X-Gm-Message-State: AO0yUKU2R/sayuXCPQx3JfJjZ6H5n9/BH25AdoAOfYMFZAPK+TVKTvrE
        IwF2Ro6i9enIFHFKdc8deMF4WBkKHw0cqbkRZSScZw==
X-Google-Smtp-Source: AK7set9fex+I8a00uNZukOrNsIcy9O8rMxyvwyTCv2Btj72fmJu2AOudL3Ki7Tf3nd2mp7tyBkC1tw==
X-Received: by 2002:a17:90b:1d8a:b0:22c:792:d342 with SMTP id pf10-20020a17090b1d8a00b0022c0792d342mr18652673pjb.26.1675019535091;
        Sun, 29 Jan 2023 11:12:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11-20020a17090a384b00b00226369149cesm8207164pjf.21.2023.01.29.11.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Jan 2023 11:12:14 -0800 (PST)
Message-ID: <63d6c50e.170a0220.5cd29.cae6@mx.google.com>
Date:   Sun, 29 Jan 2023 11:12:14 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.90-166-gcdf32c35a616
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 182 runs,
 4 regressions (v5.15.90-166-gcdf32c35a616)
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

stable-rc/queue/5.15 baseline: 182 runs, 4 regressions (v5.15.90-166-gcdf32=
c35a616)

Regressions Summary
-------------------

platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =

imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =

sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =

sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.90-166-gcdf32c35a616/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.90-166-gcdf32c35a616
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cdf32c35a61639046b67ead78b73d146925eb0df =



Test Regressions
---------------- =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
cubietruck             | arm   | lab-baylibre    | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d69368bbb0b4c6c7915ed7

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d69368bbb0b4c6c7915edc
        failing since 12 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-29T15:40:09.083347  <8>[    9.936107] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3239856_1.5.2.4.1>
    2023-01-29T15:40:09.189566  / # #
    2023-01-29T15:40:09.291620  export SHELL=3D/bin/sh
    2023-01-29T15:40:09.292165  #
    2023-01-29T15:40:09.393491  / # export SHELL=3D/bin/sh. /lava-3239856/e=
nvironment
    2023-01-29T15:40:09.394032  =

    2023-01-29T15:40:09.495343  / # . /lava-3239856/environment/lava-323985=
6/bin/lava-test-runner /lava-3239856/1
    2023-01-29T15:40:09.496018  =

    2023-01-29T15:40:09.497316  / # /lava-3239856/bin/lava-test-runner /lav=
a-3239856/1<3>[   10.353817] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-01-29T15:40:09.497483   =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
imx53-qsrb             | arm   | lab-pengutronix | gcc-10   | multi_v7_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63d6930453b88a5552915ebc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d6930453b88a5552915ec1
        failing since 2 days (last pass: v5.15.81-121-gcb14018a85f6, first =
fail: v5.15.90-146-gbf7101723cc0)

    2023-01-29T15:38:19.183207  + set +x
    2023-01-29T15:38:19.183421  [    9.311809] <LAVA_SIGNAL_ENDRUN 0_dmesg =
891119_1.5.2.3.1>
    2023-01-29T15:38:19.290428  / # #
    2023-01-29T15:38:19.392210  export SHELL=3D/bin/sh
    2023-01-29T15:38:19.392792  #
    2023-01-29T15:38:19.494174  / # export SHELL=3D/bin/sh. /lava-891119/en=
vironment
    2023-01-29T15:38:19.494667  =

    2023-01-29T15:38:19.595944  / # . /lava-891119/environment/lava-891119/=
bin/lava-test-runner /lava-891119/1
    2023-01-29T15:38:19.596673  =

    2023-01-29T15:38:19.599635  / # /lava-891119/bin/lava-test-runner /lava=
-891119/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-baylibre    | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d697849e37505fcd915ebe

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm64/defconfig/gcc-10/lab-baylibre/baseline-sun50i-a64-p=
ine64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d697849e37505fcd915ec3
        failing since 11 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-29T15:57:34.317646  + set +x
    2023-01-29T15:57:34.321928  <8>[   16.109181] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3239946_1.5.2.4.1>
    2023-01-29T15:57:34.443732  / # #
    2023-01-29T15:57:34.549729  export SHELL=3D/bin/sh
    2023-01-29T15:57:34.551419  #
    2023-01-29T15:57:34.655986  / # export SHELL=3D/bin/sh. /lava-3239946/e=
nvironment
    2023-01-29T15:57:34.658697  =

    2023-01-29T15:57:34.762420  / # . /lava-3239946/environment/lava-323994=
6/bin/lava-test-runner /lava-3239946/1
    2023-01-29T15:57:34.765352  =

    2023-01-29T15:57:34.768692  / # /lava-3239946/bin/lava-test-runner /lav=
a-3239946/1 =

    ... (12 line(s) more)  =

 =



platform               | arch  | lab             | compiler | defconfig    =
      | regressions
-----------------------+-------+-----------------+----------+--------------=
------+------------
sun50i-a64-pine64-plus | arm64 | lab-broonie     | gcc-10   | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/63d6942e26f4c1e499915eba

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.90-=
166-gcdf32c35a616/arm64/defconfig/gcc-10/lab-broonie/baseline-sun50i-a64-pi=
ne64-plus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230120.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63d6942e26f4c1e499915ebf
        failing since 11 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-01-29T15:43:33.391334  + set +x
    2023-01-29T15:43:33.395338  <8>[   16.122403] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 205931_1.5.2.4.1>
    2023-01-29T15:43:33.507615  / # #
    2023-01-29T15:43:33.611561  export SHELL=3D/bin/sh
    2023-01-29T15:43:33.612400  #
    2023-01-29T15:43:33.714318  / # export SHELL=3D/bin/sh. /lava-205931/en=
vironment
    2023-01-29T15:43:33.714987  =

    2023-01-29T15:43:33.816855  / # . /lava-205931/environment/lava-205931/=
bin/lava-test-runner /lava-205931/1
    2023-01-29T15:43:33.817970  =

    2023-01-29T15:43:33.821810  / # /lava-205931/bin/lava-test-runner /lava=
-205931/1 =

    ... (12 line(s) more)  =

 =20
