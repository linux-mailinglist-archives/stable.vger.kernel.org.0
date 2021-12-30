Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035A3481A80
	for <lists+stable@lfdr.de>; Thu, 30 Dec 2021 08:50:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbhL3Hul (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Dec 2021 02:50:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbhL3Huk (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Dec 2021 02:50:40 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DB8AC061574
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 23:50:40 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id b1-20020a17090a990100b001b14bd47532so22470341pjp.0
        for <stable@vger.kernel.org>; Wed, 29 Dec 2021 23:50:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LrWh6dWHRZNTYX4+nu1xzIyxufMZ1RlWA88G0iajCGY=;
        b=m8NyOngj/3ukEfS/tH/HWmRzESDLdg3Gr54z6kitSE+0atf2vA68o36hMweStpQ+/4
         v8h6278UHivwyhWphKzzHDFIQozmljdRQLDRychMySMFbQFATN/9KKLyG7PjJkjJo0uf
         EYw9YjTbf9uCcFyY/gx1zAPO6eFvH95ms1qO/aVKLkdCYGuXWlXYAGSBx6aK/hu+avrs
         wQUJqGNWj7lFgJlxZXDhnFRI4qZ485ohWlUH+yw/BvkdNgX42kw/Dl7zfYRk0nP1ciae
         gYGal1zIUcjV7WzrE4/LuY/iFAj1EOnz44NLaGrGRtmRGkYyZfszk+CH3sMwzVn4WMM1
         aqHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LrWh6dWHRZNTYX4+nu1xzIyxufMZ1RlWA88G0iajCGY=;
        b=Jtz5I3LOtyWwzfk5jnIkIgw5VhMzPH9x9Zp0XQXOxENZSrhkS+udc17ynExVQ2PCmr
         3tVYHFfiUfFzkE+hXfyGu49TIk0QRTYEwYINQBcTmcZMsH/e2cZP/5sfE15754t4v0lo
         B71UQVSs9rRRuQMgBdiNLgDHVGVxBGBDvsbo2ZnseQvIcTBTOMEGR1PbAFfWyz1izdZN
         9Q7fkhxeewIuGW9hdnyoUl79hqOHax40VBvHy4NsJ+xH1RypXcrGRFA823Gr2aBsaIym
         AM8dKjWPe+IQ6QP0jEiFLQIRYjNXBOiDL+xINpLOG4fUdGvDUxQsHa9y/NWzWoYPVXAr
         gHeA==
X-Gm-Message-State: AOAM532ZLNTsSzMCVeMSbz/ABibqsxKrb7Je3m2XL0a9b1Za64c5N2Lr
        OGZx/+RtdqKTWmHkj74V81696V8sCwSyorHg
X-Google-Smtp-Source: ABdhPJzU+gsYITOVgyjEM8C6xbCZov2uGpaE0e9Wxq/fXVl6k1xJQObczzO3PBF4tS+9I6TGWpcWEg==
X-Received: by 2002:a17:902:b58c:b0:149:57d2:3165 with SMTP id a12-20020a170902b58c00b0014957d23165mr28117491pls.29.1640850639774;
        Wed, 29 Dec 2021 23:50:39 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a4sm28098100pjw.30.2021.12.29.23.50.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Dec 2021 23:50:39 -0800 (PST)
Message-ID: <61cd64cf.1c69fb81.562e1.f8f2@mx.google.com>
Date:   Wed, 29 Dec 2021 23:50:39 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.294-21-g91e69228d902
X-Kernelci-Branch: queue/4.9
Subject: stable-rc/queue/4.9 baseline: 114 runs,
 1 regressions (v4.9.294-21-g91e69228d902)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 114 runs, 1 regressions (v4.9.294-21-g91e6922=
8d902)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.294-21-g91e69228d902/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.294-21-g91e69228d902
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91e69228d90227f4e3014573d9b6c6ca86381d9a =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61cd2c092598d0bee8ef6752

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-2=
1-g91e69228d902/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.294-2=
1-g91e69228d902/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61cd2c092598d0b=
ee8ef6755
        failing since 2 days (last pass: v4.9.294-8-gdf4b9763cd1e, first fa=
il: v4.9.294-18-gaa81ab4e03f9)
        2 lines

    2021-12-30T03:48:07.851161  [   20.157806] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-30T03:48:07.892432  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-30T03:48:07.901868  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
