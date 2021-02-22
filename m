Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 038C5321F2D
	for <lists+stable@lfdr.de>; Mon, 22 Feb 2021 19:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232611AbhBVS3T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Feb 2021 13:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232684AbhBVS20 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Feb 2021 13:28:26 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A975EC06174A
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:27:36 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id f8so8266109plg.5
        for <stable@vger.kernel.org>; Mon, 22 Feb 2021 10:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LCcrIe0Uuh7yRviCcmBNAVgNr0bAAPQyPeN877d7R6k=;
        b=C4W3hlE43BOgRr8XbBBGWjFMd1mKw4pSgoyRP+DCgJ1i34dI1qS8/MHUR2iv5MSlgh
         IFUMLjdwvR3E3G7/VQHSNJSeSRNYzahsvhBkwmHt3taeEaMQB9BOMG26Asg8lgiqS0pJ
         lQyonmhBaNjmpl9p4y/FLSEgtlHeu6e6KSYeNoixbVT24dhzLQk15diOiPHivCLul2oh
         17ZAAtbSPdSCK5HLaWbcrUVRAa1S4jgirLnjO0+L6eGOlIzz6SedFMhGkl2zZONkmFF+
         yYcNECswPiw8hMFn2CDJeeKC3BdWt80pF/pLLbKu0N7UVjBSvuvMfwUPIVZPDHjKvCfe
         WsrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LCcrIe0Uuh7yRviCcmBNAVgNr0bAAPQyPeN877d7R6k=;
        b=LKkubdBlQdbnW77JQuQ8Qx2dcgfZZUHqpltr4ZfEHksp5ggxFyBM8R2xHQ9lINvyaM
         atuG+O46P4uO3FX8BUMFw5ZnkPXSy3A1MJcVtd64bJJ4lM8JTrmoI9k6otC+MFt34a8I
         tmpw50qubUEKhdvkNwzlvoy3vGsX5N6ob250w/DxB59s3Q/N5OOI6eRyF8QTI1AEje8A
         Mt6YWc9h8kKrUbzDK43+edniiHyj3yi+9i/aYLLKvy08Ab6YWlTMtmCaVD69wWyJ4f0O
         p10Qr7W73bPMLJSGYJGAE9WQJMVsdyUo5soxtH6bYHrT15rcQ8pPKzYdPhfaWML7JPXy
         vTdQ==
X-Gm-Message-State: AOAM532QdK7hLn4W4mqqmSYum4f9ygv+6abvLTz1g0z+583iUaa3BYzK
        9ZOAX7LLubK5HqvtdzfC7+tQ+5sfJXZDQw==
X-Google-Smtp-Source: ABdhPJzsyAa3Hu8hk8LisQQenudaJdTbnmQzo9Mk7/KC6K2ExDeGi8i+MnuOJ9QRuZF0PnWRFyRHPA==
X-Received: by 2002:a17:902:eb06:b029:e3:dcd1:190 with SMTP id l6-20020a170902eb06b02900e3dcd10190mr11636632plb.85.1614018455724;
        Mon, 22 Feb 2021 10:27:35 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id r13sm8424183pfg.37.2021.02.22.10.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 10:27:35 -0800 (PST)
Message-ID: <6033f797.1c69fb81.d991c.0bd7@mx.google.com>
Date:   Mon, 22 Feb 2021 10:27:35 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v4.4.257-35-ge2264b5a7f4d
X-Kernelci-Report-Type: test
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/4.4
Subject: stable-rc/queue/4.4 baseline: 40 runs,
 1 regressions (v4.4.257-35-ge2264b5a7f4d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.4 baseline: 40 runs, 1 regressions (v4.4.257-35-ge2264b5a=
7f4d)

Regressions Summary
-------------------

platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.4/kern=
el/v4.4.257-35-ge2264b5a7f4d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.4
  Describe: v4.4.257-35-ge2264b5a7f4d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      e2264b5a7f4db2120f47537e067880a7bd650015 =



Test Regressions
---------------- =



platform   | arch | lab             | compiler | defconfig          | regre=
ssions
-----------+------+-----------------+----------+--------------------+------=
------
dove-cubox | arm  | lab-pengutronix | gcc-8    | mvebu_v7_defconfig | 1    =
      =


  Details:     https://kernelci.org/test/plan/id/6033c726b79f40ba98addd05

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: mvebu_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-3=
5-ge2264b5a7f4d/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.4/v4.4.257-3=
5-ge2264b5a7f4d/arm/mvebu_v7_defconfig/gcc-8/lab-pengutronix/baseline-dove-=
cubox.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6033c726b79f40ba98add=
d06
        new failure (last pass: v4.4.257-35-g748b93344eca) =

 =20
