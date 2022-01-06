Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E083A486D69
	for <lists+stable@lfdr.de>; Thu,  6 Jan 2022 23:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245287AbiAFW4v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jan 2022 17:56:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245250AbiAFW4u (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jan 2022 17:56:50 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 744ADC061245
        for <stable@vger.kernel.org>; Thu,  6 Jan 2022 14:56:50 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id iy13so3659416pjb.5
        for <stable@vger.kernel.org>; Thu, 06 Jan 2022 14:56:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=9yxtJ7BOsSP65dJMseDldAvReuP47KLsDzF+PiVe9BE=;
        b=ESHnYOAdxoMrjZpy53Ppqiv/hs341OnxFhtv46xyrFcrJQAegMtOs0uFD6ihsU1WS+
         sQqHQkaM+ADnz+txkD/B1nowoH4thjQnaQdWsI6I7mtHzUAWYfOkHTkpSS3OSOSzA7Pb
         gqAVxezk54ESIrxCwyI2wOcQJF0YeJJu2JGc1tY5knQqMYn69TrMTduVNePm2mbszC4J
         yGaL1Cpr8al3GJkD34tH8oR0SRFs2jsV/rrRLa51kxjFh+xyH2jc/0x7mCMUcL5pSE4/
         5mZ3texEbE/dF/mPltCvzKKYjVu6E8iM8H9JtX0WVpEmu8hE4dk4edyqm8JU+mezMnb6
         F9tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=9yxtJ7BOsSP65dJMseDldAvReuP47KLsDzF+PiVe9BE=;
        b=Te3jVkDIZSOsimZa+kUaF24UFXBDVhuQrKTWPoKhgY5r0ANY4oZYJ7ufKzMiTpWcYq
         SwGYvPjhqVtTjPhLnbWFiiok6tYNkCX4jbYjaGC7Oh9y/fCMJ0mq8W9ZQV++0UH92M+V
         yZoLmoSPQe1308l0bkLTbbfgsRAnGJbRPTZBYce3x5j2qUaHtVEgirIvGca6RIg5noPo
         pBY9xwqZX1rr8AAIIDOZRe5JLWgqL59cQwJ92n4xUmfksdKgObrDUQ+J4Woy/4DKywz2
         Lo+A/emVrwwstXFMlv3+nhVt8H6UdqYaj9K8iE8ncf/R5Rte3UmcsdnRLgbLDoiLQnF7
         kcuw==
X-Gm-Message-State: AOAM531hO0Tx2dQS+lINJrZa8eN64P9HuM4eD1SCsj1xRD3SdWi+yBxp
        jtKqvISrR0cvJRfjNZ06YY4rpDRS4B3F+4jd
X-Google-Smtp-Source: ABdhPJwRSiNTJnQOcPU3rSQ8BKyLOQZj3P4VWX3RtwPXiiLmdkjIGt+DQjhCBiGeNx/nB5bUdhIesA==
X-Received: by 2002:a17:90a:1944:: with SMTP id 4mr12505977pjh.209.1641509809916;
        Thu, 06 Jan 2022 14:56:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2sm29646pfl.138.2022.01.06.14.56.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Jan 2022 14:56:49 -0800 (PST)
Message-ID: <61d773b1.1c69fb81.bd50e.0244@mx.google.com>
Date:   Thu, 06 Jan 2022 14:56:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.261-1-g5e07669886b4
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 142 runs,
 1 regressions (v4.14.261-1-g5e07669886b4)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 142 runs, 1 regressions (v4.14.261-1-g5e0766=
9886b4)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.261-1-g5e07669886b4/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.261-1-g5e07669886b4
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5e07669886b4792661e49596142c290b0d368172 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61d731b0c376084b9fef674c

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-1-g5e07669886b4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.261=
-1-g5e07669886b4/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61d731b1c376084=
b9fef6750
        failing since 3 days (last pass: v4.14.260-5-g5ba2b1f2b4df, first f=
ail: v4.14.260-9-gb7bb5018400c)
        2 lines

    2022-01-06T18:14:54.672968  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, syslogd/78
    2022-01-06T18:14:54.682809  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2022-01-06T18:14:54.708300  [   19.973937] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
