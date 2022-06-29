Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04D22560128
	for <lists+stable@lfdr.de>; Wed, 29 Jun 2022 15:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231915AbiF2NUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 09:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233742AbiF2NUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 09:20:45 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65D6A34B9C
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 06:20:44 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id m14so14112024plg.5
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 06:20:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cXDfW6PCb7auwy3NE8KSs4+/cF6fsvEVTCaPu6LuuNA=;
        b=wqxzhw4legOCNOG9SrZJwo8bR2XdLavSJNNB9YLGNiEYP0zCdnJHIFqUm4oJ56i2QC
         W2GKpluN2ik8uxZAIDnVk3kdT6reTB4D60axZJYPe9nkDgnvbSiL4g3upBYQafU2TPe0
         hJ6Bs6CKBp3OcKzwl/kKJ4Py/vcHhgYFn7SXs1/u6UC8c13amMamlT7xlPo/i5b+jSPL
         yY2SLB34soDvGhig8T61c7ao0iNm1l5WbOvp7ybW+98tN10/wiEJp15Oxx7g49q6Nvb7
         BrCdqHRvTOwySAK7CAfXEak+ChH9YqIrGM3lLmy9B4HpgqNMQzlJ7k4hpzZu5CyQ0Bnc
         iklw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cXDfW6PCb7auwy3NE8KSs4+/cF6fsvEVTCaPu6LuuNA=;
        b=uDdhWy8uK9HwwQtC7IrhObYLGUvDwoD7CnYZtKAN2BIzuYnJ8VsGow75vSqcy71fW1
         /UtuoCc3P8jAg3/QkcW+/SIG6PXS3W4XMekaKP+5c7QIT5yuxJFvs7oZYgqzbILWEr+B
         Ag/R1ee5xPmQzDi5NAjYMmYDWZnuKWXyMA3Uj6n89yb2pBOdYiE2PYDgAsop2OErewzu
         0Irlq2eOY6TQoLdZ/wydRIj8GRHO1QreU+tGaIXp9aW2ytIeIZotVQ/uXKbLM0K2BkEA
         SfSLKO9EC/KLcr2QWX1tprE0I+kPjMjDq0q2kdICdtT3AN7KKaEndt9dmu+cck0dtjkF
         qNWQ==
X-Gm-Message-State: AJIora9N2DSM+lzeTrJ64rg8Ed2Z+kDNKzaNgS8vSHuJxTetxhQyh4JQ
        50+TKAy27tQYEkpSKo2W259Gn4+EtAu5oox+
X-Google-Smtp-Source: AGRyM1syKotA+8WsARDW8aWih6YkfZ0sbabKWJox7GJEHNtWSs+tza8Uf8mpGSqLCkoZQ3x7zWBr1Q==
X-Received: by 2002:a17:902:ef8e:b0:16a:5449:2012 with SMTP id iz14-20020a170902ef8e00b0016a54492012mr10483580plb.46.1656508843773;
        Wed, 29 Jun 2022 06:20:43 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id c13-20020a170902c1cd00b0016a276aada7sm11407831plc.20.2022.06.29.06.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jun 2022 06:20:43 -0700 (PDT)
Message-ID: <62bc51ab.1c69fb81.fc005.0351@mx.google.com>
Date:   Wed, 29 Jun 2022 06:20:43 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.15.51
X-Kernelci-Branch: linux-5.15.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.15.y baseline: 129 runs, 2 regressions (v5.15.51)
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

stable/linux-5.15.y baseline: 129 runs, 2 regressions (v5.15.51)

Regressions Summary
-------------------

platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =

rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.15.y/kernel=
/v5.15.51/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.15.y
  Describe: v5.15.51
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      37238449af786e1be06f193ab54a60a39a776826 =



Test Regressions
---------------- =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
jetson-tk1       | arm   | lab-baylibre  | gcc-10   | tegra_defconfig      =
      | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc1b71d8cd31edf2a39c1d

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.51/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.51/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62bc1b71d8cd31edf2a39=
c1e
        failing since 34 days (last pass: v5.15.39, first fail: v5.15.42) =

 =



platform         | arch  | lab           | compiler | defconfig            =
      | regressions
-----------------+-------+---------------+----------+----------------------=
------+------------
rk3399-gru-kevin | arm64 | lab-collabora | gcc-10   | defconfig+arm64-chrom=
ebook | 1          =


  Details:     https://kernelci.org/test/plan/id/62bc1bfcec4dca0df5a39c63

  Results:     88 PASS, 4 FAIL, 0 SKIP
  Full config: defconfig+arm64-chromebook
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.15.y/v5.15.51/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.15.y/v5.15.51/a=
rm64/defconfig+arm64-chromebook/gcc-10/lab-collabora/baseline-rk3399-gru-ke=
vin.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220624.0/arm64/rootfs.cpio.gz =



  * baseline.bootrr.rockchip-i2s1-probed: https://kernelci.org/test/case/id=
/62bc1bfdec4dca0df5a39c89
        failing since 112 days (last pass: v5.15.25, first fail: v5.15.27)

    2022-06-29T09:31:29.520018  <8>[   59.333761] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s0-probed RESULT=3Dpass>
    2022-06-29T09:31:30.542842  /lava-6705773/1/../bin/lava-test-case
    2022-06-29T09:31:30.552982  <8>[   60.367157] <LAVA_SIGNAL_TESTCASE TES=
T_CASE_ID=3Drockchip-i2s1-probed RESULT=3Dfail>   =

 =20
