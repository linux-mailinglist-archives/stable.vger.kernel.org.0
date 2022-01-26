Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1DA49C03C
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 01:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235355AbiAZAiS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jan 2022 19:38:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235350AbiAZAiS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jan 2022 19:38:18 -0500
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49498C06161C
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 16:38:18 -0800 (PST)
Received: by mail-pg1-x531.google.com with SMTP id v3so14415812pgc.1
        for <stable@vger.kernel.org>; Tue, 25 Jan 2022 16:38:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5ttJ32/eyxUX2BgicheR4A8Vx7w0uWCdGZKgFM8JDH0=;
        b=nlYeGdo+Fh1b4ap9INH+r/glg5ZCQdw8aLdvsCSOwD+yW2AyxfrKuEzcLssgc97gkx
         oRWT5ipEsILEs6z22/PEVXOM3fvXdmXHMJTecZaKBUJjIRgUIVntNWYmcRzNLUqReg3e
         DBEhj4GjEJ8+71uMtySQyb855RADwX0HeJS+41PFPBZsbP5tVdMiL69IDmpDad6MUzHR
         urHjawdtpW4A2/cUawmc8gSN9orxX94cIeXnyDB3OJEafWRl8hXB8hy5MXocacZxPbsR
         okm04fpZYtucGdt4MsYxUQWy/36zJUGoHBvndPh+dJWF+45qotuccpdEG3/nJnmbPtz8
         6IiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5ttJ32/eyxUX2BgicheR4A8Vx7w0uWCdGZKgFM8JDH0=;
        b=HR69iMYLsCjzYJNgK6Dn7brFYsR2Z6V+bcYn0iVXIlL6MnoP5WeXQoqTc/nEAHOEP1
         JZ3F4/Hdi8LU/bCQFUdPYVYMD1w/eKdygs3Q6eJ6EchcNX/9TMmkdgkROis1akg8O0mu
         xRqjSmUBeFF3aJoAHBTOmkNz/DxTPtKw7n2dv7kQ2R1ek+fgc1Ey6e3URRSGVSUDSYaB
         FX84CpA00QynnY/Eb0sGeHbqFTAjjf86/8o2zjJ9GgrsWYiq/vWEASlHKyAFywG5OVPR
         1KbeioBz8q0xqjlLzx2yEkDSILMjdwNzLVQZPvUMGjtNxsfWcrUqf2ljNlPr+Xpgfhv9
         Zj/Q==
X-Gm-Message-State: AOAM5332qTZU00lS25tTEUffPrqMUcg9jGtE4YHgTtd8f44WkAs4GvOS
        y+wuM5U3gpRYfh4q5PWMJwTf1cGQt8wdi0zH
X-Google-Smtp-Source: ABdhPJygQThs3QREWrA86wmGNej98BXyqRkGRciZYsVQmmlpYWN8PdMgvUlFaoMJg/9+CIdN3Nwy/w==
X-Received: by 2002:aa7:91c2:0:b0:4bc:6c97:401 with SMTP id z2-20020aa791c2000000b004bc6c970401mr20549439pfa.17.1643157497539;
        Tue, 25 Jan 2022 16:38:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm188223pfk.110.2022.01.25.16.38.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jan 2022 16:38:17 -0800 (PST)
Message-ID: <61f097f9.1c69fb81.ab983.0dbd@mx.google.com>
Date:   Tue, 25 Jan 2022 16:38:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.173-317-gb9fb58c8fa63
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 151 runs,
 6 regressions (v5.4.173-317-gb9fb58c8fa63)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 151 runs, 6 regressions (v5.4.173-317-gb9fb=
58c8fa63)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.173-317-gb9fb58c8fa63/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.173-317-gb9fb58c8fa63
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b9fb58c8fa638249487dbb2e90ffed66f1d742bc =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61f05d7d6f6907303babbd3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f05d7d6f6907303babb=
d3e
        failing since 5 days (last pass: v5.4.171-35-g6a507169a5ff, first f=
ail: v5.4.173) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxbb-p200          | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61f061dbb67b5c2de3abbd17

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f061dbb67b5c2de3abb=
d18
        new failure (last pass: v5.4.173-321-g34a12dd3db7f) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f062db18ebde0784abbd2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f062db18ebde0784abb=
d2e
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f05f031f209bf215abbd1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f05f031f209bf215abb=
d1b
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f062f0afff30176aabbd2a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu=
_arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f062f0afff30176aabb=
d2b
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61f05f05c308e189e7abbd16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.173=
-317-gb9fb58c8fa63/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61f05f05c308e189e7abb=
d17
        failing since 40 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
