Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AD842CB51
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 22:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229548AbhJMUtO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 16:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJMUtN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 16:49:13 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19476C061570
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 13:47:10 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id na16-20020a17090b4c1000b0019f5bb661f9so3251551pjb.0
        for <stable@vger.kernel.org>; Wed, 13 Oct 2021 13:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=uFF5az4Bu4MMxdY4ePSalWcBQK8RvqfPZZKjd99eyB0=;
        b=ElM59ZTTz5aK2/8g1DbKAk4avlMsAYJH8tnLgl73tfWArWKWJPsG6jSJTpmMYO/Ukr
         GiJetsL1/ylJt46G8urIrjbBX8wy9AZ6wXDvinH7hKW3nDDQlewUMgsIqEUL640cmbvM
         E9EJg19QljHFesjzhWecN0uJa4XI80AOB1OOPBrNFh2EAnAln606jbV+s9rM4s+dwYbf
         IbKPpEUG3wBAX341H4bFbg3sItrgsGKsk4AWqEqFvJwkiiQ0Kh/e5CiMyGRBFOnYJzJV
         HP+McoGoD6MBYji6iU5htCG9LvuuGQqDv40v9x/l2kVxn4nfrb77JWOwByHq3EJel9gd
         tmMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=uFF5az4Bu4MMxdY4ePSalWcBQK8RvqfPZZKjd99eyB0=;
        b=m6YmF0wwllWFhpXewam0XG4MaVp6sjXJg1uPjz5BqlhCbwh/V5EWp4M3vh94t+0Ahk
         OM6VeIWPvohfmykBQwjve20RbhACFhbvDX9FHW/VD/X9f8BZsjjVinIHhN3c9DfC3JsB
         UtXtV5SVz6Wlittm0xzEWHrcfQ8+WyNg6Lv55JIqqhniiWFd9+T8mApk11vJPO9f/e4e
         8Gn/D1+dPbdRo6HDES/rYBfvTD6Ztre97VlVecGnehPOuYeAlRT0gAIp8OkA4+Jt+qcv
         BkrsnRMWndLd8M1RCsSX0aCcsyu17wcjJcXbm3+p7K+u9Q4x5ym5DXRernvEj1lSzfjy
         Q0qA==
X-Gm-Message-State: AOAM530Ri5PBDupIL79FmBtkJ2tR8DGNXB+UCflGf/CPHJRHc5xIWVv1
        LhE2HW+7GgZAKqNb97GTjdNBGOwpEYxd6Cns
X-Google-Smtp-Source: ABdhPJz5dLbwjCVaC0utjW65rZKZXTsfB+3FLkLygRrL+V8/3ezRmqZ7DLCa/REN7Ixc/kGslHUQcw==
X-Received: by 2002:a17:902:780f:b0:13a:3a88:f4cb with SMTP id p15-20020a170902780f00b0013a3a88f4cbmr1351574pll.68.1634158029434;
        Wed, 13 Oct 2021 13:47:09 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n9sm6722895pjk.3.2021.10.13.13.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 13:47:09 -0700 (PDT)
Message-ID: <616745cd.1c69fb81.e5d47.4b22@mx.google.com>
Date:   Wed, 13 Oct 2021 13:47:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.153
Subject: stable/linux-5.4.y baseline: 91 runs, 4 regressions (v5.4.153)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 91 runs, 4 regressions (v5.4.153)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.153/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.153
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      940a14a7d844386c72f449045080dbbd86d1d244 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
hifive-unleashed-a00 | riscv | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/616708f0ef5ef6134708faae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ri=
scv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616708f0ef5ef6134708f=
aaf
        failing since 61 days (last pass: v5.4.139, first fail: v5.4.140) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616706c2647ca852d008fab4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616706c2647ca852d008f=
ab5
        failing since 328 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-broonie  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616706c923d64201f508faae

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ar=
m/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616706c923d64201f508f=
aaf
        failing since 328 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/616706cb647ca852d008faba

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.153/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616706cb647ca852d008f=
abb
        failing since 328 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
