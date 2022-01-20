Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F59C49555E
	for <lists+stable@lfdr.de>; Thu, 20 Jan 2022 21:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377618AbiATUWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Jan 2022 15:22:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377629AbiATUWD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Jan 2022 15:22:03 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97905C061401
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:22:03 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id d5so4634318pjk.5
        for <stable@vger.kernel.org>; Thu, 20 Jan 2022 12:22:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/6uTobqv79hNMYo9r0wOKv/XGMOzEV1zOZ6YKwDSEAY=;
        b=lH5zR6ehy/6wrZEigw4Gdf1TZK4BDBjWTKsvSO5H20Hlx9zKbQO6y7aYVLXGFlpjmS
         rm85Z48HeS0ckZ9IIuy5v42hvy9JdyYgrqY4CmRRYb2xeYksPJ7yf71QSLlX18HWTbek
         WxMvGp1RcwnKdthFIemkJHrox8h5PTloxkjex7tJ7X+y03+HnOTORtKmj+bfL8pIPkiD
         x5vqEzsgYqP9sw64QGH4ikT1IvWEDmNuoD/22OilVVHlNa+itvqkKlSkEVvJ8T+Bphmp
         P1+1uxN7zfAyThA5AH3G6qVWuvVirMbAK/GW0c6RbF3WDpmY612ix3oDsx2RRFOVmSQf
         4DDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/6uTobqv79hNMYo9r0wOKv/XGMOzEV1zOZ6YKwDSEAY=;
        b=VOJsOtZZvoU1gdaer3rQawbn0IBkqW1tQcibD/ZPKG1ppWiVggPGsV9AI6cDvj92tJ
         n+1rzv/d+LuD54nP93p4fry9o8wV3V0YJP+EqWYM8nZkRX/WMtb5IwITO9fSxTBlCI28
         eABOUNSFdBB/q9aBfyoGBi5GWZ87kI1CiceTn4sq1EUv373oV91/AK8xCiK2iXNV+7wC
         zhc5jJHdePQJWiRNX0Z9s5iiQf+35orVyPFGOgZL08L1giQJLZsrE7d99muwQ7LT2hSt
         b8HM/5ILZlwHDmzYta2E6UyZ1lcatyovs+lXlbiGuhOMUPBwHsGWSQAMxXXZIlA8oH2K
         JRVA==
X-Gm-Message-State: AOAM531/zvC3k3LJ9FT0ezmMFdoOA2HMk1n0kKQniBWw27NtVHt+XwJK
        yLBBECPEHlftj7yO7G8Btw82zpDbKCdxH1yF
X-Google-Smtp-Source: ABdhPJwB5+uvOBVKyNFVt+bwy74xUE6aU7HQ0mXqo4VJnfTdFaV7m2qq4V/sblqkytbi+eO1w7JfFA==
X-Received: by 2002:a17:90b:1c02:: with SMTP id oc2mr12809932pjb.31.1642710122986;
        Thu, 20 Jan 2022 12:22:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm3158666pgi.43.2022.01.20.12.22.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jan 2022 12:22:02 -0800 (PST)
Message-ID: <61e9c46a.1c69fb81.e276b.9787@mx.google.com>
Date:   Thu, 20 Jan 2022 12:22:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.16
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
Subject: stable-rc/linux-5.15.y baseline: 173 runs, 2 regressions (v5.15.16)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.15.y baseline: 173 runs, 2 regressions (v5.15.16)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =

kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.16/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.16
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63dcc388662c3562de94d69bfa771ae4cd29b79f =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
beagle-xm          | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61e991507e7b03c91cabbd47

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e991507e7b03c91cabb=
d48
        new failure (last pass: v5.15.14-70-g9cb47c4d3cbf) =

 =



platform           | arch  | lab          | compiler | defconfig           =
| regressions
-------------------+-------+--------------+----------+---------------------=
+------------
kontron-pitx-imx8m | arm64 | lab-kontron  | gcc-10   | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/61e98e2c8d707fb00fabbdb6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.1=
6/arm64/defconfig/gcc-10/lab-kontron/baseline-kontron-pitx-imx8m.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61e98e2c8d707fb00fabb=
db7
        new failure (last pass: v5.15.14-41-g760a85303c5a) =

 =20
