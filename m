Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B158C54EC5C
	for <lists+stable@lfdr.de>; Thu, 16 Jun 2022 23:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379009AbiFPVQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 17:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378629AbiFPVQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 17:16:25 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F6E460D92
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 14:16:24 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id i64so2522666pfc.8
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 14:16:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=H5TebqqJfIFtREjh9L1DL1d5UNXdaxeG84AxmI1o+Sg=;
        b=X57tKy6s+g2SOQG8uED8uDmDRi1Ng67UdNIeMdlBUa4ZF7LopwVaSkFZVOMoNuCcuj
         h82BMN3wCrjW8AzKQfZrboWHJujOInP4V+KrvAvsBil7KWUI7t8hiAz6HAJhrJU6GAwE
         ERg3QGG0zb3uqpT1QIJl8MrTAbWtvwp2D5xH/ZqjlvfRQS3IMsRpJwz0rx9AxWMPm9p8
         KyNN59KezF35ekf5yYzCNy6Iq6z9LlhFwQ/xUDGlJAj1XGWbwrDWejvJCGwUSjwfZXKD
         LLrGjDgzvciiFp+E7rDbxf0E4zIu/jAEP3kCBLdxVAYCY614ikgNqaL6OGPvk30f6Waf
         Rbvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=H5TebqqJfIFtREjh9L1DL1d5UNXdaxeG84AxmI1o+Sg=;
        b=ZdW7elM8lUTLvcfpTAu3hFV9uRrXRRyL06GS7yeP4LOZBUeFlX2C1Wjmgj4pCC/t/U
         uKOgLanzJ9VdMlRdbTr1hDqoeCrw1xQuBWo10jLllTjxRD0pp3pjx9UvqnwQW4Rb/smF
         JzcnOsVYKW0LodxaYe3YAYmxn2l2bN2hMFdj1rK/zGXJi6dLZVLZhWKxMOkyvwh6OYmE
         f9cDclnxx8U7ahBNmRBwNmKiJ4jUDMF909I2i2l6qT7LQHeNWLKaDb1iIqaJeoHYeC9c
         uhhBoI4aURRGzg/E5x4cT9OBfATzI1hFzFb2jQXAbGJ6nPk5T/K/une3kzeMbiN0c3HW
         7dhw==
X-Gm-Message-State: AJIora/DWlCHWFHUmXQ362/22zcpyjWyp8ZTWJYTmqzYC4lyORQZRZEl
        6ToaFLLvqUdNtIWpRUzALIQEzGOYMFKTKw1i6h4=
X-Google-Smtp-Source: AGRyM1saEsltRWpIJArUyf10O0oLxOAUlx0L6UXYedR+MPLbv36Bsj63sYEm/p94EI0FWR7D0eQb0g==
X-Received: by 2002:a63:b953:0:b0:40c:450f:3953 with SMTP id v19-20020a63b953000000b0040c450f3953mr1534453pgo.219.1655414183872;
        Thu, 16 Jun 2022 14:16:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b001674b0d4e4esm2034601plb.241.2022.06.16.14.16.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 14:16:23 -0700 (PDT)
Message-ID: <62ab9da7.1c69fb81.86702.2dd9@mx.google.com>
Date:   Thu, 16 Jun 2022 14:16:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.319-1-gb55f148110cf9
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 57 runs,
 8 regressions (v4.9.319-1-gb55f148110cf9)
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

stable-rc/queue/4.9 baseline: 57 runs, 8 regressions (v4.9.319-1-gb55f14811=
0cf9)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.319-1-gb55f148110cf9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.319-1-gb55f148110cf9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b55f148110cf9b64cb23ababc8f4c16dee250f06 =



Test Regressions
---------------- =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab64fb4c182593bea39be5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab64fb4c182593bea39=
be6
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab663f2761abeb2ba39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab663f2761abeb2ba39=
bd0
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab64f9012628fe62a39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab64f9012628fe62a39=
bcf
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab659f14108db517a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab659f14108db517a39=
bda
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab64fa5a9a5114fba39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab64fa5a9a5114fba39=
bcf
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab65c7a9999d9098a39be4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab65c7a9999d9098a39=
be5
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-baylibre | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab64fdaf4e22708fa39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-baylibre/baseline-qemu_arm64-vir=
t-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab64fdaf4e22708fa39=
bd5
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =



platform                   | arch  | lab          | compiler | defconfig | =
regressions
---------------------------+-------+--------------+----------+-----------+-=
-----------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie  | gcc-10   | defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ab66532761abeb2ba39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.319-1=
-gb55f148110cf9/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-virt=
-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab66532761abeb2ba39=
bda
        failing since 37 days (last pass: v4.9.312-43-g5b8113699dd5, first =
fail: v4.9.312-64-g69b9f3e8fce2) =

 =20
