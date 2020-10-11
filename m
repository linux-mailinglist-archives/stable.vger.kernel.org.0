Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D9728A819
	for <lists+stable@lfdr.de>; Sun, 11 Oct 2020 17:55:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729044AbgJKPzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 11 Oct 2020 11:55:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729946AbgJKPyo (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 11 Oct 2020 11:54:44 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55000C0613CE
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 08:54:44 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id e10so11157901pfj.1
        for <stable@vger.kernel.org>; Sun, 11 Oct 2020 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AYIHS2IEwXL044nHQfeUhNv+kvE8mkp+/GDRT18Ey9Y=;
        b=XDVs94hU4bd1pc5hNEiYlpUcqTNVqutvWEc0T+aEKnNVBVIDA7mH4Hh3CR4Y/kO37Z
         wJLth7gUtAQHUEQRAUM58MGVIVVmjGkS0D8FzKMALlOXE4U5oPHZgO25kZS1zADvqC7B
         STRBihJUJjU8EZ5YAiE9Gai35mC9ynrEaa9Om41TZoAlVlIRdGyyn2vXyCuj9gMJ26gD
         VJkGjTykXFYc/mcFLDVD2AAIIN9lJUaSt2n7wUPYI57besa2osH/KlkSRnEFuDU1mW95
         f4WXRD1SOI3LMC0PHwFAZB94Zi3v9IBQmijIcYPTlhQLk9bby+KnFeyFA1THAVkGofbm
         qx0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AYIHS2IEwXL044nHQfeUhNv+kvE8mkp+/GDRT18Ey9Y=;
        b=BYkuGMFfcE/WASVADoTKz9ggo5nBXoArSFupexl6are9biEswW3Ymmd9efJIWiahNC
         30JGYKhcp4H2eitDaUQmVdU6/77/1tqHjy4Ki1rEqcWRWYfVyD4ZR/jOp/WoK5qK7md4
         R9/BxoUbA0PjZx7xpqqSCWPqetyueZrEtenSC9ID84etDAnGPskR/JQ4mkRuI9g9NLTE
         CLm13x/l4zbcZUHnWGsAfNyiHQwFAQyEzmGdh2FSDiPgIiK/lPjCw3NTw7LIdySvB+Ov
         gyA/P3GkF4VrMtEtgS+1qMslzlS1v6b65jv5lb5dse16IQdQUY/PCuq70N/+uqrDk7LD
         jDJQ==
X-Gm-Message-State: AOAM533zibrEPPmSv9HeaLNQKGIdOBGmP8Gyk2C2KTFwQzTOATf1JUL+
        99HsEpTgkAAUh+Lj6FcqbWpRMMal8QrYcQ==
X-Google-Smtp-Source: ABdhPJzKja3lbybjQSKoxsv4sepLu+U15cBrRFvwtfvV41rhqeB++lPI096fYq2VzchaFnWE7ybTpQ==
X-Received: by 2002:a63:1d52:: with SMTP id d18mr10744522pgm.450.1602431683551;
        Sun, 11 Oct 2020 08:54:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 70sm18087185pfu.203.2020.10.11.08.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Oct 2020 08:54:42 -0700 (PDT)
Message-ID: <5f832ac2.1c69fb81.eb3ac.27bb@mx.google.com>
Date:   Sun, 11 Oct 2020 08:54:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.150-20-g0bfc7d70d1d6
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 102 runs,
 2 regressions (v4.19.150-20-g0bfc7d70d1d6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 102 runs, 2 regressions (v4.19.150-20-g0bf=
c7d70d1d6)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.150-20-g0bfc7d70d1d6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.150-20-g0bfc7d70d1d6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0bfc7d70d1d655e676a1d95b0cd832bffe78cbee =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f82ec096bb27513224ff3ea

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-20-g0bfc7d70d1d6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-20-g0bfc7d70d1d6/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f82ec096bb27513224ff=
3eb
      failing since 117 days (last pass: v4.19.126-55-gf6c346f2d42d, first =
fail: v4.19.126-113-gd694d4388e88)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f82d6ad0b635238444ff3ea

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-20-g0bfc7d70d1d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
50-20-g0bfc7d70d1d6/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi=
-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f82d6ad0b635238=
444ff3ee
      failing since 9 days (last pass: v4.19.148-245-g78ef55ba27c3, first f=
ail: v4.19.149)
      1 lines

    2020-10-11 09:53:58.464000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-11 09:53:58.464000  (user:khilman) is already connected
    2020-10-11 09:54:13.794000  =00
    2020-10-11 09:54:13.795000  =

    2020-10-11 09:54:13.795000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-11 09:54:13.795000  =

    2020-10-11 09:54:13.795000  DRAM:  948 MiB
    2020-10-11 09:54:13.811000  RPI 3 Model B (0xa02082)
    2020-10-11 09:54:13.897000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-11 09:54:13.929000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (371 line(s) more)
      =20
