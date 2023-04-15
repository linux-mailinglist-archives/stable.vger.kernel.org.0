Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E67456E3460
	for <lists+stable@lfdr.de>; Sun, 16 Apr 2023 01:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229995AbjDOXCR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Apr 2023 19:02:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229600AbjDOXCP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Apr 2023 19:02:15 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19A1819D
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 16:02:13 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w11so22541842pjh.5
        for <stable@vger.kernel.org>; Sat, 15 Apr 2023 16:02:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1681599732; x=1684191732;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=aX5n5y+/HhgsC7tT+Q6wsZfeTjinO6/374NC6JIKNy4=;
        b=QYvUw97hVvdkUDxTpl9awDNaPfyRe/VS+saDjpx3ieBxnWnsjgvAn+a7M3eLxyEAjF
         MUr5AUqLfBZOam+SbPnPHFI4Xp/PlZdjIIj2CDn9hfCHFXlXZSDTcGv54QXF4/uoy56Q
         JqWYJehKQS0WMLFBqUSp5rP7a4wwbxdgOCS9MsPw19RknUVnBi3fdmXwRoYminqtASrd
         zigAGAl1nMQjnQpJppji/ZzIUxl09K4PJQNwFl5ZmWd8rZAgr80tWDUFSISJp89euW4e
         XXilk4PDUhlEI6FFZGRnTwPCprZO3dWv+aiDtoLxQOumfq/qxPuzJt31XUO50XmDYI/W
         Iclw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681599732; x=1684191732;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aX5n5y+/HhgsC7tT+Q6wsZfeTjinO6/374NC6JIKNy4=;
        b=IwHvfR9nuVU1i7Hx1czGPt9vhHp06mfduovpI9DbiIabXgyHUoQMFVVUiCoHYi2w0b
         5OGSQRu//4hjlHlRuom7yT8OC77GblmC9E4cmV1F2TBtCXMFx1Dl5mlCCYcasPwJ0SDk
         lWj81rO2C6w64OhNbbqcAwnt/jAEUAISxu26YhcKLZRWfLdWHPfrUYAKaVqcazMiiFSV
         HgjyP9+WqPypk6s1m5vjDy0vl7hkjYpCrmQnHIUdOT6s85+SAdgeYZhCwKAJ8nTDzPn4
         vqjRbZHEPN/yIHFoyODPDExys4cqNBkMPbXgWUI9VYNOCGczUB7LfWQbjqNrWHbojtQT
         4b3A==
X-Gm-Message-State: AAQBX9dHVBzI2vZjh7CKugQkkt4/7Wgmh2d0HsCltLbsgpizcl4oRrYv
        sV9Ohsoz8YnPAQRsp9dFlAKoFxpwzj65PnxNUzIZ24Yg
X-Google-Smtp-Source: AKy350bGiK6Q3lMkJwt8kf48S+xhASgOTbK1mS3AbM2up7Yb3u61c8ZXwHAh3rZ2SMBnlQrHlAcq2g==
X-Received: by 2002:a05:6a20:354c:b0:d9:adc3:6a71 with SMTP id f12-20020a056a20354c00b000d9adc36a71mr9468705pze.1.1681599732079;
        Sat, 15 Apr 2023 16:02:12 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79105000000b0063b1bb2e0a7sm5067842pfh.203.2023.04.15.16.02.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Apr 2023 16:02:11 -0700 (PDT)
Message-ID: <643b2cf3.a70a0220.f9c78.b5c0@mx.google.com>
Date:   Sat, 15 Apr 2023 16:02:11 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-200-g60d79b2c931a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 195 runs,
 13 regressions (v5.15.105-200-g60d79b2c931a)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 195 runs, 13 regressions (v5.15.105-200-g60d=
79b2c931a)

Regressions Summary
-------------------

platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =

cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =

meson-gxl-s905x-libretech-cc | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =

sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-200-g60d79b2c931a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-200-g60d79b2c931a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      60d79b2c931a5c6510374452a2d942273dad50d9 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af719376b070f782e85ff

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af719376b070f782e8604
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:12:05.574494  <8>[   10.974947] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995978_1.4.2.3.1>

    2023-04-15T19:12:05.577647  + set +x

    2023-04-15T19:12:05.682693  / # #

    2023-04-15T19:12:05.783668  export SHELL=3D/bin/sh

    2023-04-15T19:12:05.783932  #

    2023-04-15T19:12:05.884939  / # export SHELL=3D/bin/sh. /lava-9995978/e=
nvironment

    2023-04-15T19:12:05.885167  =


    2023-04-15T19:12:05.986132  / # . /lava-9995978/environment/lava-999597=
8/bin/lava-test-runner /lava-9995978/1

    2023-04-15T19:12:05.986398  =


    2023-04-15T19:12:05.992605  / # /lava-9995978/bin/lava-test-runner /lav=
