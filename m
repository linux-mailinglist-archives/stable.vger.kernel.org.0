Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 914E96D0954
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 17:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232874AbjC3PVL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 11:21:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232875AbjC3PVK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 11:21:10 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23DD8CDD0
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:20:11 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id z11so12765926pfh.4
        for <stable@vger.kernel.org>; Thu, 30 Mar 2023 08:20:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1680189586;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qI9mrWROiPvVdeHyRRM3Of8so1XKDJrvfIS9xTURI4o=;
        b=3PCscDxg+D9xvrerLKEkbwtQIY+V773aJuCfliq6nqJC1QJjHwyTRg2oRvWLLaBxO4
         9kd7rGbRv0zMcQqBdSC8cEqkm3sYJ9zNQdGuvUlSKsHvKWsopnPNd3Ra/9ZaXTYBiWsk
         8xI+jqKI8s3N9zqXQdjQoTiif17rrVtCe+ygyHLF/RS7EAc6PS4l4QkxdzIPDwkG/soE
         YErHzeF3lOU8Evh3CsItsS4etAJtmynSFs23H33OeFxXCsZ4ftRUHc6D+1LWkEtWtueP
         1imjvJOnwP6nrOiG41KTO9KAaiKJcGPyKMSmAdDX9HcueNlm5mtJaoXp0cXaX64R3t2m
         L7yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680189586;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qI9mrWROiPvVdeHyRRM3Of8so1XKDJrvfIS9xTURI4o=;
        b=bgXWLdzIP4HSjoP8Yw8rRha2LvzLuUHKD+LIyrMhepHEKxSMrNyzwKQ4PWR8YLKwbL
         TbvDjWgFzQ29uak899wlLbRjbTpabCZ8j1zM7MasFz1/9P3/LE8hI0YihTFYe0qIInnz
         iH+okD4GsfOQ63nt08zRaGluMMb8Mh1PY96Va+OIpZSlqexZj8wbgSTIIbNtDZB+lUtF
         +DQOfJ+VEcyHS2n6BC3GmMgsdVJt9TeYivxTHD2MCGSIbPVG//k7O8ZAcn5eQ1U/C3FQ
         /6ONW29VJcZVgU1OCXBs3MIhJtaehnsD1LdLDZ2jr5qhcPMUvnggNHisIbTrb8oJB08p
         9yfg==
X-Gm-Message-State: AAQBX9d9pRYAL1U0rnFRp5FPY44dnr8et90iCG7zQiMN1hwpPygYWQHM
        3RPpUCmHPJL4cTYfS1AH4wvyzyZLQmT13A44EsiF8g==
X-Google-Smtp-Source: AKy350Z9l5jJ48aWf9a7H6MSe3F8EWBfNDuGwSKA2eWQ2U847PedsswCacC/UYx4JJAAUTHnsEcitg==
X-Received: by 2002:a62:7bd0:0:b0:625:83a1:78e8 with SMTP id w199-20020a627bd0000000b0062583a178e8mr21971023pfc.19.1680189586294;
        Thu, 30 Mar 2023 08:19:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s21-20020a056a00195500b0062dd1c55346sm16013pfk.67.2023.03.30.08.19.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 08:19:45 -0700 (PDT)
Message-ID: <6425a891.050a0220.52650.009e@mx.google.com>
Date:   Thu, 30 Mar 2023 08:19:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.104-145-g661d757a6dc0
Subject: stable-rc/queue/5.15 baseline: 175 runs,
 9 regressions (v5.15.104-145-g661d757a6dc0)
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

stable-rc/queue/5.15 baseline: 175 runs, 9 regressions (v5.15.104-145-g661d=
757a6dc0)

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

beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.104-145-g661d757a6dc0/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.104-145-g661d757a6dc0
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      661d757a6dc086d76d0e8eaa730b837fee30d3c2 =



