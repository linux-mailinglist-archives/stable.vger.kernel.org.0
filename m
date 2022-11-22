Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5789163431B
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 18:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234123AbiKVR6T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 12:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234018AbiKVR5g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 12:57:36 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEABE0EB
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 09:56:46 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id w4so5606429plp.1
        for <stable@vger.kernel.org>; Tue, 22 Nov 2022 09:56:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=ZiewhiPLZX3Z5F/b8nyBJcAQVLMv3we8H9R4Ll6/Y7Y=;
        b=tTBTJhYF7UPZ+qPN33a7x6nOYTz9CAOwo3QjnpJJo3hnih5A8Fve1G+S4TP6eHsTwT
         aunTrCfyp0tj63M3B7gvzH6aQgB6y8r2WXPndNSySpPk6O/coK0h6mppL25K90ahJHbp
         bKouQ+8hT8DSZ3vvuCuJEsu418/8KTv4x8tGZP/LEVLYrh85C4UWJc6gKdp3kQGI3az5
         6ff+aLLZwR7XFRxGrP2SDuXd5eJtCbzwyRzttZKzd9vhsiu4eB4IJGo/NwTZir9B1cvI
         0CVuQzC9GnlEsj3wLr24IVX4IT1KAOInU0REfzF9zoeG7VbV2WOyyPwPRihx8SbSn5SM
         /6KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZiewhiPLZX3Z5F/b8nyBJcAQVLMv3we8H9R4Ll6/Y7Y=;
        b=s7tXVcjZjk/uDfxvlc4PRQBkLF5Q5ZfdCTFGUfAk1RDsmQ5GtL+v0/v3HqKCF2McjI
         gItESXU2315WZuCd0tzLYlDF7J51jesF0nbtbA+zqg+hIwJf+bs8d+HEFkXpKUL+AwEz
         pgWxFSCkibVZFVYIUR1ZHodQOcHBCrEkvSe7wvWc/9nMYb/PD2LqmelDYoSusiUxz9xm
         qW1UTve2J2/oMBoAgEh2DFTUS6C/JIYY6DY/Exp+Llyx2WtdMKa2E/FlQNDQD+H5qSzJ
         2WaPThWurThHeVptkWDucZicHBxy6DXAEeXS+ZKA+G2TiQst1SQMJZEPuzNaT2akCEIB
         SoAw==
X-Gm-Message-State: ANoB5pl/p3i/FoMvTIw0KjkiDYabDrU8NssQXdCNZqfXIOwzgad7C+bZ
        EnnMpA59+K0f8JAP+jDz1Wm9GeyiatsaMywVTiU=
X-Google-Smtp-Source: AA0mqf7DwNz0SjfMx6qRyeaMoy31V/KsLwI9xwkSir9GP8AGb3rM5iT9KWX+3x0m5clbGSjTqJVOOA==
X-Received: by 2002:a17:903:300c:b0:17f:9538:e1f4 with SMTP id o12-20020a170903300c00b0017f9538e1f4mr16281240pla.89.1669139806120;
        Tue, 22 Nov 2022 09:56:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id d10-20020a170902654a00b00188fcc4fc00sm10544263pln.79.2022.11.22.09.56.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Nov 2022 09:56:45 -0800 (PST)
Message-ID: <637d0d5d.170a0220.809ab.02b8@mx.google.com>
Date:   Tue, 22 Nov 2022 09:56:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.15
X-Kernelci-Kernel: v5.15.79-159-g5d53be632081
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/5.15 baseline: 150 runs,
 3 regressions (v5.15.79-159-g5d53be632081)
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

stable-rc/queue/5.15 baseline: 150 runs, 3 regressions (v5.15.79-159-g5d53b=
e632081)

Regressions Summary
-------------------

platform             | arch | lab        | compiler | defconfig           |=
 regressions
---------------------+------+------------+----------+---------------------+=
------------
imx7ulp-evk          | arm  | lab-nxp    | gcc-10   | imx_v6_v7_defconfig |=
 1          =

imx7ulp-evk          | arm  | lab-nxp    | gcc-10   | multi_v7_defconfig  |=
 1          =

sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.15/ker=
nel/v5.15.79-159-g5d53be632081/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.15
  Describe: v5.15.79-159-g5d53be632081
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5d53be632081e46e480a4599dc96863b902f444f =



Test Regressions
---------------- =



platform             | arch | lab        | compiler | defconfig           |=
 regressions
---------------------+------+------------+----------+---------------------+=
------------
imx7ulp-evk          | arm  | lab-nxp    | gcc-10   | imx_v6_v7_defconfig |=
 1          =


  Details:     https://kernelci.org/test/plan/id/637cdce8534b99de6a2abcfb

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: imx_v6_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
159-g5d53be632081/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
159-g5d53be632081/arm/imx_v6_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-e=
vk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637cdce8534b99de6a2ab=
cfc
        failing since 57 days (last pass: v5.15.70-117-g5ae36aa8ead6e, firs=
t fail: v5.15.70-133-gbad831d5b9cf) =

 =



platform             | arch | lab        | compiler | defconfig           |=
 regressions
---------------------+------+------------+----------+---------------------+=
------------
imx7ulp-evk          | arm  | lab-nxp    | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/637cdb597811a059ec2abd39

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
159-g5d53be632081/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
159-g5d53be632081/arm/multi_v7_defconfig/gcc-10/lab-nxp/baseline-imx7ulp-ev=
k.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637cdb597811a059ec2ab=
d3a
        failing since 57 days (last pass: v5.15.69-44-g09c929d3da79, first =
fail: v5.15.70-123-gaf951c1b9b36) =

 =



platform             | arch | lab        | compiler | defconfig           |=
 regressions
---------------------+------+------------+----------+---------------------+=
------------
sun8i-h3-orangepi-pc | arm  | lab-clabbe | gcc-10   | multi_v7_defconfig  |=
 1          =


  Details:     https://kernelci.org/test/plan/id/637cdbb71fb3adf1642abd9c

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
159-g5d53be632081/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.15/v5.15.79-=
159-g5d53be632081/arm/multi_v7_defconfig/gcc-10/lab-clabbe/baseline-sun8i-h=
3-orangepi-pc.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20221107.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/637cdbb71fb3adf1642ab=
d9d
        new failure (last pass: v5.15.79-106-ge7e2069801de) =

 =20
