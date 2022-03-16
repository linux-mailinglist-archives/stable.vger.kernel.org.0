Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C9FB4DB37D
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 15:40:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237011AbiCPOmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 10:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243855AbiCPOmK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 10:42:10 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2336D5F25C
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:40:56 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id e6so405783pgn.2
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 07:40:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KPB4y5RBX31Edb2P1GgBhV8jkXclS//jZMJ05kaue8E=;
        b=VTWa6nCKuRWbT+71Njcr3KhzvgXcCkXveJD/ojW529T9nJfrizFcJR5+aXrdzykJpq
         utpTXA+/IS++XGLKrLN2qP0Zj8eU0xIDVenxgGQUfva0kFO2mrpqb5H2QwjHx9uxrEcQ
         JYZpoKRyFtkLMDEZLON6n0BOWvu3PQma7UQ5i46Yo/ltUeay8nceN5InbNbPm6iOamDN
         GcATYoMiwDSihn8c4H1zQomyEOTe6XovyQRncqUT+Wt0izLv8z4rgeEY5T5wlQKUJpeW
         QVHM3xFGIwogNws4vS+NuGhOXY/xkdbvBDUHrFT42w923jkWur7CviaCYN/0VXzGUmw6
         axhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KPB4y5RBX31Edb2P1GgBhV8jkXclS//jZMJ05kaue8E=;
        b=zSKXBvRNHfv+hQrPjJbTPfoloobCGP0uJE5e8WznXRx+NGO1Q2aZ1DQgaHOryOYdm7
         zDdyc63hpc1BAPqpeAxtbzyUp0nRu1VoR0CIE2qwrjsDe8dMm/rcm8Orx3V5d0EZMnSx
         yyOsQLEaWrQxrahHpm+GG21mHvP8+GUoHQK48RGUCTTFqPVYj4BO7lPRdb8g1KEcphRJ
         PkG9ZT2THvPZHUsaze4ZW3GoLjhzKgw0A4P67j4fc6A7c23Ne+6g/iIjtdrbEqNqOaFY
         PRZja8IRmD64JjRs/R2CbJUmblnOdMuI44UEE62uNmqqr5pIj1bSdozwkHRsewhAHl7r
         ciTA==
X-Gm-Message-State: AOAM530Gv742UXTYtBs1wOKvj1yuBSxi9L5IocbV6oAcESIyCWEL5uct
        0EJeizTOyrSHc5KGNbl6/jEIlYsKIqo5wEtoOGw=
X-Google-Smtp-Source: ABdhPJyX3DrxJWlF8pKiJP0zzj9OqcMzQ3Ty+r2Rm4MLgC4WLQfPv4xn7gwAsl7utreogwvmkGm/YA==
X-Received: by 2002:a05:6a00:238f:b0:4f7:78b1:2f6b with SMTP id f15-20020a056a00238f00b004f778b12f6bmr31660268pfc.17.1647441655472;
        Wed, 16 Mar 2022 07:40:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l10-20020a056a00140a00b004c55d0dcbd1sm3440561pfu.120.2022.03.16.07.40.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 07:40:55 -0700 (PDT)
Message-ID: <6231f6f7.1c69fb81.e2c1.7911@mx.google.com>
Date:   Wed, 16 Mar 2022 07:40:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.184-43-gd34fce068653
Subject: stable-rc/queue/5.4 baseline: 53 runs,
 3 regressions (v5.4.184-43-gd34fce068653)
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

stable-rc/queue/5.4 baseline: 53 runs, 3 regressions (v5.4.184-43-gd34fce06=
8653)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =

rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.184-43-gd34fce068653/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.184-43-gd34fce068653
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d34fce0686536648929897fce15bfb11091091e2 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6231bf5ad64f84606fc6299b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-gd34fce068653/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-gd34fce068653/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6231bf5ad64f84606fc62=
99c
        failing since 90 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre  | gcc-10   | multi_v7_defc=
onfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/6231bf434b9cddc6b7c6299a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-gd34fce068653/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-gd34fce068653/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6231bf434b9cddc6b7c62=
99b
        failing since 90 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
              | regressions
-------------------------+-------+---------------+----------+--------------=
--------------+------------
rk3399-gru-kevin         | arm64 | lab-collabora | gcc-10   | defconfig+arm=
64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6231c1636ae323ac7bc62969

  Results:     88 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-gd34fce068653/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.184-4=
3-gd34fce068653/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/basel=
ine-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/6231c1636ae323ac7bc6298f
        failing since 10 days (last pass: v5.4.182-30-g45ccd59cc16f, first =
fail: v5.4.182-53-ge31c0b084082)

    2022-03-16T10:51:55.137959  /lava-5889724/1/../bin/lava-test-case
    2022-03-16T10:51:55.146736  <8>[   32.668688] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
