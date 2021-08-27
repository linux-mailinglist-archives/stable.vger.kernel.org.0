Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39D113F9401
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 07:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231195AbhH0FWJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 01:22:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229757AbhH0FWJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 01:22:09 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05B1CC061757
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 22:21:21 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso8152737pjh.5
        for <stable@vger.kernel.org>; Thu, 26 Aug 2021 22:21:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=zFqm+Qq/oLD4g3VIwpPNFYihVi8natHcVsqzUTmNqEo=;
        b=tGllo+AkXLKPGPjfyxBVNFOtlda+JqUQOdkb6KOtWhdznsoxDhPodCbuZ4Fj6Y4JXq
         p+TXTKiZ7bS11xV9plKL+Ixgcm/IrCeW5FkcaUlzrNyhoJzM7uN5a+XrHKxPoXFfLdvr
         2VYijOHMiMBxHW8dtCJZ2gEFnz7K7TGK9SyZSHQDzRlt9r00CkfbSpJ+/9orulU+vbEY
         rwXeRz/uN5ggtVbgz+I3BAH7CW7qKxja0ik9nF/6x6twGBFYoIGj3tKNcGNKaDO7R1qL
         p4ulFgJh4ufrGl2R5aKbNGmmYj4vvSnDKaI8O+oa5Sh0PqweJIEQgaxAR/SmDQF6Hvor
         Z0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=zFqm+Qq/oLD4g3VIwpPNFYihVi8natHcVsqzUTmNqEo=;
        b=LYGzwdz8EoE94RozU/+N36UNvlRRAdZtHakLfigdIoe2wG7i3EDbvm1WzVb0w59mGv
         U9FHfArkf9sZ6pwxVJh//w1QggqP9/dQZCdIFWs8gM9pPB2+cR1Ph7/3QELZFA5JCr+W
         bIVVsd5dJNWk3FyygNXmVKK5YjMTG3wy1BPPFbZfoaBryGFMh2d9af7qHfj0wkej2cJS
         xpn/1xb370dk2JV4xcTIDowzlMJckyxrm0tYzK9yGbZf04d+ipVDXWRF9zb03Uhl41GL
         nvScQuBjxSwq7L/IKA1vSbR1CqzVZ7kwLJnzoEznBmHEV4xdvnSdJewrZNAG3NmMIoL8
         udbg==
X-Gm-Message-State: AOAM531ydAf7pInRMRflK+L0WGSszJ2kIwpq1aeixAdQ9P5u7Q88SW8B
        S3KV1z3ePAIEsgenruH5hDISlRfHR6ifMlRI
X-Google-Smtp-Source: ABdhPJzC7V4FKSR3+uILkMxmd3kVePVRRtgAshwBdlVErGh0DvWv45GGdwJRQEDnWWjiBeZorV2acQ==
X-Received: by 2002:a17:902:ba81:b0:132:3a70:c16 with SMTP id k1-20020a170902ba8100b001323a700c16mr6933741pls.60.1630041680308;
        Thu, 26 Aug 2021 22:21:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9sm4018684pjp.50.2021.08.26.22.21.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Aug 2021 22:21:20 -0700 (PDT)
Message-ID: <61287650.1c69fb81.495d5.aa50@mx.google.com>
Date:   Thu, 26 Aug 2021 22:21:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Kernel: v4.4.282
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.4.y baseline: 68 runs, 4 regressions (v4.4.282)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 68 runs, 4 regressions (v4.4.282)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.282/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.282
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f5b96f6814376fe061a02604064b702ccf4bc6a =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61284b5293a198042d8e2c82

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61284b5293a198042d8e2=
c83
        failing since 285 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6128446dc8de7ad4f88e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128446dc8de7ad4f88e2=
c7b
        failing since 285 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61284b7a8dc7a10f6f8e2cbb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61284b7a8dc7a10f6f8e2=
cbc
        failing since 285 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6128444b74a4796e928e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.282=
/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6128444b74a4796e928e2=
c7d
        failing since 285 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
