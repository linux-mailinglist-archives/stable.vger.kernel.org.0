Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547866E7F82
	for <lists+stable@lfdr.de>; Wed, 19 Apr 2023 18:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbjDSQW7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Apr 2023 12:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231190AbjDSQW6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Apr 2023 12:22:58 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D1AD273B
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:22:55 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id 98e67ed59e1d1-24b29812c42so410437a91.0
        for <stable@vger.kernel.org>; Wed, 19 Apr 2023 09:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681921374; x=1684513374;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=anybPyFbaovdTSoYqs4UAldT477JauNdG3gdzUflWIk=;
        b=wQ44N8ql/vFoP3Kg1dm33AroHP07v5I5Oe20yp/RUx0Kt6svINlZQwB6VbY3l4++vN
         Ere1QMP+cVIOaf93sU+AOUsJtBmWTGbWZLK0qUoXLYB27YfRPYdO+fSMmn8dBGiGn+82
         73C4ckNW5LA2JOO+yFjr77YtMbxImV7hZF+s3bA3vhOt97NHDhs7cEkB1u7cxE7jIhAW
         qo9zV5dF1wWUPBCsbg5gonR2JPRGVj6PnhdR6u1mf7IP4lgWk73r1ENyx9T0KstUn+QK
         kBzC7xWV6EsRvVprtSuL5JKvzNRvj8G3MKHpbmWIYUaqxuRwZCLzo+msdkYUpxOH6Bh1
         PlBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681921374; x=1684513374;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=anybPyFbaovdTSoYqs4UAldT477JauNdG3gdzUflWIk=;
        b=hfS50ZpBPJQWlFLKWFoROvrJN3itJfWGCCMK8rMhiLSD8XXGJT7GJIsf7EiGPH7Ub9
         9PPeFbVM5U8teQoNqRI0EJnikxYSaTEpgMx3wt1uVMN9e6ZVSo8A8gsLnI9gwAz+uT9n
         mGP1aUuY4eOR7+IsB9i6KF+3wDaP5neOVJmB8v+kKQ8ajrMEY6G+Qd73vkINTO28jhes
         FZ93qZMP9m01yeTRXBM5w4Cu/CQF3a11zH8V91/QTYdU5L9LqOei6FNpbOck7W+Sf21R
         7G8rgkdAhlVIYrVZSXoS+XoXi3rc8KXx6zK61HtXXFMDiHLIBUHAjLWsSzGLh11Yb8do
         m6cg==
X-Gm-Message-State: AAQBX9cp3brXdS1KxcxHI6U7UlGLwKxnBvghgTvZMqgfUxH/7FJD4yC9
        MWXcUCZqchaivegtJ4mQle7FS0zNLYEnOjOYbh8O6EhL
X-Google-Smtp-Source: AKy350bHrF76FtKRwUOjGGoWu2dbbigqbc0d5tY6TLFV7CbmOvJOxdyig4G/Xmbcn3uHrtJzbaQtig==
X-Received: by 2002:a17:90a:4d09:b0:246:94cf:6c49 with SMTP id c9-20020a17090a4d0900b0024694cf6c49mr3452840pjg.20.1681921374277;
        Wed, 19 Apr 2023 09:22:54 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2-20020a17090a318200b0024739d29252sm1601493pjb.15.2023.04.19.09.22.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Apr 2023 09:22:53 -0700 (PDT)
Message-ID: <6440155d.170a0220.302da.3c89@mx.google.com>
Date:   Wed, 19 Apr 2023 09:22:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-478-g612789500e617
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-6.1.y baseline: 177 runs,
 15 regressions (v6.1.22-478-g612789500e617)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-6.1.y baseline: 177 runs, 15 regressions (v6.1.22-478-g6127=
89500e617)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =

qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =

qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-478-g612789500e617/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-478-g612789500e617
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      612789500e617a8ffd9c7c1a25ba6d3566d88b60 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe263aa6f11eee72e85f4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe263aa6f11eee72e85f9
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:44:59.613651  <8>[    9.772830] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045945_1.4.2.3.1>

    2023-04-19T12:44:59.617203  + set +x

    2023-04-19T12:44:59.718825  #

    2023-04-19T12:44:59.719069  =


    2023-04-19T12:44:59.820058  / # #export SHELL=3D/bin/sh

    2023-04-19T12:44:59.820252  =


    2023-04-19T12:44:59.920969  / # export SHELL=3D/bin/sh. /lava-10045945/=
environment

    2023-04-19T12:44:59.921187  =


    2023-04-19T12:45:00.022203  / # . /lava-10045945/environment/lava-10045=
945/bin/lava-test-runner /lava-10045945/1

    2023-04-19T12:45:00.022518  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe25d4cca1abc032e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe25d4cca1abc032e8606
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:45:07.111202  + set<8>[   11.314044] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10045898_1.4.2.3.1>

    2023-04-19T12:45:07.111688   +x

    2023-04-19T12:45:07.220019  / # #

    2023-04-19T12:45:07.322965  export SHELL=3D/bin/sh

    2023-04-19T12:45:07.323756  #

    2023-04-19T12:45:07.425881  / # export SHELL=3D/bin/sh. /lava-10045898/=
environment

    2023-04-19T12:45:07.426698  =


    2023-04-19T12:45:07.528681  / # . /lava-10045898/environment/lava-10045=
898/bin/lava-test-runner /lava-10045898/1

    2023-04-19T12:45:07.529972  =


    2023-04-19T12:45:07.534753  / # /lava-10045898/bin/lava-test-runner /la=
va-10045898/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe26f7e5902176f2e8612

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe26f7e5902176f2e8617
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:45:15.387900  <8>[   10.682617] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045957_1.4.2.3.1>

    2023-04-19T12:45:15.391353  + set +x

    2023-04-19T12:45:15.493307  =


    2023-04-19T12:45:15.594365  / # #export SHELL=3D/bin/sh

    2023-04-19T12:45:15.594550  =


    2023-04-19T12:45:15.695521  / # export SHELL=3D/bin/sh. /lava-10045957/=
environment

    2023-04-19T12:45:15.695714  =


    2023-04-19T12:45:15.796482  / # . /lava-10045957/environment/lava-10045=
957/bin/lava-test-runner /lava-10045957/1

    2023-04-19T12:45:15.796807  =


    2023-04-19T12:45:15.801760  / # /lava-10045957/bin/lava-test-runner /la=
va-10045957/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe2f1c993238c022e860a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unle=
ashed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe2f1c993238c022e8=
60b
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe23d95caaeebea2e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe23d95caaeebea2e85f8
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:44:36.862893  + set +x

    2023-04-19T12:44:36.869400  <8>[   10.956469] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045880_1.4.2.3.1>

    2023-04-19T12:44:36.974170  / # #

    2023-04-19T12:44:37.075284  export SHELL=3D/bin/sh

    2023-04-19T12:44:37.075477  #

    2023-04-19T12:44:37.176383  / # export SHELL=3D/bin/sh. /lava-10045880/=
environment

    2023-04-19T12:44:37.176560  =


    2023-04-19T12:44:37.277703  / # . /lava-10045880/environment/lava-10045=
880/bin/lava-test-runner /lava-10045880/1

    2023-04-19T12:44:37.277972  =


    2023-04-19T12:44:37.283346  / # /lava-10045880/bin/lava-test-runner /la=
va-10045880/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe25a22d4f0a8622e85fe

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe25a22d4f0a8622e8603
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:44:59.688622  + set<8>[   10.440003] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10045943_1.4.2.3.1>

    2023-04-19T12:44:59.688739   +x

    2023-04-19T12:44:59.790354  / #

    2023-04-19T12:44:59.891585  # #export SHELL=3D/bin/sh

    2023-04-19T12:44:59.891812  =


    2023-04-19T12:44:59.992766  / # export SHELL=3D/bin/sh. /lava-10045943/=
