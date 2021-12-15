Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C47F475114
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 03:53:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235539AbhLOCxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 21:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233288AbhLOCxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 21:53:05 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A67DC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:53:05 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id h24so16072129pjq.2
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 18:53:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SoL3k9cUn54zI4y+/jk/8M7dHEgr8QWHiXo2ZQg2g+s=;
        b=b31EhVnQ6ukm9vmLfv3+scOTHx1h6mUxYNyHLZT9bfzBhRrxjWp/NR9wXfvtnW2hha
         zQTEDxW9uOrKhGwf23BmGdEZdesbyKg9KtKlLD3D/2ppMxS+8e0VOIMeAKtRY8/Q3VLg
         EHJP9q7FZHgi45UmVWjNp9pvq3uYNtuS9pjnC7FWqTUzIO3OwX6+/lG7mpqrEFsnf1Vr
         Q6Oc2jSJqijgX6TD85XmtLwp6+vRleThC4BaxxH3eNpWGfZ8MfxlMfyCQjyYcLTb9g+c
         szOtYNblVctNb6GIbWfVRlAhSRehxlhP0irqzpJ7zPaOig8zLgH+cwM33OsVdiWGBYsK
         55Eg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SoL3k9cUn54zI4y+/jk/8M7dHEgr8QWHiXo2ZQg2g+s=;
        b=jnFcwwNr5uWTePbuKwY5HGVkfdAr1F4hVlBPhujx05aCCsoXBdjq+Q2vybrZDxIKhM
         8fbuGuEcnuOWy26Nx8NlL/tYrQ6KjjldZW9CbCPzuupxDx2P4M1m/T/qrHdFqcgLiDx1
         gYb7Zlll52HUkg+JQg0zJbId1k4MdtUtKRhXU+HKMSGiaC+hKAurCwzp7SVeWHp9QTuz
         r53BO6fNcD6U+MaPqDFdhOLC8iTo6PZ2OXHurR3CCLpLuXgieCbHiPs0JkOxoTkmU9yb
         poYZwJrDm/khk8URN26bMvrzNPIM+n6vT7qAEZ8xvx7LCsDAjUpJWTF/2R54wrd0B44y
         abVg==
X-Gm-Message-State: AOAM530QS7xV/JktK8ZuHmMWPdK3612MPtHkcjh5Bhw0W0VVZIxUPiXg
        SMDEMESKmCBg4q9VImZXEm7AewjFei0l5Ffh
X-Google-Smtp-Source: ABdhPJw+08uyGMcgCqcvhb8wr1tyzu1SLqfy6YwEDa/qhKMgmMU9NVNnF+8ojAbF3oU35epUXDkQDw==
X-Received: by 2002:a17:903:120c:b0:148:a94c:35f with SMTP id l12-20020a170903120c00b00148a94c035fmr614191plh.132.1639536784778;
        Tue, 14 Dec 2021 18:53:04 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id k16sm433187pfu.183.2021.12.14.18.53.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 18:53:04 -0800 (PST)
Message-ID: <61b95890.1c69fb81.c763b.20f9@mx.google.com>
Date:   Tue, 14 Dec 2021 18:53:04 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.221
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 142 runs, 2 regressions (v4.19.221)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 142 runs, 2 regressions (v4.19.221)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.221/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.221
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5fd3cce374df811af0c71585bc3d1096b04da9c9 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b91f2b7a6afa3835397130

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b91f2b7a6afa3835397=
131
        failing since 1 day (last pass: v4.19.220-51-gab7df26443b3, first f=
ail: v4.19.220-75-gc65e8cddade7) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b91fdae1b8ecda5739713d

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
21/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b91fdae1b8ecd=
a57397140
        new failure (last pass: v4.19.220-75-gc65e8cddade7)
        2 lines

    2021-12-14T22:50:57.501007  <8>[   21.379882] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-14T22:50:57.545609  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-12-14T22:50:57.555063  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
