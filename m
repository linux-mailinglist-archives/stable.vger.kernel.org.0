Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA9D4387BF
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 11:02:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230211AbhJXJEN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 05:04:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230348AbhJXJEM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 05:04:12 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 147F3C061764
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 02:01:52 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id gn3so6003846pjb.0
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 02:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FLcMVcKkgMkiBSG+3oVFa5wwrABBuZxAabkl0MdZuBM=;
        b=CfA0i7bnPRtJVnnUBNrsgPs4EfWGGhPUyUbprfwTF6tFlJCfw9hbu/I2/n5ttX0FIr
         LHp+wunAAWm73orx1YROPvrvXHVIJ9x3SbaxUpWi0f87qide/If8oSJtI79Sch8blPNH
         34gRnumAxPHOPDOGEgDR5sv+yPTKsqqUNf1JKF8X4Z+nmzGumqcmth3QlbCghVLIXt0c
         oeJ8NKY1SH2Kc4dAX134WWvpa8WDShWKHsJs8c0MPXJI8STpuXW0n+qZpVzhVMTKEI2M
         RloNnxkv/mX8eiiiJVLvzldfPeDev7Ju5a3dsxQouor2jX0JPIwZqLGKGjYIQnXFUTpT
         rniQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FLcMVcKkgMkiBSG+3oVFa5wwrABBuZxAabkl0MdZuBM=;
        b=dnqdt0QnlyEP3TPwopJAe+0pqgE8iZWrHtHBBxKI1Uu5VzuIJ79bG/tgQBdNjw6ubO
         VD7ZcdktiVxE4GPsXbxc0YoO4/YO/+mEA1nAWIfzCDAlLJ4019kwofN5TRPsP7EgirMu
         Lq/W4iqdxrKs4DbtQ3V1s6An2boi1CJKV7qF21DdvEx7H8ChcyuGRCcJqTLJRVldTJ/+
         uVrxCwjVxIMvNxaRt1IieiwhJQRq/YoGs3fBTgZQVBzs4zApkZr8HItaiFcBu1iEuGRl
         VjyhHRFMzal77O/QtgHNdnZxUKpASRZyukgrIBZ5bQGwjg8tkRJSwuwTM9n87d9cbjQq
         tK/A==
X-Gm-Message-State: AOAM533P+edgS58o2nvmzFIiwqJbg2a0QtmJgq8Q/7/kFrm4Lkyh1X+y
        C1b0SYrND0+ESmnLH0+I8jSqKEgXHepdsFqw
X-Google-Smtp-Source: ABdhPJwyQ9/MtehLzWzCIl4G4aO9UnpDwH/Mhc/EJUIB8IF3NkachmRw3pFxCBu9D7Js6CTU8nOqAw==
X-Received: by 2002:a17:902:900c:b0:13f:974c:19b0 with SMTP id a12-20020a170902900c00b0013f974c19b0mr10096998plp.12.1635066111415;
        Sun, 24 Oct 2021 02:01:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g11sm13128751pgn.41.2021.10.24.02.01.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 02:01:51 -0700 (PDT)
Message-ID: <617520ff.1c69fb81.f8bfa.317d@mx.google.com>
Date:   Sun, 24 Oct 2021 02:01:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.14-64-gb66eb77f69e4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 182 runs,
 2 regressions (v5.14.14-64-gb66eb77f69e4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 182 runs, 2 regressions (v5.14.14-64-gb66eb7=
7f69e4)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.14-64-gb66eb77f69e4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.14-64-gb66eb77f69e4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b66eb77f69e4b6e914994be7ef99796384eda05d =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61751c309130d792e73358de

  Results:     69 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
64-gb66eb77f69e4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
64-gb66eb77f69e4/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.cros-ec-keyb-probed: https://kernelci.org/test/case/id/=
61751c309130d792e733591e
        new failure (last pass: v5.14.14-17-g270817aa4bf4)

    2021-10-24T08:41:01.050773  /lava-4818397/1/../bin/lava-test-case
    2021-10-24T08:41:01.066541  <8>[   10.659220] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dcros-ec-keyb-probed RESULT=3Dfail>   =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/6174f10daf2eb8030b3358e6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
64-gb66eb77f69e4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.14-=
64-gb66eb77f69e4/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-bana=
napi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6174f10daf2eb8030b335=
8e7
        new failure (last pass: v5.14.14-17-g270817aa4bf4) =

 =20
