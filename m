Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4D81241427
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 02:29:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgHKA3y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 20:29:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgHKA3y (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 20:29:54 -0400
Received: from mail-pj1-x1031.google.com (mail-pj1-x1031.google.com [IPv6:2607:f8b0:4864:20::1031])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A118CC06174A
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 17:29:52 -0700 (PDT)
Received: by mail-pj1-x1031.google.com with SMTP id l60so955903pjb.3
        for <stable@vger.kernel.org>; Mon, 10 Aug 2020 17:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=x8DzXM31uHcm3/Qx76xuYZ8/9y7DUmCCApyW5/h4V0Y=;
        b=1Hdke4I1R6MnAtvI3g1R9qKTBcleL1ofNmcfZhmqN7Q9Qpc7UTexX6KoyrBn1Wtx7J
         cGVQzWx+Vrs9lHPkDFgfgiLk6LAagiSAkvLNX4c4liJsrsmD1Tp/kAyo+jEiSiM7MZtj
         eKLnQNqLym68y+CCXbHTKcimjj6+dLj9UNfz5aQRsESLFpDYNFLwlTaR70RbaL2rPY/v
         8INdCCMxAvq1cELAorVaFN7Jmp0cY24l1swuok4m+DZdm8n3Q9eOs9USFHXEX53FyFPO
         PlWU8c9cabtXt+XFNhTjtOPp4HFDPRrGf3MAX5fJUBl73TMM7sxp52RyyN5kCNtbxMbO
         Nn0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=x8DzXM31uHcm3/Qx76xuYZ8/9y7DUmCCApyW5/h4V0Y=;
        b=K4RGh/LPYRPrvQ7bjGyjzdU3r/ecaTmjs2HiudDCgvUU50DRIUIfokgPUHIXYJtIUN
         Y5n5UDMX2yE8KncldFIzWZKSVY47JvC3BMhzr6jh8+19wYN0uXKAFbaZBQx2I6DwIaGH
         3OP+bKT67g6riGkF5Ocf8DSmbJdMJKqLzauum9kft7TUXyxPoCNDvM/IA6OP4iM27Y3O
         VPvb9Ck7Q3Dz483n++emWsqzcaGfJVDG4/n0rV0MMDnsL9v1lP4wETrmHYTWBRzL3wMa
         AEgZopZbW2DC6eEJPmun1NbktG6o0VZpZey/AIY72A9J8CTWzK4fkF2X9jgS4qtythi8
         Pouw==
X-Gm-Message-State: AOAM533iwPvjgb18GDak0fv75B0qmnhgS8gtyT5kfVLZd6DyBMj5doyt
        OAl7XjctYwmiLRT6txK4b1s/cozvmnk=
X-Google-Smtp-Source: ABdhPJxPdu3fMMzuwku80MYiLoXTYyi7yFCZjtCcGCcNzeqJ79Xi8t+SqRm4m6RwDk6HUQlHrvGa/g==
X-Received: by 2002:a17:90a:d34b:: with SMTP id i11mr1892942pjx.125.1597105791667;
        Mon, 10 Aug 2020 17:29:51 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s67sm25842967pfs.117.2020.08.10.17.29.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2020 17:29:50 -0700 (PDT)
Message-ID: <5f31e67e.1c69fb81.38d49.e26a@mx.google.com>
Date:   Mon, 10 Aug 2020 17:29:50 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.4.57-68-g133d9613b2c8
X-Kernelci-Branch: linux-5.4.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.4.y baseline: 167 runs,
 1 regressions (v5.4.57-68-g133d9613b2c8)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.4.y baseline: 167 runs, 1 regressions (v5.4.57-68-g133d96=
13b2c8)

Regressions Summary
-------------------

platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.4.y/kern=
el/v5.4.57-68-g133d9613b2c8/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.4.y
  Describe: v5.4.57-68-g133d9613b2c8
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      133d9613b2c88c60658eda244e2658dd07294b5e =



Test Regressions
---------------- =



platform              | arch | lab          | compiler | defconfig       | =
results
----------------------+------+--------------+----------+-----------------+-=
-------
at91-sama5d4_xplained | arm  | lab-baylibre | gcc-8    | sama5_defconfig | =
0/1    =


  Details:     https://kernelci.org/test/plan/id/5f31af97eeb45179ab52c1c9

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: sama5_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.57-=
68-g133d9613b2c8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.4.y/v5.4.57-=
68-g133d9613b2c8/arm/sama5_defconfig/gcc-8/lab-baylibre/baseline-at91-sama5=
d4_xplained.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05/armel/baseline/rootfs.cpio.gz =


  * baseline.login: https://kernelci.org/test/case/id/5f31af97eeb45179ab52c=
1ca
      failing since 121 days (last pass: v5.4.30-54-g6f04e8ca5355, first fa=
il: v5.4.30-81-gf163418797b9) =20
