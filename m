Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 421E242FE7B
	for <lists+stable@lfdr.de>; Sat, 16 Oct 2021 01:04:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235599AbhJOXGK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Oct 2021 19:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235596AbhJOXGJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Oct 2021 19:06:09 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 863B1C061570
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 16:04:02 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id i5so1044430pla.5
        for <stable@vger.kernel.org>; Fri, 15 Oct 2021 16:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=O4LsF+yZ5yWUrTAx5ykYjBHomJ4Agh9cFNxcd1eIDRo=;
        b=nyVBUi7tM//8ngOFvOyU8zk25nJD1EY/z72f4tcrhSuAvoITHKOkvtifbIoofhZPXo
         tOefWKwZYRcUFF+iQ6R5WnjeH9o2o6abacMluIjjnGMitPtTxAqtJJxumqWKaAIzNE1Z
         fI59BBmxVmLoF9dJjNHho9kldDFxgjd+sliM9N+QLapAoIQHh/7ckQe4odNhKyzGICsi
         rd9NSY+uNT+OpzyzdWi7ctadXP6RHe5BM41y0uzcMrAwsaYmDH1om+eRVqhlZ3J5QWyb
         5IkvacOsi5V6RQL5nDbJx8Jp24+srY+pGQ+tMuCjf1BCgFWFuMlwaTTWITjMQU7cXZMR
         QlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=O4LsF+yZ5yWUrTAx5ykYjBHomJ4Agh9cFNxcd1eIDRo=;
        b=ADyO4urKZnbKGt4HaQ0QqkwKGO5/JmNLGLvLQN3Vt1BjK9pJllPjW/GGIZB6EzF0zf
         Dt1/1TvsIY3z9/Kga9FfTkioIbivngeK4d+sbEYLzoTb9PMvuWmVz7ya2gJ+KWr76XjV
         pyqFQagAA/NxtagoOf194+x+XDh1p9Edi2gvfSSTAUlBxREErWjUWpppV1WW2bi9cj1g
         xwRO7L6KNNOsVsnemWUJGVyYGEKrS0riuY5FI49MsFxCd9deWfDf7WqSbTkva36DDM3Q
         mHufym1/1wbplfyTG84vAGcDye07QIKJ9vcn1I5od7xdqh9HyjRNkN2HiZjIhT9axwze
         O30Q==
X-Gm-Message-State: AOAM531cGL1E71L6O7VPj0ZWt6UMTacA8Dnugax0U4tNjcoxfqPlIzkQ
        mtrqbiYsuhBbVzAJxOFisomNWJhCxZ2tTw==
X-Google-Smtp-Source: ABdhPJxPGR1u7vOLoO/h6Qj+2ybhTT+dAi2tgRNVUnSPVic2+X1QDwHER9DaU9hPjk9DRD72VHtpCw==
X-Received: by 2002:a17:902:edcf:b0:13f:165e:f485 with SMTP id q15-20020a170902edcf00b0013f165ef485mr13524551plk.58.1634339041787;
        Fri, 15 Oct 2021 16:04:01 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id i124sm5983308pfc.153.2021.10.15.16.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 16:04:01 -0700 (PDT)
Message-ID: <616a08e1.1c69fb81.67df4.2f13@mx.google.com>
Date:   Fri, 15 Oct 2021 16:04:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.12-29-g6a43b9157469
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 39 runs,
 1 regressions (v5.14.12-29-g6a43b9157469)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 39 runs, 1 regressions (v5.14.12-29-g6a43b91=
57469)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.12-29-g6a43b9157469/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.12-29-g6a43b9157469
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6a43b9157469e344ff814de59e9f0499c988df2a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6169ca08a859be1a3d3358f2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.12-=
29-g6a43b9157469/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.12-=
29-g6a43b9157469/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6169ca08a859be1a3d335=
8f3
        new failure (last pass: v5.14.12-30-g495ee56a80cd) =

 =20
