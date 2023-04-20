Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45AAB6E9C99
	for <lists+stable@lfdr.de>; Thu, 20 Apr 2023 21:44:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231981AbjDTToI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Apr 2023 15:44:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229521AbjDTToG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Apr 2023 15:44:06 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E26646AF
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 12:44:02 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1a92513abebso16379365ad.2
        for <stable@vger.kernel.org>; Thu, 20 Apr 2023 12:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682019841; x=1684611841;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=As6EqD/PPxFIQTwhcsFvOe9Q17g8QpKR7yfTLoMzn/o=;
        b=2RPTE9L3B129a3+ZiU2MH4sAepgIADUCykawLKPJO6zRLKNp65NH2yfydIsoL9/pca
         J3rH5Ye0kpXBSSnRJZr+wZLQbj1RUFlYVK6jsYxT6NrqBXHqHs31fSil/qPYt4ZgJ55S
         iPXNaacfFdXNXY9bLPDI7eyf2nqn8+zG4Tf1SmGcZyZAcvf/VNyz+sMa16SbClf6HqH2
         kcNfDCs8wMZaaetpA1XTSWsWABxBYOsJhDudgjasBcJ9OP3Wy49sWGXcL7lgS13rFLhI
         tEgUNjpflnN0yjy24ycY3Qq2pyjeEzk6hLUxFeSenGHsyEeEzh18paLEk0eXu7qzqe6i
         UPmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682019841; x=1684611841;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=As6EqD/PPxFIQTwhcsFvOe9Q17g8QpKR7yfTLoMzn/o=;
        b=YnOW/T3tbspxehl36pP97pIsQsUHTjFBjKMfPIFVxRO3TZoZUrNkv4Zw3wnnFf2tIF
         YnQh/X1PFxYiZJL1yva/smDWluXSEY8t9OvJfb31TATqWxlHsrd5QK8o5Sl6Liru/Rlc
         ZGQWJlp0H1C/BkPsm/bQT1v7XQUOWWGsMhHtayQnZAS26rDWNPnPjWZoRspr9OCZe6NL
         8sbYfZdjAQA2qMJxWkfZrfSbIiOqEduDWXJj4WawNXGHa0FZE3xux+oNMrcrmP3yAaDz
         xpg7MGOlIC+I2N22SiJVzGR7OaKEP8hvNq/LjifVNQYJr3ZWMEAolHXmrCAJh6wX+OZj
         pyng==
X-Gm-Message-State: AAQBX9dkad2efmVyvwn9UANesMWMlTXPReDy2eg4x4W75lhS+p0DFBkP
        5y3P2f6gd7YwkzCXHcqqlBueIgaNFvAYuQ9xu+CM6Err
X-Google-Smtp-Source: AKy350YI74lVlSg6CtTdTgq0Wl1+PlXweLqtzn7hg06P+dSxOVxZLQEcjGaJtkYNJcJ2d0ifQ1xK6w==
X-Received: by 2002:a17:903:22c5:b0:1a4:f1aa:3ea8 with SMTP id y5-20020a17090322c500b001a4f1aa3ea8mr2907807plg.48.1682019840978;
        Thu, 20 Apr 2023 12:44:00 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m18-20020a170902bb9200b00196807b5189sm1471194pls.292.2023.04.20.12.44.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Apr 2023 12:44:00 -0700 (PDT)
Message-ID: <64419600.170a0220.637bd.38af@mx.google.com>
Date:   Thu, 20 Apr 2023 12:44:00 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v6.1.25
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-6.1.y
X-Kernelci-Report-Type: test
Subject: stable/linux-6.1.y baseline: 133 runs, 19 regressions (v6.1.25)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "chromeos.kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-6.1.y baseline: 133 runs, 19 regressions (v6.1.25)

Regressions Summary
-------------------

platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...6-chromebook | 1          =

asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-12b-c...4000-octopus | x86_64 | lab-collabora-staging | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-14-G1-sona           | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =

lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-6.1.y/kernel/=
v6.1.25/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-6.1.y
  Describe: v6.1.25
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      f17b0ab65d17988d5e6d6fe22f708ef3721080bf =



Test Regressions
---------------- =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d90074555d3a5748101

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus-C4=
36FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus-C4=
36FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d90074555d3a5748106
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:50.207448  <8>[   10.148845] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064546_1.4.2.3.1>

    2023-04-20T15:42:50.210327  + set +x

    2023-04-20T15:42:50.315880  / # #

    2023-04-20T15:42:50.416968  export SHELL=3D/bin/sh

    2023-04-20T15:42:50.417162  #

    2023-04-20T15:42:50.518131  / # export SHELL=3D/bin/sh. /lava-10064546/=
