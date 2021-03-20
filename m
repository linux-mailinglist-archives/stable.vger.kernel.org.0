Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62A5E3429AE
	for <lists+stable@lfdr.de>; Sat, 20 Mar 2021 02:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229564AbhCTBo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 21:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhCTBob (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 21:44:31 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E349C061760
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 18:44:31 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id g10so3743312plt.8
        for <stable@vger.kernel.org>; Fri, 19 Mar 2021 18:44:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fD/KXyEohygTW/zDwogPuNwAKQtxV6OWPJSIpBsReUU=;
        b=vbsh6QpTPhhVOAHZDX9Bv61Esfu31S0/5j/XWcc1mQFRUjWUeXzE1THEUzQ6jaqwDw
         umuQ4crbW5dmQkweOTcXG+1CcOWzoDne/WYchej4j1N29iK1TWmTUIJv8Sc0y63oRq6G
         GqYH2AlSzgq77VawVQHQhfqFXTBorOUWaV6BWdU6nEbS0rofYNa7bsOsEexpi9Ur40sL
         GHwDY05H4q0sWAF+yzRzuU/KJ3ecA6auXWppDkYt+bGoK/7tML3tNy8vhTSjtj29+upJ
         J684/qOKRfVhR9JMLzHlaBThDT+7Yfrk7xStLq6yQ5JKfNyuyw71y0d7YpD2xkyZslGk
         Dfpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fD/KXyEohygTW/zDwogPuNwAKQtxV6OWPJSIpBsReUU=;
        b=GwfDEo20pIC7wgtx6XmFEKOmBlLaSH7BLOdZC+8GigbQhoubRqJ87Hu68xcY7pRwDB
         +M1yaW2YjBsTeOibys/RvKLTm3vmg7Qt5iG3VS+x+cy1wAMMb3j4lEaV3BzBjgPsS/v+
         sT7YAKNrm42k/9pc4T7b6wZndXHPfDB+FxIXR7QY29EbkopKY5sjqOKSY0xN2nlxmHSk
         PSWAPzrcEYcuMDSoky2XUrILysF6HXJ2TE90/ggsWH0wFiBGWccxWq075pDYXdHhOdB8
         J4+mDCprkj7E/aIQzyCGlMBvL0oNTcR+bYz3+B91syVHDUxWriqjTObX81OGh2rWXQE3
         uyAw==
X-Gm-Message-State: AOAM532ze/GHCe0ad8G9hpAhoKHyVIaVtVLbtjq4bfITAWJdGNAWq91d
        uDa6R9eTkRZ/gmsbW+F4OxLfG+V3Ldh8Ww==
X-Google-Smtp-Source: ABdhPJxuyqtOV6jw3P01Q5rz2tmLfN2X3wK/BoCOcgFqefLgFxtQkYrUTd41C96InmIKtXqzV6eMLA==
X-Received: by 2002:a17:902:e54c:b029:e5:e7cf:d746 with SMTP id n12-20020a170902e54cb02900e5e7cfd746mr17011297plf.56.1616204670572;
        Fri, 19 Mar 2021 18:44:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v27sm6600789pfi.89.2021.03.19.18.44.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 18:44:30 -0700 (PDT)
Message-ID: <6055537e.1c69fb81.44818.0f55@mx.google.com>
Date:   Fri, 19 Mar 2021 18:44:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.24-14-gb05da84e91a81
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 178 runs,
 1 regressions (v5.10.24-14-gb05da84e91a81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 178 runs, 1 regressions (v5.10.24-14-gb05d=
a84e91a81)

Regressions Summary
-------------------

platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.24-14-gb05da84e91a81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.24-14-gb05da84e91a81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b05da84e91a81ee89c814d51c18cc6f5b077256a =



Test Regressions
---------------- =



platform           | arch | lab             | compiler | defconfig         =
  | regressions
-------------------+------+-----------------+----------+-------------------=
--+------------
imx6ul-pico-hobbit | arm  | lab-pengutronix | gcc-8    | imx_v6_v7_defconfi=
g | 1          =


  Details:     https://kernelci.org/test/plan/id/60551b49e36248336faddcbe

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
4-14-gb05da84e91a81/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
4-14-gb05da84e91a81/arm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-=
imx6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60551b49e36248336fadd=
cbf
        new failure (last pass: v5.10.24) =

 =20
