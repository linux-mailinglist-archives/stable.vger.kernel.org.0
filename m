Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E150C54ED33
	for <lists+stable@lfdr.de>; Fri, 17 Jun 2022 00:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378866AbiFPWT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jun 2022 18:19:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiFPWT5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Jun 2022 18:19:57 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C185260A9F
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 15:19:56 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id e11so2646173pfj.5
        for <stable@vger.kernel.org>; Thu, 16 Jun 2022 15:19:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=W/9cD0IX3vOGDZykW8PAPR+85qjQkrVvKkEU/Aeye38=;
        b=uhPee5KURmWc9PHUthf3+4p23OGA7N9NUgyCrNx4sVRGj8dgNrPx2drqH67JobLlRR
         DAvAG/ZM9egubyJhL+iuW1XE5Cc9AYEzl/baRP0FohEUPt63d9aZMsk3eFfWlGG3O+j6
         hYKo8PRHRMQTdJYmIxfr5QAxG0GMytctIZttRRnMYYTqvBEcRxUzWis3w3RC1+TRguc+
         J5l8C5xNIr1E5RBKXFdV4Dgn6MEJTJjhHnKEVK2Ux+FfYXtSM/JjqQY0XxdvUFNRdP2H
         QAXCbRlKQgYAPjB0yC/5iA28oqmsJRGA5Sq0cBwFdnCZ9iy2fQevY4tBUr2zb2F9UcoE
         UXpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=W/9cD0IX3vOGDZykW8PAPR+85qjQkrVvKkEU/Aeye38=;
        b=S6ptk5CmPlzyvmOyoZ/F0b711qCJvhVAah7oNrnoixDDQxfdCUszRDRuYT0BYREmND
         RmsXLE8LyAg0A8Tkj/sgD8n3wKteKuU31yCYp481vxmOsw0LVB5ymVxjVopVv4R27NId
         +BayID37O7PX1EGHhWik9ZutpwDJQKgs5fK+wqxy6hmXjxz3YeVTqMDaWMUFqfP5G3F4
         BVfrrPD3hAHkcF/Vpn5I2f5sKGn9tRjPhmdYJCBWtp7wuegZMmhWzl4gT+LAm3Jevo7G
         aFWcpbOlkyVz1b6fGrT9vIKjPLeHExAIIsiFuPbJF+WVnPlXF17kEpjo7qzl1eBnA2r4
         1lyA==
X-Gm-Message-State: AJIora+NOUcAxnkI7MuSNDISVslSfmZBSglcwIN1UGOP0RqyKpmYJCms
        FzPn//sh1mypiYNr4NYjCcmmFBVbASra19Th3u0=
X-Google-Smtp-Source: AGRyM1ulNEIZlA3DiBjIwgRTy8fFUzxuvNTP5MD91LTKRbT4mByiR52oNisblV8tSfePDMUXe8iK9w==
X-Received: by 2002:a63:d013:0:b0:3fc:e50f:8e2a with SMTP id z19-20020a63d013000000b003fce50f8e2amr6397684pgf.283.1655417996131;
        Thu, 16 Jun 2022 15:19:56 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id q1-20020a170902f34100b0016797c486e4sm2073636ple.259.2022.06.16.15.19.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 15:19:55 -0700 (PDT)
Message-ID: <62abac8b.1c69fb81.73396.3363@mx.google.com>
Date:   Thu, 16 Jun 2022 15:19:55 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.18.5
X-Kernelci-Branch: linux-5.18.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.18.y baseline: 69 runs, 2 regressions (v5.18.5)
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

stable-rc/linux-5.18.y baseline: 69 runs, 2 regressions (v5.18.5)

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


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.18.y/ker=
nel/v5.18.5/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.18.y
  Describe: v5.18.5
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      71563d69a8ec34d41857aca6040e90d54f566ee4 =



Test Regressions
---------------- =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | multi_v7_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62ab75aada7ebedc65a39c19

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
/arm/multi_v7_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab75aada7ebedc65a39=
c1a
        failing since 3 days (last pass: v5.18.2-880-g09bf95a7c28a7, first =
fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =



platform   | arch | lab          | compiler | defconfig          | regressi=
ons
-----------+------+--------------+----------+--------------------+---------=
---
jetson-tk1 | arm  | lab-baylibre | gcc-10   | tegra_defconfig    | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/62ab7442aa9a12a8f9a39bd8

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: tegra_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.18.y/v5.18.5=
/arm/tegra_defconfig/gcc-10/lab-baylibre/baseline-jetson-tk1.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/buildroo=
t-baseline/20220610.1/armel/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/62ab7442aa9a12a8f9a39=
bd9
        failing since 3 days (last pass: v5.18.2-880-g09bf95a7c28a7, first =
fail: v5.18.2-1220-gd5ac9cd9153f6) =

 =20
