Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A836291359
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 19:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438690AbgJQRpV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 13:45:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438689AbgJQRpV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 13:45:21 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8231C061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 10:45:19 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id t18so2908502plo.1
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 10:45:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L2Kya+r8g9if0wH0lFkOC52+zVsaj9DpDDbksc3sVMg=;
        b=S561Mbdz8afg+0V4Yf0fgYYa04APF8JyWdP19XcPFd7AVL2a+eH3svhv+9KiAiUwWm
         wIbgcMMBRQLrWChr/jaXW7c+kYyWfuABe56C83N6ZB6tkkKIhjl67mnoarcK8wef8+CC
         jAZ4EVzemTJeixe1A8P7i4rLo/4IAesxu2tyBHPewlTQM1r2RuY3dL0gBUCs+1rrHeil
         TMypVtydSYDqsQIakqmBBz8OVlwhgwVM2MjxQhx0gnbTyD4l0bUaYV9Y8L9U/PEja+sG
         0b8B9/JX5L678TZ48S8uZAj+Z+h+Bzr4A8d9n4Fg3IooUht2TYC8HnSFsuun7+DGwHNO
         MvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L2Kya+r8g9if0wH0lFkOC52+zVsaj9DpDDbksc3sVMg=;
        b=lx6b0va8wHNiraFLuip/1nzOpPtdqchJ+j0Xgj63z3B6dd1T9g26HFbOhG77Dne+B5
         +p6hsJwgEnf/BzB/sqqbssU7zt3EiUOpL9D4swQEYrq9I2h/yYwLSIKMWuyPZITzJ8pA
         AQaO5JwGwP2Phv6bB63Yh+Nugqw2IvCncgRWJclRES4HkB/5T8a+XdyXgd9P6Z56DmUV
         Zfq6KKwYEQZYsc3w6fQhSEv7fXNUERAU/4g5CVmbO74rBOV1oD8+kDYSG2FWY6DQ2pBK
         mbsVKOjBg3Jg5UBd8vhivIdB8PD1ggRTdW2dKdLtqIYAEU6GY3EUVmszraZ91ttaa2h9
         WsIg==
X-Gm-Message-State: AOAM531WKHsDxOGFbNT7sES7oRU7xFg6oLpPnSyf5dIW7SSJCJs951xh
        j0JiRPDMtGOZcEiaHc1kfvt6lVLRgry2Dg==
X-Google-Smtp-Source: ABdhPJxPTeFTLwMs3AhdQ+rtSNpq70XFS97D7OmpHqD5Pm/6Ci+/TtFvwGUaCD9nSO9DLyDnO8htDw==
X-Received: by 2002:a17:902:ee83:b029:d4:bdd6:cabe with SMTP id a3-20020a170902ee83b02900d4bdd6cabemr9590256pld.68.1602956718719;
        Sat, 17 Oct 2020 10:45:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t129sm6703631pfc.140.2020.10.17.10.45.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 10:45:17 -0700 (PDT)
Message-ID: <5f8b2dad.1c69fb81.70f8b.e335@mx.google.com>
Date:   Sat, 17 Oct 2020 10:45:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.202-11-g83970012a2ed
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 167 runs,
 2 regressions (v4.14.202-11-g83970012a2ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 167 runs, 2 regressions (v4.14.202-11-g839=
70012a2ed)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.202-11-g83970012a2ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.202-11-g83970012a2ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      83970012a2ed25e5f71d568815f9c5c9990bfe60 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8af6977380c797d04ff3ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-11-g83970012a2ed/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-11-g83970012a2ed/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8af6977380c797d04ff=
3ef
      failing since 85 days (last pass: v4.14.188-126-g5b1e982af0f8, first =
fail: v4.14.189)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
meson-gxbb-p200       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f8af41e0e1b5cd18f4ff3fb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-11-g83970012a2ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
02-11-g83970012a2ed/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-=
p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f8af41e0e1b5cd18f4ff=
3fc
      failing since 200 days (last pass: v4.14.172-114-g734382e2d26e, first=
 fail: v4.14.174-131-g234ce78cac23)  =20
