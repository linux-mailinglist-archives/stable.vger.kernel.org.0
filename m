Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE02C2DFF1D
	for <lists+stable@lfdr.de>; Mon, 21 Dec 2020 19:00:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgLUSAP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Dec 2020 13:00:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725961AbgLUSAP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Dec 2020 13:00:15 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11DF4C0613D3
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 09:59:32 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id e15so5734880vsa.0
        for <stable@vger.kernel.org>; Mon, 21 Dec 2020 09:59:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=4BY9XfbYistA2gBfHxDvESrtkAvYB+df4L/gpFO8XZs=;
        b=Qh1bdIrV8oHzleppi0tjTP/iQ6kHUQ0uBPyA7fxk9RxVnn9Zn+kakubpXGrjs1scMO
         CgzUoLgKTwBOE72QTt7Y1afLxtcLVtCzzmE76zyRGx2+Ur6/TFYgmXmFHOHElaWkrAp/
         0aENm4EKRAyLN7S7Y82UDflPlZjU/7nKPjs22tTnG3kShfMP4i3XR2BOGtRNUpoOGQcH
         ab/9GPaok43HrbdBASR77hz4/YcpYheQgwKYD89y33xWU3wsXTTSy3U+DnqsTkWuuL8j
         Z4v4HijuhB9BBjHxAb9St2EoyzLaCj52zn5hFCFWe7l0SMPtqi0StGSE4J+kqrJVkU60
         ZW3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=4BY9XfbYistA2gBfHxDvESrtkAvYB+df4L/gpFO8XZs=;
        b=IOsLu98rllSS3iLLQVDQULY+L3zCAUsBM91XDJ0rP4Cr5ptUdJp5DxH8cMFEybFR8s
         rwqvXH90crH3eubs7Is3dlkNrO9impg68QeRFWhLbFx2MyKhRABS3SfD2Jq7JfxHgQHD
         OJlXSoeRGnoAu/keekHOp+d9HhzzO+MjOzSw2BTwwjobUTOYlCpP91aprQwre+aFzcys
         8NCQQfr8eAZcwEDIIMa4GCKMEhnvCNg9UmM0kVer1iWbAk28HBwIc1sZgQXIutyBaZdK
         J/U8rfWX4hIP2ehVi8LAYwkedv04gBS4GoEJUdJxPQhKO+QbfvkfXlKkkVtblNxYcWi7
         tZ6w==
X-Gm-Message-State: AOAM533vww7kQgaI4opxCIMYVa0VvW43kQ90fK6s0EPlrtaV/9EIsIBg
        bOV+IpNgvOYpIeb9nsG0jkbqASh/WEPpRw==
X-Google-Smtp-Source: ABdhPJxRW4ehbLZ9aM/Nvw7WHy4ipuHqjm14Y3XACyeXzGpJskuEUaLVcGJhRBlTaVZHH6cN8pcxFw==
X-Received: by 2002:a17:902:d34a:b029:da:861e:ecd8 with SMTP id l10-20020a170902d34ab02900da861eecd8mr10833433plk.45.1608573165879;
        Mon, 21 Dec 2020 09:52:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b4sm15910979pju.33.2020.12.21.09.52.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 09:52:45 -0800 (PST)
Message-ID: <5fe0e0ed.1c69fb81.d5c5b.d421@mx.google.com>
Date:   Mon, 21 Dec 2020 09:52:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
X-Kernelci-Kernel: v5.4.85
X-Kernelci-Report-Type: test
Subject: stable/linux-5.4.y baseline: 170 runs, 4 regressions (v5.4.85)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 170 runs, 4 regressions (v5.4.85)

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

qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =

qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.85/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.85
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      19d1c763e849fb78ddf2afe0e2625d79ed4c8a11 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
hifive-unleashed-a00 | riscv | lab-baylibre  | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0ae42edc032584fc94ccb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/ris=
cv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0ae42edc032584fc94=
ccc
        failing since 32 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-baylibre  | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0ae502c46b0e18bc94ccf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/arm=
/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0ae502c46b0e18bc94=
cd0
        failing since 32 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-cip       | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0ae492c46b0e18bc94cca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/arm=
/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0ae492c46b0e18bc94=
ccb
        failing since 32 days (last pass: v5.4.77, first fail: v5.4.78) =

 =



platform             | arch  | lab           | compiler | defconfig        =
   | regressions
---------------------+-------+---------------+----------+------------------=
---+------------
qemu_arm-versatilepb | arm   | lab-collabora | gcc-8    | versatile_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fe0ae8c8d72e2d686c94cbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.85/arm=
/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fe0ae8c8d72e2d686c94=
cc0
        failing since 32 days (last pass: v5.4.77, first fail: v5.4.78) =

 =20
