Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10D8B282BDA
	for <lists+stable@lfdr.de>; Sun,  4 Oct 2020 18:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726113AbgJDQt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Oct 2020 12:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726077AbgJDQt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Oct 2020 12:49:58 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7EB8C0613CE
        for <stable@vger.kernel.org>; Sun,  4 Oct 2020 09:49:58 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id o20so4901982pfp.11
        for <stable@vger.kernel.org>; Sun, 04 Oct 2020 09:49:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=VzjVR97ZvEFDu3VW6zOMwJ1yU6JRh1UoeEOYGP0Xlrk=;
        b=nvidTNO4IgZiSeQfqdMbZo+H24M20J1y6uSFaPp5mEMiCu2C6A0QoZKOIPrWpQu7Mi
         PrQo4H0BJeGBUhGT29t5o5Jry28qI56lu645pm7T2nxO+NIhoDEDlAkZz/2Kjiu+dvKK
         mAVww2v7EPwKTcwbwPfwCgL7hQRSD+PKXeA+eleoXU26PQCeS2ywvPfqEVG1hD62fl9L
         7T4VlCL2qVT84T2WuCwEr7Tl0X7z9/5t8dUFqrn0p5wNydiC6UzQQUxcQJ+EIZSWBtPl
         by+a5srN7Wajt/I1H2s0uYbPoz8Us/lpC48zLDXlPn41z3cgBq+LhrfNU7X52K9zDjA8
         ACYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=VzjVR97ZvEFDu3VW6zOMwJ1yU6JRh1UoeEOYGP0Xlrk=;
        b=NfpKM6v4rRnMZG9Bf+UcFRRXLk+QFhexxLY9MjQ3P/c8h0/fEBmaOOl5/1Z1dK8coZ
         JQdxgBCjwEg05oshOoOkcNEke9OJqsjMK079M7MzQn+9ZaSwG1Dqi3+g0Hmu8+D/cJjj
         NBUyoeYuWW3M+/Hqyn+zGGMX4B4zPGEEpxWgweyYv43txTfh/Xzd+tgvjdj7Iz4Oi6DO
         81cI4M2118SYDxFrsreaCVO4BIamUI2WurZyvJwZ3GMt4GQDEp0itpYy5qZ0gBVGxtrc
         Gi5/8lQvuJI7TNGtRB8Eo9iI2Uvv75v4Otyk3MWIbMJl8W9pNRqWLQcnT64e7Rpt7UIE
         xjJg==
X-Gm-Message-State: AOAM530a2RTRu/P2SwSvQoBTJvRXEIgOxCZfDIpK5XgRNVrhE8jll9SB
        xZXQ0RJ/SpTWQCCRh0TZ4+9L3K4ESyheXg==
X-Google-Smtp-Source: ABdhPJylYSZdgMDsvvurxLE4a0bqMMmC1hu3M9p7XG526ya05Soyl1uyOAg6PYfj+UlLG055jfSkAw==
X-Received: by 2002:a62:1c96:0:b029:142:4bf7:15f3 with SMTP id c144-20020a621c960000b02901424bf715f3mr3437724pfc.75.1601830197615;
        Sun, 04 Oct 2020 09:49:57 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j19sm9380237pfi.51.2020.10.04.09.49.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2020 09:49:56 -0700 (PDT)
Message-ID: <5f79fd34.1c69fb81.56294.2569@mx.google.com>
Date:   Sun, 04 Oct 2020 09:49:56 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v4.19.149-12-g096379914f27
X-Kernelci-Branch: queue/4.19
X-Kernelci-Tree: stable-rc
Subject: stable-rc/queue/4.19 baseline: 90 runs,
 1 regressions (v4.19.149-12-g096379914f27)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/4.19 baseline: 90 runs, 1 regressions (v4.19.149-12-g096379=
914f27)

Regressions Summary
-------------------

platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F4.19/ker=
nel/v4.19.149-12-g096379914f27/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/4.19
  Describe: v4.19.149-12-g096379914f27
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      096379914f2766777b12c53e49461c6e6b3df41e =



Test Regressions
---------------- =



platform | arch | lab           | compiler | defconfig           | results
---------+------+---------------+----------+---------------------+--------
panda    | arm  | lab-collabora | gcc-8    | omap2plus_defconfig | 4/5    =


  Details:     https://kernelci.org/test/plan/id/5f79c3d8312003bdf54ff400

  Results:     4 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-12-g096379914f27/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-4.19/v4.19.149=
-12-g096379914f27/arm/omap2plus_defconfig/gcc-8/lab-collabora/baseline-pand=
a.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-3-g27eeeac7da2d/armel/baseline/rootfs.cpio.gz =


  * baseline.dmesg.emerg: https://kernelci.org/test/case/id/5f79c3d8312003b=
df54ff407
      failing since 0 day (last pass: v4.19.149-4-g55b73b3448d7, first fail=
: v4.19.149-5-gc7c6637a3e67)
      2 lines  =20
