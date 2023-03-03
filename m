Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A14F26A9FF1
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 20:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231583AbjCCTMm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 14:12:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjCCTMl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 14:12:41 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A78F311D5
        for <stable@vger.kernel.org>; Fri,  3 Mar 2023 11:12:40 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id me6-20020a17090b17c600b0023816b0c7ceso7177076pjb.2
        for <stable@vger.kernel.org>; Fri, 03 Mar 2023 11:12:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677870760;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=or7tl9A0gqSfk+IS2sr0YXTtZsuVS58/rXOQiw8IaiQ=;
        b=1tfC9k/BxKfNV/udqRM/jGXxHONuH1v4pWZGtMp2p0ZO0vvnslmDFM6oZoopXYEvhH
         11cmDyiHPF9PiVh1ZyD8DhiV3eMu2luagHfL981w+jJgd28dt4VzV+A9Hijtidt0DbAN
         Kiy1huFa6sanLFsJv1OYuXWb3X39qqDCrP/GLWE8Ho+38WlC2/TIcSd//eu6WK50p+xm
         OWCXL9TUtDzZjQLzreOHPfQvWW2o+cYfVU9KZPsxLF83i0CLTSB6P0BNgE+xNdDGj2wu
         +/0eLF1ZgEbL8feYl8d2TpXr/fcCc92NiYwykkWzP+6cR9A/ZgjJr0AA1/9XVDpECWCx
         gojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677870760;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=or7tl9A0gqSfk+IS2sr0YXTtZsuVS58/rXOQiw8IaiQ=;
        b=OuMEGXTEXdVvw3J2/Od80N4G5F9iyz50Xr2NKZn3Awgl/gJGeXemeBkZhB0nFf1XpR
         3B+m1SAOoMBq/Ba9qbJWg9aOuSC89+qRyInn2kv1AFDpbEjOYWw6J6x62XVt/i6aXELd
         IiU/i38JSG6lhfckf9zA2Jx3tIRWLvowfdSZn1j0m60+izyCLT3oXGSH+YK4I348zYU4
         mW1zgWYDIKijdTX497jBEBMQVnZgVrZ1sGc5AvO+vy1ZZWwltU2p4PY28pBzA0+nfh43
         8pER58h2aGPA9P0gN46ODr4Nh+riKk9LgAvkLx4J9+qLOp6zMvWRhdEovzKyNcj4ohZS
         j1pA==
X-Gm-Message-State: AO0yUKUwHb1opdQ8TFb5zKrMTcryiJAb9/YjTe0wVaD7ypa0x8psRHnq
        j83yMlVyPpTy/RueLLai4iZsMPbDgXblTwx7Kg8=
X-Google-Smtp-Source: AK7set/YDb2n/Pdd+l724Pnoyr+FVMKKnpgR7EZQiDVpUpK5OIkDODZ1Fz/NuSBOvRQGyZhrafGgfA==
X-Received: by 2002:a05:6a21:6d81:b0:cb:cd6a:2e42 with SMTP id wl1-20020a056a216d8100b000cbcd6a2e42mr3842406pzb.29.1677870759731;
        Fri, 03 Mar 2023 11:12:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x26-20020aa784da000000b005d92c9afbd4sm1983750pfn.33.2023.03.03.11.12.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 11:12:39 -0800 (PST)
Message-ID: <640246a7.a70a0220.8a885.4153@mx.google.com>
Date:   Fri, 03 Mar 2023 11:12:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.14-42-g790ffce341d3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 188 runs,
 3 regressions (v6.1.14-42-g790ffce341d3)
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

stable-rc/queue/6.1 baseline: 188 runs, 3 regressions (v6.1.14-42-g790ffce3=
41d3)

Regressions Summary
-------------------

platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2835-rpi-b-rev2 | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig |=
 1          =

meson-g12a-sei510  | arm64 | lab-baylibre  | gcc-10   | defconfig         |=
 1          =

qemu_mips-malta    | mips  | lab-collabora | gcc-10   | malta_defconfig   |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.14-42-g790ffce341d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.14-42-g790ffce341d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      790ffce341d324da7b8dbe0b70191e5215d64761 =



Test Regressions
---------------- =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
bcm2835-rpi-b-rev2 | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6402153f8006d843248c8634

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-42=
-g790ffce341d3/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-42=
-g790ffce341d3/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rp=
i-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402153f8006d843248c863d
        failing since 6 days (last pass: v6.1.13-47-ge942f47f1a6d, first fa=
il: v6.1.13-47-g106bc513b009)

    2023-03-03T15:41:45.695962  + set +x
    2023-03-03T15:41:45.700897  <8>[   16.893516] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 91996_1.5.2.4.1>
    2023-03-03T15:41:45.813343  / # #
    2023-03-03T15:41:45.915465  export SHELL=3D/bin/sh
    2023-03-03T15:41:45.916099  #
    2023-03-03T15:41:46.017679  / # export SHELL=3D/bin/sh. /lava-91996/env=
ironment
    2023-03-03T15:41:46.018216  =

    2023-03-03T15:41:46.119743  / # . /lava-91996/environment/lava-91996/bi=
n/lava-test-runner /lava-91996/1
    2023-03-03T15:41:46.120851  =

    2023-03-03T15:41:46.128128  / # /lava-91996/bin/lava-test-runner /lava-=
91996/1 =

    ... (14 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
meson-g12a-sei510  | arm64 | lab-baylibre  | gcc-10   | defconfig         |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6402158286ab32e56b8c8642

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-42=
-g790ffce341d3/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei5=
10.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-42=
-g790ffce341d3/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12a-sei5=
10.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6402158286ab32e56b8c864b
        new failure (last pass: v6.1.14-25-g50c28d473e45)

    2023-03-03T15:42:36.456144  / # #
    2023-03-03T15:42:36.557947  export SHELL=3D/bin/sh
    2023-03-03T15:42:36.558701  #
    2023-03-03T15:42:36.660596  / # export SHELL=3D/bin/sh. /lava-3382027/e=
nvironment
    2023-03-03T15:42:36.660983  =

    2023-03-03T15:42:36.762357  / # . /lava-3382027/environment/lava-338202=
7/bin/lava-test-runner /lava-3382027/1
    2023-03-03T15:42:36.763123  =

    2023-03-03T15:42:36.763336  / # <3>[   24.809504] brcmfmac: brcmf_sdio_=
htclk: HT Avail timeout (1000000): clkctl 0x50
    2023-03-03T15:42:36.770361  /lava-3382027/bin/lava-test-runner /lava-33=
82027/1
    2023-03-03T15:42:36.849316  + export 'TESTRUN_ID=3D1_bootrr' =

    ... (14 line(s) more)  =

 =



platform           | arch  | lab           | compiler | defconfig         |=
 regressions
-------------------+-------+---------------+----------+-------------------+=
------------
qemu_mips-malta    | mips  | lab-collabora | gcc-10   | malta_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/640212188152f94c3e8c862f

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-42=
-g790ffce341d3/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.14-42=
-g790ffce341d3/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips=
-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/640212188152f94=
c3e8c8633
        new failure (last pass: v6.1.14-25-g50c28d473e45)
        1 lines

    2023-03-03T15:28:19.415434  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 24679f58, epc =3D=3D 802018e4, ra =3D=
=3D 80204234
    2023-03-03T15:28:19.415572  =


    2023-03-03T15:28:19.438632  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-03T15:28:19.438748  =

   =

 =20
