Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327CC3A3D1C
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 09:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231345AbhFKHap (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Jun 2021 03:30:45 -0400
Received: from mail-pj1-f51.google.com ([209.85.216.51]:43864 "EHLO
        mail-pj1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbhFKHao (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Jun 2021 03:30:44 -0400
Received: by mail-pj1-f51.google.com with SMTP id x21-20020a17090aa395b029016e25313bfcso5493025pjp.2
        for <stable@vger.kernel.org>; Fri, 11 Jun 2021 00:28:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pg6N8/JBllTSdUyBSA1GJ/p2CkTO9SunM8m5oeXbWrE=;
        b=KybmWa/sKbqcjm5nIdckYHFZ7hkHNGwyToYYUAZcUFko5Od6SRzox+aQN+A7AFs4Rf
         fo5j1PvC+tG0KTVtAPCPp1kXeRTJyuhlzy6ozYGZhPPxqNwLbi9YM2XIBDCX1tN8F9Ag
         30RrtqYpkkbuVcsjGmU2Hdj0XqYrzVKHQyPysKFgOhPmN2xk1spg5fzB3q87vwWDEl/q
         MMpDqnRMa95J/KMy42FlKUILhjUTCWpco+07vTTxeb0AqJbUroc+LUsoUu0aP1kB8E7C
         Yv0YxAE6TaHFV/gRulMz/o1FAEiUm8h9UFEc7wKxGnguNgWnSCfj1r/es+LIVHwruh0v
         MSrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pg6N8/JBllTSdUyBSA1GJ/p2CkTO9SunM8m5oeXbWrE=;
        b=sJaLvMR3L3ulHvdvSkFS9kDSGCdV7n1jgeFybbcYaocZTfITXQ/2bVTqjUUrewNIA0
         +oJ1d1uAm4zgweVtqUEa+ol7vSI7mq3wGegJGnp5/csajmToYAZds2/6QI1QqhTRCZXF
         ORjoW3FrgIPenRTuwstLimUbg+n9iId0Wao0CR63yZH7W59NgEO4kj2QuGh+Pi+HjcCP
         n02UCXHyGh0z1u0ZLgDi7+JtCr0mp+Trsn+fLnZCfOS+ov04irURk02kJcCJK+jVSwtm
         yHDZ9nXdypvPntRp0CjtXovgwciYmt5EdMkgsrFzTVMgZVdE3Sv9rIlMtNFzMcoXPfWN
         LSWA==
X-Gm-Message-State: AOAM531FwqtEQAf6lyLTol1OtdSPw2PjC/OEOV4U30j2x4rDb4jbxvRh
        iw16mhm3FghE+B7tM+za9hnm0AJMslwJiyEu
X-Google-Smtp-Source: ABdhPJw0nlVF5hAXjQu6wZnOdEt0h7iKf3AD8n/jLiS+gCt/6O5z6ggChRBSs3kC7dozwZ6mW8IqYA==
X-Received: by 2002:a17:90a:4e0f:: with SMTP id n15mr7629307pjh.167.1623396466536;
        Fri, 11 Jun 2021 00:27:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w23sm4207676pfi.220.2021.06.11.00.27.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Jun 2021 00:27:46 -0700 (PDT)
Message-ID: <60c31072.1c69fb81.df4c1.d861@mx.google.com>
Date:   Fri, 11 Jun 2021 00:27:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.272-20-geff1f01813e9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 94 runs,
 3 regressions (v4.9.272-20-geff1f01813e9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 94 runs, 3 regressions (v4.9.272-20-geff1f018=
13e9)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.272-20-geff1f01813e9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.272-20-geff1f01813e9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eff1f01813e9db08dd532e4c487da42616a90170 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2de2d6a4f0206e50c0e13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-geff1f01813e9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-geff1f01813e9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2de2d6a4f0206e50c0=
e14
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2df31875f54b6580c0e13

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-geff1f01813e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-geff1f01813e9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2df31875f54b6580c0=
e14
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60c2de40af76b20a660c0dfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-geff1f01813e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.272-2=
0-geff1f01813e9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60c2de40af76b20a660c0=
dfc
        failing since 209 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
