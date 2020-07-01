Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEB0C210D23
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 16:07:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731223AbgGAOH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 10:07:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729503AbgGAOH4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 10:07:56 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A2C4C08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 07:07:56 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id 67so6986422pfg.5
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 07:07:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qmCeLELJ38xpU4wZi+CaN2uSSS30IxK72pTT3unjqO0=;
        b=ZpbM37Qkze7yLhjYx12xvZYDI7Ma/d6rSrXRvecTHMosUudvvLUnmPoYSqC9xJrTKI
         RNipBg9l1q+iGFJLQsSR0GFjRV/pUxCC+LhEmRdKVTsOG742urHOcBPBHz+tmUDtyNNk
         VnfF76R5UoTSaCV6i1WMtzTMc1kSDkREsZ+7sXNXH7AKjFyJTbHD0y0avkAt7qdjcutF
         KojoQQtq1xNJ7yiTVuAHz4kJpDEumEJIwEuoTQV31Zqv22Sgtc8ky/ykUrHEG3OO8Dvu
         0uJfyGMRNpkrmbEqJ0pDTiYisaTfr2f9RGh2URCLMRTbCt7lo4Yq2rTuK0qcfwX0+N8P
         2zTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qmCeLELJ38xpU4wZi+CaN2uSSS30IxK72pTT3unjqO0=;
        b=fqYWm6TrhIGNljNu2WaVXHbf12u1Nuw8Z04epR0joOoOhy6gMKd856e106S+Orjf9R
         N8qGp3rrCGE7AQnroSX5fb3EBy7BUSZK+1Sd9ATX/zgh26m0cNzyjRwzjJD65iZGj9M4
         Zu6rY+PpqBf990RiWfQTLVE1iCOWtGuO/VM9dV3Ea2LoRFyhIdDV/FmNknS7uWZyP08N
         D/D0UOJtsQAdgLRjnKpK6CKaqiVWIsOROQt5jkzPUgTZsVlqkoedIwKqlOKpFPshQXJL
         QKA15Zgrg+rCZ5I3yn4TYZt/2JE1jq33N9CgR36PLd544EGUnQ0REcYAd5nRi14O3CR9
         wfQQ==
X-Gm-Message-State: AOAM530+Is3W/fEyInoHr8ZRWq98R/akQug3eWlMVVeu6GWWVAIPkZLl
        yBx8ifZZNTEywlg9i2dqXdAl5xLGZao=
X-Google-Smtp-Source: ABdhPJy7kvbsYPBwqgrSjMaiSIimQD9kM8GEr57Qc2J9uWXYAa1eWHrLzaopkfb3IYb/u6WcOZe2KQ==
X-Received: by 2002:aa7:8f03:: with SMTP id x3mr23138259pfr.64.1593612475697;
        Wed, 01 Jul 2020 07:07:55 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 21sm6197107pfv.43.2020.07.01.07.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 07:07:55 -0700 (PDT)
Message-ID: <5efc98bb.1c69fb81.4721a.0082@mx.google.com>
Date:   Wed, 01 Jul 2020 07:07:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.229
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.4.y
Subject: stable/linux-4.4.y baseline: 40 runs, 1 regressions (v4.4.229)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.4.y baseline: 40 runs, 1 regressions (v4.4.229)

Regressions Summary
-------------------

platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.4.y/kernel/=
v4.4.229/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.4.y
  Describe: v4.4.229
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      480787e5be113fba0207addd3c6befabd4532ff3 =



Test Regressions
---------------- =



platform    | arch   | lab          | compiler | defconfig        | results
------------+--------+--------------+----------+------------------+--------
qemu_x86_64 | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5efc674b3b3289c6b685bb18

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.4.y/v4.4.229/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.4.y/v4.4.229/x8=
6_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/x86/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5efc674b3b3289c6b685b=
b19
      new failure (last pass: v4.4.227) =20
