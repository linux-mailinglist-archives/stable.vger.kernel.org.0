Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96F1D2D4699
	for <lists+stable@lfdr.de>; Wed,  9 Dec 2020 17:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgLIQSj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 11:18:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730940AbgLIQSe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 11:18:34 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAEF4C0613CF
        for <stable@vger.kernel.org>; Wed,  9 Dec 2020 08:17:54 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id e2so1485822pgi.5
        for <stable@vger.kernel.org>; Wed, 09 Dec 2020 08:17:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OQdwyE3U23KuwxHznQESH2dj4Jcym4RZPs9xKQ8wC44=;
        b=ZQ7NjD22xvp4WoMJ8ag0Dcn6V4I89nsT2NK+vGKVbDMg3OvvzUw3NLGyalIAaeMzfy
         Ht9YrAc5Lm7CC/IC8jN5bd2jPvW0lcqjZxZsF7UcAAdNnoEwChNfUX/X/22IwREbnCVe
         MVRfdOGZQrnuVjz8xtYMSlILNBJHW0JM92HqAMp4Ohi+KfyYWX4kiaPA5QDBr8YAGdby
         bI8cZC+/Uiwj1fbkiCTWfTaZuIRuNsPFLvgESWJntrQTMv++GMyR0YbreopcTCIwJcLb
         ClhQ/99IX73fH5/5IfycKKsS1Y6sxckWjlYj+Z5zxbvZfrXDMtSP9tlUWkRgYaKCTSCd
         xnJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OQdwyE3U23KuwxHznQESH2dj4Jcym4RZPs9xKQ8wC44=;
        b=Geq85srSbaZ1F+vLzXrNEfvLDoLu/AharzM/rd0iDJ0CWXHmcbTPGzALhjgwqICB9n
         eQi43vqn1woNydEjJ2DO0mTGstTtZ3VKt0AszfOBDos3po6YvD3LGr0KWzSKJfNOtZ0/
         NB4gWYM0Qb800W5G0yCkCZCQbdIEU5MYk45o1yvmAg0rpXyDZijH1VFGkGL8Heo9buOv
         rQawF6tsbR+imGLsz9M6XqIWFjIwPDGrrFO2jsLL3JOqT2sETE2ZcH9cK/c6d1bYkcR6
         +22cCpb8i3x50UCy+rALXCmDZOLRqalU65BDRn8wh3yVhb5A0cW0CHVufCclJYIULvzr
         fgHg==
X-Gm-Message-State: AOAM532sUjqffrU0cfqmXZw4q6DwDXNmbNiyce5YUowZeU6V0EnKLmd4
        9StOmR+kPW4EWw0T4xRAAd3gZ2jLT8xBLQ==
X-Google-Smtp-Source: ABdhPJxQ4zoKP+zKp6r3WxrMpOem24ZHVBm1bW2U8b6ja9yLFUtsu6H/4+K+wlwdOnjs5UPVojXzvw==
X-Received: by 2002:a63:1122:: with SMTP id g34mr2593051pgl.437.1607530673883;
        Wed, 09 Dec 2020 08:17:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c133sm2952502pfb.8.2020.12.09.08.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Dec 2020 08:17:53 -0800 (PST)
Message-ID: <5fd0f8b1.1c69fb81.655a9.567a@mx.google.com>
Date:   Wed, 09 Dec 2020 08:17:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.162-27-g4adc9dd3cc11
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 134 runs,
 3 regressions (v4.19.162-27-g4adc9dd3cc11)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 134 runs, 3 regressions (v4.19.162-27-g4adc9=
dd3cc11)

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
nel/v4.19.162-27-g4adc9dd3cc11/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.162-27-g4adc9dd3cc11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      4adc9dd3cc1189c2d8bb79abf30d67e80e8b77c0 =



Test Regressions
---------------- =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-baylibre | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c684d243d6fd6fc94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-27-g4adc9dd3cc11/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-27-g4adc9dd3cc11/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c684d243d6fd6fc94=
cc2
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-broonie  | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c6ffc1a9e9b52cc94cc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-27-g4adc9dd3cc11/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-27-g4adc9dd3cc11/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c6ffc1a9e9b52cc94=
cc6
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab          | compiler | defconfig          =
 | regressions
---------------------+------+--------------+----------+--------------------=
-+------------
qemu_arm-versatilepb | arm  | lab-cip      | gcc-8    | versatile_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd0c680d243d6fd6fc94cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-27-g4adc9dd3cc11/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.162=
-27-g4adc9dd3cc11/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd0c680d243d6fd6fc94=
cbd
        failing since 25 days (last pass: v4.19.157-26-gd59f3161b3a0, first=
 fail: v4.19.157-27-g5543cc2c41d55) =

 =20
