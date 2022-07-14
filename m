Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98342575829
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 01:48:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232445AbiGNXsb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 19:48:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232083AbiGNXs3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 19:48:29 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBBEB70E7B
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 16:48:28 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id h132so2942345pgc.10
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 16:48:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aOcxBLKbAaOiQdzJaRf+11UDxeQicW1Hbq1G+AnWI6U=;
        b=NEB3ogRbOSRf8TaWzXwNMLMcJooSHuvmgRPM5F4ZkBlAVxBUh3Z1BqBbfVakw6a/jS
         fHseO0v2ewotxjdIoXmHagWUUM4sEXSvV0ix1vpF3Dm+leGfP2aURlayPSymlrYAQA+c
         2f8t6nDemQxW1Abkz5pY7vvpND1BmR7rKrSlKGIH+rv1u70W9ciCE+tlOCx6LgQO6PDG
         WgtSZICKunU/BVIzQ6rST12nRvVarVbF79/+fxUwlyZEsnuSOizZWuYlHp/WRLhdacpD
         Q5mZB7Hdt4ZVqPQKrSeRqUunwP2U1kVAzCHBbZ7vdElkjxueiY1gTqmhFkjCoGwGYMtM
         dSZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aOcxBLKbAaOiQdzJaRf+11UDxeQicW1Hbq1G+AnWI6U=;
        b=5Fb+aNUwGUdjcxJluggAkrXYDMj5AHlcFhlYGVN7l6eYSjQLvNaEmbr0myzMs+xN5M
         E+Ic17Es480CDDgcWRflxID2zvpnjuJJnaCVX3UJFt4geds6/vRXng4Yr8RNCUwaWwLE
         sn8fBplhODy+Ysnr67KJC1ENqcnbBdxrkWvq0JA9UG/14gHm7dVcq/MDVRfyDxyCqiGO
         IL1N/EyrysIsvcXUCe/M0aA1I4PqhQPw1xB9wS24drsLddAefzJqTNuasG3CnXVOzpo7
         Xf/6CN4cpospe/NhV+N6k5wHexFSXMEVpccW9ZKHqzrGRkIsWk1ON2ADLMje6eGsikUl
         6uuw==
X-Gm-Message-State: AJIora9pziRHDSFyAMiq0Z7eCP8a78yxqsVvyJFkqmbHSb2gMEbhDRc/
        ztsTw5lCaugbALjhGyrxP7t5ye0DtYsCrC4vNl4=
X-Google-Smtp-Source: AGRyM1s8UW0du4cv68O+gLd0D6el7Gtd6075Zctx++oFigRFA8DJds21Go8xj1+yCj13k4qOh0wqdQ==
X-Received: by 2002:a63:224f:0:b0:412:12cc:1960 with SMTP id t15-20020a63224f000000b0041212cc1960mr9312597pgm.348.1657842508087;
        Thu, 14 Jul 2022 16:48:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902ce8f00b001636d95fe59sm2043694plg.172.2022.07.14.16.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Jul 2022 16:48:27 -0700 (PDT)
Message-ID: <62d0ab4b.1c69fb81.c4fa9.34be@mx.google.com>
Date:   Thu, 14 Jul 2022 16:48:27 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11-62-g9bdfd8703447
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 99 runs,
 3 regressions (v5.18.11-62-g9bdfd8703447)
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

stable-rc/queue/5.18 baseline: 99 runs, 3 regressions (v5.18.11-62-g9bdfd87=
03447)

Regressions Summary
-------------------

platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
imx8mn-ddr4-evk        | arm64  | lab-baylibre | gcc-10   | defconfig      =
              | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =

qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.11-62-g9bdfd8703447/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.11-62-g9bdfd8703447
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9bdfd8703447e5f4cce888982183f101b0c2b1a9 =



Test Regressions
---------------- =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
imx8mn-ddr4-evk        | arm64  | lab-baylibre | gcc-10   | defconfig      =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/62d07b1ececec2c0d9a39c05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-g9bdfd8703447/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-g9bdfd8703447/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d07b1ececec2c0d9a39=
c06
        new failure (last pass: v5.18.11-62-gf8ff14144283) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-baylibre | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d074e3a192572ed6a39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-g9bdfd8703447/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-g9bdfd8703447/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-baylibre=
/baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d074e3a192572ed6a39=
bf8
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =



platform               | arch   | lab          | compiler | defconfig      =
              | regressions
-----------------------+--------+--------------+----------+----------------=
--------------+------------
qemu_x86_64-uefi-mixed | x86_64 | lab-broonie  | gcc-10   | x86_64_defcon..=
.6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62d08dfba6c2db6da0a39bda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-g9bdfd8703447/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.11-=
62-g9bdfd8703447/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi-mixed.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d08dfba6c2db6da0a39=
bdb
        failing since 1 day (last pass: v5.18.10-112-ga454acbfee6a, first f=
ail: v5.18.11-61-g8656c561960d) =

 =20
