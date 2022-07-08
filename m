Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7D756C376
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 01:14:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiGHXCB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 19:02:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43062 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232561AbiGHXB7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 19:01:59 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8A3D371BD
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 16:01:58 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id o15so298648pjh.1
        for <stable@vger.kernel.org>; Fri, 08 Jul 2022 16:01:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=/Se4DS1M11TYTJ4DYR9Lc+38Iuxrp9Egi1rtW5NPSyY=;
        b=GGud/JBieHx27ehWIcTJXF0ZYlDa+Z+jqmTIAQlpsMfjKwJ8/bjgoEil1tcrSQzRJb
         qRO2FOvpZ5YspE2M0ERqHKHtsmlKzGK09cJSJnWMtQ/049al9pH4Bdl0RcVOATqZlTv5
         9NA4M5eV8zxFhw87QJPl4GBF55l3JVgpZeBr7dYnC7Zc/llf3/d+7CU5uyo2FuMqSchA
         bxB+5FdxcA3z+M81TazNOFHpNeTBemlcuWd6eN0s2bJGyxsdKkwyt+SPZLfesEHYlAsE
         j1Ag8iHjNkhNWZVjzBKXslijGJgdd21Qc6ZoxIEtz98cWtVpWv6dXPQDECWlL994h/ZM
         DgQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=/Se4DS1M11TYTJ4DYR9Lc+38Iuxrp9Egi1rtW5NPSyY=;
        b=sXW3waHkiIG3YnN15KY5a9Fp+Wx5mTT6SBh/tohQPVyU0VcqAnAYRQddbEw15nuU7Y
         iH8Ne3SUvKOQokuWsX5lUvR9WiRZ3rR/1HlhLJlm28hui4P4U0sA1kGIzPGkmedAza48
         MwgBqRFUzgu5gmXxmHPJaFmLqR/LBSVDC7L6311rlKDCBqhkKp4A8wlIy6VaE+gboLyS
         dgLI0m58w8FiZa+4mC7VUFCFg2fnCrUOboSbYqGhFsuGst/WPXMDJtpMK303Jcbs/Ub+
         skC7JvYtUQlDYhVZZp2/bpcYGM14Aja+gp/lt7QqKPyPKGDGg5IF9OZE/Z0BgrkdrTv6
         wkYA==
X-Gm-Message-State: AJIora8EF8Mjd0jZ0rkOdjUzceR7d+yr7CelgqljN/zlP9ElfSzizp/D
        Dsl9eW+VyhgZvQSiTrjiA9frlW/tou5dqm9r
X-Google-Smtp-Source: AGRyM1uc33Zvbulgn+71kDshwCDzy4r87Sgmk48Dmec9I9cPHkxNgtsqRVklZoOokZEICBKinpnNTA==
X-Received: by 2002:a17:90b:1d84:b0:1ed:5918:74e3 with SMTP id pf4-20020a17090b1d8400b001ed591874e3mr2366031pjb.173.1657321318275;
        Fri, 08 Jul 2022 16:01:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id o17-20020a170902d4d100b0016bd8a76f5fsm55733plg.137.2022.07.08.16.01.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 16:01:57 -0700 (PDT)
Message-ID: <62c8b765.1c69fb81.48b68.01f1@mx.google.com>
Date:   Fri, 08 Jul 2022 16:01:57 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.53-19-g8d59fcccbb45
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 110 runs,
 4 regressions (v5.15.53-19-g8d59fcccbb45)
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

stable-rc/queue/5.15 baseline: 110 runs, 4 regressions (v5.15.53-19-g8d59fc=
ccbb45)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
| 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
| 1          =

meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-10   | defconfig           =
| 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.53-19-g8d59fcccbb45/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.53-19-g8d59fcccbb45
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8d59fcccbb458851aab63cdfcc5b5a397cf197b5 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
beagle-xm         | arm   | lab-baylibre  | gcc-10   | omap2plus_defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62c880e04ed159c4b8a39c77

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c880e04ed159c4b8a39=
c78
        failing since 99 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig     =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62c87e6077e74cb2a0a39bd3

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk=
1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c87e6077e74cb2a0a39=
bd4
        failing since 4 days (last pass: v5.15.51-43-gad3bd1f3e86e, first f=
ail: v5.15.51-60-g300ca5992dde) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
meson-gxbb-p200   | arm64 | lab-baylibre  | gcc-10   | defconfig           =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62c885e03cc3655f8ba39c09

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxbb-p2=
00.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c885e03cc3655f8ba39=
c0a
        new failure (last pass: v5.15.52-99-g46abc1c965f7) =

 =



platform          | arch  | lab           | compiler | defconfig           =
| regressions
------------------+-------+---------------+----------+---------------------=
+------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | tegra_defconfig     =
| 1          =


  Details:     https://kernelci.org/test/plan/id/62c89665707bbc7ab7a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
19-g8d59fcccbb45/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124=
-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c89665707bbc7ab7a39=
bd5
        failing since 20 days (last pass: v5.15.45-915-gfe83bcae3c626, firs=
t fail: v5.15.48-44-gaa2f7b1f36db5) =

 =20
