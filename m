Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E95392126
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 21:51:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232577AbhEZTwc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 15:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232324AbhEZTwc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 15:52:32 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E13AC061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 12:50:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id b7so1179904plg.0
        for <stable@vger.kernel.org>; Wed, 26 May 2021 12:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d6nyhiGzNo1kX+TaoSuqA0HRyw4NtPapkOepIcL3F9I=;
        b=A/KzF/LVeQi8YCn4iis2tLn6/9ryOFcC+ZH4za4hBhoHiZjSHU6oFOwQd6f7cCM7Ne
         PLx8fyND+6HK4kXSfb0sYRv2MqvJ6rbeXQZcqvb3bi5Ytp3bdYwkFQyBf55XFTLNp3GF
         M62dDqA1VJD+iWIUMXbd+6QeU+jH7d+mTSiZvTfn2rbO3/5PiSKW2IvW+e/F1ESEhkJJ
         /JsaunMaH3LiTUIZLplfEmGRQnWW0w2pYpXYma82WJX/IFl0/8hQtBh+9ywdu4acZicF
         nAnRtDhg8Gzjsg4gY/HeAYb+vUh5LJg1m4cq7AMolJv50lSiy9A8+YxwANnUpsZOdIl3
         ZNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d6nyhiGzNo1kX+TaoSuqA0HRyw4NtPapkOepIcL3F9I=;
        b=jp448oxjewrF/OcvGFHFGxuObckc9MQMoN/z9+MldStV2usTlcNplMZZiZ7oX5ipnK
         XeyjBJgcqKMATH3anwVJORBzYthT50maundMSD9eXCNwVxJsKnj1KkmGW8rHXF4wglq5
         +yzXgo7zhisCgFHmLuDHScUyE0h/oJKfXEo+C4y2mGBRZ7QADXZBWNwBiOmxcWy7f9xw
         l+382qQF2NjxdIBs4dfNnaH2253JObTZ5gIxxy1XNU8c5nYhSw+gFKpli2k9UeJ42831
         WFOsM5ikdZbXxRsUZPYb9ZxTI40PH59cUjgTO7/aac0MJTVUuGwJe0/uOdPr7ZPcIPCt
         PdVQ==
X-Gm-Message-State: AOAM531wcw4ucBEN/Pno1E5/XMb/ubcE4rNqruQUzFUqS/b7GZc6ABC0
        UvEoWOFMYx0//WMUx2/JSj3DQUPGX7HeczOo
X-Google-Smtp-Source: ABdhPJzzOSYsdm8Vo8uDPx9Roh5pR5riaflmNkr3VxheQanx9GAOXf2opggDUz84/NF0sQbkpT+nvw==
X-Received: by 2002:a17:902:6501:b029:ef:8518:a25a with SMTP id b1-20020a1709026501b02900ef8518a25amr37598212plk.64.1622058658906;
        Wed, 26 May 2021 12:50:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a12sm48209pfg.102.2021.05.26.12.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 12:50:58 -0700 (PDT)
Message-ID: <60aea6a2.1c69fb81.fdcd4.03bc@mx.google.com>
Date:   Wed, 26 May 2021 12:50:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.191-50-g6b7b0056defc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 96 runs,
 3 regressions (v4.19.191-50-g6b7b0056defc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 96 runs, 3 regressions (v4.19.191-50-g6b7b00=
56defc)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.191-50-g6b7b0056defc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.191-50-g6b7b0056defc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6b7b0056defc6eb5c87bbe4690ccda547b2891aa =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-broonie   | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae75da330c750336b3af98

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-50-g6b7b0056defc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-50-g6b7b0056defc/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae75da330c750336b3a=
f99
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-cip       | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae7159eef3ece1dbb3afe2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-50-g6b7b0056defc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-50-g6b7b0056defc/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-v=
ersatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae7159eef3ece1dbb3a=
fe3
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =



platform             | arch | lab           | compiler | defconfig         =
  | regressions
---------------------+------+---------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm  | lab-collabora | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae7431d8ba5d8a74b3af9f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-50-g6b7b0056defc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.191=
-50-g6b7b0056defc/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae7431d8ba5d8a74b3a=
fa0
        failing since 193 days (last pass: v4.19.157-26-gd59f3161b3a0, firs=
t fail: v4.19.157-27-g5543cc2c41d55) =

 =20
