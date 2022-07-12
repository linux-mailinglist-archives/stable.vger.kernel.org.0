Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1B445726C3
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 21:54:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235688AbiGLTyb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 15:54:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiGLTyN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 15:54:13 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 858FCC6F
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 12:52:29 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so12950189pjo.3
        for <stable@vger.kernel.org>; Tue, 12 Jul 2022 12:52:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=r8I/mecRNBCpGHvmrxQlPBg/sezOmGqXXX1uGoZZT8g=;
        b=7fr67GQEgtWocxnOsYUdjyvwEGKte9YedeJVsUIQGkgKwafsZDj1h93I9kqVds5lIN
         Jih5gqTIoDIM1SOpmUjzlFP/IyFeok741ji+nwE3aXVXpKxt7d/NpmIKvHGqPnDjhecD
         s7AMQsRo67+rTnEU/dUYGkzR3VbSGR7QbNuTq5IxCT6LpvxBtksB0TN3txlQbPDHqS/v
         BAa4JeOJ0ufNRfFvOZkBN7rUYbs2jb5BEGB8/eZ7F4dmFdIetoi/lSa79WdKMBsNMQjK
         95RpAMVjmC1ReuuU5BUW0SbhOXsgWqfLWKfj96zx3BBbt3dnoSUJRqKNGk46duGWcyvV
         JjkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=r8I/mecRNBCpGHvmrxQlPBg/sezOmGqXXX1uGoZZT8g=;
        b=uIr48iixBKd3g+32lpGsSt+YVt0/larL6VFRvI/UY6/joyVxXZNsjxC5w/SCrzcEyr
         EVM5phADUoqvgl+BzAegTxk2b29HSwyxZbJbfWOB2rzs9MtOmoxzA4G+qR+50oNqLdu8
         qOtATNkCUI79VAcu/FhFdw2DeqA1PWFOLqRjzVgPW4o+aa8ZCZk4Nyqj5ExllMaCEvBZ
         Sl3RUKHvFdgXGCs+TDAl8N9yb3kU+iF+pC3RE+WGKX21ZRGEWdd1s4TqBOIlcQH0Sw1O
         4MQ6yDhTdH9Oqqg0qKDsDOsa/RJ1J53BGK3XjU1wlkAE2bZqH0+zn8e/CFzvg6u8c4Qp
         NayQ==
X-Gm-Message-State: AJIora/4cfLpl0pzYpS2I+R0Pel2HVvq+JFl/nmoN/R8aIdvVEfl8sMC
        duFJS5ZN9gYdN3ffQE6GHDsvAQdR56EYsJ/y
X-Google-Smtp-Source: AGRyM1sv2L9g8a7YVjYlWgeX73C7xpsprRP8xkdXou1418q8yonzr7BHvxNEotcObzEawIhT3+fQjg==
X-Received: by 2002:a17:902:bc45:b0:16b:d5bf:c465 with SMTP id t5-20020a170902bc4500b0016bd5bfc465mr25927709plz.128.1657655548889;
        Tue, 12 Jul 2022 12:52:28 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j6-20020a634a46000000b0040cfb5151fcsm6510359pgl.74.2022.07.12.12.52.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 12:52:28 -0700 (PDT)
Message-ID: <62cdd0fc.1c69fb81.16f5d.96f1@mx.google.com>
Date:   Tue, 12 Jul 2022 12:52:28 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.11
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.18.y baseline: 151 runs, 2 regressions (v5.18.11)
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

stable/linux-5.18.y baseline: 151 runs, 2 regressions (v5.18.11)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig       | regre=
ssions
----------------+-------+--------------+----------+-----------------+------=
------
imx8mn-ddr4-evk | arm64 | lab-nxp      | gcc-10   | defconfig       | 1    =
      =

jetson-tk1      | arm   | lab-baylibre | gcc-10   | tegra_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.18.y/kernel=
/v5.18.11/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.18.y
  Describe: v5.18.11
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      d39cd8e451f0e1a61060db914b14967d7ac50490 =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig       | regre=
ssions
----------------+-------+--------------+----------+-----------------+------=
------
imx8mn-ddr4-evk | arm64 | lab-nxp      | gcc-10   | defconfig       | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62cd9c1b550629401fa39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.11/a=
rm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.11/a=
rm64/defconfig/gcc-10/lab-nxp/baseline-imx8mn-ddr4-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/arm64/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cd9c1b550629401fa39=
bd9
        new failure (last pass: v5.18.10) =

 =



platform        | arch  | lab          | compiler | defconfig       | regre=
ssions
----------------+-------+--------------+----------+-----------------+------=
------
jetson-tk1      | arm   | lab-baylibre | gcc-10   | tegra_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/62cda96e8dfa29a70ba39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.18.y/v5.18.11/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.18.y/v5.18.11/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220708.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62cda96e8dfa29a70ba39=
bce
        failing since 43 days (last pass: v5.18, first fail: v5.18.1) =

 =20
