Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 226E732B24C
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343564AbhCCAxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345941AbhCBS06 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 13:26:58 -0500
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A38CC06178C
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 10:11:06 -0800 (PST)
Received: by mail-pl1-x633.google.com with SMTP id a24so12471852plm.11
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 10:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9h18Ygf+MTkMgQKRUf0wpwxs6A2VkU3pUbcWM1CjsxA=;
        b=f8XER2wcFa3ihIqjJxd9stykV3cajWy9EMRnRdAMIKpWxTPgADqAkms7HZnKkGsQ7W
         bUvDCFFW4a8qWO08s9IF206Ai8aoH+0tL8oRJbX64TQynTBhy0t2P095aABPInI3Vx5Z
         gGHW5TIyuiNavovvLUOEeGnz21Ks/bAh4Wxgtl2hJdwO1N+6A4Z0EPb0Z5Mt9yb3bHnq
         mJSWBssAOHtSnAs2YVmb6hjSV6Xb0YDkl3xWuEqhsJrzBOVCG3Y57AjqLsonn9wL9F1p
         vKDxrOGN+KtFSx87rh8Fd3+xkawFuj82HLkh6EnonzsGGi5NJV9lXPe5LHFm/jtdupc0
         fbvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9h18Ygf+MTkMgQKRUf0wpwxs6A2VkU3pUbcWM1CjsxA=;
        b=It96Hwp8pzvwcPrrJaF92rTVu38kTUcOznJiF1GaUA9eVDIJ3Jf8Cj4vhcl7BT95tS
         8muAVwRf2nLkX/mXT2hU8mecnOZI6J0WAqk0bxktwkERugPz4pQy6eHI4KWh1sjyn2Uo
         ijAi11seuOCWZJzsUGmhLojm8SkO+jMFVupGtiZIbHwOtV4XY1ypIJMPmkkbkZUeL6BM
         opBP6q56sIUhRzBXuhraODk7XmhrmrS/AsLic1jTYFIRZBNp+/hx78Kevffxr4xWGLqc
         nF2v8bgeDPrPQOuk6nfXAZErKX5sWZHERgOOegSRkIc7tCedt6xqlQjpEo+zvdXnDsFK
         2AXw==
X-Gm-Message-State: AOAM532NJWeOcQzeNzXgM+4IkDAkb29joM4r+4FMMXcOVLlFUGOno/k+
        u3tJQ7dXcJrFIHUZfEpbRbz+hDmqSzLoDQ==
X-Google-Smtp-Source: ABdhPJxtkIxHuJYpRvrp6HF6YYrzpGbXsxNFUbbR2N8xXdLx+1asaNWPB/9YcR2l8m6Ulz0aqzoLcA==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr5449764pjb.62.1614708665743;
        Tue, 02 Mar 2021 10:11:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h14sm280994pjc.37.2021.03.02.10.11.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:11:05 -0800 (PST)
Message-ID: <603e7fb9.1c69fb81.1c999.0bc7@mx.google.com>
Date:   Tue, 02 Mar 2021 10:11:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.258-135-g152775de98842
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 47 runs,
 4 regressions (v4.9.258-135-g152775de98842)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 47 runs, 4 regressions (v4.9.258-135-g152775d=
e98842)

Regressions Summary
-------------------

platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =

qemu_arm-versatilepb       | arm  | lab-broonie     | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-linaro-lkft | gcc-8    | versatile_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.258-135-g152775de98842/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.258-135-g152775de98842
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      152775de988429d0d3d4024712c8111a8b31b546 =



Test Regressions
---------------- =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/603e4e6412dd4bb371addcff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx=
27-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e4e6412dd4bb371add=
d00
        new failure (last pass: v4.9.258-134-g2d3a1aa101bd1) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-broonie     | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e4bf470fc0bbabbaddccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e4bf470fc0bbabbadd=
ccd
        failing since 108 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e4b861bc5ae790faddcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e4b861bc5ae790fadd=
cb2
        failing since 108 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-linaro-lkft | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603e75c756aa6d85eaaddcba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.258-1=
35-g152775de98842/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qe=
mu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603e75c756aa6d85eaadd=
cbb
        failing since 108 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
