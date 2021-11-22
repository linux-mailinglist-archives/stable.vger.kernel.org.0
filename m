Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CF55458899
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 05:21:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbhKVEYZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 21 Nov 2021 23:24:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbhKVEYY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 21 Nov 2021 23:24:24 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08C40C061574
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 20:21:19 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id w33-20020a17090a6ba400b001a722a06212so12622731pjj.0
        for <stable@vger.kernel.org>; Sun, 21 Nov 2021 20:21:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DYZJ4cKEHboFz0gw6SC0TyyvVexPN5BWccpBYGzIf0c=;
        b=Ib9s6vfA/3cLynCwlc0uicPrMz8hIP5H8tc//pvHQy13CiWEksaLR1wafDLi5qJh1M
         mJYJwqlf/0eOXg5SMwrCz5UnIGAEAN2QBT96oa3RzTfPNq048TJef0HuiGpyK4fmLBxz
         aGmm5eVx2nrwBl3bAatEHBbgIE3+94U0hRUIjs57ZtvTEDJy1ueYV2VN64a6dkwkZqKi
         Q86UmWSRdnIR7dQaEEmD4H9pNrZKTQ1aQlODSJqod+ijYpZ90XRa4zvnseoz4Ka+Aw7D
         cBSuIOV6Pp2Atl64kvMQhJJizGBQhM30LdJonRoDQ/yo6sRut8LkjvnJ6ewujEr3EdHG
         6cwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DYZJ4cKEHboFz0gw6SC0TyyvVexPN5BWccpBYGzIf0c=;
        b=xu5beq8t2kjbMJ78Q8FQuDd5IDvSqFojVNpM0ysIltgJPTveraRVwD5A0sVcN5m61A
         ihQEnfWjQ7yvtkjSEfsyb8Heumsqz8ITBvzSnhIol4RUf7cr6PH8eYtLzrIbGzVWfBt6
         eO7rVL7w0fE+g3Sqxwrl3NUuAdpEuKPcD0dkjiMa0cbesinMwPuDY6iTIB19QvHRJ2pI
         2MtufxK1uXJJEE/pphMoHnAyS9fkxkH70Gycc/pbA2vDDKssqL+3zlp8ELmkORwcaYDu
         iUfFdndrronyL2Shl8TrgSJsySoyjElONi53m25RMxxMdR367sbnxBcfZFmr5roVPr/f
         LKiQ==
X-Gm-Message-State: AOAM531wTKNFJWw/U5lpU2qHX+2C3RKsJkzX6P0IM1qMSj6lwggA1FBW
        ZIWyfmdYMtvOqav+DlA5q2HUz7P1tihgUMeW
X-Google-Smtp-Source: ABdhPJyGkGMYq9sUmn3hvv19pwugKZlE3W/25nTUrxrGi2JrT3UCWjiCh9P4c5Tr6R/idkT2WNf59Q==
X-Received: by 2002:a17:902:ec8f:b0:142:11aa:3974 with SMTP id x15-20020a170902ec8f00b0014211aa3974mr103935731plg.30.1637554878448;
        Sun, 21 Nov 2021 20:21:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k6sm14607577pjt.14.2021.11.21.20.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Nov 2021 20:21:18 -0800 (PST)
Message-ID: <619b1abe.1c69fb81.d09fa.bef6@mx.google.com>
Date:   Sun, 21 Nov 2021 20:21:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.290-187-gc47222584eb6
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 1 regressions (v4.9.290-187-gc47222584eb6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 1 regressions (v4.9.290-187-gc47222=
584eb6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.290-187-gc47222584eb6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.290-187-gc47222584eb6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c47222584eb6c7474ec6756f4f9f53cacae9fc05 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619ae01d545dd5652fe551d8

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
87-gc47222584eb6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.290-1=
87-gc47222584eb6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619ae01d545dd56=
52fe551de
        failing since 0 day (last pass: v4.9.290-161-ge496b1c75ac2, first f=
ail: v4.9.290-161-g520a4edb46f8)
        2 lines

    2021-11-22T00:10:41.167256  [   20.362396] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T00:10:41.210329  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/119
    2021-11-22T00:10:41.219486  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
