Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2183341B361
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241771AbhI1P5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:57:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241766AbhI1P5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:57:19 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0EA1C06174E
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:55:39 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id m21so21608931pgu.13
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:55:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DQdpQc8Jv5ioUUXiR24jjHGGqC4qVzzdy23hmZPHCH8=;
        b=m1x3WOpMULa+nyp9W+MzJJLWsIYjqeawUY2+zAjwv5k0EES/AdT8wuwMxlFW5DHWiP
         j4a63pLhLv5KDZ57UA3dSniArYMO7Tzz1fx5ckqc/VASXVUH8yevnFr2vBO2727t7gm3
         Pk58Hi+iAmbey2u8BZ8q1AQmVUTiarGxKpNii7e9Se6CV9w7g0RDY1o1Dep+Z3gWJRZe
         3wv+PzdlVvIFyxjBcRfIs31+aiLjB9e0BNyUnxIKZTO8TpRpEIVyEfdTS4AmTst8RkB+
         cz2wxNc8vORqd+mvlOrC3KlPLEPyjZmXi4nkQYRQm805d0brXUfIqWIZ4W0rokH6UxdQ
         AoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DQdpQc8Jv5ioUUXiR24jjHGGqC4qVzzdy23hmZPHCH8=;
        b=cshrPZMt+yGo7JKvoTHSnoozgDsDNxNfxjVgO0gn8QvQbhzjSF/rDIshQigqa2bHHR
         8PgUOOnXkzyDl/hZxbLZe891Vi3+MdcO3yH440nIbB9S8fmih0M5OuMZYuuvUUsPUNuH
         q4jWHL1G6wsdnh9k4RBKKCZTAu7d19ZmOqVSBiu2u3LhFy9/CynLi2tkh53MAe40yJ6V
         9t4X++SZhmhWdjjmHyGrCAxIFBsDD0csyDvh3ycnkODK2Gmfz71TJi0vUrplw5mC/cyt
         gthf/t2iValtogI7RyrxmzSpmBhSy9yOLNs79xO0adBaEVQ4q4F5FtRImjIoyT24rqIk
         VkMA==
X-Gm-Message-State: AOAM533OhNRaUq7P8pl8XUHA7jCBTZKFa7vBvhqsWEvJ7qBGIuAO17DZ
        5pwzhEYphtGthkzUBgrMKnAiSW2E4Qi/YIt0
X-Google-Smtp-Source: ABdhPJyjl1akvDL0uiRUMYS0P6tkkp3wrg8eyU924+kez373OKaxl6exdkTby/NjVD++VUSM9NhIMQ==
X-Received: by 2002:a62:4e45:0:b0:44b:b929:5946 with SMTP id c66-20020a624e45000000b0044bb9295946mr1904414pfb.60.1632844538864;
        Tue, 28 Sep 2021 08:55:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6sm21500916pgh.17.2021.09.28.08.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:55:38 -0700 (PDT)
Message-ID: <61533afa.1c69fb81.2f9e9.81aa@mx.google.com>
Date:   Tue, 28 Sep 2021 08:55:38 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.284-31-g2f03d537988c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 4 regressions (v4.9.284-31-g2f03d537988c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 4 regressions (v4.9.284-31-g2f03d53=
7988c)

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
el/v4.9.284-31-g2f03d537988c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.284-31-g2f03d537988c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f03d537988c3922fb33a38f1ac233e079692858 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6153079c6e85834afe99a2fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6153079c6e85834afe99a=
2fc
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61530a510a564ca91099a303

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61530a510a564ca91099a=
304
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/61530814359b9fd4a399a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61530814359b9fd4a399a=
2db
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6153094c4309dee54499a2f3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.284-3=
1-g2f03d537988c/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6153094c4309dee54499a=
2f4
        failing since 318 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
