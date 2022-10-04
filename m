Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10B405F4A79
	for <lists+stable@lfdr.de>; Tue,  4 Oct 2022 22:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiJDUts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Oct 2022 16:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJDUts (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Oct 2022 16:49:48 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0637E0B4
        for <stable@vger.kernel.org>; Tue,  4 Oct 2022 13:49:45 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id q9so13650853pgq.8
        for <stable@vger.kernel.org>; Tue, 04 Oct 2022 13:49:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=5Jx6xKc27QZOfCw5NNBze/Gx5ovAU/hbyTFvjrevbyg=;
        b=LWSL1EWG0Alq7NsIfsmsRllmeNvr2GJJEuBcHioZAIwDAv0Zqpcf6mZZWykt3GxB5D
         RJdMGR14NuNW9NF7Ulq509gMHAs2UgriGCdUToiDMqNJUvL5RrVOcdrHAxcW23tjDoRA
         VTVrOTvG8Ddr7Hk5LyjS5TyWgeCZTCI+XLT2jwz2spR+eFd4C9y5GNHOvgLka5FCJn8L
         emEJXxtwJhlH4esCkia0OvLfKyGUUCWbJkQMgYp4n1q82pnIJEh1BXxk71AavuHtiu0w
         7ub8ktHjXp2MxbesyW/YZK68pxiet0fgx3VxdrxKx4+k7mBFx8ROnA7fAL+24LIlncOp
         yBHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=5Jx6xKc27QZOfCw5NNBze/Gx5ovAU/hbyTFvjrevbyg=;
        b=OlUZ/NRE3RCqJsNukSdPoYwgd0h0SKlj71asDiOhK3bhev90wbostS7vcreI4pwrAI
         uR5wW7dxsXvuxjBlkibRghPItN9mlzAgTG5cXx4bjfLz/BB6UIHeuJZk2f1zTsEM9MuT
         YEUCYGdqdejRgr0fiqIHPqkykfvPG2vGw5FbUOa0huUk/WolXuJAZMtjg06X9kbO/z0y
         ZWAicWb/XvsyztRk8gBOsbiHKap0ABfLdWxdohw52MYqbNNDCW/qP7lWOwB6cQ4cl9dP
         ZScRHS3OvxSjrnaExVoAaZN6OZLkODUpfjN01L1Q6tgZzeIMEC+UjA18OSMOPFW1vV/r
         bzWA==
X-Gm-Message-State: ACrzQf14L9uj+sDU37dH/KF0+iDovQ2RDU4AOi/VcshnJPgdyPRDcJ3D
        seWA2YcINL68FgWdQug+AKR2sMz3u/LhGgyszM8=
X-Google-Smtp-Source: AMsMyM7Ge4BpBOD4R8P0HTfl6HRACGBZyspRMkmVQ3kRSp2iDcQrEF2oYK6XqzJVnEkVOlPQ9Jo24w==
X-Received: by 2002:aa7:86da:0:b0:562:1cb:6bed with SMTP id h26-20020aa786da000000b0056201cb6bedmr1193116pfo.60.1664916585303;
        Tue, 04 Oct 2022 13:49:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z15-20020a17090a608f00b002036006d65bsm8460909pji.39.2022.10.04.13.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 13:49:45 -0700 (PDT)
Message-ID: <633c9c69.170a0220.9bde6.e743@mx.google.com>
Date:   Tue, 04 Oct 2022 13:49:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.19.13
X-Kernelci-Report-Type: test
Subject: stable/linux-5.19.y baseline: 113 runs, 6 regressions (v5.19.13)
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

stable/linux-5.19.y baseline: 113 runs, 6 regressions (v5.19.13)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.19.y/kernel=
/v5.19.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.19.y
  Describe: v5.19.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      1bae99844613c7d26cd36dd58b2f071a6f43b3c5 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633c6810f31ed55807cab5f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/r=
iscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/r=
iscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c6810f31ed55807cab=
5f4
        new failure (last pass: v5.19.12) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633c8854961f9f1d71cab609

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c8854961f9f1d71cab=
60a
        failing since 6 days (last pass: v5.19.10, first fail: v5.19.12) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633c89d0271956829ecab63b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c89d0271956829ecab=
63c
        new failure (last pass: v5.19.10) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8173-elm-hana              | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633c703ec5ff061cdbcab5fe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-ha=
na.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-mt8173-elm-ha=
na.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c703ec5ff061cdbcab=
5ff
        new failure (last pass: v5.19.12) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/633c6a65c2afa7f76bcab600

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/m=
ips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/m=
ips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/633c6a65c2afa7f=
76bcab608
        new failure (last pass: v5.19.9)
        1 lines

    2022-10-04T17:16:07.273277  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 00007e54, epc =3D=3D 80200cc0, ra =3D=
=3D 8023ee18
    2022-10-04T17:16:07.289983  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633c68fd8611aa272fcab615

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.19.y/v5.19.13/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-sc7180-trogdo=
r-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633c68fd8611aa272fcab=
616
        failing since 14 days (last pass: v5.19.9, first fail: v5.19.10) =

 =20
