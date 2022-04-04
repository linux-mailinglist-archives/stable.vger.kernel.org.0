Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 425CE4F1AEE
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:17:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379317AbiDDVTJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380489AbiDDUTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 16:19:07 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEC2A33EB0
        for <stable@vger.kernel.org>; Mon,  4 Apr 2022 13:17:10 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id r66so431034pgr.3
        for <stable@vger.kernel.org>; Mon, 04 Apr 2022 13:17:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pnIQhMq9BBytmB9PyE3LGmV6z4VQz7SvCKhL/jECo7k=;
        b=J3FrF39C5r3bZeRQK89QayEHx/4e94MDSvz1LPwWN/wk9K9xIenY2tsCxR8aOMLyrJ
         Z9YIit0e+alFasplnJAbOnyu4q75nBdlAIaUN/DJYlCfCWZ3Bvff92hYwwC09KScSAfZ
         f25jU6Kf5ZNPq7wuXIMaam521x2KhOyFqs0FiQVFDl5h3ep4+qPy62GII8GMuJhYoBjt
         vReXkuvSX7/abspVvy3M8Z3wjgQLBkp/6IpKOSUqzbKcx92edsTqLF1nymRcdXJwfSpj
         zCveCZM57XxXtqvCAlgrVIgMTN9K4n7rSHXgJYfs6EYhazHKQnSroUlPIFDNP913/O0D
         xMtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pnIQhMq9BBytmB9PyE3LGmV6z4VQz7SvCKhL/jECo7k=;
        b=cCr/oyVFP9nbN8IkR/90aP2UTxgYA3V9uey5bnOc1Ov/Gm+s7rRH7vmDr2P3+CMR8m
         VvCw7YrkA45NiHaGnAStXZIjIv9d7SHnjgeM1LZEAT/AVqO79mGb18CZJ42L8h10PML/
         jCWI/JDCZ30JGmltvE2yPnj4wW/xez5UjnlLghpFXpZya/yz+nruUlRquabKrJ9yW5q2
         3RG2mrgVGqiAClQrgvxKqihmeUhRmp/XfDl4F5MVYttTAGqRAhHqupdS0zzr3+f+sbPk
         IUUh0ekPMR0L9n7WNpOfDiCGpz2boNitXw6wavYotHrtd+VL+ZGg34TlLQ1fuB76r28S
         XEwQ==
X-Gm-Message-State: AOAM5312SjMpl8UC/iFTr6mBulfGAVy3TRKpDpjFpeSrIDZVjSFuoXh9
        +ZTM3JyKvFd2T3elciENO2CJ3mG5HOV6wTZbJRc=
X-Google-Smtp-Source: ABdhPJzrM8Qag+Y00bPww6Y21FhoGna7WrsNkKyu/0GDpIve/aoRRyTIjZUpuaRN0OuRWxINosp/dw==
X-Received: by 2002:a05:6a00:16c7:b0:4f7:e497:69b8 with SMTP id l7-20020a056a0016c700b004f7e49769b8mr18436pfc.6.1649103429952;
        Mon, 04 Apr 2022 13:17:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a7-20020a056a000c8700b004fb55798f64sm14009155pfv.90.2022.04.04.13.17.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 13:17:09 -0700 (PDT)
Message-ID: <624b5245.1c69fb81.2589.45b8@mx.google.com>
Date:   Mon, 04 Apr 2022 13:17:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.188-368-gfedf71cf9cc4d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 36 runs,
 3 regressions (v5.4.188-368-gfedf71cf9cc4d)
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

stable-rc/queue/5.4 baseline: 36 runs, 3 regressions (v5.4.188-368-gfedf71c=
f9cc4d)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.188-368-gfedf71cf9cc4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.188-368-gfedf71cf9cc4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fedf71cf9cc4d14ab79005d434854ad9667af76c =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624b2944c809a7227eae06b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
68-gfedf71cf9cc4d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
68-gfedf71cf9cc4d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624b2944c809a7227eae0=
6b4
        failing since 109 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie   | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/624b2959c809a7227eae06c2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
68-gfedf71cf9cc4d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
68-gfedf71cf9cc4d/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624b2959c809a7227eae0=
6c3
        failing since 109 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/624b2d5e1ffb498f25ae069c

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
68-gfedf71cf9cc4d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.188-3=
68-gfedf71cf9cc4d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/624b2d5e1ffb498f25ae06be
        failing since 29 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-04-04T17:39:36.541635  /lava-6018887/1/../bin/lava-test-case
    2022-04-04T17:39:36.550017  <8>[   32.860489] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
