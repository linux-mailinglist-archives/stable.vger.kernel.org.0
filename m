Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5DB373695
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 10:48:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231876AbhEEItc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 04:49:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231430AbhEEItb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 04:49:31 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B48CC061574
        for <stable@vger.kernel.org>; Wed,  5 May 2021 01:48:35 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id v13so740769ple.9
        for <stable@vger.kernel.org>; Wed, 05 May 2021 01:48:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Udgf7p/64Dacge6c+cjgsxbGpClKuRTIcUTJFAfRjWk=;
        b=dI7gBnFJWvCGJXiWNfktgvh3zufdMr2HBeVBKPcbwwRwcJsgf+RBsgswo0zX+v3RIg
         v8GW//lVL4L/xhHjz/CPP2hUBkkW3UkhMGiKkv0VYDKUtYPA6n1LexYKJQERaPMgi+Jm
         xZQrMKxMvAA7JnWMWfqe9D8FarCubhafJ+W8oqztTBMeBtCeBbJIQ58CVj7EbePkdlYz
         FSzGu8C6LKR538Q4WL7TKw+GniU4sFrxe3Y1OJDBmGd+32LsEEAqyr3RVjiYaizHN1sm
         o9RlpwcN/oTUKfNl1BadOjPoNNQZe02AjzzuPkXNWJHkqwdZ/vMbDjEkQ4HS0Gk69J5/
         Jbdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Udgf7p/64Dacge6c+cjgsxbGpClKuRTIcUTJFAfRjWk=;
        b=maYdKmUxE7hFtbJ3Kv1ksu5ukORBUDcD9h3pBn7k4OOyKanqm9ohc2WcdEKrZ6Sm8J
         U8uoj0pttT7YvIpBJVRSDKoVt+j2UnCqREU+Ri0bP1rI+W9jVBtDw5tRGycCnj+VU/mW
         IwiEO7JQhe4NqydC+bDgNrPg6QAKIq8OPy977VI0ZU+GOKQuskRbWOdu/Hju2qkh4Z/I
         XwRllywO80xNm4UQv1aZCDqA5umLrdaCc0V7QR6ZnJRUmK3fEhgmJIV+dEl5uJK/plcu
         oxFoGfA/G/ycDyfNElkeA2rPLHJXLNdv+V9Z3SLEAVA2E3xZ5QpV3Vy7YInms7kx4FOP
         SIzA==
X-Gm-Message-State: AOAM533TM6mE5gphe/4WzSyE+cGpOhCnhgfn50Udcy87Tp44DCPKkXP4
        rgtSPAhTAoQtG9ysdlxiP2vObT/5iACysy4o
X-Google-Smtp-Source: ABdhPJxlgMxIedTkvqDUgXs/rx4m7nZkIsl4bpJ+9U8zYrXkf90oWQUTfJm06+0OEvKT+AQsf5b6hg==
X-Received: by 2002:a17:90a:f2cf:: with SMTP id gt15mr10238764pjb.64.1620204514910;
        Wed, 05 May 2021 01:48:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w8sm16180224pjq.10.2021.05.05.01.48.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 May 2021 01:48:34 -0700 (PDT)
Message-ID: <60925be2.1c69fb81.2d8aa.79d2@mx.google.com>
Date:   Wed, 05 May 2021 01:48:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.34-8-g14447ec121b31
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 115 runs,
 2 regressions (v5.10.34-8-g14447ec121b31)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 115 runs, 2 regressions (v5.10.34-8-g14447=
ec121b31)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.34-8-g14447ec121b31/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.34-8-g14447ec121b31
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      14447ec121b31742cc15819ebc25a3060ad26149 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/6091fac89bb0247fae843f1a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
4-8-g14447ec121b31/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
4-8-g14447ec121b31/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm283=
7-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6091fac89bb0247fae843=
f1b
        new failure (last pass: v5.10.33) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60920039511ba77927843f24

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
4-8-g14447ec121b31/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
4-8-g14447ec121b31/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60920039511ba77927843=
f25
        failing since 4 days (last pass: v5.10.33, first fail: v5.10.33-3-g=
9fe3189f108d) =

 =20
