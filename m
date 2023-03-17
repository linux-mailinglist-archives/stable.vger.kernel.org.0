Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 974B46BEB4E
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 15:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230109AbjCQObx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 10:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbjCQObw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 10:31:52 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56C5EE2534
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 07:31:51 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lr16-20020a17090b4b9000b0023f187954acso5382198pjb.2
        for <stable@vger.kernel.org>; Fri, 17 Mar 2023 07:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679063510;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=TH1XCCyJy5AeidxhdD7pXKk2WBAbzEYt6SeJnTAZopQ=;
        b=lv3fRhZt4zsaDbjHKvk1dKglHJb4qebCFqA/fknSPVYo2T2hqgvgS4olW/PmUHeAgd
         eehAexHlkCW//qNnE1GbymFzwEsbNy0UwHpMqnrL8t82ik8D6VhRDBH8t/yVYWdXw6Qt
         YTvXE6gg1bM73X5j8popYwEyb3wnQNE+hWjlxr6KCgT1Yo66fCDLKxZ9d/5ZOLZP9PBV
         FSKlr1ONth2pNb2Q7mSwB2hiQn49VGtp4iNDxrxq7OjT3LpnUMhwDJg/MJTT/R6F4bsM
         dAFrPVcNlTH1wi0rxMzjEPuEeDHNrX3QMreNyxCVy8zEvQt4wELInD7zYd7wgBc9CNSn
         a3lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679063510;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TH1XCCyJy5AeidxhdD7pXKk2WBAbzEYt6SeJnTAZopQ=;
        b=cRnHc8M8acfYQMa2z5TZ/sAq+poobYIlC8lcB1NuGAF9QuYx5vrS91b7O6tZrDuuMg
         qZ5OvHE450tYdsdOrcl8s/V0RprqvlXB8JaaYlfTNy58mUDSM1PBbbDXT3M+Pl7RdYrX
         EgOWmdqIOs0e2/FcqKQrZJLx0hBws2Q+TUdwhvsMQe+6BSOk1eDlpMNLDs7TMNP4a8NC
         ScvIevYSJ2KEdupuhtTYKG4serH0KGzb8dthKQAHj81z4SScuRp61jOdUNNCLdePDsEm
         JylbGKRVgWV1TmniwzZCbgHvjntEgA2Dz8qO7trQZ8isOjNvBr9aZBxCdgvMdheA5ZdF
         SDjg==
X-Gm-Message-State: AO0yUKV0koh76KvGAGoVu/U7Pqj4BlVErH1jViHlUEIZvb6DNaTQkrcV
        rx0AXts/H2KRPBnH2qedX8qjd0YDGyjAEBhdWi/zIQ==
X-Google-Smtp-Source: AK7set93LSnmEOJYC3ehzRQq3TC2AS/IoawArA8+ODUSz6dIFua7y/aAqh92iVUDVp6Wh0WtL8CvSQ==
X-Received: by 2002:a17:903:249:b0:1a0:7156:f8d1 with SMTP id j9-20020a170903024900b001a07156f8d1mr9464981plh.19.1679063510064;
        Fri, 17 Mar 2023 07:31:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u8-20020a170902bf4800b0018b025d9a40sm1606282pls.256.2023.03.17.07.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Mar 2023 07:31:49 -0700 (PDT)
Message-ID: <641479d5.170a0220.2bf78.2d85@mx.google.com>
Date:   Fri, 17 Mar 2023 07:31:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.19-139-g6d04fa2f2978
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 172 runs,
 3 regressions (v6.1.19-139-g6d04fa2f2978)
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

stable-rc/queue/6.1 baseline: 172 runs, 3 regressions (v6.1.19-139-g6d04fa2=
f2978)

Regressions Summary
-------------------

platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
bcm2835-rpi-b-rev2 | arm    | lab-broonie   | gcc-10   | bcm2835_defconfig =
           | 1          =

hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =

qemu_mips-malta    | mips   | lab-collabora | gcc-10   | malta_defconfig   =
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.19-139-g6d04fa2f2978/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.19-139-g6d04fa2f2978
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6d04fa2f2978a8570b12a4dffdd179effd688fcc =



Test Regressions
---------------- =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
bcm2835-rpi-b-rev2 | arm    | lab-broonie   | gcc-10   | bcm2835_defconfig =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/64143ff1db623c36968c868b

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.19-13=
9-g6d04fa2f2978/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.19-13=
9-g6d04fa2f2978/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64143ff1db623c36968c86c2
        new failure (last pass: v6.1.18-144-g88546018fee83)

    2023-03-17T10:24:22.004682  + set +x
    2023-03-17T10:24:22.008509  <8>[   17.719206] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 177403_1.5.2.4.1>
    2023-03-17T10:24:22.124546  / # #
    2023-03-17T10:24:22.226906  export SHELL=3D/bin/sh
    2023-03-17T10:24:22.227583  #
    2023-03-17T10:24:22.329202  / # export SHELL=3D/bin/sh. /lava-177403/en=
vironment
    2023-03-17T10:24:22.329899  =

    2023-03-17T10:24:22.431565  / # . /lava-177403/environment/lava-177403/=
bin/lava-test-runner /lava-177403/1
    2023-03-17T10:24:22.432957  =

    2023-03-17T10:24:22.439881  / # /lava-177403/bin/lava-test-runner /lava=
-177403/1 =

    ... (14 line(s) more)  =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
hp-11A-G6-EE-grunt | x86_64 | lab-collabora | gcc-10   | x86_64_defcon...6-=
chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6414421b87b6e08ded8c8644

  Results:     18 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.19-13=
9-g6d04fa2f2978/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-11A-G6-EE-grunt.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.19-13=
9-g6d04fa2f2978/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-11A-G6-EE-grunt.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.tpm-chip-is-online: https://kernelci.org/test/case/id/6=
414421b87b6e08ded8c8657
        new failure (last pass: v6.1.18-144-g88546018fee83)

    2023-03-17T10:33:37.779794  <8>[   10.461330] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dall-cpus-are-online RESULT=3Dpass>

    2023-03-17T10:33:37.782343  /usr/bin/tpm2_getcap

    2023-03-17T10:33:48.006150  /lava-9663995/1/../bin/lava-test-case
   =

 =



platform           | arch   | lab           | compiler | defconfig         =
           | regressions
-------------------+--------+---------------+----------+-------------------=
-----------+------------
qemu_mips-malta    | mips   | lab-collabora | gcc-10   | malta_defconfig   =
           | 1          =


  Details:     https://kernelci.org/test/plan/id/64143fd7db623c36968c8646

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.19-13=
9-g6d04fa2f2978/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.19-13=
9-g6d04fa2f2978/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/64143fd7db623c3=
6968c864a
        failing since 0 day (last pass: v6.1.18-146-ge0f25c5308c10, first f=
ail: v6.1.18-144-g88546018fee83)
        1 lines

    2023-03-17T10:24:16.580763  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address c19c4d68, epc =3D=3D 8023f540, ra =3D=
=3D 8023f524
    2023-03-17T10:24:16.580927  =


    2023-03-17T10:24:16.599466  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-17T10:24:16.599594  =

   =

 =20
