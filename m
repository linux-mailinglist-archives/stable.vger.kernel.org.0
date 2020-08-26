Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF3C2539E8
	for <lists+stable@lfdr.de>; Wed, 26 Aug 2020 23:44:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbgHZVoZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Aug 2020 17:44:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbgHZVoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Aug 2020 17:44:25 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 077C0C061574
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 14:44:25 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id n3so1609123pjq.1
        for <stable@vger.kernel.org>; Wed, 26 Aug 2020 14:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/WXqH/I1Co3PpTtxzrCAnBj0xYxkfczUA40hCMA1JKI=;
        b=tQr3ts5K51M3gvyeDqK/34pGMpsWKGMYqre3aUmFfZzi2jTTDsl9VGJq47ghrL07Bm
         NJip8qmzHpP8RxxpcDAbuDFxsmYu+xXisTPGemfJVrc1pyPch2sTG8oql/b4xAOGZDYW
         JqAWqmMUKZu18LkgEaCrs2qxMwqg/4GIEPL8CgFYzl6fFnvzzNkWi6TWjKx4XKfm9UUB
         DOQl6JuUUGA7/oTVWKN70svbnbQUV6JuW6mdbiObyVlAKO0w0eoUhgHE2fB4bVU9sPgV
         i/tlqQmVul99YqccmtrWyflPkIdYs7OL4fRxdX1akUz2chBwAaAo7ENvGS2cr6LOPKMm
         dpAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/WXqH/I1Co3PpTtxzrCAnBj0xYxkfczUA40hCMA1JKI=;
        b=Oe6672ZNBTFv/zSKlYEMEwUYXPTMOBKTAupBOBGBP8GE66095h5coRhwar6cqqpvei
         8JumhZHVKGfO9Dxt3izXP9SgScQYzu5iMwcsSBVpi6eecNmWiU21g6Rk17y5GfUD96qc
         jonc2AqIe4m4ZabjxJUSuJRQ/yg6gSqrCaEL7Pufczv0Oq7zG1Sz8BFvHaSjnReDseHs
         JyDN+N9zqrQ16UWnE47e58nVVUVkYgqqZ8ekAlUEM+U+MW0FvHXgim+QiNpyzFDga3DK
         rycV7gykPmPJaTnVEac1nexg+HqBa4idad9imlrEVhb3EMu9YFJi/4Ja8yO0bbve5BjX
         P9gg==
X-Gm-Message-State: AOAM531fcPObvqNMbWTYB6xKNaYCfp1XIJw6i9A1ETX5Cpxl7KlPYY6B
        Sk9gXI/h+3WQF/LFwjnSo23+nGDCeLnRVA==
X-Google-Smtp-Source: ABdhPJyYziYmR/NRIiehD6xqwqu9q42U1E4nyr1HiJ8E0RMARyqzwJtq9+P68oO0BrboSMUMAwmD/Q==
X-Received: by 2002:a17:90a:8904:: with SMTP id u4mr8082796pjn.87.1598478263692;
        Wed, 26 Aug 2020 14:44:23 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ha17sm64741pjb.6.2020.08.26.14.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 14:44:22 -0700 (PDT)
Message-ID: <5f46d7b6.1c69fb81.60d98.090b@mx.google.com>
Date:   Wed, 26 Aug 2020 14:44:22 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.61
Subject: stable-rc/linux-5.4.y baseline: 188 runs, 2 regressions (v5.4.61)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 188 runs, 2 regressions (v5.4.61)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.61/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.61
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6576d69aac94cd8409636dfa86e0df39facdf0d2 =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f46a2e76563d07e689fb42b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.61/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.61/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f46a2e76563d07e689fb=
42c
      failing since 137 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9)  =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f46a1125ece8837e99fb42b

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.61/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.61/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f46a1135ece8837=
e99fb42f
      new failure (last pass: v5.4.60-110-gd3dbec480949)
      1 lines

    2020-08-26 17:49:10.236000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-08-26 17:49:10.237000  (user:khilman) is already connected
    2020-08-26 17:49:26.580000  =00
    2020-08-26 17:49:26.580000  =

    2020-08-26 17:49:26.581000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-08-26 17:49:26.581000  =

    2020-08-26 17:49:26.582000  DRAM:  948 MiB
    2020-08-26 17:49:26.596000  RPI 3 Model B (0xa02082)
    2020-08-26 17:49:26.682000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-08-26 17:49:26.714000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (375 line(s) more)
      =20
