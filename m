Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C1EB4A32C5
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 01:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346425AbiA3ASc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 19:18:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237062AbiA3ASc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 19:18:32 -0500
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B28FC061714
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 16:18:32 -0800 (PST)
Received: by mail-pf1-x42c.google.com with SMTP id d187so9537985pfa.10
        for <stable@vger.kernel.org>; Sat, 29 Jan 2022 16:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dBAkViy1sh8t8OuKfOCSWPYf+BX3ATC9q1P3JGiJW1c=;
        b=z6FJsyN4igF3CYzUpfVc85vqzucZalEUX/mWzzJsJd8Met/lv+Eu3RLxpVfKMPkAzi
         hIarN/O/0fq2/Or00AmPXnR5y8+xshtQUvT31sdlxireUR1grGM9Pe/r9UsOeYfJzU1B
         Be5+jFJ2R4SOLWFIH32xMR1RER7gscPPMKXZGJ6qeGQRM3lF/O29QEnoP9WZEGz1xE4Q
         VCXMhW050iz389jUL0lY6COQoYZNsYmU6gRmWaBs6L22+Anfa/vDX2aZhAotuW4mZbiW
         1EWN/VRZ01vfFbOJQ0hFEYZlVYIcrmM9UX4cVYbI/4/5lQFQ3+tU6egriI0mURR+ahct
         dEzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dBAkViy1sh8t8OuKfOCSWPYf+BX3ATC9q1P3JGiJW1c=;
        b=nXfMxudowEqJF07/3GwDURVig74HI2BBVbKqA10WWfEl5qRjzr5GvB6stgEBtvQ/jc
         ewjfphEb4bcLUH3JK59P4LFEVciAkqhkRv4kofgqC6+lQ/BwyhdjzeHlC8s1l0VM9xrf
         U4wWATx4mVjZsl+1ioPpvWz52JlOkxLtPkAaPQD6Kc54FhI31hdbnSKIqlOBzKckBT1g
         0gin9ji4VI38TVUOlQejMSnOmSoGgiqcHz2pMn7VzB0MgIMMTBOYAtA52tUtN+bsprbo
         ay2rsrBw0PaTLSHscHbxDZzwniQeDdBtHPKl+oLmtMfjeOBEY63kIWEr09wF01T5j9BU
         T76A==
X-Gm-Message-State: AOAM533jOA7qPaFi+wrgT9ec4Lj3v41GjKBp2zaJw44oRDTcrcIhkJt9
        MPPUXxelQXGrqoeX6X1Kb+QqAzxlrLSgJaS+
X-Google-Smtp-Source: ABdhPJymAl8xuKhFBafs05aaeEYzvzSyEVOFzNoYbtskUZLlLkBa709FrMcvc2ZagKslNG7p0ZHy3Q==
X-Received: by 2002:a63:82c2:: with SMTP id w185mr11764678pgd.570.1643501911516;
        Sat, 29 Jan 2022 16:18:31 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g8sm13579468pfc.193.2022.01.29.16.18.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Jan 2022 16:18:31 -0800 (PST)
Message-ID: <61f5d957.1c69fb81.1be9.3ee8@mx.google.com>
Date:   Sat, 29 Jan 2022 16:18:31 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.95-34-gf70beb0212017
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 143 runs,
 2 regressions (v5.10.95-34-gf70beb0212017)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 143 runs, 2 regressions (v5.10.95-34-gf70beb=
0212017)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.95-34-gf70beb0212017/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.95-34-gf70beb0212017
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f70beb0212017a4589f7955a7cfcc0edd835d9d7 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61f5a25fea37891bd6abbd19

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.95-=
34-gf70beb0212017/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.95-=
34-gf70beb0212017/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220121.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61f5a25fea37891=
bd6abbd20
        new failure (last pass: v5.10.94-7-g5a8d22da189c)
        4 lines

    2022-01-29T20:23:48.733282  kern  :alert : 8<--- cut here ---
    2022-01-29T20:23:48.733563  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2022-01-29T20:23:48.734041  kern  :alert : pgd =3D (ptrval)
    2022-01-29T20:23:48.734700  kern  :alert : [<8>[   39.352285] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2022-01-29T20:23:48.734939  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61f5a25fea37891=
bd6abbd21
        new failure (last pass: v5.10.94-7-g5a8d22da189c)
        26 lines

    2022-01-29T20:23:48.785661  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2022-01-29T20:23:48.785955  kern  :emerg : Process kworker/1:4 (pid: 66=
, stack limit =3D 0x(ptrval))
    2022-01-29T20:23:48.786436  kern  :emerg : Stack: (0xc273beb0 to<8>[   =
39.398461] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2022-01-29T20:23:48.786678   0xc273c000)
    2022-01-29T20:23:48.786901  kern  :emerg : bea0<8>[   39.410034] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1470616_1.5.2.4.1>
    2022-01-29T20:23:48.787146  :                                     1e9b1=
0fe 0f19754f ef7a3540 cec60217   =

 =20
