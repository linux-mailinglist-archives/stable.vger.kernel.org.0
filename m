Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1F03FDE43
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 17:10:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245502AbhIAPLM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 11:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245176AbhIAPLL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 11:11:11 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D117BC061575
        for <stable@vger.kernel.org>; Wed,  1 Sep 2021 08:10:14 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id n13-20020a17090a4e0d00b0017946980d8dso4896212pjh.5
        for <stable@vger.kernel.org>; Wed, 01 Sep 2021 08:10:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WLJyj9dtYi/n+NlRT4K3QTE/Wvx+KvbraAG2ERRyc08=;
        b=tJrDuWtMTpmI5VpiTj0GLa4xN6HWHIDpqa2OuviwRaZ97TEmjyyWlcnFEXm0sMbbTk
         QHHZSY7N1afvnAyJ+VaxLhTJ8pLEXI1Tt/OYl4arHdx/fiYnCeL/BCcHijpg57mvj1B3
         G02H1BanQOMjNq/8r2UqB7DxQZgYGCc306+VUQv2+qfI3DCEIXxFZ/huyvtpmQ8nQWWN
         aObD5Z1ajXvZ9I6my17DPuJWD1uNuzGJ7SPP6/G+iSVw+6nAM2QBt7SU+fd0cci/XHjP
         bu8pWrhhJrsZDmbDXky6tOo3VmbTwikQ5b93QRWDAKooBzIUnpZd+XWtVAMiz4VVsYz2
         yjOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WLJyj9dtYi/n+NlRT4K3QTE/Wvx+KvbraAG2ERRyc08=;
        b=OQ+3Tw8HRWOonAOPId+02HoTwdt8CYceqUUAYaD7S2znWlr4mcPqeX3+6PIbTaOa8G
         9BJpAS+ZzIEURLN9C+KcSAVjkVwjZ4W+Mto27W9zyZWxzTy+wuVjUJf4ahfCGnKGu8oa
         J0C60eS0+A+nGZ29/D8wro8KKkP4Ft+5FHoZfcjsa1qntGxAiXkmO+aQluv+Rem+2+qx
         gBNvxxxl8a+WLcxOQBci+0Lauh93M+OVQchda8hskkFosogtNZVgJFTMqRjfmaEfyiEv
         aXJwXNWTBnDUwxoLhHWjp5rwasHedpnurSaZSPQq1/JRne6v00zX3/BI4Y38Ug4ZEuMk
         EmwQ==
X-Gm-Message-State: AOAM533LZXS5mIah9UegSIL7SaIfb5TtzAK6sG9yNEmLM10mwMFHkz6g
        SWcRQ76Gif6jURKcW+la6U8GBcdb1ieqmiNhEOI=
X-Google-Smtp-Source: ABdhPJxn9DK6u3porEwJ8rp7MARxRI5KEfJh/PZKWlvLMsR0oJOOdZSBZdqcAVzIZ/7r5m/Vh/sycA==
X-Received: by 2002:a17:902:ed8b:b0:138:b1c7:f3ab with SMTP id e11-20020a170902ed8b00b00138b1c7f3abmr53479plj.77.1630509014131;
        Wed, 01 Sep 2021 08:10:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t28sm282014pfe.144.2021.09.01.08.10.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Sep 2021 08:10:13 -0700 (PDT)
Message-ID: <612f97d5.1c69fb81.3c8bb.0d92@mx.google.com>
Date:   Wed, 01 Sep 2021 08:10:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.281-15-gb516404961c3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 124 runs,
 5 regressions (v4.9.281-15-gb516404961c3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 124 runs, 5 regressions (v4.9.281-15-gb516404=
961c3)

Regressions Summary
-------------------

platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx7d-sdb            | arm  | lab-nxp         | gcc-8    | multi_v7_defconf=
ig  | 1          =

qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.281-15-gb516404961c3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.281-15-gb516404961c3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b516404961c3a13e802d6bfb675cb9a135669e10 =



Test Regressions
---------------- =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
imx7d-sdb            | arm  | lab-nxp         | gcc-8    | multi_v7_defconf=
ig  | 1          =


  Details:     https://kernelci.org/test/plan/id/612f62b11c7be839b88e2c7c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/multi_v7_defconfig/gcc-8/lab-nxp/baseline-imx7d-sdb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f62b11c7be839b88e2=
c7d
        new failure (last pass: v4.9.281-9-g1aa4ebfdd9da) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-baylibre    | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612f5fd1d868cd3f228e2c7a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f5fd1d868cd3f228e2=
c7b
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-broonie     | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612f61d201d5880f878e2c78

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f61d201d5880f878e2=
c79
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-cip         | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612f5fd69e8af8e4cc8e2c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f5fd69e8af8e4cc8e2=
c78
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform             | arch | lab             | compiler | defconfig       =
    | regressions
---------------------+------+-----------------+----------+-----------------=
----+------------
qemu_arm-versatilepb | arm  | lab-linaro-lkft | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/612f5fdc9e8af8e4cc8e2c84

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.281-1=
5-gb516404961c3/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612f5fdc9e8af8e4cc8e2=
c85
        failing since 291 days (last pass: v4.9.243-16-gd8d67e375b0a, first=
 fail: v4.9.243-25-ga01fe8e99a22) =

 =20
