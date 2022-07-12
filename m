Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C217571B9F
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 15:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233327AbiGLNpK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 09:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34262 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233326AbiGLNpE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 09:45:04 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1CA287F50
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:44:59 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y141so7517312pfb.7
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 06:44:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JOOpx62iyKgfKuCaeGGWW61ZmcDmvKSon21FI//HLh8=;
        b=WWOvgsteTYeQNuLmpkoHu+QAjWb8bLqBpKnwZhCg30scqqLzCatE7Ixnfqd6bzadfh
         YDBJcr8u0cc9t2fYyt1amYM2KNHQ0CL2mFwDmiXaJxBCJ5qmHM4gOnkrxVWCPOZ+4e8m
         IT3c4wq9JvqqutDSf7PcxSWhEKVQzGn59GtWs7pQiQCMaRRWC7e/C61cNAFYHptcoqhp
         m30oLCxCOo3BmKqvjVSp93EnaKiQeSXaMX0NQRV9y5Z7goLZ6JYSF7WzEC77kci3ugnZ
         oqk+7txXPplBU7tylm5Zy7CavMZ3OI1EAzVNTLUivYz+LiUjYB0zj3Br1OJgEKaVFlfX
         O8JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JOOpx62iyKgfKuCaeGGWW61ZmcDmvKSon21FI//HLh8=;
        b=DiZhhp3h93461xtYQ/fY4inLiZXl0QIDKwabzVzTsFRB54GdGmi1OTTAosgblCqx1M
         3iTbQWFP2IQYYBVXHCmSKoOmUYNqNEmZ46W3orq17VsrCoC+N0NjQJI7qlnUIaOHTtu7
         XDqx7i2OGv7/wjrUhgs12eISvMuDyVfSyCbqWUnLWMeoiOnhnMQb5MnAa09UzmZoLQD+
         Hl8hq72aGEmCQZJaoWd0tu2vtq84wJu84kYTjVGLKXCjqZTkPTvGtph2O4gl03snWIM6
         6IuUl9xr9Sx8J8rCAUhFEog0QBMmNtdVBfRTSYbFpty71piXqdr6DJhQkwoDBr706STN
         Rl6A==
X-Gm-Message-State: AJIora86nQUV843qzZRZOoXD5PsJNzsLhQmp01lNRbetImIOMPYqDSSZ
        cLKzmj3223E3IkvgulXaIj9KQeZ26UXLH6lh
X-Google-Smtp-Source: AGRyM1taHBGHuElu+vXulIMOK+7TfGtT7Bm5W83YbCxPs4xPNZAAULVoA4+NQ+u+4FYqCkw0KX84eg==
X-Received: by 2002:a05:6a00:1590:b0:52a:eb00:71dc with SMTP id u16-20020a056a00159000b0052aeb0071dcmr2621658pfk.64.1657633498426;
        Tue, 12 Jul 2022 06:44:58 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y11-20020a62ce0b000000b0051b32c2a5a7sm6741304pfg.138.2022.07.12.06.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 06:44:58 -0700 (PDT)
Message-ID: <62cd7ada.1c69fb81.2bcc.9cb5@mx.google.com>
Date:   Tue, 12 Jul 2022 06:44:58 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.53-227-g71721f5974f2
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.15.y baseline: 136 runs,
 5 regressions (v5.15.53-227-g71721f5974f2)
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

stable-rc/linux-5.15.y baseline: 136 runs, 5 regressions (v5.15.53-227-g717=
21f5974f2)

Regressions Summary
-------------------

platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
at91sam9g20ek     | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig  |=
 1          =

fsl-ls1046a-rdb   | arm64 | lab-nxp       | gcc-10   | defconfig          |=
 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig |=
 1          =

jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig    |=
 1          =

tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.53-227-g71721f5974f2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.53-227-g71721f5974f2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71721f5974f244f7563d10b616528059705e6237 =



Test Regressions
---------------- =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
at91sam9g20ek     | arm   | lab-broonie   | gcc-10   | at91_dt_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd425ba30ad26d11a39bcf

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: at91_dt_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/at91_dt_defconfig/gcc-10/lab-broonie/baseline-at91s=
am9g20ek.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd425ba30ad26d11a39=
bd0
        new failure (last pass: v5.15.53) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
fsl-ls1046a-rdb   | arm64 | lab-nxp       | gcc-10   | defconfig          |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd4626e0467d9e47a39c02

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1046a-rdb=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm64/defconfig/gcc-10/lab-nxp/baseline-fsl-ls1046a-rdb=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd4626e0467d9e47a39=
c03
        new failure (last pass: v5.15.53) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd52fb759be4a7daa39c0a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jet=
son-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd52fb759be4a7daa39=
c0b
        failing since 14 days (last pass: v5.15.48-116-gadd0aacf730e, first=
 fail: v5.15.50-136-g2c21dc5c2cb6) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
jetson-tk1        | arm   | lab-baylibre  | gcc-10   | tegra_defconfig    |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd50ca7b8e20277ea39bde

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd50ca7b8e20277ea39=
bdf
        new failure (last pass: v5.15.53) =

 =



platform          | arch  | lab           | compiler | defconfig          |=
 regressions
------------------+-------+---------------+----------+--------------------+=
------------
tegra124-nyan-big | arm   | lab-collabora | gcc-10   | multi_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62cd6e9b3192927bd8a39c3d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.5=
3-227-g71721f5974f2/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-te=
gra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd6e9b3192927bd8a39=
c3e
        failing since 47 days (last pass: v5.15.41-133-g03faf123d8c8, first=
 fail: v5.15.42) =

 =20
