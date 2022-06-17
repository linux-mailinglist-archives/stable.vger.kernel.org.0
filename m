Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA6954FC96
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 19:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383354AbiFQR4K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Jun 2022 13:56:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383446AbiFQR4I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Jun 2022 13:56:08 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683CE4F9E2
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 10:56:05 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id a17so2513540pls.6
        for <stable@vger.kernel.org>; Fri, 17 Jun 2022 10:56:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=81z0utBi6yIB/MKOIvJASGOp/IffL0+aFKjqg8ThkjA=;
        b=ZKUjvQ3naeSz/t7Lvk2r2zyPurV1wreICkBYLUptOctl17K62NVy9/In6Z+X+cq5i5
         YNJ6CcVDjyNReuBHvyyEUmJOxOl+FWNYPIwVj7T2rjHR/BxdL1ip63q4ne0KcbqnD12k
         LhBkrr4HO3BDuoO2HuLEQ0xlj7fcfpKRz2RuLbazN7uOzRqgBpwubvSkNEzM7CE+a4el
         v6pnMkIpD5IduxHdvAo09E2xLZOEFQZP1FLxe349oo0MQjeENlNFzDGO53f8wDTsGZG9
         Yto9KXpgKSh4IYEDRHqTBOg/YJl/4YFlDheC9tgYiL2lyw7OLh/PBynNcV0u9FOUl5De
         5d1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=81z0utBi6yIB/MKOIvJASGOp/IffL0+aFKjqg8ThkjA=;
        b=fKXXUTBkITTbCy/8CdQcBkacwhcF2y5sYKiJrVbt+hS3V6gu6F0O4Rt61kTZCUJTk3
         5fOcuQLcBXatMZsgvdQkf1Fow0eW9tvaFpRE1ZPnx9a+XuvwVwbA9pOUGOTVEYHpuVzX
         DLjY3/iFwhtnJBIEGwYTOoQJ8GzR97O6N1Q0aeOjT4PD3Z0VPbydKkdVk/kQB7WdHTFx
         EfzvPHns9tbPx04lbXuQgtXrSANx1HC/+ln2yE09aJpRMHX18bJPV5Y6oP7Ojvx0HXPP
         gsmqzi/3uZ1k3FSiSgEXnjCwHgq7JBRxJ6fvi3v1fKhAU+XA6fPfvT9ZTH6vKSFsOZYF
         ZcWA==
X-Gm-Message-State: AJIora/+up2V1LvQP5NzpwqrzcxqqKwuZzoh3XKc2jU70pDBbEpv4lSH
        G2JdsgndKUUrCxDYf9KlHgVCPIVP51nYEavwAAI=
X-Google-Smtp-Source: AGRyM1tQPxnKugZn4F8FDGobbHpbVtxaOeOPjXvh9GXKGjYBzdfHDrgdDV8lJ+caq60Ant3cBU6Qbg==
X-Received: by 2002:a17:902:e84b:b0:164:8ba3:9cd9 with SMTP id t11-20020a170902e84b00b001648ba39cd9mr10717770plg.49.1655488564760;
        Fri, 17 Jun 2022 10:56:04 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id h189-20020a62dec6000000b0050dc762813csm4050556pfg.22.2022.06.17.10.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jun 2022 10:56:04 -0700 (PDT)
Message-ID: <62acc034.1c69fb81.72126.5c22@mx.google.com>
Date:   Fri, 17 Jun 2022 10:56:04 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-4-g941f74bf03b86
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 146 runs,
 2 regressions (v5.18.5-4-g941f74bf03b86)
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

stable-rc/queue/5.18 baseline: 146 runs, 2 regressions (v5.18.5-4-g941f74bf=
03b86)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18.5-4-g941f74bf03b86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18.5-4-g941f74bf03b86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      941f74bf03b865871757bd36c5d680f8528b23aa =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ac8ae4dfd678622ea39bdb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-g941f74bf03b86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-g941f74bf03b86/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ac8ae4dfd678622ea39=
bdc
        failing since 6 days (last pass: v5.18.2-866-g0f77def0f4d00, first =
fail: v5.18.2-1057-gd2f82031e36a5) =

 =



platform          | arch | lab           | compiler | defconfig          | =
regressions
------------------+------+---------------+----------+--------------------+-=
-----------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | multi_v7_defconfig | =
1          =


  Details:     https://kernelci.org/test/plan/id/62ac98a819f051dec8a39be2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-g941f74bf03b86/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18.5-4=
-g941f74bf03b86/arm/multi_v7_defconfig/gcc-10/lab-collabora/baseline-tegra1=
24-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ac98a819f051dec8a39=
be3
        new failure (last pass: v5.18.2-1057-gd2f82031e36a5) =

 =20
