Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3615076F2
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 19:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356125AbiDSSAo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 14:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356118AbiDSSAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 14:00:43 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D573A12087
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:57:59 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id q3so16540363plg.3
        for <stable@vger.kernel.org>; Tue, 19 Apr 2022 10:57:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OrfaT4jn0iOWlpZEnzAlsBB1ekLwzXrVMG9oQ7qn/e4=;
        b=6CLQlR+glaxsXYnCPyZ9Ymn0UyJ4QywekhEcFeQTJb5ArCdhzAruDJEY/GykS94hIU
         j1KFFPXwPbEcSE3aA0tbOIiem6zn5XGOtMgJo+4bKd0/BXIwMc5Jm24UOvlq0g+2NRCp
         t6djZBZD+om119jaFegOopi+anZ8F0c6jDgdufsjk+ERJuFGSrkYvjoK3o6MM4mzueM8
         vDDJwLLm7NLaLur/YT+eFdARwPQ8JG7io7hIeUzzduXImEcorm3S1wjJ7Ecz9aEQAbHp
         Hl1dAYWyMd6C6iESqIk+Z84Axbzo0lVQGaZH0yISz5rkOgiMHP16aD2Rji1BEPz/w76r
         RBEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OrfaT4jn0iOWlpZEnzAlsBB1ekLwzXrVMG9oQ7qn/e4=;
        b=gzp3Lt6ahAeoOtvL+EOH0XdvWdrEBLYxItIjjTSgmQWBXB9GaUuYCsHx09HxpeRVdN
         3zk78B1xAzM04lAc2el1HDem1p281wOgNYgP2Z6VXeRK3NNdzG7epgSCgbeg46HFPvaz
         Gm8ERjjZb3vXgdAN0gEby/mkoV9ZgWfoC0MD/6RevN8lrSY+4xVEo8LN/kvT9gupzYpT
         NprrOqJae3QVPU7aJEahjVba4ayiTbdHdOw6M0wghXokx/DHjToqmlFy+RU0BnL2GyfZ
         lKiyZtuGjWTFmDUsFxhLrsxltrR1/lDNeO8SPIO25rkyxCjD646luX7j2TjPorZcz9cy
         lwdg==
X-Gm-Message-State: AOAM533QsT2uBX+W/eLR0PvsQIAlU2OkEG7bpdpkbNHa0uQG8N7DJXlc
        MeieojIGOjp5yuTanQwg7E5pfE4fO5LJaTgv
X-Google-Smtp-Source: ABdhPJzzsfl4fInxsJRAty6jp+Ckn/3D2HMr7Wrq+An1A1wBZe7/5k0bXUyVJVcmfWaAVPO5jW1Fiw==
X-Received: by 2002:a17:90a:4203:b0:1cb:6ba1:fcba with SMTP id o3-20020a17090a420300b001cb6ba1fcbamr25166950pjg.20.1650391079225;
        Tue, 19 Apr 2022 10:57:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p8-20020aa78608000000b005082c3cbfd2sm16658023pfn.218.2022.04.19.10.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 10:57:58 -0700 (PDT)
Message-ID: <625ef826.1c69fb81.d389.7b39@mx.google.com>
Date:   Tue, 19 Apr 2022 10:57:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.189-62-g0fc658a180b25
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 130 runs,
 4 regressions (v5.4.189-62-g0fc658a180b25)
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

stable-rc/queue/5.4 baseline: 130 runs, 4 regressions (v5.4.189-62-g0fc658a=
180b25)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.189-62-g0fc658a180b25/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.189-62-g0fc658a180b25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0fc658a180b25d6e25a367bc49f8a41500dbaa23 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec5ac5f8389422eae068e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec5ac5f8389422eae0=
68f
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec52d632015dfa4ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec52d632015dfa4ae0=
6ab
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec596227d46a3c6ae067d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec596227d46a3c6ae0=
67e
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/625ec507da92433047ae0690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.189-6=
2-g0fc658a180b25/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625ec507da92433047ae0=
691
        failing since 124 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
