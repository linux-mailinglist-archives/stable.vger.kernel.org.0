Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4870D3FA4F4
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 12:14:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233732AbhH1KPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 28 Aug 2021 06:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbhH1KPO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 28 Aug 2021 06:15:14 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0E9C061756
        for <stable@vger.kernel.org>; Sat, 28 Aug 2021 03:14:24 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id 17so8391544pgp.4
        for <stable@vger.kernel.org>; Sat, 28 Aug 2021 03:14:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/uknOtD6Mb5S+RMkv7vpq3rAux7OEQWhdo1PlkVKzlY=;
        b=OssB0wD6Q6c/1Ybdrz5CwJxBPSv8yQl9HUbiSyypYXtDuqFfPVWomxF641Et1Dt5My
         cfAg0EPohfraQhJRtdGu7S9RCWn01MPayHSz/m3DxzQoRG6fggHNZoFsRM9ADoCnYTw5
         QFaW66AzFFdVX8+NlkuWYAn0qSTF0yBaob1viMFx8rvGh40+PdO7bL7dXGE540gMJnyR
         sxx2QK7UcrFImhLtyY3Sja27/DRXFoUrT5XPmwmUwoKU7o2HuwjUDeYXmylQFimgA0E6
         qSdDrb0bp6Xn2/yo2yw+JIw2TydoD9ButdsbFKb2KWqgnVwNxrp/xX+vc4fEXx0VX2FF
         rWvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/uknOtD6Mb5S+RMkv7vpq3rAux7OEQWhdo1PlkVKzlY=;
        b=P7N9sLb/Y4GmFJmTgn0R5IN82fEX9SkaTJ1vemqdnpBHLdH+5bICKtfTgfTsSudDxM
         3zzWucxEM4Epw18n0vXr9nqyaEXwP9h+ZA9JhuH9ya4B3Q7kG40UdpzKW3ZDAim8B6It
         xFX3RW3ErCPdWEbpKyY2SEz/LS6FvG4mFpfxvYdfIiuLQzX5sU33NEv+Pyyurb2ik5T/
         u9BOuZJUNojUyWHZhX9PcvkCmDoSTKD8AM9UCVcDO+1anzUHrPvsxEXekPG2aG3O4Phu
         7fWKv/NvXdVwHsrQHFF1tzOU6eHjQv82ULBjU8tpmMD90pFRryUQPURnKTM7UnVhkADX
         UsIw==
X-Gm-Message-State: AOAM532GwurCr2pjai1L7bCQiRLfkPEn2o5u/AMGptql7ucOayjk69lJ
        89994RtHQpIlQKbeWlLq47LZrsY6DXm3ZuaI
X-Google-Smtp-Source: ABdhPJwSgBkK4uEFRwP6TJusu9IwrxR5OezqaKXS4g14qvjeD0Qm6Rq/Tn7pSE6ZbtC978aPzNIS7g==
X-Received: by 2002:a62:3887:0:b0:3f2:6c5a:8a92 with SMTP id f129-20020a623887000000b003f26c5a8a92mr11218095pfa.8.1630145663692;
        Sat, 28 Aug 2021 03:14:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n30sm8800307pfv.87.2021.08.28.03.14.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 28 Aug 2021 03:14:23 -0700 (PDT)
Message-ID: <612a0c7f.1c69fb81.427a8.74e7@mx.google.com>
Date:   Sat, 28 Aug 2021 03:14:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.61-11-g5094382ce77c
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 152 runs,
 2 regressions (v5.10.61-11-g5094382ce77c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 152 runs, 2 regressions (v5.10.61-11-g509438=
2ce77c)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-11-g5094382ce77c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-11-g5094382ce77c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5094382ce77c0c51243116dfaed927d36e0453e8 =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
bcm2837-rpi-3-b-32      | arm   | lab-baylibre | gcc-8    | bcm2835_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129d45b34894e7d8d8e2c83

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-g5094382ce77c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-g5094382ce77c/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-=
rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129d45b34894e7d8d8e2=
c84
        new failure (last pass: v5.10.61-11-gecd5171696ed) =

 =



platform                | arch  | lab          | compiler | defconfig      =
   | regressions
------------------------+-------+--------------+----------+----------------=
---+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-8    | defconfig      =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6129d6e63d7896211b8e2c95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-g5094382ce77c/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-g5094382ce77c/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129d6e63d7896211b8e2=
c96
        failing since 0 day (last pass: v5.10.61-2-g8c7ea8a3f367, first fai=
l: v5.10.61-11-gecd5171696ed) =

 =20
