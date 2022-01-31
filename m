Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B364A4B02
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 16:53:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346651AbiAaPx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 10:53:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379937AbiAaPxB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 10:53:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04186C061714
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 07:53:01 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so11291846pjq.3
        for <stable@vger.kernel.org>; Mon, 31 Jan 2022 07:53:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AdicZRinNdxQxaZjU0rin9BHEnNQCU9Mk7rVSx1pDhU=;
        b=PvF99kIpNQnwGV34SsDJLhpWgm3yAF2wJmRLcAd0/EDjW2Bkh+BdYe6yoiI9AeWWp2
         6f4w09wKs+HFIHzhbohSzeRbLF8njzVTQlnIVc0ATTlPafGH7qYnsHjikOUj5E+SBBzy
         Y3/rbk1fvOGgVAoyATkG7LX4LM80/7tMoS8N9eLcAGUNHJvdZFvm6FbLLR+PmLiKSakT
         bOp8bJ3Xhle01Hj0lsYlbbuPfyBPoIySYXYtqow59/xtMIzlubKQlw2Q4PhUjUCuioDY
         orGgu9OYKvAmxyq+mXYI7aLuPFZUipYcNZaYZHukS8baedxLK+z29BMS14RNLXfrH2li
         cxVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AdicZRinNdxQxaZjU0rin9BHEnNQCU9Mk7rVSx1pDhU=;
        b=H++22b9NqznQWJ6IZ/CSK50KC2Vt5rj8CUxO/wjSXZOCrW1fjb7+qLqAxvx3p+8yUx
         hKGtZlo0o5yEdNGaYyYgdjgNtjtXjhQqKFuo9bETdmMpERsXtYw23IdKs5st5vzIlTZs
         ij/Q16iv+X8lFULd+Mp6JIuXF+PoOTEmK9boHlBmmJXLqKkNwUahsU7+MsJOlMO+r1Wp
         f0yvz0cVtxvdJK2zWAN5x5dYprEtEq0QWW2oxnHyIITgQQFnUGuOhTKWrY8kQMhLhzN8
         B+HaYJF3Ur3I3W2cnmoxM5klm0mVhibju3mtw/2PPKuOVMkZm46wsuzcIpFo/ec9c311
         7bAw==
X-Gm-Message-State: AOAM533HdPwU641XENyj9eGC+TOpaqrpACGZyf4in1VqY9LUsIxiZp3h
        Bdv/KzArSyXC3+vxAv66TOxBvU45GjOSSaGL
X-Google-Smtp-Source: ABdhPJzlwislQnRpMAdQs26AWPofKMIkzsX5yZkr57b5o0eNuXHVBhFNFq8WYYPMzcfZJ1C/d9+bdQ==
X-Received: by 2002:a17:90b:390a:: with SMTP id ob10mr34941411pjb.92.1643644380447;
        Mon, 31 Jan 2022 07:53:00 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l2sm19321628pfc.183.2022.01.31.07.52.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Jan 2022 07:53:00 -0800 (PST)
Message-ID: <61f805dc.1c69fb81.e3dd7.22e9@mx.google.com>
Date:   Mon, 31 Jan 2022 07:53:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.264-39-gefdf4d7719c55
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 51 runs,
 1 regressions (v4.14.264-39-gefdf4d7719c55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 51 runs, 1 regressions (v4.14.264-39-gefdf=
4d7719c55)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.264-39-gefdf4d7719c55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.264-39-gefdf4d7719c55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efdf4d7719c55fd6967cab8548e8865a5932a0d8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f7cd192c28ffeefaabbd22

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64-39-gefdf4d7719c55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
64-39-gefdf4d7719c55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-=
panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f7cd192c28ffe=
efaabbd28
        failing since 17 days (last pass: v4.14.262, first fail: v4.14.262-=
9-gcd595a3cc321)
        2 lines

    2022-01-31T11:50:30.829717  [   23.018341] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-31T11:50:30.870982  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/106
    2022-01-31T11:50:30.880360  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
