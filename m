Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C611F5E8D9C
	for <lists+stable@lfdr.de>; Sat, 24 Sep 2022 16:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233646AbiIXOyT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Sep 2022 10:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbiIXOyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Sep 2022 10:54:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E93E3685D
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 07:54:18 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id c24so2608331plo.3
        for <stable@vger.kernel.org>; Sat, 24 Sep 2022 07:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=zpb+bgVeb1FwMuOHgfLGg8I2gsSHrUrpaaOi5yLmeW8=;
        b=FlfrWwym1gb+4Msn1QB3qVDXOwT/WLg/i0mxnJ1vTr6ntoiaHYXmNm/+wOv96xxYQz
         bG2ZEAjK+c1kqncVjtbktRf6KDCv1JvXj6T5UZVu3gso2zKpt3BEnjVblagVOA08bNdr
         Ip/z9YM3teVSRGACIj2jun0frNaAyO7QvKlKftuo/KG7Xp5VvHJ+trV2Q7WBTrM3Ps3E
         LPwFKf9aaR1CxgSYm7UMGdGTuy/DDJi8XJL4aZAUrg5xwcG8QphMKNvCvuA4lnCdOt+b
         DmX7YFaUnF6oVNsa64odKZqVJbmuVEyHtd7obdxxspF/bDAzZTq2Xtv9T6hq6he0JPmG
         OtKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=zpb+bgVeb1FwMuOHgfLGg8I2gsSHrUrpaaOi5yLmeW8=;
        b=NJElkHXnXqObu7VdXG2BfeFUR1zAOm/JaMrhlhYc5+LhnIsUHiRV5IPFIuJm3pwBz+
         a4jf5ioYDXYb40xdSt8jlOH42wsHfrFRrJ9VQdkB/pnuq44VqFtbWxH6cq4Oley+3tqc
         Y/nXrqx1hWLbo9vNXdt3xy57xoj2Gq6MUJqK6jpP1J1dpBFIY1UI7+CZefmQVEkq9+r+
         BT8wbm6HY/uVuyvG6FwCnKcrd6ETKfpceGm3MeZnIrgZW6gMnLaO3jYGsuPVMbsaxazv
         7jJAGuND/sJIV9mrqejPwPe/XqT0l4yWPrSGrVm/6CbD4EFt6+uj1PmU3y2BZicouWP6
         0gCw==
X-Gm-Message-State: ACrzQf3Vntmc3lFz5ftN1xEhP7PT09lb7mLdB5ZFzDg43ob8G5nCWeCA
        tbdU6ZQYj+qUDCLAPX+D9+6Po6116/KP6jSMNdA=
X-Google-Smtp-Source: AMsMyM4RyIGn/eDlfWpJoWwtfu0SpkYnxWNbGnPB5kYJE/DMDZCSX3lHy+iqCMZCKWaGimDXBj6Sdw==
X-Received: by 2002:a17:90a:fa8e:b0:200:b4b9:c6f3 with SMTP id cu14-20020a17090afa8e00b00200b4b9c6f3mr27267074pjb.190.1664031257635;
        Sat, 24 Sep 2022 07:54:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090332c900b00176b63535ccsm7966795plr.193.2022.09.24.07.54.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Sep 2022 07:54:17 -0700 (PDT)
Message-ID: <632f1a19.170a0220.1ee83.f7a7@mx.google.com>
Date:   Sat, 24 Sep 2022 07:54:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.11-69-g5e775a9ea803
Subject: stable-rc/queue/5.19 baseline: 147 runs,
 5 regressions (v5.19.11-69-g5e775a9ea803)
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

stable-rc/queue/5.19 baseline: 147 runs, 5 regressions (v5.19.11-69-g5e775a=
9ea803)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

imx8mn-ddr4-evk              | arm64 | lab-nxp       | gcc-10   | defconfig=
                  | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.11-69-g5e775a9ea803/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.11-69-g5e775a9ea803
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e775a9ea803fd83bb0e21ca0d16b53bd324ffce =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632ee9360775797045355660

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ee9360775797045355=
661
        new failure (last pass: v5.19.11-69-ge9d119617721) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx8mn-ddr4-evk              | arm64 | lab-nxp       | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/632ee93d321114203335568f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ee93d3211142033355=
690
        new failure (last pass: v5.19.11-69-ge9d119617721) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632ee81db7b9990aad355664

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ee81db7b9990aad355=
665
        new failure (last pass: v5.19.11-69-ge9d119617721) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/632ee8ebf6d29a6609355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ee8ebf6d29a6609355=
656
        failing since 0 day (last pass: v5.19.10-39-g0c9655cc6e1a, first fa=
il: v5.19.11-55-g9888f771c3a9) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/632ee7ebb1a5e9b3e8355698

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.11-=
69-g5e775a9ea803/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/632ee7ebb1a5e9b3e8355=
699
        new failure (last pass: v5.19.11-69-ge9d119617721) =

 =20
