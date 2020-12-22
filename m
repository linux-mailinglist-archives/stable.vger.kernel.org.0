Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AB9F2E0B2D
	for <lists+stable@lfdr.de>; Tue, 22 Dec 2020 14:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727058AbgLVNxj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 08:53:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726904AbgLVNxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Dec 2020 08:53:39 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FC5C0613D3
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 05:52:53 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id t22so8523836pfl.3
        for <stable@vger.kernel.org>; Tue, 22 Dec 2020 05:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=quzp7Kajvw/rPvOIJqJzZJO5pPDaOZeBaRy6yunCXrQ=;
        b=hHnsOjBFAkdS46jwh5xsDNo2XH8LJn/ldttoBvurZyjKj9FT32lFK0MvPlIBFU8Jv7
         4u8BRL5tdiat20jIIIzMbu6V2np3K+jt+1161+JrKXfUBQSJ/YLVwArmvFSZiRWwNHhU
         Bh1N2MtvIlA+kXNoQ6s3cvWvjlfVNnPSwploU9fkpYBCNNg46MIoDD95It2LDCXSFm2D
         4f6ujZL3d/5Qqo1Gc4HXQR/POzaib4r2EhMIH8C+Wx6+gVNOuCSnW/o0Nzbsf0N+QFK2
         u8hx9oHA+BApFsgkzhoEr7tNdWDq5BgwFE+gjyYbxDmtFDbqfs7SauWWnZ8RPQwnTr3z
         +jKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=quzp7Kajvw/rPvOIJqJzZJO5pPDaOZeBaRy6yunCXrQ=;
        b=DYboMsn7lT7SIDpwC6A0qU926lp4oehfzdOtmEAmSt83MfRliTudGwvbQOlEirzZQ+
         OzGeSX7kOKxdhgvgyelYooi3qgArlU8Fb0P2NYuPSOqOBHey819w5Fv2HAW4lEEurl7c
         Zfgez3Y9QiPl9SWOT6KrR/ROsLkwZ8pHF6AnNxn05ZyNW6yusSYUVhnIIw0pY8mK2wU5
         jq44t34ScQi4CrHDVQgBdVQeEyGvJyRpTJFa+ChlwdfGSNHUZWFLFtzN92jzWOLqY5tX
         W6KK6+FGF6Mob0v1SNpAR9eFE7l15d6tzVMybn6us/GOrs4VWwzbmFT4cblPNZEQZ4na
         WkhQ==
X-Gm-Message-State: AOAM532G9sSvdy0R4HuH9rdjlxj75+crpOxzxW0scjqlry/dwhV2pFoV
        Gh9YeAxOvByUl3iaUUYjPXw1ENhLfhmXNQ==
X-Google-Smtp-Source: ABdhPJyrbx5SyqgtFFY1JT4dr1aN114nO7UjQlTuXIPIxu843Xup4XR4W4GoHug8481m186jkd3Pow==
X-Received: by 2002:a63:c501:: with SMTP id f1mr12093861pgd.1.1608645172152;
        Tue, 22 Dec 2020 05:52:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 37sm19938381pjz.41.2020.12.22.05.52.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Dec 2020 05:52:51 -0800 (PST)
Message-ID: <5fe1fa33.1c69fb81.6cc9c.693b@mx.google.com>
Date:   Tue, 22 Dec 2020 05:52:51 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.248-34-g56fdf4c0ed07
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 139 runs,
 7 regressions (v4.9.248-34-g56fdf4c0ed07)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 139 runs, 7 regressions (v4.9.248-34-g56fdf4c=
0ed07)

Regressions Summary
-------------------

platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =

panda                      | arm  | lab-collabora   | gcc-8    | omap2plus_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-baylibre    | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-broonie     | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-cip         | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =

qemu_arm-versatilepb       | arm  | lab-linaro-lkft | gcc-8    | versatile_=
defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.248-34-g56fdf4c0ed07/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.248-34-g56fdf4c0ed07
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      56fdf4c0ed0751c15082860d5493e7dc2f8fb54a =



Test Regressions
---------------- =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig  | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c85d41990cabd5c94cd7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe1c85d41990cabd5c94=
cd8
        new failure (last pass: v4.9.248-25-gb874f9fd96f4b) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
panda                      | arm  | lab-collabora   | gcc-8    | omap2plus_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c868037d0478b1c94cb9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fe1c868037d047=
8b1c94cbe
        new failure (last pass: v4.9.248-25-gb874f9fd96f4b)
        2 lines

    2020-12-22 10:20:20.683000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/129
    2020-12-22 10:20:20.692000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-baylibre    | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c6bece69e5b993c94d09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe1c6bece69e5b993c94=
d0a
        failing since 38 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-broonie     | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c6d1311674b381c94cda

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe1c6d1311674b381c94=
cdb
        failing since 38 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-cip         | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c6c683e3ca02e2c94cc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe1c6c683e3ca02e2c94=
cc1
        failing since 38 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-collabora   | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c692f98a861276c94cc2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe1c692f98a861276c94=
cc3
        failing since 38 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =



platform                   | arch | lab             | compiler | defconfig =
          | regressions
---------------------------+------+-----------------+----------+-----------=
----------+------------
qemu_arm-versatilepb       | arm  | lab-linaro-lkft | gcc-8    | versatile_=
defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe1c691f7a3e68c09c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.248-3=
4-g56fdf4c0ed07/arm/versatile_defconfig/gcc-8/lab-linaro-lkft/baseline-qemu=
_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe1c691f7a3e68c09c94=
cc4
        failing since 38 days (last pass: v4.9.243-16-gd8d67e375b0a, first =
fail: v4.9.243-25-ga01fe8e99a22) =

 =20
