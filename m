Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FFAA426FCB
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 19:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231268AbhJHR70 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 13:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231237AbhJHR70 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Oct 2021 13:59:26 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D533EC061570
        for <stable@vger.kernel.org>; Fri,  8 Oct 2021 10:57:30 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id g13-20020a17090a3c8d00b00196286963b9so9908028pjc.3
        for <stable@vger.kernel.org>; Fri, 08 Oct 2021 10:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YE5cRRsQ9tUj8E8AwH6DvUApu9lzvt8hseiqKbAoMiw=;
        b=ILURTgJmTOuc+ZwvbuHntV7ZtaEW0HuDuKVLX3SfKL44o19Oqa3EFtLdvye+LMLbEA
         RbOSbF7s46pPpCatlQpKpasRELqlTVx9f1q0U4/87/7mKdG1lOI/n4k4M/5uPJMEAkB9
         mx7Q59XF79GM3VgHjhobemEj5sKUD2dJC5jhXd4EV9HbfEj/N44Ny8P/9LMe9MuyAwg5
         FiKy4ruUVhvRSdcHhoRavrE6v9yGZqOhs+e0bqBX3cHOJC2cTeTDVu8rCEIUn/40JIvb
         MlT/TtuQ+EyDlE+U0gpxYrZZW2fuDliXona3dU3IuJ1+VMxR4ijefMT9qwXBcTlAWr3Y
         YGxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YE5cRRsQ9tUj8E8AwH6DvUApu9lzvt8hseiqKbAoMiw=;
        b=zExp4wvPA5hdXppM525OGmDsvVfNR5gmvbGuSwLgcNYkqmbjnsUhjU/BY6+JXGFEC9
         iZzfWH5uhGbJAl5Fj1xlGnPRBAaueNAG3bSdZjUuWsY46SHjcL4lIAkkK/q2kJ+3YKtl
         3dI9+a9XwzdNbiO8lBalhGV0wmKDdDj0B450e2roZLAYvz1kxuGU3Zu7t9OhjPN/NasD
         KX1np3iO7TCuFGnZfjZjWCX2XDe/TOQyEK/8jgCii5IqUn0FkK+smqFHbQTurbfj2B7Q
         roMoITDAoC9zoJ0EgUkQuivnw5jyur7rlF2J3QtSaP19PzyuO0uvxm/YiNrvZd5ZMzCc
         ci+g==
X-Gm-Message-State: AOAM531BJySMuKtFIxV7JN57lL2bnt+gtXLdiX1Itql6huOVaRXQAphF
        O/zLeh7WLaz8Q+Samc5iaxIvQrbNPA7j3F0N
X-Google-Smtp-Source: ABdhPJx0o3ZnRqc2UHgeneCAUNmNi8JkHlL/UP1UUmB9W7tka234QwtEdabyREKcbxx5+0w9ApLEag==
X-Received: by 2002:a17:90b:390b:: with SMTP id ob11mr3084599pjb.145.1633715850129;
        Fri, 08 Oct 2021 10:57:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 26sm5420pgx.72.2021.10.08.10.57.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Oct 2021 10:57:29 -0700 (PDT)
Message-ID: <61608689.1c69fb81.a84bc.005a@mx.google.com>
Date:   Fri, 08 Oct 2021 10:57:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.287-8-gc9a8123a0640
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 96 runs,
 6 regressions (v4.4.287-8-gc9a8123a0640)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 96 runs, 6 regressions (v4.4.287-8-gc9a8123=
a0640)

Regressions Summary
-------------------

platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.287-8-gc9a8123a0640/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.287-8-gc9a8123a0640
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c9a8123a0640ee5387d3cd085463889b75d686f2 =



Test Regressions
---------------- =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6160538dd61b0f5de099a2f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6160538dd61b0f5de099a=
2f3
        failing since 328 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/616056e40492fbfc0799a2e5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616056e40492fbfc0799a=
2e6
        failing since 328 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv2 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61606d2ef993e768a699a376

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61606d2ef993e768a699a=
377
        failing since 328 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-baylibre  | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6160538f6cc09fe25b99a2f0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6160538f6cc09fe25b99a=
2f1
        failing since 328 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-cip       | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/616056bd61ab2e0dbd99a2dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-cip/baseline-qemu_arm-vir=
t-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/616056bd61ab2e0dbd99a=
2de
        failing since 328 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =



platform            | arch | lab           | compiler | defconfig          =
| regressions
--------------------+------+---------------+----------+--------------------=
+------------
qemu_arm-virt-gicv3 | arm  | lab-collabora | gcc-8    | multi_v7_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61606d7d587db6060a99a2db

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.287=
-8-gc9a8123a0640/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61606d7d587db6060a99a=
2dc
        failing since 328 days (last pass: v4.4.243-14-gcb8e837cb602, first=
 fail: v4.4.243-20-g3c35b64319c2) =

 =20
