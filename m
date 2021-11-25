Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3950C45E034
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 19:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348546AbhKYSIm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 13:08:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355687AbhKYSGl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 13:06:41 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B80BC06139B
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:59:03 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id h24so5656716pjq.2
        for <stable@vger.kernel.org>; Thu, 25 Nov 2021 09:59:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dVv4z6N1GITKbVyHNFgMVzGoy/3eqSTrXJcCl74eopY=;
        b=py+pVZ99QyC66hfubM6tq+0rm+ytGLym3xYyBmfKDMv5Vq+0GV+GwDsIr/r2K9mhQd
         UEP0TrQ7bAjvxwGVNv1OK/EZTLZMLG00MN1qDzwgTIdcz+dhVmkDcnVztn0F3ykrtymH
         izYwqKVerpy8iGI09wmuumFHz3kJ1t3sGAkP+eBi5wphCDpZABlB5yh6u3yYS4rWA+jM
         HILHcxrc1rO4HRXz78YU5eQISjl89qgs6JHUCIVQL6DFbayHf1iYy/UGQBWeQcKzd30Y
         J6e9UMAb4GXPbpfaD5sKcJJjbpt7nv991+KXMXK0iyMdd6CIoM2uoPthVxKxf+mdk4+Q
         q2+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dVv4z6N1GITKbVyHNFgMVzGoy/3eqSTrXJcCl74eopY=;
        b=WKA1Zl0+2FMluKUkX3A54aHD11QkFCv7h9v4d2rnT7nArnTNmlJ5KM6LOuP8OaP09X
         FlCdw09bAW7pIL4RiAY5ihAEu3zLchagKx5evgLykpNyjoQIkiPUcSycOzolBrZzupRa
         LGTd4su+hvhFxzjkIHpyWX8j4ozteoOvUuvIQKTQ9s7DFJhwhJ/NcX2DzICuKVOjlIJR
         tkG9w+icVM3hjguTlIo+6XdOwJ2JIwy8VkyOj9d8XgvXQj5uRo3dO+YoFKbN4R3X3xbY
         ylRCtyNdPg8tL8BVM51oztG8g83hWL1PlHjVGyu9lyyN5uq7tvAsMvn0E08sEDB+C5rV
         piiw==
X-Gm-Message-State: AOAM530DiTE/PDY1K9YNTt7ft/tNExm+w8NdwUWEdy/251NV0HC0bHUq
        L7zXaxVDsuGmZVSBDD4W6biwRcPKBrqxmIyKImc=
X-Google-Smtp-Source: ABdhPJxPwRHVyZUhyJD1xGXQ+zqFF6c9zRDghDUP8j7OPkOW/bZlPCdmQelqoG/7nVVsaARiG19/Xg==
X-Received: by 2002:a17:90a:b88d:: with SMTP id o13mr9045871pjr.39.1637863142615;
        Thu, 25 Nov 2021 09:59:02 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c9sm2911869pgq.58.2021.11.25.09.59.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Nov 2021 09:59:02 -0800 (PST)
Message-ID: <619fcee6.1c69fb81.cbd73.7afe@mx.google.com>
Date:   Thu, 25 Nov 2021 09:59:02 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.81-153-g1c7a950f6da7
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 172 runs,
 2 regressions (v5.10.81-153-g1c7a950f6da7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 172 runs, 2 regressions (v5.10.81-153-g1c7a9=
50f6da7)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
      | regressions
-----------------------------+-------+---------------+----------+----------=
------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
      | 1          =

qemu_i386                    | i386  | lab-cip       | gcc-10   | i386_defc=
onfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.81-153-g1c7a950f6da7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.81-153-g1c7a950f6da7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1c7a950f6da70bc2d04c55cbc9721d0b7071d3d2 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
      | regressions
-----------------------------+-------+---------------+----------+----------=
------+------------
meson-g12b-a311d-khadas-vim3 | arm64 | lab-collabora | gcc-10   | defconfig=
      | 1          =


  Details:     https://kernelci.org/test/plan/id/619f99101f1f202f22f2efe1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-g1c7a950f6da7/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-g1c7a950f6da7/arm64/defconfig/gcc-10/lab-collabora/baseline-meson-g12b-=
a311d-khadas-vim3.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f99101f1f202f22f2e=
fe2
        failing since 0 day (last pass: v5.10.81-153-gc68f60f1d94a, first f=
ail: v5.10.81-153-g3504055afb99) =

 =



platform                     | arch  | lab           | compiler | defconfig=
      | regressions
-----------------------------+-------+---------------+----------+----------=
------+------------
qemu_i386                    | i386  | lab-cip       | gcc-10   | i386_defc=
onfig | 1          =


  Details:     https://kernelci.org/test/plan/id/619f97cd9668730a1bf2efa3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-g1c7a950f6da7/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.81-=
153-g1c7a950f6da7/i386/i386_defconfig/gcc-10/lab-cip/baseline-qemu_i386.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619f97cd9668730a1bf2e=
fa4
        new failure (last pass: v5.10.81-153-g3504055afb99) =

 =20
