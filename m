Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD7AB4163C8
	for <lists+stable@lfdr.de>; Thu, 23 Sep 2021 19:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240732AbhIWRDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Sep 2021 13:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238281AbhIWRDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Sep 2021 13:03:42 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA725C061574
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 10:02:10 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id s11so6934271pgr.11
        for <stable@vger.kernel.org>; Thu, 23 Sep 2021 10:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=tOfdENlY1Ez7szu/MU6aZGAtLMDPABgZED9sQwKOZKI=;
        b=38ViOU2gGqOHDRUCXU5VVzJMzrSc3565rJT176IPTcD1z6tYRKQBczo6SBfdHud/km
         8ToolX28S6F2yDhyCqHwPnUsgZcBLM2i23sRBK/RvFmanE81UIJfpz1shWjeHhsu1ttw
         wVO0uEFV1kJg+xg4RFw50M05/7/D5eGJiK/05kK3VL+q6sw9jkdNmopcWZZuLiAlRKNL
         00+qt1sDP1JfNvAnceKRMzfkPLt8M0YbIqceOYFcX6GWvO7XpOszw19Yg7FiEiW35A/A
         VsVH8rq1wQppwcz2pzuVgNy7Y7dxxE9gMdJkcQjkYUpFRgmyb8HA7722wGwWXcXdfLjt
         neBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=tOfdENlY1Ez7szu/MU6aZGAtLMDPABgZED9sQwKOZKI=;
        b=uMF5UHmwaHt0rZ7R8bt/f1pOdSnpWh5JNhaPOGlhrgNxEvSiR6eD0g6ZUevdrea+pR
         d9n606OViWRuxdlxP809U9XiGLGIn/NdN2FM6DWOOpM2L+8r/wQoSkdCmqKn9oxalM2R
         5X/+5CGhQJLKrEB79W8gqAr8S4q+AXFpurqmqeZ6AOUQeZgwf2oc6AN3Ml9LreveNWjJ
         iaRMXP5yE82sBMFkGycxkhVqBT015qU+9+1+FQh+rq2qmurKAc7VJGnH27ZHOjt6fRq+
         8QTcG0rb9Dn93uuXBbTl28gmvJ4yE9+Zgidm8WGfsqnpVGA+GnF5UXFGbwxM8QI6xOep
         CTiw==
X-Gm-Message-State: AOAM5304mZxHabgZ7YDWhNAG5w+QWwX1Uaz0EL2jl23eoS6weKSmori6
        L8TYdxzpUTCL7ruwd98tnRuQpCrlDankC250
X-Google-Smtp-Source: ABdhPJxd4QFqNqzBzLGaT9BUfjQ+HMgb8aqOm7t+stS3JmlTENoslZxT6xfNcZLImlh1cHxdMSVJ0w==
X-Received: by 2002:a63:4d20:: with SMTP id a32mr5103755pgb.247.1632416530038;
        Thu, 23 Sep 2021 10:02:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p2sm7204949pgd.84.2021.09.23.10.02.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 10:02:09 -0700 (PDT)
Message-ID: <614cb311.1c69fb81.55487.59bc@mx.google.com>
Date:   Thu, 23 Sep 2021 10:02:09 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.68-10-g38dcbe3cf3a5
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.10
Subject: stable-rc/queue/5.10 baseline: 176 runs,
 4 regressions (v5.10.68-10-g38dcbe3cf3a5)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 176 runs, 4 regressions (v5.10.68-10-g38dcbe=
3cf3a5)

Regressions Summary
-------------------

platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =

imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =

sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.68-10-g38dcbe3cf3a5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.68-10-g38dcbe3cf3a5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      38dcbe3cf3a508aa096714296313e71d61ea5e72 =



Test Regressions
---------------- =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
hip07-d05                | arm64 | lab-collabora | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/614c7db8354c2e888a99a337

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g38dcbe3cf3a5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g38dcbe3cf3a5/arm64/defconfig/gcc-8/lab-collabora/baseline-hip07-d05.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c7db8354c2e888a99a=
338
        failing since 84 days (last pass: v5.10.46-100-gce5b41f85637, first=
 fail: v5.10.46-100-g3b96099161c8b) =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
