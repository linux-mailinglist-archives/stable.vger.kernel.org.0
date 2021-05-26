Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B5A391D77
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 19:01:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233676AbhEZRDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 13:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233827AbhEZRDM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 13:03:12 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAE8C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 10:01:41 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id x188so1399407pfd.7
        for <stable@vger.kernel.org>; Wed, 26 May 2021 10:01:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=55O07P42oxb/CICnUTen6JPTNA3r4NFgh5TvCjS6pdE=;
        b=S3NHI2C00rwdE4zFMEvYg7dnmXEv6At6ycB7tPOApi0ITUzNDUnZJjjIdTrv+PguV2
         PHIFbuK5xRVNiqY/bKpKZLw2lm9bIGe/HkjOC0BgeXY5SyX3HL6xGwlFdfwgGjQnaawd
         1y/8hkYqiRT0SarH/0QHF/EXVqyacf4FTUh8wqT1/LO1nqOdB1axhgmCf2jy8w71bR/S
         FUi81ZS6fygSJQqw1fFTLqYflWsVhroBUtD+xgDE+gngY+/mP49ut2l8A36NhIexP8tM
         HwHdGA1djpIhdNE7dZBG3X7NLB+jW/KftAUpkTDd0n3jWXbJG3IovjBLoVvc0O5PqVvm
         ElYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=55O07P42oxb/CICnUTen6JPTNA3r4NFgh5TvCjS6pdE=;
        b=cuiOShCQTjWTLTF9vv/K7NZMfQ74doBRWZNw3/ZjTfrzG99ikND9keO8hfEeLZt4ZN
         gRio1hUts9I0ugEBhnOU2EdpuceyqTAst7Eyn8vtPYSeXfxV/7GLr38lAHovh5VT9LRG
         mYV9Vfk9oAy5ZLYhve2sxzXoykaSjsMUnrlfd+nBXgGRpXHK2TTQvaEr5Rs7NPkwYsRY
         J0n1xoeCpXe8zPAwM3edKeOOO0MS5PM4rzwCr9fTz/3Ik68u94vrAoVUaC18G7+rfSQW
         xdEW5a8ZtZmdUse7legeDXgKqbPQSsCxbUOGkHv8uB7h6qk5DpIh/AjQSeLzdbR6E3Iq
         rqkA==
X-Gm-Message-State: AOAM5321ed5BhI01taImbhYnBHLgINsztfl8iy/WJuwo2J/9QHUHpZV1
        9i2bqqF4gDJo4ABtYO+huFsx8l0ZutYs2K+z
X-Google-Smtp-Source: ABdhPJyE558YlK+lzTLXqoyzoCHAgS00OahM5bPJQXVidC8S1YDzmHQ8WmbQ7lmp3sQsHckWzTxLiQ==
X-Received: by 2002:a05:6a00:2126:b029:2e2:89d8:5c89 with SMTP id n6-20020a056a002126b02902e289d85c89mr34161333pfj.37.1622048500509;
        Wed, 26 May 2021 10:01:40 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o5sm16457575pfp.196.2021.05.26.10.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 10:01:40 -0700 (PDT)
Message-ID: <60ae7ef4.1c69fb81.bc2af.5921@mx.google.com>
Date:   Wed, 26 May 2021 10:01:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.4.121-73-gf68ce40c7139
X-Kernelci-Branch: queue/5.4
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.4 baseline: 114 runs,
 3 regressions (v5.4.121-73-gf68ce40c7139)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.4 baseline: 114 runs, 3 regressions (v5.4.121-73-gf68ce40=
c7139)

Regressions Summary
-------------------

platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 2          =

r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.4/kern=
el/v5.4.121-73-gf68ce40c7139/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.4
  Describe: v5.4.121-73-gf68ce40c7139
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f68ce40c7139540e22215c9721752147fa5790bf =



Test Regressions
---------------- =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
bcm2837-rpi-3-b-32       | arm   | lab-baylibre | gcc-8    | bcm2835_defcon=
fig | 2          =


  Details:     https://kernelci.org/test/plan/id/60ae4cf9458f1a96e7b3afa7

  Results:     3 PASS, 2 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
3-gf68ce40c7139/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
3-gf68ce40c7139/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-r=
pi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/60ae4cf9458f1a9=
6e7b3afad
        new failure (last pass: v5.4.121-72-gb7d94ef5137e)
        8 lines

    2021-05-26 13:28:04.996000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address eaf3dc50
    2021-05-26 13:28:04.996000+00:00  ke<8>[   14.232339] <LAVA_SIGNAL_TEST=
CASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dlines MEASUREMENT=3D8>   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/60ae4cf9458f1a9=
6e7b3afae
        new failure (last pass: v5.4.121-72-gb7d94ef5137e)
        59 lines

    2021-05-26 13:28:05.001000+00:00  kern  :alert : [eaf3dc50] *pgd=3D2ae0=
041e(bad)
    2021-05-26 13:28:05.001000+00:00  kern  :alert : 8<--- cut here ---
    2021-05-26 13:28:05.002000+00:00  kern  :alert : Unable to handle kerne=
l paging request at virtual address eaebdcb0
    2021-05-26 13:28:05.003000+00:00  kern  :alert : pgd =3D 2387777b
    2021-05-26 13:28:05.003000+00:00  kern  :alert : [eaebdcb0] *pgd=3D2ae0=
041e(bad)
    2021-05-26 13:28:05.038000+00:00  kern  :emerg : Internal error: Oops: =
8000000d [#1] ARM
    2021-05-26 13:28:05.040000+00:00  kern  :emerg : Process udevd (pid: 95=
, stack limit =3D 0x2c22ffca)
    2021-05-26 13:28:05.040000+00:00  kern  :emerg : Stack: (0xeaf3dcb4 to =
0xeaf3e000)
    2021-05-26 13:28:05.041000+00:00  kern  :emerg : dca0:                 =
                             c03b4360 00000088 eaee06c0
    2021-05-26 13:28:05.042000+00:00  kern  :emerg : dcc0: eaf3dd24 eaf3dcd=
0 c05f2e74 c05f3b38 eaf3dd40 eaf3dcfc eaf3dd34 eaf3dce8 =

    ... (41 line(s) more)  =

 =



platform                 | arch  | lab          | compiler | defconfig     =
    | regressions
-------------------------+-------+--------------+----------+---------------=
----+------------
r8a774a1-hihope-rzg2m-ex | arm64 | lab-cip      | gcc-8    | defconfig     =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae4b0de9918ba513b3afb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
3-gf68ce40c7139/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.4/v5.4.121-7=
3-gf68ce40c7139/arm64/defconfig/gcc-8/lab-cip/baseline-r8a774a1-hihope-rzg2=
m-ex.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae4b0de9918ba513b3a=
fb2
        failing since 0 day (last pass: v5.4.121-70-gb3c1ba3ecdd9, first fa=
il: v5.4.121-72-gb7d94ef5137e) =

 =20
