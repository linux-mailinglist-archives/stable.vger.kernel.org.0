Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3712328014A
	for <lists+stable@lfdr.de>; Thu,  1 Oct 2020 16:32:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732213AbgJAOcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Oct 2020 10:32:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732020AbgJAOct (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Oct 2020 10:32:49 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4E17C0613D0
        for <stable@vger.kernel.org>; Thu,  1 Oct 2020 07:32:49 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f18so4645976pfa.10
        for <stable@vger.kernel.org>; Thu, 01 Oct 2020 07:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OSkLfOJE+QyqBl6FGE7p6cFCk1q4bcv5dJ5ZPEn6Rhw=;
        b=SO/dimED3GPzNkd6lkHe9xQljbHWGJWOppZ5WktaYvwmIyStqPJu24lOK++pNUJMhw
         7Xo8OyUwAwktXFVUTbKnCEo14zsalwB0F4iSu+4VbhXmXBIVG6vxEtxURpXKscXdlvh1
         1TsFkmcUczR7ley6lT+yyUZvskXiNEnEJEM+nV5D015vPNpHHIyFnyAzmf1iP05M49Ap
         0qY2N6wIO5xazIYe/nAy3PirKIsqo/X+Wkcbtf/bRBhjPoLUbowCChtHCCO5IyUAvIKH
         mNBmVeIBwGH7gS35+FFbXJ1jNE3SfA5mDLdB6jSEixjxKIW/yS+CtuBew0O+RRbG3nMI
         Lmxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OSkLfOJE+QyqBl6FGE7p6cFCk1q4bcv5dJ5ZPEn6Rhw=;
        b=JY32BiN+EZDjvwP3Yv6CG/yXLlj7a9qXKeleR4oM+/2oogxf2fLUtj/lhNA2PDsyqi
         gKv2u6I8Bpu9bMotRXFsuZYJmU4jiPnJ4pShnwEdeebJ/Q7jR2GUlN1HQQmMMQ7k4c4X
         Y7/E/9VQ2Sgfq9p/R+LZxctwXlgK91xS+R3D2TtDXXUAUK7bl+Ojg4AL4Zi2a5cwzK1X
         wVq+jqE4Th+9BS3omBsUDJj/nNLS3UxBAzRI2T1R2UCUGPWHRc7c0bj5NeSPs2iSix7C
         DtJHCegu0yWvt8Rh8lbioUH5z/6MMIsZ1Vp/zqHjDzcp2OhsU/jNsv/d0gEw6spBBI+L
         bLzA==
X-Gm-Message-State: AOAM533wXMO6jJAJtQgwL90Xuox4jUM4cNzWYnYFSy5PZPoSNlSQt+v1
        RW57sURmom5oZRe/AZHdx8f8nJhvMEU8Ew==
X-Google-Smtp-Source: ABdhPJwvXMi6J3jKFj2Y6tJbEbRPUdtjwMC4VtGEOhHoWK+FWvpYJmoVAwou8ITzn7LisEMEafMb8w==
X-Received: by 2002:a17:902:ff10:b029:d1:f8be:ac75 with SMTP id f16-20020a170902ff10b02900d1f8beac75mr7313414plj.81.1601562768512;
        Thu, 01 Oct 2020 07:32:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id kk17sm115816pjb.31.2020.10.01.07.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 07:32:47 -0700 (PDT)
Message-ID: <5f75e88f.1c69fb81.19654.03b1@mx.google.com>
Date:   Thu, 01 Oct 2020 07:32:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.12-99-g024c7b72aca1
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 164 runs,
 1 regressions (v5.8.12-99-g024c7b72aca1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 164 runs, 1 regressions (v5.8.12-99-g024c7b72=
aca1)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.12-99-g024c7b72aca1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.12-99-g024c7b72aca1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      024c7b72aca155b72ea99dc63302f7dee8f0061c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f75b47f97ec780ded877172

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.12-99=
-g024c7b72aca1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.12-99=
-g024c7b72aca1/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-2-g61393d279614/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f75b47f97ec780d=
ed877176
      new failure (last pass: v5.8.12-99-gcaa13284791a)
      1 lines

    2020-10-01 10:48:33.315000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-01 10:48:33.316000  (user:khilman) is already connected
    2020-10-01 10:48:49.649000  =00
    2020-10-01 10:48:49.649000  =

    2020-10-01 10:48:49.650000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-01 10:48:49.650000  =

    2020-10-01 10:48:49.651000  DRAM:  948 MiB
    2020-10-01 10:48:49.665000  RPI 3 Model B (0xa02082)
    2020-10-01 10:48:49.752000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-01 10:48:49.785000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