environment

    2023-04-20T15:42:50.518323  =


    2023-04-20T15:42:50.619211  / # . /lava-10064546/environment/lava-10064=
546/bin/lava-test-runner /lava-10064546/1

    2023-04-20T15:42:50.619479  =


    2023-04-20T15:42:50.625551  / # /lava-10064546/bin/lava-test-runner /la=
va-10064546/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c8f962cb273c2748149

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-denverton.flavour.=
config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415c8f962cb273c274814e
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:38:37.802595  + set +x

    2023-04-20T15:38:37.809195  <8>[    6.769611] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064467_1.4.2.3.1>

    2023-04-20T15:38:37.914254  / # #

    2023-04-20T15:38:38.015157  export SHELL=3D/bin/sh

    2023-04-20T15:38:38.015353  #

    2023-04-20T15:38:38.116274  / # export SHELL=3D/bin/sh. /lava-10064467/=
environment

    2023-04-20T15:38:38.116471  =


    2023-04-20T15:38:38.217471  / # . /lava-10064467/environment/lava-10064=
467/bin/lava-test-runner /lava-10064467/1

    2023-04-20T15:38:38.217745  =


    2023-04-20T15:38:38.222912  / # /lava-10064467/bin/lava-test-runner /la=
va-10064467/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64416286f34fc3751a748236

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-pineview.flavour.c=
onfig+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-pineview.flavour.config+x86-c=
hromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-a=
sus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-pineview.flavour.config+x86-c=
hromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-a=
sus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64416286f34fc3751a74823b
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T16:04:06.234977  + set +x

    2023-04-20T16:04:06.238671  <8>[    7.086085] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064933_1.4.2.3.1>

    2023-04-20T16:04:06.345657  / # #

    2023-04-20T16:04:06.446700  export SHELL=3D/bin/sh

    2023-04-20T16:04:06.446913  #

    2023-04-20T16:04:06.547891  / # export SHELL=3D/bin/sh. /lava-10064933/=
environment

    2023-04-20T16:04:06.548107  =


    2023-04-20T16:04:06.649063  / # . /lava-10064933/environment/lava-10064=
933/bin/lava-test-runner /lava-10064933/1

    2023-04-20T16:04:06.649379  =


    2023-04-20T16:04:06.654244  / # /lava-10064933/bin/lava-test-runner /la=
va-10064933/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415da7074555d3a5748130

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-asus-CM=
1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-asus-CM=
1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415da7074555d3a5748135
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:43:25.236358  + set +x

    2023-04-20T15:43:25.242860  <8>[    7.159469] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064593_1.4.2.3.1>

    2023-04-20T15:43:25.350261  / # #

    2023-04-20T15:43:25.452481  export SHELL=3D/bin/sh

    2023-04-20T15:43:25.453078  #

    2023-04-20T15:43:25.554760  / # export SHELL=3D/bin/sh. /lava-10064593/=
environment

    2023-04-20T15:43:25.555502  =


    2023-04-20T15:43:25.657162  / # . /lava-10064593/environment/lava-10064=
593/bin/lava-test-runner /lava-10064593/1

    2023-04-20T15:43:25.658168  =


    2023-04-20T15:43:25.663460  / # /lava-10064593/bin/lava-test-runner /la=
va-10064593/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/644164b69690d10e47748101

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config+=
x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook/clang-14/lab-collabora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook/clang-14/lab-collabora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/644164b69690d10e47748=
102
        new failure (last pass: v6.1.24) =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d8467796e3329748184

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus-CM=
1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus-CM=
1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d8467796e3329748189
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:33.956086  <8>[   12.013313] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064543_1.4.2.3.1>

    2023-04-20T15:42:34.060979  / # #

    2023-04-20T15:42:34.161643  export SHELL=3D/bin/sh

    2023-04-20T15:42:34.161860  #

    2023-04-20T15:42:34.262802  / # export SHELL=3D/bin/sh. /lava-10064543/=
environment

    2023-04-20T15:42:34.263018  =


    2023-04-20T15:42:34.363930  / # . /lava-10064543/environment/lava-10064=
543/bin/lava-test-runner /lava-10064543/1

    2023-04-20T15:42:34.364234  =


    2023-04-20T15:42:34.368899  / # /lava-10064543/bin/lava-test-runner /la=
