Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8884D57A94C
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 23:47:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240572AbiGSVrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 17:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240575AbiGSVrA (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 17:47:00 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34BA315FC3
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 14:46:33 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s27so14654304pga.13
        for <stable@vger.kernel.org>; Tue, 19 Jul 2022 14:46:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZwAdtjcpVsD2ZgCEuqnDbHWj+ntOfjXY1Oiyfzb+nM0=;
        b=qXuhRQEx9sXkuK1SAMf537x7eQlIJ5sbx1mimLcSZHvrvE7VbKKq+BuTkV+bewukXb
         jrn5uGjlOUVYmwYVs1I5iUrjjR3S2f+I/mfmfSuIBjfF6YlZ2VhUrSfJSIFmy8sANExL
         Bksxd2MMgHWj79mi12cNnUWNXrc+jm6rJy0tEX7MHOveMgfHi+MZPBDDTSkef9qcF+ph
         eYl9S4Dq0GpWdO3jD//5JbhKe4t0OnJTTyaaU+D920Y3Qtou8vysXW9vkCW9k9Y36bnN
         CdS74E+nPd+OKfHbnPlKi5CfLeCC6JP2v7/mrtVqMyxYQHQ6Zlf/j3/doIqTaYtoVrms
         a4Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZwAdtjcpVsD2ZgCEuqnDbHWj+ntOfjXY1Oiyfzb+nM0=;
        b=zl3tjlYqJB00BZ+SCkVMg+JnLPMkt5vw2Hw2NU2FKX9/+iav9pW08X3aYlM6AVQcyO
         QZncjuAi9YRwTvAYF7lXxZtitZpm9KwDczwS1jn0EaCKSBvDRalbw1m9E+cV9L/2NVQ4
         oZJ/WbOQlkyNScIMaTBv4iJyoerpLN/HLxAFBoceldkaN+T0J+rwe1k0xuCC0IdVWS7F
         dCQrBAg1bcc7Ssom1MRH0JkwG+w5ISlgjMkHgsqurg2j/zN9atm/VRzgOXnDOQBXZ3zl
         LlW8EdiJs10td7XP+NhPY6BXDOp9iz+K+Jg75ZTfWdG3Wr08iLZrXKvpnuCIquf3n3Hx
         aE0w==
X-Gm-Message-State: AJIora9vQQ47Bez8anQPYKHIPMuKrmgYH08FYi9tj9tXWhQZyOBmVV6c
        d1HarbK8Tmj0/hzPk0e+XBoV6Mlp2PBSjrXF
X-Google-Smtp-Source: AGRyM1tmfb+7NgG24KmBi94QcY/XsaBb9Z3qZfJkMDeGIduEdHMVx8Ia4G8i9jQaafIagsP0TJmuwQ==
X-Received: by 2002:a63:8441:0:b0:415:d595:a7d6 with SMTP id k62-20020a638441000000b00415d595a7d6mr30493168pgd.441.1658267192506;
        Tue, 19 Jul 2022 14:46:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d13-20020a170902654d00b0016d1b708729sm470847pln.132.2022.07.19.14.46.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Jul 2022 14:46:32 -0700 (PDT)
Message-ID: <62d72638.1c69fb81.737ec.12d0@mx.google.com>
Date:   Tue, 19 Jul 2022 14:46:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.131-113-g024476cf51e8
Subject: stable-rc/linux-5.10.y baseline: 152 runs,
 8 regressions (v5.10.131-113-g024476cf51e8)
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

stable-rc/linux-5.10.y baseline: 152 runs, 8 regressions (v5.10.131-113-g02=
4476cf51e8)

Regressions Summary
-------------------

platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.131-113-g024476cf51e8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.131-113-g024476cf51e8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      024476cf51e88407e84736ff298652322459beb5 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f67ec7af08533fdaf056

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f67ec7af08533fdaf=
057
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f78bae2247e68edaf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f78bae2247e68edaf=
078
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f62b9a5576ab27daf05c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f62b9a5576ab27daf=
05d
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f713ae2247e68edaf05a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f713ae2247e68edaf=
05b
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f67f3fd865ef73daf082

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f67f3fd865ef73daf=
083
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f87b70c5feb7badaf067

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f87b70c5feb7badaf=
068
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f67b3fd865ef73daf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm6=
4-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f67b3fd865ef73daf=
07c
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62d6f73b287d458c32daf0bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31-113-g024476cf51e8/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220716.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d6f73b287d458c32daf=
0c0
        failing since 71 days (last pass: v5.10.113-130-g0412f4bd3360, firs=
t fail: v5.10.113-187-g3dca4fac0d16) =

 =20
