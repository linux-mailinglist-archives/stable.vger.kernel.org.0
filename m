Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18DA82A8D47
	for <lists+stable@lfdr.de>; Fri,  6 Nov 2020 03:59:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725848AbgKFC7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Nov 2020 21:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgKFC7t (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Nov 2020 21:59:49 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80407C0613CF
        for <stable@vger.kernel.org>; Thu,  5 Nov 2020 18:59:48 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id v12so2970320pfm.13
        for <stable@vger.kernel.org>; Thu, 05 Nov 2020 18:59:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KdOmy0wpZzWMq9N9uYI8TkqvsEVVxD6bb+wTsDP2tCA=;
        b=nLQfjoFYCtif8Tl1K8XxZLchUs1hciUZuF2ZA2W8ZVio4fBLYGduLLicIRm5vyJrYl
         m4m4mSrpjBukmKaZr++trzF9sEXi2J84MEVl9LBw+DY5ZEd2pSemFMrFCvKQQCeMuShM
         FmnQ410ghkm6oKieMuZEldvMr2g6UCFWpJZEJ5ug5GFS/JTBLhaxgZmF5DEV8YFf/dci
         L6awmGhdufVi+ypi7v4SB1RFNq9ZKBbD/ATO9byXdfXqTB7yBgw11LUhDMBTl7w4FblN
         WvfBUsdqVvCIFM/ZL8JirMt4aOyKwJhDFCVZMe5jAFybQ7bl1Bm2e69Xu8yttpGzd+0f
         mKKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KdOmy0wpZzWMq9N9uYI8TkqvsEVVxD6bb+wTsDP2tCA=;
        b=D+wF2BpYYNH5mR2+Qz9I7YOI/rhodVTUUCzy2uDQE0ZtZhZ6ie5bTm+qKPaIgN21aG
         m+ZYYcxmPWGykTKqgTIkTYY36rQXO0bCe3See8YaHVy1yDvTe3MjfJJjQRI03J5CRRUK
         zIYrTMPP7d7d0PcQHXrenHTJjAutmZFVxvigrglu1vDi5wZeT6oUoVron1b5UJuZ2Qqd
         hMjPFUZVfCf7fjpRpU8o9xXxsJjXm/NJK+zu11XnhSYzgcCcicsCgZIIItZRfME5UDEl
         KpTOV+Xgoi8Wqj9leQDjDJI5+Rc48I7hWHCanrzwEIpGr1HZCiZ1Uh8FchUyPSXTlV3R
         jv7A==
X-Gm-Message-State: AOAM5328xp0JeLqMWibfra13k4hnhsdI7pKIE+I1toavRmm9IC9akXsY
        +vcLpbIQw7GOilgcE+DOjgkHV/8qQqbjzQ==
X-Google-Smtp-Source: ABdhPJzwMlXi8mwy3VbsbSdRrLscXDSCxEpcvdO1//U18LevEIZRuU+YtP12R79iAd7VLOtuUvHujg==
X-Received: by 2002:a17:90a:6284:: with SMTP id d4mr55331pjj.92.1604631587517;
        Thu, 05 Nov 2020 18:59:47 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm22955pjr.22.2020.11.05.18.59.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 18:59:46 -0800 (PST)
Message-ID: <5fa4bc22.1c69fb81.f9b4a.00fd@mx.google.com>
Date:   Thu, 05 Nov 2020 18:59:46 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
X-Kernelci-Kernel: v4.9.241-92-g81e6f07cbc39
Subject: stable-rc/queue/4.9 baseline: 142 runs,
 2 regressions (v4.9.241-92-g81e6f07cbc39)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 142 runs, 2 regressions (v4.9.241-92-g81e6f07=
cbc39)

Regressions Summary
-------------------

platform                   | arch | lab             | compiler | defconfig =
         | regressions
---------------------------+------+-----------------+----------+-----------=
---------+------------
at91-sama5d4_xplained      | arm  | lab-baylibre    | gcc-8    | sama5_defc=
onfig    | 1          =

imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.241-92-g81e6f07cbc39/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.241-92-g81e6f07cbc39
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      81e6f07cbc39a0c88eaab589fcd3d1596a1e6181 =



Test Regressions
---------------- =



platform                   | arch | lab             | compiler | defconfig =
         | regressions
---------------------------+------+-----------------+----------+-----------=
---------+------------
at91-sama5d4_xplained      | arm  | lab-baylibre    | gcc-8    | sama5_defc=
onfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa489c56c60c967b0db885f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
2-g81e6f07cbc39/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
2-g81e6f07cbc39/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa489c56c60c967b0db8=
860
        failing since 7 days (last pass: v4.9.240-139-gd719c4ad8056, first =
fail: v4.9.240-139-g65bd9a74252c) =

 =



platform                   | arch | lab             | compiler | defconfig =
         | regressions
---------------------------+------+-----------------+----------+-----------=
---------+------------
imx27-phytec-phycard-s-rdk | arm  | lab-pengutronix | gcc-8    | multi_v5_d=
efconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fa489aa59df511b8fdb8853

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
2-g81e6f07cbc39/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.241-9=
2-g81e6f07cbc39/arm/multi_v5_defconfig/gcc-8/lab-pengutronix/baseline-imx27=
-phytec-phycard-s-rdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa489aa59df511b8fdb8=
854
        new failure (last pass: v4.9.241-91-gd58d4144209f) =

 =20
