Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6AE45BC29D
	for <lists+stable@lfdr.de>; Mon, 19 Sep 2022 07:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229553AbiISFxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Sep 2022 01:53:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbiISFxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Sep 2022 01:53:36 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CA013F19
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 22:53:35 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id r23so17233114pgr.6
        for <stable@vger.kernel.org>; Sun, 18 Sep 2022 22:53:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=Ku5DK3lnmHrMKisAPjXy+jTZBrWbgnCkbf1gqDqydSs=;
        b=gMLreEEZkxyXWpnz0t1GQ8A0IO97BRv3bB6KkdHDuLxQ6BPlfBSz9GfzJY8dZwLcLi
         jNDVThJc8BeR4M21IOwWH2BaFJL+h19ggqcjGnpAxaSlHVoqTUUI0WAgKy8EEY0Jar53
         EUQpfMhewdlQRVb1cSyYn5M9syZJ8arSNYm9vX1jyxxSotodc1KBYXuvwvrVE2zynZf9
         XUAJYsIkQk3rCJ9iYEzui2qMr6YfkpoSJC+c3WZlNqThr1UJkoYtS5HrBbuL/D7u2+yW
         1QI/HBB1UIx9g+Xyjm0ulE/3frP7AabQTosTkU/QRGSwwuIr9VXtaotAnkNLaqe5bejy
         Bfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=Ku5DK3lnmHrMKisAPjXy+jTZBrWbgnCkbf1gqDqydSs=;
        b=7e9Grr5pHvFdJ6FuO/GEhg+IrCwWuRJ1lkMK5vpTS0W3xR6qfNP8gdllPLpgr6M8td
         t8kNvWz1zmDysYXI+9vNybpAMrmnJP+e1/dYBQXKiCPTele8Zj9471HrYuWVRz/9nHGE
         moshKLxeXIe33v85ggjus4hwJxrYgbVFnQRE20e0zKrWKMGmtQudY7d1fsMNJuTGvyhx
         0HG9CVAXzzVn5HXmLKD3bJ3YjFF3DcPIJ14gjELDwmeOL3ZRk9qzLSAjSgDB01DfHO/Z
         nRM4ZNdUAqJSF74qBx/xC5mYHEC08IhuAEUEhjSvhREkfKLGqs6tkGL2y7IjnCBqD66O
         ua7g==
X-Gm-Message-State: ACrzQf3syPcQ4c7RI/qzMT16nHhctLEExA/WYKlN26oKtNPNT2tqi7L8
        JqCqQS/D64d07Dq7HWU5aQ6LSIUGQbVsuEiK3fQ=
X-Google-Smtp-Source: AMsMyM5b51DuTOWty9QxpeabZrCqxEoMPIoK9xnZtDvw5bSnzDIybWdqAtcsI14RZxAw865UblqJGw==
X-Received: by 2002:a63:1444:0:b0:430:980f:e511 with SMTP id 4-20020a631444000000b00430980fe511mr14272144pgu.482.1663566814940;
        Sun, 18 Sep 2022 22:53:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g17-20020aa796b1000000b0054097cb2da6sm19223029pfk.38.2022.09.18.22.53.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 22:53:34 -0700 (PDT)
Message-ID: <632803de.a70a0220.61bd.164b@mx.google.com>
Date:   Sun, 18 Sep 2022 22:53:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.9-56-g29b6ff678b0e
Subject: stable-rc/queue/5.19 baseline: 180 runs,
 6 regressions (v5.19.9-56-g29b6ff678b0e)
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

stable-rc/queue/5.19 baseline: 180 runs, 6 regressions (v5.19.9-56-g29b6ff6=
78b0e)

Regressions Summary
-------------------

platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =

imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =

kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.9-56-g29b6ff678b0e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.9-56-g29b6ff678b0e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      29b6ff678b0efed6b486bdc70535fdb22c8d7097 =



Test Regressions
---------------- =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d13b9bac8c79f8355658

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d13b9bac8c79f8355=
659
        failing since 6 days (last pass: v5.19.8-181-gaa55d426b3c1, first f=
ail: v5.19.8-186-g25c29f8a1cae5) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx6ul-pico-hobbit           | arm   | lab-pengutronix | gcc-10   | imx_v6_=
v7_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d29d462ef95d903556ce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d29d462ef95d90355=
6cf
        failing since 33 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre    | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d5dfc0901e205b35564f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d5dfc0901e205b355=
650
        new failure (last pass: v5.19.9-55-g7dbe36eefdad) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp         | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d44477d143e067355675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327d44477d143e067355=
676
        new failure (last pass: v5.19.9-55-g7dbe36eefdad) =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
kontron-pitx-imx8m           | arm64 | lab-kontron     | gcc-10   | defconf=
ig                  | 1          =


  Details:     https://kernelci.org/test/plan/id/6327d30cacc32cc1983556ac

  Results:     51 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-im=
x8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/632=
7d30cacc32cc1983556bf
        new failure (last pass: v5.19.9-55-g7dbe36eefdad)

    2022-09-19T02:25:11.683017  /lava-169441/1/../bin/lava-test-case
    2022-09-19T02:25:11.683417  <8>[   22.699423] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2022-09-19T02:25:11.683673  /lava-169441/1/../bin/lava-test-case
    2022-09-19T02:25:11.683907  <8>[   22.719250] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>   =

 =



platform                     | arch  | lab             | compiler | defconf=
ig                  | regressions
-----------------------------+-------+-----------------+----------+--------=
--------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora   | gcc-10   | defconf=
ig+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6327ce1ba1fc5475793556da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.9-5=
6-g29b6ff678b0e/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6327ce1ba1fc547579355=
6db
        new failure (last pass: v5.19.9-55-g7dbe36eefdad) =

 =20
