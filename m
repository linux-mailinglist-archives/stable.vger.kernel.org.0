Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A3012693B78
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 01:53:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBMAxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Feb 2023 19:53:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbjBMAxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Feb 2023 19:53:16 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0352C5240
        for <stable@vger.kernel.org>; Sun, 12 Feb 2023 16:53:15 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id r8so11954525pls.2
        for <stable@vger.kernel.org>; Sun, 12 Feb 2023 16:53:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+tG3iia5GHBMf7jM5AYdsojyof8QuI9hT6ffWrQU1S8=;
        b=cxgEc8ojTI+DFHSg6Px8BUPz1f/V2BqOaRYoWa5JZDu0kk+Tfketx+mXB2b7mIXTO8
         panrO0IqwLtsYDVYVkcI0OpUbfrLpv+8qyL1pPr6y3QuuXc+n4k7iA9NberDbCsRit0I
         R3llpu2sgaBjbRxqttgkeK6HsszgX78bKzc528kX7SW12c7bwEcZAsVRatVGQ3iWsYQ+
         b+MsB17aCM22OIvla2LJWjlBI3kqv7nz22TcMXB1WF7IxzX/CqJEPkRe6yIpKqYPtbSJ
         OtRIhuv1CXS4XycRGUxAwj9AmTTUFiuDQaiyrsx8jUu6lV+P4t+5HGq+UYnhZTP5kvIN
         w+jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+tG3iia5GHBMf7jM5AYdsojyof8QuI9hT6ffWrQU1S8=;
        b=nyRgyOatSn7co9d+K5XD88AnK9VPH10VpCaljzIyrL1lAqtSRi8/IJ5gETIV/cQhFQ
         WAK5c6INu9cU6VBmr+LstmxqzosERzC5dll9CrWc1TClDQN9t53xWx6Z/k07z5xeq2jK
         WJZw22uGJmvFgf0Hx17/XVZCH2UsKxCPTSx77rxxMQFvwlSMulg1mpiQP8/nJOfFDTm+
         BWEa87QenoyUTDskOtFiCB3FY9xbrltLKTUOo4F/O/JErWARraK1OhOhuqj5Xb/ktXgR
         nLMyf7uFQRfke+WHyujs+SI8nYz033WqTLNOq+BsKG4Y5lpnzO2wAgtYdthymNPuN2o6
         yT3w==
X-Gm-Message-State: AO0yUKU9JGmr0wy5eVs7Lx3+D4yHYA2mm6TtxBg+whdHXFo0aoOT3wLJ
        CMwKwygKGNTYkqsYdvinhPd7o0cZm+xes6pZex8=
X-Google-Smtp-Source: AK7set+JGfTR8pxaxnGl44HttNgkI58EhW2jHNZ9VmRf2FfI465u6/V03tFxZegxtSqi5tQixQgC2Q==
X-Received: by 2002:a17:90a:43:b0:233:b20f:e646 with SMTP id 3-20020a17090a004300b00233b20fe646mr9542640pjb.0.1676249594220;
        Sun, 12 Feb 2023 16:53:14 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c4-20020a633504000000b004facdf070d6sm6178372pga.39.2023.02.12.16.53.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Feb 2023 16:53:13 -0800 (PST)
Message-ID: <63e989f9.630a0220.c2b9c.a4f2@mx.google.com>
Date:   Sun, 12 Feb 2023 16:53:13 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.93-43-g62691dabb900
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 178 runs,
 3 regressions (v5.15.93-43-g62691dabb900)
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

stable-rc/queue/5.15 baseline: 178 runs, 3 regressions (v5.15.93-43-g62691d=
abb900)

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
  | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.93-43-g62691dabb900/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.93-43-g62691dabb900
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      62691dabb9007addf772fef814224739768c538d =



Test Regressions
---------------- =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
cubietruck         | arm   | lab-baylibre    | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63e955f0b43bd2e1d48c864e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
43-g62691dabb900/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
43-g62691dabb900/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubiet=
ruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e955f0b43bd2e1d48c8657
        failing since 26 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-02-12T21:11:00.614492  <8>[   10.006297] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3329191_1.5.2.4.1>
    2023-02-12T21:11:00.720994  / # #
    2023-02-12T21:11:00.825750  export SHELL=3D/bin/sh
    2023-02-12T21:11:00.826251  #
    2023-02-12T21:11:00.927501  / # export SHELL=3D/bin/sh. /lava-3329191/e=
nvironment
    2023-02-12T21:11:00.927981  =

    2023-02-12T21:11:01.029234  / # . /lava-3329191/environment/lava-332919=
1/bin/lava-test-runner /lava-3329191/1
    2023-02-12T21:11:01.029744  =

    2023-02-12T21:11:01.029892  / # <3>[   10.353670] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-02-12T21:11:01.033737  /lava-3329191/bin/lava-test-runner /lava-33=
29191/1 =

    ... (12 line(s) more)  =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
imx53-qsrb         | arm   | lab-pengutronix | gcc-10   | multi_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9561c497a677c3f8c8663

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
43-g62691dabb900/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
43-g62691dabb900/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-imx=
53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/63e9561c497a677c3f8c866c
        failing since 16 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-02-12T21:11:50.013300  + set +x
    2023-02-12T21:11:50.013488  [    9.378058] <LAVA_SIGNAL_ENDRUN 0_dmesg =
904379_1.5.2.3.1>
    2023-02-12T21:11:50.121240  / # #
    2023-02-12T21:11:50.223052  export SHELL=3D/bin/sh
    2023-02-12T21:11:50.223715  #
    2023-02-12T21:11:50.325215  / # export SHELL=3D/bin/sh. /lava-904379/en=
vironment
    2023-02-12T21:11:50.325822  =

    2023-02-12T21:11:50.427172  / # . /lava-904379/environment/lava-904379/=
bin/lava-test-runner /lava-904379/1
    2023-02-12T21:11:50.427954  =

    2023-02-12T21:11:50.430320  / # /lava-904379/bin/lava-test-runner /lava=
-904379/1 =

    ... (12 line(s) more)  =

 =



platform           | arch  | lab             | compiler | defconfig        =
  | regressions
-------------------+-------+-----------------+----------+------------------=
--+------------
kontron-pitx-imx8m | arm64 | lab-kontron     | gcc-10   | defconfig        =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/63e9571e338716326c8c8657

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
43-g62691dabb900/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.93-=
43-g62691dabb900/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-i=
mx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230203.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63e9571e338716326c8c8=
658
        new failure (last pass: v5.15.93-14-g45de3a37c445) =

 =20
