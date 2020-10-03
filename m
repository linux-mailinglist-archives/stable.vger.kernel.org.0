Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E24E62826F6
	for <lists+stable@lfdr.de>; Sat,  3 Oct 2020 23:57:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725917AbgJCV50 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Oct 2020 17:57:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbgJCV50 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Oct 2020 17:57:26 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E56C0613D0
        for <stable@vger.kernel.org>; Sat,  3 Oct 2020 14:57:26 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id g10so698438pfc.8
        for <stable@vger.kernel.org>; Sat, 03 Oct 2020 14:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+9SM1JI6ujoKeUm0fdOJX5fiC1JoZ9GhJlYk31Ymbm8=;
        b=fUjmFK05bg7fTy6Jxv5EnqQKUOGInyQplkXQgurNFN9W+i0XhnggXX96cmyOq7t4eb
         Ur3JyUjW4Vckg2++P48twu1TZ9qnYm+A3qNv+nKGQ/6dDDcalFWYvyPMPef3u+una+3r
         vCum1M/y/TjSGzuQE0tiwyHFCr1Qozw27W7tuRa7t6wwojlUcG6e6Rr5pI4pNaPgC+lS
         Edd+yKnFR6wFM4NR740Y+sOgHAXiFR+P2SDOt6tcYMs4X9mSPUG4hDIYX9suD9WZKJCm
         O2BFQ+LBAtJaRuYLtM0a7umyK8TKwqHJIpuNDuE6jpfkLeKCBaVj0IEn7tY6czqcZ2nw
         J4YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+9SM1JI6ujoKeUm0fdOJX5fiC1JoZ9GhJlYk31Ymbm8=;
        b=JAyUsuiCa4PknTmWecr867aGOBVtV7IqsSoZcNoK1waXSF2SfbFYxuKikQ/oX2sWA5
         vh0YyLldwD+gIXnLlUNBG5PEnjJZD2imOtBKsFjjWVJ/zO+Gym9vvaQQYqqQa/mp5P6n
         Z14AZO1rFm1Uj4echTWyEEibbDJ06Qpt4EhGq/g4FWp3pOvqA10ewtz2M7dmMMF5Or8g
         JGHBsCZHk1NZdai4eIzvm46UNdtWaxtSm69r/TucoiLdJMM6TeY+QsxyKl+jyp2b8Tzc
         MHWAnvNqFVIJ3Duz0WZQJRoCAqTLSd2hwAq2Exh1+W5flzZlNMtgI0wF3AQhuwTtCxVI
         Zmhw==
X-Gm-Message-State: AOAM533fO7/kJxIrqEALCSr8GhnWC0zM7wx8HmrYL19b3dt7BI+Rfg+v
        bR3RMvrlAIsuwYAhIsVCSgn6qsEDLxQS1g==
X-Google-Smtp-Source: ABdhPJy/5owPYd4yRT3twFOzW7PJdSlc1ZxbPtRIlPSkMTA15rQI42hFjKSEkxpVxkXWpJRqWmkYnw==
X-Received: by 2002:a62:e40c:0:b029:13f:d777:f70e with SMTP id r12-20020a62e40c0000b029013fd777f70emr8691412pfh.2.1601762244824;
        Sat, 03 Oct 2020 14:57:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q16sm7017048pfj.117.2020.10.03.14.57.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Oct 2020 14:57:24 -0700 (PDT)
Message-ID: <5f78f3c4.1c69fb81.c19c3.dccc@mx.google.com>
Date:   Sat, 03 Oct 2020 14:57:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-4-g55b73b3448d7
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 128 runs,
 1 regressions (v4.19.149-4-g55b73b3448d7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 128 runs, 1 regressions (v4.19.149-4-g55b73b=
3448d7)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-4-g55b73b3448d7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-4-g55b73b3448d7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55b73b3448d7a455d7d4e0dcd4fccc9734c6ef51 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f78b7618951497c2a4ff47f

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-4-g55b73b3448d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-4-g55b73b3448d7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-=
b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f78b7618951497c=
2a4ff483
      new failure (last pass: v4.19.149-4-gb110045ffdd5)
      1 lines

    2020-10-03 17:37:46.900000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-03 17:37:46.900000  (user:khilman) is already connected
    2020-10-03 17:38:02.020000  =00
    2020-10-03 17:38:02.021000  =

    2020-10-03 17:38:02.021000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-03 17:38:02.021000  =

    2020-10-03 17:38:02.021000  DRAM:  948 MiB
    2020-10-03 17:38:02.037000  RPI 3 Model B (0xa02082)
    2020-10-03 17:38:02.126000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-03 17:38:02.158000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (371 line(s) more)
      =20
