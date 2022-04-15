Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B7F95027CB
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 11:59:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241903AbiDOKCJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 06:02:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234932AbiDOKCI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 06:02:08 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DB3DFD23
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 02:59:38 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id t4so6972760pgc.1
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 02:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=qJDglZJBmp7Tspfj9hyp3glU3oJ5wJSRARrpfDBaGSE=;
        b=IG1MCV6jGofw9vfLqcIUP56RzovYAHCY1Hd2+SKaqQlabL96PevoL/g9c3cE6Qz/P3
         0jBUrlpamilpzzfAgI4j9ouFJq53NMNvcINc7LiNasEn7cv1f0EnyrTk96pm3ZsbNDxZ
         onmgkStX+dl1zThgva0VcE+y3VKU0ts/ejH0gEMBA4dtvL8tQneo4ytzclbWrf+SlA18
         OfyZ366uxpWKBbCN3PhAY0nT6EaJGOKonKbMB+TTdoIOIiVbzu6qnWXqet9FIc9pW3sq
         5XnIZjHcZa53lo59YT4fgyhZ9DfynpurkmLkFzS00wNNFgf4emvaPVw/KUsQkHOW2FOF
         QxkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=qJDglZJBmp7Tspfj9hyp3glU3oJ5wJSRARrpfDBaGSE=;
        b=bSrGVVsv8mZzExl4X36dGch631vxHVbXMyqZlO9au/s9diOZyvkuJZr0xCi1y8D7TS
         2gPOhlPjp7kX1S58lFqCnHU7l7EKT5tAtgRGL2CuK4FbxTHOkl9VO3OSUm9XItpjGa15
         GnrDRZvGVUUIgh1LQEJLdAU3XtdTXspUA6tgyxy0/wtL7VbVoz7cwmfbdOfAQsnzeO9o
         dfvjU9hgVZQwtnKWK0gjW/Y9Vd8oKj/oXt/hzbMXI4bE0j1GeU4TNI811vqxUNWtQyQW
         vZb7qeg/Be7uOmdcI8bxMYZplaYfz6fh54DGKzkNngQEgnNyQwzgZjWX/Rhw5FoRrJyF
         IPGA==
X-Gm-Message-State: AOAM530EfUeetStyHLw9dX61jPPemTHtYOItQN9t3KRLozogiBqI1Lsl
        dkM5Qa2yDzhDv6N8KsNElB8EXjrXl4Hr7Tjn
X-Google-Smtp-Source: ABdhPJzf9CjVwSaogRs7iLX7s8yi51IN4uLsH6JNu5lR2Hu3+nhPjP31LOY1fgrtmxUaP8ehgjd6wQ==
X-Received: by 2002:a63:5fd0:0:b0:39f:cede:cfe9 with SMTP id t199-20020a635fd0000000b0039fcedecfe9mr5754762pgb.455.1650016777357;
        Fri, 15 Apr 2022 02:59:37 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id p3-20020a056a000b4300b004faee36ea56sm2417032pfo.155.2022.04.15.02.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 02:59:37 -0700 (PDT)
Message-ID: <62594209.1c69fb81.19c69.706d@mx.google.com>
Date:   Fri, 15 Apr 2022 02:59:37 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.19
X-Kernelci-Kernel: v4.19.237-335-g5bcecb0e64a0a
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.19 baseline: 72 runs,
 3 regressions (v4.19.237-335-g5bcecb0e64a0a)
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

stable-rc/queue/4.19 baseline: 72 runs, 3 regressions (v4.19.237-335-g5bcec=
b0e64a0a)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.237-335-g5bcecb0e64a0a/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.237-335-g5bcecb0e64a0a
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5bcecb0e64a0ac4b335e92f1e37cbf9a76998e3e =



Test Regressions
---------------- =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxbb-p200      | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/6259190cd9907cdb6fae0702

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-g5bcecb0e64a0a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-g5bcecb0e64a0a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb=
-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6259190cd9907cdb6fae0=
703
        failing since 14 days (last pass: v4.19.235-17-gd92d6a84236d, first=
 fail: v4.19.235-22-ge34a3fde5b20) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre  | gcc-10   | defconfig        =
          | 1          =


  Details:     https://kernelci.org/test/plan/id/625911b35b22014934ae069a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-g5bcecb0e64a0a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-g5bcecb0e64a0a/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625911b35b22014934ae0=
69b
        failing since 9 days (last pass: v4.19.237-15-g3c6b80cc3200, first =
fail: v4.19.237-256-ge149a8f3cb39) =

 =



platform             | arch  | lab           | compiler | defconfig        =
          | regressions
---------------------+-------+---------------+----------+------------------=
----------+------------
rk3399-gru-kevin     | arm64 | lab-collabora | gcc-10   | defconfig+arm64-c=
hromebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62591205401a7d0c34ae067c

  Results:     83 PASS, 7 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-g5bcecb0e64a0a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.237=
-335-g5bcecb0e64a0a/arm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/b=
aseline-rk3399-gru-kevin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62591205401a7d0c34ae069e
        failing since 39 days (last pass: v4.19.232-31-g5cf846953aa2, first=
 fail: v4.19.232-44-gfd65e02206f4)

    2022-04-15T06:34:19.100395  /lava-6094206/1/../bin/lava-test-case
    2022-04-15T06:34:19.109165  <8>[   36.771644] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
