Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80BF84D0AE9
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 23:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237595AbiCGWTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 17:19:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiCGWTs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 17:19:48 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F085347573
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 14:18:53 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id p17so15290600plo.9
        for <stable@vger.kernel.org>; Mon, 07 Mar 2022 14:18:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=jSHkLpP7+0OVCixSPo+JrsYUKBVz3XuxqcTk+JEgUdI=;
        b=H4tvQTRHbpVX6lJ1oaUXUALVlirX53wCe2yZr/jmWvu7rxQA8JSYMqu68DaHam1hxJ
         /Mk1BTlcpwmJi+vGsicXF71ejPydFFwbrzLifBt5i5g2rlDctUzNyRhQsQQLlrNuCWfk
         19jf35BjWPqg716TAVmzIVMpo5Ug3Rdz/Al4cvhAttxKZ76lBCWKNpHK6BSC96I2NN62
         qmAuBz2qO9zF93eC667G9MVfQc9AQ6guK6p0hUTzIRP4FyEm0tYETFschxIDQdLPLjjg
         25G8o+FqGj1NHi2m1zREQQHY+8tw+jZzfv6RRbgJq4UtUK1aFOz81WiNQL4n590ShJ7i
         R5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=jSHkLpP7+0OVCixSPo+JrsYUKBVz3XuxqcTk+JEgUdI=;
        b=BZxgXhkbkCN10PTiYHzDzi0+IPnUfkafYsWL20TgUox6hdjw5ELsCsDPA+n3i6p5gZ
         hkdK5E9BI6s+rFMJRkkyVlAxpinmjuClPKeZhk7EsVdv8SMgP1O8W6FV+MmURfyh7we+
         9dYf7uqrrEBEnx5NZeS6IKTQ2OueGIPUVt3SgjzgMGAlJjk0Q9OCkeLLwU+6gK/ynjmj
         mMZLDUJJRk1roKsLNCYWdxVZFiCCy7A2Ni7IcJMC4LOdwgdXiU8zv87Zn/hQiw0SBMsB
         Kx1u/TyZIvU0clr8yLAEBKjZnhi0TvZSoIQjUX/Nh5LihQGhlS+NJYIzrHMTd6h+EqdD
         DvrA==
X-Gm-Message-State: AOAM5331JTDnBlNCuQdKo+JAaJ7LMk3WwT2BJZ4zhEA1n+I077/EKW9S
        S0m4zXaTtjrIDXd7MJXVQjpzJOCZ/ASUlHD87T0=
X-Google-Smtp-Source: ABdhPJxSSDG8JUzhqQMB+OOvqhCQltwzKZn9GMpOMj78Z4Yf4GejZTMwQqXPBw3mD3OcMXYjQnl0Ig==
X-Received: by 2002:a17:90a:ab08:b0:1bc:3ece:bdc with SMTP id m8-20020a17090aab0800b001bc3ece0bdcmr1271053pjq.32.1646691533264;
        Mon, 07 Mar 2022 14:18:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ot13-20020a17090b3b4d00b001bf0b8a1ee7sm337805pjb.11.2022.03.07.14.18.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 14:18:53 -0800 (PST)
Message-ID: <622684cd.1c69fb81.24559.150b@mx.google.com>
Date:   Mon, 07 Mar 2022 14:18:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.182-66-g5adb518895b3
Subject: stable-rc/linux-5.4.y baseline: 115 runs,
 3 regressions (v5.4.182-66-g5adb518895b3)
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

stable-rc/linux-5.4.y baseline: 115 runs, 3 regressions (v5.4.182-66-g5adb5=
18895b3)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.182-66-g5adb518895b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.182-66-g5adb518895b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5adb518895b328593a1c9d96828aa6b1a19746e6 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62264f4fdcbfbc5700c6298e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-66-g5adb518895b3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-66-g5adb518895b3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62264f4fdcbfbc5700c62=
98f
        failing since 81 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62264f2524092a1f5ec62972

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-66-g5adb518895b3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-66-g5adb518895b3/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62264f2524092a1f5ec62=
973
        failing since 81 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62264ff57cbd41e9fcc629fa

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-66-g5adb518895b3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.182=
-66-g5adb518895b3/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62264ff57cbd41e9fcc62a20
        failing since 1 day (last pass: v5.4.181-51-gb77a12b8d613, first fa=
il: v5.4.182-54-gf27af6bf3c32)

    2022-03-07T18:33:11.605868  /lava-5830098/1/../bin/lava-test-case
    2022-03-07T18:33:11.614459  <8>[   33.111818] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
