Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83A07482FEF
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 11:35:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232666AbiACKfu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 05:35:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232613AbiACKfs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 05:35:48 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6511BC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 02:35:48 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id s1so28299140pga.5
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 02:35:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=e2khnE6e0Dy3moAdopA6wshRlPwgslZEPGkOD+GmFeI=;
        b=dpb3OZ2tlw6ZUfvgTQzN+djr6UVSzMMLChHE1or2Y1oumZ6ngvseCrP7WIswZII9Tj
         5rL82TLacSZebggfzH1yYfDesa2CwecfVC/zxlmt3qUopVkC6u8DbFrpPmppO/VSAddN
         CY1ECOJAeqIGOKcP/XY+x1hVsWgwWj8HcwYX+LWu1OULeQBR0tLUgzqxVGuszENBFN5w
         Wb8YFBqWTvpUApfWUQo7gze2eAf8H9b8iJCMQPUnfKDYCqyVrXOwH6xvqFK5Gdnb3L1E
         g6gaYzUV20L/SJm3rCbJaJro6iQr3YFI/j+0wR3CkqPBJv4PMwJFPU/Xf8jWWbOfGd8L
         OUpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=e2khnE6e0Dy3moAdopA6wshRlPwgslZEPGkOD+GmFeI=;
        b=QuTja+HqQ1cuwtuHtfr7/ZxO/5pDpsmHVqhRFR+rMF4/Q/Lo64y7TsEY9YEhNXNnGV
         OJaTBYzpDfJbv8TlpHH6AYjc3NOdMJ+JYt01uitjezYe/rT8Kg4IcvlKC+/q+v79YCQd
         8sUtgBc2UISCU2tXQ2OoiiyZBbYCa2oeUZ7/wCNJ9aCEF97riMjabPLgFt4WTz682Xih
         JT0QoqD6Rn8jNUwg60JahcwqxvDYyhmmlQ4MhVQ+LRvFfhH3uY8Y35svy8iOjpeYN6Of
         6h2srLFtGk9AdEtu3rNFGV8839fPjnCNG2LmVCKpZfO0AjPzj79li+dtL2onAx53BS7U
         vN9Q==
X-Gm-Message-State: AOAM532WrfpWkodxID4sBWb6HKj+p0VcH8OqYHZCvtEKHqklYbCtPFsI
        e1nezgNtqBV6YW2TUOdnciRRgoCm5Zax0pil
X-Google-Smtp-Source: ABdhPJxbXIGQyjnVosEmooBGUEqVW2DkTG1aQ2FXm9MHe/alHc7J10GIKie0s+D5n4vKAlKAHze2cg==
X-Received: by 2002:a63:1726:: with SMTP id x38mr40164025pgl.518.1641206147733;
        Mon, 03 Jan 2022 02:35:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t27sm39460645pfg.41.2022.01.03.02.35.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 02:35:47 -0800 (PST)
Message-ID: <61d2d183.1c69fb81.c7a5a.8394@mx.google.com>
Date:   Mon, 03 Jan 2022 02:35:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.169-24-gf94ce940400b
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 173 runs,
 5 regressions (v5.4.169-24-gf94ce940400b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 173 runs, 5 regressions (v5.4.169-24-gf94ce94=
0400b)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =

qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.169-24-gf94ce940400b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.169-24-gf94ce940400b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f94ce940400b2f6e6291e6be56111f8f4e59e43e =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxl-s905d-p230     | arm64 | lab-baylibre | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/61d2a07cc5b5b86908ef687a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905=
d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d2a07cc5b5b86908ef6=
87b
        new failure (last pass: v5.4.169-23-g7f1f0a5db273) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d29eab7fe5f2dd46ef6756

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d29eab7fe5f2dd46ef6=
757
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv2-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d29eb110b7b73e4def6786

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d29eb110b7b73e4def6=
787
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-baylibre | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d29ea97fe5f2dd46ef6751

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d29ea97fe5f2dd46ef6=
752
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
qemu_arm-virt-gicv3-uefi | arm   | lab-broonie  | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61d29eb010b7b73e4def6783

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.169-2=
4-gf94ce940400b/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d29eb010b7b73e4def6=
784
        failing since 18 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
