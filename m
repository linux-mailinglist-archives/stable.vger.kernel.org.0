Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 962CA5BB121
	for <lists+stable@lfdr.de>; Fri, 16 Sep 2022 18:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229454AbiIPQga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Sep 2022 12:36:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbiIPQg3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Sep 2022 12:36:29 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8520A81B3C
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:36:28 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso253468pjk.0
        for <stable@vger.kernel.org>; Fri, 16 Sep 2022 09:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=qnw3OkaYEkTgajGS4YS8w+MiqQGKksdwbtlBQEhitW0=;
        b=eqghC7dFdaOrKChRm5oJ8o8ek5XZL1ri0+zUqgEgq6nwFne1wwl7xBJn88TjCHXW1L
         qYqMUYeyD4Y/Y9qAorfA0T69iBMZFYTW4vkwKa0Ql2qCOB5uIH118GxF33yDOgbDw8Xr
         iIROQUp9lbN9ueXtjGFx9h8ekEks93koQO7AGZx6XPS2USlOcwG1ZWH8mZipDHBnCEtt
         mDPlcZuMli2uTzwtR6TZsqMr0h+ChjKt8Z/n/k/Mm1VNyNFVJ5hdepj7UeM0t9iXNuhH
         L3/veVaFKzMranBAPPYoyQIOvNyUzb1n2m0eHa/3Fy2SbOqDBnDYihT2mFGstPg9V+sd
         nnzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=qnw3OkaYEkTgajGS4YS8w+MiqQGKksdwbtlBQEhitW0=;
        b=X/6lt83DCrKIqdp+kZbtmccz3SsIQr1m+ElMTe3yXDM0mv+zXK9cstXKodCb2A0g74
         iqdlxuikaeh+G64sTqabO7nOjhdCd9fxUJHVJy1XY+yeUkEByc24ASe8fLYfg6YZqOZP
         KbsUxLX9lnnb5WDufoav+Bsa4QTmOAoBSBm3U0/tnVIt6fACYha4WsL+RVjyFw0pDxoE
         GvGBDXQjfpN++KFRQqnZ1v9nR1rQRo2aYMIFyVefEAD8C9WjS+Ag0wbMmgvBckInCjPZ
         k1A5iRs8UkbR93HG3wmWpJYuGQBwW2jBcekRMwN6GhnxAaVQuTYTkn1lnhX8LtVkTKrK
         tqrQ==
X-Gm-Message-State: ACrzQf3QE0XPMM/TGn9GDJDNMYPi8iKYt4FtMMyRUp4hJsFc+w9Em2J1
        lfG4huG6AFJnB9xj+96ri/Wc3ndwnOeRnboAv0I=
X-Google-Smtp-Source: AMsMyM7vQsiSSMXimuDazfX+kyGAdAiQUAVpZD81QfEqVZkXXrvPzLVsj6Ielqp+KTvCCumb/V/dFQ==
X-Received: by 2002:a17:902:db08:b0:176:d40e:4b57 with SMTP id m8-20020a170902db0800b00176d40e4b57mr668747plx.172.1663346187832;
        Fri, 16 Sep 2022 09:36:27 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902da8d00b0017887d6aa1dsm558148plx.146.2022.09.16.09.36.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Sep 2022 09:36:27 -0700 (PDT)
Message-ID: <6324a60b.170a0220.fafda.12a1@mx.google.com>
Date:   Fri, 16 Sep 2022 09:36:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9-37-g8cebb0b653514
Subject: stable-rc/queue/5.19 baseline: 187 runs,
 4 regressions (v5.19.9-37-g8cebb0b653514)
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

stable-rc/queue/5.19 baseline: 187 runs, 4 regressions (v5.19.9-37-g8cebb0b=
653514)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =

imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =

imx8mn-ddr4-evk      | arm64 | lab-nxp         | gcc-10   | defconfig      =
     | 1          =

kontron-pitx-imx8m   | arm64 | lab-kontron     | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.9-37-g8cebb0b653514/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.9-37-g8cebb0b653514
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8cebb0b6535147ff027216ddf9e5ed96ca997ef4 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
hifive-unleashed-a00 | riscv | lab-baylibre    | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6324707e698c0910d935564b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6324707e698c0910d9355=
64c
        failing since 3 days (last pass: v5.19.8-181-gaa55d426b3c1, first f=
ail: v5.19.8-186-g25c29f8a1cae5) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/63247756fda0060b3b355683

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63247756fda0060b3b355=
684
        failing since 30 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx8mn-ddr4-evk      | arm64 | lab-nxp         | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/632470160515d94954355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632470160515d94954355=
643
        new failure (last pass: v5.19.9-35-gde5881df904b) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
kontron-pitx-imx8m   | arm64 | lab-kontron     | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/63246f8f1f18cf64fc35564f

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-3=
7-g8cebb0b653514/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/632=
46f8f1f18cf64fc355662
        new failure (last pass: v5.19.9-35-gde5881df904b)

    2022-09-16T12:43:43.726664  /lava-168250/1/../bin/lava-test-case
    2022-09-16T12:43:43.727059  <8>[   22.739065] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-09-16T12:43:43.727317  /lava-168250/1/../bin/lava-test-case
    2022-09-16T12:43:43.727551  <8>[   22.758838] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2022-09-16T12:43:43.727781  /lava-168250/1/../bin/lava-test-case   =

 =20
