Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F29847B6D3
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:27:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbhLUB1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:27:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229596AbhLUB1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:27:20 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B94C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 17:27:19 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id j6-20020a17090a588600b001a78a5ce46aso964955pji.0
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 17:27:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=DpQvxFbbZ+LJ6guBu/igTIyz7PrA3zNx+8MlXMHRFsE=;
        b=kIT6PfHnMAtWauHr0UPiR4eCCzmYQ9Wj4LAn9onNvgVuY8HL0OsHYRBS9HvEYe82cl
         8Z0BDYt3L6Q59OblC4VgQiJNEwpkWNcDnrmdCTkHxL5ulBl/BtDKEjfF5PlhvQo1PAYs
         +Q5q9Z8YZP7FEtEn198zg72lHD0r7qpyJhDNjRHXf6I84V2f8t4t9OTLBfGU2copfEkK
         b1d/mRJsu/qRgdyjCLIGyerxp5IMACrRxs5Jnb2reah9IwuJzSIpscod3WOf+4fZCOZj
         3TITjtBBVj2RbzWl2Dho6njyanBXJM6oG37RJb1+F+sIYTfrsL6eZ6DQ7yQ31CAwwlGm
         tD7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=DpQvxFbbZ+LJ6guBu/igTIyz7PrA3zNx+8MlXMHRFsE=;
        b=F4hQNWP5DDcDi4tpzl9U5VAkLS/KWVreY0bODti0qAkQDyZ0eVG0cJCgbtmi3b8ETT
         Dzql7PjNKCCmALyX0SHUUPcG+0zh+eKHseH1oyumhVzkxArnuT3H5iV8AmGiFGreyzpE
         Lctygmz4M4JG/prDEINh0sUDLPyEQmxh720D7Aw/oNrPdF3PfABukaNfmqj4aNqZx7LF
         r49oe4AJU9GjPaEPPNP5EKTX0kvW3DV4D0ewdw54+dYDeVOArHfNn8dtfnan0G8UucOy
         GE6s/8LJdmU8WNzLC08DdPNXo54rMfupTNmwxKWS0XsB3DtCIJsEbvljleyNQvWdot8Y
         a1Eg==
X-Gm-Message-State: AOAM532WZmPbxs9ApNEv9rCEw8cEKNXqT391v0XG9hZHAwBgXd/dUWKz
        mEdFiVDzAuTZxq5gNExjYwQKPRDCgryoZnBY
X-Google-Smtp-Source: ABdhPJx0ZuQubpciMvETEpYjoC/xIzZoZ8lkV2/mYtQx3pK1P65xanwYVXrpq5hllvo4uJQ2JYmtYg==
X-Received: by 2002:a17:90a:46c9:: with SMTP id x9mr1116067pjg.183.1640050039262;
        Mon, 20 Dec 2021 17:27:19 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10sm16703154pfj.51.2021.12.20.17.27.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 17:27:18 -0800 (PST)
Message-ID: <61c12d76.1c69fb81.472db.e612@mx.google.com>
Date:   Mon, 20 Dec 2021 17:27:18 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.87-99-gf1842ac43117
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.10
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 191 runs,
 3 regressions (v5.10.87-99-gf1842ac43117)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 191 runs, 3 regressions (v5.10.87-99-gf1842a=
c43117)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 2          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.87-99-gf1842ac43117/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.87-99-gf1842ac43117
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f1842ac43117983b139594843c38fd999986295a =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
imx6q-var-dt6customboard | arm    | lab-baylibre  | gcc-10   | multi_v7_def=
config           | 2          =


  Details:     https://kernelci.org/test/plan/id/61c0f532716bee2bd9397132

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
99-gf1842ac43117/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
99-gf1842ac43117/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-=
var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61c0f532716bee2=
bd9397136
        new failure (last pass: v5.10.87-66-g2eb0aa8b2e00)
        4 lines

    2021-12-20T21:26:45.744711  kern  :alert : 8<--- cut here ---
    2021-12-20T21:26:45.775777  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-12-20T21:26:45.776953  kern  :alert : pgd =3D (ptrval)<8>[   45.80=
7951] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-12-20T21:26:45.777222  =

    2021-12-20T21:26:45.777456  kern  :alert : [00000313] *pgd=3D491cd831   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c0f532716bee2=
bd9397137
        new failure (last pass: v5.10.87-66-g2eb0aa8b2e00)
        52 lines

    2021-12-20T21:26:45.828994  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-12-20T21:26:45.829508  kern  :emerg : Process udevd (pid: 141, sta=
ck limit =3D 0x(ptrval))
    2021-12-20T21:26:45.829752  kern  :emerg : Stack: (0xc3bc7cd8 to 0xc3bc=
8000)
    2021-12-20T21:26:45.829979  kern  :emerg : 7cc0:                       =
                                c3a0fdb0 c3a0fdb4
    2021-12-20T21:26:45.830200  kern  :emerg : 7ce0: c3a0fc00 c3a0fc00 c144=
5b68 c09e3974 c3bc6000 c1445b68 0000000c c3a0fc00
    2021-12-20T21:26:45.830880  kern  :emerg : 7d00: 000002f3 c3a0f400 c200=
1a80 ef86c180 c09f10dc c1445b68 0000000c c3289c40
    2021-12-20T21:26:45.871993  kern  :emerg : 7d20: c19c7a10 5f6f728e 0000=
0001 c3ad1940 c3ad0100 c3a0fc00 c3a0fc14 c1445b68
    2021-12-20T21:26:45.872510  kern  :emerg : 7d40: 0000000c c3289c40 c19c=
7a10 c09f10b0 c144388c 00000000 c3a0fc00 fffffdfb
    2021-12-20T21:26:45.872755  kern  :emerg : 7d60: bf048000 c22d8c10 0000=
0120 c09c7090 c3a0fc00 bf044120 c3a43680 c32d9108
    2021-12-20T21:26:45.872983  kern  :emerg : 7d80: c3a41600 c19c7a2c 0000=
0120 c0a23a80 c3acefc0 c3acefc0 c2232c00 c3a41600 =

    ... (37 line(s) more)  =

 =



platform                 | arch   | lab           | compiler | defconfig   =
                 | regressions
-------------------------+--------+---------------+----------+-------------=
-----------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
n...6-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0f1bbb5c53ff65e39712e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
99-gf1842ac43117/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.87-=
99-gf1842ac43117/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-collabor=
a/baseline-minnowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0f1bbb5c53ff65e397=
12f
        new failure (last pass: v5.10.87-62-gec26c797e6cc) =

 =20
