Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A3A9314957
	for <lists+stable@lfdr.de>; Tue,  9 Feb 2021 08:16:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230088AbhBIHPJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Feb 2021 02:15:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbhBIHPH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Feb 2021 02:15:07 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB5AC06178B
        for <stable@vger.kernel.org>; Mon,  8 Feb 2021 23:14:27 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id b8so9216925plh.12
        for <stable@vger.kernel.org>; Mon, 08 Feb 2021 23:14:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=S+sMkSo6dn2kP/aFfK2LSuC7WihCbOQVPuXN48/qnPI=;
        b=YFgzfOL6NeG3jbLyP/CXIO4QrdKB1JijXmALW53R3e3tzin4mXFOn/foqVNl1m2eT5
         QYN0ZAeltXIvw/K/uX2+L04xmu5DMj06S4h+W1fN8PAnEHPXnKar0mlx/YZZjueuEGLw
         +uEsmhmiTz89GqtMHnutBAhoYwsq0cF9we3ZcrArmBXrCy6CLKU3yCN4UJH4y6g5jmHm
         r/GBdgV6ACd4VTStzB9GpSVaS/jIn++Vn9kU33Dx69+KJqkBR/6y4y/m9OdpuRmfETv2
         VYktmxq+s+2HjtQMI40fmLKjg81aKl4248KX4dgm3cfupqTqZtQf5M8rzvUbdl5wiX9Q
         T0vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=S+sMkSo6dn2kP/aFfK2LSuC7WihCbOQVPuXN48/qnPI=;
        b=ZntDYYXr6AAt9l337xRdPmvEY8sARU3sXZ6SVhT2kXT/EQSNlCnJqUq5iFzfiVzjTM
         UXnynQlRqiaSecouyVmc4XMPhK8Y2nvL6+XYsa+O3IM8+cP3ez7RERO4MjnliJJeH8B4
         d8mlR5g6ZO6OiAosfP4MiNesF1p+oTjaGpXGtNxNPRAnPiol4+FqtsYztX9eQTA31Yhe
         /RANvXemzYJvb1EuVjo8dDBjAjbgkYQr30quWAHex3IWjP+pTwlk750elOxA/C+yqcY1
         OH+UMqizSsA7e+7abB6PzX1uRJuwUxhfSENBMx0AM917f9mNym6eMc7JvBTZVHAWd4kA
         NPDw==
X-Gm-Message-State: AOAM530b4o9zyq3AB/NgrN0EOwCXkuvuvGjFUXN0RfG1yWElwmT/UYSd
        /dWoIYYr+k3IwQ7VN6FTNWS1nS5EtblBKQ==
X-Google-Smtp-Source: ABdhPJxXfJErn96wtgpBVV+PBdXNes/JrbYB8C7BGouPQKL2BxMRE5AuWGDGQuM8kZylYOrSrQvf/g==
X-Received: by 2002:a17:902:ce83:b029:de:6b3c:fcd2 with SMTP id f3-20020a170902ce83b02900de6b3cfcd2mr19674698plg.67.1612854866975;
        Mon, 08 Feb 2021 23:14:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t25sm8139364pgo.87.2021.02.08.23.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 23:14:26 -0800 (PST)
Message-ID: <60223652.1c69fb81.2b825.434c@mx.google.com>
Date:   Mon, 08 Feb 2021 23:14:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.256-39-g1a954f75c0ee3
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 32 runs,
 1 regressions (v4.4.256-39-g1a954f75c0ee3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 32 runs, 1 regressions (v4.4.256-39-g1a954f=
75c0ee3)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.256-39-g1a954f75c0ee3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.256-39-g1a954f75c0ee3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1a954f75c0ee3245a025a60f2a4cccd6722a1bb6 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6022047fd76b4485a53abed9

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-39-g1a954f75c0ee3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.256=
-39-g1a954f75c0ee3/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6022047fd76b448=
5a53abee0
        new failure (last pass: v4.4.256)
        2 lines

    2021-02-09 03:41:47.494000+00:00  kern  :emerg : BUG: spinlock bad magi=
c on CPU#0, udevd/115
    2021-02-09 03:41:47.503000+00:00  kern  :emerg :  lock: emif_lock+0x0/0=
xfffff26c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
