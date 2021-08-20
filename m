Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 533553F24C5
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 04:31:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237504AbhHTCcQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Aug 2021 22:32:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237269AbhHTCcP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Aug 2021 22:32:15 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B9AC061575
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 19:31:38 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id 17so7742527pgp.4
        for <stable@vger.kernel.org>; Thu, 19 Aug 2021 19:31:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=L0JV+MArdGUJzcKkq/Y9l6stVd6QhyHKIMERUTvohZo=;
        b=AC+m/0z3kbgUIFJuUSQQId7e5Fb4eccIkBgOoFugAvWDKr3xh6ooODVG5FR+vUmw3f
         MFJVp2g8XhsbL7lZlNfNf4LT5cNquo4NpXPi5N1yktc+o0GvQVASjfApg0baCpoMea66
         J9z9yskhIBiwZ/cujJgyuZJAGDfKFowJJwXYhT4Xh6i7Fw9OF2zGHo9M4iQ4+GBP340D
         VD6Ddh3l9SSMAKDFeza7OqLQRAv/HzIp/gE0ZXfK+eJnIw2V0MJ8g3yCttyRF/Ur4shF
         LnzJq9EqF05LT6l9lOJJKhSEyp90tQxw6cG0vRFM4yOySA9m8hStmL518ecTSaa/hrfR
         dIGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=L0JV+MArdGUJzcKkq/Y9l6stVd6QhyHKIMERUTvohZo=;
        b=GF6QiesxYYQr9qaEl+hKpQk5fq4mtVvNeNFzSYOH6Ob20z6vkrjtbdttOOKgmjg5q1
         iwqQXUeW/xqJ1hPULnvbrRRTB7g1IqZwZnUIF3oiKqAiPAyYA8W1NapDIAPfnJHZ0Fnu
         SJk8+Oj1IzEAPCf5asyFtTELE3HbSFlg+t/y8TfZs1rj9hMn30ZCnTHcXCe/y9Kc6Cbt
         r1o3SeYisgfracas6TBVpKKFRLA0zaD91oL1CombEcJ8UgKwLV7eq8S6uEgopvf3qpyp
         0gbpPDYRoVzgTyeBuyI5CDLHOEQeAE7w6V3IkmS29318mJJvMNZOuljA9SjtvULwJcNT
         Wjtg==
X-Gm-Message-State: AOAM530iAEvzgsuoRpTAgoBVdrGbqyBB6hL97lMyRodh8hnKKuFAvqcN
        tcoSZcNNmlO82BE8OXD1bIxKHechgvKjEZLj
X-Google-Smtp-Source: ABdhPJz4SF1rx9RaiZcQXkMR2bwUCGc1v0JfAGU1Jv9qlUq88wrn760k4WGY7s37Wa75fdox9Gu21w==
X-Received: by 2002:a05:6a00:8c1:b029:3a3:b86a:302f with SMTP id s1-20020a056a0008c1b02903a3b86a302fmr17693294pfu.31.1629426698098;
        Thu, 19 Aug 2021 19:31:38 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl9sm9876236pjb.33.2021.08.19.19.31.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Aug 2021 19:31:37 -0700 (PDT)
Message-ID: <611f1409.1c69fb81.f6416.def7@mx.google.com>
Date:   Thu, 19 Aug 2021 19:31:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.244-46-geb5185438efc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 148 runs,
 3 regressions (v4.14.244-46-geb5185438efc)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 148 runs, 3 regressions (v4.14.244-46-geb518=
5438efc)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-46-geb5185438efc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-46-geb5185438efc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eb5185438efc0804c553e6dc959f2b965e132cb7 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611ee580895a052482b13666

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-46-geb5185438efc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-46-geb5185438efc/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611ee580895a052482b1367e
        failing since 65 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611ee580895a052482b13697
        failing since 65 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583) =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611ee580895a052482b136ae
        failing since 65 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-19T23:12:51.663875  /lava-4389229/1/../bin/lava-test-case[   13=
.072810] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed R=
ESULT=3Dfail>
    2021-08-19T23:12:51.664292  =

    2021-08-19T23:12:52.677388  /lava-4389229/1/../bin/lava-test-case
    2021-08-19T23:12:52.694616  [   14.091632] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-19T23:12:52.695107  /lava-4389229/1/../bin/lava-test-case   =

 =20
