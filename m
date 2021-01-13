Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C26072F51B9
	for <lists+stable@lfdr.de>; Wed, 13 Jan 2021 19:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbhAMSLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jan 2021 13:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727998AbhAMSLg (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jan 2021 13:11:36 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72049C061575
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:10:56 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id z21so2000735pgj.4
        for <stable@vger.kernel.org>; Wed, 13 Jan 2021 10:10:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9S5sIQDjOVcxwPZJ6PuLxX+EyPzaALkZJbRLTpvr8Rc=;
        b=TP6hrFge/o+mrwlYVtAig9l5M2HiylonBGg/zPUtTnMQ7KAqVwEJaSYyr4yZ3SQeq3
         JvTTnewlCbxn+Epw6/2TBvf0obEOnQuM3DcodQyueUoU0+dTacfYTSX1wubLYcO6tqqo
         T2IGVXnCJW4sdv4OsEYSwSEpK4c7AGWkg2tkvt/dlu/o5DrLiAkaHUNU1z98LfAbYDuV
         SsYRuazvDwuSEHsS/BTkG6B20EO83JxZ3RcY0Aqm3KmiVuarAxvSp2yJiBlyoEIh79Pk
         AvnUWhIc67NuTx840h6F1rRcLzylPbRMx0oWgqvVBd1h2oNkvOc309vMDj5MgHkvRnug
         /bKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9S5sIQDjOVcxwPZJ6PuLxX+EyPzaALkZJbRLTpvr8Rc=;
        b=llYxyxyBFArGv4PfiFu/+w46UGliMw2fhHrobi7UHC7iwtQhifds7OR0nHA/HRVQCD
         XgiSZjSKgQywDw4lBmXQ3Kc+XLMKyoDsbjzIGhxVE2ysjuebUkatyMRmQ7VqrVah7/Lx
         wkLeIE1oEVgDZdrPLDFIcu5uAbyCxDsEsYOP1PfuwJ7DeL3MysGAZEecgtfcHh2Gy/7f
         CXeN8l2nF6lC4KDRJwqre0Zb6B3k+sZtP4AVmefWcdOwUqBQTfpflHISbLQrzMjjDEc3
         BdSkvu1eSYUrZjXu3eUeGcxbcn4DuavHIGqg5olTgLUt1lwb83V6xbNcSI4V9IRiQGTQ
         3LzQ==
X-Gm-Message-State: AOAM530lWDVShjsj5+AAKhEZ63oEz6oXXYW/Rnms3oblloJGlOiWLxvC
        ijjBTzlE7tZfovCDjZd7FzSTxk3maIkFng==
X-Google-Smtp-Source: ABdhPJxsXFHhDNi1pkA1cEexu0TXbg8gqIkW2AqKtUfgoKJus+Lp66yYx8RZ+ji3QW88ugDQawJkoA==
X-Received: by 2002:a62:1816:0:b029:1ae:6d39:b92e with SMTP id 22-20020a6218160000b02901ae6d39b92emr3214043pfy.81.1610561455575;
        Wed, 13 Jan 2021 10:10:55 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q35sm3516442pjh.38.2021.01.13.10.10.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 10:10:54 -0800 (PST)
Message-ID: <5fff37ae.1c69fb81.255a7.70f8@mx.google.com>
Date:   Wed, 13 Jan 2021 10:10:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.250-37-gad5a48d8119a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 92 runs,
 10 regressions (v4.4.250-37-gad5a48d8119a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 92 runs, 10 regressions (v4.4.250-37-gad5a48d=
8119a)

Regressions Summary
-------------------

platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =

qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =

qemu_i386-uefi      | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =

qemu_x86_64         | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.250-37-gad5a48d8119a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.250-37-gad5a48d8119a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ad5a48d8119a44c9985dfd239ce05f4ecf344046 =



Test Regressions
---------------- =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
panda               | arm    | lab-collabora | gcc-8    | omap2plus_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff03ad7aa817ecf0c94cc2

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fff03ad7aa817e=
cf0c94cc7
        failing since 3 days (last pass: v4.4.250-3-g00441213386a, first fa=
il: v4.4.250-4-g585b96e43cef)
        2 lines

    2021-01-13 14:28:57.835000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/116
    2021-01-13 14:28:57.844000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff01dd4d9eb5720ac94cef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff01dd4d9eb5720ac94=
cf0
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff0452456e19b6a6c94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0452456e19b6a6c94=
cda
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv2 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff0275224b1d0332c94ce0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0275224b1d0332c94=
ce1
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-baylibre  | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff01dcdc9af6e550c94cc9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm=
-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff01dcdc9af6e550c94=
cca
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-broonie   | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff040bc4d67e507cc94d4a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-broonie/baseline-qemu_arm-=
virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff040bc4d67e507cc94=
d4b
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-cip       | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff024ba369c3aa74c94cc4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-virt=
-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff024ba369c3aa74c94=
cc5
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_arm-virt-gicv3 | arm    | lab-collabora | gcc-8    | multi_v7_defconfi=
g  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff0633e62a363147c94dc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff0633e62a363147c94=
dc6
        failing since 60 days (last pass: v4.4.243-18-gfc7e8c68369a, first =
fail: v4.4.243-19-g71b6c961c7fe) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_i386-uefi      | i386   | lab-baylibre  | gcc-8    | i386_defconfig   =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff033e76dcbcd859c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-u=
efi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff033e76dcbcd859c94=
cc0
        new failure (last pass: v4.4.250-37-ga4e4f0705fa2b) =

 =



platform            | arch   | lab           | compiler | defconfig        =
   | regressions
--------------------+--------+---------------+----------+------------------=
---+------------
qemu_x86_64         | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fff02ce0e3061cfddc94cd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.250-3=
7-gad5a48d8119a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x8=
6_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fff02ce0e3061cfddc94=
cd2
        new failure (last pass: v4.4.250-37-ga4e4f0705fa2b) =

 =20
