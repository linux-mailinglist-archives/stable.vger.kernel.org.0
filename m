Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C872444CA96
	for <lists+stable@lfdr.de>; Wed, 10 Nov 2021 21:26:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233009AbhKJU2s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Nov 2021 15:28:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbhKJU2p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Nov 2021 15:28:45 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 003A1C0613F5
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:25:57 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id y1so3934464plk.10
        for <stable@vger.kernel.org>; Wed, 10 Nov 2021 12:25:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=pcUn7tOgf1kOEymjfdWo1FhU3Ita1t1kQ0DxnOPo45k=;
        b=l2NJTFeCQhi6q38OA3l0aHHtYcbn8zqK1uwWQqH3XSOF531ufx3OaNx5iYXCdWlwhR
         IyKp6zxetcSqLRvKMkZiQcUzCZDFfZEvX/iYAqnWIZb+fjswNq5ijnY9XKj6tnbM7G1V
         sZzb9QJnUZNEraItxtVi+1aLB1DMn6RXg7s19pyXstdL3ZfGx6x5vqbdfOjZTRsv6N8R
         a7+0PxvGeRFqA7aF9yfUa0PWCN2+LqZDHgWicnG2uy+YPDFQa1ys7dBcfVpgVtA2CILC
         vNZ4YqBzOskCc8F7JvZEonOXMqc3JteLrpaRTcknsjcJm90QX2YJT+QIMnE5ww7+6QF4
         u3LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=pcUn7tOgf1kOEymjfdWo1FhU3Ita1t1kQ0DxnOPo45k=;
        b=62CUocyRz2jSOteW3b9wQNSM0H18r8bgAdE3PpTZ0U4iAGrj9Q8fJUIEB9mwkR/chg
         12EOC2C86xBmGJlFiEdoUo8jUDwv3DsBYBNZIcoM4UqXZmYtUJHNQtt3BoR4Ia9dyThr
         +azyD7PRNxIF4+a2Az3dDXGuESuzWc54CR3Tf7EygrFwfeZerrg6lEvJSGdxNeEVyM5x
         8CkEEF5e156JrTrwF+2BxVyBFbe+wPIruXeX5pkA3+oBLPrADLja1ahvgTD5WIiapTrK
         P0gYqyStzPh/haQtbNPlvNsyTTh3K497Z4ykouSMnILF1/ieYJy6HJHvuY2sW5VrQSLq
         XPRg==
X-Gm-Message-State: AOAM530lQYsunaq4KFC4fhXSYFr0342BQZiumBAEiSMVL0TjrZZmNun3
        wtQjFSdvE8kjAMNlDbZwisxuWbzqirvEBDMFBUU=
X-Google-Smtp-Source: ABdhPJxpjLYETxTyI/ZA6mIzWSfwdJwspsMyTtoOm/mwvPoz9ibMga4CZiq5h3YjipOH/Eu0lVv+hw==
X-Received: by 2002:a17:903:1207:b0:13d:b9b1:ead7 with SMTP id l7-20020a170903120700b0013db9b1ead7mr2000605plh.63.1636575956877;
        Wed, 10 Nov 2021 12:25:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id e2sm345142pgm.48.2021.11.10.12.25.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 12:25:56 -0800 (PST)
Message-ID: <618c2ad4.1c69fb81.96f6d.1637@mx.google.com>
Date:   Wed, 10 Nov 2021 12:25:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Branch: queue/5.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Kernel: v5.14.17-13-gb040e99ae09f
X-Kernelci-Report-Type: test
Subject: stable-rc/queue/5.14 baseline: 195 runs,
 1 regressions (v5.14.17-13-gb040e99ae09f)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 195 runs, 1 regressions (v5.14.17-13-gb040e9=
9ae09f)

Regressions Summary
-------------------

platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.17-13-gb040e99ae09f/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.17-13-gb040e99ae09f
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      b040e99ae09f1595b02917e0a6ddc5ad2f8c1e14 =



Test Regressions
---------------- =



platform  | arch | lab          | compiler | defconfig           | regressi=
ons
----------+------+--------------+----------+---------------------+---------=
---
beagle-xm | arm  | lab-baylibre | gcc-10   | omap2plus_defconfig | 1       =
   =


  Details:     https://kernelci.org/test/plan/id/618bf113115a8054af3358ec

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-gb040e99ae09f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.17-=
13-gb040e99ae09f/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beagl=
e-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/618bf113115a8054af335=
8ed
        failing since 17 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =20
