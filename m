Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B051E379D5A
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 05:05:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229994AbhEKDGI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 23:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229961AbhEKDGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 23:06:07 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2718C061574
        for <stable@vger.kernel.org>; Mon, 10 May 2021 20:05:01 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k15so1983142pgb.10
        for <stable@vger.kernel.org>; Mon, 10 May 2021 20:05:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bxbd8dNs6qhrmwMNWSEjDSMo4k/St27jIF4JVcPbP60=;
        b=IzWgM1M5/qCfly922OAhFhShtZhe8JfJKmq3ICaTk/kABfsLxCRD5HnJ7+TmxjXUru
         SnRFrxRBfwDWUAo9lQa4pqX/ZFOG4MIP0DhM1DQosI52aAzbZ+N2HsN43SR0+n26RfTf
         psNJmckaDb2Ztu5tQXrI0S+AlwktKQW7UBL8lsUqkcKf6IanhQH85gXFdPP6Lv4Rr1Zy
         ijRjMKtLHVv+VNJ9QqInpzjkGQDJXUloqcYaQwG4i26oKYGfOTDcqIbHhcVvQ/Qpju9P
         ym0v25/RUYidW0JbpCTfNdJD/7Os4Di5f8TtHL6FcOjFbTRCSqiJ1FSqU2LwaOR0ca6n
         VnYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bxbd8dNs6qhrmwMNWSEjDSMo4k/St27jIF4JVcPbP60=;
        b=MvVX9Tdb+LYGOx9PbOwYVTxWDMvHeqNxxBotGh5CfT1gAzdy9ejBuo6Yea+EeZK3vt
         avppElCng6hdVk30CSbLAVjd3+AqHmDysS/5oMYO2GVqw1ZUkPZt4/rJDiL4prrWU/8F
         gInfoM6hVt7g8ScHxN1zsc8Gsr/ezkkwftDWNLwnZTe6nbXftWkEruqOz8l81hdnpCvp
         JfUztBhJgl/BhcLz4uBktg391yX3bbcPE3Hoh01y8hF2S0gsQv7eOTMdG6sDmKUhEgBX
         Wj88CuxtSUtXWPngeGGLPZQ505hOKMhoIoDUU5AhstS1A2kc8IFFrWy9RriSrSIA8148
         wQvw==
X-Gm-Message-State: AOAM530kzRRFJvEDahIUfwRqL6SlHSBwyX3OeRnzmwJoaw146DClGnh4
        gaax3OfSW7+AzX0E9Qhv0oKo1NKTJgcsyoT2
X-Google-Smtp-Source: ABdhPJxXt1KS9OtFaDvNJgbOVlIMfcaEUQ3vWWoneOJ9KGvsa7+IAyrlRI0nOeVxyCCuSJIRpXx3vw==
X-Received: by 2002:a63:4a4b:: with SMTP id j11mr27849822pgl.451.1620702301220;
        Mon, 10 May 2021 20:05:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t192sm12333230pfc.56.2021.05.10.20.05.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 20:05:00 -0700 (PDT)
Message-ID: <6099f45c.1c69fb81.5d096.60fc@mx.google.com>
Date:   Mon, 10 May 2021 20:05:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.268-67-gc2dc964cca2a7
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 105 runs,
 4 regressions (v4.9.268-67-gc2dc964cca2a7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 105 runs, 4 regressions (v4.9.268-67-gc2dc964=
cca2a7)

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
el/v4.9.268-67-gc2dc964cca2a7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.268-67-gc2dc964cca2a7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c2dc964cca2a733b372cde98a864273bd6af8b1d =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-baylibre  | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099bf97ff572c5e826f5485

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bf97ff572c5e826f5=
486
        failing since 177 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099bf99ff572c5e826f548c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bf99ff572c5e826f5=
48d
        failing since 177 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099bf89ff572c5e826f546d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bf89ff572c5e826f5=
46e
        failing since 177 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/6099bf316c7674f9746f546a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.268-6=
7-gc2dc964cca2a7/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6099bf316c7674f9746f5=
46b
        failing since 177 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
