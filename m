Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23ABB5894F9
	for <lists+stable@lfdr.de>; Thu,  4 Aug 2022 01:43:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236936AbiHCXnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Aug 2022 19:43:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236574AbiHCXnl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Aug 2022 19:43:41 -0400
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5EED5D0E6
        for <stable@vger.kernel.org>; Wed,  3 Aug 2022 16:43:40 -0700 (PDT)
Received: by mail-pg1-x529.google.com with SMTP id 12so16479638pga.1
        for <stable@vger.kernel.org>; Wed, 03 Aug 2022 16:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=rEeTYueQhjm00RdijQEgYhtgifTtJmuE/y9H7cZdANk=;
        b=WRUrrcT7PWcKiybHEc89NZJfWHblVG36Yf2BJJi3FKVIiYLDsuQZSnbKflKDa6QzU8
         CThvbSQY/qXHwjrDyKQ550oc+iW4mJOwigJE/A5m2dkE35QCJi2Orb7MFrHyIKwkUIQa
         AKB0O96kfYLXuswzJSwUlaAT7oj7ovrK20OzSwFEZFDQi2rBL3yA+DwEjkZC0tEUhZlU
         VPLtja9ZZ9RwRGoebpqHRajE1KRSYhbKP6nj8Kd/mT+3stYb7VJO7SThZCzMqTjtaFKo
         DafxZhae0zHN6Qp32vn6oolE4vlR8EunkFyPoh1oEGP4ARvEl++4QgZuUkJOrHEP1PsK
         gY5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=rEeTYueQhjm00RdijQEgYhtgifTtJmuE/y9H7cZdANk=;
        b=rWokRM0EmHuoDC0RYIjMiMzt1jJqhlkWuGLNekkAUKK0WIiugYQHq7vHI1npxegAQQ
         n5QtuKGGVbu6ibREPAZ/3xZRyRsvC6PGsLCgs95SOZcG9j5zNJw398dVFHZM26hogPAs
         DTYNLN2BRr7qf/o9NW6fagW8B0PXht/NGzTIHMfzb+v6UzQ/HEUJEamuRQVGJX215Ol+
         3QnVgWVD9yS4sRhgMWLXYYiBw26l7x0STZuHWsK7m0Va8z9QoTQPGnQoxLgEo/sspff/
         DhDLjiJbYtMXy3NxFKAWY+xzD3CaCO0C59pw/iwrnUpPKljRc5wx1HUYXpVZOIkEBXiM
         li8Q==
X-Gm-Message-State: ACgBeo1H2mWIn/USo8aX9+qLZ2OIBzt7UQaz+kAPAcr9Unb5JgZcEZzt
        xKoKMgCefyyMUOJe45+HHodCuIiB6wMfqyJgDeY=
X-Google-Smtp-Source: AA6agR6M8tN0DQqiIAj7LNIdkUrF6xt+g34vUYNf1ySNbXuDOy9izBliC2XXDGtud/z0ibeg0Bnrjw==
X-Received: by 2002:a65:66da:0:b0:41b:ee3f:6262 with SMTP id c26-20020a6566da000000b0041bee3f6262mr15599340pgw.204.1659570220075;
        Wed, 03 Aug 2022 16:43:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y13-20020a17090322cd00b0016c4fb6e0b2sm2613169plg.55.2022.08.03.16.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Aug 2022 16:43:39 -0700 (PDT)
Message-ID: <62eb082b.170a0220.a9212.4ae5@mx.google.com>
Date:   Wed, 03 Aug 2022 16:43:39 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.18
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.16-7-g7fc5e6c7e4db1
Subject: stable-rc/queue/5.18 baseline: 126 runs,
 2 regressions (v5.18.16-7-g7fc5e6c7e4db1)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.18 baseline: 126 runs, 2 regressions (v5.18.16-7-g7fc5e6c=
7e4db1)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.16-7-g7fc5e6c7e4db1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.16-7-g7fc5e6c7e4db1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7fc5e6c7e4db1f0b90065bacbdbe126f875151e7 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62ead0c06eae40f0ffdaf070

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
7-g7fc5e6c7e4db1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
7-g7fc5e6c7e4db1/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-mt8183-kukui-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ead0c06eae40f0ffdaf=
071
        new failure (last pass: v5.18.14-247-gfd39859e7d1b3) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/62ead0bb27ea971a57daf066

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
7-g7fc5e6c7e4db1/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.16-=
7-g7fc5e6c7e4db1/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220718.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/62ead0bb27ea971=
a57daf06e
        failing since 3 days (last pass: v5.18.14-186-g9e5d3e20f8a4d, first=
 fail: v5.18.14-239-g0cb79a713f90e)
        1 lines

    2022-08-03T19:46:51.968412  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 76d3ef04, epc =3D=3D 801fef18, ra =3D=
=3D 80201bd8
    2022-08-03T19:46:52.006462  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =20
