Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E06E4FC539
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 21:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349694AbiDKTlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 15:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349693AbiDKTlW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 15:41:22 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5D5658F
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:39:06 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id c23so14798722plo.0
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 12:39:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=m80lg+9iNbw/UjgorazphYn8/uBQ0EZiwZIUiI1/wzE=;
        b=MEFfUzHcbiVBVQN4+v/Kgg1Dcxe2P5JHGMfIpzlDKQY/PUrgHHK6ohOQsm71AM5VOd
         7be/AaxrESvAiVVFWixZQclXOOHSoW11Dw00N6pwwgaiRk/i55KpHqPkqlxRisyBsahZ
         +CQide7fUx5rWwr3XUT58sFCBLSq6BR7xTO7YABuZ4mkKaVvGgTWjhTnYSsSPH1cucWO
         RjK9O85O8a5HWyjJSWdMGeP3JOccUjAhXFcgPBKHWT+lmpQ2WFbeOb5HUFaHxBNNbZ2O
         ATJblDI7KEX16K3SkwHWtAB5xLT/SBMcVNuXxrpTsqLhDsas72jKtt8XmDKSlQW72Dpv
         /1kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=m80lg+9iNbw/UjgorazphYn8/uBQ0EZiwZIUiI1/wzE=;
        b=H3lgcD1A9Cc3Wyqonun2QNF975NhqN+1zNT4Hh98ISxsmhhzxGdELdZ+d/Utund9Lp
         ig32BNI5yR8z8fxtuWkeN43xy4c0EhNA4pszb/c8WEyHyl9LP4mZEiZIj5WMWK5X36Lj
         m4kC1wOA6u5oLx32PVp2CLqwJqCVlt68tOpnOOWiaa79o9WxhjeIiW8nza46v6LS3RJB
         pPSR5C6N+PyiKAVU6ykk5IIpXQFWPv63xZEDprcoWit18tgCJAvOmYkGgsmwMKRZKDiH
         1vEW73NlKqDvqqvx5mq4nr38uCm4PdDC5FntG/4Tf106cNgBxpsFgiumGrkS22gW5VkQ
         pKXg==
X-Gm-Message-State: AOAM531JlCvPulIrEdiIsS6w6bAbSUyVZJGd6p3HHnVDhtniGUPapT4p
        lKwVHnGVtiKsqQak5MAUWajpYkn8dEpKb+st
X-Google-Smtp-Source: ABdhPJwn05AZKWnvGUIQ8Oo+apVcitce4E1sqGVhF3wzcc7N1YUlbUWLVQzezDL3xArP5VjMOHDbVg==
X-Received: by 2002:a17:902:d5c3:b0:154:c472:de80 with SMTP id g3-20020a170902d5c300b00154c472de80mr34164394plh.87.1649705945810;
        Mon, 11 Apr 2022 12:39:05 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e13-20020a63370d000000b003810782e0cdsm485616pga.56.2022.04.11.12.39.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Apr 2022 12:39:05 -0700 (PDT)
Message-ID: <625483d9.1c69fb81.54132.1a5c@mx.google.com>
Date:   Mon, 11 Apr 2022 12:39:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Kernel: v5.4.188
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 252 runs, 13 regressions (v5.4.188)
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

stable-rc/linux-5.4.y baseline: 252 runs, 13 regressions (v5.4.188)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
at91sam9g20ek            | arm   | lab-broonie   | gcc-10   | at91_dt_defco=
nfig          | 1          =

at91sam9g20ek            | arm   | lab-broonie   | gcc-10   | multi_v5_defc=
onfig         | 1          =

hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.188/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.188
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2845ff3fd34499603249676495c524a35e795b45 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
at91sam9g20ek            | arm   | lab-broonie   | gcc-10   | at91_dt_defco=
nfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/625452345beba27da2ae0689

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625452345beba27da2ae0=
68a
        new failure (last pass: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
at91sam9g20ek            | arm   | lab-broonie   | gcc-10   | multi_v5_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625450e0dd6d7ed737ae0694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v5_defconfig/gcc-10/lab-broonie/baseline-at91sam9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625450e0dd6d7ed737ae0=
695
        new failure (last pass: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
hifive-unleashed-a00     | riscv | lab-baylibre  | gcc-10   | defconfig    =
              | 1          =


  Details:     https://kernelci.org/test/plan/id/6254501e0f5f5b679aae068e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6254501e0f5f5b679aae0=
68f
        failing since 4 days (last pass: v5.4.188-371-g48b29a8f8ae0, first =
fail: v5.4.188-368-ga24be10a1a9ef) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6241bf98fc02f69164ae06f5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241bf98fc02f69164ae0=
6f6
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625452e1391a6660ecae069b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625452e1391a6660ecae0=
69c
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6241bfaddc555c1445ae06a5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241bfaddc555c1445ae0=
6a6
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625452d105309c006aae06c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625452d105309c006aae0=
6c1
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6241bf6029449ce9e7ae06aa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241bf6029449ce9e7ae0=
6ab
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625452e0ef4d73a288ae0685

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625452e0ef4d73a288ae0=
686
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6241bf707f152da392ae06b9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6241bf707f152da392ae0=
6ba
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/625452cfc45ab824f5ae0694

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625452cfc45ab824f5ae0=
695
        failing since 102 days (last pass: v5.4.165, first fail: v5.4.165-1=
9-gb780ab989d60) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6241bfc4b0e7e37dacae06a9

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6241bfc4b0e7e37dacae06cb
        failing since 22 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-03-28T14:01:12.555343  <8>[   31.772183] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-03-28T14:01:13.566814  /lava-5959525/1/../bin/lava-test-case
    2022-03-28T14:01:13.575245  <8>[   32.793032] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62545121821bddcaf1ae06ac

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.188=
/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-=
kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62545122821bddcaf1ae06ce
        failing since 22 days (last pass: v5.4.181-51-gb77a12b8d613, first =
fail: v5.4.182-54-gf27af6bf3c32)

    2022-04-11T16:02:17.630160  <8>[   32.089390] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-04-11T16:02:18.641184  /lava-6063711/1/../bin/lava-test-case
    2022-04-11T16:02:18.649866  <8>[   33.110067] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
