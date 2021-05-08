Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60A52376E5F
	for <lists+stable@lfdr.de>; Sat,  8 May 2021 04:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230289AbhEHCFz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 May 2021 22:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEHCFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 May 2021 22:05:55 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CFDBC061574
        for <stable@vger.kernel.org>; Fri,  7 May 2021 19:04:54 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id k19so9163810pfu.5
        for <stable@vger.kernel.org>; Fri, 07 May 2021 19:04:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=WAJwbkemMWeKR0OOLqTm08BPsi5eenhOLo3YVPWMhy8=;
        b=TFUr+qZBCMz+5dnFfzgHZDFg+CYpLV8IIyzp1ESMuXklVJG2t7lVZtPxfXJioyWkQ/
         MbvwQuGS2DtUS/9QoA+ln50aGJ258HS35DaBFweK9QXZNzGSYCW5Vmwj8Nh7D+OMhaQu
         vMtPzVKwf8/YgpMUE+dNINy8tRPg4ql+tWbkW9jRaRcq/Wq/Uo4WKpw9fKTKsZMESKxD
         GW/U/J6dE2nDko0HJ2g21rqo6O85DOGeXNtugBiYc6wFsLTcfcO89u+qiHV9JaQY5zvw
         pXN+iIzDNw0SRE3Q7dkXfZTqx5sUVoQVz9jpZ1QHNOJh1JRjMhg7YT2mNanqXPVw6m04
         dKyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=WAJwbkemMWeKR0OOLqTm08BPsi5eenhOLo3YVPWMhy8=;
        b=MEe8MU3Gc7k+ZCq7H+cznFfljwHfcXYVtqm4oef/ZW14Y7Ug9dkUoUItP4SdPE7DhL
         2eqQzi486PsZ7Nm+MyZZZv5QpDXSFCTmSb4kdXX7VuCvk4hTs4bcihH531lO5TTC7TvU
         OfEIUHjiQdJmlQUUwTmiKcb9UspYzlybnoDSxh5r6Uom5EJq+Oz17N9WEb13vXWBioZl
         zPEYusTkJncrp1lbyxVW9fPOk+OsuEy7wGWrqRSHTHg4clpwjZin1Jim897ktV8rIVEl
         SzKY4HMzeo7FZzfT1Nj8RJYvt4rX6Sv/8tY7ij0QcSc3MvzdVMcgXyqfCYJRD0c1g47u
         4Uqg==
X-Gm-Message-State: AOAM531fJACzfsqYPrsxv7D8mC1HEyFlOWoTe38vMHBaa2WqyLQCNLFV
        GdRWMmN7aXMi3btXo4ccaMLuFBwa8FQVPBOr
X-Google-Smtp-Source: ABdhPJxsRGlLUGJy7U86XxlQe787G0BYoJqWpzmD4jAEAHu5YmzqnJ0tlHcxyyL4h/d0LJfmgO+Uog==
X-Received: by 2002:a63:4a0b:: with SMTP id x11mr13459584pga.8.1620439493747;
        Fri, 07 May 2021 19:04:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z29sm5604315pga.52.2021.05.07.19.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 May 2021 19:04:53 -0700 (PDT)
Message-ID: <6095f1c5.1c69fb81.8e22a.1d94@mx.google.com>
Date:   Fri, 07 May 2021 19:04:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.35
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 126 runs, 1 regressions (v5.10.35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 126 runs, 1 regressions (v5.10.35)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f53a3a4808625f876aebc5a0bfb354480bbf0c21 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6095bd3e4fa42d02456f547c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.3=
5/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6095bd3e4fa42d02456f5=
47d
        failing since 2 days (last pass: v5.10.34-29-g9efe65f2d6926, first =
fail: v5.10.34-30-g5f894e4a8758d) =

 =20
