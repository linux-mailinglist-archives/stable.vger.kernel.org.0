Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCECE5A4BFF
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 14:35:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229670AbiH2Mfy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 08:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiH2Mfj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 08:35:39 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35DDA883ED
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 05:19:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso14489879pjk.0
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 05:19:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=bdsxgLXMjcbTGrXg0IxBNistplCqzeyvth0Bk+p0cEo=;
        b=e+roA+m78JqkY3wk4cSBYwYqKm8zLogRbE/fCw90Mcn4lFLVzHIp73DqDmSBAdaW1a
         rwzZLEYemvYpHA2saHl0bplzLOfWiTAqBo4tgEaXZ8zcw4BqBb1L5Yjw+OU+lVvjdE2I
         Ktt7LKw7ew5WhwxmDGDybzPnZRfliiRsvTeK6R19SZomT4/MCkB9ED+/1yZeAPw78pln
         ZGc2r7jjIq5SPBe6a/qdzuH6aIYgosGcC2IEb76HLcUUImNFRhuiepbdr/VTAUYErE09
         wzahmMH8s2DdiP3+cLdLWA3X5p8Cd3ofzmnF93KGfxT8JwLxXqfmZ9aIZM1i8EmnBCeA
         PtXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=bdsxgLXMjcbTGrXg0IxBNistplCqzeyvth0Bk+p0cEo=;
        b=hcPGIknzMZbgCEvx1zXk8RuMZnY/7lwY0hQZHt/eHYHp/Yirehe4aBa6FPP1SI3d+X
         c0zQJ1QQB0xOTRbWvXJkCA2fdO1UpOJmYxxHLO9dieB3vyvaFiJfxTVw3D+DrKncKkNx
         bUsiaBEoBzr32GUSvySefq2LSjXjsnfqz/eKUi8vJu5Yy3at6pK6KRAB9KqwBe9ER6dB
         L7Os86V4Vs6oDUmHZqJq5XYGeYdU+uw3jgiab40l92EUhnXzvzJu42sI8FMrvbAQYKaT
         814c3zhXVvv/fzcPMeypUvIX0Sf1rGSLMOsE2mn5VwLg344plTgV5zzuGTjID/UkRmX3
         85ng==
X-Gm-Message-State: ACgBeo1c/jmFXgzxzytiNLmO1ELtBaiAZnUUMViq1tRDX0UJrZ9kmc3w
        4e/ffk9UMDxTmQIiaqf7QoucgwxC1gRSs1VfKz0=
X-Google-Smtp-Source: AA6agR4mSyv3fXw9eBtio+tVBWUZx/Wj482eQcpP3DbwC69FZHTY9nph3TCofgrkL0F79zJPCcE2iA==
X-Received: by 2002:a17:902:904b:b0:170:a3e6:9d98 with SMTP id w11-20020a170902904b00b00170a3e69d98mr16098086plz.50.1661775552623;
        Mon, 29 Aug 2022 05:19:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w131-20020a627b89000000b00537dfd6e67esm5444582pfc.48.2022.08.29.05.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 05:19:12 -0700 (PDT)
Message-ID: <630caec0.620a0220.2b2ab.9645@mx.google.com>
Date:   Mon, 29 Aug 2022 05:19:12 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.325-102-g310ef13ccc72
Subject: stable-rc/linux-4.9.y baseline: 29 runs,
 9 regressions (v4.9.325-102-g310ef13ccc72)
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

stable-rc/linux-4.9.y baseline: 29 runs, 9 regressions (v4.9.325-102-g310ef=
13ccc72)

Regressions Summary
-------------------

platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
beagle-xm                  | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig        | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =

qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.325-102-g310ef13ccc72/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.325-102-g310ef13ccc72
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      310ef13ccc72259d4df1c9fabbd5b5f8b7bf5563 =



Test Regressions
---------------- =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
beagle-xm                  | arm   | lab-baylibre  | gcc-10   | omap2plus_d=
efconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a9d59b1c07dff035565e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a9d59b1c07dff0355=
65f
        new failure (last pass: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a99609b2060287355678

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a99609b2060287355=
679
        failing since 21 days (last pass: v4.9.302, first fail: v4.9.324-43=
-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a93265794fe4a7355656

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a93265794fe4a7355=
657
        failing since 21 days (last pass: v4.9.302, first fail: v4.9.324-43=
-g54391eec23dc) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a9be9903fe12d935567a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a9be9903fe12d9355=
67b
        failing since 19 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv2-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a93265794fe4a7355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a93265794fe4a7355=
654
        failing since 19 days (last pass: v4.9.302, first fail: v4.9.325) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a91edaa4bfd9d835566a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a91edaa4bfd9d8355=
66b
        failing since 7 days (last pass: v4.9.302, first fail: v4.9.325-51-=
g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3      | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a86c017559a259355653

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a86c017559a259355=
654
        failing since 7 days (last pass: v4.9.302, first fail: v4.9.325-51-=
g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-broonie   | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a8ce4ee1cfd31b355655

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a8ce4ee1cfd31b355=
656
        failing since 7 days (last pass: v4.9.302, first fail: v4.9.325-51-=
g469b0835c7652) =

 =



platform                   | arch  | lab           | compiler | defconfig  =
                | regressions
---------------------------+-------+---------------+----------+------------=
----------------+------------
qemu_arm64-virt-gicv3-uefi | arm64 | lab-collabora | gcc-10   | defconfig+a=
rm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6304a842bef26db590355642

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.325=
-102-g310ef13ccc72/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/ba=
seline-qemu_arm64-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6304a842bef26db590355=
643
        failing since 7 days (last pass: v4.9.302, first fail: v4.9.325-51-=
g469b0835c7652) =

 =20
