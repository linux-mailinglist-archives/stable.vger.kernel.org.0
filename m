Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33A52468613
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 16:52:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349513AbhLDP4Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 10:56:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348309AbhLDP4X (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 10:56:23 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A2BC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 07:52:57 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id b13so4201079plg.2
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 07:52:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=F0d6W9W9YZg2lW1AymWFA18Ar4YqXTEkdfZZvqP4WtU=;
        b=b+b+xMRtiakLlSn6N6XmoR27din+3HU53O5YlBQJeytWxBJ2ttU+7PeUZoIemIELLI
         AK5eXBuPpb3Qnq5Ejr9hT8+r1pMYDn9lDfkSs++CduAgGKUlHqYBJF1q3PHIcB+jZy3O
         /I6LjyPJAmkms4koOHNS/csFzpEyEqFkO9ianM45zFkwV9nxi7dIgxJ++0i6z5OHeicc
         Py+yo9tGsgL4UuwIns0woCfefmUqO5JVt8HLTpNVYKSBqKVHghSdsa8CsdC9PvwpsB8H
         I3Hngv3OuUrIe6vmGiQyLsRImFGedrPCX/h3QOnDzaQvTW8FJEz+A8pMSVDn2pfavJPs
         h5jA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=F0d6W9W9YZg2lW1AymWFA18Ar4YqXTEkdfZZvqP4WtU=;
        b=uu+xGTgU+q9yBwP0vtBf4RKUu8aUyxlgYJrKelkV0gP6j8OLEVrhMB9XSucaQNxCtC
         yKkDPU1DbBw46l5gO/wPxBJTB+dDXvQZhgVwOEV7yLVamYWj0VgbJN9wnz/INK5Mhcdd
         rTBpMEfnbawvRBHyndo3vZN8suY5uqN9W3dcR2U+Kq1ybGQYSXswRGu2cFzrXK/KNR5d
         tkSVCXY8gagQ9ZEtWwvAKNxq3ydFFnhGdnJAD6X4IRPthpYlHtxBbn7r+d+jMMKvVq+k
         mxptv24jz7RhB9X5b6tt7XHcoXrm6G6/b8Kxkix3aSpZvor8h7VwdpSO13KONvEIQsXn
         KUrQ==
X-Gm-Message-State: AOAM532mCR2uAnIv4A5Sk8LaEF3dTerGvkI2HZOFkY+a49zNSJAdn/R2
        Ew/UdFqslBNsNiVyzYdgO98rohSmtdO10vtX
X-Google-Smtp-Source: ABdhPJyw0Ljn7SUSaoUXirg/iD77WMNdQWPcYqcvGvzTXCs/fQlWy/SlkBkAxVZciOHC2nQfrHWLhw==
X-Received: by 2002:a17:902:a40f:b0:143:d470:d66d with SMTP id p15-20020a170902a40f00b00143d470d66dmr30724210plq.52.1638633176703;
        Sat, 04 Dec 2021 07:52:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h6sm7925002pfh.82.2021.12.04.07.52.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 07:52:56 -0800 (PST)
Message-ID: <61ab8ed8.1c69fb81.77a1d.5d88@mx.google.com>
Date:   Sat, 04 Dec 2021 07:52:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.293-43-gab8faa58fa97d
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 83 runs,
 1 regressions (v4.4.293-43-gab8faa58fa97d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 83 runs, 1 regressions (v4.4.293-43-gab8faa58=
fa97d)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.293-43-gab8faa58fa97d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.293-43-gab8faa58fa97d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab8faa58fa97db0ecf42f09c503c2e5069bf9a7b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ab575e987e850a2f1a9482

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
3-gab8faa58fa97d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.293-4=
3-gab8faa58fa97d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab575e987e850=
a2f1a9485
        failing since 3 days (last pass: v4.4.293-33-g845bf34b777ca, first =
fail: v4.4.293-33-gfe2c5280cbbe0)
        2 lines

    2021-12-04T11:55:48.844404  [   18.915039] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-04T11:55:48.895027  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-04T11:55:48.904059  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
