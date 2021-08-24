Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D1B83F5A00
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 10:45:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235292AbhHXIqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 04:46:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235016AbhHXIqO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Aug 2021 04:46:14 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6888C061757
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:45:30 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a5so11823641plh.5
        for <stable@vger.kernel.org>; Tue, 24 Aug 2021 01:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hRhWhfrt2/JtU/mAxSgZBtJjPhuR7yEa6TSfZ9BbLjM=;
        b=tCkXSv7j44NxKbJiAWJD7lMNdWftBOXJOX5e4Ln1rFUPWLHfbZiM+kHrLZsxJ7FhZ5
         k369Be+OIaxiy46WO7EoiQcsTF5jAkxCXK5OyrCeV1w18NVKav3xzfof6NCKaE4cPpag
         qrKzgEipQMXfviRry6M0j5SXo0HIKvXfWosg31tf9s3GF7lFDaAk5vhM8jFGI+BvYoae
         sah5oOIWUDrG1fcwlZWb6D/EHf40wkYZ3w2cW96IvSaUQb1ToKId2H1EZdGEs6qt/GWS
         fJz1au/QHRY5PCuK2hZ7lqpkX94izFOqFv0i92oFScdh/nxb6i2msrZcfQ7dHQSZwTmu
         akoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hRhWhfrt2/JtU/mAxSgZBtJjPhuR7yEa6TSfZ9BbLjM=;
        b=dSpxuKNK7xT7SH2ejuzElpemZFti9KSxl4DaH+ISBi9Ar/wEmDtZ7us9lJwOJCs0/P
         kRiOg6uW+ErFlRk1TjGfPo3Ll3dceJQTWv109cnB/3wgqsen0xAiKyjVeVo/xe5yuNd4
         rqeaxyH9ROBEKcJBffxkwx9zRKMkRrfm3LZLeHJupYAkJ51Ju7NlZM6S6y4UNyFSBFXT
         wKtiv6f/lEVF7NMFYiZ8arx0JuQB6AO3NaRH3hQMngHmvYtGYbgpL5wQQ0Kp3vN6TJ4s
         +B2LqFhSQP3IDsnrUGbkH4HoyKNj7HSUWSJ310qKKBf8meY9/ZI0ICsXr5n8eGkD7Qos
         kNUQ==
X-Gm-Message-State: AOAM532+6EZ89eG6KdWKETLgwwSmT4EFQrBAfRWIubd62wfmezsjL+Xd
        gMgl5bGPSCf//yTuqet9/iV7sYpK478/mUjD
X-Google-Smtp-Source: ABdhPJzOB/yDHN0rEpykS6qshM00ejEKeJUIPmTr747IWcSWVWh4O9DyS6krJQDS4xcojk7j3V2dvw==
X-Received: by 2002:a17:90a:d314:: with SMTP id p20mr3274830pju.215.1629794730187;
        Tue, 24 Aug 2021 01:45:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g6sm17653197pfv.156.2021.08.24.01.45.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Aug 2021 01:45:29 -0700 (PDT)
Message-ID: <6124b1a9.1c69fb81.6508c.42f3@mx.google.com>
Date:   Tue, 24 Aug 2021 01:45:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.13
X-Kernelci-Kernel: v5.13.12-126-ge8b42554dff1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.13 baseline: 139 runs,
 2 regressions (v5.13.12-126-ge8b42554dff1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.13 baseline: 139 runs, 2 regressions (v5.13.12-126-ge8b42=
554dff1)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.13/ker=
nel/v5.13.12-126-ge8b42554dff1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.13
  Describe: v5.13.12-126-ge8b42554dff1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e8b42554dff165f9ed01c86b1b8f4231c9d6c4b1 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/61247e1b4f68e2f1d28e2c8c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
126-ge8b42554dff1/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
126-ge8b42554dff1/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61247e1b4f68e2f1d28e2=
c8d
        new failure (last pass: v5.13.8-31-gc1a06c46ed3d) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/6124809daf191530a58e2cad

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
126-ge8b42554dff1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.13/v5.13.12-=
126-ge8b42554dff1/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6124809daf191530a58e2=
cae
        failing since 26 days (last pass: v5.13.5-224-g078d5e3a85db, first =
fail: v5.13.5-223-g3a7649e5ffb5) =

 =20
