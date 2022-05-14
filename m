Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E2526F42
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 09:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiENBW5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 21:22:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbiENBW4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 21:22:56 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0449508F0C
        for <stable@vger.kernel.org>; Fri, 13 May 2022 17:52:47 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id d17so9484867plg.0
        for <stable@vger.kernel.org>; Fri, 13 May 2022 17:52:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KKNcCPWeL4caRfiWcgJJoslef9lbN5laSjeSMwTHRaU=;
        b=VnOQ00wLCoNBhkbpyV5nL2KVEX7MKnaYbI8FKyjf1KEeoWPVI/fSGEHgnKcIMnvP7W
         At0yRiTf5gTvq4PLdNvgzuIULI2xVcoSIMVShFFSbMgEbmdWCVBMic4l6SAgKiggml3q
         EPIYa4sZNN2wgIyYxtEGjT2+voFstsN3VlEPZtt0XJ+3QmLpt7On6iTuQOwFrimb19Qv
         0fKE0y/ieMc9A3d8OTEVvKCLraYU0z4IGQ7FVifH1b/gPtTKQsB/xKfqL6gZHawZkJQP
         4bcdHZRIv7VDkf5LD4HohmQ/bK6jYpP9KwfSMZdo4qGSTT22lSQ7NU/miTjzK5Rn5ZXg
         QN+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KKNcCPWeL4caRfiWcgJJoslef9lbN5laSjeSMwTHRaU=;
        b=EsTInqeCWL4+BtGwWgNqHCZ/VkvSkB+wCE7D+E7QP9ej9W9HkRtcOWWDotjfhbvK/8
         HagOFwcgke2/nhqaLhrxlh9yK/jCg0b0DeRoGO10DoXhO23NyWSHTXsOATdKqw2XPviW
         XQs4rTDcXjjJjys1VbYK5hXwI94oj4PNLADSD6tdEu/BGCliIITOTLxktlxSyRBaJVx9
         ZKON0AfdaN2SAmq7Q4j51DPWHB8syMwcPm3Au61VVtFAFU3lXM8OIzgfb0NTXNiUROt7
         wRIrXAHRnx9uDVNxbEaafiX7+838FfroeD1qGpLEDNErHqsAYJ0h5rVTiL6+NF0DUi9y
         d7qQ==
X-Gm-Message-State: AOAM530WMJN7sM+cDwKtfJae6erDO6kmPLatdgx7vDf4xS8W9dqoDr8L
        reiYLtIiPnqboqE9rCEWuDPzh3H7ZBBUrloFKTk=
X-Google-Smtp-Source: ABdhPJwCDcJjwgpkZn+K9Q5ROHCY4OWCgADGBRFhKPp/DQ1owNiSGWQHQX2tiZ87XPGP77h54HREOA==
X-Received: by 2002:a05:6a00:26c3:b0:50d:d619:e4c6 with SMTP id p3-20020a056a0026c300b0050dd619e4c6mr6931718pfw.13.1652488654649;
        Fri, 13 May 2022 17:37:34 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x2-20020a170902820200b0015e8d4eb298sm2384937pln.226.2022.05.13.17.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 May 2022 17:37:34 -0700 (PDT)
Message-ID: <627ef9ce.1c69fb81.1d7a0.694b@mx.google.com>
Date:   Fri, 13 May 2022 17:37:34 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Kernel: v5.15.39-22-g13b089c28632
Subject: stable-rc/linux-5.15.y baseline: 107 runs,
 2 regressions (v5.15.39-22-g13b089c28632)
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

stable-rc/linux-5.15.y baseline: 107 runs, 2 regressions (v5.15.39-22-g13b0=
89c28632)

Regressions Summary
-------------------

platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =

sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.15.y/ker=
nel/v5.15.39-22-g13b089c28632/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.15.y
  Describe: v5.15.39-22-g13b089c28632
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      13b089c28632ad5a051bdbb1951ee189f96b01fd =



Test Regressions
---------------- =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
beagle-xm               | arm   | lab-baylibre | gcc-10   | omap2plus_defco=
nfig | 1          =


  Details:     https://kernelci.org/test/plan/id/627ec64ff0027370cf8f5781

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9-22-g13b089c28632/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9-22-g13b089c28632/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ec64ff0027370cf8f5=
782
        failing since 1 day (last pass: v5.15.37-259-gab77581473a3, first f=
ail: v5.15.39) =

 =



platform                | arch  | lab          | compiler | defconfig      =
     | regressions
------------------------+-------+--------------+----------+----------------=
-----+------------
sun50i-a64-bananapi-m64 | arm64 | lab-clabbe   | gcc-10   | defconfig      =
     | 1          =


  Details:     https://kernelci.org/test/plan/id/627ec4fdbb2cfc49918f571a

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9-22-g13b089c28632/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.15.y/v5.15.3=
9-22-g13b089c28632/arm64/defconfig/gcc-10/lab-clabbe/baseline-sun50i-a64-ba=
nanapi-m64.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627ec4fdbb2cfc49918f5=
71b
        new failure (last pass: v5.15.39) =

 =20
