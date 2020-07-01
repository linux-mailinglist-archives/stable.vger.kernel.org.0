Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F04262112E4
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 20:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726049AbgGASkx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 14:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbgGASkw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jul 2020 14:40:52 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE59FC08C5C1
        for <stable@vger.kernel.org>; Wed,  1 Jul 2020 11:40:52 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id x11so10240922plo.7
        for <stable@vger.kernel.org>; Wed, 01 Jul 2020 11:40:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PTyxC1OSbI2izaSYHgc9zWUL9SrLfXUNSp6ajoahcLE=;
        b=Zf7gRMsl5eF6v+vAxQ2i3y2y495iTaevIS2nvCztcTFM5EktS5eNBaTXJhTD3wP1hR
         P1I7bHd6YJ76iyIXQ95Se4BRDpCf7hhyG6nnHJbfOP7aWKrej8vJO+xRXbx30P6MHG1N
         qZ/yRuB5rB1HtOUIDOMcki/YmIyb4XgRR2lAeRxXRnCun2z85c5wkX7Pryd0yB+IFqqG
         ktWsL9yPNUfeO/O00aOixkjmQgE4Q5QXaunW1Ye3VxJ8PnfU2HxoIYYLs/zoLoTrM7r7
         xG2J1Qq7PnDYuBa/MK1HOHA2rMoraff5A7gqGFjNWNHnr9fRVCca9K8NgU7FHjfPpBQU
         flkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PTyxC1OSbI2izaSYHgc9zWUL9SrLfXUNSp6ajoahcLE=;
        b=t2rh0I1f7MPYDuQSifd5dxTtmg6jcts3gztjpZZ8xxv4pNJGN1fmzkfDzguXdU/SVG
         zNBl68OgRC0bPiO0VS3Bl04JjIcNIxlh1GzJyEBK/6PsVqIW992aFKbORuivVJtajRXF
         IPqfY6Ahe09r+bZ+dzWIno3oWSU1oN10/sF2iLOhZBHWKgcDsA4whtlafkhi4+CBXkM6
         EKIlmgla4PvoPm94KRp1mTPcbtwcWO6ky4TfjRHCfAxGyyAGSna1YmyrbADtP9uL3ttV
         gg9x5XY8lgLeTfDIT+U9dyrxrrGj3OiBfgyM+bIXWbGqZz7EaYacLuoaNfT0X3pWLu4s
         fc/A==
X-Gm-Message-State: AOAM533BLlCT6G09SFrmIk8xU7mz4amxZk9XcrjjREvXpPRGpfqZjSKO
        W1L70uOi3FP1gMAqZce+VbC8LlWhfZM=
X-Google-Smtp-Source: ABdhPJw2oojfTfsT0fzHK/BudqrAGz19AUY6jjhccsT6do5OOA5gBuiFkGfgEAQon/ZknHeTLyWJMg==
X-Received: by 2002:a17:90a:ea18:: with SMTP id w24mr27733135pjy.42.1593628851822;
        Wed, 01 Jul 2020 11:40:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id m19sm6224805pfa.114.2020.07.01.11.40.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jul 2020 11:40:51 -0700 (PDT)
Message-ID: <5efcd8b3.1c69fb81.150c9.09d9@mx.google.com>
Date:   Wed, 01 Jul 2020 11:40:51 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.14.187
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable
X-Kernelci-Branch: linux-4.14.y
Subject: stable/linux-4.14.y baseline: 47 runs, 1 regressions (v4.14.187)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable/linux-4.14.y baseline: 47 runs, 1 regressions (v4.14.187)

Regressions Summary
-------------------

platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:  https://kernelci.org/test/job/stable/branch/linux-4.14.y/kernel=
/v4.14.187/plan/baseline/

  Test:     baseline
  Tree:     stable
  Branch:   linux-4.14.y
  Describe: v4.14.187
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able.git
  SHA:      4139fb08c05fec734f85a99e8b7d99dc12b1b68c =



Test Regressions
---------------- =



platform        | arch  | lab          | compiler | defconfig | results
----------------+-------+--------------+----------+-----------+--------
meson-gxbb-p200 | arm64 | lab-baylibre | gcc-8    | defconfig | 0/1    =


  Details:     https://kernelci.org/test/plan/id/5efc9f1a81eb548d3c85bb23

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable/linux-4.14.y/v4.14.187/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.txt
  HTML log:    https://storage.kernelci.org//stable/linux-4.14.y/v4.14.187/=
arm64/defconfig/gcc-8/lab-baylibre/baseline-meson-gxbb-p200.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2019=
.02-11-g17e793fa4728/arm64/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5efc9f1a81eb548d3c85b=
b24
      failing since 89 days (last pass: v4.14.172, first fail: v4.14.175) =
=20
