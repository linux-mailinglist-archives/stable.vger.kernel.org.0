Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54DF21FC191
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 00:33:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725894AbgFPWcg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 18:32:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgFPWcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Jun 2020 18:32:36 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03169C061573
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 15:32:35 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id 23so112950pfw.10
        for <stable@vger.kernel.org>; Tue, 16 Jun 2020 15:32:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6Z8+poWxaUz2zvyYaHwQr0eS8ednXr/MXI7t5ugy6aY=;
        b=zCvzGc765VhAoiF511dQsEVeu8/NCwGgl8FIRp+Y/19D1nMIyGItGGA7DNsuJS6bgY
         gBNvnKLpAoc6SL+mQsghWjcOEmPQb7A49/+BFOgxD/8fej0FZgo9SFm0+Q/r0z3q9D89
         d7E9eoyz9KxBdTkLtTEwEXBz5m1SkOEmxfyfBLMYU2KQ0ZGoyrqYPptPme+iXFn/FDxR
         V3+/4EgMmEPeSapleeuKphnHNW1tnfos55U6PJNTyB/Wj5W3j5WlIGy6S6b6CHeiRd+O
         aTLBDhR69dOsYsM2BkykwHwHzX9xvuL5wIMijEg8N1zQVjmI1aAqKsTHlDMK7CIcl8EV
         /TrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6Z8+poWxaUz2zvyYaHwQr0eS8ednXr/MXI7t5ugy6aY=;
        b=r4vFD3LVMcyQj2WVAORNp7sGW/o1cNUuhts+WLaYP3yDP2Mb6MXZYE2wZLrc1fnLfo
         LDps+v83vv+AE9py/Lr0wXV3gGiLLuFOleL8db+B2Iw88F8gW32qHo8UpvfaB07PjCdR
         oOSabz8Y7QDkxa+rB5BYnyxQZJg3UZcoLDSjgtZv8c1ttUEuSAybYKUYFWw/2dBFewW0
         lZimfMfrp/8AjbwFgyoCBjSYMRtgIqTsMgcI+WhRo1FfVLnj1V8crQJYoTdI4KAOraq7
         PEjnQvTNNsInQF9ewl1REhDTXhAnizG9vKKpAScoFy+NqXHrPnWlfOBuX1vfPHh2f4zH
         /n7g==
X-Gm-Message-State: AOAM531FHBmDSWBC5wZN09VaYCbLHU3weEDLIK/d48myxxPf+Tte3HB8
        hh9Gf48VSf9XCmKNoymfv/vwErlgLsA=
X-Google-Smtp-Source: ABdhPJwLyXXwytROfan1tg3RaA4c/xwY9SXEBqoDTAcTCICkKfVA0ZKDQYMf8nc0j5jlJx1Xi/TvVg==
X-Received: by 2002:a63:5024:: with SMTP id e36mr3607852pgb.438.1592346754155;
        Tue, 16 Jun 2020 15:32:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d4sm3489595pjm.55.2020.06.16.15.32.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Jun 2020 15:32:33 -0700 (PDT)
Message-ID: <5ee94881.1c69fb81.542ce.95f6@mx.google.com>
Date:   Tue, 16 Jun 2020 15:32:33 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.6.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.6.16-245-gb60e06c98873
Subject: stable-rc/linux-5.6.y baseline: 108 runs,
 1 regressions (v5.6.16-245-gb60e06c98873)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.6.y baseline: 108 runs, 1 regressions (v5.6.16-245-gb60e0=
6c98873)

Regressions Summary
-------------------

platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.6.y/kern=
el/v5.6.16-245-gb60e06c98873/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.6.y
  Describe: v5.6.16-245-gb60e06c98873
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b60e06c9887321691c8d341e86c085ed3a6a4138 =



Test Regressions
---------------- =



platform             | arch | lab           | compiler | defconfig        |=
 results
---------------------+------+---------------+----------+------------------+=
--------
exynos5422-odroidxu3 | arm  | lab-collabora | gcc-8    | exynos_defconfig |=
 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ee9195483eca04a6d97bf1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: exynos_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
245-gb60e06c98873/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.6.y/v5.6.16-=
245-gb60e06c98873/arm/exynos_defconfig/gcc-8/lab-collabora/baseline-exynos5=
422-odroidxu3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ee9195483eca04a6d97b=
f1f
      failing since 14 days (last pass: v5.6.13-193-g67346f550ad8, first fa=
il: v5.6.15-178-gc72fcbc7d224) =20
