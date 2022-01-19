Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21A0B49321A
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 02:03:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350548AbiASBDf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 20:03:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238548AbiASBDe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 20:03:34 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74ACAC061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 17:03:34 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id a7so622636plh.1
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 17:03:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=FLCoybNsn5rySRmWUY72T7H2ZKypSlCnArO3yfsUt/Q=;
        b=iK9jqPgA1k/AIHrmtslzGEyu6KM2at2JOPLY/WVhww2f78rCjY//bQ7ecH76sSoye7
         xn9JBMpHoosT1Utaafr9DvNskQroavNYvUmkI4DQpWWhCfUcciw9DvPyNsyk1YET0+sY
         kOHDJcdNSy1ipfA5tWgAMg/gpR0PhL840ekU0Ky33diDDqIiLCyS+zVYGebMljMz0mgR
         OAHW2YLcezg4HqDi6yqiyitErUv65IC7hV0j3EpOacTPofWQ+ovYNbSeybSSdW0maQHz
         7JWCur4VhYaqa6Q9N/6BcuvlPX8ixnRYJoMYbQCnb8RAGG/xYKTt+rSG4zKIIf7E97Ul
         SFGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=FLCoybNsn5rySRmWUY72T7H2ZKypSlCnArO3yfsUt/Q=;
        b=X8L4QsZmoURhQtvJgUNzeCymP+5JQfEE9Jn4Itl1C7Pro6ws6XRWWVgr21A9PZxNEW
         bE9A6qrfSPq0Ad2/+MoHuYTAFpa+6bqFhh/Skt/SZfsc1ef1Wmy8J2CrhaJqr8zXGDAm
         /G2HDl3rLx7r0FoIWRCuUlZ8sx0KdChbJLcKPaQYdv+qvXUKJJrPMflK0InalQZCHWhm
         Mhcx3KZMZS6NHkrbHnVSHTe8E+jcA04lGwR2jSE1x9rgdwaF1eRAKBgVTOhr6vMGyAQX
         +tKgNnqRX4FTdeVXThS9/YK0I8VDIwH9sL5uLYLIVDzoBRSrKjQGFf6tokel8aZ2ddUG
         zetg==
X-Gm-Message-State: AOAM530cBrAAIco7bkcR7qQWsnFmjubCGMuawKFEnU44IHdxq9/keDZh
        T/eOKzDazrzyCxT+MKCi4MwvLlC0K9t1Rt/Q
X-Google-Smtp-Source: ABdhPJw0li8QojFmY12jzizkxZzSmKfmlZ5IDDH3HdfGnwXcT0s63WDW7QAvRa3YrGLzwb5spzVTaA==
X-Received: by 2002:a17:90a:9104:: with SMTP id k4mr1403358pjo.87.1642554213850;
        Tue, 18 Jan 2022 17:03:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id on1sm3376601pjb.52.2022.01.18.17.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jan 2022 17:03:33 -0800 (PST)
Message-ID: <61e76365.1c69fb81.b492d.9c36@mx.google.com>
Date:   Tue, 18 Jan 2022 17:03:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-13-g0b6158e759ca
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
Subject: stable-rc/linux-4.9.y baseline: 111 runs,
 1 regressions (v4.9.297-13-g0b6158e759ca)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 111 runs, 1 regressions (v4.9.297-13-g0b615=
8e759ca)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.297-13-g0b6158e759ca/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.297-13-g0b6158e759ca
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0b6158e759ca7b351d9bc7536f2f85c15b509dbd =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e72deaea5e252f9fabbd49

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-13-g0b6158e759ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.297=
-13-g0b6158e759ca/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e72deaea5e252=
f9fabbd4f
        failing since 15 days (last pass: v4.9.295, first fail: v4.9.295-14=
-g584e15b1cb05)
        2 lines

    2022-01-18T21:15:04.485593  [   20.255035] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-18T21:15:04.535014  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2022-01-18T21:15:04.544684  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
