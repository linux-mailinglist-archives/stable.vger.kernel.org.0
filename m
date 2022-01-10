Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB7E489097
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 08:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232935AbiAJHPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 02:15:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230433AbiAJHPa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 02:15:30 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80409C06173F
        for <stable@vger.kernel.org>; Sun,  9 Jan 2022 23:15:30 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id 201so1899084pge.1
        for <stable@vger.kernel.org>; Sun, 09 Jan 2022 23:15:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=j4VOrwYKtUSeX23pSTipPCLOYVVA0deA1r4S4hu+ycc=;
        b=sJNMPAPtVAhlhGK0oFpJL3QXcO1G/IW08PuaVsifbG1GhsH3Yy01qreOFN31IbYS1Z
         CPO8P4uePjCbOKEd2m0vHpBLXJu9FvW4XLmzvgu7Wqi/PNC7iSZZQsKNPf3HUyinf5x7
         F+DMkvMnu1rKGOtuZ1YQAHKKiLrnDj/C5ieS7+i6b1BGkd7PVdtBt5fOOn3Cxhn36oIm
         UgUn3UFBOI19wjBaWL9az6VBuWXI2fuaGHkGbQS1whXxmz22vlYETHNR4Ts5SH+L+jr8
         TDesNtiFGz6uyKJWdBMV1v4UV9ZgNeqOZ2h7OBqmGfCFQe2anCabPJBw7VB+FAjgNXy/
         qgfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=j4VOrwYKtUSeX23pSTipPCLOYVVA0deA1r4S4hu+ycc=;
        b=YCL1nttXryzgw0H5PtFPpHmAPQV/C7FEdrKL03Zig7fmdjB0zuP2PyK0rUt/gzkF8G
         TAXXdzgrkjoLzE5YYPR8S9iny+sq0NUqdJLK8hFN0F3m7lDcfdO70f7WBtK1Zx97pLhH
         etHc8p3sJwGdKb4QocxdRuswC1ZzXoYsiHxhDKZ8Gm/rEZXia7lhS7Ou/SZ7rej1ezX/
         07Z00g3NueCMJZMFifSzScklwkoVjpTCnbWHUe8rYSG/rRvWrp50ciC/oxl+leChfDvJ
         Q/gzeQ1jiHegoYdsZdr2gNePwBIoZJXoNR39tCxXQMYDvAyF+EWL2n/PrLwQ3dZ7zQy6
         jiww==
X-Gm-Message-State: AOAM532U+kuma5YouEPX2aBNE+16WwxYGH8QdG7GgtzicyYn7wHSaBBS
        vRqrEa54NSsH/4q1d2OlfnZB5NQgIfshq0qU
X-Google-Smtp-Source: ABdhPJwmOZIuVyToq3fnVbP1wpBeBm6FJdQtxdZHyf5L5wBqwQi9mKbKJlKytJbMWDb+tP5hEwigug==
X-Received: by 2002:a05:6a00:1ac6:b0:4bd:1ad:5658 with SMTP id f6-20020a056a001ac600b004bd01ad5658mr13105855pfv.48.1641798929888;
        Sun, 09 Jan 2022 23:15:29 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id gm2sm1508680pjb.21.2022.01.09.23.15.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 23:15:29 -0800 (PST)
Message-ID: <61dbdd11.1c69fb81.1e69d.4525@mx.google.com>
Date:   Sun, 09 Jan 2022 23:15:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.298-13-g45579b4281d3
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 116 runs,
 1 regressions (v4.4.298-13-g45579b4281d3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 116 runs, 1 regressions (v4.4.298-13-g45579b4=
281d3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.298-13-g45579b4281d3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.298-13-g45579b4281d3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      45579b4281d32f851fd84b14c852e3b584a7e615 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61dba8e234745e4cf5ef675c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-1=
3-g45579b4281d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.298-1=
3-g45579b4281d3/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61dba8e234745e4=
cf5ef675f
        failing since 20 days (last pass: v4.4.295-12-gd8298cd08f0d, first =
fail: v4.4.295-23-gcec9bc2aa5d3)
        2 lines

    2022-01-10T03:32:30.597231  [   19.463348] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-10T03:32:30.640162  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/115
    2022-01-10T03:32:30.649484  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
25c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2022-01-10T03:32:30.665751  [   19.531829] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
