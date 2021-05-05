Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4469337347B
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 06:53:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbhEEEyU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 00:54:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhEEEyT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 00:54:19 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B94C061574
        for <stable@vger.kernel.org>; Tue,  4 May 2021 21:53:23 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id k19so1169228pfu.5
        for <stable@vger.kernel.org>; Tue, 04 May 2021 21:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nr9v1ZDNYNs9Hkbm/fvKAoV8HeEaEyJWCLYeoMr4sls=;
        b=xzpTWVYkkaNJUxGZjEqmMyf7iZ1ptJH9c5khPo9qDtbMidupXyU2YTifSfBR+yvQiF
         wLKl3YNJxOHTsncsw5B9gTp0DUy6bMpKgdqjvurJ/2VLHq4hKuKH+Cvnze0CRwbBIEPM
         xhpBNkMtg9pmwH+QlvV13qKj/mfSv+e3nMCnfkutonsML5PS4+W6fMUoff+NVrXUu5yp
         lIjks9X3X+TrUDMm0ghYiKolGOCJYMIcZkYanlAPvdjK/mEc7/PIWhuwME2e7TDfxGOr
         rw15dOnevgWX+A+kXhNr0xHEF1In7AJF+Z4CC8CLS1vYno8K1NuUDaQbSrWftamRiw1O
         lmJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nr9v1ZDNYNs9Hkbm/fvKAoV8HeEaEyJWCLYeoMr4sls=;
        b=RlJiDsiQeULA0J1lOoCNXUYB93dkJuQrMmwsVnAH7j6YT8Pr6AQQijFdF7UoK4Y+wr
         jaimezO2/GlRWDyXWoYkRANzOMbOt/Y3x868NJpJL9ZlSoXlbWVawd97yYJ1ThSfC2ia
         4vh8FcJzo5ywkyqoVwjO7CMjXm5do1R2ai1A+1EreDl55Ay9OcrNVfjUyChCtUpiGqQH
         2BWaEwE3r4MkneJZ5Pz9iNo0yNU4OWwFIa+J5j2+NPUrf+Si5MOwo2gdLRbJiZe5zlF3
         2NP25nqNL9qMmAbN16NCjtqQFMcFldyEe+IINEgQG1/s5R7sjq6YGlquv4iFiaP5titM
         nPBQ==
X-Gm-Message-State: AOAM533VonnvrVm79dzRsuJqns1MePqLWKS3fmmZp4ePYX6gw1tvkWkG
        Fy3yrcBAvLjIjOvQ+ucd/cJIVjMAizRZPg2y
X-Google-Smtp-Source: ABdhPJzhDv0oO78UZFCG30widyAPbw2nnhtntyVI9/2aYsBtwCMmEEi1IrjGJsz29Z6hx1YupecP+Q==
X-Received: by 2002:a63:1943:: with SMTP id 3mr7640542pgz.141.1620190402979;
        Tue, 04 May 2021 21:53:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gb9sm5433756pjb.7.2021.05.04.21.53.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 May 2021 21:53:22 -0700 (PDT)
Message-ID: <609224c2.1c69fb81.54228.b676@mx.google.com>
Date:   Tue, 04 May 2021 21:53:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.268-4-g5f18e671dfcb7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 50 runs,
 6 regressions (v4.4.268-4-g5f18e671dfcb7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 50 runs, 6 regressions (v4.4.268-4-g5f18e67=
1dfcb7)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.268-4-g5f18e671dfcb7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.268-4-g5f18e671dfcb7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5f18e671dfcb7cb14f239e59821200871d39dd63 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6091ead8975c701b43843f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091ead8975c701b43843=
f1b
        failing since 171 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6091eb053b8997d36b843f19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091eb053b8997d36b843=
f1a
        failing since 171 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6091ead583662df690843f1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091ead583662df690843=
f1e
        failing since 171 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6091eb290b474e28e6843f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091eb290b474e28e6843=
f1b
        failing since 171 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-broonie  | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6091eb074aa62cdf28843f17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091eb074aa62cdf28843=
f18
        failing since 171 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab          | compiler | defconfig          |=
 regressions
--------------------+------+--------------+----------+--------------------+=
------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6091eb4ded4665f745843f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.268=
-4-g5f18e671dfcb7/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091eb4ded4665f745843=
f1d
        failing since 171 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
