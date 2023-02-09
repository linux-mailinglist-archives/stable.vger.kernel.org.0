Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE4F690E89
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 17:41:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjBIQl4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 11:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjBIQly (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 11:41:54 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9C1C40E9
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 08:41:51 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d8so2220834plr.10
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 08:41:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=iwbxCVyXvvLhxghw0wAjl4+k6wqoAI7lQCD/XkggfKs=;
        b=ou36pT3yOVvT/sWTq+/i9IHRdhEpikTo1QvzoEUiiBCnxUEFRU8Ifgw/VsIRiRyuMf
         vwE1Wkh05EiyMUGdUNcCLGL96LxYkOO+jvd/x9cvxhIG7Fz3jewAYlHv+XZbp3ftaqd/
         zBxuddxlTbOmzS/FP0WuPSJ4oWL2R1ay0oOkI7DVxtUmY2FVivmTlPHrIrlT0wNDK6c2
         ZwL6w10rHXt11xSgQEhLC2671EbhRTRciRQjaJPiAcT7HlVJzfuTTE8bXLT/nt8EB9t/
         nbEFsUewCO3ICw0iCwdTnU6sBvwDmVL2YmY0Gau+pxCCx1w+cAvxkPgd3xy2RkyEDQK+
         +m7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iwbxCVyXvvLhxghw0wAjl4+k6wqoAI7lQCD/XkggfKs=;
        b=hMsRNvza62O0K6a2MXU0ZYS2QJvW2RVZGtIvOfHRvMzXihLOQdZB7zxoWUyoLQzsrg
         RC3OjSC2NH2E5G/bS4NDwT+q77XP0fUxKcsZ7rMeD8JOhOh6lGvToCYOKH1M8G35xBya
         zX/vDRGNwP/ZDo2c1Qdu9ABxszUxgnsa/Ie5iQc9X/aA6qePuyIDf/eRYGsc5BjQW1cC
         U60MQqiBZPjC2ILm5YvwwzT8+oCrZjdylm2EUxGxK4FD4YbRnjnwNpcxi79gesLNvjS2
         aZNuihwicsALrRcfo9/t857ANfHmGSR9lg/DECdjmmpiww4fWKtNp1GxVZq1br4/KyKj
         RW0g==
X-Gm-Message-State: AO0yUKVGz9D5eJ3sPLvQpJNK/TCUeODluVxyxQ9jEPz1D2Xb4jpgKx3s
        ge/D9Y/hyP7GFfSTu0TTeiPdZV8Yd6yE5Qx8qqU=
X-Google-Smtp-Source: AK7set+lDjgApwJv9FrPmJy5073oGvLUa2in63vJxUkmvMKQJKMxKQPSatPo0CKtrNU7H2QCMDFQag==
X-Received: by 2002:a17:902:c7d3:b0:199:4289:6d32 with SMTP id r19-20020a170902c7d300b0019942896d32mr5306542pla.48.1675960910792;
        Thu, 09 Feb 2023 08:41:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jd2-20020a170903260200b0019324fbec59sm1737708plb.41.2023.02.09.08.41.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Feb 2023 08:41:50 -0800 (PST)
Message-ID: <63e5224e.170a0220.8a0a5.2b54@mx.google.com>
Date:   Thu, 09 Feb 2023 08:41:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.92-120-gc5b70dd8a279
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 168 runs,
 4 regressions (v5.15.92-120-gc5b70dd8a279)
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

stable-rc/queue/5.15 baseline: 168 runs, 4 regressions (v5.15.92-120-gc5b70=
dd8a279)

Regressions Summary
-------------------

platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
cubietruck         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =

imx53-qsrb         | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =

kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.92-120-gc5b70dd8a279/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.92-120-gc5b70dd8a279
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c5b70dd8a27965aca94b8390d62caa347f060d58 =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
cubietruck         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4efd067c3c166428c8630

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.92-=
120-gc5b70dd8a279/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.92-=
120-gc5b70dd8a279/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubie=
truck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4efd067c3c166428c8639
        failing since 23 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-09T13:06:09.493173  <8>[   10.114623] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3312679_1.5.2.4.1>
    2023-02-09T13:06:09.600318  / # #
    2023-02-09T13:06:09.701982  export SHELL=3D/bin/sh
    2023-02-09T13:06:09.702412  #
    2023-02-09T13:06:09.803658  / # export SHELL=3D/bin/sh. /lava-3312679/e=
nvironment
    2023-02-09T13:06:09.804103  =

    2023-02-09T13:06:09.804336  / # <3>[   10.353921] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-02-09T13:06:09.905602  . /lava-3312679/environment/lava-3312679/bi=
n/lava-test-runner /lava-3312679/1
    2023-02-09T13:06:09.906146  =

    2023-02-09T13:06:09.911128  / # /lava-3312679/bin/lava-test-runner /lav=
a-3312679/1 =

    ... (12 line(s) more)  =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx53-qsrb         | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63e4efb5bb10fa13838c8678

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.92-=
120-gc5b70dd8a279/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.92-=
120-gc5b70dd8a279/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4efb5bb10fa13838c8681
        failing since 13 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-09T13:05:33.787165  + set +x
    2023-02-09T13:05:33.787345  [    9.380450] <LAVA_SIGNAL_ENDRUN 0_dmesg =
901870_1.5.2.3.1>
    2023-02-09T13:05:33.893740  / # #
    2023-02-09T13:05:33.995339  export SHELL=3D/bin/sh
    2023-02-09T13:05:33.995769  #
    2023-02-09T13:05:34.096953  / # export SHELL=3D/bin/sh. /lava-901870/en=
vironment
    2023-02-09T13:05:34.097366  =

    2023-02-09T13:05:34.198554  / # . /lava-901870/environment/lava-901870/=
bin/lava-test-runner /lava-901870/1
    2023-02-09T13:05:34.199231  =

    2023-02-09T13:05:34.201260  / # /lava-901870/bin/lava-test-runner /lava=
-901870/1 =

    ... (11 line(s) more)  =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 2          =


  Details:     https://kernelci.org/test/plan/id/63e4f18175fbe6d7858c8646

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.92-=
120-gc5b70dd8a279/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.92-=
120-gc5b70dd8a279/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-=
imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e4f18175fbe6d7858c864d
        new failure (last pass: v5.15.91-20-gcb49f24ce02b)

    2023-02-09T13:13:15.174448  / # #
    2023-02-09T13:13:15.276344  export SHELL=3D/bin/sh
    2023-02-09T13:13:15.276812  #
    2023-02-09T13:13:15.378232  / # export SHELL=3D/bin/sh. /lava-270031/en=
vironment
    2023-02-09T13:13:15.378693  =

    2023-02-09T13:13:15.480190  / # . /lava-270031/environment/lava-270031/=
bin/lava-test-runner /lava-270031/1
    2023-02-09T13:13:15.481016  =

    2023-02-09T13:13:15.486556  / # /lava-270031/bin/lava-test-runner /lava=
-270031/1
    2023-02-09T13:13:15.546430  + export 'TESTRUN_ID=3D1_bootrr'
    2023-02-09T13:13:15.546760  + cd /l<8>[   12.120393] <LAVA_SIGNAL_START=
RUN 1_bootrr 270031_1.5.2.4.5> =

    ... (10 line(s) more)  =


  * baseline.bootrr.dwc3-usb1-probed: https://kernelci.org/test/case/id/63e=
4f18175fbe6d7858c865d
        new failure (last pass: v5.15.91-20-gcb49f24ce02b)

    2023-02-09T13:13:17.894413  /lava-270031/1/../bin/lava-test-case
    2023-02-09T13:13:17.894789  <8>[   14.532873] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwc3-usb1-probed RESULT=3Dfail>
    2023-02-09T13:13:17.895009  /lava-270031/1/../bin/lava-test-case
    2023-02-09T13:13:17.895234  <8>[   14.552411] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy-driver-present RESULT=3Dpass>
    2023-02-09T13:13:17.895472  /lava-270031/1/../bin/lava-test-case
    2023-02-09T13:13:17.895703  <8>[   14.576325] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dimx8mq-usb-phy0-probed RESULT=3Dpass>   =

 =20
