Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 437A53D992F
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 01:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232238AbhG1XBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Jul 2021 19:01:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232143AbhG1XBG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Jul 2021 19:01:06 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7004C061757
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:01:03 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d17so4557364plh.10
        for <stable@vger.kernel.org>; Wed, 28 Jul 2021 16:01:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lt05dXrHT+OCgPEo9dYcXn6UDnzlVIj98KuDKlebpqY=;
        b=h3b7yYKT14HVWqy5FS2znOOLUqQQ+kCNuJFFg97inwzW+bd9W0OUFn0pUF89WaWPRX
         CqoWJjVek80dMMRXOVWWo5EZTfRmLEKOeVbGRASOec1yqXoGPM8z2L46CwnyXwpLXcnq
         gOlnEQ1Y12lhQGlImNlTGiTtbwzEZ7/hiRFQ6U5uG1KXSp9hNPZCTMGOyWOrJ4LOWi6E
         ngGkq1DWdbr35UJMJobnGisSRIC9WAH++RJg9QV+7nYzyw4p7ze8kh++pVDqXGwJm56Z
         2aKZzGJjcDlxM5lydZjjRu5+FAN6hG8VOHgKl3rEclkzCRTGULK/rkVxBrXtSMivXd9j
         dxwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lt05dXrHT+OCgPEo9dYcXn6UDnzlVIj98KuDKlebpqY=;
        b=QX3Zkt9oaqk9ACr3EqO5tcvj86qNHE3jnGbcQTdH6gn4EmnvkKOVh0Tw0Qq5s6Z/WK
         Mo9YHWyqjf2GzM4glRR83O1AuHMSH3PyRE+z7di0jiM8u1rH+gmdP1Lu+URdvJqN8n0R
         Zw2OAlZCFIWP8Z3u87qd3cEbCwvgfjx0B+KjaE2BbxHMWzM14q+Z3cnw04DdFMem1nZv
         1vKbTEXRCVFBZiu1RQKYy0/f7msK8AVVlVF0eeH9u2b26ly1Q/kJbCuPeaLM5H3huItf
         30911Ilv+Azcrt7pLYtkvbrfEGCoL5DIQGgtj15vHB4SX61w5dRyodxxOC3qR+Rcd6B8
         /I/g==
X-Gm-Message-State: AOAM533dOyRufpqtxkQZWrOjxbO8VkeEm1bCG/JAD/kuFhfLrcT+mTFD
        i3Ovn+1hhXcCpBafcQRHEvXLSXYvds5kQFQq
X-Google-Smtp-Source: ABdhPJwOUrGjB+VkHtKkN3O8iK6cSl+Si/rZNnZBes38YsAaFcIQG/lIqgzv/WT1/KeOGAOOCqR/AA==
X-Received: by 2002:a63:ff4d:: with SMTP id s13mr1095229pgk.237.1627513263005;
        Wed, 28 Jul 2021 16:01:03 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e12sm1056001pfc.214.2021.07.28.16.01.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Jul 2021 16:01:02 -0700 (PDT)
Message-ID: <6101e1ae.1c69fb81.90d9.44e1@mx.google.com>
Date:   Wed, 28 Jul 2021 16:01:02 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.54
Subject: stable-rc/linux-5.10.y baseline: 160 runs, 3 regressions (v5.10.54)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 160 runs, 3 regressions (v5.10.54)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =

imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.54/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.54
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      08277b9dde633e1447e96b8cb89da2b40f96ae69 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
hip07-d05               | arm64 | lab-collabora | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6101b01e999c2f242d5018dd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101b01e999c2f242d501=
8de
        failing since 27 days (last pass: v5.10.46-101-ga41d5119dc1e, first=
 fail: v5.10.47) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
imx8mp-evk              | arm64 | lab-nxp       | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6101af8a97c6653ea15018e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101af8a97c6653ea1501=
8e5
        new failure (last pass: v5.10.53-169-gf52d2bc365d2) =

 =



platform                | arch  | lab           | compiler | defconfig | re=
gressions
------------------------+-------+---------------+----------+-----------+---=
---------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/6101aebc424dd8b5c95018e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
4/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6101aebc424dd8b5c9501=
8ea
        new failure (last pass: v5.10.53-169-gf52d2bc365d2) =

 =20
