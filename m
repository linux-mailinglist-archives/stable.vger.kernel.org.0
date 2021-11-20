Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 037D1457A14
	for <lists+stable@lfdr.de>; Sat, 20 Nov 2021 01:17:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236447AbhKTAUC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Nov 2021 19:20:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236546AbhKTAT7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Nov 2021 19:19:59 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 512F8C061574
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 16:16:57 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id fv9-20020a17090b0e8900b001a6a5ab1392so10115641pjb.1
        for <stable@vger.kernel.org>; Fri, 19 Nov 2021 16:16:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=85acWeLztwyLlVUHpOtd8GkvtlBc8fq0Y7B2IoiTGCc=;
        b=55LVy/QjrD2QcKOiOMJWYLs4Px09ivlyzs8tjN9fezStT4LqaFlJk4aWKuBuO5s9ys
         N03EGvLh935MYxT7deyuJBYhAiOJtqgsKv/7bhdWCTw57hoUjXza0On54lSTCq4xWy1E
         3h4D3da3WNannhkCkOe/EKz757vZT1XOBYoLLkQCu70nrijQM9poRiggDSJPpZsWHtwN
         Ie5zdaO/nXYEsTqPOOuvhRwLDyY+ny3KnIsN27DT8NlSGHQj8P5JpYQw9JcK7dPZ50gj
         /klCCcGbGtmimD0bN0ik/VZPDuWacXblfdv3o5WWCikCWM2Gg9V5WAI4fWtB4NZ7Qe00
         AC1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=85acWeLztwyLlVUHpOtd8GkvtlBc8fq0Y7B2IoiTGCc=;
        b=xjC9FYRXew2PEWzbX14abZ01P/ojTtOdDjAHm4zJB166ceuHsrgytACpBwMyfS0QJk
         GlBCxw1BoxyG0IZ+sBNoQM2L4H8+6K0I4e4cOpLf7V8xMZcuejpTIKiz827KFl2Zd7zV
         uWun4I45thStnzI+3g9c3gEdB7FRmXVqYArHPfcDcLDjIv/R4jisV7FqiiTCacmXQeVP
         tHsQpVOU6XlgVde7Bc+OErDkdL7JwQ0voI1bRy3E1EDOQB3zlBhVzyUEpm06uLdTA8bj
         mfSsIG3qFN/DbiJkNQTMr+sCjy534yAaASsKXnItggzX99Hcuj8uRtKTZYqvpmk2dsBu
         kmdg==
X-Gm-Message-State: AOAM533y590AnP45kVZcAI1rSdHu7iRRmYRMxD7vXvt7d2sowihUESeP
        F+Fri8+GRKxp42zjxHS6BTasRj32URKFV/5c
X-Google-Smtp-Source: ABdhPJz2KdLQYvczbyiY346XbtssMxtkcAM/JXINPCcW28gb/Ai0zwKoKug6WNA2Mn55fbpM1cqsqA==
X-Received: by 2002:a17:902:8e87:b0:143:759c:6a2d with SMTP id bg7-20020a1709028e8700b00143759c6a2dmr80630453plb.59.1637367416739;
        Fri, 19 Nov 2021 16:16:56 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id b9sm754576pfm.127.2021.11.19.16.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Nov 2021 16:16:56 -0800 (PST)
Message-ID: <61983e78.1c69fb81.95f4e.3644@mx.google.com>
Date:   Fri, 19 Nov 2021 16:16:56 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.14.20-15-g69d5eb2b3977d
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: queue/5.14
Subject: stable-rc/queue/5.14 baseline: 136 runs,
 2 regressions (v5.14.20-15-g69d5eb2b3977d)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.14 baseline: 136 runs, 2 regressions (v5.14.20-15-g69d5eb=
2b3977d)

Regressions Summary
-------------------

platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig | 1          =

mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
           | 1          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.14/ker=
nel/v5.14.20-15-g69d5eb2b3977d/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.14
  Describe: v5.14.20-15-g69d5eb2b3977d
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      69d5eb2b3977d7c03c9ac0dc7c1038fb02878f75 =



Test Regressions
---------------- =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
beagle-xm                    | arm   | lab-baylibre  | gcc-10   | omap2plus=
_defconfig | 1          =


  Details:     https://kernelci.org/test/plan/id/6198070b731b5ef1ffe551d1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: omap2plus_defconfig
  Compiler:    gcc-10 (arm-linux-gnueabihf-gcc (Debian 10.2.1-6) 10.2.1 202=
10110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g69d5eb2b3977d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g69d5eb2b3977d/arm/omap2plus_defconfig/gcc-10/lab-baylibre/baseline-beag=
le-xm.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/6198070b731b5ef1ffe55=
1d2
        failing since 26 days (last pass: v5.14.14-64-gb66eb77f69e4, first =
fail: v5.14.14-124-g710e5bbf51e3) =

 =



platform                     | arch  | lab           | compiler | defconfig=
           | regressions
-----------------------------+-------+---------------+----------+----------=
-----------+------------
mt8183-kukui-...uniper-sku16 | arm64 | lab-collabora | gcc-10   | defconfig=
           | 1          =


  Details:     https://kernelci.org/test/plan/id/619803f4ecd1d8ba7ee551d2

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: defconfig
  Compiler:    gcc-10 (aarch64-linux-gnu-gcc (Debian 10.2.1-6) 10.2.1 20210=
110)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g69d5eb2b3977d/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kuku=
i-jacuzzi-juniper-sku16.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.14/v5.14.20-=
15-g69d5eb2b3977d/arm64/defconfig/gcc-10/lab-collabora/baseline-mt8183-kuku=
i-jacuzzi-juniper-sku16.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/arm64/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/619803f4ecd1d8ba7ee55=
1d3
        new failure (last pass: v5.14.19-3-geb15f5bfec790) =

 =20
