Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33B62375462
	for <lists+stable@lfdr.de>; Thu,  6 May 2021 15:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhEFNGB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 May 2021 09:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231839AbhEFNGB (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 May 2021 09:06:01 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FA87C061574
        for <stable@vger.kernel.org>; Thu,  6 May 2021 06:05:03 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id m190so4704784pga.2
        for <stable@vger.kernel.org>; Thu, 06 May 2021 06:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gP4JUHm9+SSQtjSAIHb46sN1VnB4KBv5zq+Xh8NH2r0=;
        b=JuQWl3sSL60wdKvrZr5FiwphmAzo+hEbquPFhoctNrfTW6S3JbyhZqW2+bcVKRMfSf
         LsLvVa/diamy6uth4OsZIGjx6CenzhBVeeMUimpY+jSEv893AoPdJiDZ9LtYO9C69OsT
         HlmtCA2IVfuxZ1DOUasKoFD5PZNt2tOzgJUmQE/1adjVp5+NBadFAUgiGSGHDh9zGUsh
         W7BV+eXtQUJAfjjoLxeJl7DuORxiJWU0cbBERvOqf4pFjOpx0gUsp9i6/uGqWdjYA/1K
         1/KsFLsqcWHFiPW8AXE3xvQuIqqj703vUkyjD1BOtvX9JwQhBXvIZ1VBQkqr96tt99Sf
         uySQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gP4JUHm9+SSQtjSAIHb46sN1VnB4KBv5zq+Xh8NH2r0=;
        b=XB36+a6kh4ioxkGFKRHcBqblx02cgM+lQhxLcm2Pq/ctdGRKPkdHpnBuGjHa+/CQlB
         omXckBFpfAST4Fzl06DLlDLLkchKpWrh1gY3tJgzy4IlFf77GNVGdIgYye94J0Nx/TRV
         0XF63/wHWJ51QaML1g1TAwU2UpisWpNe4aKX4SvcHoGfPYeGLaothS8LTOJy1t8HL2pz
         Wx03uxOxLiz9DP9OceGTjafjyf+JwMlLjFYGGROho7rTQTdA2ENFY+2C7rSw+rNZ0qAi
         anmo4QBaZuwuO79boZTunk78nDMetJFojhHRXxtwV6S32JUss/K51kaURuDhKusW8UfF
         puFg==
X-Gm-Message-State: AOAM531Cy2EBWWa5vKPe1Gd2nZpg/D4Yx9JqYTC2Y4jKJLaoxCNEf8qw
        A5tdXOKS/pF9zSk1kfLKL2acXTVM3kRTz1cv
X-Google-Smtp-Source: ABdhPJx/owaWHWSBYGKl9F2PcrXzOSv7MEaOzBMIpGbfMQBZdBqzEIDvOdZDB7RXY1nykvZdkshjgw==
X-Received: by 2002:a62:30c2:0:b029:289:116c:ec81 with SMTP id w185-20020a6230c20000b0290289116cec81mr4577059pfw.42.1620306302580;
        Thu, 06 May 2021 06:05:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ne20sm2156403pjb.52.2021.05.06.06.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 May 2021 06:05:02 -0700 (PDT)
Message-ID: <6093e97e.1c69fb81.3d6b1.6143@mx.google.com>
Date:   Thu, 06 May 2021 06:05:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-6-g95e2a2bf1fb1
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 57 runs,
 3 regressions (v4.9.268-6-g95e2a2bf1fb1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 57 runs, 3 regressions (v4.9.268-6-g95e2a2bf1=
fb1)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.268-6-g95e2a2bf1fb1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-6-g95e2a2bf1fb1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      95e2a2bf1fb13c35c39343eadfb2e667b834eb46 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093b543c8fe35c5176f5481

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-g95e2a2bf1fb1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-g95e2a2bf1fb1/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093b543c8fe35c5176f5=
482
        failing since 173 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093bb15b4ed825c9b6f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-g95e2a2bf1fb1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-g95e2a2bf1fb1/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093bb15b4ed825c9b6f5=
46b
        failing since 173 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6093b3eede5ccce3a86f5473

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-g95e2a2bf1fb1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
-g95e2a2bf1fb1/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6093b3eede5ccce3a86f5=
474
        failing since 173 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
