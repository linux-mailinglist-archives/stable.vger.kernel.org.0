Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F39D0312759
	for <lists+stable@lfdr.de>; Sun,  7 Feb 2021 21:10:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBGUGj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Feb 2021 15:06:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbhBGUGi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Feb 2021 15:06:38 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF45C06174A
        for <stable@vger.kernel.org>; Sun,  7 Feb 2021 12:05:58 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id x23so6868677pfn.6
        for <stable@vger.kernel.org>; Sun, 07 Feb 2021 12:05:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PHA/pApQ1Jot6vRiPc20T5KJtw3Lxqs8YUxiAY8AofE=;
        b=CML6BsE6jIzSilQISahIpT5+f9+4cvgD3EA8i6N15YNVjWhEoG8KcJnQvxoqYnbxu4
         I6TRQuBEbTd30pfmWdafHZfLsfRicRqKrr2NvZ0kz/NWSjEeI/NXHsC+xQuUl6papOe7
         KKrI+fYwGid++KHQhlxfZcyfccPWCVX9iFwbGwgWBpccdObWXil8qv3eOGp9ImqW/fXJ
         q1g1p3JoPSXPAxZXWQgMlhHHfXbDc7YzGyEswa/hX5XkCIjT1TUhHwWPMQeERHxdNBSZ
         S9PbtX0L0kta1um8mgd+Zv/xHHQ36PrzDwfEYMYb8jCOn9pFHfNJuJK+ljpKxwig2SHQ
         1ZCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PHA/pApQ1Jot6vRiPc20T5KJtw3Lxqs8YUxiAY8AofE=;
        b=pg1zODTOa0S9U2+YNC4oGgKCsn8FxXJzK7iBZoEniUaTi+lz7NvvWe1Zfv1v51cUwS
         hrabyjf5yFtuVCOHIWKd6iBx4M29WKXtocaJ6RmNFzpGxyZ7xDIbXM28gTQ0Ii4m1qtJ
         RP5Y9/7clO9kSLT/Xzq/uaRqQndEfIFoxZWJDTfbVQ0lFE1mEozQSQVb2TQA+7RAicV+
         QUsI6Sdxr2fEXYF9+5Iv9pIt9nNJGHXQAcc8aM16dydnU1KcHbhcIkrC0zQc2jq9zLG1
         i0KSrWTIuudoF2A+PyetkR97278bct3DWFi7oom3DHbqsYDWNt4Hssnen9Hid3gqsqYA
         xVkQ==
X-Gm-Message-State: AOAM533gvKdELTnFakiRt1qpl1CWICm7v3OxqWoYHuqS1DoYgVugEXeJ
        maap4ZvJWJT4IyM7c7cvc5YCjEzGprCb+A==
X-Google-Smtp-Source: ABdhPJwfmDNyBROqoYGhv5yJC1rnDnHr0vHjF4vmhPKDWaExmtOqOB4MXAdpXSrTRae6e9HKSOUeag==
X-Received: by 2002:a65:6a02:: with SMTP id m2mr4234634pgu.443.1612728357697;
        Sun, 07 Feb 2021 12:05:57 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y4sm13418240pji.34.2021.02.07.12.05.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Feb 2021 12:05:57 -0800 (PST)
Message-ID: <60204825.1c69fb81.ea71b.dc11@mx.google.com>
Date:   Sun, 07 Feb 2021 12:05:57 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.96-3-g9af87b5c7fb00
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 159 runs,
 5 regressions (v5.4.96-3-g9af87b5c7fb00)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 159 runs, 5 regressions (v5.4.96-3-g9af87b5c7=
fb00)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.96-3-g9af87b5c7fb00/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.96-3-g9af87b5c7fb00
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9af87b5c7fb00cba0dfd8c5be9956356ff9e7355 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/602016ef140fe3225a3abe63

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-nanop=
i-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-nanop=
i-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602016ef140fe3225a3ab=
e64
        new failure (last pass: v5.4.95-32-g0acd3152d6df8) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020132d914155c9eb3abe71

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020132d914155c9eb3ab=
e72
        failing since 85 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6020132c914155c9eb3abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6020132c914155c9eb3ab=
e6d
        failing since 85 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/602014473f89626ce63abe86

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vers=
atilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602014473f89626ce63ab=
e87
        failing since 85 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/602012d12908893c4d3abe73

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.96-3-=
g9af87b5c7fb00/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/602012d12908893c4d3ab=
e74
        failing since 85 days (last pass: v5.4.77-44-gce6b18c3a8969, first =
fail: v5.4.77-45-gfd610189f77e1) =

 =20
