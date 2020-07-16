Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D16FB222B48
	for <lists+stable@lfdr.de>; Thu, 16 Jul 2020 20:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729379AbgGPSwr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jul 2020 14:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728541AbgGPSwq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jul 2020 14:52:46 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A316CC061755
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 11:52:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id g67so5285277pgc.8
        for <stable@vger.kernel.org>; Thu, 16 Jul 2020 11:52:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=G63+MJc/upZeDeT72kuRzUKz15SB5uxzin9zk1RjRfs=;
        b=qRC3dGeBJ4npdtkl2ktOVVpK5iNoz8yNfA6b71xgrirL1HdtMP3eh0NGaYn2dJTk5M
         7xT526eEqVmRfKgiqV856a9kZQmvbu8/jdprkhn4O17k5uN4USFbT+tTRwsNvQrsWEYp
         SuDHoA7X+eNi6oH9hsSh/BufCjw3v7yFGIE2c8ca74EgDR7tzXDOb5F7R18he7aRRrGn
         8eQwYbKq3tZid6wj1gv4oECYXWgjixk5pOEH8kOvPOBcpunIUslztOw5Mnwtg6P369FC
         RCGEwHeioMKcVmkojSOD0jhs3t1ZfuV8B1YZyd7Qs0oDOjuYtKfY7wr4oiizOrrHtrC0
         kaow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=G63+MJc/upZeDeT72kuRzUKz15SB5uxzin9zk1RjRfs=;
        b=lBPHCF2LYxj4e4U1IRRctN5bO8xkqWFCf+ru1ALoIGGFDd+qc53zMUPRckmuB3sRNg
         30XT0Lb8J0eKyvaCK5KeTcMxqMABZG3IhTE2p228cPhFtrRrWS4xgk9zM6g2eaxWc9ul
         IJd6DYuY8HbfGKO8Bz9XXnQCRz7ceKLZuyxLQgMnL0bb/B0JSGeRWbPdQ6rdoxDqfDby
         5w9OUL1V/jH2mEJp6RSb/Z3VSSL1rKGWLbjrG/XBA5zygQDgbAhpSEZBTXAGEGFv6jTg
         GCM3GVtP4vH8MydPfAXBjFSYxOrx9QXjmrdOV4zACYbnbdfI1Xw3nGULZqLnMryuFZCI
         OTXQ==
X-Gm-Message-State: AOAM532tkEM6mKFCEO5I83fOO0x5Emlfvs7rK86ozumpC+Tg0xRIrNvk
        YgCVZ+XbyuCZe1Z2yTUtsvOxw7798Cc=
X-Google-Smtp-Source: ABdhPJwYFaPj83+jWCj6cLuNRj7U6gncsVczcGl791cjzlfX3HWNRDcXGOtA6yWPPTKGS0V9AnDZsg==
X-Received: by 2002:a63:cc18:: with SMTP id x24mr5270834pgf.86.1594925564274;
        Thu, 16 Jul 2020 11:52:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s194sm5647430pgs.24.2020.07.16.11.52.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 11:52:43 -0700 (PDT)
Message-ID: <5f10a1fb.1c69fb81.12ab5.ffe9@mx.google.com>
Date:   Thu, 16 Jul 2020 11:52:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.7.9
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
Subject: stable-rc/linux-5.7.y baseline: 120 runs, 2 regressions (v5.7.9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 120 runs, 2 regressions (v5.7.9)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7490e75482cc99ce9d0c32a1d028d2f834c36713 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f106beead0168066485bb39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9/a=
rm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9/a=
rm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f106beead0168066485b=
b3a
      new failure (last pass: v5.7.8-167-gc2fb28a4b6e4) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f106988bc5dd6af1a85bb33

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.9/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f106988bc5dd6af=
1a85bb36
      new failure (last pass: v5.7.8-168-g4fa1cbe97254)
      1 lines =20
