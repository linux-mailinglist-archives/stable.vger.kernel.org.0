Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 090F145383D
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 18:04:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236720AbhKPRG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Nov 2021 12:06:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236663AbhKPRG4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Nov 2021 12:06:56 -0500
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 393E2C061570
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:03:59 -0800 (PST)
Received: by mail-pj1-x1034.google.com with SMTP id cq22-20020a17090af99600b001a9550a17a5so2816183pjb.2
        for <stable@vger.kernel.org>; Tue, 16 Nov 2021 09:03:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TwPBl3O0mXJJTwxaTG1ytV4XBeSeBfcbTaK2CP4GVf0=;
        b=m4HYd9CkFmA9V2iFMQLH15hWbnq2/Z+YotBZjILKiDJqwSpIEC1D8gYV1r1AgjtAcF
         LFk7LM69n19823WIc7U6TnWM0A3rB3HR/2CX91G1yoOWwqbfD8Y6RdR4Y/3s/9OFPcME
         /x4jWSQfX+nru+HifEjq+pqg2ndekmCLi6OmB9bFhgEXfo5yTxlU+k+r4mUL0ew/TCDY
         2hUWnBm9mKjGNAHErYYDPhr26AJlOl5zVYaCq6k9W61qvyD3jzZZf6IEoWMII1uIeGmd
         2er9SHwnBCGS5aXvsCWsczj4oJlPF7u9k5lfkH/OolDsTF1aiN0SxEbj79cZkHjCiVdj
         N4Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TwPBl3O0mXJJTwxaTG1ytV4XBeSeBfcbTaK2CP4GVf0=;
        b=SaskMkVH5jYFJ+w+lGOXUizzdQJygkcjjWqH51X3jx/Wd0SthupLg6r4e1rVxjWe+X
         7+vOFCvUKkcsBaV+RPM77+13owSJXXZaBk1Ew4W3K1omz4YEfvole1KC/txRSrXgRu9l
         wFRdOa1EO91NYuU8QvOrlna/NSvzMWYCiW7nVHqZmURjsl8GggD8MdFghfg5raEOpjsS
         ifuOGaTQpIo8NqNTsOu1MEAgNBDmswHiavajMGTvG91VQPzihQ8954ylu2sUDrf6wUev
         OgY4+cWs1t4DthC3xJxeHugtow0xW7tiupmyxvzrTGY+qEaL1Tp10420m9z2xNaOAsKT
         X7fg==
X-Gm-Message-State: AOAM530D1odhVFj2Ia462j7fjg2zVyEiLbptkQcqP0kPMZEBV4lCzdSv
        TW7WQkvklzHOI5OAcei7okMQFKPOYWtcEZhf
X-Google-Smtp-Source: ABdhPJwtxze7EE5gkFfHuGwqiy6SK4xcRulj8h20XL3VoRd1mednCUGdOyZgqpLMllKcMkmK44QX9Q==
X-Received: by 2002:a17:902:748c:b0:141:c45e:c612 with SMTP id h12-20020a170902748c00b00141c45ec612mr46866922pll.73.1637082238574;
        Tue, 16 Nov 2021 09:03:58 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c1sm21202461pfv.54.2021.11.16.09.03.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Nov 2021 09:03:58 -0800 (PST)
Message-ID: <6193e47e.1c69fb81.46314.ba57@mx.google.com>
Date:   Tue, 16 Nov 2021 09:03:58 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.4.292-113-ge9a92f80c735
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.4 baseline: 80 runs,
 1 regressions (v4.4.292-113-ge9a92f80c735)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 80 runs, 1 regressions (v4.4.292-113-ge9a92f8=
0c735)

Regressions Summary
-------------------

platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.292-113-ge9a92f80c735/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.292-113-ge9a92f80c735
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e9a92f80c73581d31b2eec0225c5241c4cb7f81b =



Test Regressions
---------------- =



platform         | arch   | lab         | compiler | defconfig             =
       | regressions
-----------------+--------+-------------+----------+-----------------------=
-------+------------
qemu_x86_64-uefi | x86_64 | lab-broonie | gcc-10   | x86_64_defcon...6-chro=
mebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6193a96b7ec3bb9be63358e1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-ge9a92f80c735/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.292-1=
13-ge9a92f80c735/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-broonie/=
baseline-qemu_x86_64-uefi.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6193a96b7ec3bb9be6335=
8e2
        new failure (last pass: v4.4.292-113-gc0addc794063f) =

 =20
