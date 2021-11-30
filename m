Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA28F46297D
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 02:14:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235127AbhK3BSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 20:18:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233381AbhK3BSI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 20:18:08 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED72C061574
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:14:50 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id l190so17924387pge.7
        for <stable@vger.kernel.org>; Mon, 29 Nov 2021 17:14:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=QvwXJccLaiiSMzhp1fdNysEMiYQd5ujr9WpfQ6BH7WQ=;
        b=WKNDSqKsvMcb1mZRF+Bi64iisvd9Q6iXuVXJPb04OAdlZbaX5mYVaqQpbMpRrrmypP
         IzDJy1v2MrDIx9S/flWrPgEW9xmZnKv07BvosbxGsSY8MOkXXNezKOdn7AOxx6F4Fe5x
         08SVKWEqQBbc+9vHv/ETFKG/njIJsQvFXs1UsCs1jWPRWldZwfHEJHEw1xgCuAQUQrEv
         CU1n0VinoNM2WhdDVcmornFpUjemKnKZyyjJfgcQeIbKl6TDoHxh3eQMhIAq8RUD68M2
         LE05sr0B+ENjvm1CVO73+KbxztouKK9n43rxiUXY5dhM6kopQYunnUoVfHftetYy3pgc
         dlMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=QvwXJccLaiiSMzhp1fdNysEMiYQd5ujr9WpfQ6BH7WQ=;
        b=mmQCXNPHIbKXGsF6AfSxRBofg1AYbXJp0fqtE90aRn3IvSp3n0cJXIinFrceJSL3ca
         FpIkukYbjehDgK5NKvHx91mIvszpy6gBE2aoLdVaJ/ks7e0LCjqTtRduGTcPy5qRBFhk
         mxL75pV8ODKlREWT2MmwwnXBiKStAAcECoRBNdN73pN24M62v5Tvr5KJVy4ejaaXLW5O
         K/1Nw8V/6LViYhD9b+bebw8oWnT4mm5CEKEcUfcEHEO60p3jKyREDOdolK1UUJjxR5gE
         Bhsm7+FE6YnAa2HEHBCcrP5yWJIYr4jHV4HM3LuN0RAoXYx/y+/YSwF8VQQIsvnM3KrT
         JCUw==
X-Gm-Message-State: AOAM533k6Eh9klpqPtfTo/CG4ocORZwtU+18nCJ1Vh3to/Tq4tJHsxvi
        l6NJ4su6l7mhvk6Vh0AOddi1s6WyJ2kZCoEM
X-Google-Smtp-Source: ABdhPJwHACfHYSe1+6bJIdh2Wqw+EAUTBRxjDDp64tzT3SPmMBwWGQ34a5by+8BOrIie30INOHO+yQ==
X-Received: by 2002:a63:6a87:: with SMTP id f129mr6499750pgc.391.1638234889560;
        Mon, 29 Nov 2021 17:14:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w1sm18213131pfg.11.2021.11.29.17.14.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Nov 2021 17:14:49 -0800 (PST)
Message-ID: <61a57b09.1c69fb81.cb5fc.2f4e@mx.google.com>
Date:   Mon, 29 Nov 2021 17:14:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.218-69-g47df34871c3d9
Subject: stable-rc/queue/4.19 baseline: 106 runs,
 2 regressions (v4.19.218-69-g47df34871c3d9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 106 runs, 2 regressions (v4.19.218-69-g47df3=
4871c3d9)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.218-69-g47df34871c3d9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.218-69-g47df34871c3d9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      47df34871c3d96129c019948f0c699aecb1627e7 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61a5457956e1b0447518f6e0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-69-g47df34871c3d9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-69-g47df34871c3d9/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-mi=
nnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61a5457956e1b0447518f=
6e1
        new failure (last pass: v4.19.218-59-g1172201594ac1) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61a545c9216358a00118f6f8

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-69-g47df34871c3d9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.218=
-69-g47df34871c3d9/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a545c9216358a=
00118f6fe
        failing since 4 days (last pass: v4.19.217-320-gdc7db2be81d5, first=
 fail: v4.19.217-320-ge8717633e0ba)
        2 lines

    2021-11-29T21:27:21.715602  <8>[   21.555816] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-29T21:27:21.759613  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/112
    2021-11-29T21:27:21.770348  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
