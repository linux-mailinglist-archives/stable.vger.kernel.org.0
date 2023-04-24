Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5D8F6ED47A
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 20:34:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjDXSeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 14:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231993AbjDXSeE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 14:34:04 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95E88768C
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 11:33:53 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a66b9bd7dfso52922325ad.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 11:33:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682361232; x=1684953232;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2jM8gQfIFkmGiNTil/BUPrygTbaeuCfIBwB+/3WzR54=;
        b=auARNeqISPagh5frJ7zTCzm502adAh/dLFvfWRr+QkI2kOKW6KtxdbVEa/tbddm+6U
         qKjaSJjMNatUBDn9eyEcus0dqshCDQzRt9ttGx8TqYc3u46vGJjINOB4bKeXprJGBONw
         4li4nTm3TLPKxlw8W8h+oxyEslivlkqZ7rmicXQokbSSEWmYx9U+UV01H6B8pGWyI2F2
         za2nsNO5SSj5Kn6shLxAAtj0Z4B1S7m3argRQxRIsU7/x9XRE7u5kuEyCfnk6QzD/+7V
         BkF/5UsP8oPXfYMqtN4nPKsFRAAcbhDbwjscn0gHVCe/N7RieBC1Uxrob38ILF2Vhy6C
         n2LQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682361232; x=1684953232;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2jM8gQfIFkmGiNTil/BUPrygTbaeuCfIBwB+/3WzR54=;
        b=liXZv5p+szZm7tRH3+F7xs2NQbJh6B8hKN1El0sFUetjcWWX8gtdHUf/lE/MZZD6ic
         jlIk+QzpDiGSikEy9ZVl5KDW+gVd/yZ0uOPdibWAXbdPZwTikycWocQ4y6l0ZBJcCFNo
         e+/MpoVaisxGyYJ09aCXyTn9ZmwfGMyCwGScFfWtduvaGgXLPDIzavVoccSwQY7JBxAw
         AGlAKTjHNKv3nFw4yES4PrfeiGF/NnY1XOa22uEv9NFDkyTunXAw7RH9CKp6h8SL4g5C
         a419BARSf3uGVFRchTp2W7f5mMxiwygiGCUrrnomrjEY5BgQyfcdWamLN9TdoRcsmzLq
         aBrA==
X-Gm-Message-State: AAQBX9cF1x7Ji5Gb1rwPx/VUB9X+JB+IHo3zIRra+p2gU+UPUGS7WDGh
        Eq6dErXF+5WjUZIRwTXgqFmjZHhd70pi4fP3QqurlQ==
X-Google-Smtp-Source: AKy350a3IBrsn96+uzxkTPZIuk0z+dPDzhpRovaQgsfIp2IGDoOsFLc2tY5x/oCHKPctgJWO3OyaPw==
X-Received: by 2002:a17:903:41c2:b0:1a8:1b63:8aee with SMTP id u2-20020a17090341c200b001a81b638aeemr19594253ple.46.1682361232226;
        Mon, 24 Apr 2023 11:33:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13-20020a170902ee8d00b001a66bf1406bsm6880946pld.144.2023.04.24.11.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 11:33:51 -0700 (PDT)
Message-ID: <6446cb8f.170a0220.186ec.da09@mx.google.com>
Date:   Mon, 24 Apr 2023 11:33:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-346-gfe100f863aebc
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 131 runs,
 10 regressions (v5.15.105-346-gfe100f863aebc)
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

stable-rc/queue/5.15 baseline: 131 runs, 10 regressions (v5.15.105-346-gfe1=
00f863aebc)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.105-346-gfe100f863aebc/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-346-gfe100f863aebc
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe100f863aebcb122fc45d6b365d2c3def587678 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644695cf581e5e97792e8606

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644695cf581e5e97792e860b
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:44:12.363568  + set +x

    2023-04-24T14:44:12.370085  <8>[   10.687911] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104426_1.4.2.3.1>

    2023-04-24T14:44:12.474477  / # #

    2023-04-24T14:44:12.575096  export SHELL=3D/bin/sh

    2023-04-24T14:44:12.575306  #

    2023-04-24T14:44:12.675887  / # export SHELL=3D/bin/sh. /lava-10104426/=
