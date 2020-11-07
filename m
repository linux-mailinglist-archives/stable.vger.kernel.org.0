Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 995672AA7E7
	for <lists+stable@lfdr.de>; Sat,  7 Nov 2020 21:29:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725838AbgKGU3b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Nov 2020 15:29:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725836AbgKGU3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Nov 2020 15:29:31 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB732C0613CF
        for <stable@vger.kernel.org>; Sat,  7 Nov 2020 12:29:29 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id u2so2580930pls.10
        for <stable@vger.kernel.org>; Sat, 07 Nov 2020 12:29:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KgKWupJ+/kRfkc1Z3MP8zVAkmA22pGE1kJmTYZxwfRs=;
        b=Rt+mhIArtGGRqC+eWt9Uin7gy7nspF9x1QSMc1fOARHKMbiTsj5YiM16sgPUgeJ0JT
         Zm9bZY+7g1qt2it7y/Y8H2NxEhN02lPn2lXadQo7b7iU2b6VDWbNVf9CskDv57fbh6Aw
         +srGpsUw6xzW8Es9DVCBz4ZB421o44zQaySKuZlUm6S8fihs0CeGuIIbYNbIMiYTkpqi
         U52g89v4ASQiWS+hYUZAlMqPMp3i7q0bhdeB1b3dI+WLPbewfrGx5uCuhIHLySnVnFmf
         KV1s68bVUkgBboeDNfh9Fy2/OYKsFEle8dmVrxT+Jmn6j+lk819tGeY8WEwBIuZOviSK
         xBtw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KgKWupJ+/kRfkc1Z3MP8zVAkmA22pGE1kJmTYZxwfRs=;
        b=EiZ/Rir0HQH/NJ3hu77hjq0iBoXVGJE2n0ci4fGyHkfWHGckyx/JZZyLEoACh8QX9y
         GEaVscDpyfWek8Cx8QOZoA3dgkfY+59Gm27G8Bi8XEoZUk4pH8Z4+w7GUdXzu+MPPLIK
         P/GgvTOz/KCt+uKpOP9FOHl5isad0Dw/Fo4YVF1UqHxBJ6/3hltkw/n04zgL93FMajan
         OxmYLg3oAqfWeFSKV3wHPD5CHar/QV3OjfNwe9b5QOhAUV4WplSBYbzciGH9YWh210cu
         USkYU2cb9sSNnHG6JDiLT7rN2kjlx8TdQw6E7eXJbC1aHNWg5epmjcJOfpFBNdGjn91t
         Ez0w==
X-Gm-Message-State: AOAM532JuDLe9n2DCNWbq3SYS7I7D4xYgZ1y4Slj2E4WYjm07Q/gu39p
        jhEurlN8bDjimIppj0bZi8t2LwEpBnGRSQ==
X-Google-Smtp-Source: ABdhPJwectiIwFy2qRwSeLwImNhhr5lGX3BkuQZWkbAYpIZHF2UAMMJOvG9/FASM2MfYb7b9DF4mOA==
X-Received: by 2002:a17:90a:4a95:: with SMTP id f21mr4953262pjh.223.1604780969010;
        Sat, 07 Nov 2020 12:29:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z13sm5879632pgc.44.2020.11.07.12.29.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2020 12:29:28 -0800 (PST)
Message-ID: <5fa703a8.1c69fb81.b3709.b197@mx.google.com>
Date:   Sat, 07 Nov 2020 12:29:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.204-21-gd9024a032a65
Subject: stable-rc/queue/4.14 baseline: 167 runs,
 2 regressions (v4.14.204-21-gd9024a032a65)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 167 runs, 2 regressions (v4.14.204-21-gd9024=
a032a65)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =

fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.204-21-gd9024a032a65/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.204-21-gd9024a032a65
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d9024a032a65972abce966f3b0ce662b52b5e70f =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
beagle-xm       | arm   | lab-baylibre | gcc-8    | multi_v7_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa6d2c5fad46bab48db8863

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-21-gd9024a032a65/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-21-gd9024a032a65/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6d2c5fad46bab48db8=
864
        new failure (last pass: v4.14.204-3-g76531a443c09) =

 =



platform        | arch  | lab          | compiler | defconfig          | re=
gressions
----------------+-------+--------------+----------+--------------------+---=
---------
fsl-ls2088a-rdb | arm64 | lab-nxp      | gcc-8    | defconfig          | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/5fa6d3447a4fa0caf5db8865

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-21-gd9024a032a65/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.204=
-21-gd9024a032a65/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa6d3447a4fa0caf5db8=
866
        new failure (last pass: v4.14.204-3-g76531a443c09) =

 =20
