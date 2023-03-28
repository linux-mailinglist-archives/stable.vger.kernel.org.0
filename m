Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DEE06CCE47
	for <lists+stable@lfdr.de>; Wed, 29 Mar 2023 01:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjC1XxR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 19:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbjC1XxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 19:53:12 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D50513A8B
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:52:36 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id f22so9160903plr.0
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 16:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680047556;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=BucKEXY3TReuYkWrO/aKRYlUlpvrG+YNJMe3RpXrUR0=;
        b=KNiqQCBBYWWx1Qjq0NiZJAA1urn0fswCBasZsgoau07TBBQbhijAEdvaameaOqPvbk
         Nur8fy+CEiE9VE983TRrdhZTn1euTEIiP3D9YZP8BBe7jWRPTVv7+XYGKTwZQC8ERhy2
         4ntF2zWo4YZAY4YRvfBNZSmioRMPhKnhToL5ecYFPqCc3IjkBv5UTmfXQKg7/XVk1XED
         E4VV7hftwBlevQVjqYfA1fciZs/RfFbeAHfcdmJbJfw4gPPy0OnxEEXYzKMzrGnl3e3J
         a0qATtfBbU4c7z46LvnoforDuEV74X/OgnI9jmZLAOFHRzw+f8/nPbswyCegWWNdBNd4
         LmOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680047556;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=BucKEXY3TReuYkWrO/aKRYlUlpvrG+YNJMe3RpXrUR0=;
        b=P+ihN16ei/wQDB5Z+trWYWxy923NrGk4pfDTDqFrrMZInceNAAO3ybFNDhExlV8IMl
         V2nJ5BQ8qRLXzZYhRRj+/Q535WNrSKuaFhkyFeBOErfT8M4HYpxGkNtzDrU7oGAHuY3R
         rNW2E4TlBkWrUeK93rH7OwDd3vOWO9QdrJkzrNaawY/D0a9USMOoA02LGqBUzVQKbx0d
         fxLn39LC7I8cJW2iTllLRFfPjFmstZcLaw0R0GrLPwdDI48uNmdr1gdaIelyCHQan9L+
         L4XF+zqtt+8uIeMZnWCAefS21GDGufL0cVmg4tXTQpNsP9SADcJzB6MORmXJmQK/1EIF
         GNyw==
X-Gm-Message-State: AAQBX9cdLWLl+5T5WP/OyJr9s07IC2Lk/E0TOi01r/it37+ogFUfDfLz
        YIzGVZ1MH/ck6p9ZluofWEY0HPVNVMEQZyROoK5QVw==
X-Google-Smtp-Source: AKy350ZvR91HUE8nKqBmh7/PVAb5kFFYE2xK/C+eY+GNk8FI8gvgOPhDBBvDQuwMPSmk0fJCVeUkSw==
X-Received: by 2002:a05:6a20:6d06:b0:d9:3750:3a64 with SMTP id fv6-20020a056a206d0600b000d937503a64mr443007pzb.8.1680047555737;
        Tue, 28 Mar 2023 16:52:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g5-20020aa78745000000b006262932a30csm21350739pfo.34.2023.03.28.16.52.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Mar 2023 16:52:35 -0700 (PDT)
