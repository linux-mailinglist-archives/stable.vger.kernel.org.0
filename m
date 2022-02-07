Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A41D4AC305
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 16:24:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345375AbiBGPXs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 10:23:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352125AbiBGPTB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 10:19:01 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99A61C0401C1
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 07:19:00 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id qe15so3653431pjb.3
        for <stable@vger.kernel.org>; Mon, 07 Feb 2022 07:19:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fERFE7zsLB1HguLICAgpwJq+RFYVgthPkyo+3v+ioik=;
        b=qFLzG++7BldOJ2DskTh0BQ3C+NAPFeEpP//OjDGtCvbFdiJkS85E0NZuwY+ReSf3tj
         2O3xMI9rzA7l99lupVVmSzJ8Mi77aQSGn6ChoJqjS6VyndT66TeNiUHu9rWYJitm9aZL
         iG9g0guKbWQMqtm7F/+RtcmyVc4uVV/4RHk/bSNQyH/8nLvD33emjpEedtsVY+RaP4H+
         FyxHzlMZFYL3iIjP/oMFLNOROsv0tCpQ4vi/T3eb6yskTiEDXoYTEmQ7jhWDCTt/c5Y4
         t2RveFSU8El7alVq0PQpXFp+gjTUI6MdY+T8HY3srbNUwnYJ1vBl3GNOxRW0p3oue4dp
         3FdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fERFE7zsLB1HguLICAgpwJq+RFYVgthPkyo+3v+ioik=;
        b=sVwIQNm1HkOqS3cMqtR3gwQXPPShEBXpvXSFATRfmcwcFIthoUvSnn9YJTgawEdpcl
         BMHXSDGT4ozeWpBrkgxHlg7VZgTmPv2A8ZpvnNOK2OkXN33oEcUY+rKO2puNjV1fVYer
         LigtqP3FKsO3KGRzCiYZAFOQmxFuvRZm0Nn1jFYr3jw4RwJWd3c7ArvWnFTVFs3iaHLb
         8wTovsgOkYsukvR/yLh9zdVz1cpJE4qkrsXTeYXGC0V8brIB9sEP4UG6R3tiYXri6tMh
         +MLveJkDx9Hdij6U69zN18Lvg7GxqkfMM6Gsbqtg/E8fh6as5F4lUvgJj3LEerbkoVyv
         eqKw==
X-Gm-Message-State: AOAM533SZ4nUzSM1G6QU8Sa1ys4+XcvzYVR9ow5ESdJpOJ51XRLVAwCL
        iDIzDtFnsdj6/Uu/giRjz3ao1w7U9l7oNtDD
X-Google-Smtp-Source: ABdhPJweHJoL9s7FDDh0kpyZjiMmQ/bL9gqpsAe2tMA5kglqg0fsVdmfHYOlkEoWd252Dk3W11R82w==
X-Received: by 2002:a17:903:40c2:: with SMTP id t2mr177140pld.143.1644247139901;
        Mon, 07 Feb 2022 07:18:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e19sm9386591pjr.50.2022.02.07.07.18.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 07:18:59 -0800 (PST)
Message-ID: <62013863.1c69fb81.5f9d5.6ce3@mx.google.com>
Date:   Mon, 07 Feb 2022 07:18:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.177-44-g371031e009cf
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 113 runs,
 4 regressions (v5.4.177-44-g371031e009cf)
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

stable-rc/queue/5.4 baseline: 113 runs, 4 regressions (v5.4.177-44-g371031e=
009cf)

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
el/v5.4.177-44-g371031e009cf/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.177-44-g371031e009cf
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      371031e009cfd20ed522e03847cd883a782b9acd =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6201067f7e271b13555d6f26

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6201067f7e271b13555d6=
f27
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6201066ebbebdf10625d6ef5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6201066ebbebdf10625d6=
ef6
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/62010652f41d1b5d825d6f05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62010652f41d1b5d825d6=
f06
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6201066d57363d89cd5d6f1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.177-4=
4-g371031e009cf/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6201066d57363d89cd5d6=
f1d
        failing since 53 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
