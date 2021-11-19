Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB485456789
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 02:44:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbhKSBrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 20:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbhKSBrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 20:47:10 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B033C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:44:09 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id iq11so6671183pjb.3
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 17:44:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=sfYO+htsGNz76WyzPvr0Y1sQbj4SOtaYT8ME8E+m5KY=;
        b=MMsUa2LbLE/sz/X1V3Qdq8ZqBU3mhABrnGm41FLXmZme362TrcM9fG+M3la82S9ONz
         TCz9hzDbKv0c0WcXrc+OvYr8/ZkGlNxJymH5HyGiTiVPM9Ki2623CQUI2yuTpdb9nB9J
         qydpveBdQOIWp71dX2ybkins90ttQi8ECvwZDRaUPW13lxAdzws3XjvG+43RGeux7Fpi
         CsDwPm7wHGpA02Cf6DRm7JyyRtNSTvQWKYxFzRXPrYKWeRp1/cArR/k8kimc6ZdDzmGv
         EgwcWU8C9Cs6M8Td1fK3smGmNVAAnwnFlttXLgHTLvMJ8aSxW564xXbjoCr9LIxC47Mj
         VN0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=sfYO+htsGNz76WyzPvr0Y1sQbj4SOtaYT8ME8E+m5KY=;
        b=3F/UoaZxQHb/W5od6KNmSXonHcnp7SocWlPL4ouQ/Eu1DmFs0LpxRjoGQOWfARPVB4
         wJ6gXE1tVx163IkoxpY66NIbkCO3kA224+Vb6sHnUE/miFTM7OI4aYj2WSuYHS1BlqyO
         Z9/1tExjqZg8AbRI3bAZKJkx1dL7Ph6yTlmNZvprM9QXTrjj2DS/F5XUsZIXensSQ2Vl
         Xl0d0H5DeydChVQk9xrA+GXQgTsikKlHbS2dn+gV2btU07dmrMUGe25XdKhFcZF7cKy7
         DqYRgrI+tdui8dbiWxj7Z2utaFTkaLXcx60nHGbqlBSsIUOrmMr6bLr86tm+tCiOS/lL
         xwuw==
X-Gm-Message-State: AOAM531BcNe2A+4ObEqeWVLpOq6BISZAUIdpCkvbGM2vC+IHNdwW02e1
        dQR+Md5b+/ol8Oz07SKUjn3BRQdnMC2FZ35P
X-Google-Smtp-Source: ABdhPJzK5NlZsUrGfkOHdkzerkMKSCDrL4YTHz0yS6V7jSEPJ1fHiyjVm2aw/QdVntZhSUIjVkY0dQ==
X-Received: by 2002:a17:90a:b107:: with SMTP id z7mr84370pjq.104.1637286249027;
        Thu, 18 Nov 2021 17:44:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm715985pjk.41.2021.11.18.17.44.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 17:44:08 -0800 (PST)
Message-ID: <61970168.1c69fb81.c2c79.3b5b@mx.google.com>
Date:   Thu, 18 Nov 2021 17:44:08 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-159-gb051ad78f9ff7
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 1 regressions (v4.9.290-159-gb051ad78f9ff7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 1 regressions (v4.9.290-159-gb051ad=
78f9ff7)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-159-gb051ad78f9ff7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-159-gb051ad78f9ff7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b051ad78f9ff7de0379fe342f12e4bbcb41acbf0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6196cac5881ba7e750e551e1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gb051ad78f9ff7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
59-gb051ad78f9ff7/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6196cac5881ba7e=
750e551e7
        failing since 0 day (last pass: v4.9.290-159-gbf72a0fffb43, first f=
ail: v4.9.290-159-gacda9050a82b)
        2 lines

    2021-11-18T21:50:43.260707  [   20.185028] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-18T21:50:43.308977  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/127
    2021-11-18T21:50:43.318051  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
