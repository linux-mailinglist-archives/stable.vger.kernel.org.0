Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE53F370DCE
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 18:11:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbhEBQMp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 12:12:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230110AbhEBQMp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 2 May 2021 12:12:45 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25B2FC06174A
        for <stable@vger.kernel.org>; Sun,  2 May 2021 09:11:54 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id h11so2524795pfn.0
        for <stable@vger.kernel.org>; Sun, 02 May 2021 09:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=itNIGCTZZUtsd8PupYmc9/1A4bNNOdM2iO6c1PpWgk4=;
        b=EV0P6wxQ/bvpmvY2KEPhjMH1+b6FL7tfgXz+BtWn0ocTcU2LDMnudT3kw1EIdAKoZR
         t8/fOLV+RyyD/Nx3ni3sFWmjN30Jxw7G0vordaFTZq+ZrDlf7RhTtC00Zydf01Y5mIsO
         oYv9H5hj3yyTRL+1l60A2WWy5/0gf3Xhj6Tk94hvvLKoLcgLco30q3V+ZCK/eEfmg3iq
         rXt8HS8te0Bj454bMgmDc4+eh0ALTFQEJH+ex+WzVqmRBNFAzXuGWKowchzFvUsw63SR
         NSd7j5FVjbWLXRLO37hvJCfOol1q+oeCbNBRAp+lQee/wgwwyJBCZAy5lOAfoNYXBb6a
         6OiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=itNIGCTZZUtsd8PupYmc9/1A4bNNOdM2iO6c1PpWgk4=;
        b=prASXOXBSE0Upb/MvW91JgHNqBHTlyGKEQ4eOfxN93blMiPQlfn+2vVOgCphV0NpJA
         s73T/P65XHVKHTaMyNk6eokQixr8bdD8ruJPj6rsx92UNR6Rm8XvUxPyPntJp3uCojCU
         gTvh1kZIFVdA7xfqM0z7EQybUVB37geL5s1KKT0Ia2ZsjIdeOPl/8Ko6ZrJ/wsLd80Bl
         pc9HutqJ/qmH70/5vKwY+ZFGxoARcoG+Ql/VEsePzK2oMk0j/k7SRP/q/Ped6B+dgXep
         0zQ3TxOlF4EdjHNv6wcu5t1f1LmbpEHRclHa5gK2RL4yvLkDtW0jgT2X5TZzM2a0hgsK
         gwGw==
X-Gm-Message-State: AOAM533YvvJqPbnAHtyF4TZ4U+ikWBUeXa7bYLN7R2N5B3L4rsbjggJq
        KgQVmxIG2Kv5YrhEOjUVT3L5+lPWRqmvEmSi
X-Google-Smtp-Source: ABdhPJyx6ryI2a8XrEE40aJOnRb+jfbRHXMx9mP7ZxfFyZ442SGmNa69l9SUapmkFrQe+j6mGN/Wuw==
X-Received: by 2002:aa7:8703:0:b029:261:4680:9723 with SMTP id b3-20020aa787030000b029026146809723mr14733730pfo.70.1619971913457;
        Sun, 02 May 2021 09:11:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm6973486pjk.31.2021.05.02.09.11.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 May 2021 09:11:53 -0700 (PDT)
Message-ID: <608ecf49.1c69fb81.20d67.2490@mx.google.com>
Date:   Sun, 02 May 2021 09:11:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.116
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.4.y
Subject: stable/linux-5.4.y baseline: 16 runs, 4 regressions (v5.4.116)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 16 runs, 4 regressions (v5.4.116)

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

qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.116/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.116
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      370636ffbb8695e6af549011ad91a048c8cab267 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608e77bc843be9a86a9b77b3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608e77bc843be9a86a9b7=
7b4
        failing since 164 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608e7836ef6b222e2b9b77ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608e7836ef6b222e2b9b7=
7ac
        failing since 164 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-collabora   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608ea5840afa40a31f9b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608ea5840afa40a31f9b7=
796
        failing since 164 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/608e77376f28c0aa809b77d0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.116/ar=
m/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu_arm-versatilepb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608e77376f28c0aa809b7=
7d1
        failing since 164 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
