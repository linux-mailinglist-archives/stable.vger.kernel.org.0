Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C8D53D452
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 03:27:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347655AbiFDBXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 21:23:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350263AbiFDBWz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 21:22:55 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 389C924963
        for <stable@vger.kernel.org>; Fri,  3 Jun 2022 18:22:06 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id c18so142473pgh.11
        for <stable@vger.kernel.org>; Fri, 03 Jun 2022 18:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0qaOeLuyXx4am1By+S3P8OMud4Z+Anvo0k555EDhwh0=;
        b=Xq9xeTpwtoywQEFz+cRIvHg4tt/hGQwLTcRoMir7s3r97WQqBZk+0SJp4kikfjYxe3
         KGPvEx02n3iQActmq59aZNYc1IqMRktUUUYZgJpltBdK+MTMMcMA945lP3SfpUp1CVD5
         h6+vya7rxjIPNI+0Kfek+BmmphZL7eEMXE14VspPENihx6qzV5r6Y+nBmHtavkfbVaT8
         zLVEgxFPkfG3AeLMccsSnuKXD2RgySGjzMf9OIB2aJTdn/oeMRzcyWbOY/XqnhN8lPFs
         VkkDw0/Cy5QqlwVXQP7kBhLDZ9P0khRSEE78z6o66ea/MokB1rQbT5376MoT8ODJt1q4
         gg5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0qaOeLuyXx4am1By+S3P8OMud4Z+Anvo0k555EDhwh0=;
        b=jheWhce7Eb9oCmIuwOT+iKMa1nTkMD1NdxhsZZLc9vm1tetIqHMMeiLTFGgb3Mjcaq
         h0RWFu2yasS30fj+9bdGyhgYK5z/UPL5IeHrS+CTSoBoxplPIc5Wrz6W3A0JmZAYvmpS
         tw08VLU6pXo0FfEwgkSkciZW5pPR6kSdOh8s2a6UStEOQdMRVnu+UtlZgWJwCPvPPP7T
         vfhEvlgGdE/32L4ZKGLHpga9heWmrMtWsnvDY1j9+41pnQQ3JvSxtcJQ6k6Fydoukveq
         QGjQQoZhsnExRPWQ8w8DUXUO84fWyBe4lODBoZFVn0jv6zaKA9wkgEtba8wFkQEMPx3e
         9JuQ==
X-Gm-Message-State: AOAM532ZxgdccNl5OEXPnjcI7qe/eKeSyG6CtU2RgXQdLcfW2Be5sI3B
        HPKg5Aae4lJfVbAUz0WOGXdlqvyjrYp6gpgr
X-Google-Smtp-Source: ABdhPJycMMaWmZnwoReHEqFEx89FWOFg+WnQuT79Q+U+/GCFJQo3+Jcm/HHG3IinbCd3x7R8d6uIkA==
X-Received: by 2002:a05:6a00:2408:b0:4f7:a8cb:9b63 with SMTP id z8-20020a056a00240800b004f7a8cb9b63mr12864888pfh.33.1654305710792;
        Fri, 03 Jun 2022 18:21:50 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14-20020a170902780e00b0016635122b5bsm4773143pll.270.2022.06.03.18.21.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jun 2022 18:21:50 -0700 (PDT)
Message-ID: <629ab3ae.1c69fb81.703f8.b3c1@mx.google.com>
Date:   Fri, 03 Jun 2022 18:21:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.118-217-g11f43ce2ecf88
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 84 runs,
 10 regressions (v5.10.118-217-g11f43ce2ecf88)
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

stable-rc/queue/5.10 baseline: 84 runs, 10 regressions (v5.10.118-217-g11f4=
3ce2ecf88)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig            | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.118-217-g11f43ce2ecf88/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.118-217-g11f43ce2ecf88
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      11f43ce2ecf88f37187b263af2d5700a36b39872 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
jetson-tk1                 | arm   | lab-baylibre  | gcc-10   | tegra_defco=
nfig            | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7b919160425d04a39c13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7b919160425d04a39=
c14
        failing since 11 days (last pass: v5.10.117-94-g0958739a182f0, firs=
t fail: v5.10.117-97-g61f264fd7dfaa) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7c44b6ba7da2a6a39be8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7c44b6ba7da2a6a39=
be9
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7cbeeb65c62abca39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7cbeeb65c62abca39=
bce
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7c45a6076ed533a39bdf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7c45a6076ed533a39=
be0
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7cbfeb65c62abca39bd0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7cbfeb65c62abca39=
bd1
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7c46a6076ed533a39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7c46a6076ed533a39=
be6
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7cc0eb65c62abca39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7cc0eb65c62abca39=
bd4
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre  | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7c42b6ba7da2a6a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7c42b6ba7da2a6a39=
be3
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a7c95f6f61c35bfa39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/bas=
eline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629a7c95f6f61c35bfa39=
bd2
        failing since 24 days (last pass: v5.10.113-129-g2a88b987a070, firs=
t fail: v5.10.113-199-g20397cd2a67b) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
rk3399-gru-kevin           | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/629a900bb4a3d015cea39bd8

  Results:     90 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.118=
-217-g11f43ce2ecf88/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/629a900bb4a3d015cea39bfa
        failing since 88 days (last pass: v5.10.103-56-ge5a40f18f4ce, first=
 fail: v5.10.103-105-gf074cce6ae0d)

    2022-06-03T22:49:42.343617  /lava-6535047/1/../bin/lava-test-case
    2022-06-03T22:49:42.354536  <8>[   33.983636] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
