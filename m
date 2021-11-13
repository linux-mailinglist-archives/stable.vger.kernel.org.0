Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF0D744F551
	for <lists+stable@lfdr.de>; Sat, 13 Nov 2021 21:49:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233692AbhKMUwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Nov 2021 15:52:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232203AbhKMUwn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Nov 2021 15:52:43 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 779C5C061766
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 12:49:50 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id x7so9500572pjn.0
        for <stable@vger.kernel.org>; Sat, 13 Nov 2021 12:49:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=J4k5XOJ2g+2y5yEMc148VdhS8g4XwFDTMdSgUUa9drQ=;
        b=qzik/onB8+hOcVyzl+X3DpFaVvEu4tWKMZ9KHD0Kij10AccXG+ZQNNPAt3pgJG7SPR
         MiFW9tv60vwScrnr0cQITc3edUzNBEv5DjBK+wqwz5M4CcqyAfL7mocka9g6ycg8IBdw
         AYvj4MKBRG5HNj+5dR/KlLhZwU3bAuj0yIOFwt+JG6062o39co/Z9/4Jb4nAzRpEhaMs
         3yb1LLECGgGxhfIYbxXpr94q9ouddExtnDB7hWEQtlcrGtQMfgbbcP1WpvFQguPiauYk
         HtHLmeUK6n9QMaEkGwIyjNRVOdbKGOfGJ3DikX0uqEYMGmWjniPZrE+fcs2F2vIHJ4Vn
         GOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=J4k5XOJ2g+2y5yEMc148VdhS8g4XwFDTMdSgUUa9drQ=;
        b=BMvnPD//2/fsMHvAG2eoVVH9yhEtEy7Otztd5CegjmXOFYapp7BC5bAPVhYfoD/qnT
         1iwEb38hi0IaAm2eyjq3+DzrIKmqa0oWEI04z+Kf0FGV1bCui8adCpgDra4w/h2eixao
         2ZReQNJlh2ybcIcXRQITgHHCX0UJv6o3cTizNrnQg+JAf0Q49ezFvzvfNC2IpcoTucLA
         zy+0+XfcEQXyAemyKLvAALUxrp0VaHtMlZFq3ozd7t94zYrMq/la9ZQPC+ThUtO49KkU
         2CvxXf4hXIsV9RrnpHpoji/lFhTTgfCGbUnmR/oq+heWbY9MGj8V/NkqGJE4taNg0z44
         HmXQ==
X-Gm-Message-State: AOAM531LrDvJYTLA/+lyoA+vNBTcnyVA7BNSyTlI8BMgscjgQWHQKfOq
        BMVGD4Alk5/U11PZnTkPM8Wkysyk5FibQEJa
X-Google-Smtp-Source: ABdhPJwwk4nprykYe59nZe/U0liHgg6BiaTmBIOksShFHwJM+0ugky9FwUbCIINnvB+lujZygHncqw==
X-Received: by 2002:a17:90a:cf85:: with SMTP id i5mr49263909pju.101.1636836589846;
        Sat, 13 Nov 2021 12:49:49 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p14sm8577121pjl.32.2021.11.13.12.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 13 Nov 2021 12:49:49 -0800 (PST)
Message-ID: <619024ed.1c69fb81.2802a.8852@mx.google.com>
Date:   Sat, 13 Nov 2021 12:49:49 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v4.19.217-69-g555fb1420e496
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 181 runs,
 2 regressions (v4.19.217-69-g555fb1420e496)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 181 runs, 2 regressions (v4.19.217-69-g555fb=
1420e496)

Regressions Summary
-------------------

platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =

qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.217-69-g555fb1420e496/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.217-69-g555fb1420e496
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      555fb1420e4963b3a017b4235e71deb230c3249e =



Test Regressions
---------------- =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
panda       | arm    | lab-collabora | gcc-10   | omap2plus_defconfig      =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/618feb06267bf05d2a3358ec

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-69-g555fb1420e496/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-69-g555fb1420e496/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pa=
nda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/618feb06267bf05=
d2a3358ef
        new failure (last pass: v4.19.217-64-gdd35bbb818618)
        2 lines

    2021-11-13T16:42:29.845956  <8>[   21.269317] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-11-13T16:42:29.896540  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/102
    2021-11-13T16:42:29.905998  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =



platform    | arch   | lab           | compiler | defconfig                =
    | regressions
------------+--------+---------------+----------+--------------------------=
----+------------
qemu_x86_64 | x86_64 | lab-broonie   | gcc-10   | x86_64_defcon...6-chromeb=
ook | 1          =


  Details:     https://kernelci.org/test/plan/id/618fe94bf56756a38c335913

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig+x86-chromebook
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-69-g555fb1420e496/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.217=
-69-g555fb1420e496/x86_64/x86_64_defconfig+x86-chromebook/gcc-10/lab-brooni=
e/baseline-qemu_x86_64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618fe94bf56756a38c335=
914
        new failure (last pass: v4.19.217-64-gdd35bbb818618) =

 =20
