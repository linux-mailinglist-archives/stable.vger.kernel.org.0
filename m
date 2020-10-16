Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9332B2906F9
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 16:13:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395260AbgJPONY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 10:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2408648AbgJPONP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Oct 2020 10:13:15 -0400
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8899FC061755
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:13:15 -0700 (PDT)
Received: by mail-pg1-x52e.google.com with SMTP id g29so1539756pgl.2
        for <stable@vger.kernel.org>; Fri, 16 Oct 2020 07:13:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EKD7gR4l89roFm/T7l2R4k2fft2+H+kPH19JpFEbfnM=;
        b=K5zohS5YP65ZjgVL6eXFwMlrdnHlSEikILbkMBUtFG+gNlfoVtEmnOW+NqP/DfglKb
         8i/6j8Kh8pXwuztGB1EdeNijgig96fZHrJVyHDZ0Bo0mrzkSIV8C216D50+86+O7kcCO
         YRJOZv1bDJfNnGAT4hKsyK9nZE9japgJ3+gpmUecc4JKseWP/MgyY4ESr133ZK5qOcBs
         JjYYF4tocdoyvSXAosV22StA/E1azBEmZEJln+atdXsUpTVubNIcvOcIHuroZ4gRjzMB
         j/3tpdz0QkmzgwDvWPyhNXgDqCX18g1GSaOl6d1oWw1KrPBMt+zmiToIOsVoCMzq7BvJ
         z05w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EKD7gR4l89roFm/T7l2R4k2fft2+H+kPH19JpFEbfnM=;
        b=peO6UkGpXcFkvSg1WXBmRpWk49oE27uYIGB88GRQpcXtjln/GglYTzQk6SnrKPVth6
         2j5vCyEpaJ96vonLwCnSXQxwl//QS07qqCgDaWTCLBb/sgOdLJtuM+gWOgPLhnblY015
         nyTNioayVR95snL5OPxDyyCfgF1oRZwQ46fn/wSyU+o06jxRVZS/n6P3Cr3OIihsxU0V
         syZkZeEOYguz1cEWTPsnWX8joE51PD5A4K8CQedZZmluWFmQ4Lwe0rsTBOe66Uiv5By9
         Og3zdIS3RYrv7b7ARla1U1sg7ZmPyg7tafJ7SFpJJRldFpK50jJ/7cGqi4hkxZtMa+nC
         BuOQ==
X-Gm-Message-State: AOAM532rg5XzvF6rpsYW9mmX1EP81OM7/NneXbK232D5/08UQwMIBRRQ
        lr4W7wpX5NseZUFAaHO513dbakla6wWd8w==
X-Google-Smtp-Source: ABdhPJxoZqg1fxs5fydIbXcnlgjQmgggHMMl88ijRZFF1baIN7jV0u+5du0xIJVj9r6RlpGQ2pJVOQ==
X-Received: by 2002:a62:8389:0:b029:152:416d:f026 with SMTP id h131-20020a6283890000b0290152416df026mr4158468pfe.64.1602857594803;
        Fri, 16 Oct 2020 07:13:14 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h21sm3170836pgi.88.2020.10.16.07.13.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2020 07:13:14 -0700 (PDT)
Message-ID: <5f89aa7a.1c69fb81.425c3.6163@mx.google.com>
Date:   Fri, 16 Oct 2020 07:13:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.151-21-gcab48ee31796
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 186 runs,
 1 regressions (v4.19.151-21-gcab48ee31796)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 186 runs, 1 regressions (v4.19.151-21-gcab48=
ee31796)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.151-21-gcab48ee31796/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.151-21-gcab48ee31796
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cab48ee31796f7293ee26cee550d4af7443753c8 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 3/4    =


  Details:     https://kernelci.org/test/plan/id/5f896f0de7ea8f0bea4ff40d

  Results:     3 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.151=
-21-gcab48ee31796/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.151=
-21-gcab48ee31796/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3=
-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f896f0de7ea8f0b=
ea4ff411
      new failure (last pass: v4.19.151-7-g003afd33610f)
      4 lines  =20
