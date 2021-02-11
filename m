Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44551318377
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 03:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbhBKCLI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Feb 2021 21:11:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbhBKCLF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Feb 2021 21:11:05 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59DF3C06174A
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 18:10:25 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id u15so2416057plf.1
        for <stable@vger.kernel.org>; Wed, 10 Feb 2021 18:10:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gSHFeRpaqIZJVfSw/2OVnx9+IrILmj57qxCVesnwhdc=;
        b=KY+L4fds0OS7b4NopvGWH3U9na8Bms09vp0Flx1ogg03IklFVG4eB2DivANx7LkLZv
         GT8eRMx99kzPVxgA0KIwyEMuqVG8l++/WeWB5JT5ecUfAuTHq6DXky00EUjUQrP4Sgmv
         BkOMG7QAnEJSUiZQHMs5zVVRxyYPo85LOWwDhhafun9Zy9eRlX7r5HRsbTUORZAJW1+H
         WemedBdBsNVPUanq5pU6utGeX5zpG9Hc2z3O+3plNSLHApCJ7aoIKyHu6iO5C3zh781z
         ewNwqvWS4bVreIs55ZSa8IsSyQjJpfNYsoXFfn4SP0kiygAH4PbjXcFvVEXXpv4lBsH0
         wDDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gSHFeRpaqIZJVfSw/2OVnx9+IrILmj57qxCVesnwhdc=;
        b=kOwiGqNbKOgUoxVlXXXSAR/IyIXdU5PWF/lidPFzlvnHMafBGyV8UGvUXJjxzsnQ5p
         VV3DOq48JkXN8jm0GPHQXPKvWfmp9B9KKp1ZSpaqtk02oSv1f1oNd56tvZ6igdFsiPsV
         824H5spYLxNBpuO1A5swc/awO8kAtnGIySMcPnsqFeDblx+Kty9phJL2L3pck8yQYUDc
         00jHxVxNtN05jvqU9ub4AEWjT+1WHm6/JrI2ifM8eSbzcT12oXUAh/AuzMblXpdp1M87
         vdnlzCJQy8FNI9pmQ1hu5/5butNQ1VGyd7kz42HUscnHkAz8WxJlDPqIfOdK8KivHrj1
         jMHg==
X-Gm-Message-State: AOAM532BXVdPFIT1Mds2KH7jTBfC2ElG/v0yAO5Fdts0+NpL8huxMIez
        l7su7ZCLBsdzQ5iZjuYoAR8pYGP2n9u7hQ==
X-Google-Smtp-Source: ABdhPJyziKMFMOgCie5bmGFgb6cDvoH9lhP39FFAXwp3hLDfk2VQbt34ShFU/L8ooB90cxxhCqGp6Q==
X-Received: by 2002:a17:90b:2312:: with SMTP id mt18mr1831077pjb.81.1613009424682;
        Wed, 10 Feb 2021 18:10:24 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m4sm3358491pgu.4.2021.02.10.18.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 18:10:24 -0800 (PST)
Message-ID: <60249210.1c69fb81.64b87.84b7@mx.google.com>
Date:   Wed, 10 Feb 2021 18:10:24 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.257-9-ge272440cbe96
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 31 runs,
 1 regressions (v4.4.257-9-ge272440cbe96)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 31 runs, 1 regressions (v4.4.257-9-ge272440cb=
e96)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-9-ge272440cbe96/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-9-ge272440cbe96
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e272440cbe96cbbeedb2ff32e6481ddd685b0db0 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/602460c3f8c9dded8f3abe94

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-9=
-ge272440cbe96/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.t=
xt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-9=
-ge272440cbe96/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.h=
tml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/602460c3f8c9dde=
d8f3abe9b
        failing since 5 days (last pass: v4.4.255-14-ge5269953cc26, first f=
ail: v4.4.256-14-g2d58dd4004a4)
        2 lines

    2021-02-10 22:39:58.768000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-02-10 22:39:58.783000+00:00  [   19.527160] <LAVA_SIGNAL_TESTCASE =
TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
