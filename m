Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B26D2664760
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 18:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjAJR0U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 12:26:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjAJR0U (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 12:26:20 -0500
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11049568B2
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:26:19 -0800 (PST)
Received: by mail-pj1-x1032.google.com with SMTP id n12so13122211pjp.1
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 09:26:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=nliJQlj23z9hbeKyMSl59voNvnRlEhNGeqPCO5Oz7iU=;
        b=JtUMyHuaaLvvtJ0Fme1GYAdkyW69Isn/2P63QiKEOP2DRZx7EhXV7XEooZU6TK79SM
         RuXL/owazMPaqo0dqEwk/Dc+tR20eY5cYKSt4dJYcAa5/y39hGZYq1aIOAj8gdtxLpF9
         j3+TTMF5aRCOn5A3z5Fo7WkUsRGMu08mGgF/YsQYUXTY96+644NpoA89xCcK3XgHl3z0
         +J18XngsZnrB9tIpbjC7fSeB4FlCqpPsw9bKve+WlNWt9nfWWdRObXOOdv2eS3nCxw15
         zFcRJlvvzaGd3tDYImErAhgOkRye2rfhfkZWmbTI9/xieHGMovO7/QPpWc0Y0Gr5jYsB
         gAwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nliJQlj23z9hbeKyMSl59voNvnRlEhNGeqPCO5Oz7iU=;
        b=YvktSalS2xLSnib8n0Gtz3IBxDEx4rwMProF19imBvNMXOe7Eo/PytGAvRTsZC2VIc
         Vl7hFf3lVQsKrXiXzuRT0feYFKu6P3mTHXPIJcPexQVLbw8xzX9HwqyH2ckHSSpuTOEf
         UT67vRBvUJGYziDdZP3m6fST/o46MAYjCcL4f4qivYg2Lad/FDmaREYA2E3/1/KjyfLx
         dnE2mZ2MeYoSGzkLzEwImNzJE8OeVePFYbzEm9vxZ6RAvwfBdlPBDahj9/1O2pN3F+0n
         JbUECQ+3nUTuysE6AlGeBNpATMjth0LfthBCKsEXOeaoqoeFSERs6jGzZHiFxS8QkGlk
         ZLSQ==
X-Gm-Message-State: AFqh2kpSurFriRlwL2uOb7hr3+Frgk7rHOmVjO6Qm+0pK4fqyOs1pePa
        oEOr7zdNdTQe47v5ywXYYOt4ER2E5xc3W161/ehvPA==
X-Google-Smtp-Source: AMrXdXvBL3zRsr8olr3Bhlzc2NYxbufoRsKfOSDdWnXy87QDREh6MK+bytKWyhrhrXL8UC1aEoQ4rg==
X-Received: by 2002:a17:902:6b89:b0:189:cf92:6f5c with SMTP id p9-20020a1709026b8900b00189cf926f5cmr73644692plk.52.1673371578147;
        Tue, 10 Jan 2023 09:26:18 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id a13-20020a1709027e4d00b0019312dd3f99sm8089498pln.176.2023.01.10.09.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Jan 2023 09:26:17 -0800 (PST)
Message-ID: <63bd9fb9.170a0220.3c058.d462@mx.google.com>
Date:   Tue, 10 Jan 2023 09:26:17 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.10.162-767-ge4c2d6d2444c
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-5.10.y baseline: 116 runs,
 1 regressions (v5.10.162-767-ge4c2d6d2444c)
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

stable-rc/linux-5.10.y baseline: 116 runs, 1 regressions (v5.10.162-767-ge4=
c2d6d2444c)

Regressions Summary
-------------------

platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.162-767-ge4c2d6d2444c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.162-767-ge4c2d6d2444c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e4c2d6d2444cdb93738ea7ddcef5938def711d15 =



Test Regressions
---------------- =



platform          | arch | lab     | compiler | defconfig          | regres=
sions
------------------+------+---------+----------+--------------------+-------=
-----
r8a7743-iwg20d-q7 | arm  | lab-cip | gcc-10   | shmobile_defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/63bd6b13abced621311d39d7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: shmobile_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-767-ge4c2d6d2444c/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.1=
62-767-ge4c2d6d2444c/arm/shmobile_defconfig/gcc-10/lab-cip/baseline-r8a7743=
-iwg20d-q7.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20230109.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63bd6b13abced621311d3=
9d8
        failing since 12 days (last pass: v5.10.161-561-g6081b6cc6ce7, firs=
t fail: v5.10.161-575-g2bd054a0af64) =

 =20