Test Regressions
---------------- =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/6425742fc2817e9d8062f76d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6425742fc2817e9d8062f772
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:35:51.899499  <8>[   10.876433] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9814655_1.4.2.3.1>

    2023-03-30T11:35:51.902899  + set +x

    2023-03-30T11:35:52.004558  #

    2023-03-30T11:35:52.004843  =


    2023-03-30T11:35:52.105822  / # #export SHELL=3D/bin/sh

    2023-03-30T11:35:52.106054  =


    2023-03-30T11:35:52.207054  / # export SHELL=3D/bin/sh. /lava-9814655/e=
nvironment

    2023-03-30T11:35:52.207243  =


    2023-03-30T11:35:52.308254  / # . /lava-9814655/environment/lava-981465=
5/bin/lava-test-runner /lava-9814655/1

    2023-03-30T11:35:52.308506  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642573e5e57b99c2d062f7d4

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642573e5e57b99c2d062f7d9
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:34:40.069739  + <8>[   10.844323] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9814629_1.4.2.3.1>

    2023-03-30T11:34:40.070249  set +x

    2023-03-30T11:34:40.179002  / # #

    2023-03-30T11:34:40.281978  export SHELL=3D/bin/sh

    2023-03-30T11:34:40.282775  #

    2023-03-30T11:34:40.384584  / # export SHELL=3D/bin/sh. /lava-9814629/e=
nvironment

    2023-03-30T11:34:40.385472  =


    2023-03-30T11:34:40.487330  / # . /lava-9814629/environment/lava-981462=
9/bin/lava-test-runner /lava-9814629/1

    2023-03-30T11:34:40.487628  =


    2023-03-30T11:34:40.492062  / # /lava-9814629/bin/lava-test-runner /lav=
a-9814629/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642573ec8ccea088f962f76b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642573ec8ccea088f962f770
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:34:52.934144  <8>[   10.198617] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9814584_1.4.2.3.1>

    2023-03-30T11:34:52.937395  + set +x

    2023-03-30T11:34:53.039011  #

    2023-03-30T11:34:53.140294  / # #export SHELL=3D/bin/sh

    2023-03-30T11:34:53.140532  =


    2023-03-30T11:34:53.241341  / # export SHELL=3D/bin/sh. /lava-9814584/e=
nvironment

    2023-03-30T11:34:53.241574  =


    2023-03-30T11:34:53.342581  / # . /lava-9814584/environment/lava-981458=
4/bin/lava-test-runner /lava-9814584/1

    2023-03-30T11:34:53.342924  =


    2023-03-30T11:34:53.348184  / # /lava-9814584/bin/lava-test-runner /lav=
a-9814584/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
beagle-xm                    | arm    | lab-baylibre  | gcc-10   | omap2plu=
s_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/642576380e07f43d3a62f7a1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/642576380e07f43d3a62f=
7a2
        failing since 55 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
cubietruck                   | arm    | lab-baylibre  | gcc-10   | multi_v7=
_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/642577b370a4ef042a62f779

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642577b370a4ef042a62f77e
        failing since 72 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-03-30T11:51:07.294561  <8>[    9.952108] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3455130_1.5.2.4.1>
    2023-03-30T11:51:07.404438  / # #
    2023-03-30T11:51:07.507477  export SHELL=3D/bin/sh
    2023-03-30T11:51:07.508577  #
    2023-03-30T11:51:07.509144  / # <3>[   10.113094] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-03-30T11:51:07.611133  export SHELL=3D/bin/sh. /lava-3455130/envir=
onment
    2023-03-30T11:51:07.612178  =

    2023-03-30T11:51:07.714001  / # . /lava-3455130/environment/lava-345513=
0/bin/lava-test-runner /lava-3455130/1
    2023-03-30T11:51:07.715385  =

    2023-03-30T11:51:07.720241  / # /lava-3455130/bin/lava-test-runner /lav=
