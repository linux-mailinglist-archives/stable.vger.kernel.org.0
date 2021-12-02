Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13272466DA1
	for <lists+stable@lfdr.de>; Fri,  3 Dec 2021 00:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349406AbhLBX05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Dec 2021 18:26:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349346AbhLBX05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Dec 2021 18:26:57 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DA54C06174A
        for <stable@vger.kernel.org>; Thu,  2 Dec 2021 15:23:34 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m24so803596pls.10
        for <stable@vger.kernel.org>; Thu, 02 Dec 2021 15:23:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rJFavQf8ZALNHu/Q+1Oyrn9g+9Ej4EWcBi4xMGMdc5I=;
        b=CgmPdQxWGx89eDqGKM1VA+IreHzoh8cc3Q5EErEGVs5DTZzn2P49Ivk9z181vXPaov
         wzhIQZvROAg8hsyYYql/4ZwJea/v9+Jau1VlNBJa6T0ZIMJXoLNzgmf4NnV2oXYwzdWB
         x3Ky+Z53qleYDwOyvdvNd8oc9bdV43yvMSk3tTzSiRPhuBCQdxGtQJuwh/YHzOybkgcX
         iDOSlTbRetJBO1tV5lcjdh38YwUD1O0WUSEIS6GYt09z6surPnrZ/E0C/w3l00JMa1rH
         zhpIvf3yDESwQkhcoyayCz0fskf+1hxTjagufba+vSkjgoD8h9PlnnsBYuMcov9oItta
         b5EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rJFavQf8ZALNHu/Q+1Oyrn9g+9Ej4EWcBi4xMGMdc5I=;
        b=7GrxxUYSJFn2GrWeNymC7ZXtQRrU++WODbAIDBakjGv8F5gfTyu05dSj7dHrM6Kiif
         aAgxdfZazznecl2OJPzt1eeOwU8U0KCEwW9/VoVk0lnNBp8vdAUtfeEEuRAP93hlx3hE
         iSuB4xsKF0j5dyR+3gB/ayQNg527LZ66TuXxwKwoHxBobZP6yFBZhrAP0K/DbV/RqfQx
         3BWIrHwMWK22sxrKU6sluHAoQQpMlFBkSlgC2JiyKKPcFtOmfObjBzKGylEEQuMK0RC4
         JNv7eIz+Tlfb7171f/HbT0KqelRxatOdoYPp7pd3JgvxRZlaZbStE4PmzivORFjNSF1R
         Fs/Q==
X-Gm-Message-State: AOAM533SLcfPpbEVOms+GLIp8tjGOpQuReHzUXL91J7mPcVPIlQMkRUC
        wKN5qsNAqT4uZ2xFdZlPM7a28zwr7HkR6FPc
X-Google-Smtp-Source: ABdhPJyWs6eUww6vx/SzIdFH3f/XpjsQz5iBIXk+VO0kiKbqrsJ/aVTyCMwwTnEtBQ2SOCyPqsQ+1Q==
X-Received: by 2002:a17:90a:5901:: with SMTP id k1mr9623030pji.76.1638487413635;
        Thu, 02 Dec 2021 15:23:33 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w17sm855622pfu.58.2021.12.02.15.23.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Dec 2021 15:23:32 -0800 (PST)
Message-ID: <61a95574.1c69fb81.91835.39bd@mx.google.com>
Date:   Thu, 02 Dec 2021 15:23:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.256-72-g55679b43003d9
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 83 runs,
 1 regressions (v4.14.256-72-g55679b43003d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 83 runs, 1 regressions (v4.14.256-72-g55679b=
43003d9)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.256-72-g55679b43003d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.256-72-g55679b43003d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      55679b43003d92db8116d8686d445a670401becf =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61a91b7ffefd21f56e1a94e7

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-72-g55679b43003d9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.256=
-72-g55679b43003d9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a91b7ffefd21f=
56e1a94ea
        failing since 3 days (last pass: v4.14.256-28-g54e5647834e42, first=
 fail: v4.14.256-28-gb75fc63979563)
        2 lines

    2021-12-02T19:15:58.451962  [   20.146697] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-02T19:15:58.493305  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/104
    2021-12-02T19:15:58.502530  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