a-9995978/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af70f2a547d30142e860b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af70f2a547d30142e8610
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:12:00.349972  + <8>[   11.404609] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9995995_1.4.2.3.1>

    2023-04-15T19:12:00.350594  set +x

    2023-04-15T19:12:00.459111  / # #

    2023-04-15T19:12:00.562156  export SHELL=3D/bin/sh

    2023-04-15T19:12:00.563050  #

    2023-04-15T19:12:00.665133  / # export SHELL=3D/bin/sh. /lava-9995995/e=
nvironment

    2023-04-15T19:12:00.666022  =


    2023-04-15T19:12:00.768112  / # . /lava-9995995/environment/lava-999599=
5/bin/lava-test-runner /lava-9995995/1

    2023-04-15T19:12:00.769463  =


    2023-04-15T19:12:00.774253  / # /lava-9995995/bin/lava-test-runner /lav=
a-9995995/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af718b76fcbd2af2e8616

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af718b76fcbd2af2e861b
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:12:01.331960  <8>[   10.491823] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995960_1.4.2.3.1>

    2023-04-15T19:12:01.335985  + set +x

    2023-04-15T19:12:01.441853  =


    2023-04-15T19:12:01.542943  / # #export SHELL=3D/bin/sh

    2023-04-15T19:12:01.543168  =


    2023-04-15T19:12:01.644054  / # export SHELL=3D/bin/sh. /lava-9995960/e=
nvironment

    2023-04-15T19:12:01.644266  =


    2023-04-15T19:12:01.745196  / # . /lava-9995960/environment/lava-999596=
0/bin/lava-test-runner /lava-9995960/1

    2023-04-15T19:12:01.745477  =


    2023-04-15T19:12:01.750447  / # /lava-9995960/bin/lava-test-runner /lav=
a-9995960/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/643afa02d92280009b2e866e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/643afa02d92280009b2e8=
66f
        failing since 71 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643afc5e84b0d220a92e8621

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cubi=
etruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643afc5e84b0d220a92e8626
        failing since 88 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-15T19:34:30.739906  <8>[   10.082032] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3499325_1.5.2.4.1>
    2023-04-15T19:34:30.851960  / # #
    2023-04-15T19:34:30.956533  export SHELL=3D/bin/sh
    2023-04-15T19:34:30.957487  #
    2023-04-15T19:34:31.059545  / # export SHELL=3D/bin/sh. /lava-3499325/e=
nvironment
    2023-04-15T19:34:31.060391  =

    2023-04-15T19:34:31.162401  / # . /lava-3499325/environment/lava-349932=
5/bin/lava-test-runner /lava-3499325/1
    2023-04-15T19:34:31.163730  =

    2023-04-15T19:34:31.167647  / # /lava-3499325/bin/lava-test-runner /lav=
a-3499325/1<3>[   10.513221] Bluetooth: hci0: command 0x0c03 tx timeout
    2023-04-15T19:34:31.168239   =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af70acbcae873452e863e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af70acbcae873452e8643
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:11:53.526594  + set +x

    2023-04-15T19:11:53.532975  <8>[    9.941373] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9995958_1.4.2.3.1>

    2023-04-15T19:11:53.637945  / # #

    2023-04-15T19:11:53.738949  export SHELL=3D/bin/sh

    2023-04-15T19:11:53.739163  #

    2023-04-15T19:11:53.840188  / # export SHELL=3D/bin/sh. /lava-9995958/e=
nvironment

    2023-04-15T19:11:53.840386  =


    2023-04-15T19:11:53.941343  / # . /lava-9995958/environment/lava-999595=
8/bin/lava-test-runner /lava-9995958/1

    2023-04-15T19:11:53.941784  =


    2023-04-15T19:11:53.945983  / # /lava-9995958/bin/lava-test-runner /lav=
a-9995958/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af747139eb2fba12e8664

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af747139eb2fba12e8669
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:12:51.443744  <8>[   10.804556] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 9996024_1.4.2.3.1>

    2023-04-15T19:12:51.446574  + set +x

    2023-04-15T19:12:51.548795  =


    2023-04-15T19:12:51.649942  / # #export SHELL=3D/bin/sh

    2023-04-15T19:12:51.650161  =


    2023-04-15T19:12:51.751138  / # export SHELL=3D/bin/sh. /lava-9996024/e=
nvironment

    2023-04-15T19:12:51.751356  =


    2023-04-15T19:12:51.852360  / # . /lava-9996024/environment/lava-999602=
4/bin/lava-test-runner /lava-9996024/1

    2023-04-15T19:12:51.852675  =


    2023-04-15T19:12:51.857649  / # /lava-9996024/bin/lava-test-runner /lav=
a-9996024/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af724d074884d282e86eb

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af724d074884d282e86f0
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:12:14.227076  + <8>[   10.645069] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 9996007_1.4.2.3.1>

    2023-04-15T19:12:14.227559  set +x

    2023-04-15T19:12:14.335767  / # #

    2023-04-15T19:12:14.437503  export SHELL=3D/bin/sh

    2023-04-15T19:12:14.438013  #

    2023-04-15T19:12:14.539586  / # export SHELL=3D/bin/sh. /lava-9996007/e=
