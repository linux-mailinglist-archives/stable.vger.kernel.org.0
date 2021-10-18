Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30EA430D3F
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 03:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344888AbhJRBIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 Oct 2021 21:08:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344765AbhJRBIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 Oct 2021 21:08:54 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CA0CC06161C
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 18:06:44 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id v20so10082744plo.7
        for <stable@vger.kernel.org>; Sun, 17 Oct 2021 18:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=iUJ8V3ivcPJJI2/q987iSsPouz11F/y8CBQ5rdnPQCY=;
        b=xVQklH2Z/Dcj4kVAfEY4Uf7aPa+N/4WFVLe5MybxFp2Db5Rj2uG2+nPMyoERf9XAI3
         SfFTOQm7DxRzyRKXLm4ZMZ+xGbbXJgbzfWwSVeNiY9WJEzy46/ymUdVu9V5ylfHrFtXr
         P60BUKtE+CjvXtmQRz2LeYBHQ5jGSjjQpG80uDTESUMUduVZVG3LPFjL1SJsnVZs11Iq
         uUQsxOR2mxDh1b7mfDdne4aAj076Pq7AcXAoc8JbO4G3xVXwKr2oE5jhi3It+QP1WLmh
         KdeMFgs4U80SuuJ3ytXMQNCbfxlC3iuXeiukGmzJUVL+jvj08zcyl7oTJcCHEmEGKnIT
         Rvkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=iUJ8V3ivcPJJI2/q987iSsPouz11F/y8CBQ5rdnPQCY=;
        b=Ygy7eDC7tlxXdW0yp0Nj2xqU6qSSiel61VBQ3ely/v3r5sazt1yErwah/5G/NJR2ZW
         msNzF4d6vO/W4WgJB5qNhvS1pBL4C6fbGGSfkrqMjTdrBR7ujXehWqr6P+K4JS+nzW2q
         j6HVac1dyU0Ks5wnpubWZQP9urVS3jG3EGgccUa3bx0S1fkHO9PYfZCysoam0lBmNWnm
         OYpbbd7yz8lq4FZB+SEQXnhDpFaN2wjsDovD0aWnUiGLWDjLx6poZLl/zswrrBj7xAzV
         XFgfz3fyv36ZG8jL70qcvJWF9gcspcR5n1fsyMtyYcgreXmd/uL77MuI3pp+/UdnUt0b
         6VxA==
X-Gm-Message-State: AOAM5331Ka9rn6Z9G216Aao/yTdBevhA2CcGUJKgmivaCs8YUPCt0a3I
        b5zxhbH1d/sq0z3ZOHvNxNL7G1tcBqxC0/K1
X-Google-Smtp-Source: ABdhPJxMchRVhuyRf198hau0k7A9FLE1jjogpLQmXTSUU97HYMC6cMTrZYEgxP9VLGbiiLjI9Z0Zbg==
X-Received: by 2002:a17:902:c1cb:b0:13f:8e99:2158 with SMTP id c11-20020a170902c1cb00b0013f8e992158mr17728080plc.32.1634519203661;
        Sun, 17 Oct 2021 18:06:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2sm10849636pfi.120.2021.10.17.18.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Oct 2021 18:06:43 -0700 (PDT)
Message-ID: <616cc8a3.1c69fb81.6b16.f120@mx.google.com>
Date:   Sun, 17 Oct 2021 18:06:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-28-gc22893321afb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 104 runs,
 4 regressions (v4.9.286-28-gc22893321afb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 104 runs, 4 regressions (v4.9.286-28-gc228933=
21afb)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.286-28-gc22893321afb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.286-28-gc22893321afb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c22893321afb7437d8a5acf317eca77b53c20eca =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c8dad7e8b81f5f33358f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c8dad7e8b81f5f3335=
8f1
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c9c79e35f21ce04335905

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c9c79e35f21ce04335=
906
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616c8cd10c65d9c2aa3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616c8cd10c65d9c2aa335=
8ed
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/616cb9a4178ac12d05335914

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.286-2=
8-gc22893321afb/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616cb9a5178ac12d05335=
915
        failing since 337 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
