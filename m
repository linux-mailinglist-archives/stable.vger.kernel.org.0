Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 754D13E0C18
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 03:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237429AbhHEBdH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Aug 2021 21:33:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231964AbhHEBdH (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Aug 2021 21:33:07 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02466C061765
        for <stable@vger.kernel.org>; Wed,  4 Aug 2021 18:32:53 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id o44-20020a17090a0a2fb0290176ca3e5a2fso6274227pjo.1
        for <stable@vger.kernel.org>; Wed, 04 Aug 2021 18:32:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x4Xm1zIXrIclj9xKA15g5eydm5NTVitiJKb8rGqzGws=;
        b=uWt+1ArdWElq5zZf3P62H8gWoRtVgV8VfA5h//rJDcT0ypmzpA4kkSK791Pio2xW4B
         xJObSWLS25W5R4Qr22PVlP6kduEC4gzR1pwatki8vMEuh1CxGCuZ6wfgUW9vfDzdMOze
         46kTsKtSoeNs9Wq9F//JTxUVRQqpqnBgnAWUhPUBWV0nXWPjflnT0CmOsN6XEYCaMwrM
         lQWnzdID+ci/D5NhOIjhA6kTn9H1tbGv708lbqqJb+0Gd3nASicMud9zBSPRDBB6SgNc
         kGEmCcCvbxao/Dwygx+Q1CUT7jBI+UfrRbpVuBYVveVeFA8CrhouVFXm+pduYvIBhsXs
         5gOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x4Xm1zIXrIclj9xKA15g5eydm5NTVitiJKb8rGqzGws=;
        b=P0fN+V0P8d1lMN9TFGdjGNPLFDw6xb6cKEjXO55L6uvZ3/Y86WncAz4SXagAfoTtXx
         d5/S4a0QFFHjLgKzGjljTdb/EoTAJyf9iY38A3IU7+goStE8a2BnimTraQthRPwbzZES
         9cV+r1CiM/0FHiVw/6prjmQzIzhN9isgfeJRgyMhRHwsvpOp6YfVc/6g6WvYL4i89jv4
         djz71dBVL59SLyF32f9uTjA5Yv0mEkvZ33Mma6485x2XqFC7HpqnEBkL5Nn4yGacC2Gi
         KPjxduPJk5yyOAZyyz3rQwHLATcydSO19MXtBHj464GIWdAnWzffPKfARECxcthmKkNt
         mrAA==
X-Gm-Message-State: AOAM5321kPPskq+l5Im5W6i17OgW+VYzcdfkOck3wfCPAlCOLJtOQ5df
        Hq+KJx+7fW8gnxZF+pMwrD+phbbCVflE6do4
X-Google-Smtp-Source: ABdhPJypPlMd7WxDBajugcf75Bhmu/DUd8Ege3VmqmlMXI/d9ozWQqiwe8Ixu2Po1aeOFlVXKcfmAQ==
X-Received: by 2002:a05:6a00:1622:b029:3b0:2727:2a96 with SMTP id e2-20020a056a001622b02903b027272a96mr2262059pfc.6.1628127172355;
        Wed, 04 Aug 2021 18:32:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 11sm4304956pgh.52.2021.08.04.18.32.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Aug 2021 18:32:51 -0700 (PDT)
Message-ID: <610b3fc3.1c69fb81.a004a.e5c3@mx.google.com>
Date:   Wed, 04 Aug 2021 18:32:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.56
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 84 runs, 2 regressions (v5.10.56)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 84 runs, 2 regressions (v5.10.56)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.56/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.56
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9746c25334cb364ab6651ee6dfd4cab3218d0c06 =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/610b0aa5557e74c510b13673

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
6/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b0aa5557e74c510b13=
674
        failing since 2 days (last pass: v5.10.54-25-gdfa33f1e9f64, first f=
ail: v5.10.55-68-gf9063e43ccbb) =

 =



platform                | arch  | lab        | compiler | defconfig | regre=
ssions
------------------------+-------+------------+----------+-----------+------=
------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/610b09cf22bdc2ac38b13671

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.5=
6/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-bananapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/610b09cf22bdc2ac38b13=
672
        new failure (last pass: v5.10.55-68-gf9063e43ccbb) =

 =20
