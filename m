Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F96B416546
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 20:37:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242724AbhIWSjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 14:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbhIWSjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 14:39:19 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7674EC061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 11:37:47 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id lb1-20020a17090b4a4100b001993f863df2so5492430pjb.5
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 11:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9mSoBRv7On87NwooO0mVAbxNr8xBd5pcv3kTRhLXtnU=;
        b=B1E7kNLgM2exCBXe5YnAZM3NMcLq1YEvJyOaAKc7P8Gbe2HdxqmfUGLYXPzE9c/OCu
         xa3WsTF372uAfrJNlLLrGJJ/YDmTO++bFbAyj7pl8+S23YBahc3br6MQFZt229Rvromh
         QLTyNSQOjIP32/q6Zf/Zxdo+RYc1bwK3yI+3aE7/VS6FlNZNBv8R4VnbGauCjqUxTWNT
         rZKkMPF6j4BREaCCJByYuocxLhcPIrfXxrinKx5YEoPGjlryVJd63eudzbt7Wov2iz8R
         Sd2uHEvdjQCRFqYUIqxvm51yg2LyAkkKC/R3dsDB58iWtca2fItLIqTC81x1SdrQdK+g
         jQMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9mSoBRv7On87NwooO0mVAbxNr8xBd5pcv3kTRhLXtnU=;
        b=bTS3DlXpXWA2kIC9vzAaZWLer5exq+gbaCFH711phBjJLe42RaZ4sWSXuW2cE2XH9A
         smWGVyU0/JFVrrLG9tQVwhw2/t2eRgWq9S75jhxxq07lDDuyrjenaD/0/nmdObIhWAOQ
         hN3YXoRNkcCqSDG0dE0Qp+o01pWLZZwXVSjj4Na51vpoGJuxqxlEXbloQmvM2dCdMn+O
         gNteuMNdRkHgexwZFfnw3xbFLVUU2fqKQyZSY4IxhwmnpsUamEvEYsjxWE1tq7Et2mWU
         r016xWJ9Ic5TjYNMsirgbsH72zct2HUVUPh9HhsVXANya7mq0p9h6p3ejERy9TIcSxsY
         qHVg==
X-Gm-Message-State: AOAM530RsssWErRmxzyeuZIwmcdDTl3wK3KXw80jaOjCw7oSy5r8DCyz
        3+WB0tvSB2wzrKzCtPRF4uRQBCRLHTdOSGok
X-Google-Smtp-Source: ABdhPJzXrdAkV5D343NAcJsN9MybqB6UV6Fvt6rHuIA3oiXb+nx02wA+DnBnQ+V5dNEgr/Nk4CRFMw==
X-Received: by 2002:a17:902:bc45:b0:13d:e593:cdb0 with SMTP id t5-20020a170902bc4500b0013de593cdb0mr52388plz.72.1632422266814;
        Thu, 23 Sep 2021 11:37:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z123sm6153330pfb.166.2021.09.23.11.37.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 11:37:46 -0700 (PDT)
Message-ID: <614cc97a.1c69fb81.71cae.2f08@mx.google.com>
Date:   Thu, 23 Sep 2021 11:37:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.284-2-g3fc38aacfae0
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 76 runs,
 6 regressions (v4.4.284-2-g3fc38aacfae0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 76 runs, 6 regressions (v4.4.284-2-g3fc38aacf=
ae0)

Regressions Summary
-------------------

platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.284-2-g3fc38aacfae0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.284-2-g3fc38aacfae0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3fc38aacfae0b8ef4c49ba08d6d314c6808d05a3 =



Test Regressions
---------------- =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
beagle-xm           | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/614c94465b3e91adf399a2e4

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-x=
m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/614c94465b3e91ad=
f399a2ea
        new failure (last pass: v4.4.284-2-g8135b736ce1d)
        1 lines

    2021-09-23T14:50:28.567004  / # #
    2021-09-23T14:50:28.567891  =

    2021-09-23T14:50:28.671136  / # #
    2021-09-23T14:50:28.671821  =

    2021-09-23T14:50:28.773232  / # #export SHELL=3D/bin/sh
    2021-09-23T14:50:28.773661  =

    2021-09-23T14:50:28.874848  / # export SHELL=3D/bin/sh. /lava-880385/en=
vironment
    2021-09-23T14:50:28.875323  =

    2021-09-23T14:50:28.976522  / # . /lava-880385/environment/lava-880385/=
bin/lava-test-runner /lava-880385/0
    2021-09-23T14:50:28.977750   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614c94465b3e91a=
df399a2ec
        new failure (last pass: v4.4.284-2-g8135b736ce1d)
        28 lines

    2021-09-23T14:50:29.490988  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-23T14:50:29.496725  kern  :emerg : Process udevd (pid: 113, sta=
ck limit =3D 0xcb9a0218)
    2021-09-23T14:50:29.500946  kern  :emerg : Stack: (0xcb9a1d10 to 0xcb9a=
2000)
    2021-09-23T14:50:29.509371  kern  :emerg : 1d00:                       =
              bf02b83c bf010b84 cb933410 bf02b8c8   =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614c95bb093ed46d0499a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c95bb093ed46d0499a=
2e6
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614c9625a6eb67e9e499a2dc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9625a6eb67e9e499a=
2dd
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614c9569aa6f5d685a99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c9569aa6f5d685a99a=
2de
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab          | compiler | defconfig           =
| regressions
--------------------+------+--------------+----------+---------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip      | gcc-8    | multi_v7_defconfig  =
| 1          =


  Details:     https://kernelci.org/test/plan/id/614c95ad2361e1172b99a2df

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.284-2=
-g3fc38aacfae0/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt-=
gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c95ad2361e1172b99a=
2e0
        failing since 313 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
