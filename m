Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B1A316EB0
	for <lists+stable@lfdr.de>; Wed, 10 Feb 2021 19:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbhBJSa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 13:30:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234282AbhBJS2l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 13:28:41 -0500
Received: from mail-pg1-x52e.google.com (mail-pg1-x52e.google.com [IPv6:2607:f8b0:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD368C061574
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:19:41 -0800 (PST)
Received: by mail-pg1-x52e.google.com with SMTP id t25so1775393pga.2
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 10:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ffl15TAjUV9Cbtdf6fgDnryAnBWt23/uud6xN6aIY+g=;
        b=Rt+Di7S15yXuFW4D67eFof+9iDvr9318RpZKrT5SJCZDYqjZ4MVPSqDsi8rlCNqZGY
         prl25t64RtjbgDVesbbAXmjq/h+CrG41aIvitu+6s7nEtlDPoVLKiSWY6uwjVvDrC9i0
         GQWwEbvdNHqCz9bgTvkiyWWPx10lvtZnOiKdOGPAbVsCwsb/kgnZ711qNninnQX9nueF
         D5P1GAIWFNoNRn90tvdhejei5nh162xB3SVTVwgV9JjWIhBL2PijJuiFNYroBIxHvLmZ
         R/gAgTVkbUoetDDim48aajJezvL8ce7IkU6eqZU48nKQ53EAiIeH/C3rqvcKlqJsjGul
         lDtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ffl15TAjUV9Cbtdf6fgDnryAnBWt23/uud6xN6aIY+g=;
        b=mW2+SVfs+RbisP1+4dKxWlgAkeb1p8Hi6TVvteg/yQtU6fY0rf5cr+p8pkNBGrFxxX
         BTYiFLeaaPqBBp6VIzcaFrlFXBbXQNyobLnPGihey+VxxtLuL67/zv0IsgLgM1NAaNUy
         9SK923+sdnYt4FGy4BdqPe61AkbWpWSi5lpjWwiUB/YVlnUiKyzgHXEo2CiCpfQc3iFO
         L7sw5q3N59rD5+HkHZTjzoYX2wAtSfQwaa3SMqwlLcbShCgsQxUq+fAeySOFlsIroNxi
         NssCr31gwIIFKVgDwP2VqGKDaVRHouL0r5xGHDhtTpfjp6hBUekJRdSvlKF6W4j4CTNw
         ACNg==
X-Gm-Message-State: AOAM530/ikVx9L3xj+0nd7/xEd9+UIhxKosvx8ZnPPw9NtFSoSUanzi7
        8C7QBw23EYpQbI0y7rO8AIIYkiMC7Wcn8w==
X-Google-Smtp-Source: ABdhPJy3mpnhzfB/7iond3jzQRwtDhumsMk6QHVSEE6pY/6uLxxt+HCOBoUh9Lp++lKD34jeKvg3Ag==
X-Received: by 2002:a63:d257:: with SMTP id t23mr4345368pgi.290.1612981181066;
        Wed, 10 Feb 2021 10:19:41 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b7sm129079pfp.139.2021.02.10.10.19.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 10:19:40 -0800 (PST)
Message-ID: <602423bc.1c69fb81.ac520.0649@mx.google.com>
Date:   Wed, 10 Feb 2021 10:19:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.14-120-g38499a55523e
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 108 runs,
 1 regressions (v5.10.14-120-g38499a55523e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 108 runs, 1 regressions (v5.10.14-120-g38499=
a55523e)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.14-120-g38499a55523e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.14-120-g38499a55523e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38499a55523ea06991865ad1daf9a80d39683e40 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6023f26f58ae26411a3abe6c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
120-g38499a55523e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.14-=
120-g38499a55523e/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6023f26f58ae26411a3ab=
e6d
        failing since 2 days (last pass: v5.10.13-57-gadb6856092da6, first =
fail: v5.10.14-4-g5bf21c370d20) =

 =20