Message-ID: <64237dc3.a70a0220.30a41.663a@mx.google.com>
Date:   Tue, 28 Mar 2023 16:52:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-146-g831e137c65d5
Subject: stable-rc/queue/5.15 baseline: 118 runs,
 6 regressions (v5.15.104-146-g831e137c65d5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 118 runs, 6 regressions (v5.15.104-146-g831e=
137c65d5)

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

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-146-g831e137c65d5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-146-g831e137c65d5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      831e137c65d508c59abd72afa2f4183878bed3b2 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6423456f94ac255d2662f7b4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6423456f94ac255d2662f7b9
        failing since 0 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-28T19:51:59.687570  + set +x

    2023-03-28T19:51:59.693999  <8>[   10.279438] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798744_1.4.2.3.1>

    2023-03-28T19:51:59.801666  #

    2023-03-28T19:51:59.904956  / # #export SHELL=3D/bin/sh

    2023-03-28T19:51:59.905843  =


    2023-03-28T19:52:00.007741  / # export SHELL=3D/bin/sh. /lava-9798744/e=
nvironment

    2023-03-28T19:52:00.008642  =


    2023-03-28T19:52:00.110665  / # . /lava-9798744/environment/lava-979874=
4/bin/lava-test-runner /lava-9798744/1

    2023-03-28T19:52:00.112090  =


    2023-03-28T19:52:00.118318  / # /lava-9798744/bin/lava-test-runner /lav=
a-9798744/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642344de153cddf5dc62f786

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642344de153cddf5dc62f78b
        failing since 0 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-28T19:49:36.729179  + set<8>[   11.643390] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9798697_1.4.2.3.1>

    2023-03-28T19:49:36.729721   +x

    2023-03-28T19:49:36.837385  / # #

    2023-03-28T19:49:36.940535  export SHELL=3D/bin/sh

    2023-03-28T19:49:36.941580  #

    2023-03-28T19:49:37.043820  / # export SHELL=3D/bin/sh. /lava-9798697/e=
nvironment

    2023-03-28T19:49:37.044777  =


    2023-03-28T19:49:37.146818  / # . /lava-9798697/environment/lava-979869=
7/bin/lava-test-runner /lava-9798697/1

    2023-03-28T19:49:37.148204  =


    2023-03-28T19:49:37.153609  / # /lava-9798697/bin/lava-test-runner /lav=
a-9798697/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642344e1153cddf5dc62f7a1

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642344e1153cddf5dc62f7a6
        failing since 0 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-28T19:49:30.786066  <8>[   10.127654] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798669_1.4.2.3.1>

    2023-03-28T19:49:30.789446  + set +x

    2023-03-28T19:49:30.891260  =


    2023-03-28T19:49:30.992027  / # #export SHELL=3D/bin/sh

    2023-03-28T19:49:30.992213  =


    2023-03-28T19:49:31.093088  / # export SHELL=3D/bin/sh. /lava-9798669/e=
nvironment

    2023-03-28T19:49:31.093264  =


    2023-03-28T19:49:31.193766  / # . /lava-9798669/environment/lava-979866=
9/bin/lava-test-runner /lava-9798669/1

    2023-03-28T19:49:31.194056  =


    2023-03-28T19:49:31.198871  / # /lava-9798669/bin/lava-test-runner /lav=
a-9798669/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642344d99c773d74cf62f7e8

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642344d99c773d74cf62f7ed
        failing since 0 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-28T19:49:32.507480  + set +x

    2023-03-28T19:49:32.514790  <8>[   10.066328] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798663_1.4.2.3.1>

    2023-03-28T19:49:32.619355  / # #

    2023-03-28T19:49:32.720369  export SHELL=3D/bin/sh

    2023-03-28T19:49:32.720577  #

    2023-03-28T19:49:32.821464  / # export SHELL=3D/bin/sh. /lava-9798663/e=
nvironment

    2023-03-28T19:49:32.821672  =


    2023-03-28T19:49:32.922458  / # . /lava-9798663/environment/lava-979866=
3/bin/lava-test-runner /lava-9798663/1

    2023-03-28T19:49:32.922777  =


    2023-03-28T19:49:32.927925  / # /lava-9798663/bin/lava-test-runner /lav=
a-9798663/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642344eaa969da564d62f799

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642344eaa969da564d62f79e
        failing since 0 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-28T19:49:39.290239  + set +x

    2023-03-28T19:49:39.297112  <8>[   10.076176] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798723_1.4.2.3.1>

    2023-03-28T19:49:39.399566  =


    2023-03-28T19:49:39.500550  / # #export SHELL=3D/bin/sh

    2023-03-28T19:49:39.500859  =


    2023-03-28T19:49:39.601780  / # export SHELL=3D/bin/sh. /lava-9798723/e=
nvironment

    2023-03-28T19:49:39.602011  =


    2023-03-28T19:49:39.703070  / # . /lava-9798723/environment/lava-979872=
3/bin/lava-test-runner /lava-9798723/1

    2023-03-28T19:49:39.703401  =


    2023-03-28T19:49:39.708294  / # /lava-9798723/bin/lava-test-runner /lav=
a-9798723/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642344cb3742d87a8162f76e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-146-g831e137c65d5/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642344cb3742d87a8162f773
        failing since 0 day (last pass: v5.15.104-76-g9168fe5021cf1, first =
fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-28T19:49:19.426116  <8>[   11.459963] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9798710_1.4.2.3.1>

    2023-03-28T19:49:19.530995  / # #

    2023-03-28T19:49:19.631957  export SHELL=3D/bin/sh

    2023-03-28T19:49:19.632157  #

    2023-03-28T19:49:19.733030  / # export SHELL=3D/bin/sh. /lava-9798710/e=
nvironment

    2023-03-28T19:49:19.733213  =


    2023-03-28T19:49:19.834100  / # . /lava-9798710/environment/lava-979871=
0/bin/lava-test-runner /lava-9798710/1

    2023-03-28T19:49:19.834401  =


    2023-03-28T19:49:19.839191  / # /lava-9798710/bin/lava-test-runner /lav=
a-9798710/1

    2023-03-28T19:49:19.844952  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
