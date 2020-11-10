Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46BA02ADAD3
	for <lists+stable@lfdr.de>; Tue, 10 Nov 2020 16:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731108AbgKJPua (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Nov 2020 10:50:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730850AbgKJPua (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Nov 2020 10:50:30 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70B39C0613CF
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 07:50:30 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id w14so9172808pfd.7
        for <stable@vger.kernel.org>; Tue, 10 Nov 2020 07:50:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v/MXL1be0DwxvxK0OprXDiN6Z7jni+c/efdHZh/6qrE=;
        b=B9dycZmlESgup1SpETVbudc6NDqHY2CmO+vV4ujFM+PZXw+ZYGn0PUjZ9LFnGrARQk
         uwzY7nrK1O5tfZ8WGqVU+hlY2qf/JmbLuTqQBiUTTkGRf0f4h4/nTfeNKjep5+DP62EA
         IsFjrqLXVUHwI0Gj4tsd9pC5p2R6LWaBOMCdUNwnrtQ9wd7pWTRlMSCOvtHFcIae0LyN
         3VaTb7vl8FvwufsU8mUe1KG32ztBl5oqRSd4ABHaW//LULt1RmaBvKho2TzAMuCdM6nt
         BWdNz3T7N2djMQI++vQbL1MlJz9C3BpOfRVB4pALGobcOnnyiMUA712XerHRyT+bz3fy
         j9Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v/MXL1be0DwxvxK0OprXDiN6Z7jni+c/efdHZh/6qrE=;
        b=mZ9GIQCPufqzfb24aurMX+pEpzoK7XyPevB7n+mpwjEkfRRnXnvr8XJKewZ3wQ25kE
         eKN6tvd/cS7FIK+Ysqn2ZKw+Qgje+7tIthNYEtKhcxhAKvzDKkEKmInLZHxP6X3s1/+X
         jY85+YeNUCDvFJSuAQQ8y6MYMq86f29RJ/bgBVye7qnaze2boK5jxcPONpuhlTJqyPbk
         Y063lw9LS6uWwMYXbh8Q/JB7eFfvIm6lUVqHCbeThoa1TenZN+ZMboiz/priSorP+VjZ
         B1/n8RSTjDFgDhkxIGh5ARaQ7wrG3auxmYZAfBhT9QuWTJlbc90476g8TX32nPwdK9w0
         DeXA==
X-Gm-Message-State: AOAM530zsJ+lO//7ukqb1W6ivatonqDx9IvvspPYu2KKrS89Py165EwJ
        sKNCAepLB3NEB4G/fjCQS7+1m9qxBU09KA==
X-Google-Smtp-Source: ABdhPJzEzMqyfNi4tCA1eWvu7kpWEJJYq6DZaWrVo5HxYWHFvIc2EDsEOBC1o+TiQKHMn3luXVqcnQ==
X-Received: by 2002:a65:49c1:: with SMTP id t1mr18022214pgs.40.1605023429715;
        Tue, 10 Nov 2020 07:50:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i7sm3740860pjj.20.2020.11.10.07.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Nov 2020 07:50:29 -0800 (PST)
Message-ID: <5faab6c5.1c69fb81.8fa8.8bfe@mx.google.com>
Date:   Tue, 10 Nov 2020 07:50:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.205
Subject: stable/linux-4.14.y baseline: 171 runs, 1 regressions (v4.14.205)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 171 runs, 1 regressions (v4.14.205)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.205/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.205
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      e98f3c4269fda898b913259a7d9b60fb38269869 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5faa83337695cd080adb8860

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.205/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.205/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5faa83337695cd080adb8=
861
        failing since 221 days (last pass: v4.14.172, first fail: v4.14.175=
) =

 =20
