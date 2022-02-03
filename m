Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A8E64A887A
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 17:18:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352171AbiBCQSs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 11:18:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352174AbiBCQSr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 11:18:47 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D07ECC06173E
        for <stable@vger.kernel.org>; Thu,  3 Feb 2022 08:18:47 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id r59so2854877pjg.4
        for <stable@vger.kernel.org>; Thu, 03 Feb 2022 08:18:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZGZB0869hRLD5QWMpozsu2RdP/qvlMX/e2ubnm0YSB0=;
        b=SnYsSLvatfZi10g4XJqodeUiJVHFFdd+EqpH0IcvWGznxRKlE9HAm11DDpCa/KsML8
         kGuvijYoLPymiuH+jq9uqgmk3nuscKgZYwWjKpLBQwMeloUI7LpK7N9JlNEgktiBY0AZ
         vlj3uDfkynPmd3AcpswCwYuxooqtH4AhuvkTTCnDF2MKRZUZkscMF8FtKH64x8V/oRZk
         JvRMNZWITYvOq3PapTsEgh1h7N7jwcPVwaJvS+A+NN3+4KXzS4cgdr6mxrF7tU/aiAkI
         Yc5FmzGchM6duU5ocfPmtRUjxe/6k/54qBtrWZKbavyFBPuTV8Ahlr5eC/uZFURGy70Z
         K7HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZGZB0869hRLD5QWMpozsu2RdP/qvlMX/e2ubnm0YSB0=;
        b=5GyhKy3N/VYqm028xhjf3v7f1NRMHFl4rY6AiL2mXvFqYLBj3oEHExVoVoSntTkzCp
         MksNjWYUQ/LdXFh27mpGplE5DFkvzmsabLUYqAWzfREGlWLp0/6EP8wvDDzS+W85zPM7
         PichofAAWUZlu7m2fk4pTAFCnmX01wTqMonps0PNz1HCPRWLeaC1fYldeNlOBRv3n2IL
         czMvcETaI6n18FyfggXg4AxiNWMheSUVIcnE3RRAK0fzl/JkROxCtqjmfvZDl8jWeNHS
         ql2TDZs/Z8iXW1ZzEUTrFUFM1muQLZaD3UDwBI3dEwBazIpXEKoEht/8RNNp17jx7XDR
         5l7Q==
X-Gm-Message-State: AOAM532DkS6myF1+j2+PleSuSfLO/UI3Gwpd7cerjhjX79ohzIdn4i+G
        ofZFoCvFx6PoVkOF1xuyeCDmeqAgqFg+BsCo
X-Google-Smtp-Source: ABdhPJy6M7m0rWbLdxu6NCSL9W8x5dT6iUj30a4dKIQ2cHPHJqmKNZAhTAIv39+ChpA4+q9QuuBZ2g==
X-Received: by 2002:a17:90b:3007:: with SMTP id hg7mr14815459pjb.78.1643905127132;
        Thu, 03 Feb 2022 08:18:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm10678789pfv.188.2022.02.03.08.18.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Feb 2022 08:18:46 -0800 (PST)
Message-ID: <61fc0066.1c69fb81.6c9f1.912f@mx.google.com>
Date:   Thu, 03 Feb 2022 08:18:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.176
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 157 runs, 5 regressions (v5.4.176)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 157 runs, 5 regressions (v5.4.176)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.176/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.176
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2570bb2729c7cbcecf9a4abc1e740b02a722b6e6 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61fbc78f062f3e43d25d6f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbc78f062f3e43d25d6=
f1d
        failing since 13 days (last pass: v5.4.171-35-g6a507169a5ff, first =
fail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fbcb684f40f82a925d6f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbcb684f40f82a925d6=
f1e
        failing since 49 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fbcb30ce440737d95d6f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbcb30ce440737d95d6=
f1a
        failing since 49 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fbcb7b36939ed3a95d6f22

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbcb7b36939ed3a95d6=
f23
        failing since 49 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fbcb594f40f82a925d6f01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.176=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fbcb594f40f82a925d6=
f02
        failing since 49 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
