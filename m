Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 787E82F331C
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 15:45:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728483AbhALOnN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 09:43:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728258AbhALOnN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jan 2021 09:43:13 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC850C061575
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 06:42:32 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id c13so1488972pfi.12
        for <stable@vger.kernel.org>; Tue, 12 Jan 2021 06:42:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gyNa/FkqPbj/2OoK4/OGQ+YB318iC069B9DYAGvkSkE=;
        b=TkVStcMjw8ysclmKcSar5p5kKZJKI0giN/2gtqtVfbWBNSFXfVeQUiVSpIC5EasHgQ
         M6nkVhI6r/b7n59duXWRa3WZHEWCjDtiJ5xm91x8bS77SQmEOTp5MnFwRfZ9E6t1ZwVn
         BNxyIBwx0QVdaueeCy5r5cBlf0GICKoepa72d1IX1Q/wgjU/GfhN7ozNgcQJanUaSt7j
         ghPjDTbiK+m6Z1DI5vyQd6lmM+K9PSmAwLLt/Y9PBTk4si3i1m07ROnRaV9dIj/Pgz3b
         3uKhlZo+a5ee3Kw4p+CgVcG0NfjymHHnQCINP0SVCtne/SHLwRBTllXCtc9NzoSbfoyj
         M/kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gyNa/FkqPbj/2OoK4/OGQ+YB318iC069B9DYAGvkSkE=;
        b=Xd1/HrD1NKIF+BowcpGdAXfDbx58pfqIqR4r+W4NAd9PIHjnSMe1kAzzz5bgU/tTPJ
         N+5N88OLw4hgwTKx3M0cV0jJ4nnfDe6DzbiFWxgIUbprd0gzQpuhGF8XzFG9ZJkwTDbJ
         CZf6w3nqY9rpNNZywdhCdN2hZcnyg0cLby6Vy19kbN+M0NEok9UrSLCWs63mWBMUOUDJ
         EjD1vm20iS1lSfQH4oknHrtIjwaXa+qf/zBzVMgzNKd6fQbCu9tEOxtU0UllbayQyLNq
         MyMzzY3DlEK+AU/3jKtxI4XYhPMWiOw7EJFv+OyL5OeQCssu6tDhd7pAx129owDNWrsG
         tUQA==
X-Gm-Message-State: AOAM530pFtq0093SIUENvpcLthZjUe8L33y12hW5/dzHSzZFw3odS90l
        FWFVEgt5VlduUoNcNc8PanvuXDp8qgwaDQ==
X-Google-Smtp-Source: ABdhPJzIitLHBKzykywwQHBg0Tgbov3VPr508vU3HwQKoWvbC0s8WtCr9j8wFLVmLxZa+8xhNwLWfQ==
X-Received: by 2002:a63:fb49:: with SMTP id w9mr4999972pgj.403.1610462552009;
        Tue, 12 Jan 2021 06:42:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3sm3508672pjg.53.2021.01.12.06.42.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jan 2021 06:42:31 -0800 (PST)
Message-ID: <5ffdb557.1c69fb81.9c5fe.6dd9@mx.google.com>
Date:   Tue, 12 Jan 2021 06:42:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-4.4.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.250-36-gefb67dacdec1
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.4.y baseline: 25 runs,
 1 regressions (v4.4.250-36-gefb67dacdec1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 25 runs, 1 regressions (v4.4.250-36-gefb67d=
acdec1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.250-36-gefb67dacdec1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.250-36-gefb67dacdec1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      efb67dacdec11e4291aa7994b71ad02ab7220ef9 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/5ffc44bd0f410b9910c94cd4

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.250=
-36-gefb67dacdec1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.250=
-36-gefb67dacdec1/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5ffc44bd0f410b9=
910c94cd9
        failing since 4 days (last pass: v4.4.249-21-gee71832c038d6, first =
fail: v4.4.249)
        2 lines

    2021-01-11 12:29:45.322000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/121
    2021-01-11 12:29:45.331000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