va-10064543/1

    2023-04-20T15:42:34.384254  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c9e4ef990e5d37481a3

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-denverton.flavour.=
config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415c9e4ef990e5d37481a8
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:38:51.735095  <8>[    6.188005] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064486_1.4.2.3.1>

    2023-04-20T15:38:51.738665  + set +x

    2023-04-20T15:38:51.840402  =


    2023-04-20T15:38:51.941368  / # #export SHELL=3D/bin/sh

    2023-04-20T15:38:51.941541  =


    2023-04-20T15:38:52.042460  / # export SHELL=3D/bin/sh. /lava-10064486/=
environment

    2023-04-20T15:38:52.042724  =


    2023-04-20T15:38:52.143652  / # . /lava-10064486/environment/lava-10064=
486/bin/lava-test-runner /lava-10064486/1

    2023-04-20T15:38:52.143899  =


    2023-04-20T15:38:52.149582  / # /lava-10064486/bin/lava-test-runner /la=
va-10064486/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d715652eacc8d7482b9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus-cx=
9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-asus-cx=
9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d715652eacc8d7482be
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:28.079989  <8>[   11.000197] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064547_1.4.2.3.1>

    2023-04-20T15:42:28.083737  + set +x

    2023-04-20T15:42:28.190387  #

    2023-04-20T15:42:28.191887  =


    2023-04-20T15:42:28.294393  / # #export SHELL=3D/bin/sh

    2023-04-20T15:42:28.295246  =


    2023-04-20T15:42:28.397572  / # export SHELL=3D/bin/sh. /lava-10064547/=
environment

    2023-04-20T15:42:28.398446  =


    2023-04-20T15:42:28.500678  / # . /lava-10064547/environment/lava-10064=
547/bin/lava-test-runner /lava-10064547/1

    2023-04-20T15:42:28.502103  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415db63ddcd3d66f74812e

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x360=
-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x360=
-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415db63ddcd3d66f748133
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:43:35.727789  + set +x

    2023-04-20T15:43:35.733993  <8>[   10.657185] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064527_1.4.2.3.1>

    2023-04-20T15:43:35.838739  / # #

    2023-04-20T15:43:35.939620  export SHELL=3D/bin/sh

    2023-04-20T15:43:35.939822  #

    2023-04-20T15:43:36.040714  / # export SHELL=3D/bin/sh. /lava-10064527/=
environment

    2023-04-20T15:43:36.040889  =


    2023-04-20T15:43:36.141797  / # . /lava-10064527/environment/lava-10064=
527/bin/lava-test-runner /lava-10064527/1

    2023-04-20T15:43:36.142157  =


    2023-04-20T15:43:36.146563  / # /lava-10064527/bin/lava-test-runner /la=
va-10064527/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-12b-c...4000-octopus | x86_64 | lab-collabora-staging | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d545652eacc8d74820d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora-staging/baseline=
-hp-x360-12b-ca0500na-n4000-octopus.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora-staging/baseline=
-hp-x360-12b-ca0500na-n4000-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d545652eacc8d748212
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:03.063069  + set +x

    2023-04-20T15:42:03.065621  <8>[    8.295726] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 439613_1.4.2.3.1>

    2023-04-20T15:42:03.186376  / # #

    2023-04-20T15:42:03.291339  export SHELL=3D/bin/sh

    2023-04-20T15:42:03.292954  #

    2023-04-20T15:42:03.395574  / # export SHELL=3D/bin/sh. /lava-439613/en=
vironment

    2023-04-20T15:42:03.397397  =


    2023-04-20T15:42:03.499964  / # . /lava-439613/environment/lava-439613/=
bin/lava-test-runner /lava-439613/1

    2023-04-20T15:42:03.502809  =


    2023-04-20T15:42:03.506311  / # /lava-439613/bin/lava-test-runner /lava=
-439613/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d625cddaa2a8674811b

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x360=
-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x360=
-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d625cddaa2a86748120
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:05.539633  + set<8>[   10.630195] <LAVA_SIGNAL_ENDRUN =
0_dmesg 10064544_1.4.2.3.1>

    2023-04-20T15:42:05.539769   +x

    2023-04-20T15:42:05.641712  /#

    2023-04-20T15:42:05.743126   # #export SHELL=3D/bin/sh

    2023-04-20T15:42:05.743344  =


    2023-04-20T15:42:05.844254  / # export SHELL=3D/bin/sh. /lava-10064544/=
environment

    2023-04-20T15:42:05.844470  =


    2023-04-20T15:42:05.945466  / # . /lava-10064544/environment/lava-10064=
544/bin/lava-test-runner /lava-10064544/1

    2023-04-20T15:42:05.945757  =


    2023-04-20T15:42:05.950532  / # /lava-10064544/bin/lava-test-runner /la=
