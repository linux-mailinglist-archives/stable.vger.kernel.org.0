Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 796D6500415
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 04:17:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbiDNCUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 22:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236592AbiDNCUB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 22:20:01 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 874C44EDD5
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:17:35 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso5037004pjj.1
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 19:17:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=0YZlYJhaRtUnTO6vp5ZX/QnvY6N6TmlQcQJoSHCVglQ=;
        b=1d14wrBfzGcSgJpTquYvQEPk/pDRCMAhLPP3e4LKFXmPjFWc3e7WsBS6J75uFTovXC
         jBMu4wK2vxjlmTnto6FOYywnEhWK7+70iuLPJ90zuMQxTDGlZrVawcOD1O9ECqKl/d2W
         7T/BkLmyev8iKMJdrCaIVvOZ0rjPthI6IhwMWq3GpsNtk13onuxyXdkrrvi9Da5etcpf
         InOD8a0mUe4NIw+G3VBVpQRUCmRlEwTcoXBLk4KVxzMxMqds/memlJWL72pfnLGZ3fiI
         7oICfs9gt8oq52TchrxlB2z25jWH7F0CR1TYDbzk8rLxqj2MHfdWlF2lT8pvjgJP81Xd
         0W5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=0YZlYJhaRtUnTO6vp5ZX/QnvY6N6TmlQcQJoSHCVglQ=;
        b=wWcrhyO30qdLYu1KsVF0RmzKlv3DpInGu9BljMjrch8AY4WFEQa7wiEJDz0ihklYYr
         9sD3RmEn44rYbaABbZ2Fe1NRjFlb/6JM0OBqox097rVaKMiw8uddACsRJdGWkUBbAwQ4
         A34+GjFqgQTnkniPoSF0o5FzBpANhGYg/F7vO75Nn61p0gIeLHtMFuIkSJxgXswEN6hY
         lBq770VHLQH+N3ZFx7YID5lRZiZXRnM3QbVjhRpkKlbZUXIAOXA6HzS5PWFv/rB71Hgi
         V+uR5UQA/wBh3MvEUQ7NJL9MU7yse5b0xSGxlsx248YjQjstpy0fLaD2GaDDw/nbkyrN
         ANBQ==
X-Gm-Message-State: AOAM531E1v8uAhXLQ9xFaAjoaiLbVcDm+TI8kBHesJbtY9bK0+O1Bap4
        C03vIXwP/6szi0p2s9++9DlYVA1D8Lojjau8
X-Google-Smtp-Source: ABdhPJyGIQKuEmYuJ+IbUhPoHAMAXmOHB0DHfiWH0Wl8j2NGDyLUl5BITEzvhXUs4Ez8mu5akJCuww==
X-Received: by 2002:a17:902:b597:b0:158:1aee:1b59 with SMTP id a23-20020a170902b59700b001581aee1b59mr29256740pls.33.1649902654764;
        Wed, 13 Apr 2022 19:17:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020aa79286000000b004fdf02851eesm382304pfa.4.2022.04.13.19.17.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 19:17:34 -0700 (PDT)
Message-ID: <6257843e.1c69fb81.6fc8d.1a23@mx.google.com>
Date:   Wed, 13 Apr 2022 19:17:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Kernel: v4.19.237
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.19.y baseline: 229 runs, 3 regressions (v4.19.237)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 229 runs, 3 regressions (v4.19.237)

Regressions Summary
-------------------

platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =

rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.237/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.237
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a6e4a1818efa77621b27b5055cea85873b5e1f83 =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6254f95979fe4cdd15ae06a4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6254f95979fe4cdd15ae0=
6a5
        failing since 6 days (last pass: v4.19.235-23-g354b947849d2, first =
fail: v4.19.235-58-ga78343b23cae) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/62546481ca6e0ff3c0ae06bd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62546481ca6e0ff3c0ae0=
6be
        new failure (last pass: v4.19.234-30-g4401d649cac2) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/625461e29d0a100e15ae06ae

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.2=
37/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gr=
u-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/625461e29d0a100e15ae06d0
        failing since 36 days (last pass: v4.19.232, first fail: v4.19.232-=
45-g5da8d73687e7)

    2022-04-13T23:20:55.357245  /lava-6083398/1/../bin/lava-test-case   =

 =20
