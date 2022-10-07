Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38C8B5F785A
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 14:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJGMxz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 08:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbiJGMxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 08:53:53 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A9D2F471A
        for <stable@vger.kernel.org>; Fri,  7 Oct 2022 05:53:52 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id h8-20020a17090a054800b00205ccbae31eso7128087pjf.5
        for <stable@vger.kernel.org>; Fri, 07 Oct 2022 05:53:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tyFyiYDeFQ84Bnoj2dSpuYTC6CwCxMsrXLuTDOMrBLA=;
        b=cZ6tWLLKmZP5Lj50I4NIDICivSMe619bCaIxSw7FUHc0xZlOcl8rDOjv5lLC+AumPZ
         fEwwDAyyZAMOQpXmLuGKsoB9N03yCZExZMh/tZ3lLYlHbCanS0osqh/OI+6jp8plBYaM
         hywgtcaHF7CuD/UqpglHUnh36rgYnl9Z/K30xXAjoviW1a8ophnZ5g1C3qlnCkZXj+el
         mkN2EmvDd4B8UNyrQkrLExes2nzJYkSJ4M3VvsMzweSItBWV3fkuk490z0PiNByMtX53
         7X3z43n2SltGEH5Rp0FmF0mOpvqJVzrdohLyYXqufkej7wsdobtZcyWQi8O7OEIPZ8Ej
         tJfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tyFyiYDeFQ84Bnoj2dSpuYTC6CwCxMsrXLuTDOMrBLA=;
        b=NDq8F+IP1AXCVrCZ4lyH5POlLTc3aQ7lnzAnTj9Aj2RHVEI32io3C1HZr+T8r3FGTD
         CIkVGaNnebLQ/bWNVP3vm/LDUb3cpIxjBFAO9KVYziSr0adPoSaYCDr9hXlTvK+yd7iQ
         N7yys2NU6unv9swVoiBVcoKxyvOXEFfbaVVZu6wSzMeI8ak6TmURb7HENyaseygzMbDV
         8cZhnu8YKxik/AIfl42ipefE48i3YWH7Pogf3zJqKcDhEWZSnhY0HrfgK4GQlXD0MeAM
         Fj/pdFfOdQzp8Pf+QknbgtADIDqCTlFSbByAgvIDrT5BiHFIWk7MDfbiepja6Qbbz97Y
         M9kg==
X-Gm-Message-State: ACrzQf05HZlp+5YDGdGxFFTASvtnmq1xFEZUcXa2WoCOrvC0eikUp1sg
        RMbiI9lDkhIsNWpfWitZxsAuI8YAFctRzkptGpI=
X-Google-Smtp-Source: AMsMyM5W4c7O3mj1TLgizmj4vgw4zWvrGRHkouM0kJY/WJf9nLz65qYoIkARsoUlb3+d83M/KIJ5cQ==
X-Received: by 2002:a17:903:2684:b0:17b:7568:ffea with SMTP id jf4-20020a170903268400b0017b7568ffeamr4794132plb.128.1665147231460;
        Fri, 07 Oct 2022 05:53:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w18-20020aa79a12000000b00553b37c7732sm1555434pfj.105.2022.10.07.05.53.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Oct 2022 05:53:50 -0700 (PDT)
Message-ID: <6340215e.a70a0220.6095c.284d@mx.google.com>
Date:   Fri, 07 Oct 2022 05:53:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.19.14-7-gf73a6cd88959d
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.19 baseline: 179 runs,
 5 regressions (v5.19.14-7-gf73a6cd88959d)
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

stable-rc/queue/5.19 baseline: 179 runs, 5 regressions (v5.19.14-7-gf73a6cd=
88959d)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =

imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =

qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =

sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.14-7-gf73a6cd88959d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.14-7-gf73a6cd88959d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f73a6cd88959dfad426000056a3d95d87c2de8c4 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
hifive-unleashed-a00         | riscv | lab-baylibre  | gcc-10   | defconfig=
                  | 1          =


  Details:     https://kernelci.org/test/plan/id/633feaf19cf3ecd5d3cab5ee

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unleas=
hed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/riscv/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633feaf19cf3ecd5d3cab=
5ef
        failing since 4 days (last pass: v5.19.11-208-g633f59cac516, first =
fail: v5.19.12-101-g42662133e9bdb) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | imx_v6_v7=
_defconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/633ff3d6afe80f50eacab5ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633ff3d6afe80f50eacab=
5ed
        failing since 11 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-186-ge96864168d41) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
imx7ulp-evk                  | arm   | lab-nxp       | gcc-10   | multi_v7_=
defconfig         | 1          =


  Details:     https://kernelci.org/test/plan/id/633feb8ee362b2934ccab5ef

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-evk=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633feb8ee362b2934ccab=
5f0
        failing since 10 days (last pass: v5.19.11-158-gc8a84e45064d0, firs=
t fail: v5.19.11-206-g444111497b13) =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
qemu_mips-malta              | mips  | lab-collabora | gcc-10   | malta_def=
config            | 1          =


  Details:     https://kernelci.org/test/plan/id/633ff5d19a612cbf82cab60b

  Results:     4 PASS, 1 FAIL, 2 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/mipsel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/633ff5d19a612cb=
f82cab613
        failing since 1 day (last pass: v5.19.12-114-g34c12937d8e1d, first =
fail: v5.19.12-116-g5104816afb77d)
        1 lines

    2022-10-07T09:47:46.796789  kern  :alert : CPU 0 Unable to handle kerne=
l paging request at virtual address 32c20cb0, epc =3D=3D 802006a8, ra =3D=
=3D 80203380
    2022-10-07T09:47:46.835067  <8><LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dale=
rt RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D1>   =

 =



platform                     | arch  | lab           | compiler | defconfig=
                  | regressions
-----------------------------+-------+---------------+----------+----------=
------------------+------------
sc7180-trogdo...zor-limozeen | arm64 | lab-collabora | gcc-10   | defconfig=
+arm64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/633fedbbfcb34565a7cab604

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.14-=
7-gf73a6cd88959d/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/base=
line-sc7180-trogdor-lazor-limozeen.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220919.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/633fedbbfcb34565a7cab=
605
        failing since 9 days (last pass: v5.19.11-206-g444111497b13, first =
fail: v5.19.11-207-g5704e94c78ce) =

 =20
