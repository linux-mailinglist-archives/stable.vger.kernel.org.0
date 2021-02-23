Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087103231B7
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 21:00:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhBWT6O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 14:58:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232179AbhBWT6M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 14:58:12 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E313C061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 11:57:32 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id s23so2708675pji.1
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 11:57:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p5VEuvpx9vGPmc4u+KYsGyIc+4zd2Ff+i82hQ1gjgxA=;
        b=ndiMTBsmF9tzsaYRPVhEUm+BHcIh+j+rVHic/Z28lg2xTRGZSIyhTo5J65QxOZx0KC
         1K1inI7VvJB8QQra6MZ809/7Bx/hl9Cb6cXgnNC+DPLw3ybIa2zIY/frV8EYrmk1jO/7
         Hw5HyZbuP7dxVDoO+aQhLAhK9hz2atcyrG/E4vPVT8OBer+nEkpIj+pwUnXfcDy7C+Ec
         lzoNWtgC94YVmOhUbu3B+hbeKnT/jLyxZTBzgNRGDP02GuZ26ZDrdg3rJRts72rtf9/o
         KARLjih0GMHbETYd6V+y11E9i1312hHrmd2PC8IfFKBOzJBftpm89pnwJ7LTD+ztVWt7
         YwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p5VEuvpx9vGPmc4u+KYsGyIc+4zd2Ff+i82hQ1gjgxA=;
        b=ZU7sjnSCfwmra5Ncy3DT75NjgC3cud0nphY9P2Kk+pTg6V4PFzTE4A8CG1Vd48NY3K
         Bdrw+owyCUpCvgb4XR4g60hEUmerhA/tL0ia2u3d+vnv+QkUcLOZ8DAM8uVWbUiek4pz
         ne6+/yx+FcEnOehn3fG+FVBrYyZR1HsndhlRFlJPOSuY2CU2m5FQcqLAEYCsH2kuIFJL
         gDa3J5tUG7T/DjbYHjQsRGxDOPZbx8C/9rCBG8oG+kwCpClNSDhjir0wtbGGpL20zwyY
         6YyV64F6ezpeuQg+l0I4RVwn+Qg4EYhKumI/7ljyVp9Ixak7rDLOm843SFB+OJ+oyQst
         zNeA==
X-Gm-Message-State: AOAM530gxTovUbfIRLQC9XG91S5przqrLXQBkijnc3AyxrOQNov8w5Pc
        NuetCLBIjEop+nWtjT1WRJYgfkzD4C5ZGw==
X-Google-Smtp-Source: ABdhPJwmzxOZ2FZ2xHNI9Pz/vypVdIBdivSpRfdVnZK/nsUe4gsX+A5ej7wFMqM+zc+NAo/quUKs6A==
X-Received: by 2002:a17:90a:fa81:: with SMTP id cu1mr420108pjb.132.1614110251710;
        Tue, 23 Feb 2021 11:57:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o18sm4363395pjq.44.2021.02.23.11.57.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 11:57:31 -0800 (PST)
Message-ID: <60355e2b.1c69fb81.29eab.8c05@mx.google.com>
Date:   Tue, 23 Feb 2021 11:57:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.17-29-gff14d144bfba7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 115 runs,
 2 regressions (v5.10.17-29-gff14d144bfba7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 115 runs, 2 regressions (v5.10.17-29-gff14d1=
44bfba7)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 1          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.17-29-gff14d144bfba7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.17-29-gff14d144bfba7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ff14d144bfba7b512b84b549cbbf0167b327a90f =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/603524e04bce4e59abaddcca

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-gff14d144bfba7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-gff14d144bfba7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603524e04bce4e59abadd=
ccb
        new failure (last pass: v5.10.17-29-g17962b3a67b5) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6035278544f7ff4623addcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-gff14d144bfba7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.17-=
29-gff14d144bfba7/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6035278544f7ff4623add=
cb2
        failing since 0 day (last pass: v5.10.17-29-g1b13e2554bc40, first f=
ail: v5.10.17-29-g17962b3a67b5) =

 =20
