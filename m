Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36E23457992
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 00:31:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235774AbhKSXeZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 18:34:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235663AbhKSXeZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 18:34:25 -0500
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3FA4C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 15:31:22 -0800 (PST)
Received: by mail-pj1-x1029.google.com with SMTP id n15-20020a17090a160f00b001a75089daa3so12089498pja.1
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 15:31:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ZnPVwAeRBLsYOGRXLe5Jd0k+Xuy9tFEAjqxKr+ZKu+M=;
        b=tsJAAK8jnTeFsCEfTE+4tV9ZwTuxSGUSuaB80Jat5prei0MMwyLJ9X79EyqlfVd95J
         T7LqAu6Ekkbec8zLBa5NTFVnbmHzVCwSyicbLIQF88Q/6U17/KovtFx8JL05OVlcAhEp
         vJFpU3YMym4ddNURRMuiJQUbAnIexSP8t9uAFRYHRzhhpgyRtRAuZZxefLaSPQ8QVA2E
         GeOH+hrgFGosc039u8LFeVp71icRb1yArIG8nZQC+mmd+wZ/B07z0J6SnOTYqKhIFbBa
         0uyKMvWB0MEh54Ah+MsE6jdl4Q+p0o3LwiKxkuv72VtXZDxHE1hbIkGfj0D1pJSmDKkA
         7PhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ZnPVwAeRBLsYOGRXLe5Jd0k+Xuy9tFEAjqxKr+ZKu+M=;
        b=extwyPYRLyn6JBnMupUfP6+3xKqajyG5h62yPBsr/z/uRJU4PMp/KP3fQ3e1VWrt6Y
         J5AzOOySNaYPsYGyin/7/uMoD+E6qS8nYOcj8R7A1/sn4dnoovgdta0XqiCrntvz2ovo
         CJxRFOqnKOvMg/nInyrVk79EPK3mOA3LAFzluFadUQ67YREDoLkbwhBki9Zp1UZS2UjE
         jkNtDEsiNB06rlYUCaKE5CquSOvDUdMhXp5MlMEgHBnF7bEd8WN31GBJVUq/DhPhaN0Y
         5UVZ3PJ3p60q88FiFl9T+jadRKMHjaEEP4o6xaBlmQO64ZZpq60+pTWZq2LNKpuoDuWa
         pAPA==
X-Gm-Message-State: AOAM531jMBR03AzNbautDdqq/8SYeX6HyV9eS1XrMe9qpXP69VFGZt3i
        PoQnaiFNdHBKZYDmOqlfK+2Od4+7/nVOGKIk
X-Google-Smtp-Source: ABdhPJxmofHPdAtagdzINrFjJexgcxl0gVw/2W9p+8ZV49j9qVCSy8TmyOHbGBxNrUc6QRGE6EEbVA==
X-Received: by 2002:a17:902:d50d:b0:141:ea03:5193 with SMTP id b13-20020a170902d50d00b00141ea035193mr81548222plg.89.1637364682138;
        Fri, 19 Nov 2021 15:31:22 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f18sm12257pfk.105.2021.11.19.15.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 15:31:21 -0800 (PST)
Message-ID: <619833c9.1c69fb81.18838.011e@mx.google.com>
Date:   Fri, 19 Nov 2021 15:31:21 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.80-21-g589fe774e1838
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 135 runs,
 2 regressions (v5.10.80-21-g589fe774e1838)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 135 runs, 2 regressions (v5.10.80-21-g589fe7=
74e1838)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.80-21-g589fe774e1838/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.80-21-g589fe774e1838
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      589fe774e18380a49f30c3e51b2f82c909a0126b =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-10   | multi_v7_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/6197fdbeab8d1191bee551fe

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.80-=
21-g589fe774e1838/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.80-=
21-g589fe774e1838/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-imx6q=
-var-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/6197fdbeab8d119=
1bee55205
        new failure (last pass: v5.10.79-570-gb8a534d0c374)
        4 lines

    2021-11-19T19:40:20.073542  kern  :alert : 8<--- cut here ---
    2021-11-19T19:40:20.074053  kern  :alert : Unhandled fault: alignment e=
xception (0x001) at 0xcec60217
    2021-11-19T19:40:20.074297  kern  :alert : pgd =3D (ptrval)
    2021-11-19T19:40:20.075016  kern  :alert : [<8>[   42.582413] <LAVA_SIG=
NAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=
=3D4>
    2021-11-19T19:40:20.075258  cec60217] *pgd=3D1ec1141e(bad)   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/6197fdbeab8d119=
1bee55206
        new failure (last pass: v5.10.79-570-gb8a534d0c374)
        26 lines

    2021-11-19T19:40:20.125891  kern  :emerg : Internal error: : 1 [#1] SMP=
 ARM
    2021-11-19T19:40:20.126396  kern  :emerg : Process kworker/1:5 (pid: 67=
, stack limit =3D 0x(ptrval))
    2021-11-19T19:40:20.126639  kern  :emerg : Stack: (0xc273beb0 to<8>[   =
42.628451] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D26>
    2021-11-19T19:40:20.126865   0xc273c000)
    2021-11-19T19:40:20.127096  kern  :emerg : bea0<8>[   42.640106] <LAVA_=
SIGNAL_ENDRUN 0_dmesg 1111432_1.5.2.4.1>   =

 =20
