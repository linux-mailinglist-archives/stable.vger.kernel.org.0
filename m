Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADFF66EF805
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 17:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240905AbjDZPyr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 11:54:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239512AbjDZPyq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 11:54:46 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4441B44A1
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 08:54:44 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id d9443c01a7336-1a6c5acf6ccso55677845ad.3
        for <stable@vger.kernel.org>; Wed, 26 Apr 2023 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682524483; x=1685116483;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=EqAgCO1dAFlTVvD9+F4y2+r8QDGr8l8uQObK2Wewg/c=;
        b=HHy/cWkcHR+cbs9ArPUFs/4zEav3XFmSb/+j/jHX6xRkvKNpBhoGy77xelOglbbmlK
         Mm+nFzXX2oeo0pvzv982Aitvdx70YFFxFp3wEsb8Ma3Zjh092u/69+jyLa6LbWEpRIZd
         oI5IvysrIkFkLC3yDBo5IvweQZ1OzdWOrEzTwOjEWUXZT98+6TEvxGwC5nC0J6VQzHpk
         rTl94ADj39NCAdc0DWDKygXUOiv33eV47mOOyvTOVe7SVyA0hYfvyFMMO4hi6Zx91mtr
         aEvPg+pJbU5AQLnlWWz5WnTTyJQkvJzydGrEtf+zAy4FW7jdQ8+WPQSW5e6Lh+ZM6Ypv
         IbsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682524483; x=1685116483;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EqAgCO1dAFlTVvD9+F4y2+r8QDGr8l8uQObK2Wewg/c=;
        b=WiOyL/f96GOL9FyxpcUrddanohJSwyT0WUlvLljyz+uYHbcJ+GLKA5KljYYycvynO7
         qMiRUJl4z0NFP/4xikhVwTqW0IpM+bhZZRo19K5MQhExV5WI06emP+XKwVv4BhSNKnbB
         4DTeqliKTZdTg2YkGgtNGydyN1FfkvpHMMcTVkXelj2rvYtyjE2UAEN9MTifTrSmwhrz
         rGmIpw+MxvUL7PMxBLiTpQLUmqXmCt9myRDtsNfrz+vAU/lGV/rWBocayFUz2gNLLc7K
         POu8Ekkefck8tup58pGjr2iAphKAkNl84vkNUhIdg4ibirxIjhoGl6NjNYxdJxdyAdgf
         wJng==
X-Gm-Message-State: AAQBX9eA5Ep+b4pw1/KTlGSizbZGRatjSo6tqnpanXi/MuRTPT221Y4a
        i6fDF6cM3QkAa/uE0DfdQahtr9E2Mmr2qUaZ5Ek64A==
X-Google-Smtp-Source: AKy350YBhhiWkdBl5ud9gmYouU1kkmi6CunzvG6QYD0LG0T87HSLHLK8epnnyA7cdnAhrXeoG2tYqg==
X-Received: by 2002:a17:902:e5c1:b0:1a9:29f5:d3a with SMTP id u1-20020a170902e5c100b001a929f50d3amr25672760plf.0.1682524482945;
        Wed, 26 Apr 2023 08:54:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u2-20020a17090282c200b001a4edbabad3sm10154224plz.230.2023.04.26.08.54.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Apr 2023 08:54:42 -0700 (PDT)
Message-ID: <64494942.170a0220.eb760.4575@mx.google.com>
Date:   Wed, 26 Apr 2023 08:54:42 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.22-573-gbade3379ddeb
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 93 runs,
 8 regressions (v6.1.22-573-gbade3379ddeb)
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

stable-rc/queue/6.1 baseline: 93 runs, 8 regressions (v6.1.22-573-gbade3379=
ddeb)

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
el/v6.1.22-573-gbade3379ddeb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.22-573-gbade3379ddeb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bade3379ddeb54405d31ce183785576fd37f3e0f =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644912d3ef61231bab2e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644912d3ef61231bab2e8610
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:02:08.761174  <8>[   10.722810] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10129976_1.4.2.3.1>

    2023-04-26T12:02:08.763938  + set +x

    2023-04-26T12:02:08.865389  =


    2023-04-26T12:02:08.966062  / # #export SHELL=3D/bin/sh

    2023-04-26T12:02:08.966263  =


    2023-04-26T12:02:09.066749  / # export SHELL=3D/bin/sh. /lava-10129976/=
environment

    2023-04-26T12:02:09.066978  =


    2023-04-26T12:02:09.167485  / # . /lava-10129976/environment/lava-10129=
976/bin/lava-test-runner /lava-10129976/1

    2023-04-26T12:02:09.167819  =


    2023-04-26T12:02:09.173581  / # /lava-10129976/bin/lava-test-runner /la=
va-10129976/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644913c28c3cfede692e85f3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644913c28c3cfede692e85f8
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:06:19.373745  + set<8>[    9.022646] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10129953_1.4.2.3.1>

    2023-04-26T12:06:19.374179   +x

    2023-04-26T12:06:19.481384  / # #

    2023-04-26T12:06:19.582114  export SHELL=3D/bin/sh

    2023-04-26T12:06:19.582342  #

    2023-04-26T12:06:19.682924  / # export SHELL=3D/bin/sh. /lava-10129953/=
environment

    2023-04-26T12:06:19.683123  =


    2023-04-26T12:06:19.783767  / # . /lava-10129953/environment/lava-10129=
