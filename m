Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5057232350F
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 02:21:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232101AbhBXBOx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 20:14:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbhBXApF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 19:45:05 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2037DC0617A9
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 16:32:50 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id kr16so113326pjb.2
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 16:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=BVX07+TrqvMTwXRN6Ow0JDvUqJg6S3QrUuWSwuTLB7M=;
        b=x+le9kVzFwXs8kV0TBVtHYx7vm9KTJagChxpxTuHDFFVTcauahvxM5W6XnA6yOpsMT
         xLeSQ2jAqGBpMXQmZJm47Bwj/Of5Ehoy2FAP58C5Uplyh25DVGMzJUSNKhlzzg9+s5E9
         tnxJC3RJIvv4t6+bv3t8fkVdES9HrxO7ekWMHWQcBm6XKJfS30LYn+mCB9uQyvVa/S9F
         BYoMxXJsDPgsrp391UYEEwL06zp4mHIXeOm/Q76qrBe27bL3eSdOtkB4XBlebOTkFf3M
         kbVrcL9sxb8lWhVIReUGoCxa7VHOoNF/EU5PglhW5Wkt6UUzNpKJ5bmHAgcuWcwbqg9/
         SodQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=BVX07+TrqvMTwXRN6Ow0JDvUqJg6S3QrUuWSwuTLB7M=;
        b=mGMDT8eHB2Pq3cRDfaWX/SSkmeZ2GJfkAHexzfBVIbmlL2dEnyGCsz6+TxUXKZezyU
         pHP428+GfzIhtNPfsQX5NAYu7K3JYbB34t62bvJyayYsb1QypvV2C4/1zvk+7H5llDLh
         559dhW5FMQFWKpURRHOhxCeHEPKIJ4KYJE+sXqJLW+lXzMYs1CzRx4hKVvISt5zf2XTg
         32avxnFbuRLtyZau3iNI5wEZQfNBopgoO5XuROe2FssrCUNBaS5Ywn3tYwOTQX3s+eUw
         w+IvfTlThvLndwe132iRAN2vmyyS7xkG4OrnqcTA1G9mP/3vRqEtWjFRjaaZMgSn8LIy
         O0Dg==
X-Gm-Message-State: AOAM532N5F4kJdcL6+3RraJIaZvD+kzHmUaG3cZJqyS1JWeaRhZT93tI
        T/DJmJPtpOQ1NvbPuz54uBw67yLnyae8QQ==
X-Google-Smtp-Source: ABdhPJwtBO1QfAXkfZTqDNMKh+TefEI5OfwfwEJNljN1+Kl10SuNK8vYZYTgl0hZxx/cyxgxp6lUXw==
X-Received: by 2002:a17:902:ed82:b029:e2:d106:e76d with SMTP id e2-20020a170902ed82b02900e2d106e76dmr28877060plj.46.1614126769574;
        Tue, 23 Feb 2021 16:32:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g3sm375943pfo.90.2021.02.23.16.32.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 16:32:49 -0800 (PST)
Message-ID: <60359eb1.1c69fb81.a5996.1903@mx.google.com>
Date:   Tue, 23 Feb 2021 16:32:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.18
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 114 runs, 1 regressions (v5.10.18)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 114 runs, 1 regressions (v5.10.18)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.18/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.18
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      63b9d2e001fd7ceae418ee124ae228f63f921323 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60356df528aa0ce594addcbf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
8/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60356df528aa0ce594add=
cc0
        new failure (last pass: v5.10.17-30-g905cc0ddef721) =

 =20