nvironment

    2023-04-15T19:12:14.540353  =


    2023-04-15T19:12:14.642287  / # . /lava-9996007/environment/lava-999600=
7/bin/lava-test-runner /lava-9996007/1

    2023-04-15T19:12:14.643588  =


    2023-04-15T19:12:14.648751  / # /lava-9996007/bin/lava-test-runner /lav=
a-9996007/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/643afc4c0372442b182e85e6

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-i=
mx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643afc4c0372442b182e85eb
        failing since 78 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-15T19:34:27.616243  + set +x
    2023-04-15T19:34:27.616428  [    9.397717] <LAVA_SIGNAL_ENDRUN 0_dmesg =
927159_1.5.2.3.1>
    2023-04-15T19:34:27.724384  / # #
    2023-04-15T19:34:27.825916  export SHELL=3D/bin/sh
    2023-04-15T19:34:27.826374  #
    2023-04-15T19:34:27.927594  / # export SHELL=3D/bin/sh. /lava-927159/en=
vironment
    2023-04-15T19:34:27.928084  =

    2023-04-15T19:34:28.029415  / # . /lava-927159/environment/lava-927159/=
bin/lava-test-runner /lava-927159/1
    2023-04-15T19:34:28.030076  =

    2023-04-15T19:34:28.032255  / # /lava-927159/bin/lava-test-runner /lava=
-927159/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/643af70d2a547d30142e85e7

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collab=
ora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af70d2a547d30142e85ec
        failing since 18 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-15T19:11:53.800616  + set +x<8>[   11.245337] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 9996026_1.4.2.3.1>

    2023-04-15T19:11:53.800729  =


    2023-04-15T19:11:53.905280  / # #

    2023-04-15T19:11:54.006147  export SHELL=3D/bin/sh

    2023-04-15T19:11:54.006387  #

    2023-04-15T19:11:54.107344  / # export SHELL=3D/bin/sh. /lava-9996026/e=
nvironment

    2023-04-15T19:11:54.107549  =


    2023-04-15T19:11:54.208529  / # . /lava-9996026/environment/lava-999602=
6/bin/lava-test-runner /lava-9996026/1

    2023-04-15T19:11:54.208863  =


    2023-04-15T19:11:54.213579  / # /lava-9996026/bin/lava-test-runner /lav=
a-9996026/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
meson-gxl-s905x-libretech-cc | arm64  | lab-broonie     | gcc-10   | defcon=
fig+arm64-chromebook   | 2          =


  Details:     https://kernelci.org/test/plan/id/643af79cea89fa161f2e8613

  Results:     50 PASS, 4 FAIL, 1 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-meson-gxl-s905x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm64/defconfig+arm64-chromebook/gcc-10/lab-broonie/base=
line-meson-gxl-s905x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.sound-card: https://kernelci.org/test/case/id/643af79ce=
a89fa161f2e8616
        new failure (last pass: v5.15.105-200-gd0fa0a038a68)

    2023-04-15T19:14:12.393095  /lava-333648/1/../bin/lava-test-case
    2023-04-15T19:14:12.402704  <8>[   19.375806] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsound-card RESULT=3Dfail>   =


  * baseline.bootrr.sound-card-probed: https://kernelci.org/test/case/id/64=
3af79cea89fa161f2e8617
        new failure (last pass: v5.15.105-200-gd0fa0a038a68)

    2023-04-15T19:14:11.361678  /lava-333648/1/../bin/lava-test-case
    2023-04-15T19:14:11.371717  <8>[   18.343106] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dsound-card-probed RESULT=3Dfail>   =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
sun8i-h2-plus-orangepi-r1    | arm    | lab-baylibre    | gcc-10   | sunxi_=
defconfig              | 1          =


  Details:     https://kernelci.org/test/plan/id/643af7d0528b354e882e8629

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: sunxi_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-200-g60d79b2c931a/arm/sunxi_defconfig/gcc-10/lab-baylibre/baseline-sun8i-h=
2-plus-orangepi-r1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/643af7d0528b354e882e862e
        failing since 74 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.90-203-gea2e94bef77e)

    2023-04-15T19:15:10.874232  =

    2023-04-15T19:15:10.980352  / # #export SHELL=3D/bin/sh
    2023-04-15T19:15:10.982159  =

    2023-04-15T19:15:11.085879  / # export SHELL=3D/bin/sh. /lava-3499205/e=
nvironment
    2023-04-15T19:15:11.087605  =

    2023-04-15T19:15:11.191526  / # . /lava-3499205/environment/lava-349920=
5/bin/lava-test-runner /lava-3499205/1
    2023-04-15T19:15:11.195236  =

    2023-04-15T19:15:11.209792  / # /lava-3499205/bin/lava-test-runner /lav=
a-3499205/1
    2023-04-15T19:15:11.315720  + export 'TESTRUN_ID=3D1_bootrr'
    2023-04-15T19:15:11.317080  + cd /lava-3499205/1/tests/1_bootrr =

    ... (10 line(s) more)  =

 =20
