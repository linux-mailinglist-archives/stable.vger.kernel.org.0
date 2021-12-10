Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E165C4705CA
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 17:33:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237776AbhLJQhC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 11:37:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237570AbhLJQhC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 11:37:02 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 713BEC061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:33:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 137so8535405pgg.3
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 08:33:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=l5CHR4S1i4dvQTEkMpEmhDmifAPy9Jccjj7ldlYQRCk=;
        b=PZTO6PivlimXq0QETIB2yGOEv+jnOCg7Ce/JT6rWsD4OmmfgUNLxx3ojAtYkP7BvE7
         AgsN5nJjgXe+BX/61uDG3GUjiMfoafXCODuHhGIl0/rmAONjkkZuNxsRNmzEGuoW1R5I
         HI2+1QWAJTXU5anXfxo/e3nas2Fu4pF4Fo+XSxOy7NFw9iGGybF3ciuLeL6DCM20Pnxj
         qK4hwPfvZUSM1dgopNY8/oADInuzXBesD3DkkPV/bXkknqduaRVFpOClQOx/JlB/zezu
         dsBBI0WbTJvuuNQ1qn8aLSBs/2cFODsKn0MoOtY7G83QGUOoTnkWdf2ENh1tBs4g8D73
         njlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=l5CHR4S1i4dvQTEkMpEmhDmifAPy9Jccjj7ldlYQRCk=;
        b=aoAfKK0pVSZm+O8Ak7mdP0FzpgfitAYJkgcvFjYwdSA6DZzl3M0rQ9Slm6J9yBjbqD
         RyRViIKlTHfqKTQJctZmOCMhFjikdE6baD1r7+P9N+UWC3ZpAXngQhiSc1oKg8tJJy58
         2tVpGNABg9gWY7yflKuyoXzjkW0urRmcJkmx4QOk7z2DV6u2B41RRB8ilhr7OA/N9vC7
         RAIy2GcfzSiZjxSXieOrNcq3PvVKRFVfntmt8WYjS4to8Bi/zFM4xG3KOmZxiDpyLIcP
         aQ77Bt0dR7HO+owcvBdlFy4wqb0amwqtrwVV003uevOD9fEsoN2YL55xtMaEPGWuOFDi
         cn+g==
X-Gm-Message-State: AOAM530rk+gHcy1Jd8npraBjNIop2aItMdwnCLU0l1fvzSVa/DryzVn7
        sRKR9BMp8EAqu2eG+GUF6VPiC3b89x9q0Vvq
X-Google-Smtp-Source: ABdhPJz12Z41Y0dVrHBRaGFbyLEoDlcUnYZef1IU7tzA3T56Pf2alMnl/zvUESlL0zUGc66X4a9oMA==
X-Received: by 2002:a05:6a00:10d3:b0:4a4:e516:826f with SMTP id d19-20020a056a0010d300b004a4e516826fmr18994481pfu.70.1639154006780;
        Fri, 10 Dec 2021 08:33:26 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j23sm3197431pgn.40.2021.12.10.08.33.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 08:33:26 -0800 (PST)
Message-ID: <61b38156.1c69fb81.ca4f1.94b0@mx.google.com>
Date:   Fri, 10 Dec 2021 08:33:26 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.19.220
X-Kernelci-Report-Type: test
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 143 runs, 2 regressions (v4.19.220)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 143 runs, 2 regressions (v4.19.220)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.220/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.220
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bcd694e3e7181ddb30e4156df69a2775ce51ed4f =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61b34a67c6f6ecd5b539711f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnowboard-turbot=
-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b34a67c6f6ecd5b5397=
120
        new failure (last pass: v4.19.219-49-g36bf297d8737) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61b3486b9d57b7174b397156

  Results:     5 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
20/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b3486b9d57b71=
74b397159
        failing since 13 days (last pass: v4.19.217-321-g616d1abb62383, fir=
st fail: v4.19.218)
        2 lines

    2021-12-10T12:30:19.095762  <8>[   20.964111] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T12:30:19.138429  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/101
    2021-12-10T12:30:19.148869  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
cfc [emif], .magic: dead4ead, .owner: <none>/-1, .owner_cpu: -1
    2021-12-10T12:30:19.164974  <8>[   21.034759] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
