Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F4DE449E52
	for <lists+stable@lfdr.de>; Mon,  8 Nov 2021 22:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240469AbhKHVlC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 16:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238291AbhKHVlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Nov 2021 16:41:01 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA4D7C061570
        for <stable@vger.kernel.org>; Mon,  8 Nov 2021 13:38:16 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id z6so1577019pfe.7
        for <stable@vger.kernel.org>; Mon, 08 Nov 2021 13:38:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ahC/xI3Eh5yXWxIa7xCmv3KelNhHGvK6GvhHzSLDToI=;
        b=1yUGKHOqCvpG9X0aLRjdq+h11QsF2fGc92UzIKcd/sDAhWsxxlrfXPXsq7BuiI2nLz
         IVuomOdB6+oPDSvCxNrSVVDJkMHB6NhNJa0E/uOez+a+0XOBLlaRFWVCvude/zlkW9T1
         E9kB/ISiNNKOK6BKapydRZLAij5teWg11afL+YcwymfMZWtrVepjCwHaL07FPnjxu3Ht
         SzBLYHXGXmUg4ZbFxLOcLlM7fl+3yTuPuPRTEXqG2GF3e0Rox4/+fmh+9uj27IC1aac3
         kS/nC7IVi8MrfkbKDl8+VGw6ng3GdUsdgbr3p+htkOnP7pd0IErV4wv12K57aZ815iqR
         1Inw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ahC/xI3Eh5yXWxIa7xCmv3KelNhHGvK6GvhHzSLDToI=;
        b=oZ2RhJlkXrE/XtLRdJoqaP5KHlHhSGqrKb0FpHKHGpVsMlGcpr65qhS9dHvk2tL2ff
         uVaYvhLqLlYOHrIfpKnEZvJBEd9+05m4TCao/eM4ExTxTQL756Ecw78hBdvOBGAAR4VA
         640qrD8PMc8g5DlXagb4bhmbALLz4sEe2IJ3XaPqw0/uc3J7TQG00PcH/srcfwtmDb0p
         uVkPtZny72jQcS9eNbqnAxUnCHhXbb9elcFk0Yx+8UiSOEMr09kniZNQMrfPrM+xycyC
         pELxKSWKMnBzZ9qoY1cV4EB5nkFx+Et/tSgfFbKbBPcny9V9G70qUrrgk9RmabJnKY2K
         B3/w==
X-Gm-Message-State: AOAM531GJGWjebkkE2ta0m2MnQsne/k3Ndy+iHzrvUvnCdT8JmJh920U
        1lmvW2aQX7WYEID7FKINnePE9oG9277v3W99
X-Google-Smtp-Source: ABdhPJw7OmS44Hcg4kceGSy/axAWlPIGYcvkUULRaxDovKxEb8fIFD2VKyFEeD7xCuO4Cq8Ix7Ftew==
X-Received: by 2002:a62:8f93:0:b0:49f:ed44:54ac with SMTP id n141-20020a628f93000000b0049fed4454acmr2489177pfd.72.1636407496013;
        Mon, 08 Nov 2021 13:38:16 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id mz24sm260107pjb.42.2021.11.08.13.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Nov 2021 13:38:15 -0800 (PST)
Message-ID: <618998c7.1c69fb81.e746c.14f3@mx.google.com>
Date:   Mon, 08 Nov 2021 13:38:15 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-9-g9f7eecaa70b3
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 208 runs,
 1 regressions (v5.14.17-9-g9f7eecaa70b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 208 runs, 1 regressions (v5.14.17-9-g9f7eeca=
a70b3)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-9-g9f7eecaa70b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-9-g9f7eecaa70b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9f7eecaa70b3cec9afa340bb6f31ff9192aff77c =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61896208264e178a3f3358e4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
9-g9f7eecaa70b3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
9-g9f7eecaa70b3/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61896208264e178a3f335=
8e5
        failing since 15 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
