Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4856EC175
	for <lists+stable@lfdr.de>; Sun, 23 Apr 2023 19:46:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229602AbjDWRq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 13:46:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjDWRq4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 13:46:56 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95110C9
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 10:46:53 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id d9443c01a7336-1a50cb65c92so31108105ad.0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 10:46:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20221208.gappssmtp.com; s=20221208; t=1682272013; x=1684864013;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Kl1rHKxP0KIW9xicUC50yfrL/vixW3aulj72un9Dnxc=;
        b=cUQ/3j8WnbbpCrscGTOp1Vr2W2RWKS9FgkSIB1faGuQkEL6OK/X5tJt0smo2MpbegP
         EDAXyUPyWy41Y3iUsV4h2/y7P1K7oZsNJKh+AYsxoSyqbmM1z3CGPSNRTW7948XnW+5r
         Xut2Hg0/bsfdfb4jqlMRZxl9fIRIDoPDJWj/Yc25GgYX1r1I7MX0e5pAs5zpz8E/p7/E
         SlVyYb3YzuiQHzXDiw92rZ1vQxNgf5P0PbgQ5x1EBausPvjHKDmf3cjJMuV0I6cExARe
         WOZVmAJzvjIzsMuriTUR4trqZY0srzZOczKvM4ml5m/Fyzoudv8rk/uwOrxG8YYCF5xE
         B/xA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682272013; x=1684864013;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kl1rHKxP0KIW9xicUC50yfrL/vixW3aulj72un9Dnxc=;
        b=EHXAQ9VvO5yjXfO+4qjV6SdIHPN/XkRseSa7wfPxIXZwLduKXDciE8QA7QrvjAYMQ6
         wWZNQw9woDG1x0y3dYTIm7jcY+evvua9IbpCwO26DHhsnzt0KJIyJ/gKeulqy4wa3pWg
         aBVw/egWWjxfD5H7EuE8cKclUDJgCjkesBKdIZt5VhYDX/xFDyxDkCf/JExwZII06Vny
         jNQhZw9mqziPLip9CX4XB8q7k/NK/beELEEie/tKADeC4NCc3Y3Krn6L4mH0ECVl7K8/
         1cOpKGxmFjTmj3mpMRJt5Wh5uh4+fVTO+O4sO7LQFbdlAh4wXANsJei3kO7Fxnor5vj9
         t9jw==
X-Gm-Message-State: AAQBX9fSbpoGwb/ksmDqfH7zJv40Hi7nlY954uUGL9rME6e8biurH+Ss
        SzdvsFjocNPyrbwH8atSPoPa1iuLgoXOtl/HxL0RSQ==
X-Google-Smtp-Source: AKy350Zacwossqun8UVll/vMZkrJ3KhXJZI7/T2I1Tq59EfIp1UpNE5QpM+wrhoc9FCsKmMHh62cUw==
X-Received: by 2002:a17:902:fb86:b0:1a5:4ff:33c0 with SMTP id lg6-20020a170902fb8600b001a504ff33c0mr10112608plb.12.1682272012595;
        Sun, 23 Apr 2023 10:46:52 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11-20020a170902864b00b001a285269b70sm5243426plt.280.2023.04.23.10.46.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 10:46:52 -0700 (PDT)
Message-ID: <64456f0c.170a0220.fbe9b.a747@mx.google.com>
Date:   Sun, 23 Apr 2023 10:46:52 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.105-330-g3091741130361
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 140 runs,
 10 regressions (v5.15.105-330-g3091741130361)
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

stable-rc/queue/5.15 baseline: 140 runs, 10 regressions (v5.15.105-330-g309=
1741130361)

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
nel/v5.15.105-330-g3091741130361/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.105-330-g3091741130361
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3091741130361cb89b0bae95ce3618afc6e0efa3 =



Test Regressions
---------------- =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-C436FA-Flip-hatch       | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c70ad89fe0a082e8604

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-C436FA-Flip-hatch.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c70ad89fe0a082e8609
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:39.284810  + set +x

    2023-04-23T14:10:39.291219  <8>[   10.479614] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092765_1.4.2.3.1>

    2023-04-23T14:10:39.394011  #

    2023-04-23T14:10:39.394373  =


    2023-04-23T14:10:39.495472  / # #export SHELL=3D/bin/sh

    2023-04-23T14:10:39.495725  =


    2023-04-23T14:10:39.596717  / # export SHELL=3D/bin/sh. /lava-10092765/=
environment

    2023-04-23T14:10:39.596942  =


    2023-04-23T14:10:39.697938  / # . /lava-10092765/environment/lava-10092=
