Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8082468615
	for <lists+stable@lfdr.de>; Sat,  4 Dec 2021 17:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238927AbhLDQFa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Dec 2021 11:05:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbhLDQF3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Dec 2021 11:05:29 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3923AC061751
        for <stable@vger.kernel.org>; Sat,  4 Dec 2021 08:02:04 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id gx15-20020a17090b124f00b001a695f3734aso5053314pjb.0
        for <stable@vger.kernel.org>; Sat, 04 Dec 2021 08:02:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=asZpe9hzbjHbRHNmBw4RaUiOuI8X2vZ2N7XHnmO4qBM=;
        b=3fwOkATX5QDDIAdXgZes5HkxuOO01+QugqUXAAnRUFNkn08dathXQUMrXN28Xyga0l
         koXUASOpU2QrxCaaPBh54ACobW2mMIwffR8ah+BSShGcS4tNOYHoXtqcU6RQdOYDkaQq
         lH1RfN1UlKemi6LG5dqJTeGmTLlbauTIQwmmNKr3kACUKhTE88XdInrZwFNnWbFGej7H
         bAx0OzzZwWOE1NCtGUBvhmb+AYzVLMt1j6HqLgyhzdB1zdP6xwbcyXVmbVvUydRLIEBx
         SsOVN4E5hZZtNNFffYBKmOUpXS+m8IuHLWlabHngzQThvMSdDKNE5aBHcbm0lRBdgA/b
         KFdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=asZpe9hzbjHbRHNmBw4RaUiOuI8X2vZ2N7XHnmO4qBM=;
        b=WdvUTWi8kxfV9kVf7KFBcc5OpPKgSmeqbDOKIv3XItqdw/IiqcpF+OMCnNFNbHYMHX
         X/g2J4Ao9g58U098k5VkRV1Y9h+Oj8Xf2uj3EkHdKu279UlmnkDzKMVi9upO/14q1pys
         rrUGDIh3bAYPTEru67A/l4mAItIUS6NoAd3S9dulruCahlCL36w1Q3ljhz2FCOQlswPG
         H7VPevJgKSnjD83/oCITr5Hhavir/9JXbgIsquuxTymD7alxb9hpNl8WXHM0px1lo+YH
         BdqMCjJArYq90hXZXumnZwmyVOTfYlnc7uzvGfQ3I1j799D2JOJEOsw1DraPsiARgyH+
         cXXg==
X-Gm-Message-State: AOAM532i2EyBPNyQD9FOmALsa77YFceFYSq/demw0JcZ7U2Hp8qiNnPC
        dUDgaOoxwe6nTXTALOhNrorI7zB/S5Iwk2AB
X-Google-Smtp-Source: ABdhPJyDptQIZAm8/9I4djXBjNyrVezMjVfjT72QpQmb9BMFw/1yl8Fz20LoYhr8CJISJcjl2Pikgw==
X-Received: by 2002:a17:90a:3009:: with SMTP id g9mr23294660pjb.205.1638633722768;
        Sat, 04 Dec 2021 08:02:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id pc10sm6088064pjb.9.2021.12.04.08.02.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Dec 2021 08:02:02 -0800 (PST)
Message-ID: <61ab90fa.1c69fb81.b6e2d.109f@mx.google.com>
Date:   Sat, 04 Dec 2021 08:02:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.9.291-51-g9e9032945598a
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 110 runs,
 1 regressions (v4.9.291-51-g9e9032945598a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 110 runs, 1 regressions (v4.9.291-51-g9e90329=
45598a)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.291-51-g9e9032945598a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.291-51-g9e9032945598a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      9e9032945598a3cb201edb1785a886247accb453 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/61ab5f2c3883b552be1a9483

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
1-g9e9032945598a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.291-5=
1-g9e9032945598a/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61ab5f2c3883b55=
2be1a9486
        new failure (last pass: v4.9.291-47-g43f5262d9792)
        2 lines

    2021-12-04T12:29:01.138753  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/126
    2021-12-04T12:29:01.148014  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
