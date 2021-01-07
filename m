Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2362EE803
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 22:55:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727822AbhAGVyL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Jan 2021 16:54:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726754AbhAGVyL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Jan 2021 16:54:11 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21749C0612F4
        for <stable@vger.kernel.org>; Thu,  7 Jan 2021 13:53:31 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n7so6192054pgg.2
        for <stable@vger.kernel.org>; Thu, 07 Jan 2021 13:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DOclq064aKuELCW8wRmtFbGQCh+n+TFoIXyGZM4+chg=;
        b=ssQXm+B9pteleGQlDRTJ2I8TVoivzoSbmdazAsy0l7gcFZ6WBrNzwmbqjX3+VYo8pR
         Y4mirMVuiLRfnC95W3QO0uespaAM8idXBCBj01lPlUBOLsP66KX05MOWf7K5l2ZpP2kX
         0Ut7Zs3ko67m1irtRL15G2dvKsloigLyLVo2tkUNe4IYwR+YIL0zBqxlik2Hu6T78EX3
         /HE+A/nflF043PuLu2r1Cbp75nysFA/VZwJYLHp5E9oJkE4epKBl39OD5aSDoNOtfqfs
         ZYF/1hX0V+UaGKFpnfxjkmLH5ocujBf/s8iUXQ9GmhFpDEuNT7q2N1ggFjarlxUZs/ju
         eCMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DOclq064aKuELCW8wRmtFbGQCh+n+TFoIXyGZM4+chg=;
        b=ohQ3xBNprHsYbU7WSf3YccgN78F15tVBDpOgfWqjLqmwMzBxFYRnvaa5f6Zp2NuGWr
         hyxXb0W8/T1YMUvaRrb2WyVT5Y9BG8DJVBqoohaDTbRn4ZlmwfPUtPnl+DcGGo6CdGET
         +FGUqTGcQcSvPdpU23rvliugHjaLq3Y0vKIoCL8mR6Fa4/PWu+o01Sty+CjsZLrIySa1
         KXAEX3zCVP7S44M5V/R7s5ixuNQq6XXCEBwGKTB0GENikzYtqg8gKGrXwjas6BmUikWJ
         Dn4/wRXypgynk9+Bvp60vSvXw8iXTzMOSzDvINugBarN4wWGwlK0LnJ1kxOC2kdgjr3d
         Ch1A==
X-Gm-Message-State: AOAM532F+R1a9ID922Ygl6CrUlibonMr8hqU/gnSDLarNKWv7W22Z8Zj
        XenjxSEuFnaSGFTtIOXtZFCBJ6kY1JoAdw==
X-Google-Smtp-Source: ABdhPJwsyshb8oS6Aes5Wbh0/YSY2S9nYrLA4/GtNHyeu/CTRXcKX3oGTQ7jKzio+9evkoA3ji1u6Q==
X-Received: by 2002:a62:7ac4:0:b029:19d:b6ee:c64c with SMTP id v187-20020a627ac40000b029019db6eec64cmr613060pfc.3.1610056410249;
        Thu, 07 Jan 2021 13:53:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x14sm960364pfp.77.2021.01.07.13.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 07 Jan 2021 13:53:29 -0800 (PST)
Message-ID: <5ff782d9.1c69fb81.d272c.28c3@mx.google.com>
Date:   Thu, 07 Jan 2021 13:53:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.87-14-gf52a40401ee9
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 175 runs,
 5 regressions (v5.4.87-14-gf52a40401ee9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 175 runs, 5 regressions (v5.4.87-14-gf52a40=
401ee9)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.87-14-gf52a40401ee9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.87-14-gf52a40401ee9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f52a40401ee9825556cc803c110c67bfec5f6b94 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff74df8fdec718486c94ccc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff74df8fdec718486c94=
ccd
        failing since 48 days (last pass: v5.4.77-152-ga3746663c3479, first=
 fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff74d7c4c61ebdf8ac94cd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff74d7c4c61ebdf8ac94=
cda
        failing since 54 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-broonie   | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff74d80f79a1d8c93c94ce4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff74d80f79a1d8c93c94=
ce5
        failing since 54 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff74d83234df551cdc94ced

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ve=
rsatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff74d83234df551cdc94=
cee
        failing since 54 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5ff74d38fe57783475c94cc3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.87-=
14-gf52a40401ee9/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_=
arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5ff74d38fe57783475c94=
cc4
        failing since 54 days (last pass: v5.4.77-44-g28fe0e171c204, first =
fail: v5.4.77-46-ga3e34830d912) =

 =20
