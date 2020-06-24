Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B36A2073CB
	for <lists+stable@lfdr.de>; Wed, 24 Jun 2020 14:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389393AbgFXMzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jun 2020 08:55:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388942AbgFXMzS (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Jun 2020 08:55:18 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AD5C061573
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 05:55:18 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id l63so1366160pge.12
        for <stable@vger.kernel.org>; Wed, 24 Jun 2020 05:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LKYZikns6FxT5uNm1cLzLw9A6wNVTv50J74ch37U/Jw=;
        b=hkETrF5omNsbhidIuityCVclf25Z8QJCfQwUZzVMGFKQlYCgkqN2OcvZcgEqkOQpNH
         5oZPMqurKConjXi2kWrstWUjhOY/h0zwCCQGTei/5ZgnN37hQTk5eITRXll3sRl+rg6s
         H/w3wjP546ZUTWzr2dMiKtY7LlfcbLmx2CIJXJfyetyFkVLiE8FmS9KFS2B5UQR2YhbA
         J2pTiRdCxCKgH1lqjfqMd471CwSPaHbgJ/EkUP0OC+4OHNridc6qVTHdqFxstm4fwcNB
         PtGQ2Xb+LujhBc2PZu99MP0nS4EXto+pBp/UsOiOjeLLXj4Sdg60rZpTMX8ojV9tDsg9
         o6ZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LKYZikns6FxT5uNm1cLzLw9A6wNVTv50J74ch37U/Jw=;
        b=HVqCFj2AuiJJk/UhM809U44910bVF3bCrVfXaJYw1AWx5UA7QcuWXZfHU1IZ266pXY
         f9xmiRKalbIIn/usJv3tebp6pKWvBGjNcYbhdM6q4/XHIBLnE/7xLZjDsJrmm3t2gtIx
         bhCRy+ARYXCy5GTuT5T834ASttqx/arRnvXNY/2exgF+lv5RJnB/B50TLQh9KuQSKsMC
         IehVxDmUlUZKY+ooqopixxMU6jlJmEbwecu2WGsTSxEN8lth/bjaTHyFXpYWY5ON0BYn
         eXIiZEKNd2tiFUu3kPCMDGKZhrottTwYWbTXOwRIYBT5ot34kwUKe1uvrpFl97tM1nMl
         GcUA==
X-Gm-Message-State: AOAM5322PomSNOcnduZIXeGlbg0VNGl59nWS3xNJJI/zWbbRXj3ubcq0
        4ovXbfElH3CLw7AeESe2o/oYypqEMSQ=
X-Google-Smtp-Source: ABdhPJwK1mqHHf4k7sL4uwnTeuoiF/1m/8PvO4hU/sxVQ7movuri3h9zVvQkj4I2PMt8p1rSqnPgIA==
X-Received: by 2002:aa7:9782:: with SMTP id o2mr29735913pfp.212.1593003317889;
        Wed, 24 Jun 2020 05:55:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1sm5435843pjc.33.2020.06.24.05.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 05:55:17 -0700 (PDT)
Message-ID: <5ef34d35.1c69fb81.aa0bc.1399@mx.google.com>
Date:   Wed, 24 Jun 2020 05:55:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.126-525-gf12dcdbf9d54
Subject: stable-rc/linux-4.19.y baseline: 76 runs,
 1 regressions (v4.19.126-525-gf12dcdbf9d54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 76 runs, 1 regressions (v4.19.126-525-gf12=
dcdbf9d54)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.126-525-gf12dcdbf9d54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.126-525-gf12dcdbf9d54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f12dcdbf9d549ca30275420a0c7f1c27ba80bf23 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
bcm2837-rpi-3-b | arm64 | lab-baylibre | gcc-8    | defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef31958d5382fe48697bf09

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-525-gf12dcdbf9d54/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
26-525-gf12dcdbf9d54/arm64/defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rp=
i-3-b.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5ef31958d5382fe4=
8697bf0c
      failing since 0 day (last pass: v4.19.126-501-g74874ce1e245, first fa=
il: v4.19.126-528-g54d0fce94603)
      1 lines =20