environment

    2023-04-19T12:44:59.993215  =


    2023-04-19T12:45:00.094585  / # . /lava-10045943/environment/lava-10045=
943/bin/lava-test-runner /lava-10045943/1

    2023-04-19T12:45:00.095420  =


    2023-04-19T12:45:00.100915  / # /lava-10045943/bin/lava-test-runner /la=
va-10045943/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe250aa6f11eee72e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe250aa6f11eee72e85eb
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:44:46.441455  + set<8>[    8.796716] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10045922_1.4.2.3.1>

    2023-04-19T12:44:46.441894   +x

    2023-04-19T12:44:46.550437  / # #

    2023-04-19T12:44:46.653325  export SHELL=3D/bin/sh

    2023-04-19T12:44:46.653989  #

    2023-04-19T12:44:46.755724  / # export SHELL=3D/bin/sh. /lava-10045922/=
environment

    2023-04-19T12:44:46.756423  =


    2023-04-19T12:44:46.858393  / # . /lava-10045922/environment/lava-10045=
922/bin/lava-test-runner /lava-10045922/1

    2023-04-19T12:44:46.859855  =


    2023-04-19T12:44:46.864304  / # /lava-10045922/bin/lava-test-runner /la=
va-10045922/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe251bb5aa0a8bc2e85fc

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643fe251bb5aa0a8bc2e8601
        failing since 19 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-19T12:44:51.729172  <8>[   11.104400] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10045910_1.4.2.3.1>

    2023-04-19T12:44:51.834592  / # #

    2023-04-19T12:44:51.935670  export SHELL=3D/bin/sh

    2023-04-19T12:44:51.935942  #

    2023-04-19T12:44:52.037155  / # export SHELL=3D/bin/sh. /lava-10045910/=
environment

    2023-04-19T12:44:52.037843  =


    2023-04-19T12:44:52.139674  / # . /lava-10045910/environment/lava-10045=
910/bin/lava-test-runner /lava-10045910/1

    2023-04-19T12:44:52.140739  =


    2023-04-19T12:44:52.146022  / # /lava-10045910/bin/lava-test-runner /la=
va-10045910/1

    2023-04-19T12:44:52.152383  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe104973babfdcc2e85eb

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_=
mips-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/643fe104973babf=
dcc2e85f3
        failing since 0 day (last pass: v6.1.22-178-gf8a7fa4a96bb, first fa=
il: v6.1.22-480-g90c08f549ee7)
        1 lines

    2023-04-19T12:39:24.508879  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address eebb0ee8, epc =3D=3D 80202014, ra =3D=
=3D 80204964
    2023-04-19T12:39:24.509010  =


    2023-04-19T12:39:24.532842  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-19T12:39:24.532957  =

   =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe2385c78ad48a02e85ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_riscv6=
4.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe2385c78ad48a02e8=
5ed
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fea98de8310512c2e861f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_riscv64=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fea98de8310512c2e8=
620
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_riscv64                 | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe206c434b28c532e864d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_riscv=
64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe206c434b28c532e8=
64e
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe23aebd219a1572e85e9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-baylibre/baseline-qemu_smp8_r=
iscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe23aebd219a1572e8=
5ea
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-broonie   | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643feac08a4d87bf1a2e85f7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-broonie/baseline-qemu_smp8_ri=
scv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643feac08a4d87bf1a2e8=
5f8
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_smp8_riscv64            | riscv  | lab-collabora | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/643fe207c434b28c532e8650

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
478-g612789500e617/riscv/defconfig/gcc-10/lab-collabora/baseline-qemu_smp8_=
riscv64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643fe207c434b28c532e8=
651
        new failure (last pass: v6.1.22-480-g90c08f549ee7) =

 =20
