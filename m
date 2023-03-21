Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6D226C39BE
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 20:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbjCUTDo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 15:03:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229906AbjCUTDn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 15:03:43 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4EB8567A3
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:03:10 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id x11so14535768pja.5
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 12:03:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679425388;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PduwPVWdyZI/napry7eyHYUJhWXeeY9oMmKZByY0wRs=;
        b=wZaED0mo2WTlwunLfR7AGEVTsjaQSfi5d8N5u1zA5lFMBsavjRSDVvohwWU+AecWGW
         lhZb90aQzxzlui/4EPNkQUYlR4+JtvSWYvuInR1ACRwARkfai9HaXttpUaLsDth0oqRe
         b3oRUUVxsCHmP7b52HJvzU42Ao41/XHx6yNhQ/VkMbyQE2KLlVjeQ6vULvD8Ks9OsPct
         h/NzsVSMK4jBV7TxMDf8pltrcXWSlCtxNSCHmOR/KyK5ZXXUZthxllOrmNA0WI2ROoJ1
         8TdC+kf5eVgBBr+Xke/6zpK0WnCr49aA/S0pGbn92vnXt+xIKDa5J8a7RLaiY236QI7I
         gcLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679425388;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PduwPVWdyZI/napry7eyHYUJhWXeeY9oMmKZByY0wRs=;
        b=Lnw0S3q5HXifQXJvk02MZV+ExPO+WluCMXs3SZUtRTvY5G295qoEnv9LJsVbuhEluV
         fCxpGVI/fimZXIncyexrqcg6OJN3c/ieLlxHMuhW6Iwewpxtvd6Fbpp0c9IN+PUtiW5t
         VHvtgYattVtDwgTuoHvASiN7DaaGBF6ePA9ucwUN/cl+WbPAuNUdfuitIx5U/+fxHNye
         YRQT2cjo+8hNaY1m6rRr9LkWfD5cKmii1SUSjJHrt1M7Q0b8adcKIOG3Yjcnlytcu8FV
         tb2ictTF9tLExF0UkXLkQfWD1h5fjljkBrDRgk4WzVWJ9nObkdTGoiQnx5UKuTUJM4E8
         O04Q==
X-Gm-Message-State: AO0yUKWqlwNamdodvn24DH7gT3TMH8mD6xLbNwQOGt7UVszCGPfcvxyj
        2VTdVpxEGPZEdi2QTIeMCEYwHK5BCRde5Orx+TdubA==
X-Google-Smtp-Source: AK7set841Z242npZFCMnnIwuEPmdkIDBgzEIKvHKG/59NajO1aDiIWRceMehipI82vVgQBKORqOFIA==
X-Received: by 2002:a17:903:2887:b0:1a1:a830:cef8 with SMTP id ku7-20020a170903288700b001a1a830cef8mr160641plb.27.1679425387743;
        Tue, 21 Mar 2023 12:03:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w4-20020a1709029a8400b0019a773419a6sm9060333plp.170.2023.03.21.12.03.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Mar 2023 12:03:07 -0700 (PDT)
Message-ID: <6419ff6b.170a0220.e33cf.0ed1@mx.google.com>
Date:   Tue, 21 Mar 2023 12:03:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.20-199-gdb4b67830dc1
Subject: stable-rc/linux-6.1.y baseline: 174 runs,
 2 regressions (v6.1.20-199-gdb4b67830dc1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 174 runs, 2 regressions (v6.1.20-199-gdb4b6=
7830dc1)

Regressions Summary
-------------------

platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =

qemu_mips-malta    | mips | lab-collabora | gcc-10   | malta_defconfig   | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.20-199-gdb4b67830dc1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.20-199-gdb4b67830dc1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      db4b67830dc1955a31d569f0da5b2d189fe727be =



Test Regressions
---------------- =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
bcm2835-rpi-b-rev2 | arm  | lab-broonie   | gcc-10   | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6419cd299f1c343a809c95cc

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
199-gdb4b67830dc1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
199-gdb4b67830dc1/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835=
-rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6419cd299f1c343a809c9602
        failing since 0 day (last pass: v6.1.20, first fail: v6.1.20-199-ga=
6e5071b9d96)

    2023-03-21T15:28:21.049560  + set +x
    2023-03-21T15:28:21.053343  <8>[   16.844968] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 200650_1.5.2.4.1>
    2023-03-21T15:28:21.168521  / # #
    2023-03-21T15:28:21.271191  export SHELL=3D/bin/sh
    2023-03-21T15:28:21.271647  #
    2023-03-21T15:28:21.373254  / # export SHELL=3D/bin/sh. /lava-200650/en=
vironment
    2023-03-21T15:28:21.373879  =

    2023-03-21T15:28:21.475649  / # . /lava-200650/environment/lava-200650/=
bin/lava-test-runner /lava-200650/1
    2023-03-21T15:28:21.476533  =

    2023-03-21T15:28:21.483505  / # /lava-200650/bin/lava-test-runner /lava=
-200650/1 =

    ... (14 line(s) more)  =

 =



platform           | arch | lab           | compiler | defconfig         | =
regressions
-------------------+------+---------------+----------+-------------------+-=
-----------
qemu_mips-malta    | mips | lab-collabora | gcc-10   | malta_defconfig   | =
1          =


  Details:     https://kernelci.org/test/plan/id/6419ca2123098a524a9c952b

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
199-gdb4b67830dc1/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.20-=
199-gdb4b67830dc1/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_m=
ips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6419ca2123098a5=
24a9c952f
        new failure (last pass: v6.1.20-199-ga6e5071b9d96)
        1 lines

    2023-03-21T15:15:38.658440  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 351b0bdc, epc =3D=3D 8023f540, ra =3D=
=3D 8023f524
    2023-03-21T15:15:38.658610  =


    2023-03-21T15:15:38.677023  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-21T15:15:38.677169  =

   =

 =20
