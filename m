Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 863294DB9C3
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 21:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230499AbiCPUva (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 16:51:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358107AbiCPUv2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 16:51:28 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DAEB6E78B
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 13:50:11 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id rm8-20020a17090b3ec800b001c55791fdb1so3639505pjb.1
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 13:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KqKLXXXBrRVGm8bVSzRvAHtZxN3RTZEbsi7LmxC/ljM=;
        b=pL/3K1+Vixpf93mwHRwAVQ+/TMjnvbU1w84pYLEv6Wusc7mRoImp/ZphM4JVv+BLfT
         FskLrxTXdecE9vzxQC89UQqNuv92i2rtlSwOi2vJaGfU0Fj7vwKbjKY7R+J8/tWFSQID
         nzL6BnfjGjZUPXqj0jwFHvBD2QEpNm6LTWZFO99ooNNeisM05x0gYYtKeJdBaWTblKs1
         WC349YotKZgmUMAz6moI23mk0JnFJw1W3MP6Dqi2mMQq4YsEP+38iuQc22CwoYKte6JR
         /aDA07bMI0fLz6dg3W75lySs+khDoLrclGW8TWm8gt7271o53bNMz0/GxGBGAcucz31U
         9wfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KqKLXXXBrRVGm8bVSzRvAHtZxN3RTZEbsi7LmxC/ljM=;
        b=hpZLdC+Ttz3IeGldI3kcTkbkNjnY1Gc+EwdVbTaqWgSB3sUeHaql3XYS1k7+V+Bs4X
         9kg4eQ7WEF5r3NzX/0/5mJ5dUYJcNA7PPUNmnsFKSwHXPc/OuRrwt4vEGFu+ye7idgTn
         suiUHyk4NFV8XXjMcv2fKTeXMkcowjnswa3/+XKrRgOSaHAmWvjA/Aj6Fh5ilwk1g2GX
         yXeGGT+OIdl1eAfiCcIB5pCFcyHO6LaonJOkt1l6uFisUKDTvsCWbOAFasYRCxGMDUJx
         acNqxYDTaOHs9cJhwens+k7pLEdRobPZeM4WzCPMJAbEMqmjo1jBGfuFVRSFTeohGW+m
         /kvg==
X-Gm-Message-State: AOAM533DI7bMU+q0DqpQlghJm6ZWBkLlue3aQwxQrdUCM+GaDiEbGEUO
        sPhbCml2NBwDC+eRHvtVUQ6Y/X4XHpYpuqOS1ao=
X-Google-Smtp-Source: ABdhPJwrDTTr44mq5ejlRfkcqXvnjdT94iGSJJbCjh87dmon1Wj90xEJyz0syNlCsjJiCHF9b5GU6A==
X-Received: by 2002:a17:90b:4a4b:b0:1c6:4398:523c with SMTP id lb11-20020a17090b4a4b00b001c64398523cmr1659138pjb.50.1647463810410;
        Wed, 16 Mar 2022 13:50:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y2-20020a056a001c8200b004fa14536b1fsm3788861pfw.172.2022.03.16.13.50.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 13:50:09 -0700 (PDT)
Message-ID: <62324d81.1c69fb81.a237f.9f20@mx.google.com>
Date:   Wed, 16 Mar 2022 13:50:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.185-43-gd7cd4833efab
Subject: stable-rc/queue/5.4 baseline: 82 runs,
 3 regressions (v5.4.185-43-gd7cd4833efab)
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

stable-rc/queue/5.4 baseline: 82 runs, 3 regressions (v5.4.185-43-gd7cd4833=
efab)

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
el/v5.4.185-43-gd7cd4833efab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.185-43-gd7cd4833efab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7cd4833efab230ae072f8809df8228926e544db =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/623215f910e2335736c629e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gd7cd4833efab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gd7cd4833efab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/623215f910e2335736c62=
9e2
        failing since 90 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6232160f2d66f6cb07c6298e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gd7cd4833efab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gd7cd4833efab/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6232160f2d66f6cb07c62=
98f
        failing since 90 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6232161aa9cd799411c6298f

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gd7cd4833efab/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
3-gd7cd4833efab/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6232161aa9cd799411c629b5
        failing since 10 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-16T16:53:21.317955  <8>[   30.342549] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-16T16:53:22.329148  /lava-5891950/1/../bin/lava-test-case   =

 =20
