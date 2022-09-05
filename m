Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5045AD8F1
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 20:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbiIESRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 14:17:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbiIESRJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 14:17:09 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B1A5E33E
        for <stable@vger.kernel.org>; Mon,  5 Sep 2022 11:17:08 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id w139so9175085pfc.13
        for <stable@vger.kernel.org>; Mon, 05 Sep 2022 11:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date;
        bh=eiQF/xgBmmcc7GjSuMi/6VtgQ6ZLP9pagoNFCGbjRJc=;
        b=VfzNEi0IBeabr8rNdcHk+SkeLGSkFxDBPX9WRzR4nI9qcWRKGy6cDmru5ub5pHr29q
         H3ea+FlzJ7rHSBGL8anDuf/exdW8o0zhSvqNyPML7LnFTd3zNLHXfXa9ChYXdSrjJF4F
         jAIzw5WFhDE2hGxDPaFhfQKOJWYCMRnXLNRlOxf41NLb5ncg0iUctQnTS87uU/KjreB2
         vMMhGaNTWDzrMhyaOYI5C/B7ujPSlhC9Dt8/QxSPVzEz6AwdU/fNJZeAYZYsKJHrDl6v
         c6ej0+Upp796SOmeExTOGHWgj6KRKpns4gi1/nHtz9HY0v1egShBAzdiN7/tmC7WqUMY
         T0/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date;
        bh=eiQF/xgBmmcc7GjSuMi/6VtgQ6ZLP9pagoNFCGbjRJc=;
        b=gOruHBOGHDKecXdQX/oapH0Ku/2oxUM6rdExbgcqS4tAsXHDzZ1CFquKwntKuIQzI1
         GntGEvXs3/thTK0FlnNqkIY1KT4buSMzPafKMn8BaRnOmdRuX4nuUaRpVC5vvm6RVfBW
         bygrbGz8r/crjeEAiYIn78pLGs8eTB0ZZfWNJEYpVvC95zWUkjtiuZF6EG3YS/f/0VSk
         o/FrKGSlVqxPJ5Q1LdnuEkErbpG5D3L0arlur/hMJekuE8WgPNgpHEobX4IDWw5GbM94
         sjqMDk/IHnSw01P1F1n6mcJpSSJZApfRiamanLkgHWqoGZ03+vbuwyKhnFfx3AigFWPr
         VIoA==
X-Gm-Message-State: ACgBeo3XjB3xV7rbC6GE3eNboq/meB7Qz+bbQHJ2WZMWr3t0wGD58Z5A
        2t5Xb0rqio4K34Uz5eKRYsncw5FFdkTj7zzPP1E=
X-Google-Smtp-Source: AA6agR62sVEbFyt2RERwoEVCbDbQqvY9su0JmFSXvf+Q6AgLav3FsKzHG64RdtTqWu8nkV2965wSOQ==
X-Received: by 2002:a63:e845:0:b0:42a:610a:77a9 with SMTP id a5-20020a63e845000000b0042a610a77a9mr44467440pgk.96.1662401827578;
        Mon, 05 Sep 2022 11:17:07 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x11-20020a170902a38b00b00176677a893bsm3615308pla.82.2022.09.05.11.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Sep 2022 11:17:07 -0700 (PDT)
Message-ID: <63163d23.170a0220.2f1a8.53e9@mx.google.com>
Date:   Mon, 05 Sep 2022 11:17:07 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.19
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-294-gf3fbc7a9b71b
Subject: stable-rc/queue/5.19 baseline: 126 runs,
 3 regressions (v5.19.4-294-gf3fbc7a9b71b)
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

stable-rc/queue/5.19 baseline: 126 runs, 3 regressions (v5.19.4-294-gf3fbc7=
a9b71b)

Regressions Summary
-------------------

platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig | 1          =

qemu_mips-malta     | mips  | lab-collabora   | gcc-10   | malta_defconfig =
    | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-10   | defconfig       =
    | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.19/ker=
nel/v5.19.4-294-gf3fbc7a9b71b/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.19
  Describe: v5.19.4-294-gf3fbc7a9b71b
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      f3fbc7a9b71bd899ce8f3bba74a33a56069e9597 =



Test Regressions
---------------- =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
imx6ul-pico-hobbit  | arm   | lab-pengutronix | gcc-10   | imx_v6_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/631608166c4350867c355643

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
94-gf3fbc7a9b71b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
94-gf3fbc7a9b71b/arm/imx_v6_v7_defconfig/gcc-10/lab-pengutronix/baseline-im=
x6ul-pico-hobbit.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631608166c4350867c355=
644
        failing since 19 days (last pass: v5.19.1-1157-g615e53e38bef5, firs=
t fail: v5.19.1-1159-g6c70b627ef512) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
qemu_mips-malta     | mips  | lab-collabora   | gcc-10   | malta_defconfig =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/631605e437700367c1355647

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: malta_defconfig
  Compiler:    gcc-10 (mips-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
94-gf3fbc7a9b71b/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
94-gf3fbc7a9b71b/mips/malta_defconfig/gcc-10/lab-collabora/baseline-qemu_mi=
ps-malta.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/mipsel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631605e437700367c1355=
648
        new failure (last pass: v5.19.4-233-gb132f8879934e) =

 =



platform            | arch  | lab             | compiler | defconfig       =
    | regressions
--------------------+-------+-----------------+----------+-----------------=
----+------------
r8a77950-salvator-x | arm64 | lab-baylibre    | gcc-10   | defconfig       =
    | 1          =


  Details:     https://kernelci.org/test/plan/id/631607221fc8a26f7c35565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
94-gf3fbc7a9b71b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.19/v5.19.4-2=
94-gf3fbc7a9b71b/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-salv=
ator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/631607221fc8a26f7c355=
660
        new failure (last pass: v5.19.4-233-gb132f8879934e) =

 =20
