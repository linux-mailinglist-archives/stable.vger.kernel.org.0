Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DACF13CF317
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 06:21:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232778AbhGTDlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 23:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346853AbhGTDlI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 23:41:08 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34864C061574
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 21:21:46 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id o201so18523784pfd.1
        for <stable@vger.kernel.org>; Mon, 19 Jul 2021 21:21:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=wxfBY+RY/BlQtNRHCMORh6T6NW5lNGR/5WOIkGnNFdI=;
        b=OjNuJCskXQGvOem4iOXqr89WI/dPesvigyMfKXtkEX4MpuTi1jLS/Vw+EyBUdnRrvN
         fZNW71YFjpG+c+lMfmLhdGaQlSBEXB+wTG5CQAxfZwdueaqTHcgPyR5q+jnt1Fum0/Q9
         ClOz9bdV8SG9kNj0cBycaPskWZKfJNBwyCaD58kTikFqPE9Vi39atvaynwNfAHg+XZu5
         n4Rn/y4UBze+TxTiyaGfsTk4ulQVl/fFukuoQvS2poSu4zPzEHpzkvMukNc0JjfCkFRm
         pEyqUO6ftMjx6bi+5cIR2Hd7fgvkaoYdZmkwoE5sE3TZ1bGMU17UqCLfqAH01hpOD7kv
         P3jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=wxfBY+RY/BlQtNRHCMORh6T6NW5lNGR/5WOIkGnNFdI=;
        b=F5h1sCYFY4Z825RqHP24vzfW387DxFE13kwBhYh/CXzzuQr8qD8Z83iTGiW5PVPJQs
         n6CxQVsSDCkcug58Zj4L4GbBYbDIXz+R2wm0OyXnHzpfhAGVpByCS9kWX2PiZTNiQnbP
         GNzBWwcJPFBPO5mrORE/4thIJj8c7UB2QXFHEcSX2yArhN6R3tpL9pp29+fgh4PGnj5T
         ltn5I+pOYNaukP6n+E7BLu6mNju1lEQsUwAhH0PwDqqJ1z/etkhOws/IrqAsOmtY48GP
         nMZhnwAT7zvze/ezSz2c5FIrj1PazpCdN0YBDYcoWd+9x1q9SkIgae3M5nY0CPT9jG2J
         Y02w==
X-Gm-Message-State: AOAM530D7gEyCHOncJCE2oocgelIJDA5bQhc5bxIE1bbVb704N+yyhJX
        a3zjqr3ESxG5h+lVB1X+FuA/VzqkuIQUug==
X-Google-Smtp-Source: ABdhPJyU0Lj9GwetLKNPQOYo31uje3zcRDjerzfRiICjwUjrzlGtfnKLOoJiM+4G7m9LGYY64AiRXA==
X-Received: by 2002:a63:d709:: with SMTP id d9mr28971954pgg.337.1626754905454;
        Mon, 19 Jul 2021 21:21:45 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 202sm22128093pfx.75.2021.07.19.21.21.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 21:21:45 -0700 (PDT)
Message-ID: <60f64f59.1c69fb81.1b7fc.1a69@mx.google.com>
Date:   Mon, 19 Jul 2021 21:21:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.51
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.10.y baseline: 191 runs, 3 regressions (v5.10.51)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 191 runs, 3 regressions (v5.10.51)

Regressions Summary
-------------------

platform   | arch   | lab        | compiler | defconfig                    =
| regressions
-----------+--------+------------+----------+------------------------------=
+------------
d2500cc    | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook =
| 1          =

d2500cc    | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             =
| 1          =

imx8mp-evk | arm64  | lab-nxp    | gcc-8    | defconfig                    =
| 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.51/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f68261346518c970aea06e6fb3eb031247340400 =



Test Regressions
---------------- =



platform   | arch   | lab        | compiler | defconfig                    =
| regressions
-----------+--------+------------+----------+------------------------------=
+------------
d2500cc    | x86_64 | lab-clabbe | gcc-8    | x86_64_defcon...6-chromebook =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f616852c31a85cc81160a0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.51/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.51/x=
86_64/x86_64_defconfig+x86-chromebook/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f616852c31a85cc8116=
0a1
        new failure (last pass: v5.10.49) =

 =



platform   | arch   | lab        | compiler | defconfig                    =
| regressions
-----------+--------+------------+----------+------------------------------=
+------------
d2500cc    | x86_64 | lab-clabbe | gcc-8    | x86_64_defconfig             =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f6192ee03e233c8b1160a7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.51/x=
86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.51/x=
86_64/x86_64_defconfig/gcc-8/lab-clabbe/baseline-d2500cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f6192ee03e233c8b116=
0a8
        new failure (last pass: v5.10.49) =

 =



platform   | arch   | lab        | compiler | defconfig                    =
| regressions
-----------+--------+------------+----------+------------------------------=
+------------
imx8mp-evk | arm64  | lab-nxp    | gcc-8    | defconfig                    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/60f61947e03e233c8b1160c4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.51/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.51/a=
rm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60f61947e03e233c8b116=
0c5
        failing since 12 days (last pass: v5.10.47, first fail: v5.10.48) =

 =20
