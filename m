Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2D95597ABE
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 02:45:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238821AbiHRAmY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 20:42:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbiHRAmX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 20:42:23 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3101F9E100
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 17:42:23 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id s206so70598pgs.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 17:42:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=Jw/eTFB5NZWcLgVkV8EPDCIGKf3OXeuYje3OJ6GmRgs=;
        b=KqxHtqjx/6SZ/8eyBP3/ClF8b9DcMn0dnF5P3UHiXVH5o24NTXrFcERcri4a/KJaxW
         yNB1sc1HxTsWw+ZgJPWm3jaH71UkiEqC9gUNcVx4g8G/i3ZXgjiv9rJWLpNDv5K7RSSC
         RJzIMxZPf03Xr2CMbV7v6MEegIq5mjnl4kRfQpaIz+B1d5LHazPDPKUorE86pxycdoEw
         Nw5FaJN2of6y4rbG7gkSRiZTkM3TaNDFGI9sx2IUpJbJglxxlmgnw1fE5JMGOiEs31C9
         QRoq+N1rC7IXRwgABL4swwgkxLVqqnE7qsLDDo4YsV10MCsket9MBbjTtOza6h8kPmP7
         dk0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=Jw/eTFB5NZWcLgVkV8EPDCIGKf3OXeuYje3OJ6GmRgs=;
        b=RihAelya7RTRqe87rdo3ySgYCk8ZEBLev6PjOzRkkfK0PprJuiLvY4OTIgJz5Mf9z6
         nR2Yy3TpZSxQOFr9bPcXIpm1am+Ly4bS3+/qGGdUwuS+0RTfOsCs6/zi+uZtOGM1r3QY
         OelskfiU/aJ/smCOgPxquMP3KUXSuFKP/OH4J++mh6cnFQaFDpSQ0IQF5yuLQUD6O0A6
         +VtFbnhQePof0nqzxmnlzYposxFP+iGZBk3XtVvwoe2f0a647bSr1GVILggRp3w/CgIL
         ZbQ4TH3sjO0Qnzgu3RS4LqMKGHQPw7thYYl3fYNfAl4nKErm/Xy1OQ5FmIdrM0AdHBRr
         /YUw==
X-Gm-Message-State: ACgBeo0P8I8gXLxVbmkDyuq884VnZJ4L4PFbWFWljWjrB/IxBl9fRl1B
        mXXaKceNZAUNlQ4kGCl9WOmf37jHhq6r6Ffm
X-Google-Smtp-Source: AA6agR782C4FNzyT1+l00AAVm61PL1fMZcs4ng5lgh14hXr1UKEbqq/galg+aOEZ6367TIxk/7JmXw==
X-Received: by 2002:a63:6403:0:b0:429:fd87:3180 with SMTP id y3-20020a636403000000b00429fd873180mr466930pgb.587.1660783342570;
        Wed, 17 Aug 2022 17:42:22 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 13-20020a170902c24d00b0017297a6b39dsm13101plg.265.2022.08.17.17.42.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 17:42:21 -0700 (PDT)
Message-ID: <62fd8aed.170a0220.1bcce.0090@mx.google.com>
Date:   Wed, 17 Aug 2022 17:42:21 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.61-1-geccb923b9eab2
Subject: stable-rc/queue/5.15 baseline: 123 runs,
 2 regressions (v5.15.61-1-geccb923b9eab2)
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

stable-rc/queue/5.15 baseline: 123 runs, 2 regressions (v5.15.61-1-geccb923=
b9eab2)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie  | gcc-10   | bcm2835_defconfig   |=
 1          =

beagle-xm          | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.61-1-geccb923b9eab2/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.61-1-geccb923b9eab2
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      eccb923b9eab224039e8c3eeeed43a0042a1c11e =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
bcm2835-rpi-b-rev2 | arm  | lab-broonie  | gcc-10   | bcm2835_defconfig   |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62fd556064ff4e088d35567e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.61-=
1-geccb923b9eab2/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.61-=
1-geccb923b9eab2/arm/bcm2835_defconfig/gcc-10/lab-broonie/baseline-bcm2835-=
rpi-b-rev2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd556064ff4e088d355=
67f
        failing since 1 day (last pass: v5.15.59-9-g01206bfdee44a, first fa=
il: v5.15.60-777-g484e5dee10f8f) =

 =



platform           | arch | lab          | compiler | defconfig           |=
 regressions
-------------------+------+--------------+----------+---------------------+=
------------
beagle-xm          | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/62fd5b06355ccb197b355682

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.61-=
1-geccb923b9eab2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.61-=
1-geccb923b9eab2/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62fd5b06355ccb197b355=
683
        failing since 140 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
