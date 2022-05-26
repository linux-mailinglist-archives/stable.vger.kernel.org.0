Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DEAE5353B2
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 20:58:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239645AbiEZS5y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 May 2022 14:57:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239737AbiEZS5w (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 May 2022 14:57:52 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3ABE612D09
        for <stable@vger.kernel.org>; Thu, 26 May 2022 11:57:52 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s14so2185733plk.8
        for <stable@vger.kernel.org>; Thu, 26 May 2022 11:57:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=AyCYHmg+9OeRqrxQnoYzOPvnPIIUV+5G1W1tuAaIsQ4=;
        b=P5Ll9Fm3AhCwooSfTw10o66uimUoQjAzkdUwm9V6AQ3lRQgCJiCkPDYFzwLNq2Pqkd
         AZqZ4s7tFdy4A0AmOJ66soyHdi19uC5TZW0JWyDGV6l7koxMze5GrkqHG75i4yyRL+VW
         ICmpOACKBd6le6j+Deu5ygMpvqPVTISWCnx8DDpyx+bT2soKe/Itt1yOZwwEur+/V1gY
         j8eo9xpP4IhUXqqifVi3P4YDamssg/uqGclwM/SpGZMeSYrvwII3Je4ozrm4uQcZF/Ki
         d50lD32F0xeDYd7YKm42MGoa1G/juz0i/OWaxGE4DiF+2/Pcadk/rSYDUADudEQQxqKi
         mhVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=AyCYHmg+9OeRqrxQnoYzOPvnPIIUV+5G1W1tuAaIsQ4=;
        b=AvTARi41Q2PuxhWU5/7oXUf2R3jGLa7nLBkS3cgUUlkyr3DtOt3EXgWV7Zb+bVLNJr
         F5dKU4m2vSdC6WDqTLG8o3r2BD7YZ6UopjwdaoN+XTkguoIrReRCmiLnGceXNB4VVsfp
         UKnUqS660eC+o5+NYv9Ld2//0K+96ChyWGYJe2r79ozSKJNbwrDkTuirnXgBtoSY8SyV
         SBF5Ge24BLGUdgIsPnq8skLe0fwMbZKrx3kw7YTUZsEz1rRFUaqiKK5kMM1IQap+EdEN
         WJco1/0+Epj0uyXG8AFzA3h/lr+14wnIULgJfYZWIDDg4OwpHxEeMpM9XmU85ywy+4gh
         jldQ==
X-Gm-Message-State: AOAM532egXzhOHJEoQ+9BGaBO9LdkHF/jERqvZ0YJbWUPw3QbW5YjG3G
        rekPDVI0OmanOLWjtIRg/mjbZwZU8wRr7Ra3GiU=
X-Google-Smtp-Source: ABdhPJx/txfNCBVVI+4xVUMFYx6wGSkviZg//xSm5wmzuvxMScmG9W7Q3zrm3ganBgrLJLQIEa25AA==
X-Received: by 2002:a17:90a:530e:b0:1db:de96:dff5 with SMTP id x14-20020a17090a530e00b001dbde96dff5mr4098198pjh.22.1653591471629;
        Thu, 26 May 2022 11:57:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id y1-20020a170902864100b001638a171558sm600602plt.202.2022.05.26.11.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 May 2022 11:57:51 -0700 (PDT)
Message-ID: <628fcdaf.1c69fb81.576b4.17a6@mx.google.com>
Date:   Thu, 26 May 2022 11:57:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.43-3-ga16def6cd632
X-Kernelci-Branch: queue/5.15
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 109 runs,
 2 regressions (v5.15.43-3-ga16def6cd632)
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

stable-rc/queue/5.15 baseline: 109 runs, 2 regressions (v5.15.43-3-ga16def6=
cd632)

Regressions Summary
-------------------

platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =

jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.43-3-ga16def6cd632/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.43-3-ga16def6cd632
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      a16def6cd6327c36957ee0f10ebc608c99f21259 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628f9d966641490433a39bd4

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
3-ga16def6cd632/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
3-ga16def6cd632/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-=
tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f9d966641490433a39=
bd5
        failing since 2 days (last pass: v5.15.40-98-g6e388a6f5046, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/628f9ad8fe64cd757fa39c9b

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
3-ga16def6cd632/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.43-=
3-ga16def6cd632/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1=
.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220513.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/628f9ad8fe64cd757fa39=
c9c
        failing since 2 days (last pass: v5.15.40-98-g6e388a6f5046, first f=
ail: v5.15.41-132-gede7034a09d1) =

 =20
