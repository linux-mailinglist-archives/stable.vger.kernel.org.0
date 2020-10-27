Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E81E29CAD1
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 21:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S373466AbgJ0U5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 16:57:53 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:42622 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S373465AbgJ0U5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Oct 2020 16:57:52 -0400
Received: by mail-pf1-f177.google.com with SMTP id x13so1622015pfa.9
        for <stable@vger.kernel.org>; Tue, 27 Oct 2020 13:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HWRw8EVl3oljhW7U/Cb4ap+GRBNd7Z1g/KJlESzNarI=;
        b=DA68q6k4HZQZ61vqikfA1LeHdSeuSeU9UNroCKgC5srDQJQkYjdyzLk0P4M7YFGLdm
         9zZVuaiDRajbXjDOdM/e2T78rCjZQ/GemZVrKd38cvc6Ms7BXo/vJNfXJxJWnljDwI4K
         giAJBHsCZu9MHNKcLBh1k6ChH5PIRkuDCE6BW5yp2z8WeU6WDrcWNoeb3yEWldmcyikq
         MMh7894OQe8mK2vL5qdu4klAmtHHPbOgS0FuAp3t/054/aHSBBwY/CBCbR+E6m9WVHM+
         EEn526alJA42EkBYAvc0PCjvkjv8R3mjQhoRhfsdrvZIqCiaSSXUff6ro4b5STOlopgg
         fpYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HWRw8EVl3oljhW7U/Cb4ap+GRBNd7Z1g/KJlESzNarI=;
        b=M4mxEs7vJwiwSGVp4k833XxJ1fi1mlR1Y7bWseGn/gI5Kp2L2VPCWYU+cNPXOz66ru
         GZ96uGapw8rh0oXECv7CCtpSYo4XK+i9BQeoSneU9w9hoLFhWtRFUl8kysSnktuzq2HY
         jxZFyybEuooh2105vLAWGwrXUGc4edw5JBV5kHUYsUnP94Bwzw6IR1peJSZ8CUdqvF8L
         1caZLmU+ru9WFmSIZiXhsZzG8aXT9vPrbK7Qf5E1n/Gmgw0ewhy5j7LycyqpogGjVg0C
         8Kj1AuAeZ4UdliA7Bo9DthjaGwy5V6uPqy2LMaiEd5Un2F7Z8CNohYLjx6qhYKpLFXN3
         tK+g==
X-Gm-Message-State: AOAM530gkq5nuDlM+hggCAj536ocT+BtGut1zIQNGId/iA5HJwNjMAfP
        P1dnZ7X0itp/cISKkdoUT6MM/jiiNdEZSw==
X-Google-Smtp-Source: ABdhPJw42cOrsX2ojglE+8cOjER6ndKAZ0jgwFVTzjyXydFMuQg0jOSDialcRlxJC73Y7DUaRRlOiQ==
X-Received: by 2002:a63:1805:: with SMTP id y5mr3352567pgl.174.1603832271235;
        Tue, 27 Oct 2020 13:57:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a3sm1455043pfa.126.2020.10.27.13.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2020 13:57:50 -0700 (PDT)
Message-ID: <5f9889ce.1c69fb81.739db.351c@mx.google.com>
Date:   Tue, 27 Oct 2020 13:57:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-112-gf42205a4e8cd
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 108 runs,
 4 regressions (v4.4.240-112-gf42205a4e8cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 108 runs, 4 regressions (v4.4.240-112-gf42205=
a4e8cd)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =

panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-112-gf42205a4e8cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-112-gf42205a4e8cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f42205a4e8cd954917fe16b0e43d50d1fd376840 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
beagle-xm        | arm    | lab-baylibre  | gcc-8    | omap2plus_defconfig =
| 2          =


  Details:     https://kernelci.org/test/plan/id/5f98584990e35794ad381012

  Results:     2 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-gf42205a4e8cd/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-gf42205a4e8cd/arm/omap2plus_defconfig/gcc-8/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/5f98584990e35794=
ad381017
        failing since 0 day (last pass: v4.4.240-110-gdf2675c594de, first f=
ail: v4.4.240-110-g42970a6d4724)
        1 lines

    2020-10-27 17:24:43.676000+00:00  Connected to omap3-beagle-xm console =
[channel connected] (~$quit to exit)
    2020-10-27 17:24:43.676000+00:00  (user:) is already connected
    2020-10-27 17:24:43.676000+00:00  (user:) is already connected
    2020-10-27 17:24:43.677000+00:00  (user:) is already connected
    2020-10-27 17:24:43.677000+00:00  (user:) is already connected
    2020-10-27 17:24:43.677000+00:00  (user:) is already connected
    2020-10-27 17:24:43.677000+00:00  (user:) is already connected
    2020-10-27 17:24:43.677000+00:00  (user:) is already connected
    2020-10-27 17:24:43.677000+00:00  (user:khilman) is already connected
    2020-10-27 17:24:43.678000+00:00  (user:) is already connected =

    ... (470 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f98584990e3579=
4ad381019
        failing since 0 day (last pass: v4.4.240-110-gdf2675c594de, first f=
ail: v4.4.240-110-g42970a6d4724)
        28 lines

    2020-10-27 17:26:28.875000+00:00  kern  :emerg : Stack: (0xcb96fd10 to =
0xcb970000)
    2020-10-27 17:26:28.884000+00:00  kern  :emerg : fd00:                 =
                    bf02b8fc bf010b84 cba48c10 bf02b988
    2020-10-27 17:26:28.892000+00:00  kern  :emerg : fd20: cba48c10 bf20c0a=
8 00000002 cbc32010 cba48c10 bf252b54 cbc834b0 cbc834b0
    2020-10-27 17:26:28.900000+00:00  kern  :emerg : fd40: 00000000 0000000=
0 ce228930 c01fb3d8 ce228930 ce228930 c0857e88 00000001
    2020-10-27 17:26:28.908000+00:00  kern  :emerg : fd60: ce228930 cbc834b=
0 cbc83570 00000000 ce228930 c0857e88 00000001 c09612c0
    2020-10-27 17:26:28.916000+00:00  kern  :emerg : fd80: ffffffed bf256ff=
4 fffffdfb 00000024 00000001 c00ce2f4 bf257188 c04070c8
    2020-10-27 17:26:28.924000+00:00  kern  :emerg : fda0: c09612c0 c120da3=
0 bf256ff4 00000000 00000024 c040559c c09612c0 c09612f4
    2020-10-27 17:26:28.933000+00:00  kern  :emerg : fdc0: bf256ff4 0000000=
0 00000000 c0405744 00000000 bf256ff4 c04056b8 c0403a68
    2020-10-27 17:26:28.941000+00:00  kern  :emerg : fde0: ce0b08a4 ce22191=
0 bf256ff4 cbbc02c0 c09dd3a8 c0404bb4 bf255b6c c095e460
    2020-10-27 17:26:28.949000+00:00  kern  :emerg : fe00: cbc0da00 bf256ff=
4 c095e460 cbc0da00 bf25a000 c040617c c095e460 c095e460 =

    ... (16 line(s) more)  =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f985840a16b04d04a38109c

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-gf42205a4e8cd/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-gf42205a4e8cd/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f985840a16b04d=
04a3810a3
        new failure (last pass: v4.4.240-110-g42970a6d4724)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f98575aa69aabb0d2381024

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-gf42205a4e8cd/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
12-gf42205a4e8cd/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f98575aa69aabb0d2381=
025
        failing since 0 day (last pass: v4.4.240-110-gdf2675c594de, first f=
ail: v4.4.240-110-g42970a6d4724) =

 =20
