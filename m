Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E2F932AECC
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:10:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235864AbhCCAGF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:06:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577534AbhCBGXn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 01:23:43 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73576C061756
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 22:23:03 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id e3so9177913pfj.6
        for <stable@vger.kernel.org>; Mon, 01 Mar 2021 22:23:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/7iBQq7AWRP26J8tF+W/CWrwNF3Ssu7JUbCLYimzWvU=;
        b=lzhK56CQdiHqYDbHjhbw6Uka5/J+VsEeJ7EaPRS+vtobt3PsXkIN8XoOWWjyqrzN6l
         Ty3FvJ+jyLZDd3QMJiFOvXjtqINtom2DVqkPeGNHK3g+hCd/m6xEvBvYh0rCjlBvfh0Z
         2gpQzF982XL3zQ4IPTxBIpP+xqMhkUrcx1AP8yLj2OfqjPx+7Z9vJ3GvNSqa6TTvZFl2
         AvA6JWSt2aJXe1Q3fC2EiNyjToHzFmY9P2w8LG97FUXOnELbvQ6rNw5kkfowOAgd4I1d
         lWwR7bkc8eI3q3d1qotMznndZXFH9Z9l1+I49wKQqGYRo619gzG+b/A4VvkhohCJozqT
         PByg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/7iBQq7AWRP26J8tF+W/CWrwNF3Ssu7JUbCLYimzWvU=;
        b=IQJxbsSTQu0HiSbukBGn9jQzaVkQ4UoGfPuUalD1GBgixLlNd9Isv56V9vgtEwMGAR
         l1gEKs/xQN+OT2fZU0Yd0znvv2+Qi+Huie3/BYkrOv+m4gV/PZLBdr5Cx9fsoVrgl9wZ
         QmJcYpINDKGxOpTHPq4QJ6LNBb9m4957nIHJCDn4fni4Y24YtDgOOqv9lCsYnc9cruW1
         4yjb7dc0kMhfY2t4XIkZmOLk9YilKwU+7R5pMjteFLjEuUjVlv2DVeEHiofhq6L2jF6O
         kOqfq91VccozWObz4sBOXOQtxC05DFXs7tUsWZOwyfimiMRpHSnR6mGNvOzFOIC10SQ1
         J3sw==
X-Gm-Message-State: AOAM530rumVe+Ip0M9jwKY4KXOIJfyJyrHEW5ICAMoVnDST6sVvD/gVK
        wxW6xkJtx4m+FMmpwRaiPHnbobnsYgltBA==
X-Google-Smtp-Source: ABdhPJytqIHOJREE25+VjiQBRKjGJNKb4d6UAFGoFk/lC/8ZdjkD+sS5wIzac+MhZjBwY9hz0upnVA==
X-Received: by 2002:aa7:8ad5:0:b029:1df:5a5a:80e1 with SMTP id b21-20020aa78ad50000b02901df5a5a80e1mr18473283pfd.52.1614666182643;
        Mon, 01 Mar 2021 22:23:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z8sm1582233pjr.57.2021.03.01.22.23.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 22:23:02 -0800 (PST)
Message-ID: <603dd9c6.1c69fb81.8757e.4a14@mx.google.com>
Date:   Mon, 01 Mar 2021 22:23:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.177-246-g1669093de140
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
Subject: stable-rc/queue/4.19 baseline: 89 runs,
 1 regressions (v4.19.177-246-g1669093de140)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 89 runs, 1 regressions (v4.19.177-246-g16690=
93de140)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.177-246-g1669093de140/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.177-246-g1669093de140
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1669093de1405e78ab0fe1a44d64f650110ba0b6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/603da7bba6e69773c7addcb1

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g1669093de140/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.177=
-246-g1669093de140/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603da7bba6e6977=
3c7addcb6
        new failure (last pass: v4.19.177-177-g7d59424a100b)
        2 lines

    2021-03-02 02:49:22.681000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/104
    2021-03-02 02:49:22.690000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xffffed34 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
