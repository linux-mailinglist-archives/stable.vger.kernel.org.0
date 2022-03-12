Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAD14D6D3C
	for <lists+stable@lfdr.de>; Sat, 12 Mar 2022 08:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231220AbiCLHdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Mar 2022 02:33:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbiCLHdt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Mar 2022 02:33:49 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 181B421CD37
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 23:32:43 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id m11-20020a17090a7f8b00b001beef6143a8so10101621pjl.4
        for <stable@vger.kernel.org>; Fri, 11 Mar 2022 23:32:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=cmopq649m+Cbp05LV53x4+w54FsHRY2LCU30zRzAQgA=;
        b=78ECjhX5m+QBQFc0Nyid5hRA03Nn0xnkGlzmhIBsXPEEMflX8NnIuZHjRsx2WqmiuG
         yo8Si+RDD2S97FZf75+7Y5LM3xTvJycJm+77o3N1Bn/fZc/0Lfl5DnTfBaDNnpIjVdh+
         sX+tkzweBIbImBxTI/0ne6D4fRb6jNc7Nm/ITQcP3xfL66My4/NsfJ3xpliuEx14yrux
         UlvjHT+cyeS5mqdbsEpOgTJ5TSuQhbbX71Vq0uqo35k2WBO4IN5yhMOTELNfgOf3XSaW
         mUXFgItyGBYwRYJ7V/q86JSOC3+dGcsB+bOkZIj81X+OrErY0PbkX4TIvKISwWHGXwMV
         8FpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=cmopq649m+Cbp05LV53x4+w54FsHRY2LCU30zRzAQgA=;
        b=U1PtcQ0HLwLm3tcOlak+/H1plBtexpl+7UFG/8a9AbxXFQoFgmx436r2zPREesYo4x
         w68y7vkVslkAVL4h0EkAQG0aI2mVvZo3ONlL21KokwBFwdN1wuYEI3wDxZEzjfZvr3qW
         TE5J3ry+qjwrwkd8uKFBqj6i+jOIlXgdHzUTo0sVpBZ56SGrtfbP2mRHPwgUyf0Kk+rj
         ogOveP6GDZ5JT6IunWrI5UBVb6r4JhrowXZacaTOCtWsCjIlpAw6gdwXYBgdc+Rw4lyN
         F26gwRHjBexup22MUPID7JN9dG0/36ZXe+8u6BF19n/tKVtnuT2wYHgacI2qDcl075rB
         0E/w==
X-Gm-Message-State: AOAM5311gYJ5kMKxBVMN/XlTvFP6BcDYWLeUmBymDjXB2TpkievmI5Th
        WKpLW2WLjEn6LNTCN7UAcTxdzJRbiw48sxHD17w=
X-Google-Smtp-Source: ABdhPJyLuVKi/Cev0jtwxOVijX6KCUHHI084B6A85KhdQl7fJTBycj5ymP/ll77Sw11OiMWaLmQqUw==
X-Received: by 2002:a17:90b:4b4d:b0:1c5:c908:8645 with SMTP id mi13-20020a17090b4b4d00b001c5c9088645mr3343354pjb.133.1647070362464;
        Fri, 11 Mar 2022 23:32:42 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b1-20020a17090aa58100b001bcb7bad374sm14656436pjq.17.2022.03.11.23.32.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Mar 2022 23:32:42 -0800 (PST)
Message-ID: <622c4c9a.1c69fb81.2dfa8.6460@mx.google.com>
Date:   Fri, 11 Mar 2022 23:32:42 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-4.9.y
X-Kernelci-Kernel: v4.9.305-39-g274dadc1cdeb
Subject: stable-rc/linux-4.9.y baseline: 38 runs,
 1 regressions (v4.9.305-39-g274dadc1cdeb)
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

stable-rc/linux-4.9.y baseline: 38 runs, 1 regressions (v4.9.305-39-g274dad=
c1cdeb)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.9.y/kern=
el/v4.9.305-39-g274dadc1cdeb/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.9.y
  Describe: v4.9.305-39-g274dadc1cdeb
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      274dadc1cdeb33ce11f6d23f6b89e75249d8f8c4 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/622c148b6e76f1bb77c62977

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.305=
-39-g274dadc1cdeb/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.9.y/v4.9.305=
-39-g274dadc1cdeb/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220228.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/622c148b6e76f1bb77c62=
978
        new failure (last pass: v4.9.301-35-g133617288e03) =

 =20
