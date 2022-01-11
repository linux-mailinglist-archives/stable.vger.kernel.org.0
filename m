Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D3E948B636
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:56:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245605AbiAKS4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242717AbiAKS4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:56:54 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9199CC06173F
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 10:56:54 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id c14-20020a17090a674e00b001b31e16749cso6985929pjm.4
        for <stable@vger.kernel.org>; Tue, 11 Jan 2022 10:56:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AC6NtK5GPBsnHfh7acHQTbl+w6O9Cs58eaIeIJFL+4w=;
        b=nCCtv4fJeimv3WFSk4AdHYE4Z0vlCLRRUkqWoc2r6OANp9NkFy2LOWQXHJhe0PxCXS
         OtrqQ+q+97PJjvzYRgRThDOzzgtPRCb+hP2CVaCBhKKc8ul1YFpMYEiuMEEiedWNYe2j
         SCb9P/EBZmn1qUpek15g4SVnEFKipKp0KrTYG+nfTHkQ6vst5BrQJ75UuXYfWoGvQqGj
         V02DUPvErsWlRr2kiRizzS+CvhAqpBWlzH8XxNa1KYquDbzMivrH3YqSt6OLUh4XHUkR
         G5KXdNtCQLSwWsbzWP9nlhPJCouBesSP82vD1jc/LiqlXWFKylByWsJQQ9A7qNuXOWyS
         E42g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AC6NtK5GPBsnHfh7acHQTbl+w6O9Cs58eaIeIJFL+4w=;
        b=iMifHmhhbIwps6+5qhvmVg2MkJm0LRZpe7peKvYK2CwbXz7zkih0sbmkGaMtc3r9i+
         IZgc2+Pj9x45R4H+/xa9U2hJ++M4QUlorzHxAZpoHfPPII6URGb1kJZ1W1bVcM6l+K6Z
         HOPcIyWkSAc5gfkBIq2EtgvrwkS3vzzCRAfZNRQM2Pr/IOxx08yhKtQ5fPZ77gHXF/ac
         av3gK12duK6hkwUAda5rsle97/zma2j9EKktNl+61X/maRolOUNRL7kHhMeYgxs1HyT9
         YiG5oZzPjMMwjFBr0ZTW1QfuUxzDwYME0RhhYBnOP+Qy3XwaEj8Cqlj4nTjUcZFB+ktO
         qTCQ==
X-Gm-Message-State: AOAM531OweRbwRLmpT+wADefnOGlAvNk7jEmFnbh+fiCVEDxgxHOfDz7
        PrigQCUmzz5SLkMS7gtTG8+2XrSJ+pRVuwZz
X-Google-Smtp-Source: ABdhPJxAG+tabp/2xkAi7ILViNfC6WaEeSPhY9f3pYbhwsRn8OlOKpA3OLPCEMiWkhB0ZEvkUIOw8g==
X-Received: by 2002:a17:90a:14f:: with SMTP id z15mr4548373pje.162.1641927413925;
        Tue, 11 Jan 2022 10:56:53 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f13sm11860000pfv.98.2022.01.11.10.56.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:56:53 -0800 (PST)
Message-ID: <61ddd2f5.1c69fb81.db520.d96d@mx.google.com>
Date:   Tue, 11 Jan 2022 10:56:53 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.170-34-g0f6f6defc80e
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 182 runs,
 4 regressions (v5.4.170-34-g0f6f6defc80e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 182 runs, 4 regressions (v5.4.170-34-g0f6f6de=
fc80e)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.170-34-g0f6f6defc80e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.170-34-g0f6f6defc80e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      0f6f6defc80eac5fc2fd520b0399490af6d7af43 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dd99e78298c67790ef6747

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dd99e78298c67790ef6=
748
        failing since 26 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dd9a098298c67790ef6762

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dd9a098298c67790ef6=
763
        failing since 26 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dd99fb985dc4a3cdef6751

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dd99fb985dc4a3cdef6=
752
        failing since 26 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-broonie  | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/61dd9a082e696523a7ef6754

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.170-3=
4-g0f6f6defc80e/arm/multi_v7_defconfig/gcc-10/lab-broonie/baseline-qemu_arm=
-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61dd9a082e696523a7ef6=
755
        failing since 26 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
