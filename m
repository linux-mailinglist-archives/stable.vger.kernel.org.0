Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFB396C1EED
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 19:03:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230151AbjCTSDi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 14:03:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCTSDI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 14:03:08 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD59B33CE4
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:57:19 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id e15-20020a17090ac20f00b0023d1b009f52so17424626pjt.2
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 10:57:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112; t=1679335011;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=tjvEl+epS5OznqRioETTBiMYSSfguKoFk4Qo6t6o3u8=;
        b=ZnUEJveHNxhA8Q5TbYRXohfn9RQxXq60DC6luAF5NmEscrOIcECdAtubBE1Wi4ibFi
         bHaYeSHZOg/a8WkKtQoKztwyouxp0AFpLeCtJJP8idnLMk2ctJuVEaGzSUfB9REQZIdi
         iToEOeVEFZRjDz4vaLYQaBkLnMqV8gXTJCFn3nD9FU6s4cw9NAyZhNDgmxj2/eZ/qyC3
         6jeD3hq0K29rJ0zu+5+FO1KTObax4KHFqxXDMNg1sPCAuFkJ0uGHJoN5FVRWOuUICJmN
         Z1vi4YDuOmPn7ZryovZxf3pro41QiiuHzA0t1CpunAgpFdvg4oBi1dK1eyBW/kbcqrJJ
         WcAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679335011;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tjvEl+epS5OznqRioETTBiMYSSfguKoFk4Qo6t6o3u8=;
        b=ek2e1ENK0lJ5F9SR1jtBTrybZE9fSkxHHVnGy+qXi0ZjqwxnJj78pFLoK0Kz7ivTjn
         ITFbgd/y82ClcaxYMUKRASi+5gCXxJR+ESNqi9gnyvtmmMwQQQ1lQp66Pvr9mLahlklt
         vYaDYf/bxliYHrfWZI+/ywi/JcqjOY2KkSvxSBEd14WKU538/Gg197RVlsxQbqH4v6gt
         8s5IvY6tHU3xKXipMzfj2JLov497zrcFZr7OOUmjRQ2mYv3u0tynSvoYADm6zYwrXHeK
         EHKnrCP9lgWwvzuli9Gk2jwi8osiHYE0us+D0QNxQ4zHa78NkcmTNUyn/qk30E6n1Tia
         ikBQ==
X-Gm-Message-State: AO0yUKUkFVRRyXecpzzTY/v+9wIefwmW57070aWzs/91fhlZaS/0/4Ox
        D7oiHqC5p0vYg5hOFzMn2yxKy9F6+0iPEROBQKlU8g==
X-Google-Smtp-Source: AK7set/ndWMdo3G7ftqC0pCvpzkGG8iHZEA+9egh7TRU+wOZ5ugCAoZ3PJsYyB8s9lFZPryKHKWBDQ==
X-Received: by 2002:a05:6a20:2d94:b0:d8:d7e1:fc6d with SMTP id bf20-20020a056a202d9400b000d8d7e1fc6dmr7617925pzb.38.1679335011493;
        Mon, 20 Mar 2023 10:56:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j24-20020a62e918000000b006258dd63a3fsm6634831pfh.56.2023.03.20.10.56.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 10:56:50 -0700 (PDT)
Message-ID: <64189e62.620a0220.b7029.b68d@mx.google.com>
Date:   Mon, 20 Mar 2023 10:56:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/6.1
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v6.1.20-190-gfb3ddaa27aa7
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/6.1 baseline: 171 runs,
 2 regressions (v6.1.20-190-gfb3ddaa27aa7)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/6.1 baseline: 171 runs, 2 regressions (v6.1.20-190-gfb3ddaa=
27aa7)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie  | gcc-10   | bcm2835_defconfig =
| 1          =

meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F6.1/kern=
el/v6.1.20-190-gfb3ddaa27aa7/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/6.1
  Describe: v6.1.20-190-gfb3ddaa27aa7
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fb3ddaa27aa7c828cd5b91efa475eab881398df9 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
bcm2835-rpi-b-rev2   | arm   | lab-broonie  | gcc-10   | bcm2835_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6418715b45f13055c68c866c

  Results:     50 PASS, 2 FAIL, 1 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
0-gfb3ddaa27aa7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
0-gfb3ddaa27aa7/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-r=
pi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/armel/rootfs.cpio.gz =



  * baseline.bootrr.deferred-probe-empty: https://kernelci.org/test/case/id=
/6418715b45f13055c68c86a3
        new failure (last pass: v6.1.20-142-g50c2c02e4ebf)

    2023-03-20T14:44:17.766515  + set +x
    2023-03-20T14:44:17.770271  <8>[   16.374934] <LAVA_SIGNAL_ENDRUN 0_dme=
sg 193153_1.5.2.4.1>
    2023-03-20T14:44:17.886131  / # #
    2023-03-20T14:44:17.988029  export SHELL=3D/bin/sh
    2023-03-20T14:44:17.988521  #
    2023-03-20T14:44:18.089820  / # export SHELL=3D/bin/sh. /lava-193153/en=
vironment
    2023-03-20T14:44:18.090119  =

    2023-03-20T14:44:18.191386  / # . /lava-193153/environment/lava-193153/=
bin/lava-test-runner /lava-193153/1
    2023-03-20T14:44:18.192058  =

    2023-03-20T14:44:18.198140  / # /lava-193153/bin/lava-test-runner /lava=
-193153/1 =

    ... (14 line(s) more)  =

 =



platform             | arch  | lab          | compiler | defconfig         =
| regressions
---------------------+-------+--------------+----------+-------------------=
+------------
meson-gxbb-nanopi-k2 | arm64 | lab-baylibre | gcc-10   | defconfig         =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6418688288379799ac8c8630

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
0-gfb3ddaa27aa7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-nan=
opi-k2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-6.1/v6.1.20-19=
0-gfb3ddaa27aa7/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-nan=
opi-k2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230310.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6418688288379799ac8c8=
631
        new failure (last pass: v6.1.20-142-g50c2c02e4ebf) =

 =20
