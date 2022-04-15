Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8A81501F5B
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 02:01:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347797AbiDOAEC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 20:04:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240890AbiDOAEC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 20:04:02 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1002158815
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 17:01:36 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id g12-20020a17090a640c00b001cb59d7a57cso6753649pjj.1
        for <stable@vger.kernel.org>; Thu, 14 Apr 2022 17:01:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=MAzyj4mSas/HyDATz1l1gBYis9gkD8QW0DKS7LUEaGE=;
        b=UgkporGAHdSIevTD9A8DqSvNdmnEDPMXutgkDp5I2IIaDhgsIJ14UJEgyjYlfAf6sR
         vYv8S3f4qvSZ6bPab7f5rllCSFtqs8BfoYqW3WwcXhAFJ1IkT8GUr3Lis8wXdwQEj7qh
         +2lJCQV0dm6sykCdL8eaEivtqU0+a7D7U9/P+jXOMtPwKTgQ4H/752ecVElM/mEvf04I
         PImlqn3qtxyoJ8rhLX1ej8QVuXNPPd54+p0iTLXeineC+BNtrwQVzme3nrLKXAORacZM
         fhi3mIODmsQYqe05N7vTFDl3dXMyhW5ssMDw1iuvPY3INg9WLiMsOWSQCfRMbF8KzHzJ
         jEYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=MAzyj4mSas/HyDATz1l1gBYis9gkD8QW0DKS7LUEaGE=;
        b=ZhdYW5ZGdjXNUCqGhDljPsFYUKnLNCbPkvkLDP/30ciAPxpbOKtVfDpUVcVux9vOSP
         OXGipmg1nFRSFfQ5N55HET8BSZ+sCFzotyEFMb7farnWpNobO+dl8HDV2gprZXDhSo8E
         SA7VNWJq8F74Ehi7z50JDbVxwPZwrKmb7/jxQqBpOid+rvZaK0Ki124EihzD5k3AQ1/k
         RfkctCCQ/SWhmbE0FoQ9r3rL5R4cJy1Mph7cQ0ctiRSZOo/QBO7uODT4VZ6DVxzAnWzt
         qPN+5m0w/JedCeh9vMrBaXvZaQagaD2kCIOyOYw7mD343vpBVjXHy2d7at0fw+rxojCO
         D17A==
X-Gm-Message-State: AOAM531RMzhxv1RflNIfPyFkj0L5QEoLa+wvXa5JHfizcRBjnxZ7UyFj
        dysx9eBuA6T1V0ZE122AC8Gw9aiO4q1R/Kqy
X-Google-Smtp-Source: ABdhPJwnnu2snwSR9jwYLiPHGfH2RDCYATuxnIxlWPq22PiX56uX9IfoTEzzbcHWT8u6ZwUHS1wdBQ==
X-Received: by 2002:a17:902:6acb:b0:158:8923:86df with SMTP id i11-20020a1709026acb00b00158892386dfmr15109795plt.144.1649980895315;
        Thu, 14 Apr 2022 17:01:35 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id t38-20020a634626000000b0039cc30b7c93sm2678505pga.82.2022.04.14.17.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Apr 2022 17:01:35 -0700 (PDT)
Message-ID: <6258b5df.1c69fb81.c2589.7dd0@mx.google.com>
Date:   Thu, 14 Apr 2022 17:01:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.34-8-g941e079ae4c32
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.15 baseline: 70 runs,
 1 regressions (v5.15.34-8-g941e079ae4c32)
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

stable-rc/queue/5.15 baseline: 70 runs, 1 regressions (v5.15.34-8-g941e079a=
e4c32)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.34-8-g941e079ae4c32/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.34-8-g941e079ae4c32
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      941e079ae4c3236b0cd98ef9633866270abfe26a =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/625885ef65bdfefe3eae067c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
8-g941e079ae4c32/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.34-=
8-g941e079ae4c32/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/625885ef65bdfefe3eae0=
67d
        failing since 15 days (last pass: v5.15.31-2-g57d4301e22c2, first f=
ail: v5.15.31-3-g4ae45332eb9c) =

 =20
