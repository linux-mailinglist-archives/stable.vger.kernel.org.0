Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB39248FF14
	for <lists+stable@lfdr.de>; Sun, 16 Jan 2022 22:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229802AbiAPV0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Jan 2022 16:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbiAPV0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Jan 2022 16:26:18 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55854C061574
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 13:26:18 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id h23so8309800pgk.11
        for <stable@vger.kernel.org>; Sun, 16 Jan 2022 13:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=8XQ5UUcMfsat2X78b+4JXGQ09htQ3Xdf4qzmsw7LJmY=;
        b=m6j8jEWaKAp7Tvc+ad/YAdu5YjOZ7PVnIZaRRo3DJf9YPsS6RwHdCgij94B5SqjA5E
         cbgvJs230Y7pa4j4b7shp3MCBF2WFahvxRi9WZ0X73WY6SkoJLegufzIZKuaJYku25Jl
         vMxLdqQVv+FfS6wGtOWVSvgrGosEb2if7MTPIFq5NQ2j/7XCZum3oJ86tsUkoJcIY3b6
         z8Wv825+kykKIGSJVWkZghslDi8qMgkoW6stPAssyl3jauRoWhe5zetTxwdaLGUZdd0N
         8wLmf0RrZE5qMwhwJjRqMZclllifjc8YnOUUquCT6yJnCoNMZvqaBpwz5YicNhAhd+4i
         eADg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=8XQ5UUcMfsat2X78b+4JXGQ09htQ3Xdf4qzmsw7LJmY=;
        b=HBsqwVWEHUCHkG3kbq/pLkVSG0GBMmigPmQNnBygqqN2fjAnRW8Modv8jMh1TChzmB
         xuR/gyH/UGL5SuocWtrUCd9L8W8z3i2D5RiPA89HXoatkN1/bfcd6yZXeqYnrWqR1Cfp
         qGl/yzOeTYlJk1W8Usc9XUVD3t1JqRSXw0VyShEdyJhSVbzbmoQORhMJq5DQ2r2pQ5jd
         4Xjheq6srA54xOMuMfXV1kEhuKCVDXc8hST7JNkyzhqvOiknrcAPU+bX4OYfg/RdDoqJ
         qzbcWAlbGhq7hCQOXQw0oCQo8sRX3cBrxOrC+/fdj/ZGtYu0ZPEv4F4sObiwrcigSNyD
         XaBQ==
X-Gm-Message-State: AOAM5333fAgdaugPzMDk07b4vK1mC29xomRwQTHumoqrizwuXaVFhoyh
        UDgEJxW/tUtvDE6J9+J+yVk0jVVoSuf7X5yj
X-Google-Smtp-Source: ABdhPJzGQK9qqiqJwBZJch+d2qu0jLjDax6NbnzaH9UVlf0Sdw8uqanlbr8+jftR1BYpcZlDkS8abw==
X-Received: by 2002:a63:9712:: with SMTP id n18mr16452203pge.594.1642368377737;
        Sun, 16 Jan 2022 13:26:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pi7sm9222562pjb.23.2022.01.16.13.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Jan 2022 13:26:17 -0800 (PST)
Message-ID: <61e48d79.1c69fb81.77fad.a1fb@mx.google.com>
Date:   Sun, 16 Jan 2022 13:26:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-20-gd24ad3499c6f
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 176 runs,
 4 regressions (v5.4.171-20-gd24ad3499c6f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 176 runs, 4 regressions (v5.4.171-20-gd24ad34=
99c6f)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.171-20-gd24ad3499c6f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-20-gd24ad3499c6f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d24ad3499c6f1b3ff1b14379dafbd9bccc051bd0 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e45bca623a7260b8ef6742

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e45bca623a7260b8ef6=
743
        failing since 31 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e45bdd6f93efca0def673f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e45bdd6f93efca0def6=
740
        failing since 31 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e45bc9a2cae6bff3ef6779

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e45bc9a2cae6bff3ef6=
77a
        failing since 31 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e45bdb39efffa76def6773

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-2=
0-gd24ad3499c6f/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e45bdb39efffa76def6=
774
        failing since 31 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
