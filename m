Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F403E6EBC20
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 01:50:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjDVXuP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Apr 2023 19:50:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbjDVXuO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Apr 2023 19:50:14 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 112FA1986
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:50:13 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id d2e1a72fcca58-63b78b344d5so2770877b3a.1
        for <stable@vger.kernel.org>; Sat, 22 Apr 2023 16:50:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682207412; x=1684799412;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=gPdJnaKCRRQkd2WmibS6esf/nh0fUmV/OrqlZUEmxzM=;
        b=hO4qYYfmGi/JubSyF/qQVig/7D+tk33hSvlgsLZbOVuZ99bvUlWzhEljHRK/IzLNo2
         reo5v+dV8QZXONprIcbPpf5txKVIoPsnFDvZK0anv+g1AuHD/FPEbjonpeWJ2RSqCSOF
         8kbXWuZoJxw8o8kRyw140t+/NB5xgh8v8EZgEEIpXe3a6sfhwx2b5huu0jDFlbsMBi64
         7cXDcJqscQknqoPup6eP1KlucZ6aqUQw3sfKkH9s/CI+OAEhCTeuyWKci1EoJt9V43Rl
         7t5BpF5jxNgt8ipTo5EYch+7Qi5TDZSugyyHDNRIPHJK/hVBoCfifTUisq6zkNxb7Szy
         VtYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682207412; x=1684799412;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gPdJnaKCRRQkd2WmibS6esf/nh0fUmV/OrqlZUEmxzM=;
        b=l0gj+w5F7ixJYrt06eJXvHktLKZ16GTO++PHK412mHtwMBsoqOsxg3HVPpP9TFmkhY
         i1AAb/USSU9VmQQGgSUU7T37YxqiLRgbDdOFw9JYqV6NA41Iq5Y/xm5hu/oBf6bj3Ize
         ixWYIkvOgCDuBf4a5AFQjl9ep4IqKca8aiq2cIUgLqx/S2BZGTIwrjyK8niLlm6qYRbv
         G4mL1ecNnG+NdzvpTz77f0VMciN2BfXvHp35lC7++nyaeus3Eta7sNTIF3a2HxfwG+/Y
         aO9qY5p42zHuYmWLYQ6IXe9nEtnkBP8wgRDwZfwNkPy5F6gDkVdvqPW250vPGgJ02Hnb
         7PGg==
X-Gm-Message-State: AAQBX9diP9oJ6RhqBJ95JB2BlvQeYRTAjaw6h43QnFtqdWmNZmU+xXKH
        RshlDhItYbd5ECGasTRiUMVhKi7bhVdEy/Df9e0wQKJI
X-Google-Smtp-Source: AKy350aMt2Db3Iplx8mIxwvZ0tQiiw5Z+R8I+fWwBiphzjIJ0tQZeklOaAG1K6lxxKOTRn8dv4AgBw==
X-Received: by 2002:a05:6a00:994:b0:63d:3765:dc8e with SMTP id u20-20020a056a00099400b0063d3765dc8emr11908325pfg.32.1682207412295;
        Sat, 22 Apr 2023 16:50:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q29-20020a631f5d000000b005140ce70582sm4365004pgm.44.2023.04.22.16.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Apr 2023 16:50:11 -0700 (PDT)
Message-ID: <644472b3.630a0220.34ff9.8a4c@mx.google.com>
Date:   Sat, 22 Apr 2023 16:50:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.4
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.238-225-ga3d78dc277756
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 67 runs,
 3 regressions (v5.4.238-225-ga3d78dc277756)
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

stable-rc/queue/5.4 baseline: 67 runs, 3 regressions (v5.4.238-225-ga3d78dc=
277756)

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
el/v5.4.238-225-ga3d78dc277756/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.238-225-ga3d78dc277756
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a3d78dc27775629de37e1a5c54c60c7838d01ae4 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hifive-unleashed-a00         | riscv  | lab-baylibre  | gcc-10   | defconfi=
g                    | 1          =


  Details:     https://kernelci.org/test/plan/id/64443edee049df43c82e8615

  Results:     3 PASS, 2 FAIL, 2 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (riscv64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
25-ga3d78dc277756/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
25-ga3d78dc277756/riscv/defconfig/gcc-10/lab-baylibre/baseline-hifive-unlea=
shed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/riscv/rootfs.cpio.gz =



  * baseline.dmesg.crit: https://kernelci.org/test/case/id/64443edee049df43=
c82e861e
        failing since 185 days (last pass: v5.4.219-270-gde284a6cd1e4, firs=
t fail: v5.4.219-266-g5eb28a6c7901)
        3 lines

    2023-04-22T20:08:45.341916  / # =

    2023-04-22T20:08:45.353975  =

    2023-04-22T20:08:45.465916  / # #
    2023-04-22T20:08:45.485969  #
    2023-04-22T20:08:45.588303  / # export SHELL=3D/bin/sh
    2023-04-22T20:08:45.613956  export SHELL=3D/bin/sh
    2023-04-22T20:08:45.719073  / # . /lava-3522157/environment
    2023-04-22T20:08:45.735636  . /lava-3522157/environment
    2023-04-22T20:08:45.837223  / # /lava-3522157/bin/lava-test-runner /lav=
a-3522157/0
    2023-04-22T20:08:45.848015  /lava-3522157/bin/lava-test-runner /lava-35=
22157/0 =

    ... (10 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64443f46d15c10826a2e85f6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
25-ga3d78dc277756/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
25-ga3d78dc277756/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64443f46d15c10826a2e85fb
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-22T20:10:22.449458  + set<8>[   10.479382] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10086966_1.4.2.3.1>

    2023-04-22T20:10:22.449547   +x

    2023-04-22T20:10:22.551697  #

    2023-04-22T20:10:22.552774  =


    2023-04-22T20:10:22.654672  / # #export SHELL=3D/bin/sh

    2023-04-22T20:10:22.654883  =


    2023-04-22T20:10:22.755648  / # export SHELL=3D/bin/sh. /lava-10086966/=
environment

    2023-04-22T20:10:22.755825  =


    2023-04-22T20:10:22.856740  / # . /lava-10086966/environment/lava-10086=
966/bin/lava-test-runner /lava-10086966/1

    2023-04-22T20:10:22.857072  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64443f2c463b1572402e861c

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
25-ga3d78dc277756/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.238-2=
25-ga3d78dc277756/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabo=
ra/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64443f2c463b1572402e8621
        failing since 25 days (last pass: v5.4.238-29-g39c31e43e3b2b, first=
 fail: v5.4.238-60-gcf51829325af)

    2023-04-22T20:10:01.529639  + set +x<8>[   12.929324] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10086925_1.4.2.3.1>

    2023-04-22T20:10:01.529724  =


    2023-04-22T20:10:01.631712  #

    2023-04-22T20:10:01.732877  / # #export SHELL=3D/bin/sh

    2023-04-22T20:10:01.733121  =


    2023-04-22T20:10:01.834089  / # export SHELL=3D/bin/sh. /lava-10086925/=
environment

    2023-04-22T20:10:01.834311  =


    2023-04-22T20:10:01.935321  / # . /lava-10086925/environment/lava-10086=
925/bin/lava-test-runner /lava-10086925/1

    2023-04-22T20:10:01.935609  =


    2023-04-22T20:10:01.940504  / # /lava-10086925/bin/lava-test-runner /la=
va-10086925/1
 =

    ... (12 line(s) more)  =

 =20
