Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38B46573911
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 16:43:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236614AbiGMOnG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 10:43:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236611AbiGMOnD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 10:43:03 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18739371B2
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 07:42:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id 73so10618224pgb.10
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 07:42:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YYd1Tw7krvbdqVsLdBtxEmO60AZlKykdeQgi4ST8TqE=;
        b=6MoKSbN9de5wMLW4/Z49TTncKIJ5mEUh+ke3RZJeduDImF6VvyvJaUN7uLuyAqp2tG
         q9uLulGhrXZSR8rXIjI+foj+7vTzCLaXsC6Ayn/mDxvhMzEgsHC7BdTSpl2GT0YzpNNG
         kFxVHGBOF43HGpkuQ+Y0UddIxH4+poWnfQA9Oaz1QEq27BoeAHgwMtkGra9H6jKrJwXi
         JDCcNOL/BeVfU/muKvPlJ6l4G+ZcS+rQxTuWrHIJAZIGWPJenLqGTwlVEN1aTWjmb+6P
         TZ0DhFVuabjXJGLnZhXET07QdI/Ui/LGq1yAvaBCh3oBCapLgpt8Pdq8UhO9msumjCfI
         xFuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YYd1Tw7krvbdqVsLdBtxEmO60AZlKykdeQgi4ST8TqE=;
        b=ov6IdG4oOsBvn2DXCydcHHyK1jt814DXQaPv77XePzyoymjBgtZBBt1Q3x2ADy1/UO
         pTkVnCFlBwYQgT7AXJp1ap5uyDzSfoOgfG6hZqSeQrHajlCD5y7yB4KA7cutemBeKqHc
         9mRSvDCOdgLIzrZ9qBye6vt5+i45VS+Hll/IVBOG1mctq4C7YPH+OIk0pFf2/hoAlrUF
         nozgmOe4d8YorZyZQeYqzZxK62YJV5YhR2rkxzV8ngsjhF7NLBb7cmFKi/Cfe1j+EI/O
         SILYQOwBiBYTmi/iYXvcsarHT0CxJ6PRl8mxCoQuQuoAICmHlM83IWB3SQYaNPNZGrZ9
         G3/g==
X-Gm-Message-State: AJIora9I6wt9+1nRHVr256sauHHgPxKRB+av8/5BNTND4T5Nm0mBWEES
        V0W3zH8Xte5/2eO7vf3re8TIcQpthkl6jroYGFE=
X-Google-Smtp-Source: AGRyM1u9FAA/slPFNnf+UM4+bdbK2QEx3el4F6+2wqlWVGI7+JAq7QY62cWSjw6WLeUpqi0Ikeug+Q==
X-Received: by 2002:a63:da47:0:b0:415:c9d:4e40 with SMTP id l7-20020a63da47000000b004150c9d4e40mr3175243pgj.408.1657723377514;
        Wed, 13 Jul 2022 07:42:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16-20020a170902ab9000b0015e8d4eb1d7sm8912380plr.33.2022.07.13.07.42.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:42:57 -0700 (PDT)
Message-ID: <62ced9f1.1c69fb81.32c0b.d543@mx.google.com>
Date:   Wed, 13 Jul 2022 07:42:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.130-132-g6729599d99f8
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 166 runs,
 13 regressions (v5.10.130-132-g6729599d99f8)
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

stable-rc/linux-5.10.y baseline: 166 runs, 13 regressions (v5.10.130-132-g6=
729599d99f8)

Regressions Summary
-------------------

platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
jetson-tk1                 | arm    | lab-baylibre | gcc-10   | tegra_defco=
nfig              | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =

qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
onfig             | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
onfig             | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.130-132-g6729599d99f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.130-132-g6729599d99f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6729599d99f8543a9c2525f3fbaccabccc04ad09 =



Test Regressions
---------------- =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
jetson-tk1                 | arm    | lab-baylibre | gcc-10   | tegra_defco=
nfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea48e5f461693dfa39c1f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea48e5f461693dfa39=
c20
        failing since 36 days (last pass: v5.10.118-218-g22be67db7d53, firs=
t fail: v5.10.120) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea83a7e248b1bc3a39bf9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea83a7e248b1bc3a39=
bfa
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea96240ab4ea3eda39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea96240ab4ea3eda39=
bce
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea839cc13dbdfbfa39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea839cc13dbdfbfa39=
bdc
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea7fce10bb07544a39c08

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea7fce10bb07544a39=
c09
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea837cc13dbdfbfa39bd5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea837cc13dbdfbfa39=
bd6
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea7fae10bb07544a39bff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea7fae10bb07544a39=
c00
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea8387e248b1bc3a39bf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea8387e248b1bc3a39=
bf4
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea7fbe10bb07544a39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea7fbe10bb07544a39=
c06
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea322c11e86a067a39bec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea322c11e86a067a39=
bed
        failing since 0 day (last pass: v5.10.129, first fail: v5.10.130-13=
1-g53b881e19526) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
onfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea39a4831e36aa1a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea39a4831e36aa1a39=
bf5
        failing since 0 day (last pass: v5.10.129, first fail: v5.10.130-13=
1-g53b881e19526) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea35dd36d55a96ca39bd2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea35dd36d55a96ca39=
bd3
        failing since 0 day (last pass: v5.10.129, first fail: v5.10.130-13=
1-g53b881e19526) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
onfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62cea4615f461693dfa39bfe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-132-g6729599d99f8/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cea4615f461693dfa39=
bff
        failing since 0 day (last pass: v5.10.129, first fail: v5.10.130-13=
1-g53b881e19526) =

 =20
