Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28730478DED
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 15:38:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237321AbhLQOix (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 09:38:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230248AbhLQOix (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 09:38:53 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB28C061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:38:52 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q16so2267137pgq.10
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 06:38:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o6Rt20d3S5BrXCw4kc2KvSi944+uPgB+FbdeqbVndrs=;
        b=fvA0fjCF7aZP4GL+LWRnJo+QYhelOMgdd+F39ZNMzTjrv8iLJMZt13TF8ZuF1Ot6Km
         ZljsAmYzeCM2XNI8TmN3bV0RGHEnTHXhMTFMTIISPh0Y58tVc5mfrd+6g9kBy8XyxsQ/
         7LxDiMcGqwUJ26/q7YnfV8rWkX4a4VplS8TINNBBta8kHZEEJ/n9Jiza83IxcKHI/35Q
         FPKIeBVRH7MEiwjY0W1ybwlb4h2vFhoqs/OvtnGpipuVEE5uP69v9i2QRoHMJBUftOvU
         UgUeQgIwzZY4DV+bbmm9GbuC0sGHWrVuVWZ5uGF8SD9XfGp3G2WoTEj4kUPN0/SD7dGj
         36UQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o6Rt20d3S5BrXCw4kc2KvSi944+uPgB+FbdeqbVndrs=;
        b=wn4J2cZmVIoQIzhS6dpC3urVjS4nwlEtXkWkbmQQllX6xHp8hzOwxrEL/0nPzOTaIq
         DUJ4Gabv6ZJ6waK+y2SQm4yK5SRCtnIzmKJ9KCQUGOjVdWFpeh3BkVeTuNcCYiipMexI
         o0vCWtcWebdRDjaXGQpyn0spb5kxdFV4iSB1GeL0zZFeTer14mx661q7k9jpyRADaT0J
         9Q8yRw+EEEvXjcIArnPGlyMTNpyzwkNHMeIgzzQOmcZ4TUrkDU5Wrl/Z9oH+Wu8O/ofC
         PJJprNqFz+vV7MuhSgLBWnZ3Q3vQwfJJIR+Jo/IqxVGNydJc8oWRcKdOJgkPQ9HvtmlO
         xNAg==
X-Gm-Message-State: AOAM532LDsYLAtAT+NhC16PzM2bbDmntFdLmv8dXWJbSGwRmK64CZXYx
        9FLKcWbKexdUdjVdB017Y7gaRDe0w7HTg8bE
X-Google-Smtp-Source: ABdhPJwpCNAFvWOz+i+cv7XZMVlvXmGTP96/kHyYI245Lt/pAbVEUVgolYY6mEMbOAKqa3BQ/1pOCw==
X-Received: by 2002:a65:5202:: with SMTP id o2mr3107066pgp.210.1639751932232;
        Fri, 17 Dec 2021 06:38:52 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 38sm8574851pgl.73.2021.12.17.06.38.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 06:38:52 -0800 (PST)
Message-ID: <61bca0fc.1c69fb81.9cf9c.76f9@mx.google.com>
Date:   Fri, 17 Dec 2021 06:38:52 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.167
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 168 runs, 6 regressions (v5.4.167)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 168 runs, 6 regressions (v5.4.167)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig   =
       | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig   | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =

qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.167/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.167
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e8ef940326efd17ca7fdd3cb8791c29a24b04f28 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig   =
       | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6e038bcc685ead39714b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6e038bcc685ead397=
14c
        new failure (last pass: v5.4.166) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig   | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc68528eadf91e8b397143

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc68528eadf91e8b397=
144
        new failure (last pass: v5.4.166) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6c8ee310815c2f397149

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv2-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6c8ee310815c2f397=
14a
        new failure (last pass: v5.4.166) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv2-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6cc69c87c62a0139714c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv2-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6cc69c87c62a01397=
14d
        new failure (last pass: v5.4.166) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6c8df193e30ad7397137

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_arm-virt-gicv3-uefi.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6c8df193e30ad7397=
138
        new failure (last pass: v5.4.166) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
       | regressions
-------------------------+--------+---------------+----------+-------------=
-------+------------
qemu_arm-virt-gicv3-uefi | arm    | lab-broonie   | gcc-10   | multi_v7_def=
config | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6c8bf193e30ad739712f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.t=
xt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.167/ar=
m/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm-virt-gicv3-uefi.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6c8bf193e30ad7397=
130
        new failure (last pass: v5.4.166) =

 =20