va-10064544/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c8e962e8162e0748127

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-denverton.flavour.=
config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415c8e962e8162e074812c
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:38:37.547022  + set +x

    2023-04-20T15:38:37.553790  <8>[    6.769322] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064460_1.4.2.3.1>

    2023-04-20T15:38:37.659162  / # #

    2023-04-20T15:38:37.760225  export SHELL=3D/bin/sh

    2023-04-20T15:38:37.760420  #

    2023-04-20T15:38:37.861386  / # export SHELL=3D/bin/sh. /lava-10064460/=
environment

    2023-04-20T15:38:37.861582  =


    2023-04-20T15:38:37.962548  / # . /lava-10064460/environment/lava-10064=
460/bin/lava-test-runner /lava-10064460/1

    2023-04-20T15:38:37.962836  =


    2023-04-20T15:38:37.967782  / # /lava-10064460/bin/lava-test-runner /la=
va-10064460/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/6441625e884365547674810d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-pineview.flavour.c=
onfig+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-pineview.flavour.config+x86-c=
hromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-h=
p-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-pineview.flavour.config+x86-c=
hromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-h=
p-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6441625e8843655476748112
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T16:03:25.045339  + set +x

    2023-04-20T16:03:25.051913  <8>[    6.788391] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064991_1.4.2.3.1>

    2023-04-20T16:03:25.159964  / # #

    2023-04-20T16:03:25.262538  export SHELL=3D/bin/sh

    2023-04-20T16:03:25.263526  #

    2023-04-20T16:03:25.365846  / # export SHELL=3D/bin/sh. /lava-10064991/=
environment

    2023-04-20T16:03:25.366522  =


    2023-04-20T16:03:25.468343  / # . /lava-10064991/environment/lava-10064=
991/bin/lava-test-runner /lava-10064991/1

    2023-04-20T16:03:25.469413  =


    2023-04-20T16:03:25.474764  / # /lava-10064991/bin/lava-test-runner /la=
va-10064991/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415dbcee9ae871d474813c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-hp-x360=
-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-hp-x360=
-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415dbcee9ae871d4748141
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:43:33.206411  + set +x

    2023-04-20T15:43:33.209435  <8>[    7.019201] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064614_1.4.2.3.1>

    2023-04-20T15:43:33.320295  / # #

    2023-04-20T15:43:33.423200  export SHELL=3D/bin/sh

    2023-04-20T15:43:33.424001  #

    2023-04-20T15:43:33.525759  / # export SHELL=3D/bin/sh. /lava-10064614/=
environment

    2023-04-20T15:43:33.525973  =


    2023-04-20T15:43:33.626909  / # . /lava-10064614/environment/lava-10064=
614/bin/lava-test-runner /lava-10064614/1

    2023-04-20T15:43:33.627319  =


    2023-04-20T15:43:33.632410  / # /lava-10064614/bin/lava-test-runner /la=
va-10064614/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d7210c31f744974810f

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x360=
-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-hp-x360=
-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d7210c31f7449748114
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:27.965657  <8>[   10.855195] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064572_1.4.2.3.1>

    2023-04-20T15:42:28.074057  / # #

    2023-04-20T15:42:28.176955  export SHELL=3D/bin/sh

    2023-04-20T15:42:28.177764  #

    2023-04-20T15:42:28.279837  / # export SHELL=3D/bin/sh. /lava-10064572/=
environment

    2023-04-20T15:42:28.280652  =


    2023-04-20T15:42:28.382670  / # . /lava-10064572/environment/lava-10064=
572/bin/lava-test-runner /lava-10064572/1

    2023-04-20T15:42:28.383933  =


    2023-04-20T15:42:28.388647  / # /lava-10064572/bin/lava-test-runner /la=
va-10064572/1

    2023-04-20T15:42:28.404862  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415c8f8bba1f12407481c6

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-denverton.flavour.=
config+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-denverton.flavour.config+x86-=
chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-=
lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415c8f8bba1f12407481cb
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:38:34.176277  + set +x<8>[    6.813579] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10064480_1.4.2.3.1>

    2023-04-20T15:38:34.176404  =


    2023-04-20T15:38:34.280765  / # #

    2023-04-20T15:38:34.381617  export SHELL=3D/bin/sh

    2023-04-20T15:38:34.381835  #

    2023-04-20T15:38:34.482747  / # export SHELL=3D/bin/sh. /lava-10064480/=
environment

    2023-04-20T15:38:34.483001  =


    2023-04-20T15:38:34.583929  / # . /lava-10064480/environment/lava-10064=
