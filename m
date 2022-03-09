Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D691E4D271E
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 05:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231191AbiCIBUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 20:20:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231161AbiCIBUb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 20:20:31 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A2621390FA
        for <stable@vger.kernel.org>; Tue,  8 Mar 2022 17:13:47 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id ge19-20020a17090b0e1300b001bcca16e2e7so3758700pjb.3
        for <stable@vger.kernel.org>; Tue, 08 Mar 2022 17:13:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=08Z3zQbiDjWaESe6peB8GVQQ/m0HBRQgNJueVWq27fQ=;
        b=glL1SpmNI6ioO68evIfmKm6DMc5ZXIj9sMzT8V7nxuAjySufRuiH/BTdK4vfmaRl5R
         yotLq7s5QUfGdWEyTq1K/VaIywjGdFLayEYCPOGL546VdMD6gd7dSTS/xBtq1hWNL8GZ
         Ku7AGU8ZaHCc5NLfVMXR96CCRQbo8ZX1gw2hDOh2H2p4IoyL+/cCquFqa8ulEZwtR7Js
         1LmM5XiX/pxRe/gEo2XEMzvRjgritow4+9bhIsmzAK4nFoLzbnN+A88uDkggcSuanlNe
         s2PauzNsUK/5jOz7x9KpUKaYDTyWq2EGM4oJRWKv2/Y0W17pgOg7ImAXTq+D97WcgJpz
         nc+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=08Z3zQbiDjWaESe6peB8GVQQ/m0HBRQgNJueVWq27fQ=;
        b=J6jlqWieTJJv4cLA3OWZdZB816VqVigb6NV4RewXPaMNTtQhiP8OC7pY/3J0FA8m6v
         /NKLMP+ERiWmNB6hdJNhdVojJeaMJWhV67Q8a4eHIZ+FFIQ2u6sOCucNjfirgIburUhf
         tRb3wcJsvCPsnhkv3KkPemhzLrHFfeR0qx0d+4N1G1hQLk90z7Ruy7iZkNHRc3Gy8v+m
         zi0LB+G3v6yp+1W+KAb7nCFYUBM2CUlnR1L+Bph2w9Lh8/CurPNDuEEF4gnflbHBpR9d
         R/tZrhwTAaOgZLazbnWzSWi1QsvZSAsDu/qxqFuDePpluK5pBm6ce0aaa6gafca9pFhh
         ZDTw==
X-Gm-Message-State: AOAM530Vp1B6jNoBm+5c0gxwmeD/PvoNaXBqOGPGNNnMsSZ5WawSNl6h
        23F2iCWy/LB4/NB/oSxNGLh6BLSYQswnEVbhOEw=
X-Google-Smtp-Source: ABdhPJzW+CULNaXjo0fQTzM+Aug32rJN+ShwzH8sSYQ8v8ztRHuGgzTUzY5X928YqkUm7Av4NqnyuA==
X-Received: by 2002:a17:902:b94c:b0:151:cd93:ec85 with SMTP id h12-20020a170902b94c00b00151cd93ec85mr20332986pls.76.1646788337726;
        Tue, 08 Mar 2022 17:12:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z18-20020aa78892000000b004e19bd62d8bsm333860pfe.23.2022.03.08.17.12.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 17:12:17 -0800 (PST)
Message-ID: <6227fef1.1c69fb81.bf2c6.176a@mx.google.com>
Date:   Tue, 08 Mar 2022 17:12:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.183
Subject: stable/linux-5.4.y baseline: 89 runs, 4 regressions (v5.4.183)
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

stable/linux-5.4.y baseline: 89 runs, 4 regressions (v5.4.183)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxbb-p200          | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.183/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.183
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e7d1268f5671aa524007f68f458aee185d93fa04 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
meson-gxbb-p200          | arm64 | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/6227e9f0faf000fbd4c62997

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227e9f0faf000fbd4c62=
998
        new failure (last pass: v5.4.180) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6227c63f903938f9bcc6297c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227c63f903938f9bcc62=
97d
        failing since 81 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6227c641903938f9bcc62981

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6227c641903938f9bcc62=
982
        failing since 81 days (last pass: v5.4.166, first fail: v5.4.167) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6227c88e769f36c49ac62971

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.183/ar=
m64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-kev=
in.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6227c88e769f36c49ac62997
        new failure (last pass: v5.4.181)

    2022-03-08T21:20:08.009444  <8>[   31.874134] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-08T21:20:09.021593  /lava-5840583/1/../bin/lava-test-case
    2022-03-08T21:20:09.029721  <8>[   32.894978] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
