Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9762E6D83EF
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 18:42:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbjDEQml (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 12:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231539AbjDEQmk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 12:42:40 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB6911A
        for <stable@vger.kernel.org>; Wed,  5 Apr 2023 09:42:38 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so37879046pjt.5
        for <stable@vger.kernel.org>; Wed, 05 Apr 2023 09:42:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680712958;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Op5BWXO9eNRnRT2ZsN9tRs55eJrRMJuBmNIXKS5grkk=;
        b=lUr06EQbeEhuBIKdVwvk4wD0u3a80qtaok6gpGJs6Zvz0Qwi8AdnzP+NaSZCsvXQFj
         lZbp9r5KFCGEKH4q1SnolQYydIq4q5kUBu5MOwPfwxe66rLNDAhzXNotTkVvNzIe9iMs
         vrBs0sbzVL+Y4Jh7CJFYeyl1MDEQJ8pCm09RkMfxvkr1vGkFotHT6EzebmO7btREqqWY
         EL266nmycQjoIOPbdQ0cp3itDBPDPNdfJvN+EraEiBNUJUeLJ4HJQj2mY6UZx6L1RxNU
         l52tRsavQf/QPPVqburgp89XkNoTZQ/mGK71Oy1cEF70j0b5S7rfZ8En4Xqnhy5RWE3a
         2kKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680712958;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Op5BWXO9eNRnRT2ZsN9tRs55eJrRMJuBmNIXKS5grkk=;
        b=s/iGBKde0t+5Arj0kILPDh1MVjSbtfuZyKbsThQfoL7wjx8HutbjCVC1sWa08nGTNV
         rQPY4Sga2QPbY3ScMHt+4AI8XJMD8EKGU8tfg1a+OfQ1cJ71YJ2cjvfqISf32XNX9MoR
         DZynOiC0jlsUOfbduSahroBSlUmZ484Jg4DelAZHd3v7f4qyqoO/UVX88OYBeohlbR0T
         1aaD0cKOV74fzc4IskoxYHm2R2nJZilarrJIg616JuXmaNmnz40+QPc4Ejro+PNgWX2S
         b5yctHGanb4qnrnlk86HelesvTTTK1EczomUSkFgM4KuWw+hkcvoCKorXPkCvPd8t+Xc
         W0pw==
X-Gm-Message-State: AAQBX9fv63fCEfGr2liZbaIiAeuDNd1A6MSVDaYxEb+bpEerFU//i/bs
        w5ziBw7U8f61BTC7wG+XiGy9f8mdAhk6WAidMlSYpA==
X-Google-Smtp-Source: AKy350YSBTEKIKcBjAL08XKj9o+MV6PY2Y6T6D/z/y/u9Fkz1HiCBRNu/c7+Ed3XttVvDKIfDZddIA==
X-Received: by 2002:a17:902:c945:b0:1a1:ab85:1e1e with SMTP id i5-20020a170902c94500b001a1ab851e1emr3042636pla.22.1680712957933;
        Wed, 05 Apr 2023 09:42:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id ju19-20020a170903429300b0019ea9e5815bsm10414741plb.45.2023.04.05.09.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Apr 2023 09:42:37 -0700 (PDT)
Message-ID: <642da4fd.170a0220.77f67.5af6@mx.google.com>
Date:   Wed, 05 Apr 2023 09:42:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v6.1.22-178-gf8a7fa4a96bb
Subject: stable-rc/linux-6.1.y baseline: 152 runs,
 7 regressions (v6.1.22-178-gf8a7fa4a96bb)
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

stable-rc/linux-6.1.y baseline: 152 runs, 7 regressions (v6.1.22-178-gf8a7f=
a4a96bb)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-6.1.y/kern=
el/v6.1.22-178-gf8a7fa4a96bb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-6.1.y
  Describe: v6.1.22-178-gf8a7fa4a96bb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f8a7fa4a96bb8970f07e44d4a26b9fb41d65d271 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6bef9e7eb6d8ae79e9ba

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6bef9e7eb6d8ae79e9bf
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:53.567083  <8>[   10.926016] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878614_1.4.2.3.1>

    2023-04-05T12:38:53.570229  + set +x

    2023-04-05T12:38:53.671811  #

    2023-04-05T12:38:53.773021  / # #export SHELL=3D/bin/sh

    2023-04-05T12:38:53.773227  =


    2023-04-05T12:38:53.874271  / # export SHELL=3D/bin/sh. /lava-9878614/e=
nvironment

    2023-04-05T12:38:53.874469  =


    2023-04-05T12:38:53.975404  / # . /lava-9878614/environment/lava-987861=
4/bin/lava-test-runner /lava-9878614/1

    2023-04-05T12:38:53.975711  =


    2023-04-05T12:38:53.981462  / # /lava-9878614/bin/lava-test-runner /lav=
a-9878614/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6bf3d72bb6902479e925

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6bf3d72bb6902479e92a
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:51.594167  + set<8>[   12.034832] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9878661_1.4.2.3.1>

    2023-04-05T12:38:51.594282   +x

    2023-04-05T12:38:51.699037  / # #

    2023-04-05T12:38:51.800185  export SHELL=3D/bin/sh

    2023-04-05T12:38:51.800405  #

    2023-04-05T12:38:51.901351  / # export SHELL=3D/bin/sh. /lava-9878661/e=
nvironment

    2023-04-05T12:38:51.901600  =


    2023-04-05T12:38:52.002561  / # . /lava-9878661/environment/lava-987866=
1/bin/lava-test-runner /lava-9878661/1

    2023-04-05T12:38:52.002845  =


    2023-04-05T12:38:52.007090  / # /lava-9878661/bin/lava-test-runner /lav=
a-9878661/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6bd6e916aed3d679e94e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6bd6e916aed3d679e953
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:32.556981  <8>[    7.830817] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878604_1.4.2.3.1>

    2023-04-05T12:38:32.560094  + set +x

    2023-04-05T12:38:32.662874  =


    2023-04-05T12:38:32.765030  / # #export SHELL=3D/bin/sh

    2023-04-05T12:38:32.765852  =


    2023-04-05T12:38:32.867834  / # export SHELL=3D/bin/sh. /lava-9878604/e=
nvironment

    2023-04-05T12:38:32.868601  =


    2023-04-05T12:38:32.970429  / # . /lava-9878604/environment/lava-987860=
4/bin/lava-test-runner /lava-9878604/1

    2023-04-05T12:38:32.971467  =


    2023-04-05T12:38:32.976400  / # /lava-9878604/bin/lava-test-runner /lav=
a-9878604/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6bd1e916aed3d679e92f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6bd1e916aed3d679e934
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:33.184480  + set +x

    2023-04-05T12:38:33.191448  <8>[   10.466122] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878599_1.4.2.3.1>

    2023-04-05T12:38:33.296312  / # #

    2023-04-05T12:38:33.397435  export SHELL=3D/bin/sh

    2023-04-05T12:38:33.397666  #

    2023-04-05T12:38:33.498559  / # export SHELL=3D/bin/sh. /lava-9878599/e=
nvironment

    2023-04-05T12:38:33.498763  =


    2023-04-05T12:38:33.599665  / # . /lava-9878599/environment/lava-987859=
9/bin/lava-test-runner /lava-9878599/1

    2023-04-05T12:38:33.600034  =


    2023-04-05T12:38:33.604191  / # /lava-9878599/bin/lava-test-runner /lav=
a-9878599/1
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6bd048be53fb9479e96a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6bd048be53fb9479e96f
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:24.521166  <8>[   10.286018] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878670_1.4.2.3.1>

    2023-04-05T12:38:24.524139  + set +x

    2023-04-05T12:38:24.632185  / # #

    2023-04-05T12:38:24.734853  export SHELL=3D/bin/sh

    2023-04-05T12:38:24.735646  #

    2023-04-05T12:38:24.837436  / # export SHELL=3D/bin/sh. /lava-9878670/e=
nvironment

    2023-04-05T12:38:24.838298  =


    2023-04-05T12:38:24.940284  / # . /lava-9878670/environment/lava-987867=
0/bin/lava-test-runner /lava-9878670/1

    2023-04-05T12:38:24.941493  =


    2023-04-05T12:38:24.947008  / # /lava-9878670/bin/lava-test-runner /lav=
a-9878670/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6bd5e916aed3d679e943

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6bd5e916aed3d679e948
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:28.561904  + set<8>[   11.399489] <LAVA_SIGNAL_ENDRUN =
0_dmesg 9878596_1.4.2.3.1>

    2023-04-05T12:38:28.561987   +x

    2023-04-05T12:38:28.666784  / # #

    2023-04-05T12:38:28.767645  export SHELL=3D/bin/sh

    2023-04-05T12:38:28.767810  #

    2023-04-05T12:38:28.868755  / # export SHELL=3D/bin/sh. /lava-9878596/e=
nvironment

    2023-04-05T12:38:28.868946  =


    2023-04-05T12:38:28.970025  / # . /lava-9878596/environment/lava-987859=
6/bin/lava-test-runner /lava-9878596/1

    2023-04-05T12:38:28.971094  =


    2023-04-05T12:38:28.976037  / # /lava-9878596/bin/lava-test-runner /lav=
a-9878596/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642d6be19e7eb6d8ae79e963

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-6.1.y/v6.1.22-=
178-gf8a7fa4a96bb/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642d6be19e7eb6d8ae79e968
        failing since 5 days (last pass: v6.1.21, first fail: v6.1.22)

    2023-04-05T12:38:43.817213  <8>[   12.454206] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9878658_1.4.2.3.1>

    2023-04-05T12:38:43.922595  / # #

    2023-04-05T12:38:44.023617  export SHELL=3D/bin/sh

    2023-04-05T12:38:44.023833  #

    2023-04-05T12:38:44.124760  / # export SHELL=3D/bin/sh. /lava-9878658/e=
nvironment

    2023-04-05T12:38:44.124970  =


    2023-04-05T12:38:44.225882  / # . /lava-9878658/environment/lava-987865=
8/bin/lava-test-runner /lava-9878658/1

    2023-04-05T12:38:44.226158  =


    2023-04-05T12:38:44.230752  / # /lava-9878658/bin/lava-test-runner /lav=
a-9878658/1

    2023-04-05T12:38:44.237665  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
