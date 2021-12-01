Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 962E4465952
	for <lists+stable@lfdr.de>; Wed,  1 Dec 2021 23:33:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240132AbhLAWgt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Dec 2021 17:36:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234078AbhLAWgt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Dec 2021 17:36:49 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CA5C061574
        for <stable@vger.kernel.org>; Wed,  1 Dec 2021 14:33:28 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so895878pjb.2
        for <stable@vger.kernel.org>; Wed, 01 Dec 2021 14:33:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=P8QnmFUPW/CbdQOqcTiMRSYGpVRwGGbefTi4/LOFTxA=;
        b=cv2WgHAyXJuO7YfVb3hUeYgcov+RPfdOzED5jAecqnayTEQkdjxPET0SgpJjEzrXat
         9a4z/49tmxE93NXMRipk6IQ3YV88SogoFaqNvsP1v/YAoua8v0tSv4wYI/SPs/WDekFs
         wK2cPcs6fOBCQph2yFPnvW2lAGO6CrTH3C4l7BIkbr3o0qIZlOSUzoLVUWs9X+ROKffX
         DycKyTH8Np0WsfewCBtC51YDF/5ZLmhIkiaqHiaSRYkJq5r016ouHEmoQAnpTrcY59EY
         d8rqKRzVHkm/Qtx5e/r5/lNCkUvehPPx3v0UcyxOsiQPKRsawmHpUbUOi25VcMNk7lYj
         /lSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=P8QnmFUPW/CbdQOqcTiMRSYGpVRwGGbefTi4/LOFTxA=;
        b=c55expP3hqV+zUajDyIwXuqPwwe5mP8uOk4bqtdTeBQhvKpd8ptRBSYq8kwV5QeL4J
         10jmSJwQQYcLpv871J+QCqd8BhJLmLIjDRHgAZGhTQTbxm/Kc55NetkmagCk1Z4zWrxL
         TGoLaGda0DQvR02bGydLXuTfTAANZF2DMEH02FKWPW5dQ+NBXbZH81X/Lmp2UHg17Hne
         +FQjoEB8PC8DA0QJtQXliUcMVaPNTMbfR6HmLYtfL3bEW89ayfEKGWnICEbpmXZqvDXu
         xd+oQ1HddX1QC9efG8tXKbHuEjaeeFNsxKetS7BEvyjnsL2HwEhHPcRi9gl53gyeDAdW
         PKRw==
X-Gm-Message-State: AOAM532pPESEBBytQdzy0s3V97893nhVgJBfn203aLK7H5JQcDNZF3T1
        eic8G4n1wQay6br7QevWFS0ESDt36mluTzWl
X-Google-Smtp-Source: ABdhPJzljwh9NdtODMK/dkvNp0ZPEKGsmspYKVWw/5dxJpRDoFd7p+rmAW6CAUGJ7ulHTrNmd2S1Kg==
X-Received: by 2002:a17:90b:3508:: with SMTP id ls8mr1323142pjb.51.1638398007499;
        Wed, 01 Dec 2021 14:33:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id il13sm283039pjb.52.2021.12.01.14.33.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Dec 2021 14:33:27 -0800 (PST)
Message-ID: <61a7f837.1c69fb81.7bcdb.16ed@mx.google.com>
Date:   Wed, 01 Dec 2021 14:33:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.14.y baseline: 163 runs, 1 regressions (v4.14.256)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.14.y baseline: 163 runs, 1 regressions (v4.14.256)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.256/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.256
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      66722c42ec916e92cadda46316f8f6e3fdcaedc6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a122e9463a36746918f6d1

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
56/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a122e9463a367=
46918f6d7
        failing since 0 day (last pass: v4.14.255-251-gf86517f95e30b, first=
 fail: v4.14.255-249-g84f842ef3cc1)
        2 lines

    2021-12-01T18:46:05.320693  [   20.084594] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-01T18:46:05.365375  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-01T18:46:05.374622  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
