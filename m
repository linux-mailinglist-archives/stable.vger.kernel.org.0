Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAA76552455
	for <lists+stable@lfdr.de>; Mon, 20 Jun 2022 21:00:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236360AbiFTTAM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jun 2022 15:00:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235833AbiFTTAL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jun 2022 15:00:11 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D51EBCBB
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:00:11 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id y13-20020a17090a154d00b001eaaa3b9b8dso11132773pja.2
        for <stable@vger.kernel.org>; Mon, 20 Jun 2022 12:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=t5oS4qrj7bq5XPOZWKVUyItdz4fuJRpellaA1qbyGQQ=;
        b=EI6Ka1IgHaH8rT8g4tMkmcJjsiKRueIEUPEgJDTn942r4OcAl0bkLXANRMP95O3jn9
         n16tVg9s70peaEDlTI+6RlDblzYZeIr/MFbjypZ/w+MdsKmI4/g5OFAH2snIYKzPLeFD
         tWcww9rx+1pNFFZDjhy2agGplyVj8ihXLJv1CF3T3Bk6dmq1+RWPZt9i/QSzjYfov2zf
         h25Yrfee0PWH2KzSoXo2NSIBhvAUS43jPQUPW3ydCaS8p1PnPTwI9GNtOUkrsM9OY651
         CJ9HGk/Pz8QQH5keQ/q5O58+NDfUIlMrLP/3FHObvm33EU3CaWbsboP9X0a3k8ozm16S
         pzPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=t5oS4qrj7bq5XPOZWKVUyItdz4fuJRpellaA1qbyGQQ=;
        b=MxPHlxandbyfpEgiyz1CCLGfY1ZW1J/VVBFSIGHa3nCTJgmPA10yrZD2e6zd1B6mdI
         ohflElJJQnmBgmMZTWAoh3BeOH8T98BwasNzKdllSphMRtKXuYSSoO+czb1LwwqYMeO1
         jEhdv5omgucgl5wx59Oid3OK6jbhf0YrWreZBIuzRNxFct52te5JKRj8qrsCPhy672+U
         p1BL5y7CyV++EKdN4v0U9zJBv9d1k6SdEMIVv9PNKAF59uJO7zQqq3OJFzmPHJkU9w6U
         8Rff8m1viNznLas5WNcXXCfLb5rVpNEfTzQqLc9fnmxTJYmM1KDx5MV3FcIcCfQHUhPt
         90vg==
X-Gm-Message-State: AJIora8iKehXvkoF8UT5UFNNdGxMPzhOcDXLmiaiAwIbFIQHkg7yhfAs
        w8BItiJZz6RFiVHkOmih/xYqeK8kf4aAfXflCnA=
X-Google-Smtp-Source: AGRyM1u6SUTfoXxheSSikLo3gAsAXcWAuHhTcXdSqIzNYXsALCx6fitWoruZCCsRIEFDWI1whlIUuA==
X-Received: by 2002:a17:90a:760e:b0:1ec:83e0:3ae1 with SMTP id s14-20020a17090a760e00b001ec83e03ae1mr17523765pjk.25.1655751610664;
        Mon, 20 Jun 2022 12:00:10 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d6-20020a170902654600b00163c0a1f718sm8978172pln.303.2022.06.20.12.00.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jun 2022 12:00:10 -0700 (PDT)
Message-ID: <62b0c3ba.1c69fb81.6b6e1.c5de@mx.google.com>
Date:   Mon, 20 Jun 2022 12:00:10 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5-142-g1cf3647a86ad5
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 174 runs,
 1 regressions (v5.18.5-142-g1cf3647a86ad5)
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

stable-rc/linux-5.18.y baseline: 174 runs, 1 regressions (v5.18.5-142-g1cf3=
647a86ad5)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.5-142-g1cf3647a86ad5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.5-142-g1cf3647a86ad5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      1cf3647a86ad5204a01c7495a62a13d07f02d51c =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62b09985aca985c972a39bd9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-142-g1cf3647a86ad5/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
-142-g1cf3647a86ad5/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson=
-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62b09985aca985c972a39=
bda
        failing since 7 days (last pass: v5.18.2-880-g09bf95a7c28a7, first =
fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =20
