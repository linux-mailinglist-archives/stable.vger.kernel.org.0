Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2486A3ED7D7
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:45:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230094AbhHPNqB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229744AbhHPNqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 09:46:01 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F49FC061764
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 06:45:29 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d17so20719566plr.12
        for <stable@vger.kernel.org>; Mon, 16 Aug 2021 06:45:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2RXKTowz3qeqF7EHri+FHV/TmKBglDk9ESz3kJ1swBM=;
        b=0mSmZWlu7aeGdTUjvztHynPP7R+rbc2Na4OhMAg53w9QQcWLQfDgGI+7Wb4QPOPZN5
         5qNcIzlJGSeQ3UDjRWUVcVZiujxjv5MgOyETmueX5pUJtc+aT6EB6sm6pj/DvMYl6MAO
         snz7+/p2cOw2eRHxaj0c1OtAm4I+19DaMAoIKg/Xzf2Q2PL9bAUMgZeTXv/zYPMDVWTS
         XZK+0AvR2+zlYsjdQKzY8E03kr0zhbDW82upwZDXr99Wl9BHVwGNdoD4tQ33V/RmoNkq
         IfBYWbMiAL9nsPcvLq6SjoOX0O1HLhg0BogUOfwrZDkzHxneUQPp9FGk0kLxRUjX+SsA
         mE2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2RXKTowz3qeqF7EHri+FHV/TmKBglDk9ESz3kJ1swBM=;
        b=kmz8UkHBy/2V/g6G9XPd7LOaU89k5y7SFrtCY9Mh38FieydxALM6P/At7MfZqr0JHO
         YE+eZFBlZrPagefae2CKDf/gQQTDRLRMWki/zN7vYmOnmiyVvro0rqERvefq+GpIKC7p
         1F2uGoOhPMGgAFDwGey3bIjLB9pqaIwgRaGKe+K9ZTVJdwA51bn39DCIL4HNdC5/6pKI
         imkpQZz4WlUVVbLy784uxyiq7V5OhHk8R6A9UTpGg+3FdvY100W/kf2CvWjTymlbBIVg
         fYUv8rXq2pzCHYiGoeUmTlR8QlJnMRGwjbWdjckvsTXbLI1WqXWrtRSSLEy3RstHgzeH
         Dgwg==
X-Gm-Message-State: AOAM5312vBWbmFhcAfbJ1QctfAo/Z6z8VqhbWTnsKBTlpzrkgEPa8rDS
        AtNEFoF50T2IpN7qLeCFQ1Rha5sJ/O8faTd+
X-Google-Smtp-Source: ABdhPJwlvApd6TasNrpBaPr+oqjufNLlRVd37hb7K5fbQJklfhp+3XoXODsTyKv50N7AwYuUdUzkYg==
X-Received: by 2002:a17:902:c3cd:b029:12d:7457:9898 with SMTP id j13-20020a170902c3cdb029012d74579898mr13407587plj.14.1629121528980;
        Mon, 16 Aug 2021 06:45:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w2sm9707490pjq.5.2021.08.16.06.45.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Aug 2021 06:45:28 -0700 (PDT)
Message-ID: <611a6bf8.1c69fb81.3732a.9a4e@mx.google.com>
Date:   Mon, 16 Aug 2021 06:45:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.244-26-ga131a99d6330
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 147 runs,
 3 regressions (v4.14.244-26-ga131a99d6330)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 147 runs, 3 regressions (v4.14.244-26-ga131a=
99d6330)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.244-26-ga131a99d6330/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.244-26-ga131a99d6330
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a131a99d6330511a72573ce2586a7ac649022a6f =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
rk3288-veyron-jaq | arm  | lab-collabora | gcc-8    | multi_v7_defconfig | =
3          =


  Details:     https://kernelci.org/test/plan/id/611a3bb8e21b76bb43b13666

  Results:     63 PASS, 6 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-26-ga131a99d6330/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.244=
-26-ga131a99d6330/arm/multi_v7_defconfig/gcc-8/lab-collabora/baseline-rk328=
8-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-iodomain-grf-probed: https://kernelci.org/test=
/case/id/611a3bb8e21b76bb43b1367e
        failing since 62 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-16T10:19:17.658600  /lava-4369729/1/../bin/lava-test-case
    2021-08-16T10:19:17.676301  [   17.000622] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Drockchip-iodomain-grf-probed RESULT=3Dfail>
    2021-08-16T10:19:17.676596  /lava-4369729/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdio0-probed: https://kernelci.org/test/=
case/id/611a3bb8e21b76bb43b13697
        failing since 62 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-16T10:19:15.226839  /lava-4369729/1/../bin/lava-test-case
    2021-08-16T10:19:15.244562  [   14.568426] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdio0-probed RESULT=3Dfail>
    2021-08-16T10:19:15.244840  /lava-4369729/1/../bin/lava-test-case   =


  * baseline.bootrr.dwmmc_rockchip-sdmmc-probed: https://kernelci.org/test/=
case/id/611a3bb8e21b76bb43b13698
        failing since 62 days (last pass: v4.14.236-20-gdb14655bb4bf, first=
 fail: v4.14.236-49-gfd4c319f2583)

    2021-08-16T10:19:14.208178  /lava-4369729/1/../bin/lava-test-case
    2021-08-16T10:19:14.213976  [   13.549632] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Ddwmmc_rockchip-sdmmc-probed RESULT=3Dfail>   =

 =20