environment

    2023-04-24T14:44:12.676081  =


    2023-04-24T14:44:12.776586  / # . /lava-10104426/environment/lava-10104=
426/bin/lava-test-runner /lava-10104426/1

    2023-04-24T14:44:12.776865  =


    2023-04-24T14:44:12.782267  / # /lava-10104426/bin/lava-test-runner /la=
va-10104426/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644695d3581e5e97792e86ae

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644695d3581e5e97792e86b3
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:44:14.013827  + set<8>[   11.132555] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10104414_1.4.2.3.1>

    2023-04-24T14:44:14.014586   +x

    2023-04-24T14:44:14.123425  / # #

    2023-04-24T14:44:14.226490  export SHELL=3D/bin/sh

    2023-04-24T14:44:14.227325  #

    2023-04-24T14:44:14.328847  / # export SHELL=3D/bin/sh. /lava-10104414/=
environment

    2023-04-24T14:44:14.329025  =


    2023-04-24T14:44:14.429526  / # . /lava-10104414/environment/lava-10104=
414/bin/lava-test-runner /lava-10104414/1

    2023-04-24T14:44:14.429789  =


    2023-04-24T14:44:14.434627  / # /lava-10104414/bin/lava-test-runner /la=
va-10104414/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644695dbf33558a2a72e8638

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644695dbf33558a2a72e863d
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:44:34.409285  <8>[   11.309780] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104445_1.4.2.3.1>

    2023-04-24T14:44:34.412873  + set +x

    2023-04-24T14:44:34.519126  =


    2023-04-24T14:44:34.621418  / # #export SHELL=3D/bin/sh

    2023-04-24T14:44:34.622260  =


    2023-04-24T14:44:34.723805  / # export SHELL=3D/bin/sh. /lava-10104445/=
environment

    2023-04-24T14:44:34.724015  =


    2023-04-24T14:44:34.824676  / # . /lava-10104445/environment/lava-10104=
445/bin/lava-test-runner /lava-10104445/1

    2023-04-24T14:44:34.825866  =


    2023-04-24T14:44:34.830664  / # /lava-10104445/bin/lava-test-runner /la=
va-10104445/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64469a36995baac5152e85ff

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64469a36995baac5152e8=
600
        failing since 80 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64469a8fbb9a2ac8bf2e85fc

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469a8fbb9a2ac8bf2e8601
        failing since 97 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-24T15:04:26.482776  + set +x<8>[   10.086744] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 3527353_1.5.2.4.1>
    2023-04-24T15:04:26.483267  =

    2023-04-24T15:04:26.591484  / # #
    2023-04-24T15:04:26.693256  export SHELL=3D/bin/sh
    2023-04-24T15:04:26.693951  #
    2023-04-24T15:04:26.795701  / # export SHELL=3D/bin/sh. /lava-3527353/e=
nvironment
    2023-04-24T15:04:26.796304  =

    2023-04-24T15:04:26.898015  / # . /lava-3527353/environment/lava-352735=
3/bin/lava-test-runner /lava-3527353/1
    2023-04-24T15:04:26.899562  =

    2023-04-24T15:04:26.905078  / # /lava-3527353/bin/lava-test-runner /lav=
a-3527353/1<3>[   10.512756] Bluetooth: hci0: command 0x0c03 tx timeout =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64469610f79bca69af2e85e6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469610f79bca69af2e85eb
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:45:19.995549  + <8>[   10.121043] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10104401_1.4.2.3.1>

    2023-04-24T14:45:19.995636  set +x

    2023-04-24T14:45:20.096860  #

    2023-04-24T14:45:20.097199  =


    2023-04-24T14:45:20.197777  / # #export SHELL=3D/bin/sh

    2023-04-24T14:45:20.198049  =


    2023-04-24T14:45:20.298689  / # export SHELL=3D/bin/sh. /lava-10104401/=
