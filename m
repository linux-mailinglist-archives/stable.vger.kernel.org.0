Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB65458BBF
	for <lists+stable@lfdr.de>; Mon, 22 Nov 2021 10:46:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235162AbhKVJte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Nov 2021 04:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhKVJte (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Nov 2021 04:49:34 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484D6C061574
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 01:46:28 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so16405081pjb.2
        for <stable@vger.kernel.org>; Mon, 22 Nov 2021 01:46:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=d6eUTC0pw77hGYKD0DzpfvFZYUB2aZBUGcQEDEUBSbI=;
        b=olj62BJkb6adO9PbTCIFutn4EEEtgaVQWaHyetw7FBrU+gfQUv9aX1W+JZhIb8AySQ
         xY+dV9d/f0QfH7ELzmnU45yWIiweC8pklYYP6Vyy7MUatvDCNmq58YCFLKJ/Hb9yt6Xf
         VM8VxlnXVAV2J2WmJCf1CSs9zabY15AXzOcrDCs2p/D3jJXKpQB7fl+u7hikwlxsw3eK
         UYsfq2BGJEjkGN5PeSBCnmfJiDlizS2Tn2CAlplS4ma3AnCHrbFMK1Z1qe73uToNgY/s
         G6bqI0e35woKrnAbekQ8kB9byz0loEAbQtwxarmvWYzGK6PUZRlmUgzc76RDK2dBU6/C
         OXGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=d6eUTC0pw77hGYKD0DzpfvFZYUB2aZBUGcQEDEUBSbI=;
        b=p3/oqOL15nxYBdyRxH+ZYFp7/IZYGCUi+Na902x6ZXRFWnpXfw7erPiU94X22TVaCG
         YSmytSclT/WsgCQO3Kysh3h7ZmoiBoqmO3yHw4C+oimZ1Aixhkr6J++3KrlanPyK2QTK
         sfS/ZgHsWz4cjF6RlM8ynVVRnWvRhBArAntHYbO+4k59jxJO0tXoKcy1FnLYuz10r3vx
         OfKqUPHZaxA54b7D4mbCogRLHKMh7JxWoKXC5Kn1no3CElEJEc4LnEyqQrjJT8GAC0GO
         VEWvJ8X01yNRHuqyDWl5gFmz6gV8eQo6071YgAUgT/cRBVPRg676tPgqs6gqoWTBJOd5
         L7ag==
X-Gm-Message-State: AOAM530C7/eLHSxTm4jyUa53gjnnixWwFUUEcdSEdyPpVe3zThI3ygI0
        UX6tYAuvzJfYwGdbUKELnd3ZyOsjOa6qd68d
X-Google-Smtp-Source: ABdhPJzeQA7r+ekiEeI7U8o2lJRVSy7ytuq5Hi/afMMPJDGCorZKiQ0mNqlGQjVPxHAV3XYm3jCWQA==
X-Received: by 2002:a17:90a:6e41:: with SMTP id s1mr29851632pjm.166.1637574387691;
        Mon, 22 Nov 2021 01:46:27 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j188sm7948470pfg.51.2021.11.22.01.46.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 01:46:27 -0800 (PST)
Message-ID: <619b66f3.1c69fb81.35b94.7b73@mx.google.com>
Date:   Mon, 22 Nov 2021 01:46:27 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.14.255-233-g18e656325ab1
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 127 runs,
 1 regressions (v4.14.255-233-g18e656325ab1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 127 runs, 1 regressions (v4.14.255-233-g18e6=
56325ab1)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-233-g18e656325ab1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-233-g18e656325ab1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      18e656325ab1e7764ed335dcf7c58ce99e28ba1f =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619b2f0327b6510807e551d0

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-233-g18e656325ab1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-233-g18e656325ab1/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619b2f0327b6510=
807e551d6
        failing since 3 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-22T05:47:27.033632  [   19.950531] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-22T05:47:27.076990  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, kworker/0:1/19
    2021-11-22T05:47:27.086688  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
