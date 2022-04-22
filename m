Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4304B50B5A7
	for <lists+stable@lfdr.de>; Fri, 22 Apr 2022 12:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446922AbiDVK5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Apr 2022 06:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348369AbiDVK5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Apr 2022 06:57:23 -0400
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C7D056206
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 03:54:31 -0700 (PDT)
Received: by mail-pl1-x634.google.com with SMTP id c12so10034008plr.6
        for <stable@vger.kernel.org>; Fri, 22 Apr 2022 03:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=JgOcMAG40Oo+foLkY/mJ6aTsgyXYW5218ngjIs6GiSs=;
        b=5YfUM0L3ImcTwUy4iuZ31N10XqHO8co+vUx6VwOdjMPS1za/WSYqC1+UWq/TS0Berg
         AiflXE7bgyvFtWguKXDb4QF2nkmamCsVqqeQqKBKbEQgbdjyLFIh9Wyzk6hgzMicCTdQ
         yUYMZUaySfZ+6oLpOjXT9aRJ5QjrIp044bHxeFz7c4btAONbBj4/eN04WqoqVU3U9/MX
         XAqwvBG80RHr/KUK6E17P1+Xg0PpsX/dmxICKS3rTvSkid5NejwqRuNddBMMVGJWF45B
         sZZfJ/CIlOg4ORnMAnSFE6vrccbVPt7CVbhyxOq0z+K/JhGcuwHOXh0NHfFyC0blUXl6
         04HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=JgOcMAG40Oo+foLkY/mJ6aTsgyXYW5218ngjIs6GiSs=;
        b=76hdzdSMAqNyUwN/DhF1EqbtdybNoL4L7K5UtMdayk7w52X9MlBe78hcl/ue6C1cYA
         PwXa+/gWryExS4KFCLKG0eJ+5FJFwbmJpBfN7YsitfQNSHfak+IOc8UFZf/EQ9pU/4sz
         pcENlWHwOgAK+NnjzzoLaeQiACS8SvWGCWcIFSB5rdrZ7Xq7+/NHTWln9cBTx8qcyeZF
         419NqUB0G61qikn9Awrj0x5csV5fPQT+BCCRCqQb+cwPFrOCLKP9Uq7FhjLbRKwVIQGe
         eOcfl5UctElIh1zMzwJKHC/5mhnKM050mEXY8uTMl4/nE1B5vVHy3HybFsFsScoT0aH/
         7OYA==
X-Gm-Message-State: AOAM531DnF4TueDRT+ucgGJjgtE4ncsGuo6xr0Iv9aHOmBBXxcP+CmPF
        CsHaGwpyAVY+xC/mRfIyni3IpSlggtxbvOHxhTU=
X-Google-Smtp-Source: ABdhPJwwJ6KoRXenRWOPPgvXVKHBKuZDZw2YdzXLzjKoDQ7cN9esaAYofuALnqPiNGX1fCJBj/DFIA==
X-Received: by 2002:a17:902:b906:b0:14f:76a0:ad48 with SMTP id bf6-20020a170902b90600b0014f76a0ad48mr3940801plb.79.1650624870395;
        Fri, 22 Apr 2022 03:54:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b2-20020a6541c2000000b0039d1280084asm1849828pgq.26.2022.04.22.03.54.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 03:54:30 -0700 (PDT)
Message-ID: <62628966.1c69fb81.19bcb.4a3f@mx.google.com>
Date:   Fri, 22 Apr 2022 03:54:30 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.276-6-g2dcd56b3acae
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
Subject: stable-rc/queue/4.14 baseline: 86 runs,
 2 regressions (v4.14.276-6-g2dcd56b3acae)
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

stable-rc/queue/4.14 baseline: 86 runs, 2 regressions (v4.14.276-6-g2dcd56b=
3acae)

Regressions Summary
-------------------

platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =

meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.276-6-g2dcd56b3acae/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.276-6-g2dcd56b3acae
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2dcd56b3acae2a454ac6534545f9f8eb18e7febc =



Test Regressions
---------------- =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905d-p230         | arm64 | lab-baylibre | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6261c042f4a14f5a68ff9461

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-6-g2dcd56b3acae/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-6-g2dcd56b3acae/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-s90=
5d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261c042f4a14f5a68ff9=
462
        failing since 15 days (last pass: v4.14.271-23-g28704797a540, first=
 fail: v4.14.275-206-gfa920f352ff15) =

 =



platform                     | arch  | lab          | compiler | defconfig =
| regressions
-----------------------------+-------+--------------+----------+-----------=
+------------
meson-gxl-s905x-libretech-cc | arm64 | lab-broonie  | gcc-10   | defconfig =
| 1          =


  Details:     https://kernelci.org/test/plan/id/6261bb7b1dbea6a2fbff9475

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-6-g2dcd56b3acae/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.276=
-6-g2dcd56b3acae/arm64/defconfig/gcc-10/lab-broonie/baseline-meson-gxl-s905=
x-libretech-cc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220411.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6261bb7b1dbea6a2fbff9=
476
        failing since 3 days (last pass: v4.14.275-277-gda5c0b6bebbb1, firs=
t fail: v4.14.275-284-gdf8ec5b4383b9) =

 =20
