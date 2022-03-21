Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9174E347F
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232960AbiCUXgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233178AbiCUXgF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:36:05 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C57105A94
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:34:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id i184so570741pgc.1
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 16:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LnSUcK2P+fAHkOHFCZu+nIl0FmBe5oOfMUv7VXPAS+E=;
        b=BsHqfizkR0sf4V6oowbvjxRqUQfzaf1qdg1Rb9rFLhhnC1ulrPWPzvx/iSWOYmT80k
         FnRgiaJ43zxTXZMcL5oeSr3XKGBET94nQPWujNjQhSVotRsClg60fwHM68Iyowql0TLJ
         1JchEeVnmSfXzQITSNR6MhtozyI8nYm4LJgHNH4El78ia0Vc0FwQJFbkhMaOZHAM+2xq
         P7oOysPvK7Ne3LD/D/o/XGaPgA6GhaXPh4uzb4lO4GJsxsvym8KeebA1uygua+Iv60wH
         qpPAJCl9y8ojJmCSsNEkgvqVeW16sWYjR+oOoVei2RXVnYy0lpaVR9RtkRvPRyjyKY6Z
         4DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LnSUcK2P+fAHkOHFCZu+nIl0FmBe5oOfMUv7VXPAS+E=;
        b=F5WZwUu0ETgxur7bDAi7+b/Dso2C+8Ro1UsqsgSa4vRwXMSMloLiw/pIrRRJSn75KU
         leC0jHpQusbdNj0j6AW3orWI9UYc3/drZunWU+8KraDcOaptqeEf+mz7VLh7OR6ipNTe
         IaTb/sP/1HNRv5NI+Ye1L70tSlMld3k1uhoCfjGou6nlQAD2ZsDNk7+5h4RB/czhwRiP
         XYXtYXRI9mGjvD/MAKOSt6stFj7nhi+n/avFL3eBjgx7Qk3SvLg5WSPxxVDAQY5j73DU
         7ZS94Dh5HQ9LKCZnM9DLWr8r80tbDHWaChojFi+U9WkbXtABKtZEZlEFGtIFREEMDu8K
         eV7g==
X-Gm-Message-State: AOAM532d8+bIfYb1l6i02nT6Rh6f2rDJY4WuS7tTNCh0apJyOykamJR1
        rRmqNjynBfGcHhP+0PiKEcF/1B2g9arNGbO9TOA=
X-Google-Smtp-Source: ABdhPJw8M9m7GtxBUdP6BDatAHi2IiUOMvUdXCC+VhFwnAXxA6Skjn9pzDgldiVHXNl2M165TTKq6Q==
X-Received: by 2002:a63:1758:0:b0:381:effc:b48f with SMTP id 24-20020a631758000000b00381effcb48fmr20144082pgx.124.1647905670482;
        Mon, 21 Mar 2022 16:34:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d14-20020a056a0024ce00b004f7281cda21sm21488428pfv.167.2022.03.21.16.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:34:30 -0700 (PDT)
Message-ID: <62390b86.1c69fb81.bf8cf.a35c@mx.google.com>
Date:   Mon, 21 Mar 2022 16:34:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.186-17-gd4a67f4e2cf9
Subject: stable-rc/queue/5.4 baseline: 88 runs,
 3 regressions (v5.4.186-17-gd4a67f4e2cf9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 88 runs, 3 regressions (v5.4.186-17-gd4a67f4e=
2cf9)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.186-17-gd4a67f4e2cf9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.186-17-gd4a67f4e2cf9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d4a67f4e2cf9b9424cf0075242f7c19a475a3844 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6238dba9be68ccb1892172c3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd4a67f4e2cf9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd4a67f4e2cf9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238dba9be68ccb189217=
2c4
        failing since 95 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6238dbe61ebed375702172fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd4a67f4e2cf9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd4a67f4e2cf9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238dbe61ebed37570217=
2ff
        failing since 95 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238de0bf382c6159b2172ce

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd4a67f4e2cf9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.186-1=
7-gd4a67f4e2cf9/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238de0bf382c6159b2172f0
        failing since 15 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-21T20:20:13.184472  /lava-5916434/1/../bin/lava-test-case
    2022-03-21T20:20:13.193040  <8>[   31.366094] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
