Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC78840D654
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 11:34:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbhIPJgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 05:36:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236314AbhIPJfi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Sep 2021 05:35:38 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BFC6C0613E0
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 02:34:11 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id c13-20020a17090a558d00b00198e6497a4fso7069431pji.4
        for <stable@vger.kernel.org>; Thu, 16 Sep 2021 02:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sseD8q0bM1Jv43zjAlLz+q+7LrD1C2YrPPzMqnLRHfA=;
        b=kWCmr4IcQ1HIODKqrQa65EPKm8rsfC4vcL1ePWHJchOSiC8xZKPewc9AdGtX4SIQJZ
         ZjtLQhQ+N0BkQwcex/S0Qh1QbBbVcjcpPqdRJVAhq3tz0sWP+DXirCHFnn0eBPIphQZt
         MQLAfyPGt+XHQvr0WfYcZCt14X2sne58zqmKOKiQNgPY+OVbuyPl6ibISQsdhrNYf+tH
         Tf3vCXwd78RXukroHRSpbGGV5rjxW0hb4CcrYZMyqk6nURHm9nDDVh3QTzR9aZH8X7re
         Ox2qqdkZi1+Ut13oOdfaA+lGnW65DLid+27HqIZrkN9SUKTm0ugdYhg12kHb+7AUIEF4
         MqwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sseD8q0bM1Jv43zjAlLz+q+7LrD1C2YrPPzMqnLRHfA=;
        b=430F6Fth5RjnQaHUyua5uZ1N4FdLff4KS8cAPZ/Iq5D5Hl9L0eDqdDTJIQTV50cSA7
         zr44j2q5XlIeUrpwCG6Z74tniycvoNEtjxLHiLft7SAbVwc8BHv+R59kCAmI7tQ+T4qC
         yPgguyBFs5a8La/kZN5ESulBO4sZBrCmv5cqp/Xoor9NHhmFrVmQ9Bt1pfybm6ccmfCl
         uDTwKXaZg0umADPQci/PGH4Y4bCHxQUDO4NkOl1FRjdD8fP4rW4k5/I6Dccr6zreJj+j
         KK53ml64MVm0T+fqP3aQrebzzUnX3KAcRSr3FDpTJL2syhWcgs6OAkuM4tASmS1YdPF2
         2qXA==
X-Gm-Message-State: AOAM5321OR7YhWmuD1x2i9Wcb+OErb+unPrTf9CeuZVnctqYB1ExPrGH
        eVhLNRPzT8LIjwh200ydRlFSt38ZBLChMRvpTYY=
X-Google-Smtp-Source: ABdhPJxBNtPRQh4f3Th66CBYahbM0aBRuVIoZOuLhk1TPyDPv3pLBWVBH2gfc0k2YY+7gFI6MEwS4A==
X-Received: by 2002:a17:902:be08:b0:134:924:1733 with SMTP id r8-20020a170902be0800b0013409241733mr3978853pls.64.1631784850768;
        Thu, 16 Sep 2021 02:34:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t13sm2990847pjj.31.2021.09.16.02.34.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 02:34:10 -0700 (PDT)
Message-ID: <61430f92.1c69fb81.b9870.97cb@mx.google.com>
Date:   Thu, 16 Sep 2021 02:34:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.283-116-g78a7bb31bae4
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 71 runs,
 6 regressions (v4.4.283-116-g78a7bb31bae4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 71 runs, 6 regressions (v4.4.283-116-g78a7bb3=
1bae4)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =

qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =

qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.283-116-g78a7bb31bae4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.283-116-g78a7bb31bae4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      78a7bb31bae42ac95b19071349a65f4118e31b0f =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
beagle-xm           | arm  | lab-baylibre  | gcc-8    | omap2plus_defconfig=
 | 2          =


  Details:     https://kernelci.org/test/plan/id/6142dc82de25a9a3bb99a2da

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6142dc82de25a9a3=
bb99a2e0
        new failure (last pass: v4.4.283-72-gd71f8e13792e)
        1 lines

    2021-09-16T05:56:01.249091  / # #
    2021-09-16T05:56:01.249856  =

    2021-09-16T05:56:01.352813  / # #
    2021-09-16T05:56:01.353300  =

    2021-09-16T05:56:01.454564  / # #export SHELL=3D/bin/sh
    2021-09-16T05:56:01.454889  =

    2021-09-16T05:56:01.556013  / # export SHELL=3D/bin/sh. /lava-858711/en=
vironment
    2021-09-16T05:56:01.556320  =

    2021-09-16T05:56:01.657476  / # . /lava-858711/environment/lava-858711/=
bin/lava-test-runner /lava-858711/0
    2021-09-16T05:56:01.658345   =

    ... (9 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6142dc82de25a9a=
3bb99a2e2
        new failure (last pass: v4.4.283-72-gd71f8e13792e)
        28 lines

    2021-09-16T05:56:02.171024  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-09-16T05:56:02.176685  kern  :emerg : Process udevd (pid: 105, sta=
ck limit =3D 0xcb8d0218)
    2021-09-16T05:56:02.180948  kern  :emerg : Stack: (0xcb8d1d10 to 0xcb8d=
2000)
    2021-09-16T05:56:02.189170  kern  :emerg : 1d00:                       =
              bf02b83c bf010b84 cba0b610 bf02b8c8   =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6142de341d62610c2099a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142de341d62610c2099a=
2db
        failing since 306 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/614306a336a839213499a2f6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614306a336a839213499a=
2f7
        failing since 306 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6142ddced047f5208999a2da

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6142ddced047f5208999a=
2db
        failing since 306 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch | lab           | compiler | defconfig          =
 | regressions
--------------------+------+---------------+----------+--------------------=
-+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/6143067a36a839213499a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.283-1=
16-g78a7bb31bae4/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6143067a36a839213499a=
2f2
        failing since 306 days (last pass: v4.4.243-18-gfc7e8c68369a, first=
 fail: v4.4.243-19-g71b6c961c7fe) =

 =20
