Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449B736DD3C
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 18:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231437AbhD1QmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 12:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241073AbhD1QmY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 12:42:24 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA3FEC061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 09:41:37 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id d10so6759600pgf.12
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 09:41:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=I+krMscdYF+YHKokDn/NHne9MeiHkZ/qd2yViQ62feE=;
        b=0AiGtspSQOYyuaLtBaEaqpU4GEejhC5CqwJW0uO6uuK862Cd2QwyoycrtKGuNh56hu
         JOyi0oxFohlNR94TupipNkCF8SDPoQDWMGrmxMnOIH3TTXadD4mXgrzyKJV2ccReoGDm
         RXw4S84CHgiLwvrcUOBSNJprhh7mry+8RUWFRwRhLyurR3KAwpm2XbZy3axCW/XfLqDI
         IhHS/nJOhMPRltlF/9CWT508Nzkyc0EMh9ctYMFwBppLdRPjm8W4dOtorLQgCbMgWRBV
         kazBgUu4TgmEpKAhxfvKsVhYnGiToFBHKpgCOETPV1fkMUDYfkGvX0Ax9Ciy6oS2LRVM
         bWlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=I+krMscdYF+YHKokDn/NHne9MeiHkZ/qd2yViQ62feE=;
        b=qOy2eGEuYyDEqSNrpD8Cl4IF5YJ1+VwOBOadcpAURLBDuwABKyWu/c/837uqnDwTDp
         OM8cUleY3J6cbfGGS9WJVAzVogppcNULFltrPK8vw9VD3ekpeT4G3L/1/3pQrlGneeFV
         k/XvbEsY1GxZQVmqcnR9UHNcvlvUWtdDyGkuwVwX7ZQRTLeQpXfXmw0Cb3VorrgTV4bW
         uZIZpOAqvFdtc+9s6tJL3Xazn0wkxwzK9lyEgFPYGdhiJ1XA8l+THFF8HqLKaPtWuUFh
         ZWjcIu6499tZ/Fxu0O1d+1pr8rPAk4Ah4dvnuedTz8BoleDD912A6fH/Od/BxwG6fbo8
         QOqw==
X-Gm-Message-State: AOAM532FC/zc9T2oEU5Pbuu8N8N07sJor8gEh/SudPJ7QlH14dofcEce
        fkXGINNAeWtkBR9tWqE5WjIwr76diAyRbioL
X-Google-Smtp-Source: ABdhPJxLUqGeKAnXumrFsFa6G/R9MeVFJY0c0i90M1ueUoNOwsWWpW2dGfd8CPvlPoxdVSLPkwdtew==
X-Received: by 2002:a63:4e43:: with SMTP id o3mr27550922pgl.22.1619628097262;
        Wed, 28 Apr 2021 09:41:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x13sm123451pja.3.2021.04.28.09.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 09:41:36 -0700 (PDT)
Message-ID: <60899040.1c69fb81.72e60.0721@mx.google.com>
Date:   Wed, 28 Apr 2021 09:41:36 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.189
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.19.y
Subject: stable/linux-4.19.y baseline: 109 runs, 3 regressions (v4.19.189)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.19.y baseline: 109 runs, 3 regressions (v4.19.189)

Regressions Summary
-------------------

platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =

qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.19.y/kernel=
/v4.19.189/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.19.y
  Describe: v4.19.189
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      97a8651cadce7c2b7c4d8f108b392eff31fe2c08 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895aac0f3a01ec6c9b77b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.189/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.189/=
arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895aac0f3a01ec6c9b7=
7b7
        failing since 160 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895ac50f3a01ec6c9b77f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.189/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.189/=
arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895ac50f3a01ec6c9b7=
7f1
        failing since 160 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895afe3e8fb6d6b69b77b2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.19.y/v4.19.189/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.19.y/v4.19.189/=
arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895afe3e8fb6d6b69b7=
7b3
        failing since 160 days (last pass: v4.19.157, first fail: v4.19.158=
) =

 =20
