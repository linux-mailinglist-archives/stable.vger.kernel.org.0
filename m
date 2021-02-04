Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8AC30ECED
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 08:05:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231499AbhBDHEa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 02:04:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbhBDHE3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 02:04:29 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 471C3C061573
        for <stable@vger.kernel.org>; Wed,  3 Feb 2021 23:03:49 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u15so1275165plf.1
        for <stable@vger.kernel.org>; Wed, 03 Feb 2021 23:03:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XtVxUeFzlpE6/5UOnlszDV/w32n9n088epwA/5hDFis=;
        b=U/h6c+/0cwJSJZjNibBn3fmuhz68TBBNT12LJXdmsBREt2tN2tnRfmaKqAb3wMkWwD
         C4n8Dnh95R87YeYU6a+tWtNkn8neKNoYMCpHeNtr+6O63gzedeSj8B1FUFRF3074zlOL
         1aUa7heSqdAz6BFE3KpVbAD8LdVH58Bs+g2rNdtBMlGreH4IZI9yVtQIjvZO169jT4ZN
         JXcobVifuxU4cwzmw8EwbtYFGJNuOf9F6etRmp/Aca3IJ+kJ1O0npq9gmEAHq4WD7IXA
         BFaqIl4Pb8BRtsu3yjO6/JinBWGUidG8Hy+ABX32ZReJHxKj4Murzu7XEH7X4v+w7LGl
         5sBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XtVxUeFzlpE6/5UOnlszDV/w32n9n088epwA/5hDFis=;
        b=Vb0AjrrifDFty+mBXBueD7ioYciv7YhHVgCi3I3jHiN1uH6jHq+r2Ol94dyWVOgM+Z
         p8mw5wh+SpBxTlferE6TVZVtCHB+IEeu0RvCFskWwOl3sNnMi2DywrKwB2w61DQPYTxf
         TeGt/c4SJtcb4afgkur8cPT9/uHXx3RmU66GtgaWBMb7c1cmHT28QWNGn979qDvPIA2b
         cnTPGflvaJIkh60nYHjxtUu6tbrP1+585JkT6ovkLbc1lvdWNq98Omhzkwo6PXeInk9X
         FF1tuI2ARWmmAYRrE5ekHwsvAm21BFjwiRLh4w6e1/UNlsqoV9oCT7E7XQwXjQvXhNW8
         a35w==
X-Gm-Message-State: AOAM533d9vRrsZtM5oschKCLfG6C6113OojspxJjkHClRytgz9TN2Ijv
        fcqRWdWS8h2/CzpLXGZMB8w76f/CdAUB1w==
X-Google-Smtp-Source: ABdhPJzHPaEL1MOLxzVMlkW0SPUQ1ixwvswNXVoIG0LVIhH+NFQkaDmJf1vRxG9QnFliunytOhm0rQ==
X-Received: by 2002:a17:90a:db4c:: with SMTP id u12mr6823050pjx.14.1612422227636;
        Wed, 03 Feb 2021 23:03:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e185sm4658089pfe.117.2021.02.03.23.03.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Feb 2021 23:03:47 -0800 (PST)
Message-ID: <601b9c53.1c69fb81.3df0d.b216@mx.google.com>
Date:   Wed, 03 Feb 2021 23:03:47 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.13
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 175 runs, 2 regressions (v5.10.13)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 175 runs, 2 regressions (v5.10.13)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
imx8mp-evk       | arm64  | lab-nxp      | gcc-8    | defconfig        | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.13/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0c245c5fe93f0e9769de4a8b31f129b2759bf802 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
imx8mp-evk       | arm64  | lab-nxp      | gcc-8    | defconfig        | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/601b6d29553ba124033abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b6d29553ba124033ab=
e63
        failing since 1 day (last pass: v5.10.12-78-g6ce52453eaf7, first fa=
il: v5.10.12-143-gb34e59747fbb) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/601b678b29179a8f573abe62

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
3/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b678b29179a8f573ab=
e63
        new failure (last pass: v5.10.12-143-gb34e59747fbb) =

 =20
