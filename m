Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3F9A30FCCE
	for <lists+stable@lfdr.de>; Thu,  4 Feb 2021 20:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238253AbhBDT3x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Feb 2021 14:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239794AbhBDT3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 4 Feb 2021 14:29:03 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3771DC0613D6
        for <stable@vger.kernel.org>; Thu,  4 Feb 2021 11:28:23 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id m12so2275158pjs.4
        for <stable@vger.kernel.org>; Thu, 04 Feb 2021 11:28:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DdblqR/W0h/xLbgU2rNu2jM1CutYey8064JLhF8Ho3k=;
        b=i+5h9GouCDrqeeUUACwWURR8OpkJBqKhEln7QSBVOoiMT6A5aSnnD5eeJ2EdJcNLoN
         7gFoE0d0kONRjHbPoUlcX+wgXCjmDbMMkspcQqBF8nL+MxOVn//eEsAy46sGPtdCWW9E
         4mBmQrAQanGMNjGmJI9/aotRfamSb8/ISzcfhzkVVct40KU1hFWbcHpS+ePRIvwb/6by
         NOndMtnab0jjMlqF8DAqBLjhWhwUQnNQUJo2vzOulbyA73bpnwSTgUSuOdP+H4PWvJ3w
         8bMJIDbpPql8U5mRp+COnid80ULy5VR1vbhn9AkW/XsAnkTi57zrzjJSnKOoo9M8IRlQ
         bKBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DdblqR/W0h/xLbgU2rNu2jM1CutYey8064JLhF8Ho3k=;
        b=eC0P88xD5TiRUxfi7NOdv7YETZoyuhORFNgVHd97AWURCxA/4oZFEg5raiILNv7/Pe
         rIvdrOHWzRo4qwa+FlExoOiU0cJWHkQo+aWHhGFDzGmSbVoemI/AlfHET2aFaoIJK2D2
         ObJ50Q2Tb8dnWqSGC3XTnQWcF+DU2mmBDtvYiJzkin2wtlxBc1SzuJ/RCzWbK4FdmxP1
         VM3z+8e4cwJ0Ygjgyf0evl0NixMR/v7jihIg9sKRcnXaNjhPSJ1zs48YqI6Dn6m8Rek6
         F9UdPgmKjU5nLYXmKuhJwbd0KC/gyc3v6ZWCHeLJgeKQ1lzLKsHRRMFvjZ4+q1+pyAl7
         ESoQ==
X-Gm-Message-State: AOAM533aejIXYMSZWiBQf+N0LBKi1gizt7SdR3BIiUaUIzmNRnYpPu20
        gHQxV2MymO4rww+vs2Vw77a8ZOBox45Pfaqd
X-Google-Smtp-Source: ABdhPJyHEwt9TOX80TxFPOCkhAjsDW0RHZPk4Pd9Nd7Kmmqf8cQIji/icDH1WiAneNTeDtFDS4cCuA==
X-Received: by 2002:a17:90a:fa2:: with SMTP id 31mr471751pjz.57.1612466902456;
        Thu, 04 Feb 2021 11:28:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f3sm6231189pfe.25.2021.02.04.11.28.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Feb 2021 11:28:21 -0800 (PST)
Message-ID: <601c4ad5.1c69fb81.e5306.d943@mx.google.com>
Date:   Thu, 04 Feb 2021 11:28:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.4.255
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.4.y
Subject: stable-rc/linux-4.4.y baseline: 64 runs, 2 regressions (v4.4.255)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.4.y baseline: 64 runs, 2 regressions (v4.4.255)

Regressions Summary
-------------------

platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =

qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.4.y/kern=
el/v4.4.255/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.4.y
  Describe: v4.4.255
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2f9c581dbde4e48aa0c002ddf3892d6bcd89c1a2 =



Test Regressions
---------------- =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64      | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/601b5d1e0d806f83e93abe6d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.255=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.255=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b5d1e0d806f83e93ab=
e6e
        new failure (last pass: v4.4.254-29-g9c98a187325d) =

 =



platform         | arch   | lab          | compiler | defconfig        | re=
gressions
-----------------+--------+--------------+----------+------------------+---=
---------
qemu_x86_64-uefi | x86_64 | lab-baylibre | gcc-8    | x86_64_defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/601b5d08e3da5d83d53abe67

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.255=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.4.y/v4.4.255=
/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/601b5d08e3da5d83d53ab=
e68
        failing since 1 day (last pass: v4.4.254-21-ga0b92ce8371e, first fa=
il: v4.4.254-29-g9c98a187325d) =

 =20
