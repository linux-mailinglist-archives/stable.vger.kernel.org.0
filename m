Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71AAF6B9780
	for <lists+stable@lfdr.de>; Tue, 14 Mar 2023 15:15:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbjCNOPp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Mar 2023 10:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCNOPo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Mar 2023 10:15:44 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 203C56B94A
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 07:15:43 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id z10so8975322pgr.8
        for <stable@vger.kernel.org>; Tue, 14 Mar 2023 07:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1678803342;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=PuHnziVhRPOPH5WlmSipMhtkgZlBflmWEtq3uN2xfW4=;
        b=LpeMadavVjNJyNJo7s+5k7EgiHVK/22lwzAkxBUYddwy5AddTBN2jL6nQdKi4pZY6K
         xdY5KU2DQvVuhTKsD6a7inGtmpRoy4smwf9qbisT5Sdze0sXy8poxZNJDy6BXR+uxAfv
         +BjJaolPaW/Hatsm3aFFPgh9sKxkILVosx0eS5Oc3KWVbt6uFoCoINVeG9UZxLBxentg
         xokwt+besj/ACTjbUFKtYQNf8L/YNCYA8+xA0o3aubUMXGgLUrsFcA2d+bQAkEyKl3Qi
         i280+0/YONVH0HODe6HYTCMrQqVT0/X3kHZc3WvuBfBMi/QweJKJfn9tn5cxUMgu3daC
         ohnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678803342;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PuHnziVhRPOPH5WlmSipMhtkgZlBflmWEtq3uN2xfW4=;
        b=TqeK2mbolVfKAdnZDE0V/zTU9PlGYscSOnrsjXZ1lIFcYwRqyuaeBf865u0xWygn7/
         18yhaskQ3f6lIPRoX82xaK14DMkigHBvEY/58beOq5gkRuT09J0/ColFfunqfkfPnJJr
         9FDMtJ1Imd4W4XXfsgCCHJ0eK9cmWPkv96dS5T/IsAMh3oOqXBtAYs/V20/zAytidMZl
         N3uTOIH6MZrKwpZbvV3D+6N1apaiWCQOC8E1vZk1Bqdfq4tOiqESY1+kphbgq2izzGBY
         RIboLSHOvxoDu9Xma1tGzrm1t4OZrctgYkjZq6RplT+20g80J6M+AKqOjVltCUdGUR7N
         k5Lg==
X-Gm-Message-State: AO0yUKUWBQ4UqxAdm8bY34O2GEhOk8wpzSKFkp63yiMbdDQzPr8mPxmJ
        by5FN9cbzRKrLgvHlfBIiYgkSgqM/3VNUHGX5q5XMQ==
X-Google-Smtp-Source: AK7set8g7cjQZvumQ2aWTIYMWwWb2LToiTW0YnPi36+jaQ5pc1fBOPqsVNhgjUPrL2s0MmRnjyH+mw==
X-Received: by 2002:aa7:9615:0:b0:625:4189:fcce with SMTP id q21-20020aa79615000000b006254189fccemr3958760pfg.23.1678803342299;
        Tue, 14 Mar 2023 07:15:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j13-20020aa783cd000000b005d3730383a7sm1628016pfn.220.2023.03.14.07.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Mar 2023 07:15:42 -0700 (PDT)
Message-ID: <6410818e.a70a0220.373e7.32a0@mx.google.com>
Date:   Tue, 14 Mar 2023 07:15:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.18-126-gfa938b62a47c
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 171 runs,
 3 regressions (v6.1.18-126-gfa938b62a47c)
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

stable-rc/queue/6.1 baseline: 171 runs, 3 regressions (v6.1.18-126-gfa938b6=
2a47c)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig=
 | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
 | 1          =

qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig  =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.18-126-gfa938b62a47c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.18-126-gfa938b62a47c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fa938b62a47c575ca068283287521b435bdb5d85 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie   | gcc-10   | bcm2835_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/64104b3b70c50fb2998c8642

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
6-gfa938b62a47c/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
6-gfa938b62a47c/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64104b3b70c50fb2998c8678
        failing since 0 day (last pass: v6.1.17-200-g45d6ef55e66a7, first f=
ail: v6.1.18-120-g5af7213bd7fea)

    2023-03-14T10:23:31.878945  + set +x
    2023-03-14T10:23:31.882764  <8>[   16.443410] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 159629_1.5.2.4.1>
    2023-03-14T10:23:31.999439  / # #
    2023-03-14T10:23:32.102159  export SHELL=3D/bin/sh
    2023-03-14T10:23:32.102784  #
    2023-03-14T10:23:32.204886  / # export SHELL=3D/bin/sh. /lava-159629/en=
vironment
    2023-03-14T10:23:32.205624  =

    2023-03-14T10:23:32.308000  / # . /lava-159629/environment/lava-159629/=
bin/lava-test-runner /lava-159629/1
    2023-03-14T10:23:32.309269  =

    2023-03-14T10:23:32.315677  / # /lava-159629/bin/lava-test-runner /lava=
-159629/1 =

    ... (14 line(s) more)  =

 =



platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/64104c3b38ece732c58c8645

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
6-gfa938b62a47c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
6-gfa938b62a47c/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64104c3b38ece732c58c8=
646
        new failure (last pass: v6.1.17-200-g45d6ef55e66a7) =

 =



platform             | arch  | lab           | compiler | defconfig        =
 | regressions
---------------------+-------+---------------+----------+------------------=
-+------------
qemu_mips-malta      | mips  | lab-collabora | gcc-10   | malta_defconfig  =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/641049fdb9a6166a198c8672

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
6-gfa938b62a47c/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.18-12=
6-gfa938b62a47c/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/641049fdb9a6166=
a198c8676
        new failure (last pass: v6.1.17-200-g45d6ef55e66a7)
        1 lines

    2023-03-14T10:18:30.795078  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 35b9f21c, epc =3D=3D 80201dc4, ra =3D=
=3D 80204714
    2023-03-14T10:18:30.795225  =


    2023-03-14T10:18:30.819394  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-03-14T10:18:30.819507  =

   =

 =20
