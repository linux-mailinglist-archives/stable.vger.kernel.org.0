Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33FC840CFC0
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 00:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbhIOW4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Sep 2021 18:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231197AbhIOW4m (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Sep 2021 18:56:42 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B3DC061574
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 15:55:23 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id nn5-20020a17090b38c500b0019af1c4b31fso3339344pjb.3
        for <stable@vger.kernel.org>; Wed, 15 Sep 2021 15:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yZ2/K9F/g66OcGqC1vOdX/ayQpYvCMvBul7P/Gb3JK8=;
        b=RSAjYKZE3dO7oSuqNDhnL/AwBwMywODHON1tCxcXIrMRPzURiPF0sS8qTANYCqV6LS
         dbI3/jysrC5UaMZp+X5CeneSkjfSg8aoIK+aKMgt+gFmkDwoidCAs/aK/EyXqSaZnSRw
         7l14hGKrchQEUDXRsZ/44+q0oZ9eoWvQIK3LgxK3dP42ij+45JY2pCiZm8MRsRvEOxdB
         dlv9bbPyu5CeNxm6G+9VH/oAqRbC7BxNxlxj6IjxvbHng9Jdbuww1XxjWqQc5I7nN5Kl
         PcHc8QfUX21Os9m/0MFDsXhUsRCL2GAxDhVMPJO2Hqbtthj5iIc8/0s77WptJysadO0G
         o7LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yZ2/K9F/g66OcGqC1vOdX/ayQpYvCMvBul7P/Gb3JK8=;
        b=ll0glMxHhiBcGsGFki/ZA4aly86Lr2RTPfsIV0H8VFZY5i8v0OOO7PQ9jg4iobkCwK
         uR/MrUs4tK9gOuNCdYCI4lQxxNZFQscyk0cGjPxKlwmboLoC3yGX/dPNsLWvzoTyuBxy
         14dxfeojMoEPdYdzu6wlNFqNrBb3Ag0TbKyNN9lsPLkctylsr3omyXvsr8TVoGfS1bs0
         kDUMsTJ/2QDf/N1apNguQIOnUKv29GVv5zDczS9eRkR8w6pJncJGAfjzKquIz2WnHoFi
         K5bSev9+TVQtlhgP3MMX2ZpTqhS67wjpYLuAwVi+BzSPESrMzUI/MJn7ushGZ/IZZitg
         pK5Q==
X-Gm-Message-State: AOAM533+pj05gSkaZQCppY/ucB6maKMadmAfqzhClBA4jTA0gBrRrnsj
        4AVPvROxwgydtVnpprykb/JgoBKtCmXZgyrd
X-Google-Smtp-Source: ABdhPJyZwH3klNneGX3KA9vW46g6b5TcuhKSdSgm7f6yaZYwbSnI/diUkhK1Y2YJ6oPRIvW6gcFM+Q==
X-Received: by 2002:a17:90b:3805:: with SMTP id mq5mr10346214pjb.143.1631746522941;
        Wed, 15 Sep 2021 15:55:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm791798pfl.41.2021.09.15.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Sep 2021 15:55:22 -0700 (PDT)
Message-ID: <614279da.1c69fb81.1ab5b.3f3f@mx.google.com>
Date:   Wed, 15 Sep 2021 15:55:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.282-102-g588ed610887d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 97 runs,
 4 regressions (v4.9.282-102-g588ed610887d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 97 runs, 4 regressions (v4.9.282-102-g588ed61=
0887d)

Regressions Summary
-------------------

platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.282-102-g588ed610887d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.282-102-g588ed610887d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      588ed610887d71c891c8c731f28abdcae0a6ea97 =



Test Regressions
---------------- =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614244a28e791e8d3599a305

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614244a28e791e8d3599a=
306
        failing since 305 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614244922a59cc0e0a99a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614244922a59cc0e0a99a=
2df
        failing since 305 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm    | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/614244487a2afe28d199a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614244487a2afe28d199a=
2f1
        failing since 305 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab           | compiler | defconfig       =
    | regressions
---------------------+--------+---------------+----------+-----------------=
----+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie   | gcc-8    | x86_64_defconfig=
    | 1          =


  Details:     https://kernelci.org/test/plan/id/61424953b099a5378399a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.282-1=
02-g588ed610887d/x86_64/x86_64_defconfig/gcc-8/lab-broonie/baseline-qemu_x8=
6_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61424953b099a5378399a=
2de
        new failure (last pass: v4.9.282-89-g5cf7788f31f5) =

 =20
