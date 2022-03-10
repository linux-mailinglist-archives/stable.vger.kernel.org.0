Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEE944D3F86
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 04:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234157AbiCJDK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 22:10:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233576AbiCJDK1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 22:10:27 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4387C152
        for <stable@vger.kernel.org>; Wed,  9 Mar 2022 19:09:26 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id p8so3957590pfh.8
        for <stable@vger.kernel.org>; Wed, 09 Mar 2022 19:09:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OGAM5N+hHrP1PXaieYXekT3aSREtzG/IvxqPAR6zUzg=;
        b=eQt7yR/PPyTXxYKa5SmGi3XwIX2xIbo9/w40slXMvPMuh9NLEcZZT9MQRuQ6fuMiEw
         qG0EGGdD1EROMyYUC3Svsf/k914voGaGkxCPtKtqOWUF6QdHvHTGE2Tk++GA6mMbOqdf
         HsY1nuQnQpFEOTBtI6izj4cMvqH0gIj3J85PFzMwkm7A8FvqJPLqb2rXsiRtG1er5dSl
         A67QXyKCCzbNDBH52jl78XhFBP2spBgvCPtBBHRuwH8iFOeS66z/PahA2gwsj6VZsYpA
         IgVU2V2VVvbfRVVATH1Wh+OqzkaPhzl1YgQYdWi0ikLyb+2E1y5sRK8062N2qpGHycP1
         Qqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OGAM5N+hHrP1PXaieYXekT3aSREtzG/IvxqPAR6zUzg=;
        b=ZUEgn5GWmnuwfT85NRleh8bjsQ6+FeSmQ9hLQu3FFGNHfgLh987TbQuXnXsU8uirhz
         VIECQ0qKKGTn8vvA4kdurDBmZz230oQ6cDY+UfoelA1tMdnbtjb/wrWJs3pX1NwMTnzc
         SN+dx7HQPgTKr4rBuyESPLvlX60YWNNxQaQQHDmIzDAe77CfS8bNvCFYkqVJxE3SGOSC
         zQ7NFuUBJMuTJ3Ht3nBiHS3JetH2syGZMb6P25eTFu7fsmIAP+iptwGu7ps8jS9eQ7w8
         345Xh6hxtxFaJ0XTOxjhaWHTMUiMkixOagq5nfFXinGfiCo4DnjmN0sUUyGfDKP+7yxK
         kGwA==
X-Gm-Message-State: AOAM530D+9+uTzmY2VMuk5MymTlwT6WXrQljdvUYZiXVzvQ/jm/CxGE6
        qlextPvIsPFMM7ekAtrTtXxJCESJhMMuktG+TdM=
X-Google-Smtp-Source: ABdhPJzELhCn/5bVzYAdzJxhKo2BfDGS2nULaSGnM/9DoMDyXDlgw4qurs57HzGs4c7v+/jxAJGz6g==
X-Received: by 2002:a63:224a:0:b0:368:e837:3262 with SMTP id t10-20020a63224a000000b00368e8373262mr2306620pgm.546.1646881765529;
        Wed, 09 Mar 2022 19:09:25 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t1-20020a634441000000b00372cb183243sm3798652pgk.1.2022.03.09.19.09.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Mar 2022 19:09:25 -0800 (PST)
Message-ID: <62296be5.1c69fb81.ae3e8.a711@mx.google.com>
Date:   Wed, 09 Mar 2022 19:09:25 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.16.y
X-Kernelci-Kernel: v5.16.13-38-g3416254dac79
Subject: stable-rc/linux-5.16.y baseline: 83 runs,
 2 regressions (v5.16.13-38-g3416254dac79)
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

stable-rc/linux-5.16.y baseline: 83 runs, 2 regressions (v5.16.13-38-g34162=
54dac79)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxl-s905d-p230    | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.16.y/ker=
nel/v5.16.13-38-g3416254dac79/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.16.y
  Describe: v5.16.13-38-g3416254dac79
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3416254dac79ea26e08dffde371ab1fd3130223c =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
meson-gxl-s905d-p230    | arm64 | lab-baylibre | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/622933e208267b87e3c629ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-38-g3416254dac79/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-38-g3416254dac79/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s=
905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622933e208267b87e3c62=
9ee
        new failure (last pass: v5.16.12-185-gc596a0efed21) =

 =



platform                | arch  | lab          | compiler | defconfig | reg=
ressions
------------------------+-------+--------------+----------+-----------+----=
--------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/62293283af739a06cac6299b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-38-g3416254dac79/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.16.y/v5.16.1=
3-38-g3416254dac79/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62293283af739a06cac62=
99c
        new failure (last pass: v5.16.12-185-gc596a0efed21) =

 =20
