Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B90431394
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 11:36:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbhJRJil (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 05:38:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231213AbhJRJil (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 05:38:41 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E63C06161C
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 02:36:30 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id m14so14255267pfc.9
        for <stable@vger.kernel.org>; Mon, 18 Oct 2021 02:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VvXug8NLFeOC0eC5jPGfWmbumkE841scNkDypD4Y3KM=;
        b=iMgOEkHGRi964ASSoonBxzq0HQjqtQNo1BQSnAcL8rhriHWTFvD0wWSIEtRWXq3s88
         wu3uG5xb/4UbkpvgKrgH4mTr308gw0LD1dz7kYGmzFOmHpoygEWyl0A4gXoCVn2JcEGz
         EZ08tDsC3L+/Gu5E0g0kk1gQnpGIftiDmuQbeN2g/fquyUrlPkU+X/q1HCnCaiCpLXjh
         MF3hZrGRUMSgHO2uf3G0bpxvta2Y0z4DhuhD7BQKoqNvTt7fVIU3QgTgDA+yioivso9B
         5QMHOe5VVBuwFyocnQh/HV5fXmrSD/dK0CvqjrVx4wk+2cgH+W3RjvjR/zpiuKt3xMSJ
         qLjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VvXug8NLFeOC0eC5jPGfWmbumkE841scNkDypD4Y3KM=;
        b=Q1hNSTUItm0ZpYzPchzQNDa+ohNcD/+oARoa2Mg5m1y15AuorxSDfsaSYMx1Bj24Gj
         mH4BRv/DgGVR4NG9+gA3KsXZ/23KQk5g3QcRCKDUZpGS4PSu8bUjwt5XYJOH+nyj6tEu
         /a+2kMuGUxc/h8j7MpnKnR9JF53Nf7XrDipuft4Sk155IVsRGavD43mlgqVxEx4aE8gf
         3gvveQUNSOYUuc48/KZCDfq4OMtXRb/N9aq3Q2H+RcpWS+kdu7cCb5T5gBrVXcLrvI1k
         VtcVGj2CEr+IpHQaeZ4i9owHYWtwqpRNO7+4hD1B2I/v+ivi3RN6BnVrCAHHQ03Yhvzd
         L72A==
X-Gm-Message-State: AOAM533FlxzF8KTUcQ1veQNDmB/MVuVY+wuOMgyOJNp0UZBe07yxx+qw
        /2vVv1NECslNezA93mXdbEPuL9R5B/c49D7G
X-Google-Smtp-Source: ABdhPJySfdWzaAc4tE0sDHlDnuIhpMICMPYNpgyY5VfEUJp3bl8+eFkkFtXx1LRMen/0Xfm+L5SmRA==
X-Received: by 2002:a05:6a00:1950:b0:44d:9402:3396 with SMTP id s16-20020a056a00195000b0044d94023396mr20827336pfk.70.1634549789910;
        Mon, 18 Oct 2021 02:36:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13sm12840744pfc.10.2021.10.18.02.36.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 02:36:29 -0700 (PDT)
Message-ID: <616d401d.1c69fb81.ebff1.3b31@mx.google.com>
Date:   Mon, 18 Oct 2021 02:36:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.286-29-g41084917ca47
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.9.y baseline: 70 runs,
 3 regressions (v4.9.286-29-g41084917ca47)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 70 runs, 3 regressions (v4.9.286-29-g410849=
17ca47)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.286-29-g41084917ca47/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.286-29-g41084917ca47
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41084917ca47ee6ac81786261afbab9b3523df5f =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d059f35c14b90153358e2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-29-g41084917ca47/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-29-g41084917ca47/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d059f35c14b9015335=
8e3
        failing since 337 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d09cad60afa6fae3358f4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-29-g41084917ca47/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-29-g41084917ca47/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d09cad60afa6fae335=
8f5
        failing since 337 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/616d05730d2806377a3358ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-29-g41084917ca47/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.286=
-29-g41084917ca47/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616d05730d2806377a335=
8ef
        failing since 337 days (last pass: v4.9.243-17-g9c24315b745a0, firs=
t fail: v4.9.243-26-g7b603f689c1c) =

 =20
