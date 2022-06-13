Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC17B549D73
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:21:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349107AbiFMTVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:21:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348817AbiFMTVc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:21:32 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F68527EE
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:21:47 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id h192so6128253pgc.4
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 10:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=gDO8HVUeSQxDFKDfOL7wbG9iI9zS1HTvJZhSZh6hVj4=;
        b=uw3wexldyESepJ/Y8yWpW7Nl6vq2wCFRCitRNEJG8GI3rwilRnavS0PmqII2BwVfKf
         uVwVcfkt5Xyobzoni963TRJGmsAXyEGON4r3YMUWkxf0aC90PfcVMT5rUUwCXHMYW9N9
         Xd4K9ew4PacXu4r5zExb2z4uGNRDk1SlNWA97d4QlfNCFJIRwB5dxmjuk8Kno89YyPF5
         e88m02uPuNbWBppisHbAYCcybTdx0Usvc8koZe8ZM9fd6/VWxLsFYHoJ0sYYwMbJb2Vl
         Y1By8hc5qYrhUmQsUc/X88fgvDMEn3EnDlkGTRgBIn++fKhcvrv9gXQweQ+6TN69alp5
         zXDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=gDO8HVUeSQxDFKDfOL7wbG9iI9zS1HTvJZhSZh6hVj4=;
        b=U+Bt+R2OwyH42JBem7Wd269LtmpLBkFAasHvLcAhq0O7k5GbAur4/ON4SfjPKFkTXq
         1fKwbMNyogkpyqU1bAeL46nH6NoD0+9bbNhsTGktMoXBHfleCV02hBa4E1NGLgjMLsGa
         D1aOw5Aa8lywalSKI6WVEk5gCqsPNulkY2iXpNzzjM3A4Yl4wMRteUyiMJgbqRERk+Gr
         Vci/JtdV0HcO9dKeiKR7wDCfKpgMaXzwUfoMrX7haDyM4iYhh/ShP/2gvXzztWydxLnO
         Pefm4K3EPs+04n6mvZA07foVAiD/AvfvAEXiX+hNiid7Ngbfr6MRD1EddIaR8HyJUGim
         9sPQ==
X-Gm-Message-State: AOAM530NZRz6bDiNmIBxcWsdbKWchcjgXqebMlns9DTt3EAmyN/v6q75
        ah6lC1exn7fLxlZZNW+0R3uQKuCfqax2UdGN000=
X-Google-Smtp-Source: ABdhPJyhJhYSyaPdVyCy4dOe/sOEviYIFj71KbG3Vi/kjsJ07OWcMY3CXtKDsytb9fv6SRC4NPXgQw==
X-Received: by 2002:a05:6a00:170b:b0:51b:d1fd:5335 with SMTP id h11-20020a056a00170b00b0051bd1fd5335mr273797pfc.28.1655140906620;
        Mon, 13 Jun 2022 10:21:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z10-20020a62d10a000000b0051f2b9f6439sm5864207pfg.14.2022.06.13.10.21.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 10:21:46 -0700 (PDT)
Message-ID: <62a7722a.1c69fb81.1efc2.6b51@mx.google.com>
Date:   Mon, 13 Jun 2022 10:21:46 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-1071-gfcf11988907a1
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.17.y baseline: 185 runs,
 3 regressions (v5.17.13-1071-gfcf11988907a1)
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

stable-rc/linux-5.17.y baseline: 185 runs, 3 regressions (v5.17.13-1071-gfc=
f11988907a1)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.17.y/ker=
nel/v5.17.13-1071-gfcf11988907a1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.17.y
  Describe: v5.17.13-1071-gfcf11988907a1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fcf11988907a1cf736a2e7a87c75fcbff0a3ece5 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a744b45dfd556b83a39bf7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1071-gfcf11988907a1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1071-gfcf11988907a1/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-j=
etson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a744b45dfd556b83a39=
bf8
        failing since 18 days (last pass: v5.17.10, first fail: v5.17.11) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a74530cf80feb683a39be0

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1071-gfcf11988907a1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1071-gfcf11988907a1/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a74530cf80feb683a39=
be1
        failing since 9 days (last pass: v5.17.11, first fail: v5.17.11-188=
-g30200667e8235) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a7610d4eb041ad47a39cbc

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1071-gfcf11988907a1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.17.y/v5.17.1=
3-1071-gfcf11988907a1/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-=
tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a7610d4eb041ad47a39=
cbd
        failing since 18 days (last pass: v5.17.8-115-g3f3287e397412, first=
 fail: v5.17.10) =

 =20
