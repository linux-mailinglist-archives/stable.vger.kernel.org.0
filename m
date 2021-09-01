Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B69A3FE441
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 22:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232770AbhIAUsU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 16:48:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232199AbhIAUsT (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 16:48:19 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F4B5C061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 13:47:22 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id m17so418977plc.6
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 13:47:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YNRL4pwQJnGfNlgjOLhMB4irEn82FQcFofwtf0aHYSs=;
        b=0RWtI8MzY0w6ZzW4V++mU8Qi2p7vZWx5RVHnQ+Wk2CnRFMh8SyKaxu6zaJZBqNwhka
         +1T7HFDWg+lo+SezMEf06s6MAmHaXlvFWcrIjNxgeqDGLPY8onZseU79KG/0OZw8kqfw
         uTYGBoVR4m0PkCzU7qb/ACfpvltygEYu3WNw5VhXIkPK6YSniDalcL0YplJNB3ttRbE1
         UEYtLk6TwzOY4uuX3tTQw6upEGKFoRPYBJSDYTRtaImNxkN1U5anBiwlRHiLDqGAPO2Y
         b8mnd4MSiPO+Zhj/fk/KTGH+CRLZXFTUIJ9utyyxwwulbHNR7OmsBH+hL6batkaSCXbK
         44xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YNRL4pwQJnGfNlgjOLhMB4irEn82FQcFofwtf0aHYSs=;
        b=YPZ7fyyvOWB8aV+GUVlIN4J+9GQIw+UW1D20i9/fcUMzTRXCHuU6m8ghBTM4rd9b8y
         X0Hlu056tyCu+pc2tlcWrJsC4+WWdkaux86xeNvAjnsg+zEn5JqnwyhO9KPWrQXZkhTh
         A4kaD5nSJ+BnGK97UCNK1Oy6Q/OLx+3w3tV93w0zRe+ns/NSWFSHth/QVTLJ3Vo9Es81
         BOAIhqhfeb6qEu/u+9Ks5uHFs0hLktk8q9+VEa1iFbiZ1LcIyzWey8dXHVe3unSDwdYu
         GxW1qluzwk7/GYkGoAaTQeOUop56T6OmzeulBGU9XThdml5ibCJJGIS0lgkAy3ru3nFx
         Nzxw==
X-Gm-Message-State: AOAM533kwnYmgDmn4S54IyG/lcWQ+MAVWPVB0TuXS62ZUrs25LEdDKNI
        9xtxPeOfgU5hiSohI7NLonHXasFE+5TNnpeHsKU=
X-Google-Smtp-Source: ABdhPJwNkwKcQo9THxjfCPdigEFV7tLSepGda6erTjIn13rliJeyIcgQWfhEKZVXeaFfn9M+zVobNg==
X-Received: by 2002:a17:90a:d197:: with SMTP id fu23mr1192133pjb.171.1630529241916;
        Wed, 01 Sep 2021 13:47:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n11sm376358pjh.23.2021.09.01.13.47.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 13:47:21 -0700 (PDT)
Message-ID: <612fe6d9.1c69fb81.39ba1.1aaf@mx.google.com>
Date:   Wed, 01 Sep 2021 13:47:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.281-16-gd0dca5342ccc
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 4 regressions (v4.9.281-16-gd0dca5342ccc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 4 regressions (v4.9.281-16-gd0dca53=
42ccc)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.281-16-gd0dca5342ccc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-16-gd0dca5342ccc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d0dca5342cccb425e41c08fd4d14b9b5f7efe982 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612facff9fca8ed184d59671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612facff9fca8ed184d59=
672
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fb25d9f0540b994d59666

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fb25d9f0540b994d59=
667
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612fad9fc17fa9052fd59691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612fad9fc17fa9052fd59=
692
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/612faf63f89b7a4388d596ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
6-gd0dca5342ccc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612faf63f89b7a4388d59=
6ac
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
