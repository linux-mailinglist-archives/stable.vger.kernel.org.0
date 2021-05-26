Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 092DA391A59
	for <lists+stable@lfdr.de>; Wed, 26 May 2021 16:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbhEZOgd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 May 2021 10:36:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234776AbhEZOgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 May 2021 10:36:32 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCB13C061574
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:35:00 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gb21-20020a17090b0615b029015d1a863a91so440384pjb.2
        for <stable@vger.kernel.org>; Wed, 26 May 2021 07:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=SQVMK6CHbehHP/YjQXcns5Ue52vpxAv6HrzRMkT4Fak=;
        b=gzRso+Yj3ECSM0Y25PKPscKx+BzbUQMKEKN3dIFr8+KqHX+tE9kGElVwc1S4HS7PFq
         uIqSD13ZcFEK/+QfHnfwDuhW/8CjrIagfxRWyXDHFfgI6c7hHKUX0IDm9c/CouYydl39
         ke8jHQb7xQsa8P5ilkAzYEgCLFeDVD1vXyEK3O9ihuiz+sBWRn4/3bJwQoqc2fhTcma+
         VkMPaFLUPTObq6YKbZSC3hKAImJVhpBCNy0gMmywejWJDM9bN7RRj/ZdAoPq06cFAZME
         UEqE+4+B7PYsjyLTngKXF00KtTkCXdIzjnwikiTtGCXSRyrLtrGKhhjDnCTmNMPp7ym2
         7wZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=SQVMK6CHbehHP/YjQXcns5Ue52vpxAv6HrzRMkT4Fak=;
        b=tRgxghvfK5rA6ShxHrhReo9lsoMOsQ9URBToarGa9jKh5/s6R38A/D07mpKa822MFd
         eUYI8JJ0Y67V5oOUzelOrzYOLQZPL9sHIZKXOdt3mlJrOhiYc/NycIyOQGfbX4krmsNH
         pIVMVss6hwWiEWB0X/SHn6+tRa6geEeAgp/60r6+cUBB6oxMfBKJFgh51vktyyzUUEoH
         eTsV566hDMXAu8kT01ZmGaS+tOVoGkRueWZ0y6Pxnz9DNN3Pofmr8q44bxBPInOK3SzQ
         1Mcy868J89fzORQcGOaNeHpUcet1ke4GqJ16WBtH/cg1nui+G3d1h5w7seRpFbqxOkdO
         WoSQ==
X-Gm-Message-State: AOAM532aiuNgkmUYsLviYbwqxiRdGtcJ7rrcImIAqKOzc9h8QleyFR1+
        uQlKKZRqTjj/UCJpFfPx4pxIOzfGsJn6nWqJ
X-Google-Smtp-Source: ABdhPJxWgWl8Y5IiYNmD5y4dQ1Xg7COr59hshhkFfPlox0WklrxqmMswqcv2TWwfbVazDA3QUL7IRQ==
X-Received: by 2002:a17:902:ce87:b029:ef:aff8:5d6 with SMTP id f7-20020a170902ce87b02900efaff805d6mr36191410plg.34.1622039699672;
        Wed, 26 May 2021 07:34:59 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id u4sm17192277pgl.43.2021.05.26.07.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 May 2021 07:34:59 -0700 (PDT)
Message-ID: <60ae5c93.1c69fb81.ed7d0.7f57@mx.google.com>
Date:   Wed, 26 May 2021 07:34:59 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.6-127-g3e985cc005fd
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 117 runs,
 1 regressions (v5.12.6-127-g3e985cc005fd)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 117 runs, 1 regressions (v5.12.6-127-g3e985c=
c005fd)

Regressions Summary
-------------------

platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.6-127-g3e985cc005fd/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.6-127-g3e985cc005fd
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3e985cc005fd7ca11be67a8d26591600c38431a1 =



Test Regressions
---------------- =



platform   | arch  | lab     | compiler | defconfig | regressions
-----------+-------+---------+----------+-----------+------------
imx8mp-evk | arm64 | lab-nxp | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60ae2a88cf023fbdacb3b014

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
27-g3e985cc005fd/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.6-1=
27-g3e985cc005fd/arm64/defconfig/gcc-8/lab-nxp/baseline-imx8mp-evk.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60ae2a88cf023fbdacb3b=
015
        new failure (last pass: v5.12.6-124-ga642885de2c1) =

 =20
