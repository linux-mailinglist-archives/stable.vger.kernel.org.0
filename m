Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 951A2393880
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 00:02:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234404AbhE0WEH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 18:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbhE0WEG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 18:04:06 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9A66C061574
        for <stable@vger.kernel.org>; Thu, 27 May 2021 15:02:30 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id ne24-20020a17090b3758b029015f2dafecb0so1293555pjb.4
        for <stable@vger.kernel.org>; Thu, 27 May 2021 15:02:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=p1M9RtwxVhpwyeKNvhaQjP9rRE+pXPYXUWhfRKHIlOI=;
        b=rpAEELfoNzYpE7cuU7E5CyG7cnVwJf5ZQXPl+un1piYmRIYr0XWipWg2aWc9VAzlJH
         Bpn8zGTBsXZuwUxHFgggCj/+CdsMGf4KNM6VXrNS8+vAFNgtVqCZckZq9e4TFHSZkMM+
         qLPjotsTmYE0B04ABfDm39K4J9sDkQOiJXxC9mIZh9SxrnliGNyw3AysCB4mf7JmSQsY
         CKY5WUSnzjpagU8HVDuf9ld7w9yoAm6bmP1rP0GDwUcZ3q+kFTdTOiatv+F9RMeoh5bB
         6s96SCbNFP9gUv5TJFWtRVy725+9oCfqnqBT93bVevn13FdOHa+ip5QzhBW9kvdqgMRC
         rxjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=p1M9RtwxVhpwyeKNvhaQjP9rRE+pXPYXUWhfRKHIlOI=;
        b=P+7OgJsYmV4rT5+Nrquh2lWlwZYVf6HKA1cXNhb9peg7lj3U8L0b8S3WEsZe2N49MX
         qAexTRhE4w+kdD7rjL6+Q6AyGsRXP+iKqEVN+4o03u7YYsjNGV0MWnCkivthxNSvcFwY
         oP8HGTVItqbW7P68pOaB+V3iP/MpA2xx1+kg3wG02PuTaZela2tUsljwdDbUeft7QLw1
         vEodQTs7m5S6vgBMBS05Dlk8P8kHuR1FuprcO4fYrAYC2vVyIf5PvGp0TQh+t9i9f3q+
         dCzF1yPiXNBKlkHdQdXMzsqt114JDQq1lgBOO4y0KVorxoemSnx95NlsrctkWyY5ov0W
         RDjg==
X-Gm-Message-State: AOAM532q3M5fkX2dYk3MT1VsCyqfd3AB+c+ekpnYaP5KFQ628yBHet/a
        0goWrZWDp7At3ZA/G9+ssuM7sabBl9P1qyxb
X-Google-Smtp-Source: ABdhPJybDA7Oy3I1n1SQnkiRGZfCjcXif0JK6c9d1p+G0rrpzrPWnx2bFkA2DoMRDz1s2j22iowX7w==
X-Received: by 2002:a17:90b:ed5:: with SMTP id gz21mr656993pjb.102.1622152950238;
        Thu, 27 May 2021 15:02:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x23sm2778130pje.52.2021.05.27.15.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 15:02:29 -0700 (PDT)
Message-ID: <60b016f5.1c69fb81.8f60b.9f16@mx.google.com>
Date:   Thu, 27 May 2021 15:02:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.122-8-g69500752c057
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.4.y baseline: 124 runs,
 4 regressions (v5.4.122-8-g69500752c057)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 124 runs, 4 regressions (v5.4.122-8-g695007=
52c057)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-8    | defconfig | 1 =
         =

meson-gxm-q200           | arm64 | lab-baylibre | gcc-8    | defconfig | 2 =
         =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.122-8-g69500752c057/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.122-8-g69500752c057
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69500752c0577511bd2a31b0169e1bcb6f710905 =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
hifive-unleashed-a00     | riscv | lab-baylibre | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60afdac143af1c2143b3afbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (riscv64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-8-g69500752c057/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-8-g69500752c057/riscv/defconfig/gcc-8/lab-baylibre/baseline-hifive-unleash=
ed-a00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/riscv/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afdac143af1c2143b3a=
fbd
        failing since 188 days (last pass: v5.4.77-152-ga3746663c3479, firs=
t fail: v5.4.78) =

 =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
meson-gxm-q200           | arm64 | lab-baylibre | gcc-8    | defconfig | 2 =
         =


  Details:     https://kernelci.org/test/plan/id/60aff39cd4702c337db3afc0

  Results:     2 PASS, 2 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-8-g69500752c057/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-8-g69500752c057/arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxm-q200=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60aff39cd4702c3=
37db3afc4
        new failure (last pass: v5.4.120)
        11 lines

    2021-05-27 19:30:21.454000+00:00  kern  :alert : Mem abort info:
    2021-05-27 19:30:21.494000+00:00  kern  <8>[   16.005520] <LAVA_SIGNAL_=
TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D11>
    2021-05-27 19:30:21.494000+00:00  :alert :   ESR =3D 0x96000005
    2021-05-27 19:30:21.494000+00:00  kern  :alert :   EC =3D 0x25: DABT (c=
urrent EL), IL =3D 32 bits
    2021-05-27 19:30:21.494000+00:00  kern  :alert :   SET =3D 0, FnV =3D 0
    2021-05-27 19:30:21.495000+00:00  ker<1>[   16.026228] Unable to handle=
 kernel NULL pointer dereference at virtual address 000000000000000a
    2021-05-27 19:30:21.495000+00:00  <8>[   16.030662] <LAVA_SIGNAL_TESTCA=
SE TEST_CASE_ID=3Demerg RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D2>
    2021-05-27 19:30:21.495000+00:00  <1>[   16.033335] Mem abort info:
    2021-05-27 19:30:21.495000+00:00  <1>[   16.044885]   ESR =3D 0x9600000=
6   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60aff39cd4702c3=
37db3afc5
        new failure (last pass: v5.4.120)
        2 lines =

 =



platform                 | arch  | lab          | compiler | defconfig | re=
gressions
-------------------------+-------+--------------+----------+-----------+---=
---------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig | 1 =
         =


  Details:     https://kernelci.org/test/plan/id/60afdce17c66c6172ab3af97

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-8-g69500752c057/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.122=
-8-g69500752c057/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg=
2m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60afdce17c66c6172ab3a=
f98
        new failure (last pass: v5.4.122) =

 =20
