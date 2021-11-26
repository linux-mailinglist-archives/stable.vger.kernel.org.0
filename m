Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA2445F6A6
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 22:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230514AbhKZVyw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 16:54:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232110AbhKZVww (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 16:52:52 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B2C061748
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 13:49:38 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id y7so7497354plp.0
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 13:49:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=EVuVcBlr5taOyrG/XFXFBELRrrAEeYKMtYMUM7YbvUg=;
        b=A7oxIXiRA2Oh1Iz2EVcaPoZchdbSQdZsEvLtUYPpTy49ATTJBNOVbZDkEY0xPyosCd
         HRR+midQBKoPOomw9mvUEyZ6y6ewlhCH8bannox2xejr1M3x+3nKDVcV8zUYlrEJMwlz
         X1PWlMX08L7M90a70405bPBWfoLUv52OJlrdroKPEXcWkALX+cm11uXadsbEZHGJhOpO
         D+dqbGC/Clrdw+YGFmTA5ROHQcEcQ1ff8pmLs6Vb+Etnb+GlqD8kbEadMpQ+gAfwFal8
         YR3M5VEQqZqJwMfWDR/fZlBtMGji7/JATGWYBiNmgcTxbJ3hzxmaU0GnhCq+DZ7qswG0
         GC6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=EVuVcBlr5taOyrG/XFXFBELRrrAEeYKMtYMUM7YbvUg=;
        b=ESmI//ufPu43eDr92cQkuoV9/AHKPoLoZXeiRw2CCtHRRZAdOMg2jUDzSxWzi3XW8A
         gJOH0YJ2aagNAEczAm0MhYYAyH+Ne3MNUFB0fFf35BEEEEHCJ2pA3PawvUEVurSt9R2u
         Yg9MNzrDSyQ0N5TLW1Q4toRnEFap/WJoJO6DWO+jlOIt3d+HhyatqmyLAME0UwR+mLqb
         inpoGCuiKR/HAGxj+Yh4X5Em8HPmWLfbezHedDrbW6ITZ0xrWiblV7btccR3lMstPNxX
         NQu53nirobDXG/LAhfXjcRRvaFXn0rXRoto+MFRSYFe7K4pcqn0bCXGiv84E9/0JVYJN
         8a4g==
X-Gm-Message-State: AOAM530ECncITajDlh/qESGp51jRHWXYu+QX0VNi+BqtfyEbU+IdLSKy
        8RymkLlnO9vx7BxyX7R3zxEF5ZFjTQsSNXb5
X-Google-Smtp-Source: ABdhPJxbYvZWfBLu+ANP4ThUEdYR3CDctPnsiuLdeydS1hHBk8bXcUwLmzn3IF0I6tcvnP6nlCa5bA==
X-Received: by 2002:a17:90a:3d42:: with SMTP id o2mr19029920pjf.150.1637963378259;
        Fri, 26 Nov 2021 13:49:38 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j22sm8379509pfj.130.2021.11.26.13.49.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 13:49:37 -0800 (PST)
Message-ID: <61a15671.1c69fb81.27ed1.719a@mx.google.com>
Date:   Fri, 26 Nov 2021 13:49:37 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.82
Subject: stable/linux-5.10.y baseline: 170 runs, 2 regressions (v5.10.82)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.10.y baseline: 170 runs, 2 regressions (v5.10.82)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.10.y/kernel=
/v5.10.82/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.10.y
  Describe: v5.10.82
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d5259a9ba6993a843278203323902bc0c049097e =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/61a11d9a0ef0e9e7da18f6d3

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.10.y/v5.10.82/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.10.y/v5.10.82/a=
rm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q-var-dt6customboard=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61a11d9a0ef0e9e=
7da18f6da
        failing since 5 days (last pass: v5.10.80, first fail: v5.10.81)
        4 lines

    2021-11-26T17:46:51.309429  kern  :alert : 8<--- cut here ---
    2021-11-26T17:46:51.310065  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-11-26T17:46:51.310307  kern  :alert : pgd =3D 71f88943
    2021-11-26T17:46:51.310795  kern  :alert : [<8>[   15.200593] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-11-26T17:46:51.311043  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61a11d9a0ef0e9e=
7da18f6db
        failing since 5 days (last pass: v5.10.80, first fail: v5.10.81)
        26 lines

    2021-11-26T17:46:51.362238  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-11-26T17:46:51.362749  kern  :emerg : Process kworker/2:5 (pid: 88=
, stack limit =3D 0x251b4eb8)
    2021-11-26T17:46:51.363005  kern  :emerg : Stack: (0xc3613eb0 to<8>[   =
15.247256] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-11-26T17:46:51.363231   0xc3614000)
    2021-11-26T17:46:51.363444  kern  :emerg : 3ea0<8>[   15.258736] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1149820_1.5.2.4.1>   =

 =20
