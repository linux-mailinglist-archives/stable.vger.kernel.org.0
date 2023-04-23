Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A472B6EC198
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 20:33:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjDWSdL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 14:33:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjDWSdK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 14:33:10 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61658186
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 11:33:08 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1a6bc48aec8so29385825ad.2
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 11:33:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682274787; x=1684866787;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=VQ/YxEmFjuvlisAhM94SgX0GdTI3QyjfwuThZJlfGm0=;
        b=0d096QONPMCOszIIidybI6AR6C0rC/AvvDQs0kV0xv/wqXzoiJKAOCllXdp11FHPij
         1pPp0wD6zcGba27uMpk0CjEnDDKE6MhpQuGxl7Mo/VAkHRGYeKR1mm7e4MXQFDr7lHUy
         cqQeieItloykHZcupNkq0OX+WQFQUYcM26EtM7mxDb7CzWGCVHxWIsY/bRRN1yJSCzhg
         bA0WVf0N3/UP/7k/bJ5W9TWqkjd6SHUqGnVhuGs1USZLpZU+DcDutZxmlo8nlNA5xOOn
         0T0bn+0oL8FcJzY2XEANdkozw6ZmbC4XLpmEAOT6u5FmAqKE/FKXdFoo+FYwBA0w4PGw
         DLsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682274787; x=1684866787;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VQ/YxEmFjuvlisAhM94SgX0GdTI3QyjfwuThZJlfGm0=;
        b=hAyDE0rEWMdnfzePWHQFQMS8wrWeGcyvl0v44IXCNvW5BXKYbjrT3s9cQz0xGeyWro
         cE7M2sC+6o2deloSnlvJvx+SnU5yeMwKtUS2SMUziEhIRW1LZ5UTC8tXVytKueQYe72Q
         GdmsZj7FKK4N1Xme7WYjDn5AdSqHVFYU5uVUPgyXUFn/DQAgY0l1diez3+BWMlwJruRt
         GPLevGA7mpBRWcpOMXn8Uu/7sB5AhxCWjTl3pN92ifWOkk12DOCJUv5qVAV3fZI/942w
         O2uDKNx9bYf0eHzoxOOYubp24YHx1fBYgX/pAVNtrqXXGfI/eHKVK0Z7KqwYWs/R1DHB
         XeTA==
X-Gm-Message-State: AAQBX9dMt5tqBl5gScSbfOUMalx+rfO17RJh0MqF7eVORsrr+YUrf07F
        8szkoAabnQoDvP5qmZyvU25Ht5dem4ClTWLKFGDndg==
X-Google-Smtp-Source: AKy350Z4kYE1eniLkKzus+fPHWAVMENUnZ1XeotaD0KwNsZhShsDPax++F8q4v1ZwaTDlP2dr2KXCQ==
X-Received: by 2002:a17:902:f543:b0:1a9:7365:fc2a with SMTP id h3-20020a170902f54300b001a97365fc2amr2439625plf.26.1682274787584;
        Sun, 23 Apr 2023 11:33:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j8-20020a17090276c800b001a686578b3dsm5290535plt.307.2023.04.23.11.33.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 11:33:07 -0700 (PDT)
Message-ID: <644579e3.170a0220.58f8e.9ebf@mx.google.com>
Date:   Sun, 23 Apr 2023 11:33:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.238-227-g75c0c97923426
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 68 runs,
 3 regressions (v5.4.238-227-g75c0c97923426)
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

stable-rc/queue/5.4 baseline: 68 runs, 3 regressions (v5.4.238-227-g75c0c97=
923426)

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
el/v5.4.238-227-g75c0c97923426/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-227-g75c0c97923426
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      75c0c979234265bc040fca1b0f562c9b8efed7f9 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/6445410ce829571ed02e861b

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
27-g75c0c97923426/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
27-g75c0c97923426/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/6445410ce829571e=
d02e8624
        failing since 186 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-23T14:30:21.726978  / # =

    2023-04-23T14:30:21.738588  =

    2023-04-23T14:30:21.841054  / # #
    2023-04-23T14:30:21.850813  #
    2023-04-23T14:30:21.952245  / # export SHELL=3D/bin/sh
    2023-04-23T14:30:21.962591  export SHELL=3D/bin/sh
    2023-04-23T14:30:22.063809  / # . /lava-3524227/environment
    2023-04-23T14:30:22.074557  . /lava-3524227/environment
    2023-04-23T14:30:22.175877  / # /lava-3524227/bin/lava-test-runner /lav=
a-3524227/0
    2023-04-23T14:30:22.186638  /lava-3524227/bin/lava-test-runner /lava-35=
24227/0 =

    ... (9 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644543a2a1d49a704b2e85fc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
27-g75c0c97923426/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
27-g75c0c97923426/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644543a2a1d49a704b2e8601
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-23T14:41:25.664222  + set +x<8>[   11.951759] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10093220_1.4.2.3.1>

    2023-04-23T14:41:25.664339  =


    2023-04-23T14:41:25.766513  #

    2023-04-23T14:41:25.766780  =


    2023-04-23T14:41:25.867800  / # #export SHELL=3D/bin/sh

    2023-04-23T14:41:25.867987  =


    2023-04-23T14:41:25.968896  / # export SHELL=3D/bin/sh. /lava-10093220/=
environment

    2023-04-23T14:41:25.969081  =


    2023-04-23T14:41:26.070033  / # . /lava-10093220/environment/lava-10093=
220/bin/lava-test-runner /lava-10093220/1

    2023-04-23T14:41:26.070300  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644543a7071591fae02e8636

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
27-g75c0c97923426/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
27-g75c0c97923426/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644543a7071591fae02e863b
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-23T14:41:27.357161  + <8>[   12.763140] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10093221_1.4.2.3.1>

    2023-04-23T14:41:27.357239  set +x

    2023-04-23T14:41:27.458772  #

    2023-04-23T14:41:27.559994  / # #export SHELL=3D/bin/sh

    2023-04-23T14:41:27.560185  =


    2023-04-23T14:41:27.660969  / # export SHELL=3D/bin/sh. /lava-10093221/=
environment

    2023-04-23T14:41:27.661155  =


    2023-04-23T14:41:27.762090  / # . /lava-10093221/environment/lava-10093=
221/bin/lava-test-runner /lava-10093221/1

    2023-04-23T14:41:27.762383  =


    2023-04-23T14:41:27.767431  / # /lava-10093221/bin/lava-test-runner /la=
va-10093221/1
 =

    ... (12 line(s) more)  =

 =20
