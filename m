Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12D364EA377
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 01:13:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbiC1XNi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 19:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230290AbiC1XNh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 19:13:37 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE95E5FDD
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 16:11:55 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id i11so16074377plr.1
        for <stable@vger.kernel.org>; Mon, 28 Mar 2022 16:11:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CCXae4S0HkrUvLfnwsIRuQYF4Zsydipg/05LjRo84JY=;
        b=crmFzA0MB2A+dNdWHVQFGQduWIKhDfn/AEQH8/18fADhhe4YrBDbTkrxphu1bc52QE
         ut9bxkOi4LFlhE0mCc8WiYj+B6s98Qs8Av4RIXHZ8rtEboO101BWLAoe5kPlXqvV59j+
         KkrIPUezTM0/Cef8So6yc+bb+UABn9+X3ExesT2+xRpXgkUdOXDIGkb0FzlMLjAt6g1k
         C+fWtrVc7oRCWqeq8h3sbhX6JTetoFN/CNLrl7pVgFGQQ1XmowJcxqfMrfoWIdYTPUhJ
         3gKHi/fecNCdAyAlTERHxPKQ4lu7yQdXdL3aOeyctqJqKcaAyieqHRfNgyUDxpsnsn29
         q7hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CCXae4S0HkrUvLfnwsIRuQYF4Zsydipg/05LjRo84JY=;
        b=IX6y4FH+vakCiwZLzPq67rLLvQBxo3q50qztZzUwTzrEWzjMDRwq6+ex6H6aELVMSF
         R9r23R3MOStfS2JUcK8dDzarQpYQ2d8tZEZTiDVdLGsmfz4jFF5GeCeiIHhcoeS2WA8l
         WkEcM9+2ClO67bCAyWPQbrXR/e8z/Zr3gWSvuTSuVJ0YCHVOH4Sr9oBTAI+9xSGqCWsO
         2b5IEGoKngr1K6BoxgCwhMra9Gcg31USjQCY5IBHbkEi8TD4J2jbGG9ah12P+rbwd9EZ
         VAow7xAwndgfJKy5Gjrriwmzl979Shb/wCtdONpCKzpJfy7cYNF5RQvJBRjrxLLS6r89
         ntKA==
X-Gm-Message-State: AOAM533m4L9iBl0x7s8gS8CHBn7nd4hOF/WrwtCR7LNW5euCKOAEAo83
        qMQpKhL82BNKLFrqAeeBNsN/92QIGgEPVDnYqOs=
X-Google-Smtp-Source: ABdhPJz+dQy2Uc+ZdbJHV0oElI0NR1vGFEfu8qAxSOBi8SStzV11/kz8UvnwTSL3mJE/xpMSv0Iohg==
X-Received: by 2002:a17:902:9301:b0:153:2252:44ea with SMTP id bc1-20020a170902930100b00153225244eamr27678997plb.65.1648509114826;
        Mon, 28 Mar 2022 16:11:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3-20020a63ad03000000b003821d0f0ef4sm14439483pgf.71.2022.03.28.16.11.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 16:11:54 -0700 (PDT)
Message-ID: <624240ba.1c69fb81.e23fd.6f36@mx.google.com>
Date:   Mon, 28 Mar 2022 16:11:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-14-gce3ed21ff148
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 102 runs,
 5 regressions (v5.4.188-14-gce3ed21ff148)
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

stable-rc/queue/5.4 baseline: 102 runs, 5 regressions (v5.4.188-14-gce3ed21=
ff148)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-14-gce3ed21ff148/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-14-gce3ed21ff148
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ce3ed21ff14824b8a1225ec232b0eaf563ea3199 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62420a09d1a5ea0e20ae0686

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62420a09d1a5ea0e20ae0=
687
        failing since 102 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62420a20f90718700cae06a2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62420a20f90718700cae0=
6a3
        failing since 102 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62420a08f90718700cae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62420a08f90718700cae0=
67d
        failing since 102 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/62420a08f90718700cae067f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62420a08f90718700cae0=
680
        failing since 102 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62420c9e459aff36dfae06b7

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-1=
4-gce3ed21ff148/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62420c9e459aff36dfae06d9
        failing since 22 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-28T19:29:16.636670  /lava-5962799/1/../bin/lava-test-case   =

 =20
