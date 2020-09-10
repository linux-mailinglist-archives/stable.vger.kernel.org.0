Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81906263AB1
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 04:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730532AbgIJCHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Sep 2020 22:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730294AbgIJCCb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Sep 2020 22:02:31 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADFFC06134D
        for <stable@vger.kernel.org>; Wed,  9 Sep 2020 17:46:58 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id k15so3610396pfc.12
        for <stable@vger.kernel.org>; Wed, 09 Sep 2020 17:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=E3twtkhwBHOVYr1bOubTZOCrGpvBF82D2Va5s2od4h0=;
        b=ECPxGObkXgKb4ER7mdau2mgtSnlgp46ICZHEC7Dfxi/tRFiyrUsfNrTlcIJNqNanu/
         vHZnYD1AeeyGhyPS+H1KwwkGTyP7YAEN3uto+fhHKzmI4yUjyGkVgl9riQ3RP2co0kCm
         ubmSSgpmsOayF1oU/fKg7eUx6dKc5UW+Uqt1kBGGJODyYvKCmkyT+tWona5uHX9Wv0Cv
         ozXeJMTpvjIwLWUXIw9uG4uDxe2Emw4Q1JWv6kmjwOE1PvmhNIFb8aujB0z59b6wnXCS
         NWDbvxu6aicWhT0/eFug2egTxg3lDhuAQCbViczzwNPQLlWxS4V/XS3SC461iK+bFK5T
         93rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=E3twtkhwBHOVYr1bOubTZOCrGpvBF82D2Va5s2od4h0=;
        b=fkXGWhEDHsG3ZpZe9GaI55EjaeAwWoMGK6oPyGGUy5tIvNVa/MRnRFsyTx7teu9Euz
         shkPrTMMPvaDNv3Ti0WzJ4U8m69hfiL70U8n7BwS0G3ZOGh47+7EPvGXzFC3+hHe94gu
         B8r01D6z9Py3w4YRl7OMQcOnYRBBrqw+1zm/tqQ8eTcwi23qdjqLxyBnv+AMrIxC2CtK
         Z+vxV853ZPnJ5sLVpr7/oIVLnH+ruCROSuM1rmSrM7lADOmWYWealKJ74htoqrfQwQkh
         RQR59ZMKhuPcctnAPV31tSZso+2oFHJmIALb4Uo3lfFQqfn6pZVk9BDLdvm9Esd/DVlZ
         697w==
X-Gm-Message-State: AOAM5330tH3V7PBM50FgILdulTUZ56nHFEJ4KRr0hKXaVhxItn5wfKgK
        Btqcfr4EqwFDNt0csAzF9i/Oj3Mh/iSbRA==
X-Google-Smtp-Source: ABdhPJxTk/ePUG/qwpow8kl/NLQCDmNzvKmjjpbUMFugRkX1cQwIzZ/+LGn417SEUXj2pyrgbbw60w==
X-Received: by 2002:a63:ec03:: with SMTP id j3mr2262333pgh.299.1599698817742;
        Wed, 09 Sep 2020 17:46:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d8sm295603pjs.47.2020.09.09.17.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 17:46:56 -0700 (PDT)
Message-ID: <5f597780.1c69fb81.2fabd.1422@mx.google.com>
Date:   Wed, 09 Sep 2020 17:46:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.64
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.4.y baseline: 166 runs, 1 regressions (v5.4.64)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.4.y baseline: 166 runs, 1 regressions (v5.4.64)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.4.y/kernel/=
v5.4.64/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.4.y
  Describe: v5.4.64
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      6ffabce36fc83a88878cef43e8b29b0103e24709 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f5942b3c69b96da58d3539a

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.4.y/v5.4.64/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.4.y/v5.4.64/arm=
64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f5942b3c69b96da=
58d3539c
      failing since 4 days (last pass: v5.4.62, first fail: v5.4.63)
      3 lines

    2020-09-09 20:58:54.251000  Connected to bcm2837-rpi-3-b console [chann=
el connected] (~$quit to exit)
    2020-09-09 20:58:54.251000  (user:khilman) is already connected
    2020-09-09 20:59:10.078000  =00
    2020-09-09 20:59:10.078000  =

    2020-09-09 20:59:10.078000  U-Boot 2018.11 (Dec 04 2018 - 10:54:32 -080=
0)
    2020-09-09 20:59:10.078000  =

    2020-09-09 20:59:10.079000  DRAM:  948 MiB
    2020-09-09 20:59:10.094000  RPI 3 Model B (0xa02082)
    2020-09-09 20:59:10.181000  MMC:   mmc@7e202000: 0, sdhci@7e300000: 1
    2020-09-09 20:59:10.212000  Loading Environment from FAT... *** Warning=
 - bad CRC, using default environment
    ... (387 line(s) more)
      =20
