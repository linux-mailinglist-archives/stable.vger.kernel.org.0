Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBD5A3E2EDF
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 19:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241152AbhHFR3N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 13:29:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234746AbhHFR3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Aug 2021 13:29:12 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A98ECC0613CF
        for <stable@vger.kernel.org>; Fri,  6 Aug 2021 10:28:55 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id j1so17710533pjv.3
        for <stable@vger.kernel.org>; Fri, 06 Aug 2021 10:28:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BfLr+ja35xInyLs1+vofpSiAuXP4Lxw54AZyoGHwzyA=;
        b=U7DwlfX7sTrVs8DNeVgSGYs5JPdgSDVp0fPO5qjox4A+uLIGvCSRB96A67L34JY0q4
         e7ao9T7r3+4kJ48G15PdH+oX8y6Om9WRA3uU3sY5AbqDjVZKU38SiHcy6KGzy/zIRWTb
         SgP3sSAqeJ8h4BRWScML0vbzkVrv0ppEytwDNYKPVzr9F8aTuQLG+ZWr7HqY+bAyFPv1
         Gy09LbneVuUgIVdmp4EdEhNuS3DlGgM1IXaOAGfIObroIfXdwLxREn3VzOlBD5YkQcoh
         /b4KEl22bbNWdFFXuCyJU6OTnLTwERyV95D1Y7JU8x40TnHez/qJsCdWVvb5UW/RyOJZ
         yTrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BfLr+ja35xInyLs1+vofpSiAuXP4Lxw54AZyoGHwzyA=;
        b=Dml+Mzg12oPQyKVPsieyIf5t77Xf/N0kuQsHE0FA7neMzbNr79fBkmo6mZcpQeRqeO
         t+O5V4ptNBWxYJIA6p1AUUHX7Hzo/R+4bN3U+HfTJzF5fb8lIOR1b64hiOrdRG3x0zZv
         RG5w/rHkvsjbxmRpm3SYGtG2y1T7Ci85hhoy4o7ken4vhGl89CkIVWTEQISVReuaTMc9
         cu/uOGvwEi7OrH+urrT5h6jxGljyqtIpFXEykxHV5cvVqATKrhXPa+atSMudR9aQjSCw
         /z7jjT1XSKu1alCdxbf5Bvj5RVODXlpqMVL7VNNFFxaYTNN6en3A5KLzWZ4k+GDj1j23
         wQcA==
X-Gm-Message-State: AOAM530PB0gq7loSncEveTea4OgPMXJSGPAnJaFdUep75JHm4mAiLNit
        idDogU3oVOoUlVNsBklkrlj1BFzAV7iWOA==
X-Google-Smtp-Source: ABdhPJymCtCC9ypYr1k3ytDNIICZGofrnwZWX6ayOYyRj/T9qxs7ln1Y2T1kaDLOl4Ti4XcFvV2HHA==
X-Received: by 2002:a65:6813:: with SMTP id l19mr570063pgt.118.1628270934967;
        Fri, 06 Aug 2021 10:28:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n12sm13261524pgr.2.2021.08.06.10.28.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Aug 2021 10:28:54 -0700 (PDT)
Message-ID: <610d7156.1c69fb81.508a9.7263@mx.google.com>
Date:   Fri, 06 Aug 2021 10:28:54 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.242-12-gd7decc4b25e5
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 86 runs,
 3 regressions (v4.14.242-12-gd7decc4b25e5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 86 runs, 3 regressions (v4.14.242-12-gd7de=
cc4b25e5)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =

qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =

qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.242-12-gd7decc4b25e5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.242-12-gd7decc4b25e5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d7decc4b25e5f95848a688261db9ff2d18604b39 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
meson-gxbb-p200      | arm64 | lab-baylibre | gcc-8    | defconfig         =
  | 1          =


  Details:     https://kernelci.org/test/plan/id/610d3a7bb7bb885f6ab13669

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42-12-gd7decc4b25e5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42-12-gd7decc4b25e5/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d3a7bb7bb885f6ab13=
66a
        failing since 493 days (last pass: v4.14.172-114-g734382e2d26e, fir=
st fail: v4.14.174-131-g234ce78cac23) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-baylibre | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610d36290785c3e665b13675

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42-12-gd7decc4b25e5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42-12-gd7decc4b25e5/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qem=
u_arm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d36290785c3e665b13=
676
        failing since 264 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =



platform             | arch  | lab          | compiler | defconfig         =
  | regressions
---------------------+-------+--------------+----------+-------------------=
--+------------
qemu_arm-versatilepb | arm   | lab-cip      | gcc-8    | versatile_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/610d361148c977b037b13662

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42-12-gd7decc4b25e5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
42-12-gd7decc4b25e5/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610d361148c977b037b13=
663
        failing since 264 days (last pass: v4.14.206-21-gf1262f26e4d0, firs=
t fail: v4.14.206-23-g520c3568920c8) =

 =20
