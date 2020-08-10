Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A64924135D
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 00:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbgHJWps (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 18:45:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbgHJWpr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 18:45:47 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B632DC06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:45:47 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id u128so6537641pfb.6
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 15:45:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=6wipAl5L3YXklN7S6pimt5hWKFS5vTYe7gnJqptZo8U=;
        b=GiICe/lf6mGoo9LNZt5TfkJTAJ+NRH9LnmGDgX0oCs8SomGIrKlX7GCPLG4z6leXzr
         UC8Jz/SQRrY8LKQCUEBwwwT4Iry1LB5MZr0F1K6g8S0YLdUXEzyqV0GumZYSORg1Lu1t
         Hl10t2NWnKjsF+GP85sgsEgjQV7bZLecNehS0AFA9utacH7B3aAwUnL6K5Ip/c6pgrsN
         g6LLfVjy5a2EbL6/NPSM0MQiTh3aUaSXbmjGrdcKIT3k+L2ZrrJVSdmNhBVtfQGjAM1j
         ur/ukkC6to3bqR5Krf0DlioZccWdmUlw8zLRtZHzf5Flqa+OWJT/dtX+/OQOJLlV+pPo
         +qHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=6wipAl5L3YXklN7S6pimt5hWKFS5vTYe7gnJqptZo8U=;
        b=i0DuF4EYOqiuKNRvLFz6AzJD0KbQFH7E9ZbApr7i5uaL9EoFBglNcmFdqbch/zp6Zq
         IFwOTFKfvaHjUc8dNLk3QIcjFf7VgbdlT16Gekr6At/GgIM7HJ4qrVk64vm0iayQ2LdC
         7ndUWw4eUawLA3eAEpLUDgGE7bMQCfC71VsTAAIiyQYOkIqosVMJxWhvFrBynxyAUspc
         FO2hO+DLJXQ6y5JsG447viihovC5QFtvJwd1shbaY8PEcS9mLfxcDcMtBrTPJwW54fGI
         TYnMjXZUYbahVIzhxBx+lhbiyHcKmpd+CzJeUThYyINMuA/h8Bl7w0isTBRQKqU6nWFr
         cBLw==
X-Gm-Message-State: AOAM530zd7rzliSU/nxJj5Da9Y57rE2+yee4rRTlwEIkGeQA27NYViJI
        +DaHJwTXfFHPNySqqY4k1s8jvzP5mfQ=
X-Google-Smtp-Source: ABdhPJzKcH9LCyUXc+uBQmIOGAKHVaoahDE3yJ42ZKGZRJI6wAoJfFcavnpZm+ll1iSOmM/JXalYsg==
X-Received: by 2002:a63:7e52:: with SMTP id o18mr22901813pgn.273.1597099546558;
        Mon, 10 Aug 2020 15:45:46 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id z5sm20840540pfk.15.2020.08.10.15.45.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 15:45:45 -0700 (PDT)
Message-ID: <5f31ce19.1c69fb81.31700.10e6@mx.google.com>
Date:   Mon, 10 Aug 2020 15:45:45 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.138-49-gb0e1bc72f7dd
X-Kernelci-Branch: linux-4.19.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-4.19.y baseline: 156 runs,
 2 regressions (v4.19.138-49-gb0e1bc72f7dd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-4.19.y baseline: 156 runs, 2 regressions (v4.19.138-49-gb0e=
1bc72f7dd)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =

hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-4.19.y/ker=
nel/v4.19.138-49-gb0e1bc72f7dd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-4.19.y
  Describe: v4.19.138-49-gb0e1bc72f7dd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b0e1bc72f7ddff40c7c5b68313d3ac76495d678d =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f3197d5b82805ec2652c2ed

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
38-49-gb0e1bc72f7dd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
38-49-gb0e1bc72f7dd/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sa=
ma5d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f3197d5b82805ec2652c=
2ee
      failing since 55 days (last pass: v4.19.126-55-gf6c346f2d42d, first f=
ail: v4.19.126-113-gd694d4388e88) =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
hsdk                  | arc  | lab-baylibre | gcc-8    | hsdk_defconfig  | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f31976e687e31a1eb52c1b7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: hsdk_defconfig
  Compiler:    gcc-8 (arc-elf32-gcc (ARCompact/ARCv2 ISA elf32 toolchain 20=
19.03-rc1) 8.3.1 20190225)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
38-49-gb0e1bc72f7dd/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-4.19.y/v4.19.1=
38-49-gb0e1bc72f7dd/arc/hsdk_defconfig/gcc-8/lab-baylibre/baseline-hsdk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/arc/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31976e687e31a1eb52c=
1b8
      failing since 21 days (last pass: v4.19.125-93-g80718197a8a3, first f=
ail: v4.19.133-134-g9d319b54cc24) =20
