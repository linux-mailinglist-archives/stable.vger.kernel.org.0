Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FB434A3000
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 15:12:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234194AbiA2OMg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 09:12:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233450AbiA2OMe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 09:12:34 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4BB0C061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:12:34 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id o16-20020a17090aac1000b001b62f629953so6227230pjq.3
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 06:12:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=i2M8d9rjrH+yAqzDUh2TV2xksJkbCrHHrGYWH1gINf8=;
        b=dlRqSfDsLkgOxxhUczcwTlzfDK7KNZg6UUSA1kY3suNyuWZbT8+fl3znAo5q/IBu69
         tuxpcovlN7uS9wABlBhsNQW4KkLtLEurcjtspvaXafmaMOl5CqjyrNKPG7l7+iWgrlYn
         MxsmzYhE92AimcX2apTEp8msGOkFCZp1Tp/ysG+xIjQ+B87JBQbWGZ2XyxGpqDAO0ljS
         6wfTkpsPL14WsZCpq+Pmh/vjhqospcHr59w5VT1a+QnKRSmyfqQPZH8M8giGXOdPYY3k
         X6tYdlittfpHJTfHUuTcxoS70KLZBo3z6Jw1Rrda64E6xxWXnH6iOI6PAUJYQIlptt46
         ui4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=i2M8d9rjrH+yAqzDUh2TV2xksJkbCrHHrGYWH1gINf8=;
        b=qovsb3Rw4GwOQtHJMgRQRjCztrDvxoE5TG4NR4rMNbHJrA9IstVNhzcIbkEFjukxuk
         glj+sTYs2iMgs7PphUfA8oVoi0qzy/qXxssNeR4PlqIKHc701IdGhV1PXYKCR7V1lKsG
         bj3zgPHt78xNk2FrbFbmjJ8rRxXiwoKHgKutHMQ4309O+IKBvx7xWU9W8xg2q9s5V9/a
         MrVWL/g4jIKCf+zzOcpBjuF0lvUULEWQ1tXEewJYUhEA54DMRrqe0bN9DYK2gENUw+E0
         FuPnGXQ1tr0rVr8cI7+qm/KP9QRW8k1hXtltig2r/26Pw1HzFeu2ce7T1ndHsvJb8K4D
         Ey7w==
X-Gm-Message-State: AOAM530oLrnSllZlmP4MXoJXH5/Gh2EOgTk1PJEpwF1RhsN7UgCj4n19
        Eo+5Ho55eq43/adHfp5geQsiJZ1qL8roYYP5
X-Google-Smtp-Source: ABdhPJxo7MGoMrc9loMqyGee9FtoZm3TRnEXcnMypibYbmeN4k/8fnd2+N8ry0koftXhWL/6h+k7Gw==
X-Received: by 2002:a17:902:b681:: with SMTP id c1mr12885480pls.110.1643465554073;
        Sat, 29 Jan 2022 06:12:34 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p22sm13329582pfo.163.2022.01.29.06.12.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 06:12:33 -0800 (PST)
Message-ID: <61f54b51.1c69fb81.20915.372f@mx.google.com>
Date:   Sat, 29 Jan 2022 06:12:33 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.263-3-g815d04e959cc0
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 119 runs,
 1 regressions (v4.14.263-3-g815d04e959cc0)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 119 runs, 1 regressions (v4.14.263-3-g815d04=
e959cc0)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.263-3-g815d04e959cc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.263-3-g815d04e959cc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      815d04e959cc0f998bf9e97c1e4381fa04053329 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61f5185876280f9a78abbd36

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.263=
-3-g815d04e959cc0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.263=
-3-g815d04e959cc0/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f5185876280f9=
a78abbd3c
        failing since 1 day (last pass: v4.14.262-183-ge251e7983f4f, first =
fail: v4.14.263-3-ga2d9e2bae197e)
        2 lines

    2022-01-29T10:34:44.482447  [   19.767272] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2022-01-29T10:34:44.527239  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, swapper/0/0
    2022-01-29T10:34:44.536196  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
