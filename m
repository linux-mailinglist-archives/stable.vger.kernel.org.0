Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D795F470F8F
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 01:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241751AbhLKArG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 19:47:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237381AbhLKArG (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 19:47:06 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B718DC061714
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:43:30 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso8881514pjl.3
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 16:43:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=UfxI0ktwUvwfApHZdVKYBwUjTiQ7XSAfAAz7wiVTCEM=;
        b=5PtG3fjMU08yY1cXvCUc/inJu163OwPF4ndmHHYdN8fhGIeho1jFNcsqBhDTCJzPZS
         1pw9YzyaVNx1K7i9kop1sScfmTW49vuOJ/YO/z2Ymq2le9EFnUg02wlzeApEd6gmW7KJ
         yUjk3t+RlCnvJOu5hjBE864ZzM/HbLhAHiB4k4rmNFPK+l222Qg7O32mR4CCx/rCrpML
         dhPQmQdHRHQ7Qvcj7ewl/ho8fIcmcMSPYuJsrF7GAhpnwd2u3QPZnmbhSqN3H+JN4Kl3
         n4YKHA5ean77HyVXvhxHGsdmePomO7kMQIWppO1wQx/5LkyMW9SYCvgCI6/N5GkN9VYY
         5iyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=UfxI0ktwUvwfApHZdVKYBwUjTiQ7XSAfAAz7wiVTCEM=;
        b=LfYtg28v6r3QDt3APRhicT/qozodH3Fyqt9V++/gpgdKxV89G+kinDx590QaBP23qz
         b3Gkd62jshMeW/cwf29Ir1i+fJgOrO2yiTk4v3ra9Kitllg4zOPwrHbeaqNz4SudQdCs
         DF3hVsdtgo8tGDOFhva3o0zNGIpEhZsGCO1u+LddQFpYWwlK7xlybUHwsicGuXrrYQU6
         QLSMgrkGYa77gYJ2uhAyZZxAXFnhT9cvXFfWIsDbOBkeD6RIVssNxIIAZdGKT9aPJns3
         O7EJnbfg76hxOnfFnX9BCjA+KzmRqEoJXP3MjF7ED4eVhBlU0YvoZgizS30vWbK9/aEs
         UJnA==
X-Gm-Message-State: AOAM530+lFI42WKMRg51s/LmKpUQlsA/sCHBHs9bEGnU3kEQBsYwW6Ci
        fwHFkmp/3rzRUX3TIOnaTd9eXw2unaHZDY5H
X-Google-Smtp-Source: ABdhPJyq6QFHlN31jLoCyG9yzrQ4G5I+462Bm71rOxXYZwyLNKNy6VIwqEcWa/rMaSeccO1FSymHVA==
X-Received: by 2002:a17:903:2344:b0:142:25b4:76c1 with SMTP id c4-20020a170903234400b0014225b476c1mr80178849plh.43.1639183410104;
        Fri, 10 Dec 2021 16:43:30 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm4667784pfu.183.2021.12.10.16.43.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 16:43:29 -0800 (PST)
Message-ID: <61b3f431.1c69fb81.6d044.e6a4@mx.google.com>
Date:   Fri, 10 Dec 2021 16:43:29 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292-10-g8eabbb4fb693
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 125 runs,
 3 regressions (v4.9.292-10-g8eabbb4fb693)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 125 runs, 3 regressions (v4.9.292-10-g8eabbb4=
fb693)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.292-10-g8eabbb4fb693/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.292-10-g8eabbb4fb693
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8eabbb4fb6931f52575953d33ac3276dc9e4ee0c =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3ba62924bd6b71839713a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
0-g8eabbb4fb693/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
0-g8eabbb4fb693/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3ba62924bd6b718397=
13b
        new failure (last pass: v4.9.292-9-g6988c513714d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3bbb69dd931ec4b397124

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
0-g8eabbb4fb693/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
0-g8eabbb4fb693/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b3bbb69dd931ec4b397=
125
        failing since 0 day (last pass: v4.9.291-70-gd8115b0fbf8b, first fa=
il: v4.9.292-9-g6988c513714d) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3ba0a157b9d3d9439711e

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
0-g8eabbb4fb693/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-1=
0-g8eabbb4fb693/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b3ba0a157b9d3=
d94397121
        failing since 0 day (last pass: v4.9.292-8-g267327cffca6, first fai=
l: v4.9.292-9-g6988c513714d)
        2 lines

    2021-12-10T20:35:04.430202  [   20.306823] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T20:35:04.474786  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/118
    2021-12-10T20:35:04.484102  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
