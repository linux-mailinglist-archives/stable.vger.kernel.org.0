Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1D92D8219
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 23:31:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406914AbgLKWan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Dec 2020 17:30:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406943AbgLKWaE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Dec 2020 17:30:04 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67020C0613CF
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:29:24 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id w16so8098710pga.9
        for <stable@vger.kernel.org>; Fri, 11 Dec 2020 14:29:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=1PejJ8oie5F7hHV/Hss1kielFtMy4QBy27UPMP1Kpvs=;
        b=tXaTw2lj8iYYw5GKVca4+Fmla0ILCD83is7aSvvteEnqYjfIGLA0KbItcMCIbeHhl3
         yyEiBxt3L94MunY/3TKt7rdsODqlSEAC5KnTUzLk+7pZWucRJ/+kEVJDTnmgveTNuK2v
         waDonSHN0VziKyk4SxJkV9IV4To1T+UrexkCXVwvrobSOISTe0xQ2Ej7RseTgsX0BpyR
         QXRwL+W7jujVvM11337qUlTEbEPthU9eImpe4NECrAWvhx2eCOAVA5YV2wJFUqS9mUQf
         1jqg0DPsfZUic/eHiSfSBjSf+/rng28/IfmWYoJtROCRTbXIR7OGjRUJpxNwDlczTww8
         XAQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=1PejJ8oie5F7hHV/Hss1kielFtMy4QBy27UPMP1Kpvs=;
        b=ntbY/GhdqzDLFF449Oe2YB+JpcE4LrklYarWMJsaLcJOhGJ6anLXAUc5QtpY4+q/2n
         wGiwf8QjEmbIZCZFjOgE10B/cd3MOtt4GO52cGPIPW0IfICoY3LxWxmiISUR+SH6LgIA
         bS4ERktPWDnRyvwd5Qi7MnaP7DxlPZqPrcfwIrhNRO5mZRCzMxKuEcR7jKc1fIg+LRuu
         sQceJtP0YI77w9yaFOFmf0SmqBVsN/rfMTqcsR3K5EIpCxllypesRrsV25woJyBmgYPQ
         O/dklgpgPresB067pg+pr7TxNbRaaYBIbkr1uhwFUCSauqvp8bYd4t6ob0kVx0k0RMdJ
         4Axg==
X-Gm-Message-State: AOAM533/S/lkq9rdcblgUz3CYpypm+YRDEiuswdcEIW8FjFaJIqYGJVA
        VeT35yT9D+ygV5/a687q/Z2idk4CVr7cOw==
X-Google-Smtp-Source: ABdhPJxjkz2DXbAR3oOHtG9JSztWpA867aw3hVI+pDeJE1P/HNVYkxL7OzsvsxEwC8j/QYlIugB4LQ==
X-Received: by 2002:a63:2805:: with SMTP id o5mr13806023pgo.339.1607725763556;
        Fri, 11 Dec 2020 14:29:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h12sm11487222pgf.49.2020.12.11.14.29.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Dec 2020 14:29:22 -0800 (PST)
Message-ID: <5fd3f2c2.1c69fb81.b0041.5bf5@mx.google.com>
Date:   Fri, 11 Dec 2020 14:29:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.212-2-ga950f1bfe7736
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 128 runs,
 4 regressions (v4.14.212-2-ga950f1bfe7736)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 128 runs, 4 regressions (v4.14.212-2-ga950f1=
bfe7736)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.212-2-ga950f1bfe7736/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.212-2-ga950f1bfe7736
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a950f1bfe77367fe9f0547afca6623c3ca35866b =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3b9c00977e8d1dfc94ce9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3b9c00977e8d1dfc94=
cea
        failing since 27 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3c721b0ab45ce5cc94cb9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3c721b0ab45ce5cc94=
cba
        failing since 27 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3b9cab889592364c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3b9cab889592364c94=
cc1
        failing since 27 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/5fd3b99cc1460b94fdc94cc1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.212=
-2-ga950f1bfe7736/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fd3b99cc1460b94fdc94=
cc2
        failing since 27 days (last pass: v4.14.206-21-g787a7a3ca16c, first=
 fail: v4.14.206-22-ga949bf40fb01) =

 =20
