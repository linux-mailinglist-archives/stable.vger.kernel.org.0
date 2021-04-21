Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD744367022
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 18:28:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242194AbhDUQ3Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 12:29:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244357AbhDUQ3N (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 12:29:13 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A6AC06174A
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 09:28:40 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id g16so16052508pfq.5
        for <stable@vger.kernel.org>; Wed, 21 Apr 2021 09:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SICzQ4YEUy38GTatDMTaFEcb70EpiwxTJB5bVIK/PaY=;
        b=nR0NkqenZn9GnEd/2VHFqcHqgyS/YY+H9VmYlOk2om93yYF4joIkaWpK7lD5LhciW8
         w+qlSOGuqUZ5iNZKbuoMUdXyuPG+1D/XKI+obFpzdalUbY+CR8p2hs4OM1fYPSFN+4GV
         MrtfGeX+L0wdDK5sPRF5v/sxDwaPvr03xKjYKqaDtyR4CKqEe7cQ9NqLPoTtekOONzDo
         UoiPIwOGKqKg43sR3CMbzbsO5nV8iuVT5axYmAip1X6En/nC7+SYvnv4Fv4Ian7URRvM
         a1EFJaOWfGAh5xbEEwuZLWF7MfAR9Kw3k1xeeVV8wztKgbbYJHBB6EAO9czWEzXpoGmY
         1xBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SICzQ4YEUy38GTatDMTaFEcb70EpiwxTJB5bVIK/PaY=;
        b=Z5e1ljUhAtky956ZHvIg3SY5FyqtDMiFJWcIIDCQKeKkTIT5V5UxLU3JPY8NHwCDpE
         tIgYtMY4iYUsCR5/AOelll/MoQis+cLgjvhLsWGKDFYCuXofZCtsZpK5MqXbM8eViMRZ
         y1UzkxAawGrYFdp8vyEKsloZxA0OwqiPG7jWtwwDM/dZfLCAUHCNVakBReDsOR9vk3Fo
         dnDa0lqT5Q+A7cr+ZuBCjf2Qagxkv5xBq4gcZIWP+ZljadQf46fyNLmxmvHGb5Ds7wdm
         a/QQtX1/LxfAGP12+2g9zpiRrfw9XD1O+cp5y6zEmyKDEp4xXodVuRDlIm4acKf4d0Fy
         rNKg==
X-Gm-Message-State: AOAM5308GVyJhxCVuWHMsDCoCIj/3gfdY0ranwReQQ2ZBPzBD9p79Xf9
        aBndy4E5g2lTOjUQnF5GI757B0oYGEoM8ybKiAc=
X-Google-Smtp-Source: ABdhPJzIuiQ0EPfBatxjwT/q6vJsqV4+k6e/UsEiJ/MXXoX+mXo6j/qLptni4mKW4ZkQ0WW4/bWDyg==
X-Received: by 2002:a65:6414:: with SMTP id a20mr3946396pgv.96.1619022519333;
        Wed, 21 Apr 2021 09:28:39 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z188sm2047836pgb.89.2021.04.21.09.28.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 09:28:39 -0700 (PDT)
Message-ID: <608052b7.1c69fb81.6c960.5c7c@mx.google.com>
Date:   Wed, 21 Apr 2021 09:28:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.267-27-gbfd90512e028
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 89 runs,
 4 regressions (v4.9.267-27-gbfd90512e028)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 89 runs, 4 regressions (v4.9.267-27-gbfd90512=
e028)

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
el/v4.9.267-27-gbfd90512e028/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.267-27-gbfd90512e028
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bfd90512e028e1130af067132999d744e3f4f40e =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801ec319b5e7480a9b77c0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801ec319b5e7480a9b7=
7c1
        failing since 158 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801eaf707c0503749b77b8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801eaf707c0503749b7=
7b9
        failing since 158 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801ebf19b5e7480a9b77bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801ebf19b5e7480a9b7=
7be
        failing since 158 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60801e9a85f43eca3e9b77da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.267-2=
7-gbfd90512e028/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60801e9a85f43eca3e9b7=
7db
        failing since 158 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
