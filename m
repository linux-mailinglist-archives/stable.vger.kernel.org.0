Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B71483946
	for <lists+stable@lfdr.de>; Tue,  4 Jan 2022 00:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbiACXmR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 18:42:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiACXmR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 18:42:17 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 091FDC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 15:42:17 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id t187so17126141pfb.11
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 15:42:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lwv4ZEfpkcX8mk83OSfXxT6tyfSNq0yiB7CYAu6z/TU=;
        b=EX9sXHyBKPfioGxkmSz9ASpey6luutbWtRk4rTdlDIfyzKhShSWMh7iXBasAfpAxg0
         RZISYGfM0v5eIIbfmMZjHmcj5mS66CqEW8O64QcdPBKg5W5YLna8FCHtVJqSRBXmCwxi
         A9TZpPfenMWxZuJXpQmIKBNaySyQ2X9TI/782nAON32rHu7mJXyoEkLUQOx0I3RaJhnK
         K1k3rQypm/KGnlOr490dxcVTLw2czsJV+eHdghTzS/eiJY9WafUf5Je4FoDLUj5dFzL4
         b9QTYgCEkDVvDZT82EHbDzi0mUu8OB4RLVn7vm5ThMWevRSCtwGRrSGY52d4Rc36LKxV
         5loA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lwv4ZEfpkcX8mk83OSfXxT6tyfSNq0yiB7CYAu6z/TU=;
        b=ZmWKofHzOhFW/d1kqm0MkoOw2dHpr1mseSK/U1L1DP+07F9GuY0RDMBhA7cGuxx+oF
         mNUSr27VpsfUG9Enj123UFspPoBSEN45G51IsSdHX+dAGTC/2ptZ+vFtj7hQxmnYqjx7
         KKcCSob2zvFLtZLl+1XF5EQxGtJVCh3wpUE5h4jffMoZvHHiCKWzGFmvST98OKawI18B
         vjODqB5F8WeCy9k0etTCwuR1K/5+0vfvFHINbOkCURULnYbP1rqtcSueZi4UJBzAh0I3
         t7gbFv0OSbmpCv0VE9QXgI4eJZjY79K3bdaFat+//hjlU5OmekH64K/cvLH6oU93zpaQ
         T8Vw==
X-Gm-Message-State: AOAM533wc2ZYShuBypFYEMCb0DSegSRz3QQ+3DZ0/kAvdsxuwZTjT6KW
        IjLR0MRLURRQpUlHf7jVsHyuPn+5ivoOBCrx
X-Google-Smtp-Source: ABdhPJwrBoU+hvQDGpF/Yf8Mx9Xoj0CGjXG6bWNXdvSeaXNfV1w4JX7nfg3C4qOxb34KAZ1RVoR7vg==
X-Received: by 2002:aa7:8d99:0:b0:4bb:8e5e:9ae4 with SMTP id i25-20020aa78d99000000b004bb8e5e9ae4mr46140696pfr.68.1641253336422;
        Mon, 03 Jan 2022 15:42:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f16sm36613534pfv.135.2022.01.03.15.42.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 15:42:16 -0800 (PST)
Message-ID: <61d389d8.1c69fb81.19c50.287a@mx.google.com>
Date:   Mon, 03 Jan 2022 15:42:16 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-38-g41ba4f080544
X-Kernelci-Branch: linux-5.4.y
Subject: stable-rc/linux-5.4.y baseline: 152 runs,
 5 regressions (v5.4.169-38-g41ba4f080544)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 152 runs, 5 regressions (v5.4.169-38-g41ba4=
f080544)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxm-khadas-vim2    | arm64 | lab-baylibre | gcc-10   | defconfig     =
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
el/v5.4.169-38-g41ba4f080544/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.169-38-g41ba4f080544
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41ba4f08054409abf5bd8f08be2d48cc9c235ca9 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxm-khadas-vim2    | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61d35589591a304022ef675a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxm-kh=
adas-vim2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d35589591a304022ef6=
75b
        new failure (last pass: v5.4.169-38-g2023b5129d9e) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d353130d1ce26e8fef675c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d353130d1ce26e8fef6=
75d
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d35305767431aad9ef674c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d35305767431aad9ef6=
74d
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d3533c0d02b5cf49ef678c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_=
arm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d3533c0d02b5cf49ef6=
78d
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d353185937179564ef6743

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.169=
-38-g41ba4f080544/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d353185937179564ef6=
744
        failing since 18 days (last pass: v5.4.165, first fail: v5.4.165-19=
-gb780ab989d60) =

 =20
