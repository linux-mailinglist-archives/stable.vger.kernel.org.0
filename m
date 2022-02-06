Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3ABB4AB119
	for <lists+stable@lfdr.de>; Sun,  6 Feb 2022 18:57:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiBFR5C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Feb 2022 12:57:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiBFR5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 6 Feb 2022 12:57:01 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC601C06173B
        for <stable@vger.kernel.org>; Sun,  6 Feb 2022 09:56:59 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id on2so2315852pjb.4
        for <stable@vger.kernel.org>; Sun, 06 Feb 2022 09:56:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1LNyIoI4PI0E6e7RR539c9t6B0ZPaNmSeETqnMWoJa4=;
        b=mkCunh7FWz9ZbdQ7cbj2rwI2JkZtJN0VNImG+3qW8KFiNC/9SKrgf89Qm41+13uZUM
         uOoeBCznRt880tLvjSYXIwtk60OQelmiVNbuuj5tihOBQqoPFIphKqfeZBp4mRKu3A/m
         ZlBqFJSYXl0RUgoetrcYELGVVmi/adX5hYOarw6kZCWciU+r4loeyAVv7cFP1/clsa3P
         LYL6S4xoBmrrLNzg0LQDE72bxOcZjKvYVfxUwIrCirt684uBNKRo0U3hA0FfqKJ6rVRk
         NSYORH99fUnrwxLOolcqebtQzQUJOYR98jcmiY1AfYvl2E/qP/guxzlwFEm/MAV7dVdN
         FwIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1LNyIoI4PI0E6e7RR539c9t6B0ZPaNmSeETqnMWoJa4=;
        b=zPLwoMsoi9e09Vhz9z9jLvFkK6yRRo6G5DmcVdjV8c9dv/8E8r7R0K7yqyIxUogH+l
         EQvdZ9xmRoWqaFINFkPtbA1OnOjCseWLQsqltWe+nEJC1ysUgUXnVPwC6TdoozJXghHX
         doJqEUfJZc3tGU8xMlWJNGaApITkV1BElFLi7r/Cky7DcQLGhZYhr5cHpyBiQwVtF5At
         K2rjOq7dYokVCRvFkI++tsILByMfZtTSy9z15BBDrIOAGgyzfAQ3UABS/zvNUGdI64p9
         cWe07nmx/mo1wdlFVLxpODhGUJKgRiAa2ZCRSxjfQayqbyhfce2uHUbO1KL64SoHCG/z
         WV3g==
X-Gm-Message-State: AOAM5322SO5UsVboUrtCxEm1sxBxCW81F9ToktbIJb76ZPKDWpUx46n6
        3/qfxbbwol6kFX1HEajSVefe6l9iJXUtannI
X-Google-Smtp-Source: ABdhPJyUl4nebVBdMXRPunS5aSa9o56U8rBdg7eln0wcrFEQtgvuj38YH48INNAjpSLL5RXNLGcHDA==
X-Received: by 2002:a17:903:110c:: with SMTP id n12mr12897793plh.163.1644170218998;
        Sun, 06 Feb 2022 09:56:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y42sm9316609pfa.5.2022.02.06.09.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Feb 2022 09:56:58 -0800 (PST)
Message-ID: <62000bea.1c69fb81.be92.7ecc@mx.google.com>
Date:   Sun, 06 Feb 2022 09:56:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.177-40-g908d8dc7229b
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 139 runs,
 4 regressions (v5.4.177-40-g908d8dc7229b)
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

stable-rc/queue/5.4 baseline: 139 runs, 4 regressions (v5.4.177-40-g908d8dc=
7229b)

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
el/v5.4.177-40-g908d8dc7229b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.177-40-g908d8dc7229b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      908d8dc7229bb2aecdd541561db5e5ae91e29c38 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ffd563923127232b5d6f01

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ffd563923127232b5d6=
f02
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ffd575923127232b5d6f0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ffd575923127232b5d6=
f10
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ffd5653f5a8ce0fb5d6eee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ffd5653f5a8ce0fb5d6=
eef
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61ffd58969285365be5d6efb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
0-g908d8dc7229b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ffd58969285365be5d6=
efc
        failing since 52 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
