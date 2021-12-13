Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA7DC473023
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 16:08:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239974AbhLMPIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 10:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236500AbhLMPIj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 10:08:39 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A188C06173F
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 07:08:39 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id m24so11351940pls.10
        for <stable@vger.kernel.org>; Mon, 13 Dec 2021 07:08:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rE/THdhp99X0G7jJ7VhY4Bo8366G2KhZv/aBEeD2mDE=;
        b=fD6WhaH3ggQAJRdHQiAyVojphkueO0Uffj1ifdQRFG3OznXB4+9mdMc3/ICTxjgVJe
         qFBZbhjZ7W+nMxboN/5EaudTZxw5lHCPo63a7uC/Fk9Yz76PnYT17k3v1soIio+WyQ2O
         OnYp8a1qry2PIOPaH5WGGMWFU3EPabOcHjc8lk45MHPFpTAFm/9UyRtYu9BzRu9DR4Kr
         Yv7HgVCvBaHdRTnhMBRYqveY2Ox2ZmJGUN4mCWWSkItQqpdoH7aL1xoW0dL5iY6MIUXe
         wNCPuI3/5VVaprjKT80r1SqVE/3/VHS/YJ7bMyaQ4k6NyDafEr457XfMYF/mAsi6wgLe
         YLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rE/THdhp99X0G7jJ7VhY4Bo8366G2KhZv/aBEeD2mDE=;
        b=vgX6Yyw4oyHDqbVkflPXAycVXhTi/G7bM7evgvIjmW3OtNSeV5ncqToCspPdmXluls
         AwDcIeKlXBimvH64VnZyR0x8s50P4Q3yx2JKjRkSVq5YzXFiCoYoZ3zqbOa9w/PQtU3Y
         FBmSP/o1x5dXEPBY2jrbgQNqHRSJKaUrtf3govZUAS+tMo8L/sMjMmHDiJ9Vd1CE6Kud
         Y2368J3LKCK0gqfV8jXqfg/2cZwDYVqNE6r5GmOiFEby/m8laLDt+ry/TP0OIuazC5S+
         SZV4ErrvC/X5+GUfqme4tjxrtl/ygBQJ+FBNJUwCFEWitkyS1qEEgePKC77Z3BegffkD
         L5Lg==
X-Gm-Message-State: AOAM533K9tuFKcrU0mi0UAENR0kaoWY8ltdBwVQrEYnEWoqotnQSK/zR
        6U/dLTxIhfrJcZfkoAU0TKQ3wa+ECViGWp2g
X-Google-Smtp-Source: ABdhPJw7wXGZkxA1P+2gK8ALzDzJU8ydvtUWxw8uvhcXgzsr+/l0KUOWQ/Cj4aqxgTMqkgnyFXt6Bg==
X-Received: by 2002:a17:90a:e00f:: with SMTP id u15mr44245971pjy.123.1639408118683;
        Mon, 13 Dec 2021 07:08:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 6sm9142022pgc.90.2021.12.13.07.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Dec 2021 07:08:38 -0800 (PST)
Message-ID: <61b761f6.1c69fb81.5289e.800a@mx.google.com>
Date:   Mon, 13 Dec 2021 07:08:38 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.294-37-g25f002b45e2f
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.4 baseline: 107 runs,
 3 regressions (v4.4.294-37-g25f002b45e2f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 107 runs, 3 regressions (v4.4.294-37-g25f002b=
45e2f)

Regressions Summary
-------------------

platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =

panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.294-37-g25f002b45e2f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.294-37-g25f002b45e2f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      25f002b45e2fe0f495c34bd929e6d1934943f8c2 =



Test Regressions
---------------- =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
beagle-xm | arm  | lab-baylibre  | gcc-10   | omap2plus_defconfig | 2      =
    =


  Details:     https://kernelci.org/test/plan/id/61b727f9f61dd60db9397139

  Results:     3 PASS, 2 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-3=
7-g25f002b45e2f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-3=
7-g25f002b45e2f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagle=
-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/61b727f9f61dd60d=
b939713c
        new failure (last pass: v4.4.294-27-gf40112305aac)
        1 lines

    2021-12-13T11:00:54.901947  / # =

    2021-12-13T11:00:54.902631  #
    2021-12-13T11:00:55.005746  / # #
    2021-12-13T11:00:55.006522  =

    2021-12-13T11:00:55.107929  / # #export SHELL=3D/bin/sh
    2021-12-13T11:00:55.108428  =

    2021-12-13T11:00:55.209429  / # export SHELL=3D/bin/sh. /lava-1235004/e=
nvironment
    2021-12-13T11:00:55.209856  =

    2021-12-13T11:00:55.311065  / # . /lava-1235004/environment/lava-123500=
4/bin/lava-test-runner /lava-1235004/0
    2021-12-13T11:00:55.312260   =

    ... (10 line(s) more)  =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b727f9f61dd60=
db939713e
        new failure (last pass: v4.4.294-27-gf40112305aac)
        29 lines

    2021-12-13T11:00:55.777147  [   49.537414] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-13T11:00:55.828943  kern  :emerg : Internal error: Oops - BUG: =
0 [#1] SMP ARM
    2021-12-13T11:00:55.834665  kern  :emerg : Process udevd (pid: 106, sta=
ck limit =3D 0xcb934218)
    2021-12-13T11:00:55.839134  kern  :emerg : Stack: (0xcb935cf8 to 0xcb93=
6000)
    2021-12-13T11:00:55.847322  kern  :emerg : 5ce0:                       =
                                bf02bdc4 60000013   =

 =



platform  | arch | lab           | compiler | defconfig           | regress=
ions
----------+------+---------------+----------+---------------------+--------=
----
panda     | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1      =
    =


  Details:     https://kernelci.org/test/plan/id/61b7282a120424a2fb39711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-3=
7-g25f002b45e2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.294-3=
7-g25f002b45e2f/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b7282a120424a=
2fb397121
        failing since 0 day (last pass: v4.4.294-9-gc0c2458dacd8, first fai=
l: v4.4.294-20-gc778b3c7e92d)
        2 lines

    2021-12-13T11:01:41.121187  [   19.398590] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-13T11:01:41.164701  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/117
    2021-12-13T11:01:41.174287  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
