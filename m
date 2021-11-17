Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9F54454950
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 15:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhKQO4I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 09:56:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbhKQO4H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 09:56:07 -0500
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3227C061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 06:53:08 -0800 (PST)
Received: by mail-pf1-x42e.google.com with SMTP id n85so2876852pfd.10
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 06:53:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ijgCSk9RnMGhIBg3hXlgr/sISbhEMvT5V9s3yuBT2+I=;
        b=WWSyHzEQdSSz6mOIdSp4u6bBYBQI+pbYUrI9OZ/MjDvbmjOsIndNIIMOG/CbCdegjw
         03qILtld+CX6JTzOhKbidvpQxOd2UYvI58ddUCLNgxZJQ7/P89Bgn1DGqCGqWwDd2rdE
         p6gYgFysohchIqJkciwkQkxAiK9Ne2a19vbCpajs1GRFpDNkNuH3NDngIwcLMnb39DCv
         32MgSfW98SDvMLztDCCKynpwGcSpA/70bB3dCQuIq95prnQGv0z/hLcgegFni/SafVY3
         C7WjUjj/AYrJMLiyBL8IIS0grGNUBTXy0x5Ofl36bSgcMRNIr9aB/5ung8xSpQgaNfl/
         PU/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ijgCSk9RnMGhIBg3hXlgr/sISbhEMvT5V9s3yuBT2+I=;
        b=UaDrXcXfiPlhjZMsV/8hbMaRCBk7gh54vBmZinD3693ahwc8OD84N2Cfv3O333PDD8
         7ovDzfoq91adAg5zNxprk+MrQJlBJKeloDbVEQAgCnvZWm0oR6cnk86aBkQ+iA2lkjL+
         8O2KmimCHXv5j5C7Y1xXMM6c+GHsVlL8nMGjU/83JkFLuumXHmBXu2wb+mYHTYPcBpa4
         UlUMf5+2DF3Jnfg5AXPJZx6nYjBcJLcznvQ/38Llu7yla9hVo5YsEDStIf6+PSbW17Kv
         92VXzj1/mgqAswbKlHpIqh+0lUs+QxvNFjm7cyeGaHJ/uArEKYmnmnaPDr/vHCIY72Ct
         w0Ow==
X-Gm-Message-State: AOAM5306lgTdonqpiMnXLlFW3VAFDKtn64yvtrUNQ2VcBhQArYeCRTx2
        OgkIEL/Agx6vGH+/+OReKH0fhNjw85y7G/r+
X-Google-Smtp-Source: ABdhPJx22ShXXONBkyeKh5dhqgQVUHMbbv34FoULsw5K3CndNTCuu/AVJyRzTDBIw7v72RTw3MpTVA==
X-Received: by 2002:a63:d74a:: with SMTP id w10mr5639176pgi.341.1637160788121;
        Wed, 17 Nov 2021 06:53:08 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t7sm5725992pjs.45.2021.11.17.06.53.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 06:53:07 -0800 (PST)
Message-ID: <61951753.1c69fb81.b5a7b.04aa@mx.google.com>
Date:   Wed, 17 Nov 2021 06:53:07 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.14.255-199-g19adfc3d75c6
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 79 runs,
 1 regressions (v4.14.255-199-g19adfc3d75c6)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 79 runs, 1 regressions (v4.14.255-199-g19adf=
c3d75c6)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.255-199-g19adfc3d75c6/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.255-199-g19adfc3d75c6
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      19adfc3d75c619b72b1fdb574162d970818d2bc8 =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | regressi=
ons
---------+------+---------------+----------+---------------------+---------=
---
panda    | arm  | lab-collabora | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/6194dd6874308c7e653358f5

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-199-g19adfc3d75c6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.255=
-199-g19adfc3d75c6/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6194dd6874308c7=
e653358f8
        new failure (last pass: v4.14.255-199-gb184298c8e64)
        2 lines

    2021-11-17T10:45:44.991747  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/100
    2021-11-17T10:45:45.000653  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
