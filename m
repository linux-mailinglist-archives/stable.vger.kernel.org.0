Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E16F1454EB6
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:46:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbhKQUtA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:49:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhKQUs7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:48:59 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 462EAC061570
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:46:00 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id nh10-20020a17090b364a00b001a69adad5ebso3632594pjb.2
        for <stable@vger.kernel.org>; Wed, 17 Nov 2021 12:46:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=KARJdGfLdEZ2B2P7EgP29qKf9ysskx63uMX3GoxFPjE=;
        b=Ev5OiKpa+IDEH2FjBVxaqAzDRi91PLmg8ZduhDySe3usSsiQQ7CPpcSAmFE2tbmcGg
         fyFtN8Ar1TjgpPniq4lthlb7JwoX3YtOcKe5AIMEnFDPGYPsofHnTQWn5gcKhN3V1CDF
         Kby0QqGVpUjGc6Q7HDd+OtSTOxGapATjtlzdBnOyvBlpkIlR5rqUbClUJzh4eMufPw06
         QNCzBLV9nJLOsbnYgftjZ3ZYaIiZxpxsnUiaWseucqBcZi8xxfKau/V/wBPheS3gs1HS
         z5c8z/6ysan56M012PDc3ZFt9HUXb5sWKsldfE/nKQ/KtXXUFwzT1iddYXfzU6ogbBkq
         b81g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=KARJdGfLdEZ2B2P7EgP29qKf9ysskx63uMX3GoxFPjE=;
        b=0hrqz6nc3NkpwqvZU/hVaUWb7AlhxPZbu8UFDcjZ7xP4o8k277B+xc1/3xaHZoqGPY
         IwTHGy0c1uX7R2KDVU0ErAL6wjXuYgcyMLLDpAritp8Qni4RJbVsSqLAh2aevgrJCATJ
         nwsRIf/QRcaVJXwDxYnaPY5qRdoN6eyBHYbFLXrT+ToD3MkWTFPdZa0oU+owj9FW/Am1
         3PGuuMQsmvNgouGdu7x/ztrInHLaY9yckvHdLQ9r2Iv/zRVrQzri4CVH1ESBEcE9sgZD
         suNiqHC19XLzx6HKFQgXSHAPO35cVVmwu1WVI+ymiGEDOPs3KipGO05FeWTZ+Cu8blRZ
         RukQ==
X-Gm-Message-State: AOAM5334QFaG2GwjPECDuYc2EIzX/3kG+sa0c7fjJcYg02iURKipEQqD
        2sGchy+VKh4i0M9WxMHEAGJ10/k1qeZtM3e5
X-Google-Smtp-Source: ABdhPJx8xyU1NaXoMx88819I9g8amB9Tid7SpnVM0eQ2ZB1USBd5If9GV12JORwfaIpCFTRFufMnbA==
X-Received: by 2002:a17:902:748c:b0:142:5f2f:1828 with SMTP id h12-20020a170902748c00b001425f2f1828mr59279101pll.4.1637181959431;
        Wed, 17 Nov 2021 12:45:59 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id j15sm512461pfh.35.2021.11.17.12.45.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 12:45:59 -0800 (PST)
Message-ID: <61956a07.1c69fb81.22a6.2962@mx.google.com>
Date:   Wed, 17 Nov 2021 12:45:59 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.18-857-g3166c34d4645
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 102 runs,
 1 regressions (v5.14.18-857-g3166c34d4645)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 102 runs, 1 regressions (v5.14.18-857-g3166c=
34d4645)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.18-857-g3166c34d4645/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.18-857-g3166c34d4645
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      3166c34d4645bcbddbf650f84da7014e09cb515e =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/619532bab5b286d44733590e

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
857-g3166c34d4645/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.18-=
857-g3166c34d4645/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619532bab5b286d447335=
90f
        failing since 24 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
