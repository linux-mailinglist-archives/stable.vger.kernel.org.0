Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D33147518C
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 05:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbhLOEDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Dec 2021 23:03:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235674AbhLOEDd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Dec 2021 23:03:33 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9ABC061574
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 20:03:33 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id k6-20020a17090a7f0600b001ad9d73b20bso17949602pjl.3
        for <stable@vger.kernel.org>; Tue, 14 Dec 2021 20:03:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=Nx70cCYOR89A3TcciZ1ryU5AGmmC2NDLk5Agmh7GkbE=;
        b=pBZJvtg8JezdJoecEqNNM6i9uG4kcA/HZvGyWjpGHiR7vh8JmyRVuxsxMOO+xLArYL
         nMYjOaZA2bMMl9Vq3KLJduYzGrZfIEL20uAGPXZ2Q/GFKyk3v8i6l2N6S0t+yysTO87L
         f+P9wBBwyR26kraHZM5JwBUnDcXGrM2HEoWMvpcYTHkRwo613hSafOf+kIqjAhwjPsNb
         JvF7aSBYOKXLE2hZBmOq9DU5qroIbmO0U+ELoxUDA67YWOr9gKDmxVYbj7e4PYTrWBHN
         CuW7yQuIFfOql2SDIZC9g57WnXZJSfCW8NFdiDBkmJnZ392sG/QPbht+vP75GTA6rVYs
         sWrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=Nx70cCYOR89A3TcciZ1ryU5AGmmC2NDLk5Agmh7GkbE=;
        b=ehnczoEbU98rQyI8NycDxqehvMHgta3L9+CsWD9fugZx2L2+lpR58gNzMBH1V+NCRF
         ntuMv8WB9S9TGquFpjXL0GvfydGe6W5Yr5mxx6HqYisthjSj++u3uEDjDe61/e0K+2Ur
         SVqUK/FZhC0JXZBuNPzxWdyW4C7mhjuCrC57CaNFPdhcXOl2/ATUEHa/03bOI1nez0m4
         z/gH6XmLWvyLkHBUnI5pgpOI9qKPr62OMx1Vfx5B+H9AKAM98/o8C+JSTpev1QZFKcIE
         6WTQZ/1VwP2/GC2NXJ52lz9X5JPavWnkbn0shHIyDFZTdpK5AN8Zth43kKpWdQrVr4rF
         DDoA==
X-Gm-Message-State: AOAM533w6Ubx6xYZOlmfvSXVq7X22teMWNxGvh1ZLOUHaiASkpRdk7mY
        ULiVepMfRSwEOQ/r+AyeHrHKbllCltixOWlN
X-Google-Smtp-Source: ABdhPJwSvCoJTNU3obWSk+I26bk/Y5kToyYLzAiwn6UajZHopGeragBEdA67LFKxS/oWm5pjKDdpvg==
X-Received: by 2002:a17:902:e887:b0:148:a2e7:fb32 with SMTP id w7-20020a170902e88700b00148a2e7fb32mr2671852plg.115.1639541012851;
        Tue, 14 Dec 2021 20:03:32 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b18sm560704pfl.121.2021.12.14.20.03.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 20:03:32 -0800 (PST)
Message-ID: <61b96914.1c69fb81.bee86.284c@mx.google.com>
Date:   Tue, 14 Dec 2021 20:03:32 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.85-1-g8f1fe98f60cd
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 180 runs,
 5 regressions (v5.10.85-1-g8f1fe98f60cd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 180 runs, 5 regressions (v5.10.85-1-g8f1fe98=
f60cd)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 2          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =

r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.85-1-g8f1fe98f60cd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.85-1-g8f1fe98f60cd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f1fe98f60cd116cb105cf343e94642f2fe6af24 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 2          =


  Details:     https://kernelci.org/test/plan/id/61b9336b739308c54839717f

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61b9336b739308c=
548397183
        new failure (last pass: v5.10.84-132-g7154d0f70682)
        4 lines

    2021-12-15T00:14:11.274425  kern  :alert : 8<--- cut here ---
    2021-12-15T00:14:11.305587  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-12-15T00:14:11.306773  kern  :alert : pgd =3D (ptrval)<8>[   11.67=
7160] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-12-15T00:14:11.307047  =

    2021-12-15T00:14:11.307274  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b9336b739308c=
548397184
        new failure (last pass: v5.10.84-132-g7154d0f70682)
        46 lines

    2021-12-15T00:14:11.364356  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-12-15T00:14:11.364859  kern  :emerg : Process kworker/0:1 (pid: 29=
, stack limit =3D 0x17228938)
    2021-12-15T00:14:11.365096  kern  :emerg : Stack: (0xc223bd68 to 0xc223=
c000)
    2021-12-15T00:14:11.365314  kern  :emerg : bd60:                   c3bf=
f9b0 c3bff9b4 c3bff800 c3bff800 c1445b68 c09e3944
    2021-12-15T00:14:11.365527  kern  :emerg : bd80: c223a000 c1445b68 0000=
000c c3bff800 000002f3 c3bff400 c2001a80 ef86ff80
    2021-12-15T00:14:11.365974  kern  :emerg : bda0: c09f10ac c1445b68 0000=
000c c228da40 c19c7a10 fafa92da 00000001 c3cc7d80
    2021-12-15T00:14:11.407360  kern  :emerg : bdc0: c3a9af00 c3bff800 c3bf=
f814 c1445b68 0000000c c228da40 c19c7a10 c09f1080
    2021-12-15T00:14:11.407888  kern  :emerg : bde0: c144388c 00000000 c3bf=
f800 fffffdfb bf048000 c22d8c10 00000120 c09c7060
    2021-12-15T00:14:11.408126  kern  :emerg : be00: c3bff800 bf044120 c3ca=
66c0 c3326708 c39fe140 c19c7a2c 00000120 c0a23a50
    2021-12-15T00:14:11.408347  kern  :emerg : be20: c3ca66c0 c3ca66c0 c223=
2c00 c39fe140 00000000 c3ca66c0 c19c7a24 bf1520a8 =

    ... (36 line(s) more)  =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig             | 1          =


  Details:     https://kernelci.org/test/plan/id/61b9302916804035d639712a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minno=
wboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b9302916804035d6397=
12b
        new failure (last pass: v5.10.84-132-g7154d0f70682) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b933392b65c9b70d3971d4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabora=
/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b933392b65c9b70d397=
1d5
        failing since 0 day (last pass: v5.10.84-132-g4821c82036b6, first f=
ail: v5.10.84-132-g7154d0f70682) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
r8a77950-salvator-x      | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook   | 1          =


  Details:     https://kernelci.org/test/plan/id/61b934f2e2241006d5397182

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-r8a77950-salvator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.85-=
1-g8f1fe98f60cd/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baseli=
ne-r8a77950-salvator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b934f2e2241006d5397=
183
        new failure (last pass: v5.10.84-132-g7154d0f70682) =

 =20
