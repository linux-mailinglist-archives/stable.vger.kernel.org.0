Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BCAC482F2E
	for <lists+stable@lfdr.de>; Mon,  3 Jan 2022 10:01:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiACJBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jan 2022 04:01:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229723AbiACJBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Jan 2022 04:01:46 -0500
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A50AC061761
        for <stable@vger.kernel.org>; Mon,  3 Jan 2022 01:01:46 -0800 (PST)
Received: by mail-pj1-x102d.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so31769961pjp.0
        for <stable@vger.kernel.org>; Mon, 03 Jan 2022 01:01:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v69cHNdl76Z1l9oetx04QE35yc5iqDvoIunwrI0/iLk=;
        b=JyEwsT0AVCyzP42QslPK8LVkxslz7PEGG6S/0VNHI4n5Uix/h/A8ESx1/sIGb1weGi
         U7MG/cIR+EBQdSJltFaaKgz1GXRsyEQJRpX62D8krBd9MlsZ1l33H9eTL/jqqauZUEcc
         rGJ02nY2MZsTuG+Juu1gJyUXZfRnwMHM9EeXlrIFD5Z6qG4wRinca3tkFKDb7HDriTOV
         CeI5vN//kL87hpGO+RGVz3Yr00jY/4utaEofqEdyefYDpBok+Fph42bJ8LRw+wbbcvBT
         EkvcPxmawchFYt3waYpQ9CrUAfUYQ4+vBgZnqwUKhvS1pfzaT0dR7D4GdNhaHsRfisRP
         0glg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v69cHNdl76Z1l9oetx04QE35yc5iqDvoIunwrI0/iLk=;
        b=n7r0Q9BmUJQIBwYa4SDpJrm2oLo5aS8RyJgq9tPCelKWYBzTl5AKa7FfLvRCVH/bZ0
         02a/kZlXnvKG2k1YeUMF4l1yr6UswKF06rCwAnVCwpUcsuC20O72z/8gERQkpadkVnrp
         bnNu28iBECD6CjdCgXBfvZsKo65cV0KstH+0H8YXofjJC77mYnHZIDbERXqTKHTTu4D7
         HDzkKEnuy2BJTb0heTV5XpiT/nDsHnh+QuVGRf50qZ/4o6pT/McLSLEpJxWroQticULb
         4a3MpS/LRg9xc0xhXuRjw6nCdMwDeM6QY3CgF2lgQTnmFMBHjydTj9hoCu6109CzsfdG
         I5tA==
X-Gm-Message-State: AOAM532xFnFI4hK/xpHSA/fmFdVucchiNi0ngmGSIuCzqzYYCJ2VkZQj
        PpopvB7xns8kf0AwXR5i4ShMjM/3AOyqav1v
X-Google-Smtp-Source: ABdhPJxP7MhchRpRQHys8xoSFnjLwG+f509Hg1XBffu+K7zOzkeZ7MSNaEYPBaNazppihDl3w/a9EQ==
X-Received: by 2002:a17:90b:3e87:: with SMTP id rj7mr52271998pjb.88.1641200505935;
        Mon, 03 Jan 2022 01:01:45 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h3sm30226223pjk.48.2022.01.03.01.01.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jan 2022 01:01:45 -0800 (PST)
Message-ID: <61d2bb79.1c69fb81.52f5c.1ee8@mx.google.com>
Date:   Mon, 03 Jan 2022 01:01:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.295-5-ge297e6d38d55
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 1 regressions (v4.9.295-5-ge297e6d38d55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 1 regressions (v4.9.295-5-ge297e6d3=
8d55)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.295-5-ge297e6d38d55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.295-5-ge297e6d38d55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e297e6d38d554e6dcbc7c44972642db3a084d583 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d2875aa47ddc6a91ef6752

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-5=
-ge297e6d38d55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.295-5=
-ge297e6d38d55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d2875aa47ddc6=
a91ef6756
        failing since 6 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2022-01-03T05:19:04.898314  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2022-01-03T05:19:04.907628  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-03T05:19:04.923443  [   20.025970] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
