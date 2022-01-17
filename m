Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D8B28490C8A
	for <lists+stable@lfdr.de>; Mon, 17 Jan 2022 17:34:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240877AbiAQQeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 11:34:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235274AbiAQQeg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 11:34:36 -0500
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AB92C061574
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 08:34:36 -0800 (PST)
Received: by mail-pf1-x42f.google.com with SMTP id a5so10643126pfo.5
        for <stable@vger.kernel.org>; Mon, 17 Jan 2022 08:34:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=TcoPpQ/zUEjvchpBmQD6WcEK7wYv5Ea1Fd9KMl841iY=;
        b=sy40hM+UZyRoLuPAIr5zHdULMKg5QX/wAkR4qaI+77ZsTlL9J8DQUTgmqTWPMBalwJ
         HiSIfuu038aAtQQKe8dkroOGpdQmmsTjauGr+NWKMDR1IlpMqWgyOSiATyGGmFQ5+ycO
         Z9pjtQZmSOiybtS/N/WpbdpZNA/+6kinW3/o5ULwrU4hoOfx+wRl4w5X1I6HGADkJaqU
         EHQ2qqkqe6cLksCTQb8i5dOkI5wgGXUuJl5TdZ0/t+2qiud3WdG19CQAdgTlo+W5nyby
         FQIVr2UtZkmuj4KM7Q0t+pK1Zd2m4F+V1ZPw92C+g3bhPvWTCNkO2Kj7Kc0JdqOuYr7y
         2MGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=TcoPpQ/zUEjvchpBmQD6WcEK7wYv5Ea1Fd9KMl841iY=;
        b=4p+qzXD1uwQ0CFkO1dPwb/Xc79+H+/W/wu4WIZ8K+IOyEGvVC1ULTjp2V/C7mlDH94
         dzHnviSOHqDRP+cgCl+Kbc1Nj/Zwq+53pwbKvceTEvSecs3pY8em5pykLjWni9K3qjmY
         pN95oXlMeFP0hAUZ2EqIbxqlzLINvBmi00i4AoI+xCxr5yL/r/Am2HTWCRAR5jsHgSzq
         dmdBTuZUyVVsaAW3x4fTXW+TjC7GRgaTWCCd9bSLSSXrDULJzmcel+7h/by8UizYlcd5
         TZ/DcWwkPFXUzoWEJt3CeKDsZ6DgWuCkXsIaw7YsgTjRh6dFN+hbZ9EjYBYiK6CgzrCx
         S1rA==
X-Gm-Message-State: AOAM531CFf3PhWG4FgBauKrbe4KoQwouj+1qy3gpCwGeVJMqEUCOLlYH
        4icGH0Pm4sojFYXiwpMdpKSeo6/FR8pGzo+B
X-Google-Smtp-Source: ABdhPJxIVbLkUWUCgS7iDq1epL3djBF5hDpwYVMA0ffp8+fsjw/UJA45vTDikqJkD8sNa3WjeRKk3A==
X-Received: by 2002:a63:8842:: with SMTP id l63mr16381576pgd.180.1642437275690;
        Mon, 17 Jan 2022 08:34:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u20sm15226850pfg.105.2022.01.17.08.34.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jan 2022 08:34:35 -0800 (PST)
Message-ID: <61e59a9b.1c69fb81.3e437.86ac@mx.google.com>
Date:   Mon, 17 Jan 2022 08:34:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.15.14-42-gf775278b8bfb
X-Kernelci-Branch: queue/5.15
Subject: stable-rc/queue/5.15 baseline: 184 runs,
 2 regressions (v5.15.14-42-gf775278b8bfb)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 184 runs, 2 regressions (v5.15.14-42-gf77527=
8b8bfb)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.14-42-gf775278b8bfb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.14-42-gf775278b8bfb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f775278b8bfbc6717de46393e2f2f697687d3ed0 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-g12b-odroid-n2 | arm64 | lab-baylibre | gcc-10   | defconfig | 2     =
     =


  Details:     https://kernelci.org/test/plan/id/61e5636f25c64576b4ef673d

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
42-gf775278b8bfb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.14-=
42-gf775278b8bfb/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-g12b-od=
roid-n2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/arm64/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/61e5636f25c6457=
6b4ef6741
        new failure (last pass: v5.15.14-40-gade5287c90b8)
        12 lines

    2022-01-17T12:38:43.256658  kern  :alert : Mem abort inf<8>[   15.36117=
8] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines M=
EASUREMENT=3D12>
    2022-01-17T12:38:43.257011  o:   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61e5636f25c6457=
6b4ef6742
        new failure (last pass: v5.15.14-40-gade5287c90b8)
        2 lines

    2022-01-17T12:38:43.258191  kern  :alert :   ESR =3D 0x96000006
    2022-01-17T12:38:43.258392  kern  :alert :   EC =3D 0x25: DABT (current=
 EL), IL =3D 32 bits
    2022-01-17T12:38:43.258566  kern  :alert :   SET =3D 0, FnV =3D 0
    2022-01-17T12:38:43.258732  kern  :alert :   EA =3D 0, S1PTW =3D 0
    2022-01-17T12:38:43.258893  kern  :alert :   FSC<8>[   15.386241] <LAVA=
_SIGNAL_TESTCASE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREME=
NT=3D2>
    2022-01-17T12:38:43.259054   =3D 0x06: l<8>[   15.395647] <LAVA_SIGNAL_=
ENDRUN 0_dmesg 1410311_1.5.2.4.1>   =

 =20
