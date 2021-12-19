Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32D6E47A005
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 10:25:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235462AbhLSJZa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 04:25:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229585AbhLSJZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 04:25:29 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE3AC061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 01:25:29 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so9966877pja.1
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 01:25:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=2jC/VX077Q3/TXDOez6LhoQMDsN0rBWlTQVSsdVBXro=;
        b=L2OvKRlyLpfxFTrpd3IoJjDLB+vZMV1C4N9kTmuMQAahs0WSJhMONk1RE6vi9RNK4h
         Plg5Glj9jDsyIoT2toEaEPcVL5m1+paVJSCq15A/VXgh1+kweY0aCl0foCTfoMqJPRjA
         TpHLxd7atyaPRRgc+5DNzXQfLTe3j0vWJnro+66t1QneI9/yEqMb2Jo/hwOFaygIUM6M
         6S5uMpoYVZlDEDRsezfLCpltcUGBJvyYY5kg2s9G2+gcB7B4/6DRsWfYxe4D6CoVPQvy
         lqCE2t5/fodak3xsdckS+w7cmOnarC5gZE6/XV2I7Mw+7KQqavBdgqk0EbSUNGYBJcLf
         xS8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=2jC/VX077Q3/TXDOez6LhoQMDsN0rBWlTQVSsdVBXro=;
        b=1Rv3u7I0wu3yj7S3xFXBVCz/HNLOm/tM1Rv5NR1ZbaaFpwv136hrH86SEJiflkGrjw
         FSCCjOPJhWYHIjW4qf07D0kNosU15B0q3czWitfE24glmI/xm4gkMJM/mCkU4ADG4tQL
         Dw7IrsJlpkbydVkY67Asay3M2qcju3MVdMSGRx5zO7HGBo5458CUwzNjaHlZIClAYPYw
         e1YRnYRYjHpfOFZ0CeC7mI1r2luKlqzKK/MszqckixSKiBN2VmG+/MBcU/ihnei0gkPv
         TNWNLG7B7r4ZRxcKykzM8JZ5QeQ1My5olHQJy//dBUX27YAu9Q4u+YdOabRawOj5OGpd
         BEhA==
X-Gm-Message-State: AOAM533ok13RUNg69V+EjODOiyyq/Ri3PemkMaoYkW2TiQlgPQ5bbKYv
        zO7itPAmoXvf+DPl3tBxF+UgptQAuEdiApi3
X-Google-Smtp-Source: ABdhPJwiMt/8O6QcXa/o9KKt8d6/F6rE9m5of1OjByTZxInA3btBPCuYq28HL3RXfGRjqHMVYNHHZw==
X-Received: by 2002:a17:902:b18d:b0:148:dcd8:79e with SMTP id s13-20020a170902b18d00b00148dcd8079emr10793792plr.74.1639905928855;
        Sun, 19 Dec 2021 01:25:28 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ng9sm19368559pjb.4.2021.12.19.01.25.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 01:25:28 -0800 (PST)
Message-ID: <61befa88.1c69fb81.dcdf4.504f@mx.google.com>
Date:   Sun, 19 Dec 2021 01:25:28 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221-29-gd12f6c695033
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 130 runs,
 1 regressions (v4.19.221-29-gd12f6c695033)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 130 runs, 1 regressions (v4.19.221-29-gd12f6=
c695033)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.221-29-gd12f6c695033/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.221-29-gd12f6c695033
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      d12f6c69503361325e2596d155c9578c624b4f8b =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61bec0dba7d9644ea0397138

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-29-gd12f6c695033/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.221=
-29-gd12f6c695033/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61bec0dba7d9644=
ea039713b
        failing since 2 days (last pass: v4.19.221-9-ge98226372348, first f=
ail: v4.19.221-9-gf48d5f004d75)
        2 lines

    2021-12-19T05:19:04.418276  <8>[   21.354125] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-19T05:19:04.465037  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/103
    2021-12-19T05:19:04.474234  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
