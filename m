Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142AA6EF9AD
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 19:56:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbjDZR4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 13:56:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230043AbjDZR4d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 13:56:33 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003E435AD
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 10:56:30 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id 98e67ed59e1d1-2470e93ea71so5409043a91.0
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 10:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682531790; x=1685123790;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=xPZMEdAZDuD5brY8ewqneWBzvLhYMfhIpchcOtarksU=;
        b=CjvZpXg1hEeMjU3e0LOr3/ZYj3Lb0UTe1Pziw55U8T4suAiLSh6Yf0Il2Zh6U4bdyK
         nCgkb76KCVLmIuhxKl/dzvIsWvikPFuhQ6Z2ZPv+O6WykhLNIoU8ODIxMKS4nSBblKK8
         urr4YUPC+N1OwSkQaW0BqIrMsFeUkkNpn+uaydUGpG67BLEAXL1x2ucx5IqFlOBgRvpM
         r3WEA3fnTc70LXOvGk2iwIdUh/ulS+2/iXOs+p8trwhtBmb0Qjr5HyR87LR4yKQDO0tD
         EnZJRJy3yUEConJvuRxc1kl+4l/H1s3h/oXmu8hPEV67qwpMOis6Kln1xh97SnEfsdnv
         tlWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682531790; x=1685123790;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xPZMEdAZDuD5brY8ewqneWBzvLhYMfhIpchcOtarksU=;
        b=BpMs6cAJvlMnDm4PLUvyuj7qvjc4hCEteYM9Hn7NoEoaXFkrnE64gazwY/NU/3x6cK
         tRY28xcZSRYyOFLide5BRrJdHOFFr230J9jJ28Ab34+vEJdn2Kk+8RBhmJCbDfUyju6Q
         Ppr9xhDcbkcntGbmFQgj0EcVXe6HrJCOLGJyLluQF14P5/gplNHee1Cvv8CGPb8hscR+
         HxFkMacywSjP9K/VKyPYgdhpeKb+L9lLyQ63GHYaiHU9MZk0PpjRv34PkboM45Gbxzd8
         CDcnEoqeIa1YVHDiP1SXn0QOts8LQBherwBhkBIww1z87esJ8h1HvfLTBvUDogRwjtlX
         Jg7A==
X-Gm-Message-State: AAQBX9ebdaGvxp80j74xYZOe8AjWK8TsQGrUYjf1oiVHJ2CcspRJ1+Qr
        f5v+oeECa2ekG09beZCtLON2b6YYNs6ltjStn0yekw==
X-Google-Smtp-Source: AKy350YSU3eI2NGfeWL2m368I+A0WdQJrCp5UjlDfYQyvj0R4csI6W8A7ELBzkaraOdCK5sBNoYhiQ==
X-Received: by 2002:a17:90a:2ec3:b0:247:a22d:2a44 with SMTP id h3-20020a17090a2ec300b00247a22d2a44mr21582312pjs.36.1682531789854;
        Wed, 26 Apr 2023 10:56:29 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id az1-20020a170902a58100b0019cbe436b87sm10258336plb.81.2023.04.26.10.56.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 10:56:29 -0700 (PDT)
Message-ID: <644965cd.170a0220.6961d.54d3@mx.google.com>
Date:   Wed, 26 Apr 2023 10:56:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-573-g35b4c8b34dab
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 108 runs,
 8 regressions (v6.1.22-573-g35b4c8b34dab)
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

stable-rc/queue/6.1 baseline: 108 runs, 8 regressions (v6.1.22-573-g35b4c8b=
34dab)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.22-573-g35b4c8b34dab/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-573-g35b4c8b34dab
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      35b4c8b34dab9bd2f84167b1e255fefc9104fa2c =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6449313aaf9feecdb92e85e9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6449313aaf9feecdb92e85ee
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:11:57.114973  + set +x

    2023-04-26T14:11:57.121509  <8>[   10.889062] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10132034_1.4.2.3.1>

    2023-04-26T14:11:57.226054  / # #

    2023-04-26T14:11:57.326697  export SHELL=3D/bin/sh

    2023-04-26T14:11:57.326885  #

    2023-04-26T14:11:57.427416  / # export SHELL=3D/bin/sh. /lava-10132034/=
environment

    2023-04-26T14:11:57.427640  =


    2023-04-26T14:11:57.528247  / # . /lava-10132034/environment/lava-10132=
034/bin/lava-test-runner /lava-10132034/1

    2023-04-26T14:11:57.528521  =


    2023-04-26T14:11:57.534484  / # /lava-10132034/bin/lava-test-runner /la=
va-10132034/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644936b57e61d609ea2e85fb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644936b57e61d609ea2e8600
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:35:28.601323  + <8>[   11.354359] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10132026_1.4.2.3.1>

    2023-04-26T14:35:28.601407  set +x

    2023-04-26T14:35:28.705926  / # #

    2023-04-26T14:35:28.806560  export SHELL=3D/bin/sh

    2023-04-26T14:35:28.806749  #

    2023-04-26T14:35:28.907280  / # export SHELL=3D/bin/sh. /lava-10132026/=
environment

    2023-04-26T14:35:28.907480  =


    2023-04-26T14:35:29.008065  / # . /lava-10132026/environment/lava-10132=
