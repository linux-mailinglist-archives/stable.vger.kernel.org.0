Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 051C732740D
	for <lists+stable@lfdr.de>; Sun, 28 Feb 2021 20:22:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbhB1TVu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Feb 2021 14:21:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231207AbhB1TVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Feb 2021 14:21:50 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A59C06174A
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 11:21:10 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id a23so303648pga.8
        for <stable@vger.kernel.org>; Sun, 28 Feb 2021 11:21:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hRER8zldJAAIMr6Re3Nn4orTwkJhjR0IK/FMbFQjBpU=;
        b=HeFVbhXX55gfuuh2UY34HCzoDfZrFKZ6q0Fc9dDpPgpDfV+M3iiYGXkzZsHyO9PFd+
         F6trAoYv9DCtADIUKq6Gz6evDhnpeAOySKLL9guixIl126egkxOMMqSJqWImkYTRgNNh
         4BWHxbGMCk21F2P89qbjxr+67nH9wsirXvL0lP+6+J93Iq+9Nt7hE7UQULZKEsZXks+h
         TTZBTofWrmVt6bhsSE4hAb4/aeWV+S8h/fHx6miY8xKKrTi0Vboel6UGnIW7nV/97XG3
         aBZ8oMluTUFReA4Ine0pvqRBnoaF9+Xaew/O20i0yrs7U7dYAE43px2qfucr22b+X4cK
         EpPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hRER8zldJAAIMr6Re3Nn4orTwkJhjR0IK/FMbFQjBpU=;
        b=UFaU63H6ABT6mpkvx23mzW6NTq3803HbodghJvok0RJgKi57JkqB+EJv/AmRXfggqn
         85UrViqeQjWOSqKEt46K9HWVa6cG22lMqDj5LRhc7gjoqscY6wUlw2c83ccvoUSjNpyq
         HlPUz0EIFpYNhdg1nSE/EYMuTJig5BQ7Y1f10ZLFmUdgzmvu/gyCyrOzcBS9Fz0SZWCp
         /6rQluOODXbOHzOdm73ItsqbgpuTIpeNfLS76H/6kw96Jzb8/JI7hYYBKk2UXHBTNZek
         1LuiAtPRvt3C5/gssAqoaE7aenVsMGPT1l6vpwjSiFHvXgwnUQ8+a5bLqUuvmYzZFQX+
         WHyg==
X-Gm-Message-State: AOAM531J0vEAMwcyaNyzNrOCVEW4KLD0bTTW2DGyk+gyzw33WYpYmuk5
        s/YPrqQAWCrdwU2XRqdRrx40+DXTf3Q8lg==
X-Google-Smtp-Source: ABdhPJxxCeWX9BOk0xOGwB10Vxyl32DYLW1mVIzjmTBjNX+By8SrIKjkEbeTkHQkoEi7iBH6A1KRWw==
X-Received: by 2002:aa7:8292:0:b029:1ed:d6e5:1333 with SMTP id s18-20020aa782920000b02901edd6e51333mr11965802pfm.55.1614540069858;
        Sun, 28 Feb 2021 11:21:09 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b187sm13706914pgc.23.2021.02.28.11.21.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 11:21:09 -0800 (PST)
Message-ID: <603bed25.1c69fb81.fc291.f7d8@mx.google.com>
Date:   Sun, 28 Feb 2021 11:21:09 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.19-19-ged89ece04062
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 115 runs,
 4 regressions (v5.10.19-19-ged89ece04062)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 115 runs, 4 regressions (v5.10.19-19-ged89ec=
e04062)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =

imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =

meson-gxm-q200           | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.19-19-ged89ece04062/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.19-19-ged89ece04062
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ed89ece0406208d64ca8787f5c735ce6139f28c0 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx6q-var-dt6customboard | arm   | lab-baylibre | gcc-8    | multi_v7_defco=
nfig | 2          =


  Details:     https://kernelci.org/test/plan/id/603bbb31f32a497260addcc4

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
19-ged89ece04062/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
19-ged89ece04062/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/603bbb31f32a497=
260addcc8
        new failure (last pass: v5.10.19-1-gd1c42444d513)
        4 lines

    2021-02-28 15:47:16.188000+00:00  kern  :alert : Unable to handle kerne=
l NULL pointer dereference at virtual address 00000313
    2021-02-28 15:47:16.189000+00:00  kern  :alert : pgd =3D 1b1f9328<8>[  =
 14.355624] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=
=3Dlines MEASUREMENT=3D4>
    2021-02-28 15:47:16.190000+00:00  =

    2021-02-28 15:47:16.191000+00:00  kern  :alert : [00000313] *pgd=3D0000=
0000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/603bbb31f32a497=
260addcc9
        new failure (last pass: v5.10.19-1-gd1c42444d513)
        47 lines

    2021-02-28 15:47:16.248000+00:00  kern  :emerg : Process kworker/3:2 (p=
id: 80, stack limit =3D 0xe432ad82)
    2021-02-28 15:47:16.249000+00:00  kern  :emerg : Stack: (0xc26f1d58 to =
0xc26f2000)
    2021-02-28 15:47:16.250000+00:00  kern  :emerg : 1d40:                 =
                                      c3c741b0 c3c741b4
    2021-02-28 15:47:16.251000+00:00  kern  :emerg : 1d60: c3c74000 c3c7401=
4 c1449338 c09bdc5c c26f0000 ef871cc0 c09bf01c c3c74000
    2021-02-28 15:47:16.252000+00:00  kern  :emerg : 1d80: 000002f3 0000000=
c c19c76e4 c2001d80 c328d900 ef85d1a0 c09cb3b4 c1449338
    2021-02-28 15:47:16.290000+00:00  kern  :emerg : 1da0: c19c76c8 d8ec1f9=
7 c19c76e4 c3ce6d40 c3ce5300 c3c74000 c3c74014 c1449338
    2021-02-28 15:47:16.291000+00:00  kern  :emerg : 1dc0: c19c76c8 0000000=
c c19c76e4 c09cb384 c1447060 00000000 c3c7400c c3c74000
    2021-02-28 15:47:16.292000+00:00  kern  :emerg : 1de0: fffffdfb c22d8c1=
0 c355ef00 c09a12dc c3c74000 bf026000 fffffdfb bf022138
    2021-02-28 15:47:16.293000+00:00  kern  :emerg : 1e00: c3ce6340 c3b0430=
8 00000120 c35607c0 c355ef00 c09fac78 c3ce6340 c3ce6340
    2021-02-28 15:47:16.294000+00:00  kern  :emerg : 1e20: 00000040 c3ce634=
0 c355ef00 00000000 c19c76dc bf049084 bf04a014 00000020 =

    ... (34 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
imx8mp-evk               | arm64 | lab-nxp      | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/603bbdf3581b151ea9addd0d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
19-ged89ece04062/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
19-ged89ece04062/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bbdf3581b151ea9add=
d0e
        new failure (last pass: v5.10.19-1-gd1c42444d513) =

 =



platform                 | arch  | lab          | compiler | defconfig     =
     | regressions
-------------------------+-------+--------------+----------+---------------=
-----+------------
meson-gxm-q200           | arm64 | lab-baylibre | gcc-8    | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/603bbc6ab56ac8ceecaddcde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
19-ged89ece04062/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.19-=
19-ged89ece04062/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/603bbc6ab56ac8ceecadd=
cdf
        new failure (last pass: v5.10.19-1-gd1c42444d513) =

 =20
