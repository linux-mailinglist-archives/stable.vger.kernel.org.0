Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 026983BA6A5
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 03:36:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230353AbhGCBim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Jul 2021 21:38:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230017AbhGCBim (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Jul 2021 21:38:42 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84988C061762
        for <stable@vger.kernel.org>; Fri,  2 Jul 2021 18:36:08 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id 67-20020a17090a0fc9b02901725ed49016so4533828pjz.1
        for <stable@vger.kernel.org>; Fri, 02 Jul 2021 18:36:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fLWSGAAYGjV8iafNY4MrOVJD9ZQyHE5Blv54aZeLxFw=;
        b=xnCtBnjaaxlQ9VA88f8NbF+pFbVYkoq+HRQA5BHJ6d4yvk3nF8TQ0UzeSNPYUpXQ5l
         UMCLHu3H9Swh1NIZXPrkyxwR0l/Q/4jTLc8Tj076PIvngwtCr4aCsu95Cqd+8vQF7dCN
         piB6h9rD9XgfPmCXawwDT7rBXsInmofIr0yaQ2GgaU6w0eMmLyQMJ/4mTl6pJo961JnI
         BRx31KrU5TZtn9WI2eRjMdyevcKBvX2MTVX41W9SAG1rWjxpRjbhKO7XhanCnhTmdthY
         kPpKtounDKub6r+HrSAeDl+HmeyjvjP0O89WFkWDFJgY1y078sKc6Eh5msKtNRmnlRXA
         seGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fLWSGAAYGjV8iafNY4MrOVJD9ZQyHE5Blv54aZeLxFw=;
        b=F/3+x++/QuzvI0iAgBou1H14/ZK4nw1AM4ibTtl5SiaXVFjx196o9KycLy+Ey48t7o
         EHTpAOp/QMKe5zE7aajLeXZ77PVXhu0kLHY3fYgErPtUmFgeXiRX4FEpV9psAIqiA+P7
         1EZ9juUL74cvHQk7MIOEPAllaxqTJdZReWJlNuwmqNC1wzZRMQq6EixLshiAl5bK28G+
         /IAe/gX9/wClXYERvZqXedUSjONe/F/Bi7mzHJBOQt9TKvpIJH44WnharmnasOkOAN1+
         mCBgoXSIoO83NQKrqnOAWQ4BkQXynN75TKdmW5YAlE8T8uAy/0uu+4rXuR7BC/P/NWuJ
         pLnA==
X-Gm-Message-State: AOAM532gvXDRFyXCTU/0HFd8xSbDiQzcYpii7w4dlbrNEHtVLQpAhj++
        1rBRnjagyPkdRgkpp7W9d3uj2UXYATVJPvxb
X-Google-Smtp-Source: ABdhPJyRrVvivXMOoo//CwdViAEYUe0q6s1pIODMeQ3ED407x3kMUKVFod6bq2ICHubsov6eQyfNaQ==
X-Received: by 2002:a17:902:d4c2:b029:118:7b47:e5bf with SMTP id o2-20020a170902d4c2b02901187b47e5bfmr2160843plg.9.1625276167758;
        Fri, 02 Jul 2021 18:36:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h18sm5506928pgl.87.2021.07.02.18.36.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 18:36:07 -0700 (PDT)
Message-ID: <60dfbf07.1c69fb81.4bedd.423f@mx.google.com>
Date:   Fri, 02 Jul 2021 18:36:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.274-4-gc53600c5769e
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 147 runs,
 6 regressions (v4.9.274-4-gc53600c5769e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 147 runs, 6 regressions (v4.9.274-4-gc53600c5=
769e)

Regressions Summary
-------------------

platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =

qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.274-4-gc53600c5769e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.274-4-gc53600c5769e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c53600c5769e0bc30904082456d4d630bad5627d =



Test Regressions
---------------- =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-baylibre    | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60df88fe552b74ec9911797c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df88fe552b74ec99117=
97d
        failing since 230 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-broonie     | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60df93b48bff1752ee11796a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df93b48bff1752ee117=
96b
        failing since 230 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-cip         | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60df89001ac675d7e211796d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df89001ac675d7e2117=
96e
        failing since 230 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-collabora   | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60df90d81d68b8a0f611796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df90d81d68b8a0f6117=
96f
        failing since 230 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_arm-versatilepb | arm    | lab-linaro-lkft | gcc-8    | versatile_defc=
onfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/60df8f280716669ffe11796e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df8f280716669ffe117=
96f
        failing since 230 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch   | lab             | compiler | defconfig     =
               | regressions
---------------------+--------+-----------------+----------+---------------=
---------------+------------
qemu_x86_64-uefi     | x86_64 | lab-broonie     | gcc-8    | x86_64_defcon.=
..6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/60df94b8c5efd36690117a1c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/bas=
eline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.274-4=
-gc53600c5769e/x86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-broonie/bas=
eline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60df94b8c5efd36690117=
a1d
        new failure (last pass: v4.9.274-4-gb83b4e4da787) =

 =20
