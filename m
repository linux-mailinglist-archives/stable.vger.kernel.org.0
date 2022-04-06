Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 780BA4F6E21
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 00:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234948AbiDFW7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 18:59:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234084AbiDFW7l (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 18:59:41 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDC8D6212E
        for <stable@vger.kernel.org>; Wed,  6 Apr 2022 15:57:42 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id o5-20020a17090ad20500b001ca8a1dc47aso7229950pju.1
        for <stable@vger.kernel.org>; Wed, 06 Apr 2022 15:57:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=HTOpwYEoVeAZSWFosnAW887jX3r1FqsXmOqgZWuvlpY=;
        b=j3UTEnW+jiqmgFhyn+t4R+7YunvHJLzT59oJOWsq8e4bzTB1h9Pde+0l7Bv5wLduRg
         mKO1mIv3qCedoa/l1pr8SigJsaNieDGSxjgkODyFFbJn1ZmB3bvK0W85+y9i8DUu1kqp
         hxDSx62CUgU5dod2XmkhYRE23KE3NPlW5Sciru9yyiN9yvH4tp+H09GOIm2yxbrK4o19
         rQlCKDJgPExtmj3Z5cItIUJsF7RkpjIAvf7V9HEBn/Twy0BPp9zk53rSvX6TZE44wRne
         6S7C3JlWSxLq4Oyv5Zc/RCltfF8Zz1WykCcMRMBXpbkWTWEA6L6piz/uXroWOiCjRBJq
         a8kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=HTOpwYEoVeAZSWFosnAW887jX3r1FqsXmOqgZWuvlpY=;
        b=J6tARqNPp0oFaVVdC5DBCA1QGk8aHzPy3iS4ewPpmSYmEBV2992nxCqUdv8d2Y3lxa
         +3/3KjVfzVSa5QAaRA8bDXTqr8oxObtHNSZv/z1PDOAM/ni8LxS7u+kp4x1HuVn4KIvQ
         P21M2wQRkiUNTun/Ge0NwMQkrdulJO+0Ainmotn9wrEI6FjyE9RvOKGQMjN2BEcTkeeT
         K1aJIZRcpWsczM+P2msGJ3uDRYNU6W1OaACS9Rw4ZDZ+rV12lDfxzXA/7gR6oUeK0kUT
         hI8UQXmU0b92XOgGXf5OeH97NsgtyB/jlEHQPpFnlScc4KE6jB6yDo5MYMTt2vhqSfen
         al1g==
X-Gm-Message-State: AOAM530rlX1cpNBhFplzZJLgxEQfrRnPYFeE+Yi5qGUakuzoBcSXXroe
        +Fu8A/VLi6uBTgvHUPskhkqy1rdHogz+Z8DZ5Fw=
X-Google-Smtp-Source: ABdhPJwy6WkSuoPxNCosqkHCApjsCANXOj2M0SJG10whluDc/haoHE3+pnbf9ScKXyzHFok6ZRPHQw==
X-Received: by 2002:a17:903:2284:b0:154:3b97:8156 with SMTP id b4-20020a170903228400b001543b978156mr10847626plh.95.1649285862250;
        Wed, 06 Apr 2022 15:57:42 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id w13-20020a17090a5e0d00b001c7d4099670sm6613921pjf.28.2022.04.06.15.57.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 15:57:41 -0700 (PDT)
Message-ID: <624e1ae5.1c69fb81.b2e88.2c6d@mx.google.com>
Date:   Wed, 06 Apr 2022 15:57:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.14.y
X-Kernelci-Kernel: v4.14.275-206-ge3a5894d7697d
X-Kernelci-Report-Type: test
Subject: stable-rc/linux-4.14.y baseline: 50 runs,
 2 regressions (v4.14.275-206-ge3a5894d7697d)
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

stable-rc/linux-4.14.y baseline: 50 runs, 2 regressions (v4.14.275-206-ge3a=
5894d7697d)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =

meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.14.y/ker=
nel/v4.14.275-206-ge3a5894d7697d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.14.y
  Describe: v4.14.275-206-ge3a5894d7697d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e3a5894d7697dcb0d8d6ac0b8c3b793bf817f371 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig         =
 | 1          =


  Details:     https://kernelci.org/test/plan/id/624de40ae2ee02898fae0690

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-206-ge3a5894d7697d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-206-ge3a5894d7697d/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gx=
l-s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624de40ae2ee02898fae0=
691
        new failure (last pass: v4.14.271-23-ge991f498ccbf) =

 =



platform             | arch  | lab          | compiler | defconfig         =
 | regressions
---------------------+-------+--------------+----------+-------------------=
-+------------
meson8b-odroidc1     | arm   | lab-baylibre | gcc-10   | multi_v7_defconfig=
 | 1          =


  Details:     https://kernelci.org/test/plan/id/624de2ce082b53496aae0695

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-206-ge3a5894d7697d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-m=
eson8b-odroidc1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.14.y/v4.14.2=
75-206-ge3a5894d7697d/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-m=
eson8b-odroidc1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/624de2ce082b53496aae0=
696
        failing since 51 days (last pass: v4.14.266, first fail: v4.14.266-=
45-gce409501ca5f) =

 =20
