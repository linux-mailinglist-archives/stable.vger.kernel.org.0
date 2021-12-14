Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47D75474518
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 15:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232720AbhLNObc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 09:31:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231174AbhLNObb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 09:31:31 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B565C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:31:31 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id np6-20020a17090b4c4600b001a90b011e06so16138573pjb.5
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 06:31:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=f248qzp+GXxwdG3rXPt1tkVJQYdH19VX/3z4OqL3jiE=;
        b=PcI5vKvjrrewAb4W7lyvDj2z5GD9Dc1ofc7+OoURuhGouZ2JP1nuYwqxvZp/DjrG+B
         I5/Lz50KSIx1F+AMxwrDcTFJPAfecZabGNMW63Py4zsxd9GzR6iTVmK77vUGOsiImAiQ
         X/i6mdW/PFzPhxeHbx7xhBgmbx/Mpcr+K8jfTmIUnVCTVUeloGkxWS5GWv0Y2TwOskWs
         x2zwuyb+98eLn5mId0tW9a9ZmGOVNbkmWe97c/e3DBhxvR23YzifuAqcexRpmLcUs0PL
         E76v6kF0nJ5XBXd9UrB9ixzFiVeOmbzcV+MsHmtL4Emd5W4r7JRXM7Tdw5PG+oDnmADn
         t5OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=f248qzp+GXxwdG3rXPt1tkVJQYdH19VX/3z4OqL3jiE=;
        b=ooIuHMxJAPnr/W7XhV9ka6qlyqE+NNXsaKX9K4rdkylTq8rSa1QLc70Vb/cIuNIoVw
         5gSP45h1h5qn4XdIuDSzFHpjf+4tmFh0gQg8jAvgqBkzAB+ZMqgWvR32aiMV+t2JV9Ir
         YAcp8JtMj0AlT+OvoqiAW5vrSXIrLINdLhBFxqrZMzoz0Kc8wzDhOQCI7UW/QdWi+etN
         qO8izcuqhTDeOk7SndiIHHilIkogDNSpvuFmrZSqwUEzNGdOeCeyzP1j3F/Wzsffa0+t
         ttBgc7g69pRRe/vhr5y5G1jpw6Sx0ELQObwxiu179ji+7JCiZsB05uJSSvPKiXXynHv0
         8fjg==
X-Gm-Message-State: AOAM532OJz3Cf9lIMD5Jc5/F2sCLDwNNP82n3VIVV3xzpHLg9ZfvSNDt
        SKbv6fn9K/kBxhi7ieSD64ER00q0pbNqaw40
X-Google-Smtp-Source: ABdhPJx2fLO4aC/xF91BH5CoMeSGX1ZKlf8cZjt3K5qn++CNu6YftHAM1vNCddh5qQicnm9TO/6IAA==
X-Received: by 2002:a17:90b:4a92:: with SMTP id lp18mr5925118pjb.55.1639492290378;
        Tue, 14 Dec 2021 06:31:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id l1sm2633611pjh.28.2021.12.14.06.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 06:31:30 -0800 (PST)
Message-ID: <61b8aac2.1c69fb81.424f6.6b03@mx.google.com>
Date:   Tue, 14 Dec 2021 06:31:30 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.14.y baseline: 121 runs, 2 regressions (v4.14.258)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 121 runs, 2 regressions (v4.14.258)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.258/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.258
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      9dfbac0e6b8600043de8dc85ed072f5f1342dc15 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b870f044946e439e39713b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.258/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.258/=
x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b870f044946e439e397=
13c
        new failure (last pass: v4.14.257) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b86f344b32f91f4d39711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.258/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.258/=
arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b86f344b32f91=
f4d397121
        new failure (last pass: v4.14.257)
        2 lines

    2021-12-14T10:17:06.917084  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/99
    2021-12-14T10:17:06.924445  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
