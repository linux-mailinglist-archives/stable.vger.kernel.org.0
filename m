Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F875867AF
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 12:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbiHAKlp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 06:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231398AbiHAKla (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 06:41:30 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E18EB37FA7
        for <stable@vger.kernel.org>; Mon,  1 Aug 2022 03:40:41 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id x2-20020a17090ab00200b001f4da5cdc9cso4691115pjq.0
        for <stable@vger.kernel.org>; Mon, 01 Aug 2022 03:40:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+IceAtIkZX/KOxeDc9cp80Fq0/j2uopWBNfl7HZHqtg=;
        b=Unq48IuexkNlKz4cVyLdb0U+N5RyM16usjbDhrIPTgvyoW9Zth52JIaf5GEWOeVxHI
         xd6AVE8Jiiqv+7bXPaR8pB6LqYLzSMg+0BBrn56YDD7p3JxoqbK7rwYrgIe0TOsI3sLo
         j+5WEiskTMt0rh9zP8cT908r9ppC6YstoOzx0aK3qbftQ7ojWenqsxqWQ/U9YluTrV3K
         5nWGhJtr+4jDLgoYofW3/oPmWurDu7jCDhxeNFeC20HjANufNnWctBpM6nqbeoaeRUYB
         FDnLn665C9oCzzGVlRpCxQ0Zah0aGozKuC74YKhBNxZ3W6NykmqCUPbElFEoHTd84/8u
         LYGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+IceAtIkZX/KOxeDc9cp80Fq0/j2uopWBNfl7HZHqtg=;
        b=IbfBLHklaWGpvSV3H+hGxUIAKJqz7jZDGEfJvk2d4TIvWyDa1rtlMSUDqLUCNlZsVF
         2Ee2f7Fbfd8WKcudhyCh/jcuA2VCmjyMaQwIkMPobbIqESe+qMUgOL54V07v/TRTC4zc
         0JNP53WMuMM2bnNYv8qef+Lpe/kUdBlZ7Wtu/Wnb2QuOYhesZjq2o9xlLgswnZo2/OpA
         QEwmxE46k5OG/ieKbjv52K8wzU0D0CvYYT0+t9XYgFruJsdBh1JFXWCLVmUldgYELB37
         ucHURr74z8Hc0mfi/CW3QVdfzhL9Na/S4Z1O/DDFi4wm0BdFTXGps4SE3HEykD7vIL1u
         cYuw==
X-Gm-Message-State: ACgBeo3t8l6Vn0rLg/pr9cN7vZv0QhVokx3Qfg5shOpcKiAboY1zptc0
        HvxTktx5b2RjTkagT4OKepPFn01BYorKb41U0K4=
X-Google-Smtp-Source: AA6agR6DWlEsUUGrVQUMx75qQcXcnAX4GgAIOW2pCbbpDkW7Dl4yDNWtfALC4c3kmxJuPmRGCr7Dcw==
X-Received: by 2002:a17:902:dac7:b0:16e:fc21:4e17 with SMTP id q7-20020a170902dac700b0016efc214e17mr765219plx.168.1659350441137;
        Mon, 01 Aug 2022 03:40:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m13-20020a170902f64d00b0016bf2a4598asm9088311plg.229.2022.08.01.03.40.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Aug 2022 03:40:40 -0700 (PDT)
Message-ID: <62e7ada8.170a0220.70c7c.d7af@mx.google.com>
Date:   Mon, 01 Aug 2022 03:40:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.324-35-g0973dc75e426c
Subject: stable-rc/queue/4.9 baseline: 27 runs,
 8 regressions (v4.9.324-35-g0973dc75e426c)
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

stable-rc/queue/4.9 baseline: 27 runs, 8 regressions (v4.9.324-35-g0973dc75=
e426c)

Regressions Summary
-------------------

platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.324-35-g0973dc75e426c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.324-35-g0973dc75e426c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0973dc75e426c8eff64c53f873222849d877fc2b =



Test Regressions
---------------- =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68b0040c2a4748fdaf094

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68b0040c2a4748fdaf=
095
        failing since 82 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68cb9e5111d81c6daf069

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68cb9e5111d81c6daf=
06a
        failing since 82 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68b1584b5d76025daf07a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68b1584b5d76025daf=
07b
        failing since 82 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68c905b7716aa5edaf0d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68c905b7716aa5edaf=
0d3
        failing since 82 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68b3ceb505686cadaf05b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68b3ceb505686cadaf=
05c
        failing since 82 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68ccde5111d81c6daf095

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68ccde5111d81c6daf=
096
        failing since 82 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68b0140c2a4748fdaf097

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/baseli=
ne-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68b0140c2a4748fdaf=
098
        failing since 82 days (last pass: v4.9.312-43-g8ccd2ae24f47, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab         | compiler | defconfig    =
              | regressions
---------------------------+-------+-------------+----------+--------------=
--------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62e68ca5ac7f7a32ccdaf0bf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.324-3=
5-g0973dc75e426c/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62e68ca5ac7f7a32ccdaf=
0c0
        failing since 82 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
