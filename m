Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55012438752
	for <lists+stable@lfdr.de>; Sun, 24 Oct 2021 10:23:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhJXIZi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Oct 2021 04:25:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhJXIZh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 24 Oct 2021 04:25:37 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64995C061764
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 01:23:17 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id e10so5781209plh.8
        for <stable@vger.kernel.org>; Sun, 24 Oct 2021 01:23:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O2nZLcUS7NyaUZEKd2KKj/OHp1nbFXd8ZWdfLIZi71k=;
        b=hbUMoFLdTdC6QunXb4fBiOQCay9Dnp7uZJKtN/TyGZFumgvbABrjCFQTQR1B6D6oI6
         QcVBaBtyTAwF6lAhhHRSLCMWvjinRmmgqCN7V39dfrU3We1WbvlKsp/VnLYWtDxpDtPE
         T99fe/GsAonceDIeGAGobQg49rVtD1VUCGwlNbQLMC2u6NFmA3bb392+cN7qQEy8Aqou
         KaUdCwuAuopec2HzwF7kZmOCKrvn140KcnuEFPde+kw6eknLN9Izq6kjS5qG8twMIZUH
         9PRxGt0VknXGM7cS/xbDyDX4NOOsmytEZI4yUmDR7pQwThSht36PDDs5hc3VXI8ES6Yo
         PUVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O2nZLcUS7NyaUZEKd2KKj/OHp1nbFXd8ZWdfLIZi71k=;
        b=jPaPz3YSdprqHkNqZjgxKdNO8Or5bbuM79eLGHdioKbmjbt2uOF6tIncNjtR/I2gky
         kAIV6f4wH1mDkgMq2shCJlld2wP6+DEImOKyqFUwQR3D+uUdAUUgwFX1NVsDMJXW/1Dm
         X4ci6oYhQ4djR7JcKgBsLtZF9zozowoqPAhvwhKsT3Cdmaz0++RqudenGi6B9jttmVzz
         XvL+LwzvRoI0iKYTk5QvLdsuZmuY/zfeCCVD+6GNydeJpWunge9Kne3HpXA/PPOF/aNm
         YkwPOtJmnKfK7/ijNocLTFpdC18VK8Tade+eulDRc/VwqWJwTImvHm/6WdWEGMxdYrZe
         Qp7g==
X-Gm-Message-State: AOAM532Vo7CvwuAmQP3dP3XoZ4V1C7+pw6nMeNGJPblgJevMZwc6y0wo
        maQMYtGKAcGu1LRb0bn950pRlAw+qifHuBJC
X-Google-Smtp-Source: ABdhPJxvIUO9cS6JE8qkfNBW2QGPHUJe+Q1PpgIWQOXtXbYqKo3K7s3+UwaCA5AaMSorq/4RQsGlVg==
X-Received: by 2002:a17:90a:764e:: with SMTP id s14mr10283934pjl.231.1635063796676;
        Sun, 24 Oct 2021 01:23:16 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o4sm14661687pfb.48.2021.10.24.01.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 01:23:16 -0700 (PDT)
Message-ID: <617517f4.1c69fb81.5f458.81a5@mx.google.com>
Date:   Sun, 24 Oct 2021 01:23:16 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.252-7-gee9da0cd0b1b
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 132 runs,
 1 regressions (v4.14.252-7-gee9da0cd0b1b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 132 runs, 1 regressions (v4.14.252-7-gee9da0=
cd0b1b)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.252-7-gee9da0cd0b1b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.252-7-gee9da0cd0b1b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ee9da0cd0b1ba2caca5c566489dfd0ff4a08087d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6174dcb0f7e6f3866a3359ed

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-7-gee9da0cd0b1b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.252=
-7-gee9da0cd0b1b/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6174dcb0f7e6f38=
66a3359f0
        new failure (last pass: v4.14.252-5-gdabefdaad1a3)
        2 lines

    2021-10-24T04:10:11.488576  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-10-24T04:10:11.497990  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
