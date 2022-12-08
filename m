Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D3A9647842
	for <lists+stable@lfdr.de>; Thu,  8 Dec 2022 22:53:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbiLHVxr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Dec 2022 16:53:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229824AbiLHVxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Dec 2022 16:53:45 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331019AE21
        for <stable@vger.kernel.org>; Thu,  8 Dec 2022 13:53:43 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id d7so2856330pll.9
        for <stable@vger.kernel.org>; Thu, 08 Dec 2022 13:53:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=L3cotTEKoVg/NI8hE3ajxkF4MJIW6yza9CRM4C5P02c=;
        b=TsOCW2+Q9PEKLZ+qJDBzL5x4wibovr+mPGy2dxfWmm1icHmYsDocvWm4I2+NSyY4Qu
         8Ii1fzmzbIVYop0XpcAX7prqK4GzV7qTPNdluP5Wt2eAmD5uDhr15+rSMunIt+SGXoPO
         ac7+aOVg3rMQFjrFIWefHMLEXQ0Z0kQ1ErSpYrgTM1wCRwUmuxWfB9bZ95qWgsScmblg
         liO2+BQ4sjid+7lyl+pn9e4GYcxfd3tYfIL4WnSHbHN1f8TfVcZHDDCLA2fgplmk9cWx
         JjrmnHGTp2bGrH8OHoapbcQhN4KARcfz3WmbUQ48UZyBtrPNAN011EXAVVfhWIhDkM/a
         F+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=L3cotTEKoVg/NI8hE3ajxkF4MJIW6yza9CRM4C5P02c=;
        b=xdW1ud3djQly0zb4mVz6MAFJB5n0FNzJNOmbO/jA8FqKf+XFwICEYahy0uxH6o5eN4
         tuxislyZPwMG+IDsXnKBsHajgay7+SxJ0df9xtLJbqhIhCXTcWbEn4r3N8CL3Bc2VUN4
         cmiF6PC63HUvY4DWr9bRUiBXwes8ygGlxs6EYuAUU9Rm09zEnMCK5KyAFCPhWb2PEbDG
         700Iah2xYzkcT8DX35uXelvQaj+VFx2Jhs08XYkMPWfIPaoPvyxKOpiUY/q2or+wCyVF
         UBdGUsxTjp38Wwu6/Piw2YdHpQGjxFKkJ+8PyL1ycNm8s0d7qLiYtvBUJAEJe1xdPRHl
         j4QQ==
X-Gm-Message-State: ANoB5pku7blKokPPqQ+j7vgP2E8+SwFqJDJp6lB/tx1n5GfytbhygDaT
        i6ky3lN4rkqfqXk9vcn+bISWfE+7b00Bn845N9jrlA==
X-Google-Smtp-Source: AA0mqf5Bd4OhRYvhGqjETBAlhUr/Yj4wDI/jX9Xn8zMbA63qdFPkJL8FVU08S7P0wpuXf/fWaMKClw==
X-Received: by 2002:a17:90a:ae03:b0:20d:bd5f:ced2 with SMTP id t3-20020a17090aae0300b0020dbd5fced2mr3550563pjq.34.1670536422351;
        Thu, 08 Dec 2022 13:53:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id qe7-20020a17090b4f8700b00218d894fac3sm89875pjb.3.2022.12.08.13.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Dec 2022 13:53:41 -0800 (PST)
Message-ID: <63925ce5.170a0220.f774d.054c@mx.google.com>
Date:   Thu, 08 Dec 2022 13:53:41 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.10
X-Kernelci-Kernel: v5.10.158-45-g6bfd2d2abf3f1
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.10 baseline: 102 runs,
 1 regressions (v5.10.158-45-g6bfd2d2abf3f1)
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

stable-rc/queue/5.10 baseline: 102 runs, 1 regressions (v5.10.158-45-g6bfd2=
d2abf3f1)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.10/ker=
nel/v5.10.158-45-g6bfd2d2abf3f1/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.10
  Describe: v5.10.158-45-g6bfd2d2abf3f1
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      6bfd2d2abf3f195413917dcd593093eccfb4f960 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/63922b09143841072f2abd0f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.158=
-45-g6bfd2d2abf3f1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.10/v5.10.158=
-45-g6bfd2d2abf3f1/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-bea=
gle-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221125.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/63922b09143841072f2ab=
d10
        new failure (last pass: v5.10.157-95-g602512855c6c) =

 =20
