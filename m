Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED94E326C
	for <lists+stable@lfdr.de>; Mon, 21 Mar 2022 22:47:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbiCUVsM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 17:48:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiCUVsK (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 17:48:10 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1FF268319
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:43:23 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id l4-20020a17090a49c400b001c6840df4a3so516040pjm.0
        for <stable@vger.kernel.org>; Mon, 21 Mar 2022 14:43:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0rWEHeHeelD/axbvUrZdYNrgEd8pHUvnSftd5WJY660=;
        b=35/wzM/hvjeVGBL0E8cRMVjWmTRq/diQ6UrvyyBePp6R8Aa8XydtQO5puR9f99+i4U
         C8oKMn5QORccupLQJbZPQhQ+n+vWTJ0hSuDZx5ZOx2iD1Lyqky2t48UcBJ3Ki+D3hwnK
         bAP1vhV1s9w7z0tvSAVrP6P6UWuS/XWrB79bgPgTBatJG0EsOV3CiPqai7GTLv5lpjmM
         FMwIph+rgbbPv6674MjZ/yx5ER12yBBEIbJNUMo8jbaBQcF/V7NNUebcTwh38eDlynqI
         O5PC1LH6/TRBO/gyt8+Q/YAQtv2zRRSLKWmefF9ZMFXzjUoblf16Ae8KD5x3dDLXEx8e
         8iMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0rWEHeHeelD/axbvUrZdYNrgEd8pHUvnSftd5WJY660=;
        b=Z3GmHdoMWicajxhqvWYSXDBXLYKIW8Jb19Jg2fYyW27ChXzqGq/8zeE433vO0poYC9
         Gn+akSUP9bOowNjjE1SUgVzVvCfMW+j2ZoWxUgAEg12Md/yPI4gFKFgR9iYM/iIwohfm
         PTgWajx8VhDUL9iAQv1Qi7XyPSY5I77OgSeY6TzV/UZLv8O9ujROxArwpu0TqhCZ5zmS
         tiVT5uajrLclnLXWfRuKvohSXgUiEMrm+o0RBNLMCaW5NoHxl4uroEsRbrmztnIUkH0x
         NGWXS93iJx91oDzlxNu5hGJEBri5MngLPGs5s9jsHL/sG37i2FN6TVDRN8QaKZhhMEXQ
         BdaA==
X-Gm-Message-State: AOAM533PkVU8BcBAaAYhCSrs2AKWZlES51bhiG2q+AQnjJsjaaFMpIlI
        1dpjP2pfUzhN63mZlzdg20x73GyHhm3US3ftCNY=
X-Google-Smtp-Source: ABdhPJzVfGxBmUCvlEqm8GFIjw/7H7MFLfJh53v6dBBHjYSqfQw+AQMIlitpX90jGi3xePoyvbAmpw==
X-Received: by 2002:a17:90a:5b06:b0:1b8:b705:470b with SMTP id o6-20020a17090a5b0600b001b8b705470bmr1242458pji.168.1647898980867;
        Mon, 21 Mar 2022 14:43:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w9-20020aa78589000000b004f78b5a4499sm18936601pfn.206.2022.03.21.14.43.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 14:43:00 -0700 (PDT)
Message-ID: <6238f164.1c69fb81.a7664.5473@mx.google.com>
Date:   Mon, 21 Mar 2022 14:43:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.186
Subject: stable/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.186)
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

stable/linux-5.4.y baseline: 90 runs, 3 regressions (v5.4.186)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.186/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.186
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8e24ff11b5d216dc5de667bebeb7b0ef3946c596 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b57d93cb76bd142172b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.186/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.186/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238b57d93cb76bd14217=
2ba
        failing since 94 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6238b569ac39c38967217314

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.186/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.186/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6238b569ac39c38967217=
315
        failing since 94 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6238c04db0cf626b2d2172bd

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.186/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.186/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6238c04db0cf626b2d2172df
        failing since 12 days (last pass: v5.4.181, first fail: v5.4.183)

    2022-03-21T18:13:09.599260  /lava-5915637/1/../bin/lava-test-case
    2022-03-21T18:13:09.607222  <8>[   32.723707] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
