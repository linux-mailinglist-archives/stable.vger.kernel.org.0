Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F308850035E
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 03:02:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbiDNBE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Apr 2022 21:04:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiDNBE7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Apr 2022 21:04:59 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA1874EF70
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:02:36 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id f3so3476341pfe.2
        for <stable@vger.kernel.org>; Wed, 13 Apr 2022 18:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=15IGy+j8KYCC7nDqWTj+rQJI35xR1UF+wiDfCd+Cgag=;
        b=MKkVr0qUkRJjyLYdF1gvjH6xOqoKQbQwciwfqduCreVTBd5J0mCwLkT8tWM7Cwmwk+
         DQzqKWhh+xaz7O5wGBgagYR3HVLQTjBKbnOnbLQt5e6ZpCvtl0k4F3PaE4vTf2sEyU6M
         HOmPUcWv5Etir0MrQ8n29j3rLT4m/wyfJr80ptS8FHoCCYiqdKNhEc2D7OPPGHS76Yaf
         USeV/TH0/Zfo0GRxELVr2yVRHx4WpcOEZAIQTQIMv40R+MledCzD5x6/tiPlSWxa+G6B
         nhKz4GRlwE61ask2AXEf1bFJavVxmge/REZGVQByAOVKA7sXLPzt++51/9B7HFegcGTP
         tQ4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=15IGy+j8KYCC7nDqWTj+rQJI35xR1UF+wiDfCd+Cgag=;
        b=CDlAXz00mt6Uarc20XLTYCA9rGD9K34BH4KbgvWCAC+lgmEaoEjeYgumlKW7223S82
         +afCi7VOo/rAEWyvITTVCisou6XHo2D4zMeihQq1u6axUpeohvjqlDHtnhW3UPMzpd5d
         ncpw3Nb15wJb2GYZSUqDxmgGrkvoQEnoHIgqApjGnk7f2Jokv3DCiKiGuZWJqQ6KYVCs
         ZkvJuTwLKbBhufjo2N1IZ9m9yvW/FvalqgswOp1Vo0Sd7bXThD1oLMentX7kIkqnIuwC
         csqa0z2rne7qKN1GfXN16UCBQQd1L/DBP5FCnUhwfhgb5v5Innlxqdy9CJTbw01BVYpf
         EWhg==
X-Gm-Message-State: AOAM533NEwTJakPgIylls52IUZ0Fjvc8D19LxUFiVY7Is2xEho5MclIx
        kEEwDQD1foexbc1280uxplHBRDSPAARnt87w
X-Google-Smtp-Source: ABdhPJw/UvsCmfPmGHgCejvgmokGV23zXKIHmatx/aLgPmWNnWGq0nH3rKpsMg9BfMQLi7byqB0EzQ==
X-Received: by 2002:a65:5b8c:0:b0:39e:293a:7787 with SMTP id i12-20020a655b8c000000b0039e293a7787mr229431pgr.461.1649898156212;
        Wed, 13 Apr 2022 18:02:36 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id n24-20020aa79058000000b0050612d0fe01sm283416pfo.2.2022.04.13.18.02.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 18:02:35 -0700 (PDT)
Message-ID: <625772ab.1c69fb81.eddad.1276@mx.google.com>
Date:   Wed, 13 Apr 2022 18:02:35 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.14
X-Kernelci-Kernel: v4.14.275-259-gc0d8ccd782bba
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/4.14 baseline: 51 runs,
 1 regressions (v4.14.275-259-gc0d8ccd782bba)
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

stable-rc/queue/4.14 baseline: 51 runs, 1 regressions (v4.14.275-259-gc0d8c=
cd782bba)

Regressions Summary
-------------------

platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.14/ker=
nel/v4.14.275-259-gc0d8ccd782bba/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.14
  Describe: v4.14.275-259-gc0d8ccd782bba
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      c0d8ccd782bba0b373742464358416c5a5f4fbe1 =



Test Regressions
---------------- =



platform             | arch  | lab          | compiler | defconfig | regres=
sions
---------------------+-------+--------------+----------+-----------+-------=
-----
meson-gxl-s905d-p230 | arm64 | lab-baylibre | gcc-10   | defconfig | 1     =
     =


  Details:     https://kernelci.org/test/plan/id/6257425b93c45a8d63ae06b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-259-gc0d8ccd782bba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.14/v4.14.275=
-259-gc0d8ccd782bba/arm64/defconfig/gcc-10/lab-baylibre/baseline-meson-gxl-=
s905d-p230.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220401.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6257425b93c45a8d63ae0=
6b7
        failing since 7 days (last pass: v4.14.271-23-g28704797a540, first =
fail: v4.14.275-206-gfa920f352ff15) =

 =20
