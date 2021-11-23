Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B5CE45ADAE
	for <lists+stable@lfdr.de>; Tue, 23 Nov 2021 21:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbhKWU7w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Nov 2021 15:59:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232112AbhKWU7w (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Nov 2021 15:59:52 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 343ADC061574
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 12:56:44 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id y7so134107plp.0
        for <stable@vger.kernel.org>; Tue, 23 Nov 2021 12:56:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=XeH9wZh7k3gyR6jy5pg8DTOavFC7G+581IVjJGfZDD4=;
        b=l+YiaKmtepzaltTnEMoWNRq4NcE+dxt5goMMpBwkYT9KS+Us/rpcKP37aB6lnv4cK2
         CbF1qyOIu/uSttmfKiwfkGaKzGPOlz3GOt8Lc8uJO8+J0Xlqs3chQH8vouItVreUrTdM
         4v/UC54NjPRthrLWfX9Z7uq6R3ih27ZKm+rWPishGM0TP+igZfaY7gMK6OgbBD0ueF3C
         8R9uq0pdbEZ0yvNNb3IBawZmE0rK3ruT8zYpx+9kc754p7jb5+6h0dW9JIsUDfWBaIuw
         70bqUBcsKCYF2HqYI0O9Ia9N4woM5JwX9YoQVfqqYskNNyp62oUIQQdtHAKsJ3mqx7JY
         Tiig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=XeH9wZh7k3gyR6jy5pg8DTOavFC7G+581IVjJGfZDD4=;
        b=yOp2zOPvCUK69LGLFMTwI5fU5IO3lrNoDyz7YCR7i1mvCr5AKXAxAvlWflxCegqJq3
         7ExVnIyEzCIlWgdgK8lgq01TgT+ALxu50eh3tsV2gEoWf0EABgxz0LJ0poZsq9bK++A4
         /cJUPDZ/OdHqV2duuF0ANRBII5q3cgYZSMg2PcXWwtHcBZYBhiRGMzvkwp8as5I5cO0E
         Upaw3Q3KMTzOVodDpHSyl3m4JnLz3Ih0U9YPLZ+snC2LxWFnuqC1VnVqp8FM2cxeP7ee
         KPq69Jk5hleJc2yBCFPyQdIdvDGnuGA4kagOL7KxynlFPEqLZxsIbMiAmvIZizWlmkn7
         ya5A==
X-Gm-Message-State: AOAM532Zam8W0D0DJSgNZ4YIdWkJuqIUbNpMSfyOcwNUBKpghykuqonG
        cr8ifbyTWYH6pbJDlLIkzqR8tv54RMc7vyz4
X-Google-Smtp-Source: ABdhPJyeBYiRY8eGubJQYUWdG7e68ZoGiBribSIgvpYj5BLbfoX8XcruIZtBp55sZR1oB/kO6TPn1Q==
X-Received: by 2002:a17:90a:c986:: with SMTP id w6mr6841420pjt.27.1637701003107;
        Tue, 23 Nov 2021 12:56:43 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id bf13sm1995956pjb.47.2021.11.23.12.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Nov 2021 12:56:42 -0800 (PST)
Message-ID: <619d558a.1c69fb81.94029.4bfa@mx.google.com>
Date:   Tue, 23 Nov 2021 12:56:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.255-247-gef0c1521b3af9
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 135 runs,
 2 regressions (v4.14.255-247-gef0c1521b3af9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 135 runs, 2 regressions (v4.14.255-247-gef0c=
1521b3af9)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-247-gef0c1521b3af9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-247-gef0c1521b3af9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ef0c1521b3af974cb705ed5dca9c5f98d0e4f8e1 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/619d1a50ccc14f8864f2efbb

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-247-gef0c1521b3af9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-247-gef0c1521b3af9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-p=
anda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/619d1a50ccc14f8=
864f2efbe
        failing since 4 days (last pass: v4.14.255-198-g2f5db329fc88, first=
 fail: v4.14.255-198-g6c15f0937144)
        2 lines

    2021-11-23T16:43:40.329728  [   20.088073] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-23T16:43:40.369829  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/95
    2021-11-23T16:43:40.379272  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-broonie   | gcc-10   | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/619d2c4f181cb97674f2efc6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-247-gef0c1521b3af9/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-247-gef0c1521b3af9/x86_64/x86_64_defconfig/gcc-10/lab-broonie/baseline-qem=
u_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619d2c4f181cb97674f2e=
fc7
        new failure (last pass: v4.14.255-233-g18e656325ab1) =

 =20
