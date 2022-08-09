Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F05458E3D0
	for <lists+stable@lfdr.de>; Wed, 10 Aug 2022 01:42:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229449AbiHIXmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 19:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiHIXmP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 19:42:15 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D8C7538C
        for <stable@vger.kernel.org>; Tue,  9 Aug 2022 16:42:14 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id c19-20020a17090ae11300b001f2f94ed5c6so2145968pjz.1
        for <stable@vger.kernel.org>; Tue, 09 Aug 2022 16:42:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=yS7tXM2kgiqsLyiZVGZ6WRms7icVrOXqdVMAy/s3lpg=;
        b=k3WD4+2f4qUVcqZH9iWruzNW+05PsXHqEYteqTx78FhyaaB6QRnjD09puPwQ2OrvNe
         gwMSWSMAG3q5DFl/JiSNA4TkUunTuOa5gAP7kf1sNri+sBfPaAVvBBQhImdIxiYALidk
         rdt+hWgJbKcoR7MGSOG3UmW2ookfRs9Hk5bdGh08l1Ndw90hKXfiBxkN/rFCcZmhkZyA
         ddBI1k3HAbzJIFB5zkibzjcN3Kz0UgHYpzJ7bpNILcUPMj5bUg8/4Qi0+3t8NfWM+Wtg
         oDxykuB1SuXqNA5EIBJlghiuQzaJtcjEPmMl3t+1siTvYHJvhWWPMSaQpwTL0JwxuzFd
         0p+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=yS7tXM2kgiqsLyiZVGZ6WRms7icVrOXqdVMAy/s3lpg=;
        b=h3WLCq7TijGgZhHPEA533UABXMClYncKDbVamiUT9sst2h1HNf/gZXyfV2GqMwUagh
         n7Vh9ljRNoDC6E//nEshskOtZoXJy+rkbpM8dQh/BXsyP86D8XzE58Gg6HW0b5+Tekh0
         hTULZJaskyKnCJbjzUzMBTKvNZo2+QIKrvDayQF+cF0NicpvLoyqwENWVwomq6kYQ1iY
         2kU9eP7g8xwnGSfn5oEUkSnWxLJzmeMzElIRpBlY4ZkDpKhyokue/7KqNqwt+iDOiojR
         bksVNKuz6oOoaCNAzJwaJ0tl4IddHed2E3xSRjO/d59w6cY9caDH07lSAJFQbTUoEYJx
         0Xvw==
X-Gm-Message-State: ACgBeo3ld4+276CVm7Ma4lIXknORR03b/ndxl6vB2l+CEhazEdJVA6p4
        8WaJRUejFGOvfL72P/jCEIKUTtZavduZvW+t8Fo=
X-Google-Smtp-Source: AA6agR4sMfTse+nvHw/Nxkrkd5Zq32qmYSOyuZcXP0olStXLck7XzseAyhhTQkqs68oda7xiGSyyzg==
X-Received: by 2002:a17:90a:d585:b0:1f4:f9a5:22a9 with SMTP id v5-20020a17090ad58500b001f4f9a522a9mr847916pju.49.1660088533819;
        Tue, 09 Aug 2022 16:42:13 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q14-20020a170902dace00b0016f035dcd75sm11375095plx.193.2022.08.09.16.42.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Aug 2022 16:42:13 -0700 (PDT)
Message-ID: <62f2f0d5.170a0220.4b40f.3dd3@mx.google.com>
Date:   Tue, 09 Aug 2022 16:42:13 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.209-16-g0bf8828e9254e
Subject: stable-rc/linux-5.4.y baseline: 142 runs,
 5 regressions (v5.4.209-16-g0bf8828e9254e)
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

stable-rc/linux-5.4.y baseline: 142 runs, 5 regressions (v5.4.209-16-g0bf88=
28e9254e)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.209-16-g0bf8828e9254e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.209-16-g0bf8828e9254e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0bf8828e9254e4c8917e2556001411f431ba0a70 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2baa26e168bd69ddaf081

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2baa26e168bd69ddaf=
082
        failing since 91 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2baa16e168bd69ddaf07b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2baa16e168bd69ddaf=
07c
        failing since 7 days (last pass: v5.4.180-59-g4f62141869c8, first f=
ail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2ba7053ddeb07fedaf062

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-collabora/baseline-qemu_arm64=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2ba7053ddeb07fedaf=
063
        failing since 7 days (last pass: v5.4.180-59-g4f62141869c8, first f=
ail: v5.4.207-123-gb48a8f43dce6) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2baa36e168bd69ddaf087

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2baa36e168bd69ddaf=
088
        failing since 91 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =



platform                   | arch  | lab           | compiler | defconfig |=
 regressions
---------------------------+-------+---------------+----------+-----------+=
------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62f2baa56f61555723daf079

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.209=
-16-g0bf8828e9254e/arm64/defconfig/gcc-10/lab-broonie/baseline-qemu_arm64-v=
irt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62f2baa56f61555723daf=
07a
        failing since 91 days (last pass: v5.4.191-85-ga4a4cbb41380, first =
fail: v5.4.191-118-g7dae5fe9ddc0) =

 =20
