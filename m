Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E12C4DE3DE
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 23:03:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238382AbiCRWEV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 18:04:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236473AbiCRWEU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 18:04:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBEA5632C
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:02:59 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id z3so8117835plg.8
        for <stable@vger.kernel.org>; Fri, 18 Mar 2022 15:02:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=N9DDX2KJGuxLQfUf76KnLxUPm4qRlaG7lTYT6EDp1vU=;
        b=C56kH9Bwo+Xh++RvLpbhflXl16Vth9lZrSH3rNPv5RfYgBdSwm0RnnqqSdxN0OcB+P
         tjcqlzUexZBPzuovmkIj7WEsG1qPTqSj6do7pqGFNxgvvFQuadaHY6FwzkwKOUtdEstG
         4KDXWnGOOgtFojtR4X03MwQ2j09UWPt3Z4P+qsvhMns2r+/EAI9A+ZEd1fOPgIWh3bgX
         bOeZotTsAK5MTVDI/SD/f4WwIVgzOP7L9GNpcDCuqyYDvKqdkv9isGiJ0yI4uXrOxd0s
         /lTFAUm4jf3e4W+ojk+pBNwC9horSmsa/6EyL6G6yn+QXTkbB+vMtU215f3gY7brm7Ms
         oWoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=N9DDX2KJGuxLQfUf76KnLxUPm4qRlaG7lTYT6EDp1vU=;
        b=RoI0lqOYwh2LoJV+7faICSVKY67lgD/0HTWjVgrcKl3gVDrkO7o8GtP99Ih/9DhLBp
         YyYtXHY/RDOgifzxMucdbTfylSJZGK2pFzTBCbZ9ZFCUoQ7D3o/7xgAGaZttEcQE0wAY
         KjFbFxm8qIjUwHK5QX4wdxjynCA+wVtfhf7IFwvAodfW8PpBKHKQwFArztLJ2DnuVWsK
         N4DkjEfnanqIEh7c3JdjUFI8S3rpAmKWz/V5Z4cwWXWnvQ3xIT9i02t4ujxyBbEZAahb
         JKNh0+Yhx19RWdgaJuWu9Bef2kck2eNo6lXoCfFkDMD/QUtFYXBIxgVNA5tCMex0dB+s
         7EPQ==
X-Gm-Message-State: AOAM5333z5nY623qcuvUj793MsrAjYB/sJxDzhkENvPdzAvbyjTKwVzR
        /lhwW6qirZqZFAqKoXIWgx48jW2CoI8zAUmtq0U=
X-Google-Smtp-Source: ABdhPJwEAZ+ky0wHlXSbUF49CkAjOljbVPJgk2U3+GjI6oMbdVDppWdzG4nWItwWzOC8SrmpU+LKAQ==
X-Received: by 2002:a17:902:b410:b0:14b:e53:7aa0 with SMTP id x16-20020a170902b41000b0014b0e537aa0mr1578754plr.101.1647640978953;
        Fri, 18 Mar 2022 15:02:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id nl17-20020a17090b385100b001c690a0df82sm4871963pjb.23.2022.03.18.15.02.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Mar 2022 15:02:58 -0700 (PDT)
Message-ID: <62350192.1c69fb81.a7fa1.d30b@mx.google.com>
Date:   Fri, 18 Mar 2022 15:02:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.4.185-42-g1476905224034
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
Subject: stable-rc/queue/5.4 baseline: 63 runs,
 2 regressions (v5.4.185-42-g1476905224034)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 63 runs, 2 regressions (v5.4.185-42-g14769052=
24034)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =

qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.185-42-g1476905224034/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.185-42-g1476905224034
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      147690522403454e2f223ee77d99ddab282394c6 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6234c981095494ea9af8008b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
2-g1476905224034/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
2-g1476905224034/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6234c981095494ea9af80=
08c
        failing since 92 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6234c96de784cbf113f8009a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
2-g1476905224034/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.185-4=
2-g1476905224034/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_a=
rm-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6234c96de784cbf113f80=
09b
        failing since 92 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
