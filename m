Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CEE244F59B
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 23:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232791AbhKMWJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 17:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbhKMWJf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 17:09:35 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA43C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 14:06:42 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id b68so11489745pfg.11
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 14:06:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=YHG6q5e5fHM2nytcCSDXoAqw49ABpImEw168+oGZ6o8=;
        b=6E8nRQYqJV+BFOeT2FfySJN1rhwJGlnngA8K3R/R9zLOZp/Mo2Lb0v12GsMow4YWxQ
         odY1AaDeO444YN1H2XhyXZoOLMeprqdw7JcjWqf56dqXmL8yIj/t0l4YL5bHiGHlHlhP
         +avMXBRLvb1Ia1S2ASqI2aGL3xKiG49Z7FRv3rj2zTE2CwmA2cgIP3uzjY/F+yIadqKx
         n+b3ofzGgYSrkikL3B75o3Fn5N0SKm6Pw67uNcQVDqftWw08Y/AyL6hRU3bz562Zu4Ns
         /AQBV90Q7mG5PLUuBgY8imylQu9IiRPBXP4rp5n0r+4ft+HZPk4BaEfSokIwbaWuq3xI
         9zTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=YHG6q5e5fHM2nytcCSDXoAqw49ABpImEw168+oGZ6o8=;
        b=QYAkuq9KMSeRjhAqNA8jS5lM0pj9jjB4KqTH/cDlH97oV3nHZy32v3lpl1cU9HD/0O
         HNqhfKOVUMAXn3jPjg7LcS7zotVrPGIV4BAuq5zRpiUGdXEcgpQq/ss4rtFrigvyclyK
         ioPKRhe7wEksbA+g059Bh2EIun4zkW1kTS1vY3zxPXJ8hM0+W8H6gLe0yGT6xpwvCABc
         pnpMoT5LCHVqh7CotxAP1lsIFrddIDPa3HLSrgh0q+v7J9SnW1YgI/mOu9l6jvgBRUbv
         aANWK9AJ7kkhXpuZrQPsxSEocebu3PW2wwNbTTst6SPOzIgGY/VImm0PvIoWCDNPgZNg
         6jeQ==
X-Gm-Message-State: AOAM5317/gT7/qSaTNPNzR5TRMQ168IuS74p7K4HF7PB9TRCwLXxe2mH
        XCIi3IfYfhNqOzUq3UoV8kbnuKEbU+eYkePh
X-Google-Smtp-Source: ABdhPJzCoe2KjQdP1HMtf21rVyTGWCgLPdY2XjwBs+eDpVCgOxCmA/fq1Sf4vsGTLTO2vU3Q0FLSiw==
X-Received: by 2002:a05:6a00:170d:b0:4a0:c6a9:622b with SMTP id h13-20020a056a00170d00b004a0c6a9622bmr19920799pfc.41.1636841202222;
        Sat, 13 Nov 2021 14:06:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w7sm7979045pgo.56.2021.11.13.14.06.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 14:06:41 -0800 (PST)
Message-ID: <619036f1.1c69fb81.d3bfe.7383@mx.google.com>
Date:   Sat, 13 Nov 2021 14:06:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-53-g91947c5ae67c1
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 117 runs,
 1 regressions (v4.14.255-53-g91947c5ae67c1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 117 runs, 1 regressions (v4.14.255-53-g91947=
c5ae67c1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-53-g91947c5ae67c1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-53-g91947c5ae67c1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      91947c5ae67c12dfe8bfebbc7e1ee3c4d481eabc =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618ffbd6c2ea0ec5203358e5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-53-g91947c5ae67c1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-53-g91947c5ae67c1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618ffbd6c2ea0ec=
5203358e8
        new failure (last pass: v4.14.255-31-g6c7702079927)
        2 lines

    2021-11-13T17:54:11.850516  [   20.079711] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-13T17:54:11.891900  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-11-13T17:54:11.900799  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
