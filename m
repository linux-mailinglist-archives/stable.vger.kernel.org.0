Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C048F53F461
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 05:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbiFGDOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 23:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229862AbiFGDOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 23:14:19 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B90A19C2A
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 20:14:18 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id w21so14369514pfc.0
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 20:14:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=hCr0kryMvo+JodBVAE8GslFi9G1zTIIt9PkZUOFWNRQ=;
        b=DaQJl/V8eY5qD/OA6Lk0KaEa1W743xdkHOeGa7NlVjG++8encqO+f9H9qXqWw0n2o4
         Ny/zEUKDWt+K8k8LInt35+uqc6Am5DTT+5EGV3lLyeHv/w4kD+wfIF9Gp58hAZUlaE9M
         L3FHismfdnhdB/WxPRpDgaxca3ChQ+hgZVDImLD8LWYNlboXei8XFYilLKfzVOFN9uTm
         x0ZBr/2QL7D8A8hZtk4+FYdGUOrwMaHZe9VetfDMTVSzI8U88lqHuBWStbbXv8BsmND4
         BbeuSc6FC0Eap/vD9Nib/+gYamPz3LNU9Q6yoXW0b0XHk/3/gfsyDodKPFpOLjJVw7KO
         hP4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=hCr0kryMvo+JodBVAE8GslFi9G1zTIIt9PkZUOFWNRQ=;
        b=m1v6uzbrdQgUKsF90fPSGvDD+Cau70jAZmsthCZXG7wxcIHVj0iVhjKLcVgXLE5zMm
         FYvqEsJ+bCInjEarWGP2kWXO8sT7OXk7b9NwWETLSaYbTwOWxksxIsnWMjVA/ApLBlNA
         CAGFB1ep2FkokYp7QXNfbxRKqD3rQSieQlERFTojKVnUjXyEYXV8W34Nqu65duQ7a+af
         lnJa4Kb8KJ/GUd9TFCCOxrbalA2PqqqaGzvpBgH8gQK57tKuK5954IZxjEB0mER1HcDy
         KNYRwKkh4zgJMUYlsUOHPdf98PZvPNrwbhwVbMP/5fnmcMPK/uIxAptbt2XbhDPHIabr
         qSYA==
X-Gm-Message-State: AOAM533mKnSk+gbAXlwxKXjvo22qAXcdOu0UQG23RtcLOeHhDdDhLrJJ
        gu+zDygO2QzR+W1tYUkkIGdTQNU5kVeVztjg
X-Google-Smtp-Source: ABdhPJwgJRNLusqdktHCyYSKf4h0MZKM4LabFsUwogvpI+H4stMSH9IJdYSEuHijDholGoHtx2wjvw==
X-Received: by 2002:aa7:814c:0:b0:51b:b3ee:6be2 with SMTP id d12-20020aa7814c000000b0051bb3ee6be2mr27548607pfn.3.1654571657744;
        Mon, 06 Jun 2022 20:14:17 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h7-20020a170902680700b001651562eb16sm11156843plk.124.2022.06.06.20.14.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 20:14:17 -0700 (PDT)
Message-ID: <629ec289.1c69fb81.3ef1c.960f@mx.google.com>
Date:   Mon, 06 Jun 2022 20:14:17 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-759-gf64e250b75652
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 147 runs,
 3 regressions (v5.17.13-759-gf64e250b75652)
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

stable-rc/queue/5.17 baseline: 147 runs, 3 regressions (v5.17.13-759-gf64e2=
50b75652)

Regressions Summary
-------------------

platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =

tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-759-gf64e250b75652/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-759-gf64e250b75652
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f64e250b75652194c860a44bc5e162abd151ab24 =



Test Regressions
---------------- =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
rk3288-veyron-jaq       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/629eb4ad08143f2e56a39be1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
759-gf64e250b75652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
759-gf64e250b75652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-rk3=
288-veyron-jaq.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629eb4ad08143f2e56a39=
be2
        new failure (last pass: v5.17.11-186-g31ab69ffae8a1) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe    | gcc-10   | defconfig     =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/629e88d9d76639ad09a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
759-gf64e250b75652/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
759-gf64e250b75652/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e88d9d76639ad09a39=
bd5
        new failure (last pass: v5.17.11-11-g79941e95964af) =

 =



platform                | arch  | lab           | compiler | defconfig     =
     | regressions
------------------------+-------+---------------+----------+---------------=
-----+------------
tegra124-nyan-big       | arm   | lab-collabora | gcc-10   | multi_v7_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/629e9f7627fba1276fa39bd1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
759-gf64e250b75652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
759-gf64e250b75652/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220603.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629e9f7627fba1276fa39=
bd2
        failing since 10 days (last pass: v5.17.11, first fail: v5.17.11-2-=
ge8ea2b4363353) =

 =20
