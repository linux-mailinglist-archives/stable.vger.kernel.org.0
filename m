Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B6114C55C0
	for <lists+stable@lfdr.de>; Sat, 26 Feb 2022 13:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbiBZMA6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Feb 2022 07:00:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbiBZMA6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Feb 2022 07:00:58 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF9882D34
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 04:00:23 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id z15so6964977pfe.7
        for <stable@vger.kernel.org>; Sat, 26 Feb 2022 04:00:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XjUcpP5KU5vAkQwlsxM6cS/fl5JH0NRKPI1B2nKxXaM=;
        b=ljS3+7waCOYX3cxtRufo1Z7EJ6LQjzyYtEHS3EaDNmaBohSi2361iXtKSHpgXrZ5Hi
         351PiTvqg2aGp1G/auZDUDPIZHPAz6gdtBOZ8aVuLk4q6ARbTu8H5ZlriZIqQ7tJ4kpn
         d7RhBfJOgQI72jixID85GQvN4pOnC5oUWOG+oRp3bl1FDmonGur/Y7jvPjJIyexz7mnQ
         3KfP5Ji9loSQDmFTt+ly5GfaraSJuCXaiWp08m35e3b0veGg+x3WL0V5U16gYlnEHJ52
         WhvVztkQYiB4upI9Kaaa91MvxjcbXz7c+vzNHkIwU/S5DP3BdSVrQaCfeMEPtM3gWfl3
         mIMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XjUcpP5KU5vAkQwlsxM6cS/fl5JH0NRKPI1B2nKxXaM=;
        b=zMF0YqEpWMmeIRTEJJSDVw41wZSndDUah1qk4xPfA7JR01u8nATf+VgWcmozaNTgPV
         WWeyLcZg0Qkgrt8pdY8cGhdtFjz/cgvSRtIzGm2fvOwgupAuoGBtG1T3qFChB32aJuZ8
         2aW5aTINyJLV3f9P7j16RGf3IYK/uT5Ag7RuOh2CytGpW0PBm4vdXW9G98HYaNf5F2m4
         P7685Ostb4pk/ogmfvMnP2uKUbNdweVMigv05MEgpB45u/yQ2iJpOVHgO7v9AMPs25du
         LyRMvhWH3AO54p5PXBpM8yX0ntmsU0mquJdXWcRHGFF5pL6T/YVO1pTplrqdOp5rWfh8
         d8VA==
X-Gm-Message-State: AOAM5312p2ecL4M5ze2TOUqoffqk6BpBAbQ1v+HIkGFiwlw1AiskiKqR
        UGR/oJQ6Xx9qGDHQA/FWu3OxiAShMZfga7DOf9I=
X-Google-Smtp-Source: ABdhPJwktqnQbGm0iZbxF0BebwFppOTZq/GOga7gbvo/hjMLnSL/DmgiKAlTuk8eBdx4LdDat7aXiQ==
X-Received: by 2002:a63:9311:0:b0:372:710e:2263 with SMTP id b17-20020a639311000000b00372710e2263mr9744556pge.223.1645876823276;
        Sat, 26 Feb 2022 04:00:23 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3-20020a17090a5d0300b001bc2b469051sm11756887pji.29.2022.02.26.04.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Feb 2022 04:00:22 -0800 (PST)
Message-ID: <621a1656.1c69fb81.b9c08.d826@mx.google.com>
Date:   Sat, 26 Feb 2022 04:00:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.4
X-Kernelci-Kernel: v5.4.181-31-gb33d1cb14e5c
Subject: stable-rc/queue/5.4 baseline: 99 runs,
 2 regressions (v5.4.181-31-gb33d1cb14e5c)
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

stable-rc/queue/5.4 baseline: 99 runs, 2 regressions (v5.4.181-31-gb33d1cb1=
4e5c)

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
el/v5.4.181-31-gb33d1cb14e5c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.181-31-gb33d1cb14e5c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b33d1cb14e5ccf2ed4dde8e73b195b8cc51d663e =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv2-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6219df13e6fd49e511c6299e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-3=
1-gb33d1cb14e5c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-3=
1-gb33d1cb14e5c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv2-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6219df13e6fd49e511c62=
99f
        failing since 72 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
qemu_arm-virt-gicv3-uefi | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6219df15ccf63594d7c62968

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-3=
1-gb33d1cb14e5c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.181-3=
1-gb33d1cb14e5c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-qemu_ar=
m-virt-gicv3-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220218.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6219df15ccf63594d7c62=
969
        failing since 72 days (last pass: v5.4.165-9-g27d736c7bdee, first f=
ail: v5.4.165-18-ge938927511cb) =

 =20
