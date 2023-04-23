Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1350C6EC118
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 18:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjDWQ20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 12:28:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbjDWQ20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 12:28:26 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4031E79
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 09:28:24 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id d9443c01a7336-1a95aef9885so9372495ad.1
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 09:28:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682267304; x=1684859304;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=kBwoNMlORUqQfahMFRXA2hipNYBK/RxT3DEjqAuDCT0=;
        b=AxB8nj1VilRD65t46g+jfH3amWTmgrtwc8Fw1MwiT7ugaLgWmUMswkDy7AsFRdl67D
         m1K4T5yf1nvzuStVDZG3oKTf9PPjRkM4N97/3AhDvDZFObspFPhqHBWe5MeOAphuu2+X
         Xp5VYvgF9VERMUOcoYBfulU3t0hMCcJHJ852MfrNlUJlkv1tBnMeEhmfGhYbZ+Nr20sv
         82bsiNFbk44rhdHyALYM1Hv2O0D39KBpaZvJtgC3qFW5QJKLcG0hMMtFgrKo5t4p66Ng
         vgsFlDQ9m++xKEczJFkE6cC71jDqK9/U/EORJx/fmoBFR3vYvdxK1Blj8LXRGn0clfa/
         qoEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682267304; x=1684859304;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kBwoNMlORUqQfahMFRXA2hipNYBK/RxT3DEjqAuDCT0=;
        b=JQHm7lAu49f3dMq7WHHL8kzOelq4cz18j8cFjCEjp4sOclK6GoJx+3WhZ+C5XUWnAa
         wZ/meEGyqGcAxcA5Ur4W0lWJ0LyYF6lUclyfi2SPV4ZoKN1AjSD+AAV/B6B7jJOwEosh
         Ggfd73D5frT2QiqzroI0hGA2iuQrXd6szSv6qzc4Bci6sphfk2X+QuSMKb8eN41xRrnN
         V1Z8r/Aba/ZyXNU3XGUCBwEXHn0PukRyBjWy589imCWXnYM2YnNHysyMLxJg3S7NqGfE
         jcfonnre+m2xXkPZs/I/yX8pGTQLVHsekhuwZndbRI2VhL/CLJin1bJ+akbMHZnZGSYx
         qNBQ==
X-Gm-Message-State: AAQBX9eeGFS6c4VGRMXTq/42BfY5ly6we3roNHKc+KelO5VunzMZzLug
        U1fAHPM8itDWPXBbDc+61tSMbdMciABspNSp6KABYQ==
X-Google-Smtp-Source: AKy350ZL7kiQbggn8VyGTa518G1qrD/8eH2YJQnIUZvqebRFnUC+IBZQeAG3W/hl61pj1tEmOEOyoA==
X-Received: by 2002:a17:902:e850:b0:1a2:296:9355 with SMTP id t16-20020a170902e85000b001a202969355mr12593024plg.16.1682267304192;
        Sun, 23 Apr 2023 09:28:24 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id jl13-20020a170903134d00b001a9666376a9sm1462230plb.226.2023.04.23.09.28.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 09:28:23 -0700 (PDT)
Message-ID: <64455ca7.170a0220.a086f.258f@mx.google.com>
Date:   Sun, 23 Apr 2023 09:28:23 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.238-226-gf3ef447a3b236
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 66 runs,
 3 regressions (v5.4.238-226-gf3ef447a3b236)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 66 runs, 3 regressions (v5.4.238-226-gf3ef447=
a3b236)

Regressions Summary
-------------------

platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.238-226-gf3ef447a3b236/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-226-gf3ef447a3b236
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3ef447a3b236a18972289e80cf8d2ca060d15e2 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/644528ce8e7960d8e82e863c

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
26-gf3ef447a3b236/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
26-gf3ef447a3b236/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/644528ce8e7960d8=
e82e8645
        failing since 186 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-23T12:46:50.525197  / # =

    2023-04-23T12:46:50.534933  =

    2023-04-23T12:46:50.640765  / # #
    2023-04-23T12:46:50.647189  #
    2023-04-23T12:46:50.749817  / # export SHELL=3D/bin/sh
    2023-04-23T12:46:50.761902  export SHELL=3D/bin/sh
    2023-04-23T12:46:50.864358  / # . /lava-3523860/environment
    2023-04-23T12:46:50.870849  . /lava-3523860/environment
    2023-04-23T12:46:50.973079  / # /lava-3523860/bin/lava-test-runner /lav=
a-3523860/0
    2023-04-23T12:46:50.982529  /lava-3523860/bin/lava-test-runner /lava-35=
23860/0 =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6445280ed3e0637f062e862b

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
26-gf3ef447a3b236/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
26-gf3ef447a3b236/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6445280ed3e0637f062e8630
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-23T12:43:41.276303  + set<8>[   10.700259] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10092146_1.4.2.3.1>

    2023-04-23T12:43:41.276413   +x

    2023-04-23T12:43:41.380407  / # #

    2023-04-23T12:43:41.481432  export SHELL=3D/bin/sh

    2023-04-23T12:43:41.481626  #

    2023-04-23T12:43:41.582527  / # export SHELL=3D/bin/sh. /lava-10092146/=
environment

    2023-04-23T12:43:41.582740  =


    2023-04-23T12:43:41.683708  / # . /lava-10092146/environment/lava-10092=
146/bin/lava-test-runner /lava-10092146/1

    2023-04-23T12:43:41.683989  =


    2023-04-23T12:43:41.688721  / # /lava-10092146/bin/lava-test-runner /la=
va-10092146/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644527b109233fb26f2e85ec

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
26-gf3ef447a3b236/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
26-gf3ef447a3b236/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644527b109233fb26f2e85f1
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-23T12:42:11.677231  <8>[   12.491131] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092102_1.4.2.3.1>

    2023-04-23T12:42:11.680413  + set +x

    2023-04-23T12:42:11.782150  #

    2023-04-23T12:42:11.783256  =


    2023-04-23T12:42:11.885339  / # #export SHELL=3D/bin/sh

    2023-04-23T12:42:11.885674  =


    2023-04-23T12:42:11.986702  / # export SHELL=3D/bin/sh. /lava-10092102/=
environment

    2023-04-23T12:42:11.986910  =


    2023-04-23T12:42:12.088093  / # . /lava-10092102/environment/lava-10092=
102/bin/lava-test-runner /lava-10092102/1

    2023-04-23T12:42:12.088453  =

 =

    ... (13 line(s) more)  =

 =20