026/bin/lava-test-runner /lava-10132026/1

    2023-04-26T14:35:29.008338  =


    2023-04-26T14:35:29.012840  / # /lava-10132026/bin/lava-test-runner /la=
va-10132026/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64493423c96a6214e32e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64493423c96a6214e32e85eb
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:24:12.967165  <8>[   14.692875] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10132015_1.4.2.3.1>

    2023-04-26T14:24:12.970319  + set +x

    2023-04-26T14:24:13.071783  =


    2023-04-26T14:24:13.172378  / # #export SHELL=3D/bin/sh

    2023-04-26T14:24:13.172580  =


    2023-04-26T14:24:13.273125  / # export SHELL=3D/bin/sh. /lava-10132015/=
environment

    2023-04-26T14:24:13.273358  =


    2023-04-26T14:24:13.373860  / # . /lava-10132015/environment/lava-10132=
015/bin/lava-test-runner /lava-10132015/1

    2023-04-26T14:24:13.374227  =


    2023-04-26T14:24:13.378676  / # /lava-10132015/bin/lava-test-runner /la=
va-10132015/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64493443a2e69628842e85ec

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64493443a2e69628842e85f1
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:24:52.522711  + set +x

    2023-04-26T14:24:52.529234  <8>[   10.657712] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10131950_1.4.2.3.1>

    2023-04-26T14:24:52.634584  / # #

    2023-04-26T14:24:52.735278  export SHELL=3D/bin/sh

    2023-04-26T14:24:52.735481  #

    2023-04-26T14:24:52.835977  / # export SHELL=3D/bin/sh. /lava-10131950/=
environment

    2023-04-26T14:24:52.836230  =


    2023-04-26T14:24:52.936876  / # . /lava-10131950/environment/lava-10131=
950/bin/lava-test-runner /lava-10131950/1

    2023-04-26T14:24:52.937233  =


    2023-04-26T14:24:52.941788  / # /lava-10131950/bin/lava-test-runner /la=
va-10131950/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6449333d276637c72b2e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6449333d276637c72b2e8606
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:20:26.676397  + set +x

    2023-04-26T14:20:26.682874  <8>[   13.428882] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10131996_1.4.2.3.1>

    2023-04-26T14:20:26.786993  / # #

    2023-04-26T14:20:26.887778  export SHELL=3D/bin/sh

    2023-04-26T14:20:26.888068  #

    2023-04-26T14:20:26.988695  / # export SHELL=3D/bin/sh. /lava-10131996/=
environment

    2023-04-26T14:20:26.988994  =


    2023-04-26T14:20:27.089628  / # . /lava-10131996/environment/lava-10131=
996/bin/lava-test-runner /lava-10131996/1

    2023-04-26T14:20:27.089989  =


    2023-04-26T14:20:27.094695  / # /lava-10131996/bin/lava-test-runner /la=
va-10131996/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644930ecfce0bb40012e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644930ecfce0bb40012e85f8
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:10:43.167155  + set<8>[    8.692056] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10131976_1.4.2.3.1>

    2023-04-26T14:10:43.167359   +x

    2023-04-26T14:10:43.271588  / # #

    2023-04-26T14:10:43.372174  export SHELL=3D/bin/sh

    2023-04-26T14:10:43.372355  #

    2023-04-26T14:10:43.472869  / # export SHELL=3D/bin/sh. /lava-10131976/=
environment

    2023-04-26T14:10:43.473047  =


    2023-04-26T14:10:43.573596  / # . /lava-10131976/environment/lava-10131=
976/bin/lava-test-runner /lava-10131976/1

    2023-04-26T14:10:43.574017  =


    2023-04-26T14:10:43.578334  / # /lava-10131976/bin/lava-test-runner /la=
va-10131976/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6449345790bfe38ee52e85f7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6449345790bfe38ee52e85fc
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T14:25:09.562233  <8>[   11.207234] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10132027_1.4.2.3.1>

    2023-04-26T14:25:09.666923  / # #

    2023-04-26T14:25:09.767660  export SHELL=3D/bin/sh

    2023-04-26T14:25:09.767908  #

    2023-04-26T14:25:09.868486  / # export SHELL=3D/bin/sh. /lava-10132027/=
environment

    2023-04-26T14:25:09.868729  =


    2023-04-26T14:25:09.969352  / # . /lava-10132027/environment/lava-10132=
027/bin/lava-test-runner /lava-10132027/1

    2023-04-26T14:25:09.969730  =


    2023-04-26T14:25:09.974674  / # /lava-10132027/bin/lava-test-runner /la=
va-10132027/1

    2023-04-26T14:25:09.981045  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/644934b1c96a6214e32e8628

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-g35b4c8b34dab/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/644934b1c96a621=
4e32e8630
        failing since 2 days (last pass: v6.1.22-560-gc4a6f990f6a64, first =
fail: v6.1.22-564-g3588497f7ea83)
        1 lines

    2023-04-26T14:26:50.647188  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 3213685c, epc =3D=3D 80202234, ra =3D=
=3D 80204b84
    2023-04-26T14:26:50.647329  =


    2023-04-26T14:26:50.664285  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-26T14:26:50.664369  =

   =

 =20
