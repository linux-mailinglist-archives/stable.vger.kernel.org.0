Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19BDB41BBC2
	for <lists+stable@lfdr.de>; Wed, 29 Sep 2021 02:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243380AbhI2Aja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 20:39:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbhI2Aj3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 20:39:29 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED5BFC06161C
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 17:37:49 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id k24so850492pgh.8
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 17:37:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=K2XmubxedL8o1pgWZ7K55bAWio/JfL/5v4UIMkHwPK0=;
        b=CL81AEfrXtaQfHGjXONMVdYeXPwxiCanV00hFqjCm4QVkIfrNKkf73fJp1xw1RTKfc
         DPCV8LqhKdtCKGi+JBNDfaPGzfOud0n+ED67OfHTrm3d/GgYbTk2gYntQCl4BYujh1/1
         OvDT49mwWdxlUJ6HoBJQhdlUtPM65GFcG+6CveWpZFUTopM/L7xwQ2Qtq6SzNuaRvOOz
         KIlu7BZp2yfAMpqCfxrthJqwyZVt7qbJIYM1ieKMd6jJyCs6Fg2zKimpeEFzQz/IBjEu
         HmYEUN3PXUeydakfrNqczpx8y64+N8UPvYSrS8btPAQlNWOe19RmM+zkTjRD/ETvDvLp
         avaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=K2XmubxedL8o1pgWZ7K55bAWio/JfL/5v4UIMkHwPK0=;
        b=emnaVm3fj+vcIn7SoKmGsoRfUU57sYxoqo6iX3fHy9XMQiP5FPYHfsropvwg03WX02
         jQahh6SdSR9YkQc2ZCr2C+zrE5IUuE5k6GHLGh1RBpPh9Tr0UYfB2SMQSL0LXz/5JPed
         DtZ5wghqR9AbQhM8hQASK7UuNOAFeJIeANyiWsm0MabQh6yzWiHHvBMmiPsbdMUV4D6M
         zH4RAfHxGylQyt0+0z/FjenLw4BLrI+bwooEmxBdiyQw/1AaqmqmBaCAwgx/BgJOHq1u
         29t9FrQEhYLlzyDCQ1hNELCtsu9UA/4GOp1KNLa5erfh7HUOQMB775mq0eUvB6kUFd0F
         DXKw==
X-Gm-Message-State: AOAM532RFJNGphuUwOFjbRF/1X8ABkVNEMz24i0mfcOAE/RjX9WNyrlC
        KtI3P2U+XZ3OUfJjGHAhZFWN7cnJQXleJOtJ
X-Google-Smtp-Source: ABdhPJw9aEq23qkdjqZCHKJY3pWBrRhFI9A2Jvo2IZ+knMnC8/w0caST6of0BPsQoyW3h9Ux4b3WKQ==
X-Received: by 2002:a63:e24b:: with SMTP id y11mr7000947pgj.452.1632875869274;
        Tue, 28 Sep 2021 17:37:49 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d5sm193743pjg.53.2021.09.28.17.37.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 17:37:49 -0700 (PDT)
Message-ID: <6153b55d.1c69fb81.3198d.1125@mx.google.com>
Date:   Tue, 28 Sep 2021 17:37:49 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.285-24-gad37b725027a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 78 runs,
 8 regressions (v4.4.285-24-gad37b725027a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 78 runs, 8 regressions (v4.4.285-24-gad37b725=
027a)

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
el/v4.4.285-24-gad37b725027a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.285-24-gad37b725027a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad37b725027a8c3c822ed45a3eed50d761df6bc6 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/61538301fc998b774699a307

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle-=
xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61538301fc998b77=
4699a30d
        new failure (last pass: v4.4.285-24-g0a5ad79130e2)
        1 lines

    2021-09-28T21:02:38.686625  / #
    2021-09-28T21:02:38.791062  #
    2021-09-28T21:02:38.791929   =

    2021-09-28T21:02:38.893426  / # #export SHELL=3D/bin/sh
    2021-09-28T21:02:38.894006  =

    2021-09-28T21:02:38.995149  / # export SHELL=3D/bin/sh. /lava-896148/en=
vironment
    2021-09-28T21:02:38.995737  =

    2021-09-28T21:02:39.097140  / # . /lava-896148/environment/lava-896148/=
bin/lava-test-runner /lava-896148/0
    2021-09-28T21:02:39.098587  =

    2021-09-28T21:02:39.099409  / # /lava-896148/bin/lava-test-runner /lava=
-896148/0 =

    ... (8 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61538301fc998b7=
74699a30f
        new failure (last pass: v4.4.285-24-g0a5ad79130e2)
        28 lines

    2021-09-28T21:02:39.557685  [   49.998443] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-09-28T21:02:39.609143  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-28T21:02:39.614879  kern  :emerg : Process udevd (pid: 109, sta=
ck limit =3D 0xcb950218)
    2021-09-28T21:02:39.619357  kern  :emerg : Stack: (0xcb951d10 to 0xcb95=
2000)
    2021-09-28T21:02:39.627520  kern  :emerg : 1d00:                       =
              bf02b83c bf010b84 cb969010 bf02b8c8   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61538058f7349f486099a2f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61538058f7349f486099a=
2f8
        failing since 319 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/61538077764f94bbb299a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61538077764f94bbb299a=
2f1
        failing since 319 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6153814cb018f1bfbd99a302

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6153814cb018f1bfbd99a=
303
        failing since 319 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615380bc49e6e3e6b799a2ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615380bc49e6e3e6b799a=
2ed
        failing since 319 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6153810510842b268499a2e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6153810510842b268499a=
2e5
        failing since 319 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/615383413e2ed4b23799a30c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.285-2=
4-gad37b725027a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/615383413e2ed4b23799a=
30d
        failing since 319 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
