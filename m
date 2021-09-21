Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAC3441389A
	for <lists+stable@lfdr.de>; Tue, 21 Sep 2021 19:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbhIURjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 13:39:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231441AbhIURjE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 13:39:04 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A4C9C061574
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 10:37:36 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id y4so185973pfe.5
        for <stable@vger.kernel.org>; Tue, 21 Sep 2021 10:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FQezmwhTBfXZBfLGazRUl2coRfL0QW/nWvxp3HNzNRg=;
        b=AsNyJNqPzKfgtu9npQnMYH7aKnopgiMcBT+25REpf39Bj+BniITeKhG4acWhcEyiyW
         CljdSQeCzpBh7hPtNaj14MUIjpDtV1R1H/je0j5imV7C/hjNs4iF8iXyWBKeF9Z/iW3n
         0PuleSI5Nzro+T16RuKeu2ASv4smkvW7MGG0rgaAryEf6HSvMbY00zWiIGTbLcBX2D0L
         HUoP69cwS8/h1yQA8hyLLZhreUj3sBxG09MkCDWC6pcr+1JAZmbc2Vkhcvqiv3zky26W
         EQsyWHPll0bXnEs9sn3QPxcn+mpVMMIZMGWP2gk4ahN7JecZytwjG+DGNrOr8nEkCpt+
         +OXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FQezmwhTBfXZBfLGazRUl2coRfL0QW/nWvxp3HNzNRg=;
        b=f+ohkuUNGSSfAn5phjPr9GB6oAd6ZuOvU6tTheXjPTpjvjS69GRblk/lsALHykVY9G
         DD4gPIYng9F4mOHIr0S9bVSIlWcy4IKEnvHjHGMSwgyHs8A82i7rqCauXrNGzfJXNXDU
         elWAKG3DyYaknQYpOieDIfXlL+OJJGkY0q3NaUae9Wh9rRgWE11c05bzdflJhFnLKndG
         q2koMwk8kc7mZw5hN4oiL03+FR6hSFEZkFZi/5MWjw4PH3ktVfRIwDpYUcmq/2KxVP3l
         +rZocYQlHSXg3ujiLIllnz2pQdzYL5vffrQrX52e33za+2FkdF+nnd4qe9RlAyyjjU6W
         0TkQ==
X-Gm-Message-State: AOAM530H7kpJciD48qs3OfQe8lj38AnhmwIBIM8WAYSYH2eWCet6ECYN
        KjNI/SiBzeUxRKiwTq94A0CuQwotvILqAZjD
X-Google-Smtp-Source: ABdhPJz4Ky/sgyoVhlO74ccldC+qAWMm3d0sqlBoqj/JkOvojWgnSfnz4QGRMlv1R8aqleII9Vh1pQ==
X-Received: by 2002:a62:6587:0:b0:445:824:58f2 with SMTP id z129-20020a626587000000b00445082458f2mr22509376pfb.82.1632245855613;
        Tue, 21 Sep 2021 10:37:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g4sm19038908pgs.42.2021.09.21.10.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 10:37:35 -0700 (PDT)
Message-ID: <614a185f.1c69fb81.32497.78ec@mx.google.com>
Date:   Tue, 21 Sep 2021 10:37:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.283-133-g94366d40b3ff
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 80 runs,
 8 regressions (v4.4.283-133-g94366d40b3ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 80 runs, 8 regressions (v4.4.283-133-g94366d4=
0b3ff)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =

qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.283-133-g94366d40b3ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.283-133-g94366d40b3ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      94366d40b3ffda7be4bc479b66a73786708ae0b6 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/6149e9f6c30b3e447499a2e3

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6149e9f6c30b3e44=
7499a2e9
        failing since 5 days (last pass: v4.4.283-72-gd71f8e13792e, first f=
ail: v4.4.283-116-g78a7bb31bae4)
        1 lines

    2021-09-21T14:19:15.672545  / # #
    2021-09-21T14:19:15.673285  =

    2021-09-21T14:19:15.776556  / # #
    2021-09-21T14:19:15.777217  =

    2021-09-21T14:19:15.878650  / # #export SHELL=3D/bin/sh
    2021-09-21T14:19:15.879074  =

    2021-09-21T14:19:15.980236  / # export SHELL=3D/bin/sh. /lava-865457/en=
vironment
    2021-09-21T14:19:15.980669  =

    2021-09-21T14:19:16.081819  / # . /lava-865457/environment/lava-865457/=
bin/lava-test-runner /lava-865457/0
    2021-09-21T14:19:16.082922   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6149e9f6c30b3e4=
47499a2eb
        failing since 5 days (last pass: v4.4.283-72-gd71f8e13792e, first f=
ail: v4.4.283-116-g78a7bb31bae4)
        28 lines

    2021-09-21T14:19:16.598176  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-21T14:19:16.603953  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb948218)
    2021-09-21T14:19:16.608426  kern  :emerg : Stack: (0xcb949d10 to 0xcb94=
a000)
    2021-09-21T14:19:16.616356  kern  :emerg : 9d00:                       =
              bf02b83c bf010b84 cbafb210 bf02b8c8   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6149f7fe7798984f8b99a2fd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149f7fe7798984f8b99a=
2fe
        failing since 311 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6149e73828d26be08099a2de

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149e73828d26be08099a=
2df
        failing since 311 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6149e80868a588d74a99a32c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149e80868a588d74a99a=
32d
        failing since 311 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6149f89fe33fd2bbb199a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149f89fe33fd2bbb199a=
2db
        failing since 311 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6149e7ae48dc59677d99a2ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149e7ae48dc59677d99a=
2ef
        failing since 311 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6149e881aee5830f3999a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
33-g94366d40b3ff/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6149e881aee5830f3999a=
2f3
        failing since 311 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
