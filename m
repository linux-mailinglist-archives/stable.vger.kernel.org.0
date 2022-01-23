Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F9F549756F
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 21:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239963AbiAWUBc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 15:01:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239911AbiAWUBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 15:01:31 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC19C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 12:01:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id pf13so14277779pjb.0
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 12:01:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=g1yKst0SCQzddtSeQaOfE60wE+Lg6BlYXVImy1BLUMw=;
        b=Ig52cS6TvilvMWxznGXkyMACBaXYTPRTncJ3E6qNy/vZjN+b4uxuGvmY1hzfxZs56s
         VrBGAq+Xr2OZFJXPGFI498izmR+IGhi4Si2HikxMKbcWikmCq0IyI8m04d/OqGVdBaEF
         kCOke/Zx9XTv0s2QqC1xQRUXpM0yOlXZ+2c+rsmwXaS+VqvmDMRdrdDZkio8AUT1Oc4/
         Pua7DfcSndTxZlyiVwPI/gdEF+Ps2QHh26IRKuY+IivBh3U6i5rhfduScafTK4saEsBL
         NcRxWNd1bw0qCt0TPfbF2GVN6Is7Na0W0RcFBgVCqo38s4N1yWFWXXjBdKxuFrkAzqQ4
         Tsng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=g1yKst0SCQzddtSeQaOfE60wE+Lg6BlYXVImy1BLUMw=;
        b=4rEQDofq8u+19bFuu8OShXepgR5oxv5LJFIfA2/z0VFQhj3FP13l2fHqrxsO4/gQM0
         pz4JSbTeE1nbpG9O28jx9kMRsXQhnF9Jx2JFdxuKG0r4/ZajXoNMqX7//R2086T1j/GW
         S5BYTkguLEFA1KHxfRdW4V2FtMOTQdQIK+SHhrCICwMppeVHymsGyV3KoURQGEn4x94t
         nxih75ORPSkZ3QkeF4BWOhf8ucyZ1IXtX1tlwp31EFIeWdtLgmzOZI8r/n3pnb/xyhCF
         ZfDzJWFGsAkxbu+YCw6IA50UnGG+hRgA1wOmc2H+/fv4j/RLTriYOsm3jO6SlMCaOnY2
         OcZQ==
X-Gm-Message-State: AOAM5321Tgmp9q1gudz3slpeP79xHymp8sQyWiCNZUSbs5cSmU03qcEJ
        Kf2Cnme294rNkA1RN87Dme3sDjmUJda3DHwM
X-Google-Smtp-Source: ABdhPJwEzhfIzkF2rXnb0vUTau3OOkwniDAX4hNflhha+xnOFSVnWINdym5i4RR4g4WW8IP6o6IC9g==
X-Received: by 2002:a17:90b:314b:: with SMTP id ip11mr10054724pjb.201.1642968090702;
        Sun, 23 Jan 2022 12:01:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s12sm730904pfk.65.2022.01.23.12.01.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Jan 2022 12:01:30 -0800 (PST)
Message-ID: <61edb41a.1c69fb81.a290b.1b08@mx.google.com>
Date:   Sun, 23 Jan 2022 12:01:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-117-g892dd8804579
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 145 runs,
 1 regressions (v4.9.297-117-g892dd8804579)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 145 runs, 1 regressions (v4.9.297-117-g892dd8=
804579)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-117-g892dd8804579/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-117-g892dd8804579
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      892dd8804579358aacb04672ab9e53decdf81631 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ed7b62ea76febe11abbd31

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
17-g892dd8804579/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
17-g892dd8804579/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220115.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ed7b62ea76feb=
e11abbd37
        failing since 3 days (last pass: v4.9.297-12-g2155294a7be2, first f=
ail: v4.9.297-12-g4a79c59748ce)
        2 lines

    2022-01-23T15:59:11.464706  [   20.406799] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-23T15:59:11.507037  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/120
    2022-01-23T15:59:11.516169  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-23T15:59:11.531716  [   20.475646] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
