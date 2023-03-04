Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9883D6AAC0A
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 20:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjCDTF0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Mar 2023 14:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjCDTFZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Mar 2023 14:05:25 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1B6C17F
        for <stable@vger.kernel.org>; Sat,  4 Mar 2023 11:05:24 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id u3-20020a17090a450300b00239db6d7d47so5337523pjg.4
        for <stable@vger.kernel.org>; Sat, 04 Mar 2023 11:05:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1677956724;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Xv0nVKlFCwfE9vJgG6b8fIy3tp7aUUgH7xmM7pq9Byk=;
        b=8ATeKkSdaV0MHd5fOP5IfPFzMFP+Tl618zIAbO/Y1Qio8Yv7cU7fwx8NTPj6qYwsuZ
         FPBBWXwhKPv/5tKZL2bSRQRzz+nj4N6phQcq+tf6D7nNSj3Cz3IQwHqwyO/PkKV7sYcD
         carFgr0av+aI5H5m1HO+BHAKbWf+FDDoMqpfEcKvy7843+jjMFk2eKa442k9wel8VUYu
         /gDvG//7AmMUCSnxn7T92bJ2aCbDrr12T1ysbLLdxS72M92aTh6cuzJpeCWf1lFOQK1+
         Vq9fMKpTbShoxv9tWaIjEUkOoc1eWUY5aH3qFnOIppKa4ucRRhU49LJDuPIljingGEb3
         NC/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677956724;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Xv0nVKlFCwfE9vJgG6b8fIy3tp7aUUgH7xmM7pq9Byk=;
        b=m1nWbWoq6Oyf/iLABIh19SW7MVZWdIbU3yjNT7MVtwN8iD5n2elpbGnu/Mum87+FHX
         p1qOKWMQJQNOQsWH9+MEHy7Xa5ErZM0cJzM0qfwD1c8XKXCDihbC6mGypOtzMIABlt1j
         2VmLPfzYA1zq6ZDAGhymHRmtZpHrY9tNHzpMJWTUgd6DX7jnGMmpp1JKkFeM1HSLtM5x
         ocHZt8IAFB9iapZHYhtvrLd7j8szwz0c2eqUiq1bUbtrlJz8vwpuncjo0w4MpQQE1+95
         a90UPr8NZ/Nv9S2BCIxW+hZD6YEqcLslxnVDHLpLWNMH+1a0SdOnfHS3qlcGFIY39Jll
         tErg==
X-Gm-Message-State: AO0yUKUBVVLBdaFnVm2GiLrvVpVLwdxDHG2pZSUKc3MIxf1VK50t3VQZ
        C+MIchekEiyoWDVg94rIHZeV6scF+Tj/dYePs3rSCLUX
X-Google-Smtp-Source: AK7set+mvgh1jfmVXFTsDQlotCubRz8+kQBLJ+OIc8f6hEijg/63dUCjeJmvSyGPr61eh4zLFgVf1A==
X-Received: by 2002:a17:902:c103:b0:19e:7611:7162 with SMTP id 3-20020a170902c10300b0019e76117162mr5433771pli.16.1677956723959;
        Sat, 04 Mar 2023 11:05:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4-20020a170902e80400b0019d397b0f18sm3631048plg.214.2023.03.04.11.05.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 11:05:23 -0800 (PST)
Message-ID: <64039673.170a0220.e054d.6da4@mx.google.com>
Date:   Sat, 04 Mar 2023 11:05:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.15-4-gf9fbed52efb7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 188 runs,
 3 regressions (v6.1.15-4-gf9fbed52efb7)
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

stable-rc/queue/6.1 baseline: 188 runs, 3 regressions (v6.1.15-4-gf9fbed52e=
fb7)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig=
 | 1          =

meson-gxbb-nanopi-k2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
 | 1          =

qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig  =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.15-4-gf9fbed52efb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.15-4-gf9fbed52efb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f9fbed52efb70a01defc6c3edc8e1c98f8888d87 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/640361d0f9f95a0cee8c8677

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-4-=
gf9fbed52efb7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi=
-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-4-=
gf9fbed52efb7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-rpi=
-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/640361d0f9f95a0cee8c8680
        failing since 7 days (last pass: v6.1.13-47-ge942f47f1a6d, first fa=
il: v6.1.13-47-g106bc513b009)

    2023-03-04T15:20:23.447022  + set +x
    2023-03-04T15:20:23.450641  <8>[   17.052141] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 96937_1.5.2.4.1>
    2023-03-04T15:20:23.563593  / # #
    2023-03-04T15:20:23.665992  export SHELL=3D/bin/sh
    2023-03-04T15:20:23.666707  #
    2023-03-04T15:20:23.768785  / # export SHELL=3D/bin/sh. /lava-96937/env=
ironment
    2023-03-04T15:20:23.769426  =

    2023-03-04T15:20:23.871678  / # . /lava-96937/environment/lava-96937/bi=
n/lava-test-runner /lava-96937/1
    2023-03-04T15:20:23.872712  =

    2023-03-04T15:20:23.878979  / # /lava-96937/bin/lava-test-runner /lava-=
96937/1 =

    ... (14 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/64036496175e5e9b338c8644

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-4-=
gf9fbed52efb7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-nanop=
i-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-4-=
gf9fbed52efb7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-nanop=
i-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64036496175e5e9b338c8=
645
        new failure (last pass: v6.1.15-3-gecd1b5690765) =

 =



platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6403618e6a8041909f8c8659

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-4-=
gf9fbed52efb7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-=
malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.15-4-=
gf9fbed52efb7/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-=
malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230224.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6403618f6a80419=
09f8c865d
        failing since 0 day (last pass: v6.1.14-25-g50c28d473e45, first fai=
l: v6.1.14-42-g790ffce341d3)
        1 lines

    2023-03-04T15:19:38.537008  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 24679f58, epc =3D=3D 802018e4, ra =3D=
=3D 80204234
    2023-03-04T15:19:38.537196  =


    2023-03-04T15:19:38.566373  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-04T15:19:38.566541  =

   =

 =20
