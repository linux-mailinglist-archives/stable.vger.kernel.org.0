Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED4E4423A6
	for <lists+stable@lfdr.de>; Tue,  2 Nov 2021 00:01:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229842AbhKAXEE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 19:04:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbhKAXEE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Nov 2021 19:04:04 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B5A6C061714
        for <stable@vger.kernel.org>; Mon,  1 Nov 2021 16:01:30 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id k4so3218634plx.8
        for <stable@vger.kernel.org>; Mon, 01 Nov 2021 16:01:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Okd+yRn0kaqNo0zPlc3oBBgMozlnomh4dlr3FOJGyWU=;
        b=J/le1+gY3g/ssZU26vI/InFzfHS5UoepAxCth37xfMXvnKKsEku0ed4LGitrGdPBr3
         P7XgLSZXktlM7Ioj+W7yQG3RO9ZGW/+YpY/H+h+h7L6+7nrfawIdEyySJbBYQOUEzyKw
         xzA3/ZI55l3KNZ2XDRXxMMdc7bmVYkB6+5vnUh4ztIU7cX72V7kGuOXEjbDwzakwsxx8
         z+ZEBkSXmJj7wbG7+awt1Ra0W97gCWRoHtPyYRiIne8UduYgM+sygxGu8qoh9rh+afE9
         BTO3R9B32yXZsE7sgVbvwRd4EPyveSOHgWRRLpRAmTNPmD1MsjRpkYydNiPB7FHowB9h
         mhbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Okd+yRn0kaqNo0zPlc3oBBgMozlnomh4dlr3FOJGyWU=;
        b=m7b3gI3OBuVWYE52u3hrBTbCD/dQBHHu6u9BkKyJAzKx4x6/pOfMXpdec49PI5H3u3
         YKrcLwJDbuKUZzq2I9la5veVo4017+WzAnox5LRKIOW/tRrls2BZQoobsIosJ1yiOPoZ
         uvzbbJ4wl627NbZC8vHaYIMdKO6d6kmiKIrRAGSb2YsCJcMY4Fz8m2nziw6fPRt9gbf4
         +IEWsrVC/G1LOAMzWU6VZhU9U24ZjwydhyKfLB83gesTyP0bKLA8EjBQIiOmU7GibbUp
         r9HWLcupsk/zBdg8RZcCRax4xVUa3iuUq7fZtLLyqWRqSXPh5V2idlHtF19OLME7eM6s
         XrIw==
X-Gm-Message-State: AOAM530J7n5AqIPVg3VmaJZvDcR8G0IAT4N2O43MROdQoQSSR4yd04zw
        jmvHZmUHBpmk7OMcufi716wCJRZu+psUKeXj
X-Google-Smtp-Source: ABdhPJzc5SouyHINlSwoAGr8gm+EP/vIf8Bxcr0lKm7AijaOZn++XY7Sa2omM1Yl0NL5vST2rhPJUA==
X-Received: by 2002:a17:902:e5ce:b0:142:780:78db with SMTP id u14-20020a170902e5ce00b00142078078dbmr1049974plf.12.1635807689866;
        Mon, 01 Nov 2021 16:01:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9sm7193936pgf.15.2021.11.01.16.01.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Nov 2021 16:01:29 -0700 (PDT)
Message-ID: <618071c9.1c69fb81.740d1.3391@mx.google.com>
Date:   Mon, 01 Nov 2021 16:01:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.288-20-g17640f20d4dd
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 103 runs,
 1 regressions (v4.9.288-20-g17640f20d4dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 103 runs, 1 regressions (v4.9.288-20-g17640f2=
0d4dd)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.288-20-g17640f20d4dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.288-20-g17640f20d4dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      17640f20d4dd3576f40047703ba45a20e4981a19 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61803cc725eed5396b335907

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-2=
0-g17640f20d4dd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.288-2=
0-g17640f20d4dd/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61803cc725eed53=
96b33590a
        failing since 0 day (last pass: v4.9.288-20-g1a0db32ed119, first fa=
il: v4.9.288-20-g7720b834ad25)
        2 lines

    2021-11-01T19:15:00.679338  [   20.299438] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-01T19:15:00.723012  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/121
    2021-11-01T19:15:00.732440  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
