Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39E1B57650E
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbiGOQD3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233537AbiGOQDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:03:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C6A753A3
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:03:02 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d10so5002613pfd.9
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=dMcPLYAZZk9H+0TYHpwnmcOBINnmeDwuPTJsk3lT58M=;
        b=RSBRIKT3DPfgMZCRwUHG8HmwPCF0bhgvhWZeLZPFCCXLZs7DwMRxRDlxjbUSEhzW1I
         ub19MtnR7ahC3YNsbq9/FF5rCs1Cs77HsADnDLclv8Vb6eVLswBU5duc4SCZ/2DEJ9AX
         sf2ixQHcUA50//Mj9mW3sWuK8dQs4cbncZpkSOa7mntdr8/btU1cO2CR3RZO6aoa1wg7
         aVDcNbzSvJY5f1viMtOB6E5f0D3ryQqSXz0qZBGvkzlJFed1VfAbgmwcYmJHHiVxozo5
         KFWbmcYbKAznK7MZS83QlyHxudofgYxN3ZgNqO/zXW8iazTTYhFqXynbBGaAEHGTYy9j
         BGYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=dMcPLYAZZk9H+0TYHpwnmcOBINnmeDwuPTJsk3lT58M=;
        b=pV6P3PNiAbxzySrqQEg5bT+lKRGSMWkKl8z5XtzfUv6vmd9XDYETE/fPhNOQ3dob4K
         oAutYZCzzzhpgS2paFY1NrHGhk46aQGY747s5pzU4CrJm2y+7mdmVzlVENRSTGvaXNx7
         e5pC/FRte0poJXmaGAy8WKNt9CrEdUPm0G2DLcwSy5MqjmKNmSvYbv/3xrQP0Bmmvkc0
         pYaQb+WAYxudIApgyVle32JqzUnjTIdOSSA1OyBXLDzWqG5x5X+vQHnDgPMe249846kz
         WVgEaIw0hVS2KSF9Qxbg+gpBfjUHYICZY3n1lfpeIi3V2w2kbK3n9Z4/2WpHJ08jH//+
         vRVA==
X-Gm-Message-State: AJIora+Yy2U81KDBy46LLjE4N2T7lAQbpUwlAccz/PWS3GlQ86Y1lGEN
        1ymIMc1GoVKDZgnVZkduyp8SZFKEUX1m1Zkb
X-Google-Smtp-Source: AGRyM1vudgqcd3HwJzeT7o7CwWIrQleO9Ee49HCn5o16AlqSPpHL/vHLGWHaTB15NA++7i6clYFHTA==
X-Received: by 2002:a05:6a00:168a:b0:4f7:e161:83cd with SMTP id k10-20020a056a00168a00b004f7e16183cdmr14569874pfc.56.1657900982122;
        Fri, 15 Jul 2022 09:03:02 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e29-20020aa7981d000000b0052ab54a4711sm3995587pfl.150.2022.07.15.09.03.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Jul 2022 09:03:01 -0700 (PDT)
Message-ID: <62d18fb5.1c69fb81.33a47.6551@mx.google.com>
Date:   Fri, 15 Jul 2022 09:03:01 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.131
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 74 runs, 1 regressions (v5.10.131)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 74 runs, 1 regressions (v5.10.131)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.131/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.131
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      8f95261a006489c828f1d909355669875649668b =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig       | regressions
-----------+------+--------------+----------+-----------------+------------
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/62d15c04df50c440e4a39bf6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
31/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62d15c04df50c440e4a39=
bf7
        failing since 38 days (last pass: v5.10.118-218-g22be67db7d53, firs=
t fail: v5.10.120) =

 =20
