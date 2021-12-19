Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83C44479FE8
	for <lists+stable@lfdr.de>; Sun, 19 Dec 2021 09:39:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235397AbhLSIj4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Dec 2021 03:39:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235395AbhLSIjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Dec 2021 03:39:55 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79A1AC061574
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 00:39:55 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id y16-20020a17090a6c9000b001b13ffaa625so7399433pjj.2
        for <stable@vger.kernel.org>; Sun, 19 Dec 2021 00:39:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pc0d8EQJeX7R0SzlpwuGVJYgaH81MjC+JvLLMY6vjt0=;
        b=UBcV2pHUFJ/I4pGtC4HH5sN1zUyjNRMKmMG0b/KNGW/MiWOHP7g9MM9XC7ibpQYv90
         qvh8G4Qk4HSuSdgvI8MU91yfqtmodxBBsSfrpLX6Vu/miTsbqU1PiKedApjGGi04ZTPt
         Dm4XlYU63r03OncBYBbF85dsc/TVQCmiwdxYkdBPufHZ+uBKI8L8OTnwsbfi7FGk1hJp
         x9rrKvcXsON2v5ceAHqqFp74yTt7Qe8zrFggK3Ck6F+7tQQuTKrLBZYQOrqEjEGRfkqe
         /hTE4cpqfTFEuwl6FPbDQywLPH7/ftIhGX/i7ixcEDV0tWiKOkTpV0+1SK5mfbzAL0Wz
         uFUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pc0d8EQJeX7R0SzlpwuGVJYgaH81MjC+JvLLMY6vjt0=;
        b=ZYBCu0xAWSGIqwVQSbCfpZOGSH8C+t3SOTqNdGQKG/WXupIW1rJzxd5gLm8er3+euO
         zOXuxdCa6Lmj/nda8tF7i0ssFLdeCdD3ZiMfenIjGOl41Sf8/ifsU1PpPU7ZN26h7FHc
         IjO4jCVg8XtL/3HpQ29M2LYEb4Bcoj8CMb3TMAmSDXhC1Ax5ZwWhk/d880OgnLrPNVoQ
         llhNJ0YA81TRA4B9glSPatiirGaHkKpCkjl9kUd36A9sOMp9PBcLlYbfOaihchH/nvom
         Cu82MCt5wrfxL+Qfm5nI0jPQkhGzF5aeqUBNkH1NZ9xerzT4g7tRagHxRosWRfrJAqre
         HzZQ==
X-Gm-Message-State: AOAM531+KDe2q/KhYywLWyIZmS7996Hr6el7qeFvt9hIuM/mA5yF72w4
        pZXL4oaI6lhz3zwmqxZ0ato98JAXZ9zglehR
X-Google-Smtp-Source: ABdhPJw6tcNo+K25UXspP7wrJgqYnprInn6XsgEZ9FQiTSZZOLiHO5r1890Zv1aV4/zkK6zcsOPFJA==
X-Received: by 2002:a17:90b:4a05:: with SMTP id kk5mr13625220pjb.232.1639903194870;
        Sun, 19 Dec 2021 00:39:54 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cm20sm2646512pjb.28.2021.12.19.00.39.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 00:39:54 -0800 (PST)
Message-ID: <61beefda.1c69fb81.65102.7609@mx.google.com>
Date:   Sun, 19 Dec 2021 00:39:54 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.258-24-g5205a2d8fc35
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.14
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.14 baseline: 152 runs,
 2 regressions (v4.14.258-24-g5205a2d8fc35)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.14 baseline: 152 runs, 2 regressions (v4.14.258-24-g5205a=
2d8fc35)

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
nel/v4.14.258-24-g5205a2d8fc35/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.258-24-g5205a2d8fc35
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5205a2d8fc35c03ecbf22c2867ee9fef2a2548bb =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig    | 1          =


  Details:     https://kernelci.org/test/plan/id/61beb43f4099e4131239713c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-24-g5205a2d8fc35/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-24-g5205a2d8fc35/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-min=
nowboard-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/x86/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61beb43f4099e41312397=
13d
        new failure (last pass: v4.14.258-16-g61a721b2d716) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
        | regressions
-------------------------+--------+---------------+----------+-------------=
--------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/61beb5bcd210062869397129

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-24-g5205a2d8fc35/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.258=
-24-g5205a2d8fc35/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-pan=
da.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20211210.0/armel/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61beb5bcd210062=
86939712c
        failing since 5 days (last pass: v4.14.257-33-gcf9830f3ce18, first =
fail: v4.14.257-53-gbe1979ab4cd9)
        2 lines

    2021-12-19T04:31:33.867857  [   20.040191] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-19T04:31:33.910228  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/98
    2021-12-19T04:31:33.919002  kern  :emerg :  lock: emif_lock+0x0/0xffffe=
d3c [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
    2021-12-19T04:31:33.932711  [   20.107055] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>   =

 =20
