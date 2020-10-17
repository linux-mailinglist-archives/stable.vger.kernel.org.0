Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800F42913B3
	for <lists+stable@lfdr.de>; Sat, 17 Oct 2020 20:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438563AbgJQSlX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Oct 2020 14:41:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2438553AbgJQSlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Oct 2020 14:41:23 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8831FC061755
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 11:41:23 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 144so3459753pfb.4
        for <stable@vger.kernel.org>; Sat, 17 Oct 2020 11:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/SFMrLE5Q6M2FpStX3Kto35lNQYJgxxMVEeIBbybW20=;
        b=coyxY3AL2VkOsJNzkF0f+8bODPtHyHoD6gDOkdJPWoQsYhfiE2NV/KiEWPl9TORNyc
         VA74yNQWnTz6XWGyiVAHC9PiVOhaayFHHu8s2bcpxAyx6scuG+wEINxazCR7QqeVSBgx
         QPsEnu6W75LLZvlFrQLQRgSENlOZRuAtkoq02psQTL9bBzTBL0589p15gcj/KxfZ+hdQ
         qy6VqMibhSiy7hk5QECKQckkGaIVE9H1YNwomlRQB57HGysncgvpQCz2tWDkUQ7PzZ5v
         A9Gj1VJE7zcLdTwKWvD01pcMlEyHP0zbUPS9GCeyUZpXUPNyTao9pMN6mxRsa/lsndEr
         1wSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/SFMrLE5Q6M2FpStX3Kto35lNQYJgxxMVEeIBbybW20=;
        b=jfkhc/vJvzNFGGpLmOCtQd2I4fNqOvRHa9/1PPEYqd0XzLzBdQYQMdng03RlAk3t0T
         HpGCURcR2DGeMbSE4ukJB0wf5RUmOe3tjTkRTees0YKoIx3WGe/87sqZ4EM9epy04s4t
         vN9ItKLWMhsjCXv6oqLmavrBnC753Ady7lS6ZwRxG9SiXwsvIzRVZ6zJDlGrhVtVeM49
         CLI4AyQgZ8in64oAI8ig0XPKCvfC6RleYKJe5Y528Ebq24DTECFSBJRJCFSIWbeoGADv
         4N3ke5/YkFv9Gu6AANFBQ593/oZbofleAff65PxxrYte4z0iLm+bKSeYpk48QER7VY0+
         vsyw==
X-Gm-Message-State: AOAM532wRaS5EdnFbWQcAcoLB8+eCJoPZDsbfsR+6r1NuIan5nUcnAr/
        HJ8d5SiqjWKpeFvF9Ro1xoWl3julEygkvw==
X-Google-Smtp-Source: ABdhPJzQ9YB6HfIwol2d1C6iGNtWkuGwizXw/ixeFIryrEYAG3D5n0G7kDaKPUKWttkPbgRFLN95Yw==
X-Received: by 2002:a62:7d4d:0:b029:152:1b09:f34 with SMTP id y74-20020a627d4d0000b02901521b090f34mr9904473pfc.76.1602960081194;
        Sat, 17 Oct 2020 11:41:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 3sm6356967pfg.125.2020.10.17.11.41.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Oct 2020 11:41:20 -0700 (PDT)
Message-ID: <5f8b3ad0.1c69fb81.a44ad.db6c@mx.google.com>
Date:   Sat, 17 Oct 2020 11:41:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.16-30-gcfc6983c9555
X-Kernelci-Branch: linux-5.8.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.8.y baseline: 193 runs,
 1 regressions (v5.8.16-30-gcfc6983c9555)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.8.y baseline: 193 runs, 1 regressions (v5.8.16-30-gcfc698=
3c9555)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.8.y/kern=
el/v5.8.16-30-gcfc6983c9555/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.8.y
  Describe: v5.8.16-30-gcfc6983c9555
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cfc6983c955542777cc0caa08290666fe1510f92 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f8b0197c4d194d1854ff450

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
30-gcfc6983c9555/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.8.y/v5.8.16-=
30-gcfc6983c9555/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f8b0197c4d194d1=
854ff454
      failing since 1 day (last pass: v5.8.14-125-gf4ed6fb8f168, first fail=
: v5.8.15)
      2 lines

    2020-10-17 14:34:27.479000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-17 14:34:27.479000  (user:khilman) is already connected
    2020-10-17 14:34:44.770000  =00
    2020-10-17 14:34:44.770000  =

    2020-10-17 14:34:44.770000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-17 14:34:44.771000  =

    2020-10-17 14:34:44.771000  DRAM:  948 MiB
    2020-10-17 14:34:44.786000  RPI 3 Model B (0xa02082)
    2020-10-17 14:34:44.872000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-17 14:34:44.906000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (390 line(s) more)
      =20
