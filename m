Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418CB474732
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 17:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbhLNQKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 11:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233351AbhLNQKu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 11:10:50 -0500
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA214C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 08:10:50 -0800 (PST)
Received: by mail-pf1-x436.google.com with SMTP id k64so18209637pfd.11
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 08:10:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MJYs2tC5jAfNnoPJ7DBE5nBHL6spHCo+pOciLWd+TuM=;
        b=8Kt3j59jnKCKQCyZA9sbtoBU98+RVLia3EFxJ+U96FVcydTZUcab04k9jXhjJTrci6
         IJkDQ6uySuPKgTA2ZZD2MhTpgjrcoxVxcyEpV3Jx4laLa74W9OzOdMnGRVeXlJ3cjxcy
         zLsdnz7jmUO3A8D6ISv6eOK7xoPP+HoVVcfPKw8GJOja3coNELK/fuQxbHRmAsWhSHjN
         rZm2QQW0C61EgW96VgOAoAakXd/vXuVpHBGx0xytsF2VcHlyDZTy3gBXAUEKGXnFcsff
         24ZC1OHklY16EM+ttK7s5M7XZjz0jOkd+3mLAf0gc5PY2QGH/07pj33ueU60IHy7NUq6
         t6yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MJYs2tC5jAfNnoPJ7DBE5nBHL6spHCo+pOciLWd+TuM=;
        b=obSKy2T3YCgVMKYYZdUE0Oz5v9JFZc9gvD6xskzCVjsthGWmHmKj9uwz8BtvozGcIe
         egS3gJTwRA3pho5meh794VPfW8hIBYzZn2v2hpFy0RW7sXP4P4GonDxPXhEh6aHRHqg+
         rXAKvCT1hHPsMQIGSq5C0ZYNNkEz1KPh9nJVUzT/5pZlq3EZeaaxu6BLM7sDggb21jvk
         cKDFze8MFt14oadgN8Zq/iXPY6g+tuXr21aCm1juaTViWbgKaTJZbzMGaINJ4CRX1jLg
         8viBWoQMxFmL6p+4Anjwc3/iy99giTMlcqkGmkAutKi903Mh+kOrQ5XsqqsuFaTIhR6o
         nEPw==
X-Gm-Message-State: AOAM531Rgvzc5yWisG9gvfEs+KR3DMOVU7GujNwQvs1qfeplAAClxYOB
        F5gqZqrOnLOb39xqR3t5f/YtSi7WfjJRuiy4
X-Google-Smtp-Source: ABdhPJzCxQe5VMFUVxm93LCIqbnNJ2WEsEbrp3Vw8jCFzhBhu2HDfTGUpmF2N+sNtgU09x4gCpArmQ==
X-Received: by 2002:a63:7c1b:: with SMTP id x27mr4356637pgc.176.1639498250167;
        Tue, 14 Dec 2021 08:10:50 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ls14sm3303801pjb.49.2021.12.14.08.10.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 08:10:49 -0800 (PST)
Message-ID: <61b8c209.1c69fb81.a6479.82ec@mx.google.com>
Date:   Tue, 14 Dec 2021 08:10:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220-73-g3a5a4233740e
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 111 runs,
 2 regressions (v4.19.220-73-g3a5a4233740e)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 111 runs, 2 regressions (v4.19.220-73-g3a5a4=
233740e)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.220-73-g3a5a4233740e/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.220-73-g3a5a4233740e
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3a5a4233740ef12d80baa6b876767af35621b671 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b8869afb085b877c397146

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-73-g3a5a4233740e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-73-g3a5a4233740e/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b8869afb085b877c397=
147
        failing since 0 day (last pass: v4.19.220-50-g08088af69537, first f=
ail: v4.19.220-74-g36a00096e704) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/61b886465ed03825b1397131

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-73-g3a5a4233740e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.220=
-73-g3a5a4233740e/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b886465ed0382=
5b1397134
        failing since 1 day (last pass: v4.19.220-27-g87731ec9404c, first f=
ail: v4.19.220-50-g08088af69537)
        2 lines

    2021-12-14T11:55:35.968923  <8>[   21.191894] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-14T11:55:36.013416  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/109
    2021-12-14T11:55:36.023056  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
