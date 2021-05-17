Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D270A386D7F
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 01:03:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243270AbhEQXFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 19:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233727AbhEQXFD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 May 2021 19:05:03 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F22C061573
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:03:46 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id n6-20020a17090ac686b029015d2f7aeea8so459547pjt.1
        for <stable@vger.kernel.org>; Mon, 17 May 2021 16:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=+y+n7gTnHRrgdXHA8rbS40AO/cEo+auNSfqJhK1fCiQ=;
        b=ECoUgpzTBia0XKsgJMhdaJRXEu1oVcHK5M5G95CvR0vvTFFPBbMOr7AwzPtz3RMQ7x
         UHMGkSONwumHFMXCrpVncjqI3Fk5dQAfuIKykurzoxXCtTPBRDvfZ8eHldSYl++Y+igS
         4XZOW02faKteGrbbhoGRfo6xwqpomaKvLyv+XlWKXK/WG1I8iQtRIIqR1ET3y/CYACc3
         ocv4FQuAVleqRrA+GyizBN/ouzyJVQM/tBJ8Mt9JMoP3oZnUzZ6crLH5Qq1aMMw2sJy3
         KkunCAk0Vk7ZTpLQ22NQ9xfJIKt5cJxirkCgr0ogZ9Gu0wou+36qiwm9qaM2/0GIazaO
         BZNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=+y+n7gTnHRrgdXHA8rbS40AO/cEo+auNSfqJhK1fCiQ=;
        b=a/SH0Ra+TAoOoReSEREDNEaIfbcP87UhZqTs9nt8kn+122kN16plgvFXf9Q0OgDOLo
         P4UL7EdGlwxIwSaxvWFRIzrD2brG/OEQgdrziO+VSF0FIGTS6kWYvRjEI4S9at+lfTm0
         falBE0kxsjfWLmTWRHCTAKHEQKL+/6583SHd+jWLEj8x73+vtwmhgFfsWvdKPQjjZeT6
         eNbtOMfgbSvdQyAZ+gXX7JOGVW2UzJg6BGkoXM9A8H0BRw14+G9I2RZF+LxVQcDA0DV+
         6xsDiVko+35ddAAOi8es9QBRu0pvQAVypr670+q5OPBdxICKH0TgTImEgFSeM9camCqo
         ZeCQ==
X-Gm-Message-State: AOAM532j8QL/66Ed1zwau1M6sGBX8RuOH7ww/yS+T2mI4k1df08FuGfw
        TanRC0vyotqMfTOXNMMu1hQ+hcmmL9JS2LCY
X-Google-Smtp-Source: ABdhPJyb6yAQ3tJcskj4oY/7Nl2dpFSUFyG75pH7M1PIfbyMweUPXlpTZoHZ6S8CaMZSfcgGMQlifg==
X-Received: by 2002:a17:902:e9c6:b029:ef:a615:723a with SMTP id 6-20020a170902e9c6b02900efa615723amr931212plk.71.1621292626241;
        Mon, 17 May 2021 16:03:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cu2sm3647891pjb.43.2021.05.17.16.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 16:03:46 -0700 (PDT)
Message-ID: <60a2f652.1c69fb81.8623c.b7e8@mx.google.com>
Date:   Mon, 17 May 2021 16:03:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.10.37-289-g371f71e1d51b
X-Kernelci-Branch: queue/5.10
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.10 baseline: 132 runs,
 2 regressions (v5.10.37-289-g371f71e1d51b)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.10 baseline: 132 runs, 2 regressions (v5.10.37-289-g371f7=
1e1d51b)

Regressions Summary
-------------------

platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =

imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.37-289-g371f71e1d51b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.37-289-g371f71e1d51b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      371f71e1d51b4def8c23c6ebf8f5e142ebe4be41 =



Test Regressions
---------------- =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
bcm2837-rpi-3-b-32 | arm   | lab-baylibre | gcc-8    | bcm2835_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a2c0a62976805ae4b3afc0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g371f71e1d51b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g371f71e1d51b/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837=
-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c0a62976805ae4b3a=
fc1
        new failure (last pass: v5.10.37-289-gf12d611314b3) =

 =



platform           | arch  | lab          | compiler | defconfig         | =
regressions
-------------------+-------+--------------+----------+-------------------+-=
-----------
imx8mp-evk         | arm64 | lab-nxp      | gcc-8    | defconfig         | =
1          =


  Details:     https://kernelci.org/test/plan/id/60a2c5ad632a5c1581b3afc5

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g371f71e1d51b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.37-=
289-g371f71e1d51b/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a2c5ad632a5c1581b3a=
fc6
        failing since 0 day (last pass: v5.10.37-260-g2c9127d0fedb, first f=
ail: v5.10.37-289-gf12d611314b3) =

 =20
