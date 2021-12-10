Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA5E470C8B
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 22:28:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344363AbhLJVbh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 16:31:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235807AbhLJVbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 16:31:37 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D6F1C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 13:28:02 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id gf14-20020a17090ac7ce00b001a7a2a0b5c3so10327494pjb.5
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 13:28:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Xj7041Vfsycxu1Ic5PSLMNiSHKOY09B9FdveDnGN3e4=;
        b=AGxn/8JW8jMcEV1G+d0YljZB9yveeFNKMXv3tuSD+PUq3hyZnQwzz+cDzSGewyTzIX
         CDQY04TiWIhbkC98x7bdOYC8ZsJqBThmTARv1Cpp288V6xjohI3pXHhUnlpVPsHGrP3s
         DRAEZO3Fmd/hOCTkIdz6AARpH0jBvuke3I7BgVWfDy98K919JdD0KvkJ+TVX778Av0/l
         jvgo8wba7s8XIpFdtyzlpDEN9n4DycbwG0PB6bc3STX7p7N8FGbuBlgGgfmepoPBdmvg
         r2q9fAqUKH7IS1nZuEGpo3vZd0iSfjXxNWOiLNTfUZbGlAlBWODH8OMI2ZzhjxvSdwrU
         iR+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Xj7041Vfsycxu1Ic5PSLMNiSHKOY09B9FdveDnGN3e4=;
        b=Vodmnd3HHaIaf2iPeEzUzBayf9D+pAnArwSu+nOyJK2MlgddSOWp7iYWCxUUW1TSyB
         8CRtq8vJbnpXqV77+tDwLgX04Pb7cGVBOFJ+tzsv0mPWwgXyzr8iqzM/o9Us0w3e6Y+Q
         IlMSjWbLiutkVMf1dCZnvP+PqOw6MrWhsN8PVzmviO6RdzrHiHy2FWUwFgRjlALuMYK2
         lCGa6Fc1R5g1lj10XScS+al4VXZIob1IURr9kuxJbjh2EtETd/FIdjX2k33IEwhuRhcH
         DJJ8zeIQP04p4x4a64xXq56XrcDa1BWDwk8+ViFZJ203NcU/1E46KNdVO6Js1EhW9xJv
         TNLg==
X-Gm-Message-State: AOAM532ItxrCvm9cBQPL8Fpefx38dyy9ZapRDoflA2mz5uQ27CgvkNat
        DTLE+lMyRaDkxOxgAGYNwKijzlAzusEGms5F
X-Google-Smtp-Source: ABdhPJztgU54xywkNshs/Vd6lNaQfyaWZHZuySjlYXZXhQEaBKYnBwORm/eDtudnmDnJG7eNeV4JdA==
X-Received: by 2002:a17:90b:2252:: with SMTP id hk18mr26843234pjb.218.1639171681414;
        Fri, 10 Dec 2021 13:28:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h8sm4623613pfh.10.2021.12.10.13.28.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 13:28:01 -0800 (PST)
Message-ID: <61b3c661.1c69fb81.c040e.dbaf@mx.google.com>
Date:   Fri, 10 Dec 2021 13:28:01 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-19-gb25ac2999a81
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 165 runs,
 2 regressions (v4.19.220-19-gb25ac2999a81)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 165 runs, 2 regressions (v4.19.220-19-gb25ac=
2999a81)

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
nel/v4.19.220-19-gb25ac2999a81/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.220-19-gb25ac2999a81
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b25ac2999a81b3c6bd5bd4a44c70a33b8a46f1cd =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b38a5ef50afa601239714b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-19-gb25ac2999a81/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-19-gb25ac2999a81/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b38a5ef50afa6012397=
14c
        failing since 0 day (last pass: v4.19.219-56-g730dd2023c98, first f=
ail: v4.19.220-14-gb7524491658f) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b38aed2d92d00318397137

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-19-gb25ac2999a81/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-19-gb25ac2999a81/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b38aed2d92d00=
31839713a
        new failure (last pass: v4.19.220-14-gb7524491658f)
        2 lines

    2021-12-10T17:13:56.415914  <8>[   21.138031] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T17:13:56.464979  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-12-10T17:13:56.474188  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