a-3455130/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642573ff88c7ee700c62f777

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642573ff88c7ee700c62f77c
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:35:10.410187  + <8>[    9.973556] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9814577_1.4.2.3.1>

    2023-03-30T11:35:10.410587  set +x

    2023-03-30T11:35:10.516255  #

    2023-03-30T11:35:10.517539  =


    2023-03-30T11:35:10.619811  / # #export SHELL=3D/bin/sh

    2023-03-30T11:35:10.620038  =


    2023-03-30T11:35:10.721339  / # export SHELL=3D/bin/sh. /lava-9814577/e=
nvironment

    2023-03-30T11:35:10.722132  =


    2023-03-30T11:35:10.824143  / # . /lava-9814577/environment/lava-981457=
7/bin/lava-test-runner /lava-9814577/1

    2023-03-30T11:35:10.825426  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642573d2468db45bf462f7b3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642573d2468db45bf462f7b8
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:34:24.958078  + set +x

    2023-03-30T11:34:24.965057  <8>[   10.568599] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9814628_1.4.2.3.1>

    2023-03-30T11:34:25.067346  =


    2023-03-30T11:34:25.168281  / # #export SHELL=3D/bin/sh

    2023-03-30T11:34:25.168485  =


    2023-03-30T11:34:25.269345  / # export SHELL=3D/bin/sh. /lava-9814628/e=
nvironment

    2023-03-30T11:34:25.269534  =


    2023-03-30T11:34:25.370405  / # . /lava-9814628/environment/lava-981462=
8/bin/lava-test-runner /lava-9814628/1

    2023-03-30T11:34:25.370686  =


    2023-03-30T11:34:25.375476  / # /lava-9814628/bin/lava-test-runner /lav=
a-9814628/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642573f34a5725485362f77a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642573f34a5725485362f77f
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:34:50.173369  + <8>[   11.352744] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9814613_1.4.2.3.1>

    2023-03-30T11:34:50.173875  set +x

    2023-03-30T11:34:50.281895  / # #

    2023-03-30T11:34:50.384361  export SHELL=3D/bin/sh

    2023-03-30T11:34:50.384586  #

    2023-03-30T11:34:50.485497  / # export SHELL=3D/bin/sh. /lava-9814613/e=
nvironment

    2023-03-30T11:34:50.485718  =


    2023-03-30T11:34:50.586532  / # . /lava-9814613/environment/lava-981461=
3/bin/lava-test-runner /lava-9814613/1

    2023-03-30T11:34:50.586818  =


    2023-03-30T11:34:50.591747  / # /lava-9814613/bin/lava-test-runner /lav=
a-9814613/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab           | compiler | defconfi=
g                    | regressions
-----------------------------+--------+---------------+----------+---------=
---------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora | gcc-10   | x86_64_d=
efcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/642573d9448c27b4e962f7bd

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.104=
-145-g661d757a6dc0/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230324.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/642573d9448c27b4e962f7c2
        failing since 2 days (last pass: v5.15.104-76-g9168fe5021cf1, first=
 fail: v5.15.104-83-ga131fb06fbdb)

    2023-03-30T11:34:34.043276  + <8>[   12.127541] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9814593_1.4.2.3.1>

    2023-03-30T11:34:34.043362  set +x

    2023-03-30T11:34:34.147494  / # #

    2023-03-30T11:34:34.248485  export SHELL=3D/bin/sh

    2023-03-30T11:34:34.248673  #

    2023-03-30T11:34:34.349546  / # export SHELL=3D/bin/sh. /lava-9814593/e=
nvironment

    2023-03-30T11:34:34.349726  =


    2023-03-30T11:34:34.450673  / # . /lava-9814593/environment/lava-981459=
3/bin/lava-test-runner /lava-9814593/1

    2023-03-30T11:34:34.450935  =


    2023-03-30T11:34:34.456043  / # /lava-9814593/bin/lava-test-runner /lav=
a-9814593/1
 =

    ... (12 line(s) more)  =

 =20
