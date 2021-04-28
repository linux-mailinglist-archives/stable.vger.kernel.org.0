Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356A936DC67
	for <lists+stable@lfdr.de>; Wed, 28 Apr 2021 17:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240429AbhD1Pu5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Apr 2021 11:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236041AbhD1Pu4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Apr 2021 11:50:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61B31C061573
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:50:11 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id gc22-20020a17090b3116b02901558435aec1so5629242pjb.4
        for <stable@vger.kernel.org>; Wed, 28 Apr 2021 08:50:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6F82r63qCNgd6TKEUXqR27etc0NPKwHn1xxB2MPsgpY=;
        b=W6E2/0jmG9fS3fqH2bY8rYvaRAS1BoYjjrDGUuNRAImzFTjq+GI9nV5U3c3hPJ1Nrg
         CMAkytRiPQ/kAQBBDaNhzJzzV/8XdCc09N0tHnRLnpLQlry5dsDU/IktjTxIrYVwf6AZ
         TClJcBZKbnZN0KnLh+pPN0ALDnD3eR/LCdnhlWXeLmagUvB7MlWQvfcZFHrvqHHen3hp
         jwx1nrciTz8+vkbY+rvey9WCjD00Q0GdkVi8F4t/7F23JSxaOQXyC6dYx6TE3aUEE8iM
         CHbGIKx8W+i9zBNEM6w8gNmuLs1vSMuTP2OT+TM7/QYruddE2pdxlRrHFIcaSCAGtmny
         VeyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6F82r63qCNgd6TKEUXqR27etc0NPKwHn1xxB2MPsgpY=;
        b=B8uvnATy5ou9Ezx+8CJmAfaDVSjUFMPSueak63q1pV/NCseuCSIKpgeZh1BKRoKbyp
         SsIv7eIaRPiah0kDjtUGbdI7aSbuu+IYVt2UCcr+G3A6Waw2jNS2TVaCyJAr7h+aPMiF
         fc1ORMLi8EtaNEVx7KhUrgT1CqCcQbiydfKqVS1TWOE25nfWMULf/6+60bbe2NpWN9Ub
         +KWSceHA6P54P3t9v14HurKE9C5Ia6w4FjxOX8JhEvKJ4d7OZBM0ZXTpPUxux++/2tuW
         AWBNpQrDM/BBMxPMX6L6y8wzoxQ+/iBVEsErYejy3j2QoAin67hfe+s8N/jCiLkYJAV7
         PAqQ==
X-Gm-Message-State: AOAM5300yCa+AmFXeOa0m25oJWA9SVMSrSeQV3BKBLZt5RuiPkVqICrJ
        ONSGOUieiz/L8DZ8r3w33u+vsnL2gD8N1FEP
X-Google-Smtp-Source: ABdhPJwqp1M2lzTxKgTTexxHhD0vAUo0C8QFs8sCiRBsMncGCKBTV42DhUFEnLQD9fYHmsSZO0FI0Q==
X-Received: by 2002:a17:90a:6583:: with SMTP id k3mr34739164pjj.227.1619625010606;
        Wed, 28 Apr 2021 08:50:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ne22sm5155132pjb.22.2021.04.28.08.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Apr 2021 08:50:10 -0700 (PDT)
Message-ID: <60898432.1c69fb81.93a1b.fb8f@mx.google.com>
Date:   Wed, 28 Apr 2021 08:50:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-51-g09d3b447c34f
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 97 runs,
 3 regressions (v4.14.231-51-g09d3b447c34f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 97 runs, 3 regressions (v4.14.231-51-g09d3b4=
47c34f)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-51-g09d3b447c34f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-51-g09d3b447c34f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      09d3b447c34f20215c978e8f1e77c2d930c9e8e8 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6089515d495b7830a59b77c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-g09d3b447c34f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-g09d3b447c34f/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6089515d495b7830a59b7=
7c5
        failing since 165 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/60895164371ca534cf9b77a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-g09d3b447c34f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-g09d3b447c34f/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60895164371ca534cf9b7=
7a2
        failing since 165 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/608951943ec55985889b7795

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-g09d3b447c34f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-51-g09d3b447c34f/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/608951943ec55985889b7=
796
        failing since 165 days (last pass: v4.14.206-21-g787a7a3ca16c, firs=
t fail: v4.14.206-22-ga949bf40fb01) =

 =20
