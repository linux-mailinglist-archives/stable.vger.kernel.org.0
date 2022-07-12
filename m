Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 904E5572897
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 23:27:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbiGLV1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 17:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbiGLV1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 17:27:07 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F4201CB45D
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 14:27:04 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id i8-20020a17090a4b8800b001ef8a65bfbdso393498pjh.1
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 14:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JvFKeJqENrzR3jeJT/5d78/wUB/PFqJ90nsYVOtZF34=;
        b=gKZ3qtwJ+aPvcPss41v2mGdywhcf06hVLt064IMutQWwM4CuC3Di13UQd35hpAZugT
         ShRJFXn/3frZyFreXGoLeETxXJu1Wyc5xdw8khs3LzdbPfCqYckuafIZfh7qRkGAWZxD
         VlgjYpUqpRLsAG2p64Yy6GlkPyvFIFz9rMmIjyJoGhLW+jf/FM1BH44lkOdBbTjl9UC0
         bSLpeKDJ0MCXUUA2GU425o+8/KzS7CuuB3Q2Qbwu8qvAWeACLhf/nmXn44B9BENvoRXe
         eW92o7k//2ZEbKUABvhkjc+dmekeSfFvOXmNwG92EfLMXghymXl6+RBFQ9re+72V4NNd
         fyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JvFKeJqENrzR3jeJT/5d78/wUB/PFqJ90nsYVOtZF34=;
        b=QSoHZ/aYwIh2FZWncjzsMhZul77pq9iZff26sStwDyZSzd8ais/EU1ARzO99PKXUJ7
         A95HIR6viKibZiejbeMxbMzAITznxwePuIRUV+i8wkqz/xWe9ZUSICMk3N0qEDPk4E+K
         fs/1H6NuudzOS6QKKz1v2mh4bXj7X1lweVIgbA78JFcuKF6OXjNwnRC9HO0iWn3Shv9q
         sjkK8YRo9CkM2GpanH06BPfK6ZrtKYFNfo/RZjKSJneTZBJ8Oerhu8kpRXHkxvefT3RC
         v7NeimAxuemgEt1ujar/lCOGGaUSDKnjDM1VZF7Nj1R+11H3Fyx2s6vxAYeR1Vkh4qYC
         Lz1g==
X-Gm-Message-State: AJIora9+mE8sUx+8xHLxQkpJppTwc/15vgFp99oZ7/LsUHMW2BLtsnuU
        mRCVPW+5Bsx2mvThrsXfwHqooqYCiUODJZ6Q
X-Google-Smtp-Source: AGRyM1sV4cD8S7eEgZOm6VOhFVxVGsJulijD6tN2jRMJlx4fUUTXcYiXNt9DBk5iNnVUVCP4Cd106A==
X-Received: by 2002:a17:902:d4c5:b0:16c:44b7:c8fd with SMTP id o5-20020a170902d4c500b0016c44b7c8fdmr13866884plg.36.1657661224262;
        Tue, 12 Jul 2022 14:27:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 188-20020a6218c5000000b0052ab734e8c4sm7208904pfy.213.2022.07.12.14.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 14:27:03 -0700 (PDT)
Message-ID: <62cde727.1c69fb81.227c4.aa42@mx.google.com>
Date:   Tue, 12 Jul 2022 14:27:03 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.130
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 93 runs, 11 regressions (v5.10.130)
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

stable/linux-5.10.y baseline: 93 runs, 11 regressions (v5.10.130)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config | 1          =

meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =

r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip       | gcc-10   | defconfig=
       | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.130/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.130
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      26ae9c361414418ed02d6e97b3d0c8eaa93be355 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
jetson-tk1                   | arm   | lab-baylibre  | gcc-10   | tegra_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdba9b7ae6388325a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdba9b7ae6388325a39=
bdb
        failing since 43 days (last pass: v5.10.118, first fail: v5.10.119) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb346a2208a81d1a39c1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a311d-khadas-vim3.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-a311d-khadas-vim3.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb346a2208a81d1a39=
c1d
        new failure (last pass: v5.10.129) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb0f5987f0ff4b9a39c16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb0f5987f0ff4b9a39=
c17
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb4636efd351c41a39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb4636efd351c41a39=
bd1
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb0f7987f0ff4b9a39c1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb0f7987f0ff4b9a39=
c1d
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb4776efd351c41a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb4776efd351c41a39=
bd5
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb0f6c0bb962fd0a39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb0f6c0bb962fd0a39=
be4
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb46403df23783ba39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb46403df23783ba39=
bd4
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-baylibre  | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb0e1c0bb962fd0a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb0e1c0bb962fd0a39=
bce
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb43c03df23783ba39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb43c03df23783ba39=
bd0
        failing since 63 days (last pass: v5.10.112, first fail: v5.10.114) =

 =



platform                     | arch  | lab           | compiler | defconfig=
       | regressions
-----------------------------+-------+---------------+----------+----------=
-------+------------
r8a774a1-hihope-rzg2m-ex     | arm64 | lab-cip       | gcc-10   | defconfig=
       | 1          =


  Details:     https://kernelci.org/test/plan/id/62cdb742ac4a3f5546a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.130/=
arm64/defconfig/gcc-10/lab-cip/baseline-r8a774a1-hihope-rzg2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cdb742ac4a3f5546a39=
bce
        new failure (last pass: v5.10.129) =

 =20