environment

    2023-04-24T14:45:20.298885  =


    2023-04-24T14:45:20.399382  / # . /lava-10104401/environment/lava-10104=
401/bin/lava-test-runner /lava-10104401/1

    2023-04-24T14:45:20.399734  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644695c15123d082942e8610

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644695c15123d082942e8615
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:44:03.108590  + set +x

    2023-04-24T14:44:03.114869  <8>[   10.467545] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104422_1.4.2.3.1>

    2023-04-24T14:44:03.217547  =


    2023-04-24T14:44:03.318122  / # #export SHELL=3D/bin/sh

    2023-04-24T14:44:03.318326  =


    2023-04-24T14:44:03.418825  / # export SHELL=3D/bin/sh. /lava-10104422/=
environment

    2023-04-24T14:44:03.419033  =


    2023-04-24T14:44:03.519562  / # . /lava-10104422/environment/lava-10104=
422/bin/lava-test-runner /lava-10104422/1

    2023-04-24T14:44:03.519993  =


    2023-04-24T14:44:03.524340  / # /lava-10104422/bin/lava-test-runner /la=
va-10104422/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644695dc339ee8a0fc2e85fa

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644695dc339ee8a0fc2e85ff
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:44:33.105504  + <8>[   11.083160] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10104459_1.4.2.3.1>

    2023-04-24T14:44:33.105591  set +x

    2023-04-24T14:44:33.210271  / # #

    2023-04-24T14:44:33.311019  export SHELL=3D/bin/sh

    2023-04-24T14:44:33.311823  #

    2023-04-24T14:44:33.413113  / # export SHELL=3D/bin/sh. /lava-10104459/=
environment

    2023-04-24T14:44:33.413281  =


    2023-04-24T14:44:33.513752  / # . /lava-10104459/environment/lava-10104=
459/bin/lava-test-runner /lava-10104459/1

    2023-04-24T14:44:33.513999  =


    2023-04-24T14:44:33.518728  / # /lava-10104459/bin/lava-test-runner /la=
va-10104459/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64469a6b6c1bae53da2e861e

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64469a6b6c1bae53da2e8623
        failing since 87 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-24T15:04:02.025692  + set +x
    2023-04-24T15:04:02.026034  [    9.373775] <LAVA_SIGNAL_ENDRUN 0_dmesg =
935919_1.5.2.3.1>
    2023-04-24T15:04:02.133284  / # #
    2023-04-24T15:04:02.234863  export SHELL=3D/bin/sh
    2023-04-24T15:04:02.235323  #
    2023-04-24T15:04:02.336596  / # export SHELL=3D/bin/sh. /lava-935919/en=
vironment
    2023-04-24T15:04:02.337042  =

    2023-04-24T15:04:02.438297  / # . /lava-935919/environment/lava-935919/=
bin/lava-test-runner /lava-935919/1
    2023-04-24T15:04:02.439143  =

    2023-04-24T15:04:02.441727  / # /lava-935919/bin/lava-test-runner /lava=
-935919/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644695caa054afb1c32e860d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-346-gfe100f863aebc/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644695caa054afb1c32e8612
        failing since 27 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-24T14:44:14.418245  <8>[   11.308000] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10104427_1.4.2.3.1>

    2023-04-24T14:44:14.522822  / # #

    2023-04-24T14:44:14.623513  export SHELL=3D/bin/sh

    2023-04-24T14:44:14.623732  #

    2023-04-24T14:44:14.724265  / # export SHELL=3D/bin/sh. /lava-10104427/=
environment

    2023-04-24T14:44:14.724502  =


    2023-04-24T14:44:14.825116  / # . /lava-10104427/environment/lava-10104=
427/bin/lava-test-runner /lava-10104427/1

    2023-04-24T14:44:14.825475  =


    2023-04-24T14:44:14.829953  / # /lava-10104427/bin/lava-test-runner /la=
va-10104427/1

    2023-04-24T14:44:14.835244  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
