Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4737E31B8E2
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 13:19:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229998AbhBOMSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 07:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhBOMSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Feb 2021 07:18:17 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7871C061574
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 04:17:36 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id 75so727950pgf.13
        for <stable@vger.kernel.org>; Mon, 15 Feb 2021 04:17:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cuJ9u35uT4xsdAhDFV77b3KkUW2muAe+Kmww4v25Obs=;
        b=R91NMY5xMF0+tg8Qa07OSM+400o8yFPlDlivib1FjDXGs9Bd1qll4MjhF1t6lJZO4B
         QgX0wXLwwTRuwlgOxiihiOnZzLSMuzn0O6A2dpcsWouCpbCa9k5/egPzgnKy82v3fYUl
         dS9YiYNQ/bZa1MvrU226IahCgpfByyezIOndeEVU/9dDrv1Im0pAtti1fZKWTBk0FTW0
         9YSE8bEo1OIbUn0aEZkm0Vjk92/ZTxQ+biShQkIl512/d6NUy855qxpuG2tsXEh/uA1Y
         tepARkAbMNDSuULnHgrci7kHETJiLxKH37xlWriGOjPtv88/RjYTOVBiOKarMnoxeUat
         QM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cuJ9u35uT4xsdAhDFV77b3KkUW2muAe+Kmww4v25Obs=;
        b=HDOgHYN7aUt1T1No9EoDuwppc3bsdhbp5XmOah9nI/u5EzBKu3xyQpGrGwmazjqaxg
         JTwynMy6XrWZx2UT/+Lpj+epIxybTPFOODnK2ZISQc/VRcf207ybqwT1jdp4nfNHoXBA
         mPaQO5BvxMILt/MvyBScnHa0EqWMS6shXEHdvsRxrWSfNdj3Y1dy+tXIihQGPMldDaWp
         RtMwuOHiFtdrtA3vLeY8N1dia0UZHgyxgKiR7zKzrA+iadU9+F8nnoSZ04OejHhlHSMj
         vnmw2EiSyeuM6AZ1hwLn/7Y4lVVFwekzRFm1QW9oCM0HpvB0p1CFnuAkYpybANcFDGm2
         AS5g==
X-Gm-Message-State: AOAM530lfAcJJXV+ffYopAftBZTZMwkO2zqfqCaRGAShQOmjB88WHxYK
        0F86P2mh+nhCu865oUBQjneW106xmtcwPg==
X-Google-Smtp-Source: ABdhPJwdXvPr0TnE0cIRy9hNNt1eFU2RUgypEurBMLzeeb/lT7IWJPITetjJ+jaFs+QKfRVkyomlzA==
X-Received: by 2002:a62:5e44:0:b029:1a4:daae:e765 with SMTP id s65-20020a625e440000b02901a4daaee765mr14919846pfb.8.1613391456035;
        Mon, 15 Feb 2021 04:17:36 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b15sm18209553pgj.84.2021.02.15.04.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Feb 2021 04:17:35 -0800 (PST)
Message-ID: <602a665f.1c69fb81.2ea6e.622c@mx.google.com>
Date:   Mon, 15 Feb 2021 04:17:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.176-27-gde63c7784ab7
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 77 runs,
 1 regressions (v4.19.176-27-gde63c7784ab7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 77 runs, 1 regressions (v4.19.176-27-gde63c7=
784ab7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-27-gde63c7784ab7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-27-gde63c7784ab7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      de63c7784ab7d60ac902aa8cb5830158382d5068 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602a302a3e286595633abe76

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-27-gde63c7784ab7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-27-gde63c7784ab7/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602a302a3e28659=
5633abe7d
        failing since 7 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-15 08:26:13.987000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-02-15 08:26:14+00:00  <8>[   22.937835] <LAVA_SIGNAL_TESTCASE TEST=
_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
