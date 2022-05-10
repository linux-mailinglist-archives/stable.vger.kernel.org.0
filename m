Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB6A8521233
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 12:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239823AbiEJKbd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 06:31:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239850AbiEJKbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 06:31:31 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9F12016CA
        for <stable@vger.kernel.org>; Tue, 10 May 2022 03:27:33 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g8so14562619pfh.5
        for <stable@vger.kernel.org>; Tue, 10 May 2022 03:27:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=vNU6zYRRP1ucsQfk+qhx/ggSCJBk84AKFG6/rd7SrKw=;
        b=1nyv0EEjqBi3UhLSoxrdmC2SxiEc6Yt/fZCyIbZM94fhuuBzQBZ5JhjdVe+pYSsPKh
         KFUDDTkELfNB7qnuRYocaEx9bSkOG00G+h2zw0c9+pBK+gCPzwpa+iEJ6mLuNCivNzlY
         5h7LsTFqodtqHN7w0gU1D5D7BewE5mdwODhjrlj+G30+BP8Mee3b0kJ1Xr/5x4/khpWH
         Nlu8Rw11yeVTtEPSmJ2EHtaO+BQ4L9JG0PEBu1AcriD8LxEM3PX7as8w3CLepZNwuNvg
         iivB5lwC5ceaIWoupgHUJvF1xKM0ZMpGOZBxgopM410YnKDvwk2AdTy53dWbY1KkcuX0
         4rqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=vNU6zYRRP1ucsQfk+qhx/ggSCJBk84AKFG6/rd7SrKw=;
        b=nqufthVXFX6TsDRznfs/9fsQbgfWWHUIEAzqWDhzjbxDiL2872oWRygV3Bm/tE9xqi
         X0HQlMyfIKlgBOxDi5ACpJAiRnqqLQGOB/aJn5RDTzHW1XyOon2aS+1YzhgVfEKLQ3kT
         lEzv6UEOeXWUxAAJv1x5GKtQouIwnqKv4576y+TcaYgkldYJzf4MqAP2wsT70thOOm9p
         c5nBttfpXv342POvUnNzx72jiSOSVWBYVZAGvTW7bvKSbXpcvvjSYWPENPFd2rM1i5Jo
         vEn/hQpojRZA+7mJ+SSAaFQ6WUBne3SRoJLMTfPJExnRSx3ehU7Mgfavi85C7awnlvNY
         b/qA==
X-Gm-Message-State: AOAM530R2YSUvhmcS0xUt5rRFOVc5lHbm2BU8bxPxXmmAUT6p3WmYSEN
        FDVNavkeWyUu+1p8uH/wVb5wWjkJvBstHlLpRrY=
X-Google-Smtp-Source: ABdhPJwztS+tPg+fQnGU28gEYi8JPPYDQlFH6lry572nVDfXTPAccpU38ej3g+NOuzEEKgpGUd0EGA==
X-Received: by 2002:a05:6a00:8ce:b0:510:9298:ea26 with SMTP id s14-20020a056a0008ce00b005109298ea26mr14304254pfu.55.1652178452855;
        Tue, 10 May 2022 03:27:32 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9-20020a1709027c0900b0015f086e4aa5sm1592750pll.291.2022.05.10.03.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 03:27:32 -0700 (PDT)
Message-ID: <627a3e14.1c69fb81.d6577.3eff@mx.google.com>
Date:   Tue, 10 May 2022 03:27:32 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.37-280-gbc585cada83d
Subject: stable-rc/queue/5.15 baseline: 172 runs,
 2 regressions (v5.15.37-280-gbc585cada83d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.15 baseline: 172 runs, 2 regressions (v5.15.37-280-gbc585=
cada83d)

Regressions Summary
-------------------

platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig=
 | 1          =

r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.37-280-gbc585cada83d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.37-280-gbc585cada83d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      bc585cada83d9ccb61706f93d0a4808781726096 =



Test Regressions
---------------- =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
beagle-xm           | arm   | lab-baylibre | gcc-10   | omap2plus_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/627a0ceb0c0adbca958f571e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
280-gbc585cada83d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
280-gbc585cada83d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a0ceb0c0adbca958f5=
71f
        failing since 40 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =



platform            | arch  | lab          | compiler | defconfig          =
 | regressions
--------------------+-------+--------------+----------+--------------------=
-+------------
r8a77950-salvator-x | arm64 | lab-baylibre | gcc-10   | defconfig          =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/627a0c00b774b2bdd58f5748

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
280-gbc585cada83d/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.37-=
280-gbc585cada83d/arm64/defconfig/gcc-10/lab-baylibre/baseline-r8a77950-sal=
vator-x.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220506.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/627a0c00b774b2bdd58f5=
749
        failing since 5 days (last pass: v5.15.37-174-g3e309972807a, first =
fail: v5.15.37-177-g7b6e96fc83bc) =

 =20
