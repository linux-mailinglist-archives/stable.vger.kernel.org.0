Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB21453DCA6
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 18:02:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243141AbiFEQCu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 12:02:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232481AbiFEQCt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 12:02:49 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7275F26E1
        for <stable@vger.kernel.org>; Sun,  5 Jun 2022 09:02:48 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id gc3-20020a17090b310300b001e33092c737so10750966pjb.3
        for <stable@vger.kernel.org>; Sun, 05 Jun 2022 09:02:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pgt5kOYLRmvaeOH7QhM5Av7T40bckA4FZ8LWecg5GIk=;
        b=pKKZTtXovaTz7QraYsxShxazWiL1xxGmHidDGZXpcvE44y4OM2mnuak/iOo3arAX4Y
         c/TICYSWC6KSFBwfeRi4ZIquFjfLY0fLujG5AnjN9g6khSUwe+l/abTcjEtn/Hh5oBNl
         U9Lyrnh40AlkHwYZ74zCN8OCu8N69F1SdFwNtM7t6MvjE7Kd/c02DS53RF6muL+9S5Z5
         xQCnT3TZ/L/bU9VG37I5vIzmgdCZpMEYa5v6ciCckM1pO8mlhHqg5UOHBlUFQzgiXOv+
         fMoZakj36jZlrnkJ3UfqemGvSJsE/4D3IfFn4l1MsJYOJLk1rdUvY5XrGWXDaZkr36bM
         gceQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pgt5kOYLRmvaeOH7QhM5Av7T40bckA4FZ8LWecg5GIk=;
        b=kasZt4MuW3N9wg/g2whITM+I+fWhxJYL8vH/fWuL4nJrJguB+eRWBgeRa8oK3qm5oQ
         USOq9EJjNC6o4gamPLdnF66pIt9L9fWr9P2p0VwTiOwoJxU+NkvxfeJ6MDKe5otxtCA4
         cNHkK87oqZNpwhYPlh9Pib5WM2RqFKENZznsaCoEuD6LBa1mEdQcd2ugrFfEUV2z1BSE
         AgZ+RWTLN5o6d6SaE/kn8uOIZl6zvjUgcbvCnHtCXzsVRCbW1zBKVwOgyRaA6sO9VKOF
         /W2tlgBVxdrWkFUREVIYGLIw4wGnT8DUcSmIbQ/Rg5/mNS9KADIij4u2i7OY7lk44U0z
         eNTA==
X-Gm-Message-State: AOAM533Hg+71/q9aigR/SlO+S/Zbq7WAsjpWMj7unXsTeDvXppg2CYvy
        aevL/Ct5HqLQReVDrTsDx8fBsCII3ML6VxNp
X-Google-Smtp-Source: ABdhPJw9ytIbQ0xRW1d0zxSEnvWFHH+l3q/d+qddpnA6WYc2RKHscKr+f23ob/UfXDwIktsqZev3IA==
X-Received: by 2002:a17:903:41c9:b0:164:57e:4b22 with SMTP id u9-20020a17090341c900b00164057e4b22mr20165699ple.2.1654444967797;
        Sun, 05 Jun 2022 09:02:47 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n18-20020a62e512000000b0051b8987efc0sm8933261pff.218.2022.06.05.09.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 05 Jun 2022 09:02:47 -0700 (PDT)
Message-ID: <629cd3a7.1c69fb81.f2ae0.3d9d@mx.google.com>
Date:   Sun, 05 Jun 2022 09:02:47 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18-115-g7ba95b2c35a6c
X-Kernelci-Branch: queue/5.18
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.18 baseline: 162 runs,
 1 regressions (v5.18-115-g7ba95b2c35a6c)
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

stable-rc/queue/5.18 baseline: 162 runs, 1 regressions (v5.18-115-g7ba95b2c=
35a6c)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.18/ker=
nel/v5.18-115-g7ba95b2c35a6c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.18
  Describe: v5.18-115-g7ba95b2c35a6c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      7ba95b2c35a6c6903c08e97c07fb987834402044 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/629ca65b20f4ba40d5a39c16

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-115=
-g7ba95b2c35a6c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.18/v5.18-115=
-g7ba95b2c35a6c/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629ca65b20f4ba40d5a39=
c17
        new failure (last pass: v5.18-114-g35335b1f45edd) =

 =20
