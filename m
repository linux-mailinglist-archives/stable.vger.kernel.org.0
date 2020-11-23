Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 453722C11F0
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 18:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388346AbgKWR2M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 12:28:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732550AbgKWR2L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Nov 2020 12:28:11 -0500
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43A5C0613CF
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 09:28:11 -0800 (PST)
Received: by mail-pg1-x52d.google.com with SMTP id 62so14859566pgg.12
        for <stable@vger.kernel.org>; Mon, 23 Nov 2020 09:28:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SY2tIDNT7sPmfkPM7SLvRDOPaif/YaJuVw8kgx9BJ+w=;
        b=vR4zmLrR6gCl7Ix6YCOcLwiK6nHLxLNIjO/BvIkoA9tvbx7EdPjXBZXwV2kfF1qk7k
         8QDFhMbk6rEY6Ht393GUIrVK/F4xNIxpCoCBZBxMP8kphZeID72DvzO9blR41U/gQIbW
         1xbjWtIxdrgzkogSVAB87LaZFzRuOs7l7qMzqNe3KO7RgNDOD69PKutf5DFBaI6l9xDr
         8R5kwBwH0o/MrhBoMjoqKJXFX3h3IO47CTHSJ0fgLR3zGrAkZm8kQMGGP7esUPg4v2Vi
         bTGlyCrls0SFni62gR6JpLv//fyDGTnmpOwdniH2xH7ZdG36b5MWSFlh+xgL/HX6HtAZ
         u9SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SY2tIDNT7sPmfkPM7SLvRDOPaif/YaJuVw8kgx9BJ+w=;
        b=WH/ynuu8i/+5A6za3NZ8XA6DfgvdRlVxrV1NcbUrxSb7aXgCug9+UK3FbSL/ZDmzNm
         KilRshKOODZDqv5kEPCu0k7BDFxHMziELrWOC261LvLffvlpt6pHGrChZV2YM8l5xlWC
         FgUpUNAIWbKKADa//qaBui2nPORWTQnaRuCunV9B2Yp0Tf8mk3Bj+iI36PoE8EHucftU
         qi0WB/vBRrUdzjeAll4NWv94UBEQzNxUL7PFrA383n+8wY1qGWztHyqIHCjuflfcDls0
         GgPqyLeZrPO79QXOp/1ZxCapUGStdqJZvXoE94fpfEGekhasiNU6l4yBrt+Avg4imKek
         MtTw==
X-Gm-Message-State: AOAM532YLSBjjrCkd9iG3RPD+D6HLxjX5iblBgbs1A6o81MEeUlp5N3F
        xM3U660K9GWK+vM4QC2viAJGwxzKzIKX+A==
X-Google-Smtp-Source: ABdhPJyruSpCddLYhyVFns7cEBAaD64fa9yIQ9NOpWVusSA3kOm1Kh8ojJw6jv4ph7Hx6n8qKBczZQ==
X-Received: by 2002:a17:90a:c287:: with SMTP id f7mr945833pjt.34.1606152490971;
        Mon, 23 Nov 2020 09:28:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id fh22sm14751884pjb.45.2020.11.23.09.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2020 09:28:10 -0800 (PST)
Message-ID: <5fbbf12a.1c69fb81.63fac.063d@mx.google.com>
Date:   Mon, 23 Nov 2020 09:28:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.9.245-47-g992d8941051d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.9 baseline: 118 runs,
 7 regressions (v4.9.245-47-g992d8941051d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 118 runs, 7 regressions (v4.9.245-47-g992d894=
1051d)

Regressions Summary
-------------------

platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =

panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =

qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =

r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.245-47-g992d8941051d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.245-47-g992d8941051d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      992d8941051dc1ddef62218e720576f77bf61645 =



Test Regressions
---------------- =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
at91-sama5d4_xplained | arm   | lab-baylibre  | gcc-8    | sama5_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbea43ea11a8e19d8d90f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5d=
4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbea43ea11a8e19d8d=
910
        failing since 25 days (last pass: v4.9.240-139-gd719c4ad8056, first=
 fail: v4.9.240-139-g65bd9a74252c) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
panda                 | arm   | lab-collabora | gcc-8    | omap2plus_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbecbd699f6f5d9d8d931

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5fbbbecbd699f6f=
5d9d8d936
        new failure (last pass: v4.9.245-34-gc27c2d5e85ea)
        2 lines

    2020-11-23 13:53:11.519000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff24c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-baylibre  | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbc2a7ae97b4df0d8d91b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-baylibre/baseline-qemu_ar=
m-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbc2a7ae97b4df0d8d=
91c
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-broonie   | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbc3337c142919ad8d90a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-broonie/baseline-qemu_arm=
-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbc3337c142919ad8d=
90b
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-cip       | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbc27707f5cfc0bd8d900

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-cip/baseline-qemu_arm-ver=
satilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbc27707f5cfc0bd8d=
901
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
qemu_arm-versatilepb  | arm   | lab-collabora | gcc-8    | versatile_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbbde12ef5f45cad8d923

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: versatile_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm/versatile_defconfig/gcc-8/lab-collabora/baseline-qemu_a=
rm-versatilepb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbbde12ef5f45cad8d=
924
        failing since 9 days (last pass: v4.9.243-16-gd8d67e375b0a, first f=
ail: v4.9.243-25-ga01fe8e99a22) =

 =



platform              | arch  | lab           | compiler | defconfig       =
    | regressions
----------------------+-------+---------------+----------+-----------------=
----+------------
r8a7795-salvator-x    | arm64 | lab-baylibre  | gcc-8    | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/5fbbbbf284c5695224d8d904

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.245-4=
7-g992d8941051d/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a7795-salvato=
r-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fbbbbf284c5695224d8d=
905
        failing since 5 days (last pass: v4.9.243-24-ga8ede488cf7a, first f=
ail: v4.9.243-77-g36ec779d6aa89) =

 =20
