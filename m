Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CF263748BF
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 21:35:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232878AbhEETgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 15:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232858AbhEETga (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 15:36:30 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9481DC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 12:35:31 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id c21so2518846pgg.3
        for <stable@vger.kernel.org>; Wed, 05 May 2021 12:35:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=k8JHVwUZte5lxdMlYqJdYFiG16BchDDz3hY+wOvNwKM=;
        b=tUNtpVqWhiLORTrHE/zE+466TNkpDPaChw9nLvuXTBRuN7jN4dyN25RcYWhGCFOI3y
         Pd0oujhqxdsSVOBK7uQjRcNHu6+LmwElfXmqG4uVpA/Z0te/9567uA8XAUCF7J93OCDl
         jUArEgq7ABC+R67DBUqRveZaDz37gGi1uDLYnJaFpfHm+TSWyaGMMwEiazPcVe305dyM
         cRfIuD2bDy+SQP+4n0J6ga3VRDl6fkmFcMPTiNVWL1IYNoeAdfcE86gk6VY9dhtVRwv3
         h/i+LE2qOB2sc/lgnkzMKZJ5G0lwmp1ko9rxYzLmsNMwZshuChBSFmpFYQyhWRS2vTmQ
         THAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=k8JHVwUZte5lxdMlYqJdYFiG16BchDDz3hY+wOvNwKM=;
        b=Dqj6u++sl3T1MvXIUsHYJLLA96rK2DHxByfkUMGo7MxHgyE4HZdwFtTQOsV/lPL1l9
         pBXp0Yp4gAD/fpCmTPTZ3suducU958BMw7UNJYxcQJNZm0jkTqfXXFKbF/VkEyqalULP
         4pERT/feRhYiojQw6IgbELP7XF4JexQutOBFlNDOMGwpuC/R7fDCXmoH7ndiXjvnHYX2
         J+pRQ5dsDYkwNSi1x6xs4tFfo8W4CC4h4V+Ovk9eLzRGz3B44nOBeNb3D6kZeotWyarc
         1JGEIGGnDfaNXQF0EhIL+AA/eih15W1p5blzd4mXXJ21OiW9wCxNK3JZ6EdyfcpUHV8x
         BEfg==
X-Gm-Message-State: AOAM532hV5u2MqwROKybtvLf/pSme6YDF+7ZzeeUwmUKXC8V0FiX9y4A
        q3OLoBx9dPoEh820v9SOZSAWQzEgxVXAoCC3
X-Google-Smtp-Source: ABdhPJyGzocRGI/MqJSo71k620tBs6f+GRQ7T5jekqE0MOiySLtGDVy+W9z7rKiVVw6NpZzzpFPrMw==
X-Received: by 2002:a05:6a00:2296:b029:28e:e91a:299d with SMTP id f22-20020a056a002296b029028ee91a299dmr557451pfe.22.1620243330955;
        Wed, 05 May 2021 12:35:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n8sm43048pfu.111.2021.05.05.12.35.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 12:35:30 -0700 (PDT)
Message-ID: <6092f382.1c69fb81.54d3b.03a9@mx.google.com>
Date:   Wed, 05 May 2021 12:35:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.189-15-g26cbee976edc5
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 70 runs,
 3 regressions (v4.19.189-15-g26cbee976edc5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 70 runs, 3 regressions (v4.19.189-15-g26cbee=
976edc5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.189-15-g26cbee976edc5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.189-15-g26cbee976edc5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      26cbee976edc57aac7c811f341ca9eaf1f4737c4 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092bf8e351d358f536f5469

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g26cbee976edc5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g26cbee976edc5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092bf8e351d358f536f5=
46a
        failing since 172 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092bf9a8e07b533116f5467

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g26cbee976edc5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g26cbee976edc5/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092bf9a8e07b533116f5=
468
        failing since 172 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6092bf9d351d358f536f546e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g26cbee976edc5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.189=
-15-g26cbee976edc5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6092bf9d351d358f536f5=
46f
        failing since 172 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
