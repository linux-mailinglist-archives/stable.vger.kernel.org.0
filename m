Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21048478CB1
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 14:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234468AbhLQNum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Dec 2021 08:50:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234254AbhLQNul (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Dec 2021 08:50:41 -0500
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0AAC061574
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:50:41 -0800 (PST)
Received: by mail-pg1-x536.google.com with SMTP id y9so2147105pgj.5
        for <stable@vger.kernel.org>; Fri, 17 Dec 2021 05:50:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EPxI38zJo36QH9o0OSrhCpcWNnMeG+Qbl7jEZhBJcfU=;
        b=v5ZRYBev1x2AurQMaDKbFGcFMc2PU2shMlnSF6rf//ELFe+QhU3kiOUpWWeocwSmzm
         5EFsf6gCx3urdMQvSJ1v7ZTrDk4ex7xzWc5dArdrSVdUthqcyMJrZGBGu1EW6UpF1Jup
         pMLdfpeqqyQ392VOhp80VmidwjWQ468egd62kXYtwD5ka0toI2hDvKrwRbYj9d4x32Gz
         KSt3dcgWSuOaCmujn8LkQjZbgl2oKk0P6oXSqnmvMfGN6kKHoCeUaCOH7jUrhPgnEViw
         XAUS/Ahq172bVw3WlPmd5TJlrK0mtkWkpQVXYlWxfR+pustO15dLy0XG5omf44AuK2Dn
         FREw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EPxI38zJo36QH9o0OSrhCpcWNnMeG+Qbl7jEZhBJcfU=;
        b=O0haoMQnOrs3rZ3y02FUhE9Ds9DU1u8MHc5qVQN4WFfnzVVPYalgBST6N9eHEzcO+h
         T7lM7WcblnGDjfNMaumg43CmSyTGpV/Gio+nrP2VBFcj1a13JnALZqoXoasRKt+UIboT
         gsrmBrN2YFFdEVwGds1Vt12su16pG/wdi7Q7+emZNIpG4cS+3+dMFFwFYkyG1UZa8xAI
         UvHJILOxDbTZItjf5gcg7AM5e4Tln8piB5izli6tCS881LCZ6SFo/rhqd+KTSyT8gtGM
         bmO32qJnWaFtUncs2JG51wpouZHL0Our75tVsn/Y7PAU0oD1T6jvJFJM8RuoOPY5usfV
         2uDQ==
X-Gm-Message-State: AOAM531d7GkfEizhis106Ck9ii41XAJRJcPvbYq/qRMYvcw14JJCJOi/
        V/tf5fOxHbTMLbAkpxamtTJaBQzL9fhSzKOC
X-Google-Smtp-Source: ABdhPJyGxiGF8/oMzY02ek6y/iM5qONN60Bb701n3MjSRmxt0KhIZhLEMBlICTF8DtrDhVRZ/EW0kA==
X-Received: by 2002:a05:6a00:1a8d:b0:49f:de63:d9c0 with SMTP id e13-20020a056a001a8d00b0049fde63d9c0mr3088004pfv.79.1639749040615;
        Fri, 17 Dec 2021 05:50:40 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u3sm10721363pfk.32.2021.12.17.05.50.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Dec 2021 05:50:40 -0800 (PST)
Message-ID: <61bc95b0.1c69fb81.70514.bc8f@mx.google.com>
Date:   Fri, 17 Dec 2021 05:50:40 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-9-g941419606e99
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 154 runs,
 2 regressions (v4.19.221-9-g941419606e99)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 154 runs, 2 regressions (v4.19.221-9-g941419=
606e99)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-9-g941419606e99/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-9-g941419606e99
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      941419606e99b755d13e0c7e9c1bcec21a60cd7b =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6419f123a11eb139713e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-g941419606e99/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-g941419606e99/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61bc6419f123a11eb1397=
13f
        new failure (last pass: v4.19.221-9-gf48d5f004d75) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61bc6124da2690865e397171

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-g941419606e99/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-9-g941419606e99/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bc6124da26908=
65e397174
        failing since 0 day (last pass: v4.19.221-9-ge98226372348, first fa=
il: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-17T10:06:13.343932  <8>[   21.136962] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-17T10:06:13.388844  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-12-17T10:06:13.398017  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
