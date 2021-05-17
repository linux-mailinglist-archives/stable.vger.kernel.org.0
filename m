Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF004383DC8
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 21:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhEQTvi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 15:51:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235119AbhEQTvh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 15:51:37 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7580AC061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:50:18 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id lj11-20020a17090b344bb029015bc3073608so249954pjb.3
        for <stable@vger.kernel.org>; Mon, 17 May 2021 12:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=en/u9HW/bU3dpnXIU3WGtSTu2gFwJOXGYn1raVwq9v0=;
        b=2JVCNV5Y3PIaYa1E0+BJ3J7uxPWNTMCuIRib63nOB1j/fh/MsACqnIwtQ1iCBJv2GP
         OVUhnphHTVCCYkzHRO0QsiJShxYTdaMguNeXISwmFws7LofvTD2xi4aETyr3F89sby0J
         Q4B3YpHim3whjJsCZ26UP3kHBmYD5q30JaACbcDgzEPdkdEY4O6Oaihj5xVbL8wrkJw6
         fNVjaJNMrqiF/DtRRyWwx5ggqax7Cgxl+Z4rJkPqpCQlKqtVxXN6KI7IVxT06tfpCvUu
         avVXakrszeXYa+M+pGoEJPCoOekqup7ZKRtcU9f1H11D60QXlh1u5VB8vW0kzXTlkWcl
         KVjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=en/u9HW/bU3dpnXIU3WGtSTu2gFwJOXGYn1raVwq9v0=;
        b=t6z5fk3GNgZ/td24msO0fbLc3VT50U00sj+nm8nfoElm9T/1mpol6kfqUg/oUHSq0F
         4p+7BGvKG7jduK0FhKbafhFycLoayG5nChASokgWzBj25T2mfMjatrXJoNzSWTEYJCFD
         7Gyeno/PSfcnx6TO6l7AAqqYmPxj3Y1lwJnNPVd85OBmVRa0+bSTFbL+XkaOIvElmibs
         sAx8unstIURBYukIl1lHZ8Xn9IwQO43Mw3huWSqZJnIoOtBMd40h293uMP4moxVOgFWa
         E0fa4yQzqO0WTIELkTXYwMeS8AcO5qeQHW+TIaIapxLpXBaHe0kCoRpDAYzXAPirbthw
         xM1w==
X-Gm-Message-State: AOAM533klGrjjoIcnRBvQoM0/1FaRC1HvKzyrwOrR2NUdnTyMsHia26N
        dTs//zDPz3e2oNA9+aVI+B0qo7javmcfQb2c
X-Google-Smtp-Source: ABdhPJx4EQDKS4bHFhqxLCfAub7i2EbhUhJQ39452CIpK8RzZPOije+OAJ/RuuDQ8HGJXrsrCAinMw==
X-Received: by 2002:a17:90a:bd05:: with SMTP id y5mr1090260pjr.229.1621281017865;
        Mon, 17 May 2021 12:50:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y14sm196478pjr.51.2021.05.17.12.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 12:50:17 -0700 (PDT)
Message-ID: <60a2c8f9.1c69fb81.da5e5.10f9@mx.google.com>
Date:   Mon, 17 May 2021 12:50:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-289-gf12d611314b3
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 134 runs,
 1 regressions (v5.10.37-289-gf12d611314b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 134 runs, 1 regressions (v5.10.37-289-gf12d6=
11314b3)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-289-gf12d611314b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-289-gf12d611314b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f12d611314b3e820b7906afc99d6c97db0c79513 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a299441f91ed35adb3afa4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-gf12d611314b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-gf12d611314b3/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a299441f91ed35adb3a=
fa5
        new failure (last pass: v5.10.37-260-g2c9127d0fedb) =

 =20