imx6q-var-dt6customboard | arm   | lab-baylibre  | gcc-8    | multi_v7_defc=
onfig | 2          =


  Details:     https://kernelci.org/test/plan/id/614c7c78de23b6212699a2e8

  Results:     4 PASS, 2 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g38dcbe3cf3a5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g38dcbe3cf3a5/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-v=
ar-dt6customboard.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.alert: https://kernelci.org/test/case/id/614c7c78de23b62=
12699a2ef
        new failure (last pass: v5.10.67-128-gad904e1e9645)
        4 lines

    2021-09-23T13:08:50.813065  kern  :alert : 8<--- cut here ---
    2021-09-23T13:08:50.844341  kern  :alert : Unable to handle kernel NULL=
 pointer dereference at virtual address 00000313
    2021-09-23T13:08:50.845439  kern  :alert : pgd =3D 3971f4ee<8>[   11.67=
0231] <LAVA_SIGNAL_TESTCASE TEST_CASE_ID=3Dalert RESULT=3Dfail UNITS=3Dline=
s MEASUREMENT=3D4>
    2021-09-23T13:08:50.845726  =

    2021-09-23T13:08:50.845959  kern  :alert : [00000313] *pgd=3D00000000   =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/614c7c79de23b62=
12699a2f0
        new failure (last pass: v5.10.67-128-gad904e1e9645)
        47 lines

    2021-09-23T13:08:50.861033  kern  :emerg : Internal error: Oops: 17 [#1=
] SMP ARM
    2021-09-23T13:08:50.903322  kern  :emerg : Process kworker/0:1 (pid: 29=
, stack limit =3D 0x11495cfd)
    2021-09-23T13:08:50.903596  kern  :emerg : Stack: (0xc223bd50 to 0xc223=
c000)
    2021-09-23T13:08:50.904074  kern  :emerg : bd40:                       =
              c3b0c5b0 c3b0c5b4 c3b0c400 c3b0c414
    2021-09-23T13:08:50.904313  kern  :emerg : bd60: c144ae24 c09c762c c223=
a000 ef875fe0 8010000f c3b0c400 000002f3 d5f04be9
    2021-09-23T13:08:50.904534  kern  :emerg : bd80: c19c788c c2001a80 c30c=
ac00 ef859900 c2001a80 c30cac00 ef859900 d5f04be9
    2021-09-23T13:08:50.946072  kern  :emerg : bda0: c144ae24 c3eff1c0 c3ad=
4680 c3b0c400 c3b0c414 c144ae24 c19c7870 0000000c
    2021-09-23T13:08:50.946611  kern  :emerg : bdc0: c19c788c c09d4f2c c144=
8b4c 00000000 c3b0c40c c3b0c400 fffffdfb c2298c10
    2021-09-23T13:08:50.946853  kern  :emerg : bde0: c37a8e80 c09aac74 c3b0=
c400 bf048000 fffffdfb bf044138 c3efa8c0 c3585108
    2021-09-23T13:08:50.947078  kern  :emerg : be00: 00000120 c328a8c0 c37a=
8e80 c0a04aa8 c3efa8c0 c3efa8c0 00000040 c3efa8c0 =

    ... (35 line(s) more)  =

 =



platform                 | arch  | lab           | compiler | defconfig    =
      | regressions
-------------------------+-------+---------------+----------+--------------=
------+------------
sun50i-a64-bananapi-m64  | arm64 | lab-clabbe    | gcc-8    | defconfig    =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/614c7dfc3ec86a950b99a2f1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g38dcbe3cf3a5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.68-=
10-g38dcbe3cf3a5/arm64/defconfig/gcc-8/lab-clabbe/baseline-sun50i-a64-banan=
api-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/614c7dfc3ec86a950b99a=
2f2
        failing since 10 days (last pass: v5.10.63-26-gfb6b5e198aab, first =
fail: v5.10.64-214-g93e17c2075d7) =

 =20
