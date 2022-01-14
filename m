Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7F0748E6C4
	for <lists+stable@lfdr.de>; Fri, 14 Jan 2022 09:45:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbiANIpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jan 2022 03:45:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbiANIpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Jan 2022 03:45:24 -0500
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D956C061574
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 00:45:24 -0800 (PST)
Received: by mail-pg1-x52b.google.com with SMTP id t32so2220108pgm.7
        for <stable@vger.kernel.org>; Fri, 14 Jan 2022 00:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=CW8wsZcJzenwHEgRDgcaqGQB6VoiuMI8oX9nw1fDmM0=;
        b=Wjc2g9ZKJJ7e/+W9j5fFDGj/gP2joni6kp6f5AAgptyfNUEReyIjVG2Z8Zq1Ub9uF4
         SBT+Ca5pGGI/PJ5vsMsavM4ptqkgJ3TYfSiqNIM1aU/mma70RQQSx0NZthSFojkDJ6wz
         ZWsW4mDlov7bhAYkEg759wkPRhkyTv/v7KKjStPYwDxpMlvg6bq9vtMzLAWwQ0w/Pljc
         5iBjQHOH2I/5Wb2e1H5bgjXhDGSyxwRfC8WrygkQk8viyHZw7bqgNpV/Y02Rgbqs44wi
         f4YXMa89iHOMcF/MpYfeIxRobcDtHLt0lrAQBazFRvUutWEhiFsvlgmfWI4jgIvKJU2d
         looA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=CW8wsZcJzenwHEgRDgcaqGQB6VoiuMI8oX9nw1fDmM0=;
        b=VWEJZYm0BVIGWq28FHajsxWWKQackYKHUiB/lFHfX09zLzavgHm5wwGwUdwfrtHR07
         HI24K+yZd4RTtVYUY9hdHca5mu9O+2PH6oESMA2e4ixCdFTFwWO6i1sGlv3Tbk+HZLZa
         hNvC4WMZ/H4nsrsM8UFLEZVYnbS1699SWqkvPCV2852IH7R5G9NIOjjQmqDmT96shiqF
         o3Luqfb7/YyvgxzaI4MOhRpSedjyEApy/xlnTeWlybf+bHPc2IvqDD/s8ox+3wS2J+PX
         oAg5DDzLcg0ETLCPirmuIXkR60iVFYisgtal99Pf7uhdiAulKagh8jgF5GRnPIz/y+FN
         j63g==
X-Gm-Message-State: AOAM532njMvmnfjcgYW+C+BURkHlrHiode5wwASGd9r5qJwjKYhHe45w
        Ylf/rMdVhpFKG0yEHm6duqKuHm++RFmSQu+BQI8=
X-Google-Smtp-Source: ABdhPJzkpTe7ssrw3KiLevUhc8wpBayC3T/ifCFE5WFTShRUMN1bXMzYx9hOZvUmQiL2c5lGt0VpRw==
X-Received: by 2002:a62:8f01:0:b0:4bf:3782:22e3 with SMTP id n1-20020a628f01000000b004bf378222e3mr7958646pfd.52.1642149923511;
        Fri, 14 Jan 2022 00:45:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v6sm4472231pjs.54.2022.01.14.00.45.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jan 2022 00:45:23 -0800 (PST)
Message-ID: <61e13823.1c69fb81.88ed9.cf9b@mx.google.com>
Date:   Fri, 14 Jan 2022 00:45:23 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.299-6-gd031e8a4028f
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 71 runs,
 1 regressions (v4.4.299-6-gd031e8a4028f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 71 runs, 1 regressions (v4.4.299-6-gd031e8a40=
28f)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.299-6-gd031e8a4028f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.299-6-gd031e8a4028f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d031e8a4028faac8aeb141a4ca45000fdf4fe3c8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61e106c0653b92fb3eef6750

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-6=
-gd031e8a4028f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.299-6=
-gd031e8a4028f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e106c0653b92f=
b3eef6753
        failing since 24 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-14T05:14:20.822684  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2022-01-14T05:14:20.832568  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
