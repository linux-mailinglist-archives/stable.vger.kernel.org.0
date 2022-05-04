Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19A8F51ACF5
	for <lists+stable@lfdr.de>; Wed,  4 May 2022 20:34:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377168AbiEDSi1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 May 2022 14:38:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377187AbiEDSiE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 May 2022 14:38:04 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB1E238AB
        for <stable@vger.kernel.org>; Wed,  4 May 2022 11:28:15 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id gj17-20020a17090b109100b001d8b390f77bso5927193pjb.1
        for <stable@vger.kernel.org>; Wed, 04 May 2022 11:28:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hRHBMxnLgCYdrk9bVd17SGwPsExKa2X7ugKdSE3H0vA=;
        b=kvc2it10atMNStCnvgJkDgEZoccqGpjS0QPT2MOkTfhjY8z2NJWzwswKtm1pYwYWfN
         VebI+CspM2UOuVCqOIzb3UPqDZ96ivO8TCU1B6AxVuXTalHFdpwTWPIy7BQif1/uBG65
         ulmkW1NB7hA+Nn19hZrVdVUwftLxvq6yL48LUsBfD9D056HSaZfGe/qDvaMkYqP96M8N
         bcRBs4iV1ei3m87wCfApCGxE1NBLJaUXk+hI+HA6OV4iwAi0g7I046oLb0oQGIy73cPq
         SBwkEEQ398TtEXGHfKsth/gngzB1qJ1g3pTA4IwEK11pQgcSsVw34XyiinEkyHJGW/8+
         le0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hRHBMxnLgCYdrk9bVd17SGwPsExKa2X7ugKdSE3H0vA=;
        b=Bq6A7jQ+aavFA85xGB3G4maudutXNyFlGvp7rz8LLwLSDhzSo4rSaHbn41J9SI44/R
         Kbm9r9fVsZ896UDiv/B1tamXl+TLT4Jy9xPhBoKFplOM7UZk3kP5YF0vY9VjafnQfWFv
         rXUdlPv5PjXXq8Fhww0EFKQRZZXQEpbO4D7VuxDBdxAc1i1DT2EG6y6ppPBbqA++GbTn
         6nkDkUZgo1ersbFjclDCYkXpht4D6PMvqyK5yWOjHdNgDs9SvkiD7xZMYdI6cIyrmU00
         Ue6RGcVFypqnY4+tNQBDvyp/7cY85adY9Wy+ATczVJvHQWgmdfDvTego+Vks5dzFqpmL
         199w==
X-Gm-Message-State: AOAM532xHoXUarJYdOwrXjOBGaFX8ozjIByhvS7n8TpYef1X65yAzZ3+
        bdl7hXOhKtZi6aZSTU7nFGj6Pavu+D5+HtZ5qMg=
X-Google-Smtp-Source: ABdhPJzLHv17JMBEsw0voGeTgrB7WiL4SvHMdV/xQEvfBGuoYAyLJuHmNuM+81efJAM/DyVvVwFORA==
X-Received: by 2002:a17:902:7c81:b0:156:30ef:7dec with SMTP id y1-20020a1709027c8100b0015630ef7decmr22949359pll.74.1651688895247;
        Wed, 04 May 2022 11:28:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w10-20020a1709027b8a00b0015e8d4eb1dbsm8671593pll.37.2022.05.04.11.28.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 11:28:14 -0700 (PDT)
Message-ID: <6272c5be.1c69fb81.5122a.5475@mx.google.com>
Date:   Wed, 04 May 2022 11:28:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.191-83-g2d723d526f73
Subject: stable-rc/queue/5.4 baseline: 91 runs,
 4 regressions (v5.4.191-83-g2d723d526f73)
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

stable-rc/queue/5.4 baseline: 91 runs, 4 regressions (v5.4.191-83-g2d723d52=
6f73)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.191-83-g2d723d526f73/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.191-83-g2d723d526f73
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2d723d526f735966b904f52c02d035793882b005 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62729dc92f58fa50eb8f572c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62729dc92f58fa50eb8f5=
72d
        failing since 139 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6272975f8fb879bdc78f5736

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6272975f8fb879bdc78f5=
737
        failing since 139 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62729d8c6548cacb2a8f577c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62729d8c6548cacb2a8f5=
77d
        failing since 139 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62729724d8a87d55318f5735

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.191-8=
3-g2d723d526f73/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220428.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62729724d8a87d55318f5=
736
        failing since 139 days (last pass: v5.4.165-9-g27d736c7bdee, first =
fail: v5.4.165-18-ge938927511cb) =

 =20
