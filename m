Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 505EF49AA23
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 05:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356842AbiAYDec (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 22:34:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350390AbiAYDXe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 22:23:34 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB4D5C05A19B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:46:51 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id v74so14385378pfc.1
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 15:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EEdHs1gw51S0DW/gahQoxnCJHiR8ASF5cof83E7R7gs=;
        b=6E6c+bAhNKy6kVgB/sszB9LajBnvXAw4mq2LvIKZzoBrfVlZofe31hYg4IpBfbU9n8
         7gKSmj6PCY0H0JBtxaL6UrVfi/8uET1KtVesJmhu7b0Y1kkXli1Qa01ZnJWo7wDqTcI9
         DkRzM0JgkHHuAGIo6nwuTjZKfB32M1lvDOxTQ4EDR/Xi5coaBrDhSWvFOzMdONfuCOed
         Vqve3S72NjQ06F2NPzR/X1+pUXdAnBET6Uty8I1Q0PRs4KCWXAeX+VGzYGQ9jI3kMxRe
         7E7X6nV2LN5LGgRwWia/Q+2wxEuJ6jIa5aZ+2OgXXPfwFcTIIud4gmy8BoYFUOnqDonX
         dniA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EEdHs1gw51S0DW/gahQoxnCJHiR8ASF5cof83E7R7gs=;
        b=e2C9ncXgYLQ2MM96U9NXQ4XnBKdtIvfAWPcdDOn/FV30xKhyJUlBCNt5hAuprUnkYc
         1RDL+c7Azml0PAceSTV+e43ELzryor3/WNBg27iM4GhU0V404LYEAzTZoHDTUPpE1Vqe
         YFhD9wIQufTvA8kynmD081fpXmac+6lOOuMjZWZ5jfl3Gn1NX+aJffEbJOsBDpSCy1n+
         AjMDLiBJeDO+vOZIOtJwkGCqAaivkDOt1sDnb+GWTohA7nhDN6tCR9eSG5uLo18589Qs
         ToPz3bn+j75Z5C7AHk0qIdEgpN0Ffow9pXGBiPBTZxqOLRMGomz0S7RKgFFPQMrDrat6
         0EGw==
X-Gm-Message-State: AOAM53117C5DWRBXqHShV029FPlb1TB4mRc9TklRlviNgecOAwwYtVnM
        sb35QF4T2Cwy+5rwdgLAWNlzvFxo6wF1Rzoq
X-Google-Smtp-Source: ABdhPJwABOwgQK0LI2v3QhDzKJ9C2CgaySdwZNrxhZdE/t7AQhyQoXdpvcWzixNvyQZMKnJqmsdr9g==
X-Received: by 2002:a05:6a00:2494:b0:4c9:f16b:3e37 with SMTP id c20-20020a056a00249400b004c9f16b3e37mr4003272pfv.29.1643068011284;
        Mon, 24 Jan 2022 15:46:51 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5sm17179245pfk.172.2022.01.24.15.46.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jan 2022 15:46:50 -0800 (PST)
Message-ID: <61ef3a6a.1c69fb81.7d462.fff0@mx.google.com>
Date:   Mon, 24 Jan 2022 15:46:50 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.297-150-g86d4516a7d68
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 117 runs,
 2 regressions (v4.9.297-150-g86d4516a7d68)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 117 runs, 2 regressions (v4.9.297-150-g86d451=
6a7d68)

Regressions Summary
-------------------

platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
d2500cc  | x86_64 | lab-clabbe    | gcc-10   | x86_64_defconfig    | 1     =
     =

panda    | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.297-150-g86d4516a7d68/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.297-150-g86d4516a7d68
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86d4516a7d6873803aff67c8aabf02c4fd37f8f6 =



Test Regressions
---------------- =



platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
d2500cc  | x86_64 | lab-clabbe    | gcc-10   | x86_64_defconfig    | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61eefe2cd9c504df4aabbd25

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
50-g86d4516a7d68/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
50-g86d4516a7d68/x86_64/x86_64_defconfig/gcc-10/lab-clabbe/baseline-d2500cc=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/x86/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eefe2cd9c504d=
f4aabbd2d
        new failure (last pass: v4.9.297-124-g1de5c6722df5)
        1 lines

    2022-01-24T19:29:38.589367  kern  :emerg : do_IRQ: 0.236 No irq handler=
 for vector
    2022-01-24T19:29:38.600948  [   10.777392] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2022-01-24T19:29:38.601323  + set +x   =

 =



platform | arch   | lab           | compiler | defconfig           | regres=
sions
---------+--------+---------------+----------+---------------------+-------=
-----
panda    | arm    | lab-collabora | gcc-10   | omap2plus_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/61eefe99eb45e069e9abbd1f

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
50-g86d4516a7d68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.297-1=
50-g86d4516a7d68/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61eefe99eb45e06=
9e9abbd25
        new failure (last pass: v4.9.297-124-g1de5c6722df5)
        2 lines

    2022-01-24T19:31:25.773978  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/122
    2022-01-24T19:31:25.782915  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
