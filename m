Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8C23FA1E1
	for <lists+stable@lfdr.de>; Sat, 28 Aug 2021 01:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232405AbhH0Xje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 19:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232433AbhH0Xje (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 19:39:34 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E38A9C0613D9
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 16:38:44 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id y23so7215757pgi.7
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 16:38:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U8xPQQm6gQcdWKMU1R7azedVoMqdVQ4N6Tf0AWVdPxg=;
        b=yKZ8z5wJ23RXQ07z7LGxkjZ+XYWoMcBh2RtlnCuzEkBq4tLI2v1glmPp4rQU8V++3V
         36qee4LnmiRSnunO4cIY7j2O1tuVknp1llHXyOfF9XNKnx/BtOptxZs9Lrzvl75JQleJ
         JBlIdzGBbounPUfnnqoeQJR+II3umzcYSo8loW74mHRAnCOEX31XrnmFs5cV7h9v0kYU
         XdO952sI6Lbw1Bttdyl+XJaQcnREZwM5FBmwg4jfpEQHFDK+r4ydIsDEvlFyXWpbIfMY
         Fbaoai8BAlJhLTOC7TGbbnkIDU9ZiGVZhXfF0CqVZhrc/79G/1I8GNbhwREPsZ0a5JiK
         gu6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U8xPQQm6gQcdWKMU1R7azedVoMqdVQ4N6Tf0AWVdPxg=;
        b=GFUnar6jtmIcU1djxeNqcsMRD5kFSauYO735qeOMUHR7sRCRJ8RurcCtmiLzJVqyhE
         HY+BxbIAVhK7Ef5aKYMZCldokhxvxY0dDWV7NhyildaUf4o2VuStTNUo7amwyo18CNVH
         aZiJVtN/Rh3zj7fegXrP/YzJjr9UQcCtQRVmWExFYWZmmBvGGKooNCxV5vGcfd2sDnFq
         zduDieREF6RwIzhDdNCudrZvDDM6q0EYEhbbrNCkp5TSQpbDBw5HeUxu4X2ZYOl9Zykk
         KmOeYhpzzF9lMO2D+BA0ccgjUJrfUmPF9esv+FY9qAzkanGXnSNyMFlyIMUv9pGmyyCv
         a4zg==
X-Gm-Message-State: AOAM5320e4/uzSU+rNSkGlck80sZp2DFpYOSqEZLtTAZFeUYd0ohnw+I
        HLZFqI3bKcxEXBkfIOa3/m8weGbWvju55d4L
X-Google-Smtp-Source: ABdhPJxbrYGytmaYyX9lofnb5Hko+2BCzlr7/NaV8tKWUKGroQiIV6LcJrX2GEW4eKfM1li0ufpURQ==
X-Received: by 2002:a63:e214:: with SMTP id q20mr9989944pgh.134.1630107524188;
        Fri, 27 Aug 2021 16:38:44 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4sm705941pjm.36.2021.08.27.16.38.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 16:38:43 -0700 (PDT)
Message-ID: <61297783.1c69fb81.a52da.3183@mx.google.com>
Date:   Fri, 27 Aug 2021 16:38:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.61-11-gecd5171696ed
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 157 runs,
 3 regressions (v5.10.61-11-gecd5171696ed)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 157 runs, 3 regressions (v5.10.61-11-gecd517=
1696ed)

Regressions Summary
-------------------

platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
imx7ulp-evk             | arm   | lab-nxp    | gcc-8    | imx_v6_v7_defconf=
ig | 1          =

imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig        =
   | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig        =
   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.61-11-gecd5171696ed/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.61-11-gecd5171696ed
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ecd5171696ed5a484bcebd91aae4a52710b7703e =



Test Regressions
---------------- =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
imx7ulp-evk             | arm   | lab-nxp    | gcc-8    | imx_v6_v7_defconf=
ig | 1          =


  Details:     https://kernelci.org/test/plan/id/6129465ff9ffab2aee8e2ca2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-gecd5171696ed/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-gecd5171696ed/arm/imx_v6_v7_defconfig/gcc-8/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129465ff9ffab2aee8e2=
ca3
        new failure (last pass: v5.10.61-2-g20e0ada087bc) =

 =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
imx8mp-evk              | arm64 | lab-nxp    | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/612948009c84d241448e2c95

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-gecd5171696ed/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-gecd5171696ed/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/612948009c84d241448e2=
c96
        new failure (last pass: v5.10.61-2-g8c7ea8a3f367) =

 =



platform                | arch  | lab        | compiler | defconfig        =
   | regressions
------------------------+-------+------------+----------+------------------=
---+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe | gcc-8    | defconfig        =
   | 1          =


  Details:     https://kernelci.org/test/plan/id/6129479c8750a027438e2c81

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-gecd5171696ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.61-=
11-gecd5171696ed/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6129479c8750a027438e2=
c82
        new failure (last pass: v5.10.61-2-g8c7ea8a3f367) =

 =20
