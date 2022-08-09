Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2653058D153
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 02:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236913AbiHIAVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Aug 2022 20:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244705AbiHIAVI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Aug 2022 20:21:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F69C2ADE
        for <stable@vger.kernel.org>; Mon,  8 Aug 2022 17:21:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id p14-20020a17090a74ce00b001f4d04492faso10684619pjl.4
        for <stable@vger.kernel.org>; Mon, 08 Aug 2022 17:21:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=r4MwkkoyaYALFhB7lZ6by9NKiT3EIS9LXoOpS4meqdM=;
        b=o/VhiiDMHC2VJOc4Z3ArQI8ghLS16wKLub0JVMJao5WbJx+v/35CPPtpvHnM+UiPR7
         7S2zrq5xIunAkMLwxq5S/Rf1+yg4ZSwod8kq8vpii4WXhYep+NESGOC9bRM1QKaln8Hz
         73ohxINhJa6dYlqfn1bHQdY5g03ETUPIjJOIhHVVzKYlg8CM9Knu1D5fmOQFlzni5kRI
         rSuAlC/ma4cAcCJ8RewzmS4MJ1goPmuRr7WL45lUz1eLhqKYW8SSNH42BjlEv06pesUZ
         aIlaNWiJ2r74vZBZzsQHS1uZA1n5k6D+G7XKI00QoW2n40GsyUBOI1kLcknFV1aFr0px
         b1qQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=r4MwkkoyaYALFhB7lZ6by9NKiT3EIS9LXoOpS4meqdM=;
        b=Olx6yWpRCYWcYpY13PfBlQLSzITeatoMBXcW2UIydsDTqrIbnoSsj0CW7RKpaA3ccz
         c0YJsBtlJZI/XXqGUo825pm8SHX+iM+yIMYoNqm8U//E6bt5BNmWR9EV9riAMvWfQanr
         dBjILh5TZHEr7lmfbOl7DOJHv9L/vNf24cTmn2lXkGfGDUpDZ1iNbccIhvz8fw2xD+Lp
         i8zGtfu94mcJHdCocz+v6bveIkqTDJIvrxGv/jYY/TjTrSj27cYEDVUXzWEnEPYHmNxF
         E0V5thUeqM8Z3vAOR0GU8FvDmT+P50iB1rMtdqK0R0AgldO8O5zzi7y4uiI9x0c5LCWS
         VLlA==
X-Gm-Message-State: ACgBeo14KAYWAu+zFbIdhVTG9a0e5G9GUWhTDVvqsad4ZW6hD3vBlBCK
        DueZwoCCRardFqyVV3nHN1+ycfch7tq3qQjK2NI=
X-Google-Smtp-Source: AA6agR44YKJeQzFRo1+40FjP0Il/P68w84ggTJTBebpExigRm3Crywtj3qYQiBgybyQ/bCyJKry3qg==
X-Received: by 2002:a17:90b:4b0a:b0:1f5:f2c3:645c with SMTP id lx10-20020a17090b4b0a00b001f5f2c3645cmr17334096pjb.10.1660004466633;
        Mon, 08 Aug 2022 17:21:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l15-20020a170903244f00b0016c4e4538c9sm9644900pls.7.2022.08.08.17.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Aug 2022 17:21:05 -0700 (PDT)
Message-ID: <62f1a871.170a0220.dd2f5.f92a@mx.google.com>
Date:   Mon, 08 Aug 2022 17:21:05 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.254-30-g67daacde1ca6
Subject: stable-rc/queue/4.19 baseline: 127 runs,
 10 regressions (v4.19.254-30-g67daacde1ca6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 127 runs, 10 regressions (v4.19.254-30-g67da=
acde1ca6)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =

rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.254-30-g67daacde1ca6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.254-30-g67daacde1ca6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      67daacde1ca61a885a851ec74cfa099be5e171f7 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f177a3be112f9cc1daf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s90=
5x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f177a3be112f9cc1daf=
07c
        failing since 111 days (last pass: v4.19.238-22-gb215381f8cf05, fir=
st fail: v4.19.238-32-g4d86c9395c31a) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f17559f5dbec8a18daf071

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f17559f5dbec8a18daf=
072
        failing since 90 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f17762f673053b3ddaf06b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f17762f673053b3ddaf=
06c
        failing since 90 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f1756d1edaa762d1daf068

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f1756d1edaa762d1daf=
069
        failing since 90 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv2-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f17763f673053b3ddaf071

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f17763f673053b3ddaf=
072
        failing since 90 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f1755bf5dbec8a18daf077

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f1755bf5dbec8a18daf=
078
        failing since 90 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3        | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f176fe381cd3c3acdaf0a6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f176fe381cd3c3acdaf=
0a7
        failing since 90 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f1751df6757cd498daf093

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/basel=
ine-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f1751df6757cd498daf=
094
        failing since 90 days (last pass: v4.19.241-58-g8b40d487da7e, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_arm64-virt-gicv3-uefi   | arm64 | lab-broonie   | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/62f176fffc50acdbebdaf059

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-vi=
rt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f176fffc50acdbebdaf=
05a
        failing since 90 days (last pass: v4.19.241-58-g5e77acf6dbb6, first=
 fail: v4.19.241-83-g0ec5709aa1da) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
rk3399-gru-kevin             | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62f173e35eee33e102daf086

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.254=
-30-g67daacde1ca6/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/bas=
eline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62f173e35eee33e102daf0a8
        failing since 155 days (last pass: v4.19.232-31-g5cf846953aa2, firs=
t fail: v4.19.232-44-gfd65e02206f4)

    2022-08-08T20:36:47.421472  /lava-6997044/1/../bin/lava-test-case<8>[  =
 36.645428] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-i2s1-probed RESUL=
T=3Dfail>
    2022-08-08T20:36:47.421634     =

 =20
