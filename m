Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCCF137BC5D
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 14:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231468AbhELMTt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 08:19:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231451AbhELMTt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 May 2021 08:19:49 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AEFC061574
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:18:41 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id m190so18110742pga.2
        for <stable@vger.kernel.org>; Wed, 12 May 2021 05:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=yIIzJNEZof72j3kYXClFhy/hhw38ZBfMeV83BZYUwxw=;
        b=1/FETfPcXHdMa9GbVcSbrj3WB0yHRB9Qrind7aa+xfY8Pk4TytIWBqTQKQowzWXUqC
         KyBa6Disb2i4jtmh9Jb+66YWVeDLj376z7DvnlHjaV4nhj4Wm09DV+pBWKlZYE6EpGwc
         Dq1L4XXsZUrMnJzI4czjM6BDkXwkdHrNdfgHgJBMljknhlJRgSJVPmvN4IlNwYXyC6V3
         I66sY1gbAyUl9lDjK5o9gvR3/NyOTbVTtH/vFHVXgJjg5ViOoo3BXkQOGUJ+h6BLNjYe
         pc9zTWKFxgsXHL7SJ82Cf+7A8N+PWHEFWaaARVXfF0NCnSpoPqz8CNg79CwCQ86snx6L
         ow4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=yIIzJNEZof72j3kYXClFhy/hhw38ZBfMeV83BZYUwxw=;
        b=GYMTLPqL/WBZyAL/EuTZjwP0lPXIyuVJOMOfezcMV0eEses6FLDGoEHoO/dpEh16ld
         vHPu0Y5V2/Inr/OKBkErUwV5Fo8dfQkGY+GTC7Ge4nNbpmHthNkryo7ErTDRYm4m4R2m
         SeMZCe7QzWX8vA4e3WjfMd6tIq5ejxEkT7xISuZX/l94CSASc/uX0C3FBcqiJbo+puyR
         aRekH4Q3w6+CTuEwLeCbMn0KL1r2RVXi0WUznzNcJ6mhpDQGj4fe4GmmH3YIJDFFInLR
         aT2mITRFzSioU4Mldq62g3qYhddUz4AMn9QfSCedcf8qZ/0DdjyDgfeJZZT6GIii2U64
         4bvg==
X-Gm-Message-State: AOAM530jyXObOVbtLUjxnB6zquLWGPenT6fRweNxEsEssgurAqA+01fK
        hkSDwmieFA5FZ2xP9OYdJqIUv/oY40O1X7lB
X-Google-Smtp-Source: ABdhPJysk/t8sDyoOJszXDV25ykSwurK6VRv4m7Ga4uQtESXj4sTOF7kHGx8Y/ZJKFfAGosINU9qvw==
X-Received: by 2002:a05:6a00:7d7:b029:28e:5a59:25f9 with SMTP id n23-20020a056a0007d7b029028e5a5925f9mr34581233pfu.24.1620821921184;
        Wed, 12 May 2021 05:18:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j2sm4328061pji.34.2021.05.12.05.18.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 May 2021 05:18:40 -0700 (PDT)
Message-ID: <609bc7a0.1c69fb81.1f227.dee7@mx.google.com>
Date:   Wed, 12 May 2021 05:18:40 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.11.20
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-5.11.y
X-Kernelci-Report-Type: test
Subject: stable/linux-5.11.y baseline: 170 runs, 3 regressions (v5.11.20)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-5.11.y baseline: 170 runs, 3 regressions (v5.11.20)

Regressions Summary
-------------------

platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defco=
nfig | 1          =

meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.11.y/kernel=
/v5.11.20/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.11.y
  Describe: v5.11.20
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      0323610eaa5ca00195a715f6e25add4c24150ee3 =



Test Regressions
---------------- =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
imx6ul-pico-hobbit   | arm   | lab-pengutronix | gcc-8    | imx_v6_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/609b928529be1fa3a4d08f76

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.11.y/v5.11.20/a=
rm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.11.y/v5.11.20/a=
rm/imx_v6_v7_defconfig/gcc-8/lab-pengutronix/baseline-imx6ul-pico-hobbit.ht=
ml
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609b928529be1fa3a4d08=
f77
        failing since 4 days (last pass: v5.11.18, first fail: v5.11.19) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxbb-p200      | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/609b93b9a056b4f89ed08f53

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.11.y/v5.11.20/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.11.y/v5.11.20/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609b93b9a056b4f89ed08=
f54
        new failure (last pass: v5.11.19) =

 =



platform             | arch  | lab             | compiler | defconfig      =
     | regressions
---------------------+-------+-----------------+----------+----------------=
-----+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre    | gcc-8    | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/609b94319733d5d815d08f1e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-5.11.y/v5.11.20/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.11.y/v5.11.20/a=
rm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/609b94319733d5d815d08=
f1f
        new failure (last pass: v5.11.19) =

 =20
