Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43A253DE6A5
	for <lists+stable@lfdr.de>; Tue,  3 Aug 2021 08:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231386AbhHCG0g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Aug 2021 02:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbhHCG0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Aug 2021 02:26:36 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0838C06175F
        for <stable@vger.kernel.org>; Mon,  2 Aug 2021 23:26:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id a8so5370050pjk.4
        for <stable@vger.kernel.org>; Mon, 02 Aug 2021 23:26:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vUNXxSPezUQMws1FKkqi/Tez97ONZPx+OsmSDRwfDSY=;
        b=DNPwCuf5qw3u4leeTkeEGHVHXLXPAsp2gvOhyljTSyEliZQcikD8D3NTZkIdkA9aaj
         CrjI29znfClBFRXEHfbe/MiS6Ix3Nw4YcM9gn1+IEeImwayn2VNIWcs5KLOJGvQq/oqV
         lydxrx4O+UafbSFvBTRpYvRKZ8wT34KvBlxiprGLRdoM4mLlnbF4lwv+3/qOmU3wwgBG
         9+CF6MUSjJwsnCtOrEpK2dvnED8yIamDfDOGUFvMLpdUyel8ArfV9qqLDscQncdyK/1u
         xw2RJw6YmwVFo/T/nTAor80oVYZgqMkGNDmyz0aRreelzGAqr5CSC5i15UVraBYBnzs3
         mZmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vUNXxSPezUQMws1FKkqi/Tez97ONZPx+OsmSDRwfDSY=;
        b=N51nWrNrKaooR1q2tCHFfVW82SEWeBaGBRK7kVSWNpS43nLeRGFjrzs5bbuyOR0iPG
         LtGuWOkit11Euv8VJrqzYn5flJvR3Q0PLs5XSiKni+foTL4qtCExD8/UKDtvMY3iCbck
         CZkl4CCmpNsQlP+1J109jwRdxUeqr+IujFvhk/6RUi5ilgJjZFZiJdOUF+OtK04iRv6k
         q/oroV5++z5stm5+ORawXW8x1M4d+vuPEahWId/S+qJLqw0sN6tRno7Rsv1q2ZzmG5MB
         hYGZI3CQhRTD+U8deZcPtSxEOYnoIbQVyi+Zp/Gcq8pDu5/uk5/yWGSZXYnRT3GJ6FSS
         7twQ==
X-Gm-Message-State: AOAM532j6bGTFGra3X3eVcDUL/OZvSjoAVxWrg5U1GC2p/U7W7OQLsB8
        XJBkGrYTWOITLGTDg0A9ExktPujJiPy7Ag==
X-Google-Smtp-Source: ABdhPJwCqJJjZR/PCiphMAXcDcY9V4ew1XwQbLT+MwSwcNJ5+zfcEs28NmR5uxyUjMhIUs6zWQwExw==
X-Received: by 2002:a17:90a:2ec3:: with SMTP id h3mr21212932pjs.125.1627971985287;
        Mon, 02 Aug 2021 23:26:25 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d2sm1518598pjd.24.2021.08.02.23.26.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 23:26:24 -0700 (PDT)
Message-ID: <6108e190.1c69fb81.1c02a.59c7@mx.google.com>
Date:   Mon, 02 Aug 2021 23:26:24 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.137-44-g01895863f82a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 174 runs,
 3 regressions (v5.4.137-44-g01895863f82a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 174 runs, 3 regressions (v5.4.137-44-g0189586=
3f82a)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.137-44-g01895863f82a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.137-44-g01895863f82a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      01895863f82a15f7962b9d6f2f8e0e2f0566c44e =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/6108d4fcb9e8458cdbb13661

  Results:     67 PASS, 3 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
4-g01895863f82a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.137-4=
4-g01895863f82a/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk3288-=
veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/6108d4fcb9e8458cdbb13679
        failing since 49 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-03T05:32:28.265143  /lava-4314354/1/../bin/lava-test-case
    2021-08-03T05:32:28.282277  <8>[   15.172429] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/6108d4fcb9e8458cdbb13690
        failing since 49 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-03T05:32:26.839875  /lava-4314354/1/../bin/lava-test-case
    2021-08-03T05:32:26.857784  <8>[   13.747463] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/6108d4fcb9e8458cdbb13691
        failing since 49 days (last pass: v5.4.125-37-g7cda316475cf, first =
fail: v5.4.125-84-g411d62eda127)

    2021-08-03T05:32:25.820812  /lava-4314354/1/../bin/lava-test-case
    2021-08-03T05:32:25.826313  <8>[   12.727910] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
