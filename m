Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5688529517C
	for <lists+stable@lfdr.de>; Wed, 21 Oct 2020 19:26:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438029AbgJUR0l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Oct 2020 13:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730782AbgJUR0l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Oct 2020 13:26:41 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45650C0613CE
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 10:26:41 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id b6so2334473pju.1
        for <stable@vger.kernel.org>; Wed, 21 Oct 2020 10:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=67ozpfa0wvk9WBj51Yc7P6sLPX70F9s/rdWKGTiTyO0=;
        b=i6AVqapmp9MThLtGT/Bko/P1f8IVLFqshfbmiXKuva/Clv/TnuYmmEASX8byCjzHRZ
         4MViZeRsDQT5DJVNS5+0CFI5NcC/6T1MpvDY9PDUFLcmC8XwglIsTX3aRn40UsLrHJGT
         as+gzxElaxBbMRVU+63GVFhyAgx1UEO8pl9UAt3uYxtURzqyAE/Npt2lrdFND0IyCgfb
         ReWdmySDdJe97IyWHo3KSA3ztmZtI2EzQoAkbzfM0uPxAek4d6o0BMkJj6YVilx9GEt2
         Z/E/6aG9Q4xBfAy6g+KRBg/93ADBO9UBYroVfMiKMLbl3Q/a4KSSEso0q1xFaoIMVCmm
         ezqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=67ozpfa0wvk9WBj51Yc7P6sLPX70F9s/rdWKGTiTyO0=;
        b=jSgpV02d9lNP5XRaMW9bLb5wg/USxg9wjR+p26wKvVPiP9LWGPx1lLUWaL7XWgtDYV
         Z0J26eDRwJl2QYt92/+0eQiPQXT3Hq2AqK5dZdcJC3zQrMzI9NiMKtYqWpkuxgDkhdA9
         GvlkdwGzNw/PkfUEL2Iji5XHRoBl0zTYxK6g/HevYyta0kHSpuczZAT06B0qW3J41Ewg
         ZmzxOilfrDkUCvv/k2OLZLuGyrv6KFBhuS8IG1WCMk1dpjI1P+x4A7RBIH9cW7BoFChQ
         2sUa8hXfi3TBRraYt2VXvpsfALc6E4AqRaR9mhrc1WFHTgc1f1WjMiNnOo/LwM8LIOtt
         BYnQ==
X-Gm-Message-State: AOAM5306fZCccY026iksJeqL0VaUd+JoORIcgTOcrKYQlwOpPiPAmiBT
        CUUXbo/mGlOODGQc++Si0HX6q4yJKG8rbA==
X-Google-Smtp-Source: ABdhPJwy2dh2bwSNKHttxus24Bceb8lVzFnwncaBNCu6G+/ZMhhdPUXEo7woIfLRgOQk7tj9DIJ1Dw==
X-Received: by 2002:a17:90a:5885:: with SMTP id j5mr4576168pji.117.1603301200020;
        Wed, 21 Oct 2020 10:26:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ga19sm2667461pjb.3.2020.10.21.10.26.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Oct 2020 10:26:39 -0700 (PDT)
Message-ID: <5f906f4f.1c69fb81.2b175.63ea@mx.google.com>
Date:   Wed, 21 Oct 2020 10:26:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.8.16-29-gb009255afab7
X-Kernelci-Branch: queue/5.8
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.8 baseline: 164 runs,
 1 regressions (v5.8.16-29-gb009255afab7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 164 runs, 1 regressions (v5.8.16-29-gb009255a=
fab7)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.16-29-gb009255afab7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.16-29-gb009255afab7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b009255afab7a463b4a07438228e492a103ba1d3 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f90389f54dd731f6d4ff3fa

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-29=
-gb009255afab7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.16-29=
-gb009255afab7/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f90389f54dd731f=
6d4ff3fe
      failing since 0 day (last pass: v5.8.16-29-g970dd0292df8, first fail:=
 v5.8.16-29-g94b8033e99d8)
      1 lines

    2020-10-21 13:31:16.907000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-10-21 13:31:16.907000  (user:khilman) is already connected
    2020-10-21 13:31:32.113000  =00
    2020-10-21 13:31:32.113000  =

    2020-10-21 13:31:32.113000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-10-21 13:31:32.113000  =

    2020-10-21 13:31:32.113000  DRAM:  948 MiB
    2020-10-21 13:31:32.129000  RPI 3 Model B (0xa02082)
    2020-10-21 13:31:32.216000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-10-21 13:31:32.248000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (381 line(s) more)
      =20
