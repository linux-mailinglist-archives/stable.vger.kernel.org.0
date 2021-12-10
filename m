Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36652470C19
	for <lists+stable@lfdr.de>; Fri, 10 Dec 2021 21:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233105AbhLJU6t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Dec 2021 15:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbhLJU6t (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Dec 2021 15:58:49 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95389C061746
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:55:13 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id x7so7694826pjn.0
        for <stable@vger.kernel.org>; Fri, 10 Dec 2021 12:55:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=o2rHv01PLe666jWgfJFcPT02rwhqkl1tH6wLPlJKOjY=;
        b=UzECb78pzPT+2/UaeAD2zAU9HkRmFWVKx4rLajWVJKx3uzlJQhkakbybPu5yq31iJw
         ohfty1oRg8XLN3Iyu6xIbLXSr3uPqAKwGhoDObCaJch4Gzs9jIIYzejUenDGFfvYBOUr
         sQOu8/GRQmT5FBiq0Zcx7lB2j3HSCt8JYr85jniUN/3WdAN5/loJlzFkFc3Vvw0AOb9n
         NQt1wU7xD47sD+jv/zgRxnutj5OtcxGxDYLiL9GSEryF++w4foyWpzZv7Ovx4nKtFj7g
         OzjNwon3e3918le6ZzZynOzXhl+ySBhglQIXcQhCndJ/9JqgL/XD6EYktTziGNwCLu9D
         fpOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=o2rHv01PLe666jWgfJFcPT02rwhqkl1tH6wLPlJKOjY=;
        b=PgWDtJTEA1Pj4l8WsMeZhWDMaUcDdUpulheZADiIFd7seNsbx77ZO6YuQ8rJaCC0wD
         y5MllaLtzc6m+h8hbfp7iqSksedu/g476GsPV0EksoZfC1aw31mrIx3844uQi1a0RvdR
         Bp/Hwa4nYjXENeCMqNPAV4ZPsFI72k6Nkz66kybqkGm7StoefTQfXwygCHWHLjblfOds
         RxKjOqFfMhk6ne1SszUo5FKukPq0qV0AfcRwqCCZfH3PlouG2S6tUpRd+I5rMTalkzgb
         nRtax4jQrjR0k+C90K+uIPvefUb5Bqf/f2DRiBtuuwu28l2GSBiaahFcTStL/MzlQcsb
         SN7A==
X-Gm-Message-State: AOAM532vVVrW+hchGjyca6gZshdjfCVr1oyZyxj5o+OVEQAZ8YpZH3Kx
        8VuF+tQyFUqOD7ka4ZjGbRs8JOT8VhCHRqHW
X-Google-Smtp-Source: ABdhPJzIjcZ6RCFIdDYmD+RuLz906nae+pDWzYg6ZOiUnQ5fSYSeKW5kiBtRjNmH5IA5SWiClhSm5g==
X-Received: by 2002:a17:90a:b88d:: with SMTP id o13mr26529179pjr.39.1639169712934;
        Fri, 10 Dec 2021 12:55:12 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c3sm4187349pfv.67.2021.12.10.12.55.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Dec 2021 12:55:12 -0800 (PST)
Message-ID: <61b3beb0.1c69fb81.7e015.c9a4@mx.google.com>
Date:   Fri, 10 Dec 2021 12:55:12 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.9.292-9-g6988c513714d
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/4.9
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.9 baseline: 129 runs,
 3 regressions (v4.9.292-9-g6988c513714d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.9 baseline: 129 runs, 3 regressions (v4.9.292-9-g6988c513=
714d)

Regressions Summary
-------------------

platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =

minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =

panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig        | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.9/kern=
el/v4.9.292-9-g6988c513714d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.9
  Describe: v4.9.292-9-g6988c513714d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6988c513714ddbc1e620c4068cc950bf9e2fdb50 =



Test Regressions
---------------- =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
meson-gxbb-p200          | arm64  | lab-baylibre  | gcc-10   | defconfig+ar=
m64-chromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/61b389232f97014431397149

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-9=
-g6988c513714d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-9=
-g6988c513714d/arm64/defconfig+arm64-chromebook/gcc-10/lab-baylibre/baselin=
e-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b389232f97014431397=
14a
        new failure (last pass: v4.9.292-8-g267327cffca6) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
minnowboard-turbot-E3826 | x86_64 | lab-collabora | gcc-10   | x86_64_defco=
nfig           | 1          =


  Details:     https://kernelci.org/test/plan/id/61b38571cfcf3c31fb397141

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: x86_64_defconfig
  Compiler:    gcc-10 (gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-9=
-g6988c513714d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-9=
-g6988c513714d/x86_64/x86_64_defconfig/gcc-10/lab-collabora/baseline-minnow=
board-turbot-E3826.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/x86/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/61b38571cfcf3c31fb397=
142
        new failure (last pass: v4.9.291-70-gd8115b0fbf8b) =

 =



platform                 | arch   | lab           | compiler | defconfig   =
               | regressions
-------------------------+--------+---------------+----------+-------------=
---------------+------------
panda                    | arm    | lab-collabora | gcc-10   | omap2plus_de=
fconfig        | 1          =


  Details:     https://kernelci.org/test/plan/id/61b38389e3dc804b5339713b

  Results:     4 PASS, 1 FAIL, 1 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-9=
-g6988c513714d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.9/v4.9.292-9=
-g6988c513714d/arm/omap2plus_defconfig/gcc-10/lab-collabora/baseline-panda.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/61b38389e3dc804=
b5339713e
        new failure (last pass: v4.9.292-8-g267327cffca6)
        2 lines

    2021-12-10T16:42:31.773305  [   20.467620] <LAVA_SIGNAL_TESTCASE TEST_C=
ASE_ID=3Dalert RESULT=3Dpass UNITS=3Dlines MEASUREMENT=3D0>
    2021-12-10T16:42:31.825060  kern  :emerg : BUG: spinlock bad magic on C=
PU#0, udevd/129
    2021-12-10T16:42:31.833881  kern  :emerg :  lock: emif_lock+0x0/0xfffff=
230 [emif], .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0   =

 =20
