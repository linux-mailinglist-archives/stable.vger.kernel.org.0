Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D264145ABBA
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 19:52:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232432AbhKWSzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 13:55:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233876AbhKWSzO (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 13:55:14 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42015C061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 10:52:06 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id l190so8569415pge.7
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 10:52:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JKFJUW5XSbhH7a+LY0HJ77LgR7pHqpp+6Mgb3AvsnyQ=;
        b=36kfQn2ZyErBt5G8x59jf3WQbcfYEVPIs7gXkflZn4sp7YQNEGcqGxe0x+o2U5T1Fh
         JPFih0mThm6FurSjsEpCxyZHFQ/Fs0S39/11Px0snbTOBkgTRlv82g4P2NRQduoaam0G
         jggHcYURS38Bxu6nWLhBumZ+HHvIWGukfmmwVdm/G/PJ06G1U+Q/ULZFY6pu/s7Y6QDP
         3RGCxNOtaNPLFwVsh0+Hn8OzL1byN7t7Y72oGSbDIQB9RywOCyUHejpoM0qWXsXFZRk0
         jf61X0Gb28WwMnXFqafE7leVMKZ248G90Ed3/8sMKZeXwJmFlUrh7s3lv3dK86SgYJmM
         jwew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JKFJUW5XSbhH7a+LY0HJ77LgR7pHqpp+6Mgb3AvsnyQ=;
        b=C/vv+IvrTkZy4XVrm+rh4BtC6EWKMV0XlevKcxHLQw7PkItulZXz84Gddrt592B+j5
         CMlhLCNzRwghoiO2lydgX5k3XGYAXUv9awpbWBzKiuGsBo7OM4UrODiYAL7hQ0VZnK/s
         SmwHxt4/YQjJ2VVBXI1YCo0SoUkxXd5iRRjVdQUlFBsXbJbz50IUIo2+mA557ctd5xe2
         OIN893BzGHULICxPSQVSrfAaRnrjsmC+djZLGBH2TubA8UZHDsxdRxwVgUwESDToHcQP
         1z/xuk8CnxWxE026WLlUVSzuH8ffOgjXHDRC2DIBkruhw4EbNVomyKlZmTqe8h2Ahqpx
         msiQ==
X-Gm-Message-State: AOAM532Yiioh+aOUtbZzELH3qttTP6nRt5lGBehLAxvAC5D9tuu1GTM5
        JJ8gdAf4EcYQDXCJB7qplRpkZqqOqXR50jrK
X-Google-Smtp-Source: ABdhPJxIK7dw8s58HGdJNZCWPJfwUPIQlbT9wisYCS2sNGmj5Jpw5MUGgOuYkm/Q8hUR0ymLuhcypw==
X-Received: by 2002:a63:150f:: with SMTP id v15mr5429035pgl.38.1637693525600;
        Tue, 23 Nov 2021 10:52:05 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mq14sm2135221pjb.54.2021.11.23.10.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 10:52:05 -0800 (PST)
Message-ID: <619d3855.1c69fb81.487a5.4a80@mx.google.com>
Date:   Tue, 23 Nov 2021 10:52:05 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.290-205-g1c958d9dc5c55
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.9.y baseline: 121 runs,
 1 regressions (v4.9.290-205-g1c958d9dc5c55)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.9.y baseline: 121 runs, 1 regressions (v4.9.290-205-g1c95=
8d9dc5c55)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.290-205-g1c958d9dc5c55/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.290-205-g1c958d9dc5c55
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c958d9dc5c55418ead256636c85f814a263379d =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619d010d78af61e604f2f00d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-g1c958d9dc5c55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.290=
-205-g1c958d9dc5c55/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d010d78af61e=
604f2f010
        failing since 10 days (last pass: v4.9.289-23-g6ecf94b5fd89, first =
fail: v4.9.290)
        2 lines

    2021-11-23T14:56:06.941749  [   20.066711] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T14:56:06.986137  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/128
    2021-11-23T14:56:06.995418  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
