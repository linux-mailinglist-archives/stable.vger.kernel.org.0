Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4F13B4D8F
	for <lists+stable@lfdr.de>; Sat, 26 Jun 2021 09:59:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbhFZIB4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Jun 2021 04:01:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhFZIBz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Jun 2021 04:01:55 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BCCC061574
        for <stable@vger.kernel.org>; Sat, 26 Jun 2021 00:59:33 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id g4so6792128pjk.0
        for <stable@vger.kernel.org>; Sat, 26 Jun 2021 00:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=bmbvkxylJKpyQXX2H0+6SBugSxr3wYLdMgIq6kCWtKk=;
        b=lD/iRX8R2SfFv/omESJQqoin/wwmnt1u+EY6fPz3p1uPoMiIFQIehgMrK6VbyxeNIg
         7WgIXXgcTBBlQzEYVBk8n6gddqis3at1h6aol/F+Z+P7sebxFWEJu3bzYKST1r4r0Z2g
         K8wNYRLRf3QsV+Ih3XvQMP1SNbsHQo4nmMswjxlVWO/UuuivpXdg4TaEvPrWNEeUoB6L
         iUaDPzDDwvQkYipkih1DvJy/OPfdwxOVjpVrfagsZYXpDam9NJuFjYj7gGZ2w1jlSsec
         cP5vbjr+mUwzR2WebxcL2qethnODeo97d416I+C6Z8AD60k42rDRV2fYmSYMC77ztFpg
         +ngw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=bmbvkxylJKpyQXX2H0+6SBugSxr3wYLdMgIq6kCWtKk=;
        b=Ri5pVrnEEzh/pGjoAIcgQapYJ+XKWrm5npL3eE11vC2Fz+VpFqDC7yNiN8cI7hix5O
         +xTMivwOa0FdwA+FDRX8K1x4o0Qjho/U3vMS0nW6m+F/RDTAhmuZc0dXK/aAgy5C0D2B
         Jna6B09k+NdoUln5y/CkCwc+n3qhrl/fdtA/7VQJd16UkD4V5LJNL3dz5aj6hlwh3knH
         +D/z3o1sO1heJUipOYwk6sXwAlfzqFTwdoreHf56Ptzg94LKCjusZxopC6uT/wXtExee
         Kz4QF/5K9aREn+2EE10XNoueelK1vr0h7DErpXZH4VU+cidDi+CLZillDXkXNwOj+O07
         QHLA==
X-Gm-Message-State: AOAM532F8W/nfxlYJcitZto1xkZsYrLdsZv9aQPMCupSnWEii9dIV0Mz
        BOplmTpUyzG13XEcZJdxIN0d3m/D5B1mP6is
X-Google-Smtp-Source: ABdhPJxg8L66OtxbdZgmkSpaT3p7YP3ZiQ4SCnoUq2rbvsmRfE1UNjuY9SwELEGOmet68ba8S22OMw==
X-Received: by 2002:a17:903:304e:b029:11d:75ff:c304 with SMTP id u14-20020a170903304eb029011d75ffc304mr12543668pla.33.1624694373038;
        Sat, 26 Jun 2021 00:59:33 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y6sm7316490pgk.79.2021.06.26.00.59.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Jun 2021 00:59:32 -0700 (PDT)
Message-ID: <60d6de64.1c69fb81.b51a1.4feb@mx.google.com>
Date:   Sat, 26 Jun 2021 00:59:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.46-57-g54dbb0e69e1a
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 186 runs,
 3 regressions (v5.10.46-57-g54dbb0e69e1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 186 runs, 3 regressions (v5.10.46-57-g54dbb0=
e69e1a)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.46-57-g54dbb0e69e1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.46-57-g54dbb0e69e1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      54dbb0e69e1a0a25b3be61186745fe5b2deb026a =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/60d6adc74a4bac13f1413266

  Results:     66 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
57-g54dbb0e69e1a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.46-=
57-g54dbb0e69e1a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288=
-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/60d6adc74a4bac13f1413283
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-26T04:31:49.926879  /lava-4098899/1/../bin/lava-test-case
    2021-06-26T04:31:49.932417  <8>[   11.525033] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/60d6adc74a4bac13f1413284
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-26T04:31:50.964181  /lava-4098899/1/../bin/lava-test-case<8>[  =
 12.544480] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Ddwmmc_rockchip-sdio0-probe=
d RESULT=3Dfail>
    2021-06-26T04:31:50.964724  =

    2021-06-26T04:31:50.965174  /lava-4098899/1/../bin/lava-test-case   =


  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/60d6adc74a4bac13f141329c
        failing since 10 days (last pass: v5.10.43-44-g253317604975, first =
fail: v5.10.43-130-g87b5f83f722c)

    2021-06-26T04:31:52.387154  /lava-4098899/1/../bin/lava-test-case<8>[  =
 13.968045] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Drockchip-iodomain-grf-prob=
ed RESULT=3Dfail>
    2021-06-26T04:31:52.387588  =

    2021-06-26T04:31:52.387839  /lava-4098899/1/../bin/lava-test-case   =

 =20
