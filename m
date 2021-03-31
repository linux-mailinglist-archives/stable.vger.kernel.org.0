Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 274FD34F756
	for <lists+stable@lfdr.de>; Wed, 31 Mar 2021 05:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233462AbhCaDSJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Mar 2021 23:18:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233587AbhCaDRm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Mar 2021 23:17:42 -0400
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BC6AC061574
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 20:17:42 -0700 (PDT)
Received: by mail-pf1-x434.google.com with SMTP id m11so13522895pfc.11
        for <stable@vger.kernel.org>; Tue, 30 Mar 2021 20:17:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=evHCtVMu943mmKDMfYooPGcdjpDkNYXs4KPymZK64ok=;
        b=dMSQzAA4nKXONh+V/F2vN3dEMbWvBkylVad/5z6OZhNLJFCi5A2bExtlXCCHvDa1JH
         MjBhl9klVb933PhhaP4KyPxGLirxvP8o4oDlrYVv+grGMwRmfAOE3Qs8v3M+Gezt+d98
         jbj1GgA8DeurOGPy9C/zd1Vo25b/UiKf5/t0CuJEWA1y6r8OOH+f+QeVXrZ51jtu9P3m
         oNr2pisC09AjS1nT2ZU9qCGnZYH4UrVVFcREK4DLMap/kDWOIilgBhydyb4Nqvz28aFy
         FwQKacm8/iWvaWEEpHYu19lclXGKQ0gRqYABY3wxSeDeDnCKolug10XZvGVewA3UC8wN
         tcig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=evHCtVMu943mmKDMfYooPGcdjpDkNYXs4KPymZK64ok=;
        b=R9xRqErpbiDQ1MdHlUyt7D7+EZ/8iSvyipW1+VtjMCybeOlytb7Tfo2TQJJRkSYLDS
         ZDQYYL7PD4E7sU4na1cLjWB02bWudfVwzJQsivpoA5IyqFz9QgbPzYaHcGbTUyquIq/V
         vve1KftVMqFoqdkU2o8cWflOsufLHmUqavHmt6mp6H8zlxMhEdiZLzhm5Rh27fUM5/To
         OdLWTrO9blo8MpukwbAde81uYuuJc3bQgbnCCDN29pVUCL7VEGUlFpnowzDV5UlvcKR0
         cq26FBI8QlLso3CZ4R49KGgnwbjG2jiNgu00q16LReA67BuIHeoXa9rz97exWzD0tTCc
         TlbA==
X-Gm-Message-State: AOAM533PMJ+JxmZ2dvwcHlICPvVjnfno6+JPQk1ONWkqQbKwrDurgL14
        WtWb4GZ+vBQEIfcjT3EtMsSJd68APZ6d3a6B
X-Google-Smtp-Source: ABdhPJy2w5OtsVQnb+8wtSP+4pGLohL7DyDor6+TJ8PXO8RX/g8X4nguWIUU5MHOVamHSlR9L9MpTg==
X-Received: by 2002:a63:504f:: with SMTP id q15mr1211536pgl.290.1617160661344;
        Tue, 30 Mar 2021 20:17:41 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id g10sm550625pgh.36.2021.03.30.20.17.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 20:17:41 -0700 (PDT)
Message-ID: <6063e9d5.1c69fb81.30a28.2726@mx.google.com>
Date:   Tue, 30 Mar 2021 20:17:41 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.10.27
X-Kernelci-Branch: linux-5.10.y
X-Kernelci-Tree: stable-rc
Subject: stable-rc/linux-5.10.y baseline: 179 runs, 1 regressions (v5.10.27)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.10.y baseline: 179 runs, 1 regressions (v5.10.27)

Regressions Summary
-------------------

platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.10.y/ker=
nel/v5.10.27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.10.y
  Describe: v5.10.27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      472493c8a425f62200882c2c6acb1be2e29b3c03 =



Test Regressions
---------------- =



platform                 | arch | lab          | compiler | defconfig      =
    | regressions
-------------------------+------+--------------+----------+----------------=
----+------------
imx6q-var-dt6customboard | arm  | lab-baylibre | gcc-8    | multi_v7_defcon=
fig | 1          =


  Details:     https://kernelci.org/test/plan/id/6063b4bc8af8be6567dac6b6

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.10.y/v5.10.2=
7/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-imx6q-var-dt6customboa=
rd.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6063b4bc8af8be6567dac=
6b7
        new failure (last pass: v5.10.26-91-gfa9a491e09c62) =

 =20
