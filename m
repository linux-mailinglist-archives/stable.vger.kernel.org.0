Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAA8D31B378
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 00:50:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbhBNXuC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Feb 2021 18:50:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhBNXuB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Feb 2021 18:50:01 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54B0BC061574
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 15:49:21 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id z7so2744329plk.7
        for <stable@vger.kernel.org>; Sun, 14 Feb 2021 15:49:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=3AQ3QzsPS4Gnwmcsr/R6ptolVAEpat4T5dYWPScM76Y=;
        b=2MoxO87C4rmoE9//djh7qoMZCRjd2i1WPqU2IhO8pmiU0AsvxugjxkzmTpZlvkc+Qa
         PpQc3gQuYL7x2eZYDp9Z2nF56u5EQlhCS1NeEKcOJkV5QPT8wITQQCion+3rGs9f24sP
         ab5dQOnbTCevWEIV0krmbP3sN7/Qa64MZpPLBNl5KfLZZu3tiZptdixjRQEbWLLPHNCP
         fjj/hS+gAuDqoi1sSOpP3Cb47jW8WZIT0eSOKLu6HJiX0HRymG9Hi4gwmUgl3N445UjS
         /bZ0Uc3dIyd8cnUu4N70ezNRl64B6zFCVP2YhDP8EE+ckekyMdFu7xIYMFN8/II6W7AM
         sTzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=3AQ3QzsPS4Gnwmcsr/R6ptolVAEpat4T5dYWPScM76Y=;
        b=tRxx/p596MoA7IEBD9VRKVCC3zrLMx3266n2FZ55qJS3RjsoNN3W13WS2d8J4aZp8G
         JrfeveVoYbKm8kdtPyCI/QJZtuWDJG3FfrlHe9OvONk5ao50+NmO6fg1nELVuPgIa/HP
         xaqqVxFAyyrUBQJ4ZZGYmiTDhGHQJdwWD7H6QZQtdsV9eV8ntAw11WbCnFaUFwgn0MPB
         y9mCmZte+J2UbTprToYWb9Z+r5DN7mVrVJH0ByD0YlFyjJ5jvzht2LfQ2FN2W4TiXIL6
         ixp8BPYfWi0VnZlcUReNudI0+0R3c/IMKmvbnnZbPn3f34wQZw5Hk0hYsGTKiHOdiOch
         riNQ==
X-Gm-Message-State: AOAM530g8Wc2OpLr/YzQTT1gfkbx11/Bf3kbaHmxne/NCgpMz0TlHi9X
        Dnf9fagaASBDGXMtfBFTLAz00bNnjfDLdw==
X-Google-Smtp-Source: ABdhPJzXZahrLHf6gB47PMgSAESGKy/hDYClWjq+Tktlu8zZDVLI03Ysipym02cJRDVobp0o9sxWVg==
X-Received: by 2002:a17:902:b206:b029:dc:1f41:962d with SMTP id t6-20020a170902b206b02900dc1f41962dmr12998110plr.28.1613346560625;
        Sun, 14 Feb 2021 15:49:20 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id v26sm15295106pff.195.2021.02.14.15.49.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Feb 2021 15:49:20 -0800 (PST)
Message-ID: <6029b700.1c69fb81.1cfd6.14fa@mx.google.com>
Date:   Sun, 14 Feb 2021 15:49:20 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.176-15-ge50fb963e438
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 52 runs,
 1 regressions (v4.19.176-15-ge50fb963e438)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 52 runs, 1 regressions (v4.19.176-15-ge50fb9=
63e438)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.176-15-ge50fb963e438/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.176-15-ge50fb963e438
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e50fb963e438431b0f14936a45feb3b5921f6bae =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/60297fa495e01425693abe73

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-15-ge50fb963e438/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.176=
-15-ge50fb963e438/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60297fa495e0142=
5693abe7a
        failing since 6 days (last pass: v4.19.174-3-g9df30fc2980a, first f=
ail: v4.19.174-9-g72c4313237ab0)
        2 lines

    2021-02-14 19:53:03.368000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/100
    2021-02-14 19:53:03.377000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
