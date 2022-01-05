Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2A66485A9F
	for <lists+stable@lfdr.de>; Wed,  5 Jan 2022 22:31:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244429AbiAEVbB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Jan 2022 16:31:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244426AbiAEVbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Jan 2022 16:31:00 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85257C061245
        for <stable@vger.kernel.org>; Wed,  5 Jan 2022 13:31:00 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id iy13so329929pjb.5
        for <stable@vger.kernel.org>; Wed, 05 Jan 2022 13:31:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=5K8T5gIhoZBssOB1//QXnVN8Lu5QbJ4pzxnheVsutd0=;
        b=QJ5avgQelTuxjzAJF9CmEiY0e6jvQ+jqs0H0KNXT8i8yQHGoE64NFDwCZV+H/vUTHy
         goLZPk3xFQZ6ScHpMqH5xgf+VnXkCADd9Kma8Y30Ft2nlT+l50KMmb+RR4s+rBCVokdK
         99IvlXJzZtaORqtI0os+sTbW9HqprVNkuyiE5HUk7UwbveEOyZuZXimlCiCbOKHtjtC9
         L8sYy7XCk/EdQ+21Dqlh0tGIV16kpLaE5UTRFs/2kULq/RYhaGW/e9CnsdsAvtqf8J43
         slUbpJv3bbpmjfpz1Rygv9LxdzvKx21kIm21007Zzr0vzmLRqnZ1776odbC865FWoaVi
         7Exg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=5K8T5gIhoZBssOB1//QXnVN8Lu5QbJ4pzxnheVsutd0=;
        b=jEnFQTcTFuHUO0kdbq0x+t7ydlzMAnptJVCHHB3vWNC+85fZTfvs1SnqPMaPZoly3I
         O68K8zW6vfNpIFxXyJPlzRcbJKQbX0HEuH1jAuPrjvMBNt3nhes9yDy9ac2k27umSDjp
         FXOsxKWuMn6PNtCH/ONcVN8NVVjbuoo56yTHM6hUcscBbv9ytmU4vO0cwAQayLuXke2o
         q9JGqFCUhu3l6SgtZjsGRD8EYAjvxc+eujC6pymUmOy3plByRYTomNLivC8iyMEkyBto
         4uy1x1Jd2MA8ySJrxTGM9hbel4/Anu4wCFBJhpX7igtH+d7FXyiENAGRUOHcEi6SLgKs
         t/fg==
X-Gm-Message-State: AOAM530eQ90jZF+J1q3z08uaqlpJrLCGN9mQD/3bEQ8W7wvEHlQfESdr
        xMF4g6sprXYT3FPkx3ZKDSRE2pv7P4PVwUz9
X-Google-Smtp-Source: ABdhPJxTD4Om3R3fcOJgXIl/bI+UdKXq9WucJkx+mmK46EBzJhken3GT0n1Tam8nSDnacL0e7e7q3g==
X-Received: by 2002:a17:903:1ce:b0:148:ca49:b017 with SMTP id e14-20020a17090301ce00b00148ca49b017mr55122184plh.18.1641418259810;
        Wed, 05 Jan 2022 13:30:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b14sm61190pfm.122.2022.01.05.13.30.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jan 2022 13:30:59 -0800 (PST)
Message-ID: <61d60e13.1c69fb81.2d4b9.04db@mx.google.com>
Date:   Wed, 05 Jan 2022 13:30:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-13-g1d9484cc9e1a
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 132 runs,
 2 regressions (v4.9.295-13-g1d9484cc9e1a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 132 runs, 2 regressions (v4.9.295-13-g1d9484c=
c9e1a)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.295-13-g1d9484cc9e1a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.295-13-g1d9484cc9e1a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1d9484cc9e1a4df669a3985ac43ca6818c88cfc7 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d5d9afec6a0c5e42ef675d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-g1d9484cc9e1a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-g1d9484cc9e1a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61d5d9afec6a0c5e42ef6=
75e
        new failure (last pass: v4.9.295-13-gf65af3015b1d) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61d5d8ea962da349e8ef6760

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-g1d9484cc9e1a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-1=
3-g1d9484cc9e1a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d5d8eb962da34=
9e8ef6763
        failing since 8 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-05T17:43:51.626740  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, mmcqd/0/83
    2022-01-05T17:43:51.635966  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