953/bin/lava-test-runner /lava-10129953/1

    2023-04-26T12:06:19.784875  =


    2023-04-26T12:06:19.789569  / # /lava-10129953/bin/lava-test-runner /la=
va-10129953/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644912e61790bd5fd82e85f1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644912e61790bd5fd82e85f6
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:02:21.412483  <8>[   11.082546] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10130030_1.4.2.3.1>

    2023-04-26T12:02:21.415602  + set +x

    2023-04-26T12:02:21.517137  =


    2023-04-26T12:02:21.617822  / # #export SHELL=3D/bin/sh

    2023-04-26T12:02:21.618026  =


    2023-04-26T12:02:21.718552  / # export SHELL=3D/bin/sh. /lava-10130030/=
environment

    2023-04-26T12:02:21.718752  =


    2023-04-26T12:02:21.819270  / # . /lava-10130030/environment/lava-10130=
030/bin/lava-test-runner /lava-10130030/1

    2023-04-26T12:02:21.819535  =


    2023-04-26T12:02:21.824509  / # /lava-10130030/bin/lava-test-runner /la=
va-10130030/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644913d332b63f458b2e860d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644913d332b63f458b2e8612
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:06:30.444903  + set +x

    2023-04-26T12:06:30.451541  <8>[   12.355279] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10130034_1.4.2.3.1>

    2023-04-26T12:06:30.556061  / # #

    2023-04-26T12:06:30.656749  export SHELL=3D/bin/sh

    2023-04-26T12:06:30.656997  #

    2023-04-26T12:06:30.757550  / # export SHELL=3D/bin/sh. /lava-10130034/=
environment

    2023-04-26T12:06:30.757828  =


    2023-04-26T12:06:30.858351  / # . /lava-10130034/environment/lava-10130=
034/bin/lava-test-runner /lava-10130034/1

    2023-04-26T12:06:30.858739  =


    2023-04-26T12:06:30.863668  / # /lava-10130034/bin/lava-test-runner /la=
va-10130034/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644913e632b63f458b2e8624

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644913e632b63f458b2e8629
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:06:41.831017  + set<8>[   10.382668] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10130006_1.4.2.3.1>

    2023-04-26T12:06:41.831109   +x

    2023-04-26T12:06:41.932643  /#

    2023-04-26T12:06:42.033521   # #export SHELL=3D/bin/sh

    2023-04-26T12:06:42.033765  =


    2023-04-26T12:06:42.134318  / # export SHELL=3D/bin/sh. /lava-10130006/=
environment

    2023-04-26T12:06:42.134534  =


    2023-04-26T12:06:42.235138  / # . /lava-10130006/environment/lava-10130=
006/bin/lava-test-runner /lava-10130006/1

    2023-04-26T12:06:42.235429  =


    2023-04-26T12:06:42.240239  / # /lava-10130006/bin/lava-test-runner /la=
va-10130006/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644912cd31f9a35dc82e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644912cd31f9a35dc82e861b
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:01:59.326214  + set<8>[   11.376638] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10129966_1.4.2.3.1>

    2023-04-26T12:01:59.326325   +x

    2023-04-26T12:01:59.430667  / # #

    2023-04-26T12:01:59.531240  export SHELL=3D/bin/sh

    2023-04-26T12:01:59.531477  #

    2023-04-26T12:01:59.631974  / # export SHELL=3D/bin/sh. /lava-10129966/=
environment

    2023-04-26T12:01:59.632174  =


    2023-04-26T12:01:59.732679  / # . /lava-10129966/environment/lava-10129=
966/bin/lava-test-runner /lava-10129966/1

    2023-04-26T12:01:59.732972  =


    2023-04-26T12:01:59.737289  / # /lava-10129966/bin/lava-test-runner /la=
va-10129966/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644912f8c8cb81646f2e8619

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644912f8c8cb81646f2e861e
        failing since 28 days (last pass: v6.1.21-104-gd5eb32be5b26, first =
fail: v6.1.21-224-g1abeb39fad59)

    2023-04-26T12:02:45.537185  + set<8>[   12.462195] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10130025_1.4.2.3.1>

    2023-04-26T12:02:45.537268   +x

    2023-04-26T12:02:45.641158  / # #

    2023-04-26T12:02:45.741797  export SHELL=3D/bin/sh

    2023-04-26T12:02:45.741995  #

    2023-04-26T12:02:45.842503  / # export SHELL=3D/bin/sh. /lava-10130025/=
environment

    2023-04-26T12:02:45.842719  =


    2023-04-26T12:02:45.943254  / # . /lava-10130025/environment/lava-10130=
025/bin/lava-test-runner /lava-10130025/1

    2023-04-26T12:02:45.943540  =


    2023-04-26T12:02:45.948302  / # /lava-10130025/bin/lava-test-runner /la=
va-10130025/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
qemu_mips-malta              | mips   | lab-collabora | gcc-10   | malta_de=
fconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/6449101bc2bfd805f22e860f

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.22-57=
3-gbade3379ddeb/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mip=
s-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6449101bc2bfd80=
5f22e8617
        failing since 2 days (last pass: v6.1.22-560-gc4a6f990f6a64, first =
fail: v6.1.22-564-g3588497f7ea83)
        1 lines

    2023-04-26T11:50:44.425068  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 3213685c, epc =3D=3D 80202234, ra =3D=
=3D 80204b84
    2023-04-26T11:50:44.425211  =


    2023-04-26T11:50:44.448752  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>
    2023-04-26T11:50:44.448868  =

   =

 =20
