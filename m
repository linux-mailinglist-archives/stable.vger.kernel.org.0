Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F07413887C2
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 08:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232519AbhESGpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 02:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232439AbhESGpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 May 2021 02:45:50 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A89CEC06175F
        for <stable@vger.kernel.org>; Tue, 18 May 2021 23:44:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id k5so6834317pjj.1
        for <stable@vger.kernel.org>; Tue, 18 May 2021 23:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=PBkJ8xEe0V5XJGdcayuuTyIOxDg1623Z9YdjIystf6E=;
        b=MIBH9CMHRnqVT46CGi8cFI3G2aOY/WOc4J7sw2LS0TSfxmt+BSVmDzWRbTZGscnCD6
         M1Kt2nLS6rUFTblEcIuhxIgNoOSHdEMORNZEs6tObjeX+mnbT8W/vkZYWrOeI5I2E/ZO
         vd02N82b246ueL2RonZ8XctIxMWwYzlg7Kh9nTVNB2BYOEU7AK4OQVricz26NvOSkVcY
         OvHfZ2sPu+HHMsiqUTNLetc7WhqJmuNVAyhiDEq1NYl3YP14wdJrfZ/1rKxwYYiVwcRU
         RbMhwLDpyQd/M9+0fav1+j9tinH5XpL+fqX7KzI7d+jK1qxIJaQbvMOcLBjzNhGLqlJQ
         Rl8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=PBkJ8xEe0V5XJGdcayuuTyIOxDg1623Z9YdjIystf6E=;
        b=BDeWfV5JF/YwN9LVjS7Yw9g57HEPfNn2mSH+zUIjOn4GgDudGKeVo427KOk1zxgclw
         nHn150CbacqFUPZulRt9pTXm5Cr4ikJfUj07YSeai6U2j9LYSpYehm+fmOAE7p3eWcgB
         TKaPBjXMY/N8NZqpTEK8iB1v7PBWhmcJ8kmg0Ev48TczwQN0S3nFzi+UJNIF/QGuCzD2
         ynGLGp5P9YLrnFtO9m91bmQhVp0X74BVrHk+8WAb0M+Jm2X2JWl1Q+63mor6xwoQnVBX
         9jPmSW2AcKN7Z5T0vidPaVAlXckbOCdRnMDmJokAh837Id4t0cfWgKY65KrKoZmAIEGm
         CtYA==
X-Gm-Message-State: AOAM5301rI4iq+Ss151pEgx8OJaVoTEwnFrhQ+VZ3bdHS9ilV5ptK3lK
        8MKia6GRsOrXPoh0hujOqeUKV4eaTK/yc1on
X-Google-Smtp-Source: ABdhPJzkq2sM8kXuJWcCCecLUUtRzCtncslYIjXsJDiy7aQK6kXjuxrXL7Ibn0noQllB65TcMhf68A==
X-Received: by 2002:a17:90a:8911:: with SMTP id u17mr9933959pjn.165.1621406670063;
        Tue, 18 May 2021 23:44:30 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id f21sm9516768pjt.11.2021.05.18.23.44.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 23:44:29 -0700 (PDT)
Message-ID: <60a4b3cd.1c69fb81.445d8.1078@mx.google.com>
Date:   Tue, 18 May 2021 23:44:29 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.12.4-363-g2fd5d85fdab9
X-Kernelci-Branch: queue/5.12
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.12 baseline: 164 runs,
 1 regressions (v5.12.4-363-g2fd5d85fdab9)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.12 baseline: 164 runs, 1 regressions (v5.12.4-363-g2fd5d8=
5fdab9)

Regressions Summary
-------------------

platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.12/ker=
nel/v5.12.4-363-g2fd5d85fdab9/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.12
  Describe: v5.12.4-363-g2fd5d85fdab9
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      2fd5d85fdab929230d046c639c6dd768bf78992d =



Test Regressions
---------------- =



platform      | arch  | lab          | compiler | defconfig | regressions
--------------+-------+--------------+----------+-----------+------------
r8a77960-ulcb | arm64 | lab-baylibre | gcc-8    | defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/60a480562cb03812e2b3afa7

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-8 (aarch64-linux-gnu-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g2fd5d85fdab9/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.=
txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.12/v5.12.4-3=
63-g2fd5d85fdab9/arm64/defconfig/gcc-8/lab-baylibre/baseline-r8a77960-ulcb.=
html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-5-g2f114cc7102b/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60a480562cb03812e2b3a=
fa8
        new failure (last pass: v5.12.4-362-g6cee647af019) =

 =20
