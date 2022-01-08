Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E45154880F1
	for <lists+stable@lfdr.de>; Sat,  8 Jan 2022 03:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiAHCka (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Jan 2022 21:40:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiAHCka (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Jan 2022 21:40:30 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDD4C061574
        for <stable@vger.kernel.org>; Fri,  7 Jan 2022 18:40:30 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id t187so6746625pfb.11
        for <stable@vger.kernel.org>; Fri, 07 Jan 2022 18:40:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=v8u45mxAzWFfkRLJ+nNhGCjrN63R6j5zcQwefkjBYpY=;
        b=IghNWqbRLaM645pnBvLyfGqfFmszR8zCk8aEdHohO/lhj5HuJZ3GUZglu1YNHunzG/
         EcAgJ/Rn7eUYAP6ZSYh2H0VdnkNi+8Ged0PNiAwY2kJMf7Do4Nu1BrmKiUtPeaM3JIyw
         NOyLIss72/NEEmWSssDIJOOoCr/q0xC/ATlBhtfLOahZ83I23LHE0xAX9Qk7ztp5X5qZ
         dMqF4R3scES/mgQGQz5q7U/oxoD31XhVVCyUO2tsoeQhZ1IoXcnX184kZVbRl6YnMk7S
         corZRxTlzQftD4O6rKP8XRwtypB3U19BgIqineMpxB9vKGWURAk/VDYhwFnSU74LCOKT
         XgzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=v8u45mxAzWFfkRLJ+nNhGCjrN63R6j5zcQwefkjBYpY=;
        b=ifaN86Y2hCncKUkDFi/I5fMq7uBwpTf3XepEvS54lBRNCr3F/TtYp/J9ryHe5v/Ux1
         cSHbQWXq8tDpp7+nGV3Fi1gRy9XIANcsatUXaqBuENcmswzN8XQ2k3eY0g7yIOhZ8RPj
         T8iOmb5kzB1w6PxgPJ1qXkQzvkx9bhLDEAmsoASsUEf2y09SOgq3waRrM1+PkIS2ycr+
         YyVogHq+O6CY0yByLnn/jxj2aAlSNypD67c6Ji/wOShsHx/jD9Mfl7Trviy2rPbkml2z
         Qi/6j52j0eJAysOx6XXXTOHUIezQyaHlw0A9bDUJk63Kx9Qz7GYozcQK9EdrBJLGI//B
         zmPg==
X-Gm-Message-State: AOAM533vgkmNwI2KexKZurTwpN/HVbWJNhdSzzCG6ZSb5LaQEFgWa9s9
        iqTuhSm1kDUW+SaGCNB0tq1GJIQMQUjJQEgW
X-Google-Smtp-Source: ABdhPJz7kEdUDlbfyRSJgSa1S2/4uhHCQlFtHwq/iBVvMgyHp1J+rV6us3e2rKY4gDd0P/AyruwOig==
X-Received: by 2002:a63:9f1a:: with SMTP id g26mr4300756pge.524.1641609629807;
        Fri, 07 Jan 2022 18:40:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b6sm230623pfm.170.2022.01.07.18.40.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jan 2022 18:40:29 -0800 (PST)
Message-ID: <61d8f99d.1c69fb81.4bdab.12b5@mx.google.com>
Date:   Fri, 07 Jan 2022 18:40:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.224-10-gacc18bbff1ff
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 161 runs,
 1 regressions (v4.19.224-10-gacc18bbff1ff)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 161 runs, 1 regressions (v4.19.224-10-gacc18=
bbff1ff)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.224-10-gacc18bbff1ff/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.224-10-gacc18bbff1ff
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      acc18bbff1ff6f32fe4c5c94806bd8459b74292a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d8c58158d773d6cbef673f

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-gacc18bbff1ff/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.224=
-10-gacc18bbff1ff/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d8c58158d773d=
6cbef6742
        failing since 4 days (last pass: v4.19.223-16-ge86e6ad8a5c1, first =
fail: v4.19.223-27-g939eabea13d4)
        2 lines

    2022-01-07T22:57:53.965394  <8>[   21.123291] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-07T22:57:54.009418  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/111
    2022-01-07T22:57:54.019223  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