480/bin/lava-test-runner /lava-10064480/1

    2023-04-20T15:38:34.584244  =


    2023-04-20T15:38:34.588855  / # /lava-10064480/bin/lava-test-runner /la=
va-10064480/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/644163044910826f80748118

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromeos-intel-pineview.flavour.c=
onfig+x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-pineview.flavour.config+x86-c=
hromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-l=
enovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromeos-intel-pineview.flavour.config+x86-c=
hromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-l=
enovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/644163044910826f8074811d
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T16:06:09.274323  <6>[    7.676800] usb 1-1.4: new full-speed=
 USB device number 11 using xhci_hcd

    2023-04-20T16:06:09.274709  + set +x

    2023-04-20T16:06:09.281180  <4>[    7.684038] usb 1-1.4: Device not res=
ponding to setup address.

    2023-04-20T16:06:09.287574  <8>[    7.684141] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064985_1.4.2.3.1>

    2023-04-20T16:06:09.395140  / # #

    2023-04-20T16:06:09.496276  export SHELL=3D/bin/sh

    2023-04-20T16:06:09.496946  #

    2023-04-20T16:06:09.598605  / # export SHELL=3D/bin/sh. /lava-10064985/=
environment

    2023-04-20T16:06:09.599294  <4>[    7.906326] usb 1-1.4: Device not res=
ponding to setup address.

    2023-04-20T16:06:09.599627  =

 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
cros://chrome...PRESS_GZIP=3Dn | 1          =


  Details:     https://kernelci.org/test/plan/id/64415db316381adf6d74811a

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: cros://chromeos-6.1/x86_64/chromiumos-x86_64.flavour.config+=
x86-chromebook+CONFIG_MODULE_COMPRESS_GZIP=3Dn
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-lenovo-=
TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/cros---chromeos-6.1-x86_64-chromiumos-x86_64.flavour.config+x86-chromeb=
ook+CONFIG_MODULE_COMPRESS_GZIP=3Dn/clang-14/lab-collabora/baseline-lenovo-=
TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415db316381adf6d74811f
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:43:34.427111  + set +x

    2023-04-20T15:43:34.430627  <8>[    7.743182] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10064599_1.4.2.3.1>

    2023-04-20T15:43:34.535816  / # #

    2023-04-20T15:43:34.637523  export SHELL=3D/bin/sh

    2023-04-20T15:43:34.638335  <6>[    7.784866] usb 1-1.4: new full-speed=
 USB device number 11 using xhci_hcd

    2023-04-20T15:43:34.638752  <4>[    7.792038] usb 1-1.4: Device not res=
ponding to setup address.

    2023-04-20T15:43:34.639141  #

    2023-04-20T15:43:34.740896  / # export SHELL=3D/bin/sh. /lava-10064599/=
environment

    2023-04-20T15:43:34.741116  =


    2023-04-20T15:43:34.741197  / # <4>[    8.002947] usb 1-1.4: Device not=
 responding to setup address.
 =

    ... (17 line(s) more)  =

 =



platform                     | arch   | lab                   | compiler | =
defconfig                    | regressions
-----------------------------+--------+-----------------------+----------+-=
-----------------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora         | clang-14 | =
x86_64_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64415d645cddaa2a86748126

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    clang-14 (Debian clang version 14.0.6)
  Plain log:   https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-lenovo-=
TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable/linux-6.1.y/v6.1.25/x86=
_64/x86_64_defconfig+x86-chromebook/clang-14/lab-collabora/baseline-lenovo-=
TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230407.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64415d645cddaa2a8674812b
        failing since 14 days (last pass: v6.1.22, first fail: v6.1.23)

    2023-04-20T15:42:12.394384  + <8>[    9.394235] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10064539_1.4.2.3.1>

    2023-04-20T15:42:12.394470  set +x

    2023-04-20T15:42:12.499424  / # #

    2023-04-20T15:42:12.600314  export SHELL=3D/bin/sh

    2023-04-20T15:42:12.600536  #

    2023-04-20T15:42:12.701547  / # export SHELL=3D/bin/sh. /lava-10064539/=
environment

    2023-04-20T15:42:12.701767  =


    2023-04-20T15:42:12.802710  / # . /lava-10064539/environment/lava-10064=
539/bin/lava-test-runner /lava-10064539/1

    2023-04-20T15:42:12.802985  =


    2023-04-20T15:42:12.807240  / # /lava-10064539/bin/lava-test-runner /la=
va-10064539/1
 =

    ... (12 line(s) more)  =

 =20
