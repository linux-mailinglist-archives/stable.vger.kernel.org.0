Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92BC84686B7
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 18:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234651AbhLDRo0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 12:44:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385267AbhLDRoZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 12:44:25 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE93EC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 09:40:59 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so7680487pja.1
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 09:40:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HMYRsH3w1yPQOz4vmqUTvAceXmKvNFqY2Kc6YyeJ6N8=;
        b=6EwYP5iYJLxNovcDgDMtw7AwQwgzfqPU9X/bKflUq4Pw33vZxnDCZwcz1GIcfJHfVB
         F2fE8BeuIvk/q4tz/uqokGUYxOKyFHdVldfDrLEBNIKI9ylCaCSpssedZhDH0Pff/qgl
         ibH5Fq7Kson8WS3/7INu2H+OT3TfWu83nsgN9ZMG/CIUvMRheIGuFAN0iI5xYpUg/aau
         XDDyCwsYCMt7mg/RluXx9s7Woc/B+Sqcm0rRUuA3ZLGiw6N6ySGcIyrQ3NPknmfNANx1
         DkVitS6oPDwO2IA5UX0T4pWDW0tOPaSFihsCrd50FOOi4UrqzH5uDbKbGAUksgI2P04M
         xZ2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HMYRsH3w1yPQOz4vmqUTvAceXmKvNFqY2Kc6YyeJ6N8=;
        b=CEZTJDlzosm9aaiE2dAL6aJzAfeJfcOm79/wh3TVbosR3UIFxcrpIq7R0pZ3kmYeQl
         n8i4kKMECEHGBKu+KdXl3BBwWKqDTKB2YLvyMO9I9yBCTZeRY1i1sDpbDY3NayjgzcVs
         2LhnNaMTqCX0yMhsrrgmMZ0LmPGQsPdHeeuzfTQm9fOpGt+WJ3LAwPUWajoZAYx5nowe
         xHVxKvyM3ere49Yf1nfnZg8vsNFNGT6F3hh0MjXRDRkl87s4oig6SkEeJIe93Acztfn+
         sz45BqzoWUdRhtnAfSd7Ghpln4SP4zo7yqQwbJXnelOHDup6RS25iBO72EBXIh2C7KRO
         dANA==
X-Gm-Message-State: AOAM530KIGbSL9fRJ4urLH13N2BXdTZ2Xpv1qw7Q7uEf1F+OzRW7hCfy
        MTy1YJgOhbl8FMMqPmK8hakhYs5CNtHfQSBO
X-Google-Smtp-Source: ABdhPJywiCgd2C51CqFPQz8B73FLM7T1dO7h1pqQf5mZa+ljK0wh1ff0GDMy8Y84IDIie4xrqnf/PA==
X-Received: by 2002:a17:903:2291:b0:142:b53:6e08 with SMTP id b17-20020a170903229100b001420b536e08mr31447824plh.10.1638639659170;
        Sat, 04 Dec 2021 09:40:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q89sm5750797pjk.50.2021.12.04.09.40.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 09:40:58 -0800 (PST)
Message-ID: <61aba82a.1c69fb81.fa6d0.0dfc@mx.google.com>
Date:   Sat, 04 Dec 2021 09:40:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.219-21-g5587cefa484d
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 141 runs,
 2 regressions (v4.19.219-21-g5587cefa484d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 141 runs, 2 regressions (v4.19.219-21-g5587c=
efa484d)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.219-21-g5587cefa484d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.219-21-g5587cefa484d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5587cefa484d1a01734476716ee70d57282a33c3 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ab70aa1fd05dfcdc1a94b0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-21-g5587cefa484d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-21-g5587cefa484d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61ab70aa1fd05dfcdc1a9=
4b1
        new failure (last pass: v4.19.219-16-gb516c2c95dce) =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61ab7108a29581d6b11a949b

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-21-g5587cefa484d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.219=
-21-g5587cefa484d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab7108a29581d=
6b11a949e
        failing since 1 day (last pass: v4.19.219-3-g91f80b6b7a49a, first f=
ail: v4.19.219-3-g04afdf3600b5e)
        2 lines

    2021-12-04T13:45:25.396436  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-04T13:45:25.405975  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
