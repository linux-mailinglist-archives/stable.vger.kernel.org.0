Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7FE224E208
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 22:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgHUUSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 16:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725831AbgHUUSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 16:18:05 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F7D8C061573
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 13:18:05 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id mt12so1293995pjb.4
        for <stable@vger.kernel.org>; Fri, 21 Aug 2020 13:18:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OdFjyGmhZfEh82XwPDTRDNUdXa6mrlOLNn9OMrg/YU8=;
        b=x77pcE8HL7dN4wVA/+/e7JtfLA54WukIgtam37+Grs5mn068hhFf6sglG07ADGUT8u
         fC0GHn2QrnfZ5x0dq4GLK8SkNAKY+Bp8+tv22BqUJkav1DsVjlApI6Arozpno8RseA7b
         4cRhUbaf5G4KmtTuKGEfSvpXiSImraUlOfHOMvFlR8sqyrGRVAwy6xUcUVUA6dHfvZox
         E3/bYm8tjyQdj4ajTwsOYiz5c8ehnpzqPcOrJXV9c0S0ARNMEkplu+pEAvpSGBaPvepe
         Gfq0jCZ1m85MLyk0VGhgt8MqEkyw4GuxZKlAZaqJGhVsAFj5+ldc0QKDe3euaTr/t2Pu
         ZVPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OdFjyGmhZfEh82XwPDTRDNUdXa6mrlOLNn9OMrg/YU8=;
        b=KVU5ekrAY8i5LG738GjewxmV0x6H8v/FbOmoreo6yeUTphuwavxP0kvs81DThvJtWP
         pJ71NUnwwQu5O5OBFznH05L4Fr/j1HiwgSeH/8edt09alyoiCJ3+19oXtzu9+k3ZRUWv
         DJsXW0NBkvzG1yI6O8jAfRTY0jNsN7cXOU9hgJzk8KJwb80avfcoxSZExv1WoWIGaOAu
         XlVG71qL/DfRS1B2MMk/sg2QAxCZ8ZQqW30RtMJDO5hYxx9SIilHFGlIHnDoYAxYT/0j
         /YI22VjYh0wmtsGPs991o+Sl9Q9LFqSZgFsaAnRo8EbjqSH2VwyqZH/ZjgSt13Ud+Iih
         RAWQ==
X-Gm-Message-State: AOAM533aXt4dbgrk9K0CG/+zxzZ0NMTPEqv0tEoWSg+k1RVbYpYTso+c
        wb0H3R3nxI/nEnpbDrxEEkKyRWTAvcjrFQ==
X-Google-Smtp-Source: ABdhPJxHjVhk5XGQtmiUxK7Ky5yyUtddVW5erBbA5Lbs7Bk+ugn8Z/tIaUm+btT6CofFu1WyTOqaLQ==
X-Received: by 2002:a17:902:ee0b:: with SMTP id z11mr3591389plb.161.1598041083415;
        Fri, 21 Aug 2020 13:18:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q82sm3903462pfc.139.2020.08.21.13.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 13:18:02 -0700 (PDT)
Message-ID: <5f402bfa.1c69fb81.e986e.c4f6@mx.google.com>
Date:   Fri, 21 Aug 2020 13:18:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.7.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.7.17
Subject: stable-rc/linux-5.7.y baseline: 181 runs, 2 regressions (v5.7.17)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.7.y baseline: 181 runs, 2 regressions (v5.7.17)

Regressions Summary
-------------------

platform              | arch | lab           | compiler | defconfig        =
| results
----------------------+------+---------------+----------+------------------=
+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
| 0/1    =

exynos5422-odroidxu3  | arm  | lab-collabora | gcc-8    | exynos_defconfig =
| 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.7.y/kern=
el/v5.7.17/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.7.y
  Describe: v5.7.17
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3f45898cffc4e386952f3e4821810500adccea1f =



Test Regressions
---------------- =



platform              | arch | lab           | compiler | defconfig        =
| results
----------------------+------+---------------+----------+------------------=
+--------
at91-sama5d4_xplained | arm  | lab-baylibre  | gcc-8    | sama5_defconfig  =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f400009b8a31725159fb42b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17/=
arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f400009b8a31725159fb=
42c
      failing since 36 days (last pass: v5.7.8-167-gc2fb28a4b6e4, first fai=
l: v5.7.9)  =



platform              | arch | lab           | compiler | defconfig        =
| results
----------------------+------+---------------+----------+------------------=
+--------
exynos5422-odroidxu3  | arm  | lab-collabora | gcc-8    | exynos_defconfig =
| 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f4023c9b8b606d1759fb42b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.7.y/v5.7.17/=
arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f4023c9b8b606d1759fb=
42c
      failing since 1 day (last pass: v5.7.16-99-gc5aad81e7f2d, first fail:=
 v5.7.16-205-g7366707e7e99)  =20