765/bin/lava-test-runner /lava-10092765/1

    2023-04-23T14:10:39.698315  =

 =

    ... (13 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-CM1400CXA-dalboz        | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c6fad89fe0a082e85f9

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-CM1400CXA-dalboz.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c6fad89fe0a082e85fe
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:35.764318  + <8>[   11.696879] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10092725_1.4.2.3.1>

    2023-04-23T14:10:35.764397  set +x

    2023-04-23T14:10:35.869135  / # #

    2023-04-23T14:10:35.970137  export SHELL=3D/bin/sh

    2023-04-23T14:10:35.970334  #

    2023-04-23T14:10:36.071242  / # export SHELL=3D/bin/sh. /lava-10092725/=
environment

    2023-04-23T14:10:36.071436  =


    2023-04-23T14:10:36.172308  / # . /lava-10092725/environment/lava-10092=
725/bin/lava-test-runner /lava-10092725/1

    2023-04-23T14:10:36.172568  =


    2023-04-23T14:10:36.177126  / # /lava-10092725/bin/lava-test-runner /la=
va-10092725/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
asus-cx9400-volteer          | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c7443ad1aef6a2e8638

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-asus-cx9400-volteer.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c7443ad1aef6a2e863d
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:39.204763  <8>[    8.463580] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092753_1.4.2.3.1>

    2023-04-23T14:10:39.207849  + set +x

    2023-04-23T14:10:39.309713  =


    2023-04-23T14:10:39.410702  / # #export SHELL=3D/bin/sh

    2023-04-23T14:10:39.410901  =


    2023-04-23T14:10:39.511846  / # export SHELL=3D/bin/sh. /lava-10092753/=
environment

    2023-04-23T14:10:39.512041  =


    2023-04-23T14:10:39.612965  / # . /lava-10092753/environment/lava-10092=
753/bin/lava-test-runner /lava-10092753/1

    2023-04-23T14:10:39.613237  =


    2023-04-23T14:10:39.618131  / # /lava-10092753/bin/lava-test-runner /la=
va-10092753/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
beagle-xm                    | arm    | lab-baylibre    | gcc-10   | omap2p=
lus_defconfig          | 1          =


  Details:     https://kernelci.org/test/plan/id/64453ecf581ca303752e86fc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-be=
agle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/64453ecf581ca303752e8=
6fd
        failing since 79 days (last pass: v5.15.91-12-g3290f78df1ab, first =
fail: v5.15.91-18-ga7afd81d41cb) =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
cubietruck                   | arm    | lab-baylibre    | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c41566ce6d4462e863a

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-cub=
ietruck.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c41566ce6d4462e863f
        failing since 96 days (last pass: v5.15.82-123-gd03dbdba21ef, first=
 fail: v5.15.87-100-ge215d5ead661)

    2023-04-23T14:09:37.301944  <8>[    9.985812] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 3524111_1.5.2.4.1>
    2023-04-23T14:09:37.411750  / # #
    2023-04-23T14:09:37.515519  export SHELL=3D/bin/sh
    2023-04-23T14:09:37.516441  #
    2023-04-23T14:09:37.618381  / # export SHELL=3D/bin/sh. /lava-3524111/e=
nvironment
    2023-04-23T14:09:37.619332  =

    2023-04-23T14:09:37.721352  / # . /lava-3524111/environment/lava-352411=
1/bin/lava-test-runner /lava-3524111/1
    2023-04-23T14:09:37.723044  =

    2023-04-23T14:09:37.723658  / # <3>[   10.352815] Bluetooth: hci0: comm=
and 0x0c03 tx timeout
    2023-04-23T14:09:37.727475  /lava-3524111/bin/lava-test-runner /lava-35=
24111/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-12b-c...4020-octopus | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c63e68f3818182e864c

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-12b-ca0010nr-n4020-octopus.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c63e68f3818182e8651
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:30.977032  + set +x

    2023-04-23T14:10:30.983564  <8>[   10.294131] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092842_1.4.2.3.1>

    2023-04-23T14:10:31.088386  / # #

    2023-04-23T14:10:31.189475  export SHELL=3D/bin/sh

    2023-04-23T14:10:31.189685  #

    2023-04-23T14:10:31.290634  / # export SHELL=3D/bin/sh. /lava-10092842/=
environment

    2023-04-23T14:10:31.290800  =


    2023-04-23T14:10:31.391808  / # . /lava-10092842/environment/lava-10092=
842/bin/lava-test-runner /lava-10092842/1

    2023-04-23T14:10:31.392066  =


    2023-04-23T14:10:31.397119  / # /lava-10092842/bin/lava-test-runner /la=
va-10092842/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14-G1-sona           | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c63143f5001d62e865d

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14-G1-sona.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c63143f5001d62e8662
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:30.350934  + set +x<8>[   10.082185] <LAVA_SIGNAL_ENDR=
UN 0_dmesg 10092762_1.4.2.3.1>

    2023-04-23T14:10:30.351019  =


    2023-04-23T14:10:30.452973  #

    2023-04-23T14:10:30.554148  / # #export SHELL=3D/bin/sh

    2023-04-23T14:10:30.554341  =


    2023-04-23T14:10:30.655245  / # export SHELL=3D/bin/sh. /lava-10092762/=
environment

    2023-04-23T14:10:30.655424  =


    2023-04-23T14:10:30.756351  / # . /lava-10092762/environment/lava-10092=
762/bin/lava-test-runner /lava-10092762/1

    2023-04-23T14:10:30.756659  =


    2023-04-23T14:10:30.761565  / # /lava-10092762/bin/lava-test-runner /la=
va-10092762/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
hp-x360-14a-cb0001xx-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c78bc1ebb2edf2e8601

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-hp-x360-14a-cb0001xx-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c78bc1ebb2edf2e8606
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:43.560126  + <8>[   10.733618] <LAVA_SIGNAL_ENDRUN 0_d=
mesg 10092756_1.4.2.3.1>

    2023-04-23T14:10:43.560618  set +x

    2023-04-23T14:10:43.669251  / # #

    2023-04-23T14:10:43.772141  export SHELL=3D/bin/sh

    2023-04-23T14:10:43.772943  #

    2023-04-23T14:10:43.874893  / # export SHELL=3D/bin/sh. /lava-10092756/=
environment

    2023-04-23T14:10:43.875790  =


    2023-04-23T14:10:43.977792  / # . /lava-10092756/environment/lava-10092=
756/bin/lava-test-runner /lava-10092756/1

    2023-04-23T14:10:43.979012  =


    2023-04-23T14:10:43.984387  / # /lava-10092756/bin/lava-test-runner /la=
va-10092756/1
 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
imx53-qsrb                   | arm    | lab-pengutronix | gcc-10   | multi_=
v7_defconfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/64453beb0df2cb26922e8603

  Results:     5 PASS, 1 FAIL, 1 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/arm/multi_v7_defconfig/gcc-10/lab-pengutronix/baseline-=
imx53-qsrb.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453beb0df2cb26922e8608
        failing since 86 days (last pass: v5.15.81-121-gcb14018a85f6, first=
 fail: v5.15.90-146-gbf7101723cc0)

    2023-04-23T14:08:36.241481  + set +x
    2023-04-23T14:08:36.241883  [    9.349230] <LAVA_SIGNAL_ENDRUN 0_dmesg =
934815_1.5.2.3.1>
    2023-04-23T14:08:36.348263  / # #
    2023-04-23T14:08:36.449822  export SHELL=3D/bin/sh
    2023-04-23T14:08:36.450299  #
    2023-04-23T14:08:36.551495  / # export SHELL=3D/bin/sh. /lava-934815/en=
vironment
    2023-04-23T14:08:36.551923  =

    2023-04-23T14:08:36.653113  / # . /lava-934815/environment/lava-934815/=
bin/lava-test-runner /lava-934815/1
    2023-04-23T14:08:36.653691  =

    2023-04-23T14:08:36.656637  / # /lava-934815/bin/lava-test-runner /lava=
-934815/1 =

    ... (12 line(s) more)  =

 =



platform                     | arch   | lab             | compiler | defcon=
fig                    | regressions
-----------------------------+--------+-----------------+----------+-------=
-----------------------+------------
lenovo-TPad-C13-Yoga-zork    | x86_64 | lab-collabora   | gcc-10   | x86_64=
_defcon...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/64453c61e68f3818182e8633

  Results:     6 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.105=
-330-g3091741130361/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-colla=
bora/baseline-lenovo-TPad-C13-Yoga-zork.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230414.0/x86/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/64453c61e68f3818182e8638
        failing since 26 days (last pass: v5.15.104-76-g9168fe5021cf1, firs=
t fail: v5.15.104-83-ga131fb06fbdb)

    2023-04-23T14:10:28.674319  <8>[   11.664716] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 10092805_1.4.2.3.1>

    2023-04-23T14:10:28.779293  / # #

    2023-04-23T14:10:28.880285  export SHELL=3D/bin/sh

    2023-04-23T14:10:28.880542  #

    2023-04-23T14:10:28.981495  / # export SHELL=3D/bin/sh. /lava-10092805/=
environment

    2023-04-23T14:10:28.981708  =


    2023-04-23T14:10:29.082613  / # . /lava-10092805/environment/lava-10092=
805/bin/lava-test-runner /lava-10092805/1

    2023-04-23T14:10:29.082946  =


    2023-04-23T14:10:29.087827  / # /lava-10092805/bin/lava-test-runner /la=
va-10092805/1

    2023-04-23T14:10:29.093072  + export 'TESTRUN_ID=3D1_bootrr'
 =

    ... (11 line(s) more)  =

 =20
