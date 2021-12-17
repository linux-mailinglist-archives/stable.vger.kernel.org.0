Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 991F647822C
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 02:31:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhLQBbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 20:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbhLQBbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Dec 2021 20:31:11 -0500
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111FCC061574
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 17:31:11 -0800 (PST)
Received: by mail-pf1-x42b.google.com with SMTP id c2so844927pfc.1
        for <stable@vger.kernel.org>; Thu, 16 Dec 2021 17:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2HZ24ufzsms/frJe3hIzZ64JVK1THBU3H0lan8d0Cg0=;
        b=LIB8yYx1b2rk62qzY0eXpSUZbdi0qxo6bbooCDrO3jbq+MmNDXD6XIvjcgDoDJHgL5
         RRX4tyYriGlXehqf68PmGwrY2C8/AYdz5wgKoj48vfFvgJ6McItbTstPJWuayHNnnCdv
         ky+9GrKPnXTlkvLu5mRRFFn8Q2QxMDsTPqUwoCf9O/9yCEWtZJWF8pQE9se6BTy6fZp9
         NaT6VnTYYoZPo1tonLT84Ikg5dBxYnAbW3v0UboTCsC3pEid47PWdIrExDsGctUXt/X/
         Rit7Fjx2+Cv0Q3WWoEdMHTY9pN22sMf+SaKOYVMSDUa9c11T3Qz8d86pC8LlmiJKSg3/
         AqXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2HZ24ufzsms/frJe3hIzZ64JVK1THBU3H0lan8d0Cg0=;
        b=LtC2QNtwllKs3u9zGl5lFlbLfnFPrfJcJvtGCD6whn/mgTtcI4pOvCgG+c4w9zIloA
         2oixNEV4L0WPs/5uYLL8WoTciz4aj/+nBumxk990vgvQzXDxPrq38K5DM2Bpoe6TDb5V
         eu4DFSuDxCX7WqrIWNvl+qkru0PMWJkrSMRQA01i6plXp2n9vnddTQjhzkBC0qxdrWY/
         A3Lum71/T4HWz31LBcZ6lcqA5qdOb0pvBS11C7OoScMRvanny1ajoL6YhYL6m/qB8ccQ
         csYUVZ048W6dl7IQiy/V/6w81CK8KySBL7Xk5iLFyLwswl0EBqtetoLSnH4cP3ZrVYBA
         Adlg==
X-Gm-Message-State: AOAM533iHuP1xjfYzuRzmSZdKgqw371Ej+CHYuIB6EWZEnHCctZWnOOP
        frkOSxu0euv/83Zq1Yr4lcuUtqp3HB6h9mH5
X-Google-Smtp-Source: ABdhPJxDS5sl420DB7HB4CgfQPaOTuAY5cYrrmfkth2q8Hm3UXrWg6p8u7F/n/CzCj+4VZd3yetkqQ==
X-Received: by 2002:a63:6945:: with SMTP id e66mr779072pgc.237.1639704670406;
        Thu, 16 Dec 2021 17:31:10 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f10sm3543826pge.33.2021.12.16.17.31.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Dec 2021 17:31:10 -0800 (PST)
Message-ID: <61bbe85e.1c69fb81.86aec.b703@mx.google.com>
Date:   Thu, 16 Dec 2021 17:31:10 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-9-g33a692b157b2
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 1 regressions (v4.14.258-9-g33a692b157b2)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 1 regressions (v4.14.258-9-g33a692=
b157b2)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-9-g33a692b157b2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-9-g33a692b157b2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      33a692b157b2d08d2c7c980f026591417af250d3 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bbb1a5ef41725029397146

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-9-g33a692b157b2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-9-g33a692b157b2/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bbb1a5ef41725=
029397149
        failing since 3 days (last pass: v4.14.257-33-gcf9830f3ce18, first =
fail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-16T21:37:23.757646  [   20.048675] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-16T21:37:23.802711  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/97
    2021-12-16T21:37:23.812427  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
