Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 031323033E2
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 06:08:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729257AbhAZFH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:07:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731877AbhAZDuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 22:50:01 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30F8C061573
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 19:49:20 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id p15so1251699pjv.3
        for <stable@vger.kernel.org>; Mon, 25 Jan 2021 19:49:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=fZeCIH3sYNKmKOjSGRuL9ueWzWdnVrKBzQuQp93WZnU=;
        b=HACDiJtB1kugc7i2Ew1FMGSskKt+MmOkbxmIYHZGuGBch/cWhzQ+cYhLcwQzHiwSS0
         g7VyROa4PX6K3AEjsd8ZxY9aVBofH/S3TAfb5/jvqNU4vi8fRJVcBzzPvfgcBBvU8cMl
         209thhs18ZggnLQB84c6GVint8+LVqQA8IlwHH9iX/qiEaw74B/uA544afy+zJFjOkQo
         vToIzinNSeSg68YnH4sm54pnqXAzuOnYahTHGbJgVioP5FTJpiVWfdp2CN9+nWoeqjOI
         XvXYrB4Imq9qehWRotCelDMferKnnvd2wWqto4BXdva9Ksq0Y0IGEc2nYKrkr6+TWYbY
         MV2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=fZeCIH3sYNKmKOjSGRuL9ueWzWdnVrKBzQuQp93WZnU=;
        b=hXv/VOZV+UwtXVwl6+4gdPQ/K8OQQncAVzUGovNPyXxrkPAtD3X1Sb2oAmjA5KKxfC
         rj3gFziFVUpEvQO9Q8fpVBJaAuv/FyluGvzOMbLz1jidTwsEUdV9Df5VRrFUffeub5k4
         bYzd8TCDkcXH9HK9foFv8DgbKyX68QcLxwJKRJUdII9yreMKvRrsPo6nMbA3KScoB8Hx
         kolmWvxmWHkrpJn5ClleJzkV9GYjka+Hb8s/A53fwA5t2Cfz0LSCOcBPnzZKKRzlnwKG
         RN5c+2jlIgK4DgaN0hueXkrVB/pqF87zkf/hN2rdgBcHSRTV2v+FexT/vnF/z2SFAzCJ
         ZuMA==
X-Gm-Message-State: AOAM533rTaGgVaKOktA9QTzrYBOG1HeE6zqT5cE2CPxIuUH2xWLAKNP7
        Ruj5y6BhQP0dwbVFTCjxVGY/f5meUIhErBtz
X-Google-Smtp-Source: ABdhPJzmfqFgTeMwcu5YNCXxrAEyeG3mB4dSz8LtjAJn0uRc9NuKyKydE5kuHZyLxkApi8MCo5rheg==
X-Received: by 2002:a17:90a:34c8:: with SMTP id m8mr3774054pjf.103.1611632959906;
        Mon, 25 Jan 2021 19:49:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j123sm19054167pfg.36.2021.01.25.19.49.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 19:49:19 -0800 (PST)
Message-ID: <600f913f.1c69fb81.edf7b.e735@mx.google.com>
Date:   Mon, 25 Jan 2021 19:49:19 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.10-199-g7697e1eb59f82
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 189 runs,
 2 regressions (v5.10.10-199-g7697e1eb59f82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 189 runs, 2 regressions (v5.10.10-199-g7697e=
1eb59f82)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.10-199-g7697e1eb59f82/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.10-199-g7697e1eb59f82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7697e1eb59f825c3808c1f23eaf22eddb7b44ff7 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/600f59b796c0318ea2d3dfd7

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
199-g7697e1eb59f82/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.10-=
199-g7697e1eb59f82/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/600f59b796c0318=
ea2d3dfdd
        new failure (last pass: v5.10.9-43-gd43bfb30a14f)
        4 lines

    2021-01-25 23:52:11.258000+00:00  kern  :alert : Unhandled fault: align=
ment exception (0x001) at 0xcec60217
    2021-01-25 23:52:11.258000+00:00  kern  :alert : pgd =3D (ptrval)
    2021-01-25 23:52:11.259000+00:00  kern  :alert : [<8>[   39.370486] <LA=
VA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASURE=
MENT=3D4>
    2021-01-25 23:52:11.259000+00:00  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/600f59b796c0318=
ea2d3dfde
        new failure (last pass: v5.10.9-43-gd43bfb30a14f)
        26 lines

    2021-01-25 23:52:11.310000+00:00  kern  :emerg : Process kworker/2:3 (p=
id: 139, stack limit =3D 0x(ptrval))
    2021-01-25 23:52:11.310000+00:00  kern  :emerg : Stack: (0xc3addeb0 t<8=
>[   39.416653] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UN=
ITS=3Dlines MEASUREMENT=3D26>
    2021-01-25 23:52:11.310000+00:00  o 0xc3ade000)
    2021-01-25 23:52:11.311000+00:00  kern  :emerg : dea<8>[   39.428152] <=
LAVA_SIGNAL_ENDRUN 0_dmesg 630452_1.5.2.4.1>
    2021-01-25 23:52:11.311000+00:00  0:                                   =
  c349d400 ef7be600 c3243080 cec60217   =

 =20
