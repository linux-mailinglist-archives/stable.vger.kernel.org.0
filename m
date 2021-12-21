Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6EDC47B686
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 01:44:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231355AbhLUAoX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 19:44:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231254AbhLUAoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 19:44:23 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CBF1C061574
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 16:44:23 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id b22so5400302pfb.5
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 16:44:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JxjiNM9u2uwyhLiP1zEQyWBsxOqLARbua7GfOkQa+sk=;
        b=rlr09+a75/TV73Ug1DBsXcfBiT4xdcykh1/OyjA/+aoQtNZhxmqYb3dyk6plAxtC+W
         QJzMQH7N3LeDRFwI3QZj2Q2EzezYM9XONDUFrHGU9KfyjNeY6lApspHormaHg5QBjynE
         8lPXWy6mrnliKjaurgMOqzUHydE6OgubsHzb+MY7VkmOedsslmnBJI6x0b8BzYgTl83I
         oVnTScjb+zWwr3aONHZnAffpNnyswWBsoBT/dkBmaaOgc+EOC5ED3QzeFf+pXFcwBKY6
         G1q8r2AaMhsoaXCrC/bEizG1NSVc92Bi49FEJQSakkaUduJtKpyVEfHnj3SnCIl8NepE
         kerA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JxjiNM9u2uwyhLiP1zEQyWBsxOqLARbua7GfOkQa+sk=;
        b=GAFD/k5zH8ZGPgYoPB4DsLBD8uzEYGrTfWGXvNaX9yEOaQkOelIuG2jKCaYtjuFwkB
         z/f8+XHaLCWg1oliZpbzH88bQBLYVDeLY5l/3xjcQPYKXFdGXSfLZtjoulxC2NnEZ7t2
         LO5rnPGAETt3H0mKmNvkHCe6cpJ1irEcxHiZY4ezfDkNPceZw6/gJi8Hq6uPgbDav6DW
         XPOW12yCJWSoaNWUCSD1umqsOOyLs67SKeJaolaS6teBVnIxji2W3MO6SFkBLcqTYuap
         cRPPEMNLdAdQby2oHmYcPdyh0fa8a+c08Sk5DcJ5w1CuziI2M3LE5a0aXsW2sSO/oJPn
         6RFw==
X-Gm-Message-State: AOAM533WjD0yXeM8m+FFM0pnXVKUgGKK80FhF4T8wxQvkGypWzEtftR1
        TaesEK2Zyh15DQBpTDHZ/dLQ9ap5njlJ1umk
X-Google-Smtp-Source: ABdhPJxS+wCC4CP+E8w1zLNSZRqPaR4K+95/tefpUsD3O7M5FKXK4y6nU1Da1LxeD+Ey2lf1lM6E/g==
X-Received: by 2002:a63:ab0d:: with SMTP id p13mr620698pgf.570.1640047462724;
        Mon, 20 Dec 2021 16:44:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s3sm8913993pfm.0.2021.12.20.16.44.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 16:44:22 -0800 (PST)
Message-ID: <61c12366.1c69fb81.a1433.96ea@mx.google.com>
Date:   Mon, 20 Dec 2021 16:44:22 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-45-g86b521e57e04
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 137 runs,
 2 regressions (v4.14.258-45-g86b521e57e04)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 137 runs, 2 regressions (v4.14.258-45-g86b52=
1e57e04)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.258-45-g86b521e57e04/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-45-g86b521e57e04
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      86b521e57e04297ee4cc68a8a01f53fbd7fa22bb =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0e9c91665ff7453397161

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-45-g86b521e57e04/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-45-g86b521e57e04/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61c0e9c91665ff7453397=
162
        failing since 1 day (last pass: v4.14.258-16-g61a721b2d716, first f=
ail: v4.14.258-24-g5205a2d8fc35) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61c0e9f971188afea2397147

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-45-g86b521e57e04/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-45-g86b521e57e04/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61c0e9f971188af=
ea239714a
        new failure (last pass: v4.14.258-24-g6a08d661000f)
        2 lines

    2021-12-20T20:39:15.040146  [   20.153320] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-20T20:39:15.082836  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/105
    2021-12-20T20:39:15.092202  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
