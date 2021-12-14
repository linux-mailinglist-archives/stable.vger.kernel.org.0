Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A5564743CF
	for <lists+stable@lfdr.de>; Tue, 14 Dec 2021 14:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234546AbhLNNrC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 08:47:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhLNNrB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 08:47:01 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B33CFC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 05:47:01 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id r5so17372187pgi.6
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 05:47:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=b3JCuzFBeCrtjJVMzhllIp6EQfIYsJJyKyTAR5XBY/8=;
        b=6RAoHx/gvTAbE63a57bMVzzrxoopHFNAw+W3x6M9hGUH5kdiHgKKzNNogCsYUXqP40
         H3HTRCqgjRK1UPD24EqKjHolzM66V5Bloh2FOscqJSifYSL1uZsdIrQiRGC/Jp7Erg1c
         gO8976c5197cotT7Pqu9uaMv7uTlfFyXGYESkXRujgMG4AqZhsVdtgz+HITPPq0DiXhx
         bPjWOO7u5H8uDa5O3j3PKs/hHgGd4irxlpXw1JxNghUvaCxNweReND5GFkgFl2BE2Vio
         co6P6CKGY/MmCvrnRi4RIQn/OHn2IADyTvnfmytJX/kFqK+m3uJOPnJcrjIb821aYLbc
         05jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=b3JCuzFBeCrtjJVMzhllIp6EQfIYsJJyKyTAR5XBY/8=;
        b=0As7tpJLs1G1Hue6k+Byr2uZGg3JA90OG1HFRa7K0Ett48B6nVc1JqrG/IxwqXLJ/N
         QBEjv6c6GVC2EG/EnNsrQxWmffpuCkv/xAgA9/R6yFxM6ptCggqPQzn/ZWeiRo7mHFvs
         TyL3ZOeKcnezTfWd6ldO7tCVrftEYevbvHh+7mmvUvoR0mknjTPo2KXchgseIvMHGYez
         3/NbT50JmN+P5Ibeu3uXM2V8Md1j1akbhSEuLmhlTSkUUQa12esW9Go8MptSgp6hjEbH
         dydasjrpm7V+J0rru/421fC8RAKs3hx/w0cZpn5WCoby0pQ0KkMEhCSxk2C1Mm2WZfu2
         6fZg==
X-Gm-Message-State: AOAM533ALfjINxfX1pQdIijtQRDzu+9uxQAmo5W+4nbgL50ByU4tsoaK
        6T8/CvGURDbr35dBkhgce9NDiPBj4wmrd5pP
X-Google-Smtp-Source: ABdhPJyXrvviLIz9KwpdXndEcZAZaZmbHaWvWOUncWNYFCnkWg3VxyoH1Rjj7L2HxK4rN1yOl33n9Q==
X-Received: by 2002:a62:d414:0:b0:4b1:3bf5:2b6d with SMTP id a20-20020a62d414000000b004b13bf52b6dmr4315473pfh.24.1639489621092;
        Tue, 14 Dec 2021 05:47:01 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q18sm15349691pfn.83.2021.12.14.05.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 05:47:00 -0800 (PST)
Message-ID: <61b8a054.1c69fb81.33115.b0a2@mx.google.com>
Date:   Tue, 14 Dec 2021 05:47:00 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.293
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Tree: stable
Subject: stable/linux-4.9.y baseline: 92 runs, 2 regressions (v4.9.293)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.9.y baseline: 92 runs, 2 regressions (v4.9.293)

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


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.9.y/kernel/=
v4.9.293/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.9.y
  Describe: v4.9.293
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      98d396d082d499d85ea373e3f8d6e7906c232cda =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b86a377b51d63732397135

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.293/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.293/x8=
6_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot-E382=
6.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b86a377b51d63732397=
136
        new failure (last pass: v4.9.292) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b869f7dc40d4299e39716d

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-4.9.y/v4.9.293/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.9.y/v4.9.293/ar=
m/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b869f7dc40d42=
99e397170
        new failure (last pass: v4.9.292)
        2 lines

    2021-12-14T09:54:44.360976  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/116
    2021-12-14T09:54:44.370174  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1   =

 =20
