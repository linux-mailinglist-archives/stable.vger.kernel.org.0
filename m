Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC9C5470B1
	for <lists+stable@lfdr.de>; Sat, 11 Jun 2022 02:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242861AbiFKAv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 20:51:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238092AbiFKAv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 20:51:56 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F24640F
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 17:51:54 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so845828pjb.3
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 17:51:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=ViU/gjvZzVw7kUVza478tcNfl/NOz7M4aXyNFJyQufg=;
        b=nf8E3sS5TBq9Dq0niRMIrR6PPGshxx/zMy7n4HseqwKFo45clcEjdOk39MpKxxZFwj
         E/Pfq1x7CAnio5pmukKSk1Vvy3iXOkJx+Ecj3km5+Gs42OwQjUODmUAnUMyOKxwuVcS6
         DF4Nrz1tvKybIO+QbD8HOk54CHdSAqjsaNvsx0iBwaU+TIcYvzdQDv4aBzt6EJsNgTOy
         7Vuxn/QkmcA68afTMeFdYDREB/eXib5GuunDHxfJnOh+fLd3H6FjfAezXVJRVDH7heQw
         q0l4BXoL0uRNbzmbf3maQtz87StKiLpr+bXUR0S08DajjHfLF+PmFYIbn0+LsNr6Cgbk
         dxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=ViU/gjvZzVw7kUVza478tcNfl/NOz7M4aXyNFJyQufg=;
        b=PtqMU8ukRWTluG4g8W4DIMkDCSo2TXRQ3dSzmkwVbIY7mhF+FM43EMhPqWH+C3JZxf
         gLh24CmK1/T3QKszRHccTEzqJFPNsZBCQjD/zvdQlFu/cozE1aij3EBFqceLDl2E9Ad0
         vGf/LuEyc6CsukdeHnUNblvQ5l+/cXz5GlJJa4Oe8vj3fSKRChRSLdJxs8JtANFbDYaV
         fOFjmV8SlZLmsL4I1tBU+7d6mazurEUMwLkbWoy/GCIPIlZGFa+BZWr+GRqGT6oJQB8V
         8Y6vcvFN9+23VBYP9suQ+O8G1qHovsBxzymMRUeZqQG5MClPG1SwSbkMaiynJ6pecBFg
         vEig==
X-Gm-Message-State: AOAM530xbR0BG8UVegZwhb5ifoRa/8468Nxi4seAAPp2x1YLfp/EtSFY
        uJw4c4TeJ4WcDZ1Gjb8JW4VrDUdDSQkS36CW/ro=
X-Google-Smtp-Source: ABdhPJwpWJ657Dwj/YHVmB/5zvp2Dg6BD9orDpAHcNON8+O9gAhs+edE+mYULWE2qAhbu/hhykGT6w==
X-Received: by 2002:a17:902:ecc1:b0:167:74c3:55b1 with SMTP id a1-20020a170902ecc100b0016774c355b1mr30433564plh.108.1654908713812;
        Fri, 10 Jun 2022 17:51:53 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u17-20020a62d451000000b0050dc762812csm191892pfl.6.2022.06.10.17.51.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jun 2022 17:51:53 -0700 (PDT)
Message-ID: <62a3e729.1c69fb81.760cd.0518@mx.google.com>
Date:   Fri, 10 Jun 2022 17:51:53 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13-928-gfe5fcee7b41f8
X-Kernelci-Branch: queue/5.17
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.17 baseline: 166 runs,
 4 regressions (v5.17.13-928-gfe5fcee7b41f8)
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

stable-rc/queue/5.17 baseline: 166 runs, 4 regressions (v5.17.13-928-gfe5fc=
ee7b41f8)

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

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.17/ker=
nel/v5.17.13-928-gfe5fcee7b41f8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.17
  Describe: v5.17.13-928-gfe5fcee7b41f8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      fe5fcee7b41f8a5559e1a536a08323eb621400ec =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a3cf59cae48f37aba39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jets=
on-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3cf59cae48f37aba39=
bda
        failing since 15 days (last pass: v5.17.11-2-ge8ea2b4363353, first =
fail: v5.17.11-110-g77c86f3d903a) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a3d12a7f0e2808f5a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3d12a7f0e2808f5a39=
bce
        new failure (last pass: v5.17.13-907-ga980fa631e355) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a3d7d339eff5a5e1a39c29

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-teg=
ra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3d7d339eff5a5e1a39=
c2a
        failing since 14 days (last pass: v5.17.11, first fail: v5.17.11-2-=
ge8ea2b4363353) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig    | =
1          =


  Details:     https://kernelci.org/test/plan/id/62a3df42e6f29a3710a39c3f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.17/v5.17.13-=
928-gfe5fcee7b41f8/arm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62a3df42e6f29a3710a39=
c40
        failing since 3 days (last pass: v5.17.13-759-gf64e250b75652, first=
 fail: v5.17.13-771-g1bf589e90ab9c) =

 =20
