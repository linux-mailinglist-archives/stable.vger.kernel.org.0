Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 968A72046DB
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 03:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbgFWBtY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Jun 2020 21:49:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730322AbgFWBtX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Jun 2020 21:49:23 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97ED9C061573
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 18:49:22 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id x11so8427955plo.7
        for <stable@vger.kernel.org>; Mon, 22 Jun 2020 18:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ySzJB1tXiZLDs7qv0SArRhlE+fEt1l9lTDwtNJOfZVY=;
        b=Fhxu9UG5fljAQA0wz47n1pGPotqYiVy9DuVPnwzc+PilNK6poJDUxc/lU6mZawCinh
         xddrsrPWDzUStqGSdk+iqiYdCnZkvsL+D042LV4DNVqWdY4rdSJBdCjNQzi3sk0TT0RG
         XbWdM2Bz25RsHBBZ8mlCz+ffA0qVC36DmNchTLi7IaAdBd+O9t/+o29N+CxY+c5HhzdY
         EGgmcSO/ipC4H78ny8QbqLTbyN9P+9ZBfPRQbrXTvMwUOKSjzHehE6AwlPFeMkIMgJpb
         oDMWz86djzYIWsbi02NXyA/53WskBncdmf6iRt90rn3mLkzXKRb2EKqr8Wiwl8ekXzDI
         MSPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ySzJB1tXiZLDs7qv0SArRhlE+fEt1l9lTDwtNJOfZVY=;
        b=iKnrIvKj3KoY1Jl/xTuKAeB727c6k4XB5YsEIcmyO+uRorVcNfwb4FzVGUOwaG5eef
         qmWj6Jg9LtTsezgro46jNAhnaNPaJOvJHqcbXbylNg8n+UYDNTm1Id9r2g6uxSj+FWaQ
         cWU8RokjJndONodjlM+RZ4E19Z26cDwxpZ43z/HnoqJhfZM3BbiaaByVfNFHICzAfaZV
         TMwO4eHjIc1rh+l2NOZUSAmcteahosCykMejolYyDMg88mQfes9tgahr7nCUVezFK73y
         XwqRI39wrwGMqIqH83DU2Zb+zxjU2qJoUw8alFHyRBrrULodPlBXdxoRvP0kDzUwnLSu
         dmRA==
X-Gm-Message-State: AOAM531oErEtvtGfne7X/vPjsyV9M4F3+Ud62rVMqw8fZ54K6lHPdz89
        x+HOl2yrk5woFCJTG8Xf08UlnOal+7A=
X-Google-Smtp-Source: ABdhPJzmxj4WpQ19NOP0ojxHyND9zVBxg6vgaHHJQ5+5QNRin6DGSlye/m7GwQOmaLvCHh8uXXuHxw==
X-Received: by 2002:a17:902:8304:: with SMTP id bd4mr21552385plb.8.1592876961081;
        Mon, 22 Jun 2020 18:49:21 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y7sm694444pjy.21.2020.06.22.18.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2020 18:49:20 -0700 (PDT)
Message-ID: <5ef15fa0.1c69fb81.4dd71.33e4@mx.google.com>
Date:   Mon, 22 Jun 2020 18:49:20 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.44-755-g1d94fa9fbd5f
Subject: stable-rc/linux-5.4.y baseline: 60 runs,
 2 regressions (v5.4.44-755-g1d94fa9fbd5f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 60 runs, 2 regressions (v5.4.44-755-g1d94fa=
9fbd5f)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =

meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.44-755-g1d94fa9fbd5f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.44-755-g1d94fa9fbd5f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d94fa9fbd5f0a775217d4180270dae8cede3f92 =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
at91-sama5d4_xplained        | arm   | lab-baylibre | gcc-8    | sama5_defc=
onfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5ef12d5276f6f88edb97bf2d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
755-g1d94fa9fbd5f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
755-g1d94fa9fbd5f/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama=
5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5ef12d5276f6f88edb97b=
f2e
      failing since 72 days (last pass: v5.4.30-54-g6f04e8ca5355, first fai=
l: v5.4.30-81-gf163418797b9) =



platform                     | arch  | lab          | compiler | defconfig =
      | results
-----------------------------+-------+--------------+----------+-----------=
------+--------
meson-gxl-s805x-libretech-ac | arm64 | lab-baylibre | gcc-8    | defconfig =
      | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5ef12b49203e16980997bf15

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
755-g1d94fa9fbd5f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.44-=
755-g1d94fa9fbd5f/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s80=
5x-libretech-ac.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ef12b49203e169=
80997bf1a
      new failure (last pass: v5.4.44-466-ga9a8b229b188)
      2 lines =20
