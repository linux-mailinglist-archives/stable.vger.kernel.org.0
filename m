Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A054A492B0B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 17:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244194AbiARQT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 11:19:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346194AbiARQTR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 11:19:17 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 673F9C06174E
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:19:16 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id pf13so23847700pjb.0
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:19:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OTmCxpmE0kdCFAKZGcGit3fNCWmQNEo3CcdnH37KCGE=;
        b=AwL2d7z0UUPoekNFrNnhp64MaezIBpKdZ1dtA4+/5OV+H7Z7qtx4TgO7/k5HU6H8KT
         8TfxYL8IWilHeq1iD2I88TupmZN6Vc2EuJoC3RMj+2+ab7JzvgOIWxcc0fMQXeYvuZwp
         kT52dFmqIp13hrn0QShLdS9uDPqAJRoZ2FvwtJ9RwFuu+5FS7+e4UQAXoRVgqDWjBJTR
         1pzl6OMXLRW9DuE0DHRmP4st4eqpPzhSnDXuraisYaL/0RsllEtgCnGbICnMxgUblQIe
         D+34+pdtGSkHOBQmgVi72qgzM61lV+WoxU3/YdsRIyKhGd1lt6htRA+WN9WrJU7fuuBQ
         o5sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OTmCxpmE0kdCFAKZGcGit3fNCWmQNEo3CcdnH37KCGE=;
        b=Iy9UMLV7Xe1KWYhxD1B3jdqTgyk7mGh4PRFl3pfQpJmoiG7g6M5FKRfF4ktKDIOnE/
         sin4p9GjuXuaP+LHZEDuIG5SvOjTyial1xe3wK88+uHSyZ7jYTqVcHM7qGeUPoXWimbV
         ajVpgS/o3LuQubhxYR/oOZWuooPDYz/V/ATlqLjRn3pEYasgAoutbMAvtY2+vnKDFWIu
         ZcqMQg1AOzpei9baYdJEZZkc9smVFPmJzkA0Z6pPXSjYO3pZ50DqI3EQoB7Z7AtxafQz
         D2Zz9CjXOWVb14yEGGgBZ/f2094hicaZkUtkmG8fopOilESya8oQ/4nIhRKzxUnJIdvB
         x5lQ==
X-Gm-Message-State: AOAM531TMYZnC6E7k7tDa5lQLNqwCm7bN60r9tQOlk/8vC9cBOcQTBMc
        f3uDdKTs58lrb9fD0dpoksdZXeY4Ter1yY2W
X-Google-Smtp-Source: ABdhPJz0yFFCSyBQ3hZnd6gXxfYqwH2zmT+g2ifW4KT6L93UjWceWML5ED6m1qabnKWy93L23MhzOw==
X-Received: by 2002:a17:90b:3148:: with SMTP id ip8mr27665955pjb.61.1642522755742;
        Tue, 18 Jan 2022 08:19:15 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 34sm14981483pgl.72.2022.01.18.08.19.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 08:19:15 -0800 (PST)
Message-ID: <61e6e883.1c69fb81.711e3.755f@mx.google.com>
Date:   Tue, 18 Jan 2022 08:19:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.171-32-ge8a73034b1a9
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 4 regressions (v5.4.171-32-ge8a73034b1a9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 4 regressions (v5.4.171-32-ge8a7303=
4b1a9)

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
el/v5.4.171-32-ge8a73034b1a9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.171-32-ge8a73034b1a9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8a73034b1a9c12f921c37738d6110fa8d3e64ef =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6b2606d000de10aef6746

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6b2606d000de10aef6=
747
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6b2836af7af9f11ef675a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6b2836af7af9f11ef6=
75b
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6b262012c1312ebef6754

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6b262012c1312ebef6=
755
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61e6b2846af7af9f11ef6767

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.171-3=
2-ge8a73034b1a9/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e6b2846af7af9f11ef6=
768
        failing since 33 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
