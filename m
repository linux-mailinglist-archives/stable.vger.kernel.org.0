Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6355F572BD2
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 05:18:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbiGMDSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 23:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiGMDSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 23:18:47 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC6D10FCD
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:18:43 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id f11so8436087pgj.7
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 20:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=xiuH3fCrimCjzCsvU8Zy335q1jS3AslMU53QnScOWe4=;
        b=1JcwVupDeMMZjxF6b5gizE/Qa1v9SeTgpp4kzzLNWqK2mhsaRS6rp4CEWF6BYnOxEF
         eeWCPsSzZVzuLtyAXA8IwfRCtZ0ROSju4kmGSMDWyzsXz0tzj5fVeMVlgCHboJcMS9eH
         U7WNytXFAIJyJy+LUcfwXfX5pNrmRkW2X1v6+u9bIgR/zz3aF6gMlnHtadXfDvJNLteT
         YyQiojF6xjK/38mbbIiXQUqrYJ+5CShprmW0F3aqfje+bDNEzI1m1huVRBBpmwkEsJTz
         ej5M1rNbu9d+srARcJ5QkZu0HASTwCmr7cIOM6E5qya7x38C1B+wXGRXH7VMHeo/kuub
         NIxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=xiuH3fCrimCjzCsvU8Zy335q1jS3AslMU53QnScOWe4=;
        b=wzPYAHZgyYqi1HJ5GhdODFC40jO0+/V5O//eJc7WxviZCmRdCz2CloiJMMhBsX0eLl
         4ZGNHRlhveQE5CLZ50FTCs2p/JAabYu9juZXiV6+u/jMzJMZr1aw9lSbjDnzNkz4j1pw
         xP3U6F2byXDNSOBy3XEfvOpxvSUmh2kZ7/QTjeaMkbmdlSgjjRm/JOl1b1Q/bxYYq8JW
         dqNiJmxmIBbQUcG9K2FObKnf8tPEtcLGTEo/ZdwSVUGnb3Cgrjuocsk14VeCC+xHN2B2
         CpV1iZ5pn6Ir3TfQOAf991Q8jQS51TgA/4OmulUBZfeCQNCK9HQnroGbbfWtIkwzvHxN
         r/Sw==
X-Gm-Message-State: AJIora9w1el3wMsQZ0/kXQpVaBdt2U+DMFZ5B4ZXEgDGVQY1S/3OvWx2
        eR/kISsoDNxWS7/vk0t3T8Yjrwj4ABgNXoBd
X-Google-Smtp-Source: AGRyM1vE51Uu9ONpjf/f7FBoz5glEwBLNwrjL68sr5vlNnXGzyDwaLEdMj3F34EjKyDab1US7vVi9Q==
X-Received: by 2002:a63:ef05:0:b0:416:306:db8d with SMTP id u5-20020a63ef05000000b004160306db8dmr1190613pgh.203.1657682322816;
        Tue, 12 Jul 2022 20:18:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 31-20020a63165f000000b00416073ced8csm4245860pgw.73.2022.07.12.20.18.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 20:18:42 -0700 (PDT)
Message-ID: <62ce3992.1c69fb81.ddb78.683e@mx.google.com>
Date:   Tue, 12 Jul 2022 20:18:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.130-131-g53b881e19526
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 130 runs,
 13 regressions (v5.10.130-131-g53b881e19526)
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

stable-rc/linux-5.10.y baseline: 130 runs, 13 regressions (v5.10.130-131-g5=
3b881e19526)

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
onfig             | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
onfig             | 1          =

qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.130-131-g53b881e19526/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.130-131-g53b881e19526
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      53b881e19526bcc3e51d9668cab955c80dcf584c =



Test Regressions
---------------- =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
jetson-tk1                 | arm    | lab-baylibre | gcc-10   | tegra_defco=
nfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce196c1a173290f3a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetso=
n-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce196c1a173290f3a39=
bcf
        failing since 36 days (last pass: v5.10.118-218-g22be67db7d53, firs=
t fail: v5.10.120) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce09841fa517fedea39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce09841fa517fedea39=
bd4
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce1336a7682adaeca39c60

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce1336a7682adaeca39=
c61
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce0992f0c3a383e5a39bf1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce0992f0c3a383e5a39=
bf2
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv2-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce139b444ee16609a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce139b444ee16609a39=
be5
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce0995f0c3a383e5a39bf4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce0995f0c3a383e5a39=
bf5
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3      | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce13c21df09a7bf7a39bf3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce13c21df09a7bf7a39=
bf4
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-baylibre | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce0990f0c3a383e5a39be3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce0990f0c3a383e5a39=
be4
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_arm64-virt-gicv3-uefi | arm64  | lab-broonie  | gcc-10   | defconfig  =
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce13724f4c5b0a2ca39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce13724f4c5b0a2ca39=
be3
        failing since 64 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
onfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce05e5ff7df2e372a39bdc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig/gcc-10/lab-baylibre/baseline-q=
emu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce05e5ff7df2e372a39=
bdd
        new failure (last pass: v5.10.129) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-baylibre | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce06eb25ba6ca3a9a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-bayl=
ibre/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce06eb25ba6ca3a9a39=
be2
        new failure (last pass: v5.10.129) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
onfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce0e35179500802ca39c03

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qe=
mu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce0e35179500802ca39=
c04
        new failure (last pass: v5.10.129) =

 =



platform                   | arch   | lab          | compiler | defconfig  =
                  | regressions
---------------------------+--------+--------------+----------+------------=
------------------+------------
qemu_x86_64-uefi-mixed     | x86_64 | lab-broonie  | gcc-10   | x86_64_defc=
on...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ce108e430da566d5a39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
30-131-g53b881e19526/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broo=
nie/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ce108e430da566d5a39=
bd2
        new failure (last pass: v5.10.129) =

 =20
