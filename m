Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9AD14AAD40
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 01:43:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348417AbiBFAnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 5 Feb 2022 19:43:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348322AbiBFAnt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 5 Feb 2022 19:43:49 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD150C0612A4
        for <stable@vger.kernel.org>; Sat,  5 Feb 2022 16:43:48 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id r76so930649pgr.10
        for <stable@vger.kernel.org>; Sat, 05 Feb 2022 16:43:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AAox0cegsdog4N/RXp+6QXhuBkMoKjCB9955HEa4o+U=;
        b=v0+xitBvA8b4kDaJAHx0lmbJoiv43BXGrdTyNeAvIc8aNGey6Efgren9VDam7ogoKo
         4ryNgfMd0KEIosA1aj+wEqjH4E1GI/byNv/F9TNMgcJX1BBWXaJjqvOVI4wTXeNnVCnA
         fvnhl0q1OPNYlhJnIQ51iKOMJWk8QNl5wr25/vcvaxOqYtSkiA2WsdGvO49VTEt5ODUX
         F9sVkLaMgl0OUf1ZiGUbgadbdztwbweN+i3QYmSqPrXlNsY3an01ha8KAD6Mb7MyhO5W
         oWuqIgYjEP0MIF11njUAF4uhRZ7s3o18St/4ECBTDkQQqGzROa7a9c4KleEWJ1OhWLLC
         A/rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AAox0cegsdog4N/RXp+6QXhuBkMoKjCB9955HEa4o+U=;
        b=0U4MMUszpax5T3mMg80+3pG5h15IhMB28S8JaB4jE+NsR5QXS8LDFCd5ZE5vBQSQY+
         SuHC/1ZYV1ozz2/6ek/c4aAl6vm8rFbTL7tIq6yNktuCcnK6BU18kPA6cMiJo9yDQXKZ
         gwMronuLKyntrRNWNCLzdMEXXLoMsCoBMdYJCcjLi5UxHZJCWOwcSb7ujEaFaX6riZYJ
         zRMrD1j26mNoeOS7N7YFFTbUnzAWXr2PkEOVWlZLf8o7IGxTsPrD32TQdXwBfsrvli4l
         pp3PsWvcA/Iq1hS/2VGvtxNnRkmClzuGp7Rye0sleFiMvHyXBm6wrGEYenqyYATUAV1y
         9Atw==
X-Gm-Message-State: AOAM533kDI5ykhbpuRRo9HwYlPJP/na4Uwqe/kssVyZFdii2LFSNFfdt
        NqwfMEGsCrlPppWDxRJhKcPZlbBXW1wABJT8
X-Google-Smtp-Source: ABdhPJy8nVMSxzlVndT+fGHvQrAJzx975Eqx2Yig6cSwPyiHg86qz3xaNyRLA01s4IZ5o18FC9/5hw==
X-Received: by 2002:a63:d217:: with SMTP id a23mr4524598pgg.76.1644108227964;
        Sat, 05 Feb 2022 16:43:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m11sm4599813pgb.15.2022.02.05.16.43.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Feb 2022 16:43:47 -0800 (PST)
Message-ID: <61ff19c3.1c69fb81.cbd79.c2ad@mx.google.com>
Date:   Sat, 05 Feb 2022 16:43:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.177
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 128 runs, 5 regressions (v5.4.177)
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

stable-rc/linux-5.4.y baseline: 128 runs, 5 regressions (v5.4.177)

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
el/v5.4.177/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.177
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b8f53f91712808313bf7b5bd9947d7095968248a =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61fedcdc012828c0355d6f00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fedcdc012828c0355d6=
f01
        failing since 16 days (last pass: v5.4.171-35-g6a507169a5ff, first =
fail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fee3d0563dc731a95d6f00

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fee3d0563dc731a95d6=
f01
        failing since 51 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fee3d8563dc731a95d6f06

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fee3d8563dc731a95d6=
f07
        failing since 51 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fee3fd57dba2084a5d6eea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-ue=
fi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fee3fd57dba2084a5d6=
eeb
        failing since 51 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61fee3dc563dc731a95d6f20

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.177=
/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uef=
i.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61fee3dc563dc731a95d6=
f21
        failing since 51 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
