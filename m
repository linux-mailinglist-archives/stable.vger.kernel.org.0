Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3C729946E
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 18:54:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781507AbgJZRyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 13:54:53 -0400
Received: from mail-pj1-f49.google.com ([209.85.216.49]:54929 "EHLO
        mail-pj1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1781502AbgJZRyx (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 13:54:53 -0400
Received: by mail-pj1-f49.google.com with SMTP id az3so3629097pjb.4
        for <stable@vger.kernel.org>; Mon, 26 Oct 2020 10:54:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KVxhP7n6vKVcCo6i1iQnxkbpt5bGE1rKP+dRUQTWgz0=;
        b=brsJPMC1V2KlZUBVKqJwn3tSXWJ5aQogbwU8FQp5cf53BTXPrujDMR8bgEz7SCotXW
         O9ll56S29n2wLHO1hMWadL0DElEv7N464OxbtpAlKgawXoGaHN9K0fQ0UsDzsBiWuXs/
         lPmkprCsaCsN16JMHV+oqF5WjidHL2w13yhZrCIO8b43dxa0N0iKOo6W+0JLnnPbwAMq
         GWgo0qKH0ucwauatoIrTb8+75xDtUy8UUfphIMRqsXR4lg8oON1F08pDBn8D9E+1gwfJ
         Q30tC56HcG0/uvCGUvSYQwXyES8g2+uyx5b1KNj0LBeY/cOmc+caZtvDVx4P0k7ueieO
         ayMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KVxhP7n6vKVcCo6i1iQnxkbpt5bGE1rKP+dRUQTWgz0=;
        b=i6pbDVOeDobQYsZk1vmxp16OfRFTFbqb4RIZhvTyviiB28VjNy5ocUap4nnSP94O+j
         TfCMVZuU52Mrnh2N8sNEzw+5HjTReN9dBEcy4UcYle7coBIxTNt/xIG1clU+/idvBx7T
         LY+Fi0+cvUteEAO12DPwF7SFC8Vw/D3KbQoS/2Hvp/eBZdWtN/QQ42UMMVHcTOBARGVd
         fYHiacJTUIUNayWbCPa+Kak2WH5vJKNwooCij2DqPaDlngKgH0zJCORoWhCz7xgRapBi
         GwKxrtGweehcYRxqlYHGNY5SV2RciAsKy8P3YAZ+A9Zr5ifaP1ekjvLHUYl/W5OZwQkD
         Ggew==
X-Gm-Message-State: AOAM5321WJ6cxvHsjSdgyvI7kGDwV3GFKoJKHp6NQzm0EMezCfC/hpgj
        UW0k5MZlCniPy7VpYNQMOWZ2EASKphDFCQ==
X-Google-Smtp-Source: ABdhPJz2lp8W1K6XN4R/35+sndejMMIP+Y1zRaIKqRkJfRW2lopdRZtQqxjA8SV0Ard0jwySlSKCwg==
X-Received: by 2002:a17:90a:f198:: with SMTP id bv24mr17647072pjb.230.1603734891783;
        Mon, 26 Oct 2020 10:54:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e6sm11212374pgn.9.2020.10.26.10.54.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 10:54:51 -0700 (PDT)
Message-ID: <5f970d6b.1c69fb81.b7373.60c5@mx.google.com>
Date:   Mon, 26 Oct 2020 10:54:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.240-109-gfb6a031a221a
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 70 runs,
 5 regressions (v4.4.240-109-gfb6a031a221a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 70 runs, 5 regressions (v4.4.240-109-gfb6a031=
a221a)

Regressions Summary
-------------------

platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =

qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_i386-uefi   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =

qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =

qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.240-109-gfb6a031a221a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.240-109-gfb6a031a221a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb6a031a221ae97d890e13d85ca53429df6c4a10 =



Test Regressions
---------------- =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
panda            | arm    | lab-collabora | gcc-8    | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96dbe65066a5146a381017

  Results:     3 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f96dbe65066a51=
46a38101e
        failing since 2 days (last pass: v4.4.240-11-g59c7a4fa128e, first f=
ail: v4.4.240-18-ge29a79b89605)
        2 lines =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386        | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d9f22d35b5cc18381128

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d9f22d35b5cc18381=
129
        failing since 0 day (last pass: v4.4.240-18-gec7216aecf8f, first fa=
il: v4.4.240-109-g76d7a01ba8bf) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_i386-uefi   | i386   | lab-baylibre  | gcc-8    | i386_defconfig      =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d9da1628de916c38102c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: i386_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/i386/i386_defconfig/gcc-8/lab-baylibre/baseline-qemu_i386-=
uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d9da1628de916c381=
02d
        new failure (last pass: v4.4.240-109-g76d7a01ba8bf) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64      | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d989db59b140fb381026

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d989db59b140fb381=
027
        new failure (last pass: v4.4.240-109-g76d7a01ba8bf) =

 =



platform         | arch   | lab           | compiler | defconfig           =
| regressions
-----------------+--------+---------------+----------+---------------------=
+------------
qemu_x86_64-uefi | x86_64 | lab-baylibre  | gcc-8    | x86_64_defconfig    =
| 1          =


  Details:     https://kernelci.org/test/plan/id/5f96d9700b754a715a381038

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-8 (gcc (Debian 8.3.0-6) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.240-1=
09-gfb6a031a221a/x86_64/x86_64_defconfig/gcc-8/lab-baylibre/baseline-qemu_x=
86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5f96d9700b754a715a381=
039
        new failure (last pass: v4.4.240-109-g76d7a01ba8bf) =

 =20
