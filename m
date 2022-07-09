Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C57A356C7D8
	for <lists+stable@lfdr.de>; Sat,  9 Jul 2022 10:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229557AbiGIILW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Jul 2022 04:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiGIILV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Jul 2022 04:11:21 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3C3171731
        for <stable@vger.kernel.org>; Sat,  9 Jul 2022 01:11:20 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id e132so767795pgc.5
        for <stable@vger.kernel.org>; Sat, 09 Jul 2022 01:11:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=lavocIWhcqFFpQ6zggvOID0tmCnoiCLvxsMnzEq7tMo=;
        b=tiGvLIrtmzWNkrIQIORmMG1UITJXsc8c3hZKPlzEwOO7l7R7PP7R8un8lLmr4vIJHa
         vIZUrSATDH1XRA7xm7W7iQ16fe77LFBfzcCg7F6sPtCBajAfZV3EFeyL3zEvWi3SuNOZ
         T2Uq5FLA3w+OvjksNmNqP/qzvZZbHK3/lIj1ktzzzzGmIG9IKOS0ZPcxG73KEK0awxFr
         1UMJBfNAwnj5FVvDIF4xS+MLxFRFuoHCp6VO2sKvzsGtFbSJGlt3FOozRi4qXFv0xpdK
         Z6c1CdxrZH/kN1tjJ4eOR9iktKuUtQgclw3oQ9E5ibXMQJEOFLvtvS/u3g9o0aeyyNti
         SR5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=lavocIWhcqFFpQ6zggvOID0tmCnoiCLvxsMnzEq7tMo=;
        b=rk2OqARZ5mkQFa8U0e+6oalj35vBmRAwJK/t9kF0dkGBOpd+V9E2/WWSCw58FYigmL
         NSzNwHIyxBRU7fjQadrHqQiN/2vpCxanUFOCtoiib6/RnHxwyLFt8Vj6YquhpDpclLWk
         SdQ0l/XCmy1BT7wr0APBxqnG/PW7I6UTAXVkU3TvIm9qYn1FEQo0mH4+ZE3b0jA043gO
         JQFF2hdvYdaqrR1sn5HJQzQ4rmsr2kMxEs1SjE6WLbdG13jW0D3S6cpfhv2DWNnxd9Ds
         rbLmMsZy4mMh/Z5f7ZUc7jICANNc9qyr57QHPuYzQUz+sH/2B3LuHX2qDLp5Z9MHcrSH
         QXFA==
X-Gm-Message-State: AJIora/P7KfcyQQx9Bq+Db60c5HsdjF0cNqjQ5Fkn0+3xpQL5g0YC2DE
        ZWghbZBwVtN1ZUm03yH5Q6ko6ZhA5vxx3Lmq
X-Google-Smtp-Source: AGRyM1ubVgEknfbHBCJ7keiy8a4QWr8L6Qt2Epcrq5CyB2IbihQSjxtQ7XTqULoExVDrYYXwVFbjNw==
X-Received: by 2002:a63:550:0:b0:413:8c29:e9ed with SMTP id 77-20020a630550000000b004138c29e9edmr6501962pgf.180.1657354280220;
        Sat, 09 Jul 2022 01:11:20 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a8-20020a170902710800b0016be195fd39sm782573pll.57.2022.07.09.01.11.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 09 Jul 2022 01:11:19 -0700 (PDT)
Message-ID: <62c93827.1c69fb81.f31fd.12b2@mx.google.com>
Date:   Sat, 09 Jul 2022 01:11:19 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.53-161-gab88938c957f
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 49 runs,
 1 regressions (v5.15.53-161-gab88938c957f)
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

stable-rc/queue/5.15 baseline: 49 runs, 1 regressions (v5.15.53-161-gab8893=
8c957f)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.53-161-gab88938c957f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.53-161-gab88938c957f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      ab88938c957f2e2edc60e19ab6df7830fc1c6914 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62c902391b40bc326ea39bce

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
161-gab88938c957f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.53-=
161-gab88938c957f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62c902391b40bc326ea39=
bcf
        failing since 100 days (last pass: v5.15.31-2-g57d4301e22c2, first =
fail: v5.15.31-3-g4ae45332eb9c) =

 =20
