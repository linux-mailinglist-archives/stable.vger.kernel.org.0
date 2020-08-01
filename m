Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 327C0235316
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 17:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHAPrw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 11:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726534AbgHAPrw (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 11:47:52 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59FEAC06174A
        for <stable@vger.kernel.org>; Sat,  1 Aug 2020 08:47:52 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id mt12so8723847pjb.4
        for <stable@vger.kernel.org>; Sat, 01 Aug 2020 08:47:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dn4G1XHuY6TL13b+f+qdjJekC5Ek3ShoHSyVkKN61zY=;
        b=TOLYJjf144ZbaXKqybCAosyODV8gzLjEvnt//rTN3nXMDSVuqGOVUq23gUUDB3jyyf
         G3sbgynDQfYLIO7xDSjh5HErcV3jckuw9a1Fv/0VqcrEec7xPkt+v07eGZv1HKiiSqot
         mf34zd7hByd2Z5vvZq+Qm2q1KkhrNQyS8nDX8wIsYDGTeh+WxzCMmiNB0ro84cB9+SoP
         kVu8fhgHIH1NjZDGX7yB9MhzwedKIl75TN2ph9hAzB4UWnHN+UQ59Ojlm36e+kCXDXTJ
         CtNk4RDKMGrcHipmGUoaH5B1gwFaaLYHa1CQu8+/QbSJwhaXwTveD1RKdh9Kcag9rDwS
         b4ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dn4G1XHuY6TL13b+f+qdjJekC5Ek3ShoHSyVkKN61zY=;
        b=GwU286GcvyCX8Ls3VCEzz0ZK+vFl+yANkkT6dF0kg9R8v8mWeE4fpRVGMWEjW8l/HE
         VxlnJUJAJG1NpWEAiR542asdENfi8mGF4y8dn0xSdwCfm5YiTxEfq9K7yLNUn1UPgLtm
         IC9mmBQXLm4IHJZ6iEKe+NgZkIwItyAvVOGeiM2VMVq9LkhFnaXjt4IDxqo7gu1zNeMx
         gxN7SahQ21p/UmfF8qYOafVo9Kvkz5jAczhVNNq03r3OZUreCT+ERiomDNuKqj+zp/0r
         8krLQQRWvB3LuMl5rkEUdcRrP+JJ5U0D0uQAxDCRufmRizC2y/eEFw1FiP988EpKeiPp
         T1wA==
X-Gm-Message-State: AOAM531YtrE7o7sw1+5y4SPyrzPQG8rquOEwUuSvXDLFcBV+t03WFV8Q
        VLJrgKl9l7Tt9wInOvLeheH3PffRZYg=
X-Google-Smtp-Source: ABdhPJzpYxD3U8wpzbo/YPbZsNk9f0zPgaOl12z55qQGCHo64FVqX6M/GY5uoGfdYyJAcQZdajxkcQ==
X-Received: by 2002:a17:90b:8d6:: with SMTP id ds22mr9333023pjb.145.1596296871588;
        Sat, 01 Aug 2020 08:47:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm14240950pfr.61.2020.08.01.08.47.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Aug 2020 08:47:50 -0700 (PDT)
Message-ID: <5f258ea6.1c69fb81.619bc.2dff@mx.google.com>
Date:   Sat, 01 Aug 2020 08:47:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.136
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 180 runs, 2 regressions (v4.19.136)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 180 runs, 2 regressions (v4.19.136)

Regressions Summary
-------------------

platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =

bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.136/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.136
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13af6c74b14a883366e7702c40c52ff548096e7f =



Test Regressions
---------------- =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
at91-sama5d4_xplained | arm   | lab-baylibre | gcc-8    | sama5_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5f255b3e6bf76351d952c2b5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d4_xplained.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f255b3e6bf76351d952c=
2b6
      failing since 46 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch  | lab          | compiler | defconfig       |=
 results
----------------------+-------+--------------+----------+-----------------+=
--------
bcm2837-rpi-3-b       | arm64 | lab-baylibre | gcc-8    | defconfig       |=
 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f255a8108726c583e52c1a6

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
36/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f255a8108726c58=
3e52c1a9
      new failure (last pass: v4.19.134-105-g62c048b85133)
      1 lines =20
