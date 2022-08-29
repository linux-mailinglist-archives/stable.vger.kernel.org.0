Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7ADC65A51A0
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 18:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230361AbiH2QZT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 12:25:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbiH2QZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 12:25:17 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F1F32228D
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:25:16 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id 76so8696762pfy.3
        for <stable@vger.kernel.org>; Mon, 29 Aug 2022 09:25:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:from:to:cc;
        bh=cp8RXPJqo17aTuFmO6oFBBf3lwmtpIayX/scP1NUGFw=;
        b=dXsrByw6TJ1nO3iUVVA3RhJstK/Kn7WIn4hASAaluW+uokatBfQ8+wUnWNIvGFwZcI
         QZtnqCSnI/NCpiBcAH0sWUAeTP5mcptSY4EliIPIWP3MnG7u37YEqWHd0HwNRS47dfgp
         08CCljtCtjtSOPaJFzuFzrJQH6QV6gpmG35e97LLca5aN4DZ9yJXuLcn+4m55lG3O07/
         Ob0Zm6vw3DuqlVjQHxmN+/c8xyiN/Hapzy1oPIySO/G+wtGjY96oynqq6JDRXKiGRhxY
         qvoqpaGQvNl1F3C8CcOoT7RwFZFpHxv1kzxY0O0G9bYPvqNrMYpLAgGN8+TjxutX+R1j
         JFUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=from:to:subject:content-transfer-encoding:mime-version:date
         :message-id:x-gm-message-state:from:to:cc;
        bh=cp8RXPJqo17aTuFmO6oFBBf3lwmtpIayX/scP1NUGFw=;
        b=LAFpPKdQlU+4QLoLqA29jFBnb6erig9NndhwD4NfDhCCIK2R1Raf/OpnYDJ7rCx3tj
         7+jefvKsCJ7Lsspd4EbuxrAWHEuaWrg8LXZICrGab1raGZiFC2J2Cj2Zvl4fQdKDMwKG
         qk1gTzgh0wK4Nu4ZGsw8NxBYCiq1VwcYAlSP09yINAA24FsYhpRhUkCRzs1IHm35MwdZ
         CZ3qcmOxLQhgjBBq/Y6dQwEITLFplBkLL1FPIALbiiJDFZDicvZuAAE4cGOcDakEzn5b
         IezK9SmfXQQ2bgI+WyLqvEJlHVpRFdWygg4xLzpFj3qVsJLMqz65iZaqvoZYGJn2HeVH
         1Ekg==
X-Gm-Message-State: ACgBeo2SYa+bqnGs/7dzC+dZlg6dtA/9dssdwxJ5wEDi1vKsgM+PYhrV
        Ib4M2cQsEooIi/ZVe13Oml68uPTi04TDmZTzIm4=
X-Google-Smtp-Source: AA6agR7I6KZuSptInIXDVgXIUi3hig4BT8MvNRKkjtpxRVk4so1LGYFN70LGPxs/5l1/TZ6EKnP18A==
X-Received: by 2002:a05:6a00:2387:b0:52f:17a0:628c with SMTP id f7-20020a056a00238700b0052f17a0628cmr17138371pfc.17.1661790315389;
        Mon, 29 Aug 2022 09:25:15 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id x9-20020a170902a38900b0016f154c8910sm5558623pla.204.2022.08.29.09.25.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Aug 2022 09:25:14 -0700 (PDT)
Message-ID: <630ce86a.170a0220.59123.8c7b@mx.google.com>
Date:   Mon, 29 Aug 2022 09:25:14 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: linux-5.19.y
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.19.4-161-g5cfa6cf5bd86
Subject: stable-rc/linux-5.19.y baseline: 106 runs,
 2 regressions (v5.19.4-161-g5cfa6cf5bd86)
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

stable-rc/linux-5.19.y baseline: 106 runs, 2 regressions (v5.19.4-161-g5cfa=
6cf5bd86)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =

imx8mn-ddr4-evk | arm64 | lab-nxp      | gcc-10   | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.19.y/ker=
nel/v5.19.4-161-g5cfa6cf5bd86/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.19.y
  Describe: v5.19.4-161-g5cfa6cf5bd86
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      5cfa6cf5bd86ffb0f956ff2ac4876ec6905dd3cf =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-baylibre | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/630cba10b63f8473a635565f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.4=
-161-g5cfa6cf5bd86/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.4=
-161-g5cfa6cf5bd86/arm64/defconfig/gcc-10/lab-baylibre/baseline-imx8mn-ddr4=
-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cba10b63f8473a6355=
660
        new failure (last pass: v5.19.3-366-g32f80a5b58e2) =

 =



platform        | arch  | lab          | compiler | defconfig | regressions
----------------+-------+--------------+----------+-----------+------------
imx8mn-ddr4-evk | arm64 | lab-nxp      | gcc-10   | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/630cb93e54e6698b5e355691

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.4=
-161-g5cfa6cf5bd86/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.19.y/v5.19.4=
-161-g5cfa6cf5bd86/arm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220805.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/630cb93e54e6698b5e355=
692
        new failure (last pass: v5.19.3-366-g32f80a5b58e2) =

 =20
