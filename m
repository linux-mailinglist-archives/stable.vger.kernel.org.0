Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E14C0474E65
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 00:00:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235030AbhLNXAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 18:00:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229944AbhLNXAS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 18:00:18 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 809B6C061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 15:00:18 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 133so18481390pgc.12
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 15:00:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=aRCIuw1wJKXDfX9YUVmdp/sOiqfhWYC3E1/R+RsRyyI=;
        b=d3S9PrGhkqbvTnFRiCu0mERBybM6zObEY47JC3ymuPwuWAVnvDF0kFTZboyxEm5iqd
         mHl3OPUDkZprRbk7jMzi+9N5svnJEFgmd6j345BoOd359qncqXK3pR6U1bX4L+6MlvOU
         P/OsukYVxEO5qN4S1+bZXKA3A8vKki/6jPQ9/Ub5ifqpIk4naRhq/pDO8lr8+8vbnZy0
         eWxP8yOldrxqyhf+4Ja2z91isCA1jWXCdWdjcuEE56Im2yv9HXGfuGxxkEH23aNS+D6S
         YD9j5Vxu3suU69FwyAj3WEteCRpvpu3uLYwCI8HxOX1JgrFtRcgSx2GlwZryvCVvQ7gD
         GrLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=aRCIuw1wJKXDfX9YUVmdp/sOiqfhWYC3E1/R+RsRyyI=;
        b=YCd6wfmi98ruRfrtJoHjup6xUl89RMUJ6KJ7Ksgb1DG0ERP+2Wt4d9yyS8Y5VX0a7F
         QLSGbZ+QtvmrfbxQU5m/SpyDAYCH8ReFeIL7Cgu2FQzm9tYQLpnUS+ta/gewEYt0St+C
         Jc/r8XA5Do73F0b4XbTenFNUoKIDeBfZKn9x3DoNMSqFh/PnmmgXu9AKGGa4eUEOU/je
         iuL3YBdK9UktS201nRzxHr62QZo0puklE53W+7XgLOvGxlmP219Z+w9JBtA2lUnF8id4
         HXknllo82YvFLQ5SBYVmCkdrPq1bkFNW3n3nbkG53ZMzXDE2Qge1asE1wFAMdzvPkJlu
         qGIA==
X-Gm-Message-State: AOAM532Bmro8BfUsj8vpAQhUoaTkAftHmMqtltimssRsvKtwxDrL+MGz
        qiXZGHnQvaGKQ3lohZDNIVwcu+4ty6aXC1SQ
X-Google-Smtp-Source: ABdhPJy4RAFGgkCZfZQ0BxjaJ76C6ewMv5WkCx4WsjXoBINmj+JfXNrrYP0WHesSGd+hrBuudqEksw==
X-Received: by 2002:a63:605:: with SMTP id 5mr5489621pgg.522.1639522817765;
        Tue, 14 Dec 2021 15:00:17 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u32sm123004pfg.220.2021.12.14.15.00.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 15:00:17 -0800 (PST)
Message-ID: <61b92201.1c69fb81.b5071.096f@mx.google.com>
Date:   Tue, 14 Dec 2021 15:00:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.15.8-1-g41d9a2be88b3
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 174 runs,
 3 regressions (v5.15.8-1-g41d9a2be88b3)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 174 runs, 3 regressions (v5.15.8-1-g41d9a2be=
88b3)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
meson-g12b-odroid-n2     | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =

r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig   =
               | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.8-1-g41d9a2be88b3/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.8-1-g41d9a2be88b3
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      41d9a2be88b3689e3fc81a402d9eceaefb97147c =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
meson-g12b-odroid-n2     | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b8ed939d0fd4475339713b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-1=
-g41d9a2be88b3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-meson-g12b-odroid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-1=
-g41d9a2be88b3/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-meson-g12b-odroid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b8ed939d0fd44753397=
13c
        new failure (last pass: v5.15.7-171-gb100f8739254) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61b8e8d196ea39bfe339719c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-1=
-g41d9a2be88b3/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-1=
-g41d9a2be88b3/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b8e8d196ea39bfe3397=
19d
        new failure (last pass: v5.15.7-171-g6d3962ea0ace) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig   =
               | 1          =


  Details:     https://kernelci.org/test/plan/id/61b8ed7f0353920274397157

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-1=
-g41d9a2be88b3/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvat=
or-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.8-1=
-g41d9a2be88b3/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salvat=
or-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b8ed7f0353920274397=
158
        new failure (last pass: v5.15.7-171-gb100f8739254) =

 =20
