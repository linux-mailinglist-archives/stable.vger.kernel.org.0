Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB641B2CB
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 17:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241350AbhI1PT3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 11:19:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241514AbhI1PT2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Sep 2021 11:19:28 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0642C061746
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:17:48 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id om12-20020a17090b3a8c00b0019eff43daf5so3078533pjb.4
        for <stable@vger.kernel.org>; Tue, 28 Sep 2021 08:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TBo/CWiTRP50bR8mgMCHtpMm1qAK05wI2LYdGiiQyiA=;
        b=MkmLViTG3KenwPBCni9cQRvBwHWuGXsQBltq4TQxcCeknYhIsHXJp7P9JhCK9Dsgxr
         ywjH/GVoYrmDbbfOHA0gSlxKpfuxJE0Slf+VStZ/26P/Nl4Vnlydc3CWl2NqnloEWJ7V
         pGJ3UY6XAYPyH0F2FRqGal3UzOBBhqyDt9gNEo+CgCHRojq1cdbHOHe0WWwS8P9MPEle
         8sBgcgxnqLLAU7Myp33aOmdNqVY9wI4TVn3FbOMzKdflNGsHlVyO+UiUiVihVtx6S9U7
         J6YWVtHg6LFXLSPvvetTEq9POJZpM7lSdqT+ymqnB0Ueltbj81ebtZlHaN8Bs0jKr4xt
         Fb+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TBo/CWiTRP50bR8mgMCHtpMm1qAK05wI2LYdGiiQyiA=;
        b=kVsHDqTPZoRFOwTJmKMHhsqt9WSDJLKgQOqLmzuO3KmII/beW4KRWqzGcRrl2MmBTt
         Bapp8GnpfzdjrhUlSr4ENcm/IEuHzv2StiCzrUWb8dX49KDyM7wmOAGiwVJOv+4ulOUb
         Sv22sxfv26XLOvXrVxuaJe09+GFhMh/2RwPsWnRd3atiwDCY7pJwtHmBsyh0QiDpLmuQ
         iInydepOf/dJPoPvWwYgu3pqnYJT9XkJ6Bt1BA7GSo3ynk8d6QmZwWfaY2FSUFvd2t9o
         Ggs6Hac7cABDt5zEsUJ3JOxcv9RNS6FT1oWSb982SJjLitKiVOQS4+A+3V/pzf8bOGAA
         vWKA==
X-Gm-Message-State: AOAM531CmP1mWEnRslYUFNJx4RFaWSbBBRLpDOlbVgQA2qMXmsl2t9wM
        1xDtpUZacv87evYBMkfyGtvvWbM/KYDuY2BD
X-Google-Smtp-Source: ABdhPJyc9xuoF7jqCLSkR8hfqvrTXMTf6Or/rimmXcZ51mi+HCdZIuCYbx8AVjm9sAW8jIw7U78chw==
X-Received: by 2002:a17:903:187:b0:13d:fd13:8862 with SMTP id z7-20020a170903018700b0013dfd138862mr5232680plg.85.1632842268046;
        Tue, 28 Sep 2021 08:17:48 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j3sm21595188pgn.12.2021.09.28.08.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Sep 2021 08:17:47 -0700 (PDT)
Message-ID: <6153321b.1c69fb81.4b5c0.5981@mx.google.com>
Date:   Tue, 28 Sep 2021 08:17:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.69-103-g9583b61453b7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
Subject: stable-rc/linux-5.10.y baseline: 120 runs,
 3 regressions (v5.10.69-103-g9583b61453b7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 120 runs, 3 regressions (v5.10.69-103-g958=
3b61453b7)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.69-103-g9583b61453b7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.69-103-g9583b61453b7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9583b61453b7d7bd52b2b593858583715f37f254 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6153117fb744d149e599a2f9

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
9-103-g9583b61453b7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.6=
9-103-g9583b61453b7/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6153117fb744d149e599a30d
        failing since 105 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-28T12:58:22.167360  /lava-4593265/1/../bin/lava-test-case<8>[  =
 14.222957] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-09-28T12:58:22.167843  =

    2021-09-28T12:58:22.168224  /lava-4593265/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6153117fb744d149e599a324
        failing since 105 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-28T12:58:20.744263  /lava-4593265/1/../bin/lava-test-case<8>[  =
 12.799252] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-09-28T12:58:20.744772  =

    2021-09-28T12:58:20.745187  /lava-4593265/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6153117fb744d149e599a325
        failing since 105 days (last pass: v5.10.43, first fail: v5.10.43-1=
31-g3f05ff8b3370)

    2021-09-28T12:58:19.707014  /lava-4593265/1/../bin/lava-test-case
    2021-09-28T12:58:19.712675  <8>[   11.779825] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
