Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E4A43BD14
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 00:15:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235260AbhJZWSG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Oct 2021 18:18:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhJZWSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 26 Oct 2021 18:18:05 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85F48C061570
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 15:15:41 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id ls14-20020a17090b350e00b001a00e2251c8so561928pjb.4
        for <stable@vger.kernel.org>; Tue, 26 Oct 2021 15:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=GPBL5QocSvSsLVsWlQvgP0l2Y8cbvr1LzNfq8kUKOpk=;
        b=sa8XODtJDxOIKAfbJhLqAaZ3mglelq7zgDoaLLbvKbAVnfh5IotMRifozsynl1S5U5
         AqcgIrLufWAd4sEZ7KODUaQWVDBkC7FmJ6u6Sj+8FVUJyNqRXkC/7DD5d331KzuLEiyY
         S3deUl2soJkagrM6hKg2/Z8wlkEYsxCI1KfKminWgDAgUO6zB+kWKnbOFv5Res1Gkn5+
         nKr0kcjX7Lmevfxr9QskFcq8Hxnh3eyAl8D/Q9y3vBy5UBlfT6m2jOVJvHlvbmea5u/X
         kDZNhGyXVTAgc2G5Q87Agr1KI2nTOUrX1BpE0a09dmpeIkeI5OPN7icotBnhquzJLFXb
         Os8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=GPBL5QocSvSsLVsWlQvgP0l2Y8cbvr1LzNfq8kUKOpk=;
        b=LDAxS/gromG8XrFqK7q+fv/ieZzc/blyBW/m7iosp2UgZsLcCZm0BwwO1Sbaq6otzJ
         Xn9S/Lfd7cIiwSQT8fL4LhlCDjyhTurAc5nSWer3GP/cEgvF/DA4485ritJ1Li1PYkef
         5lNq84Qtoa/sdg/uVl1D5uoTFhx5CxM/FoKG24zVgWQWYvzVDEHgvZ8VZlJBiy0QJlUJ
         pGjwPKWoAbk7FL2Szs2IwP4MmB5vxzPgDmQOv0/Yu9NSnYOmdMKRhLgZ8z6uHdw6yOqC
         mOexuq0ajouUmYAEw8NmCfpZ0igYxgryC3X8AJ5vGnFfo1s/SUOnqr2U08GMQ00UOijM
         QKwA==
X-Gm-Message-State: AOAM531sr5YyiCJt8bxQYfNmL0Tfw8ui5WaXhJTBgPjrh0E13ZwMwJDW
        e6OkvMaHoWg4XZlUHHtU9oIrYtuByL+ClEAY
X-Google-Smtp-Source: ABdhPJwx1G92Plbuo/qbvP9YUe1/aNs9CZtTPxEt9akfrNWUfQJZkzdCWog0JF8aKDNP0yXSLToKcg==
X-Received: by 2002:a17:90b:207:: with SMTP id fy7mr1612578pjb.145.1635286540992;
        Tue, 26 Oct 2021 15:15:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l11sm25633955pfu.55.2021.10.26.15.15.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Oct 2021 15:15:40 -0700 (PDT)
Message-ID: <61787e0c.1c69fb81.dd8cd.1bdc@mx.google.com>
Date:   Tue, 26 Oct 2021 15:15:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.213-36-gb94013ec6bbb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 120 runs,
 1 regressions (v4.19.213-36-gb94013ec6bbb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 120 runs, 1 regressions (v4.19.213-36-gb9401=
3ec6bbb)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.213-36-gb94013ec6bbb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.213-36-gb94013ec6bbb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b94013ec6bbbc1627a45925360e3c26e67616a06 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/617846f503260b1a9c3358ed

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.213=
-36-gb94013ec6bbb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.213=
-36-gb94013ec6bbb/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/617846f503260b1=
a9c3358f0
        new failure (last pass: v4.19.213-36-g72599f780657)
        2 lines

    2021-10-26T18:20:21.755654  <8>[   21.110565] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-10-26T18:20:21.799190  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/108
    2021-10-26T18:20:21.808306  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-10-26T18:20:21.822524  <8>[   21.179443] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
