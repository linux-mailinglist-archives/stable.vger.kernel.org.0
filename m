Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F272B36ACA1
	for <lists+stable@lfdr.de>; Mon, 26 Apr 2021 09:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231989AbhDZHGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Apr 2021 03:06:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhDZHGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Apr 2021 03:06:49 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED9FC061574
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 00:06:07 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f11-20020a17090a638bb02901524d3a3d48so4609436pjj.3
        for <stable@vger.kernel.org>; Mon, 26 Apr 2021 00:06:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qIRrHY6V72OkfzUCm1Sffo4WQZGSRchE8dfdteWsupY=;
        b=qqRaiOJ93rgGCjl4gXK/GdsHKinqFpTADmbpp+6GrDCNAXFjcuz4QgsYbOt75j3rPS
         Z+szQXnAV4tMVIeK4zr5ju++RoYs4+J8Y7w+x26N1CqW5Og0oEmBGuBj8M846nJGSuMl
         PBOQrziFgUdOfI5nuYMDa19FutC7/VOpkx7SdSguj8sAKwUG1bTgY9149IG0JQz0cS7b
         CqtXlP4WaRfs+5nIfYn6Ur5rz6NkahCu1IjXnsPrr4kJoRdDLMMSvLdgZrQLyoG4fxXl
         icB2zweIqVD7znfQKY5leLXJeKDxDMIf2XZWaemfsUzFCiY57BN8tUg9vZWFEIA9qzfR
         zS3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qIRrHY6V72OkfzUCm1Sffo4WQZGSRchE8dfdteWsupY=;
        b=WshSQqMt6EVkIvZ2bPUw9ppW6qeRDo1ah5gaEkleCGr2fbXP6FNIzuveqCGy3GJ2VY
         N+WMkiqzXC2FlWPT2EuaCA2VG4lxhiu+ZWIy1ELreeMwZKG6mmVTJPe8PDNSMABTa4Jr
         dUePCm5eyYU6lVRfvXjyGd7IMvyVV2RSPSIC1z0J6Tx3yLp7njwJdomOKO3SIBEFYDOq
         Y22pjmf3rK4GGcLhEOGPbDHLb2GTX/tjX/JNwlVgKjZVKbiX1mUqD27ckiNkS5G8pw/c
         sv/ZwQbPZWGRIhQF47egq9kQwbJAjvNG6u32Gj1Q2r0MOk27dR5oSB120ey/bMWueKV6
         QWsg==
X-Gm-Message-State: AOAM533LxD/jW31jSdPtpuDkh2RuhASf++1hgZv5A/Dnz/UBK3Hvau7/
        oozYee1Cf/wxNzwTyjfkJFZ4MDM3lms/Q7Xh
X-Google-Smtp-Source: ABdhPJyKe/B8V+W3TaZQYj/3FgNv3FJACZrLWhdpFy4K0xdfmdy8vF3BJxUYSrY76/V3uvfqPO8X3A==
X-Received: by 2002:a17:90a:7c4b:: with SMTP id e11mr20605328pjl.151.1619420766980;
        Mon, 26 Apr 2021 00:06:06 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j27sm11123862pgb.54.2021.04.26.00.06.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 00:06:06 -0700 (PDT)
Message-ID: <6086665e.1c69fb81.bcd02.0ad8@mx.google.com>
Date:   Mon, 26 Apr 2021 00:06:06 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.231-48-g2c32049071e3b
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 107 runs,
 2 regressions (v4.14.231-48-g2c32049071e3b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 107 runs, 2 regressions (v4.14.231-48-g2c320=
49071e3b)

Regressions Summary
-------------------

platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =

panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.231-48-g2c32049071e3b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.231-48-g2c32049071e3b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2c32049071e3bd2f52a66f668462b2bffd627846 =



Test Regressions
---------------- =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
fsl-ls2088a-rdb | arm64 | lab-nxp       | gcc-8    | defconfig           | =
1          =


  Details:     https://kernelci.org/test/plan/id/6086356bd67aceb2269b77ab

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-g2c32049071e3b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-g2c32049071e3b/arm64/defconfig/gcc-8/lab-nxp/baseline-fsl-ls2088a-rdb.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6086356bd67aceb2269b7=
7ac
        new failure (last pass: v4.14.231-39-ga9b6ba4783dcd) =

 =



platform        | arch  | lab           | compiler | defconfig           | =
regressions
----------------+-------+---------------+----------+---------------------+-=
-----------
panda           | arm   | lab-collabora | gcc-8    | omap2plus_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60862dd36c953b4f329b77ad

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-g2c32049071e3b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.231=
-48-g2c32049071e3b/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60862dd36c953b4=
f329b77b4
        new failure (last pass: v4.14.231-39-ga9b6ba4783dcd)
        2 lines

    2021-04-26 03:04:47.550000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
