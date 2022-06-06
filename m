Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FB4D53E854
	for <lists+stable@lfdr.de>; Mon,  6 Jun 2022 19:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238115AbiFFNHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Jun 2022 09:07:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238336AbiFFNHf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Jun 2022 09:07:35 -0400
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AFC3233
        for <stable@vger.kernel.org>; Mon,  6 Jun 2022 06:07:31 -0700 (PDT)
Received: by mail-vs1-xe2e.google.com with SMTP id f1so1175134vsv.5
        for <stable@vger.kernel.org>; Mon, 06 Jun 2022 06:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=OXKzMQx6QuR0u+YsVqOPpEK2TCXJkoVbPKzkvWtW9PY=;
        b=4MDlu5Vz0ZacIZSnnG23Kx2A8N/fwN9KpE+h7qp+MmFCuHBsh4UzbzTFSY7XHq2uwW
         BUg576PCg2EcyQ7xoyX4lMC9uGM/zrc+13y6haJR+N2mYHwkPZHJC2mo730vOR0Bz2wH
         n3+4y7uZXlcskdufkaYT72MSoEPzNI00yi98E7B07FL+WIK55hU/gow7SOVav4gNh1X/
         2gIJ/6gYzrAVf11pDzMbaXYzza9+/VKE9lg2npOODRJQl+CcwjlsgdTmLVOg0cnrEALm
         RcLhGS56RjzofFtOYZ2S4jPaueANeMJtXlyihtyKM8S/kZP0VGbwdupEtwu+lxtNMJdN
         AP0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=OXKzMQx6QuR0u+YsVqOPpEK2TCXJkoVbPKzkvWtW9PY=;
        b=5jO3UhpgGclBXkXvkoDJbiFrAdFFfzwZfkpP2edRB0eTyRTEqCRp0ydspN5OU+o3Im
         dyC00czOgaU5t4IXal58qCRP9I0RZLZYgmcaoNXTfmT9Mie8K6NwCKavCJfu4OTv0omM
         JMyQOkrC8s1qCJrk0t1NSM8Hvj9yR8tbrw18kb/jDpPhH+CG9bsP+uIL+n4Kf0TxM5z6
         THky+SXxdPUBjf7y2b7m/v7BJvu6xYLnA7P3hUflnciR3iKh7YhE/J79MtPsf7OYYx9y
         OFi7DE0dE5/sZQ3I3EI6oC2QsXs5XdZUpDGi/j3VrjxM8uS8ju60BG+vhzLJlPvGUlqI
         cPIw==
X-Gm-Message-State: AOAM531zv0bkJy/7Z6SxgustHGDkgs17KHe8TYgPrClqEHbAnpvt1UYb
        d16Sq5WLuZPt40qIPdsdDzxni187z3Gxy3VR
X-Google-Smtp-Source: ABdhPJytwvpDiA/SQ3kjbMUrq67WmVf3CIk8U54caV8s4hgPGbpj9TH2YcSv/KbvEqDzxxh7APvzOQ==
X-Received: by 2002:a17:902:c941:b0:164:14cb:ce5f with SMTP id i1-20020a170902c94100b0016414cbce5fmr23720429pla.127.1654520839437;
        Mon, 06 Jun 2022 06:07:19 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id cp14-20020a170902e78e00b0015e8d4eb1d3sm10420911plb.29.2022.06.06.06.07.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jun 2022 06:07:18 -0700 (PDT)
Message-ID: <629dfc06.1c69fb81.97d31.7f1e@mx.google.com>
Date:   Mon, 06 Jun 2022 06:07:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.17.13
X-Kernelci-Branch: linux-5.17.y
X-Kernelci-Tree: stable
Subject: stable/linux-5.17.y baseline: 112 runs, 2 regressions (v5.17.13)
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

stable/linux-5.17.y baseline: 112 runs, 2 regressions (v5.17.13)

Regressions Summary
-------------------

platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig | 1  =
        =

tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable/branch/linux-5.17.y/kernel=
/v5.17.13/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-5.17.y
  Describe: v5.17.13
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      8eb69e8f0d4544de764ab03c5b292ead949d9ac1 =



Test Regressions
---------------- =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
jetson-tk1        | arm  | lab-baylibre  | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/629dcb31a009ddc494a39bfa

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.13/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.13/a=
rm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629dcb31a009ddc494a39=
bfb
        failing since 11 days (last pass: v5.17.8, first fail: v5.17.10) =

 =



platform          | arch | lab           | compiler | defconfig       | reg=
ressions
------------------+------+---------------+----------+-----------------+----=
--------
tegra124-nyan-big | arm  | lab-collabora | gcc-10   | tegra_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/629dfa43146f4780c1a39bcd

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable/linux-5.17.y/v5.17.13/a=
rm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.txt
  HTML log:    https://storage.kernelci.org//stable/linux-5.17.y/v5.17.13/a=
rm/tegra_defconfig/gcc-10/lab-collabora/baseline-tegra124-nyan-big.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220527.0/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/629dfa43146f4780c1a39=
bce
        new failure (last pass: v5.17.10) =

 =20
