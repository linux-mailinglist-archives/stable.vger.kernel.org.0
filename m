Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E6B33B8A41
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 23:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232630AbhF3V5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 17:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232042AbhF3V5t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 17:57:49 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E460AC061756
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 14:55:18 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id j199so3394162pfd.7
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 14:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=LPh6o6VxnscBX/ZkeMEavYp/WXswq/C53sEq5ImWEtY=;
        b=vzLazBonIu6yBP9aVwTLHdVipN/4gFkePRrgBhXn9jSJXeOFpPg1wPrYfWhEr7SjJN
         hZgaBKczs4T3xIvuZgD1WHmqeXSCbPzynzWy7E/MR/ZkW8aG0Mx8CQZ9naDXYqM2TuQW
         cczp8WuEZCURz3/2z6NfYjD6RDEUgE8tVbbr8Bq1MBOtS4LckwJCHmUSGjf6RVNVC4l5
         aLscsczeI+NZQnQo5i2Dl3Ft8xs0Lq4/XKlS+q2cItTKwD9kKra1I1ojky4Rufc8x3Td
         sgBYKXkpx9r1KVGf71JHOXIGPJ15VCosZOOPTdIeteTgfXbHqMStswSj6HTP0euFYAF2
         Y+uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=LPh6o6VxnscBX/ZkeMEavYp/WXswq/C53sEq5ImWEtY=;
        b=ewEpdhxaPo6cCwJA+bPbhVaffH3OslJDBidfUqy28dNksS35lKJ3AJw7x/bWyvKPjF
         n3llYKhB5RRymS8Qjxn1UnymvPxqiUikkFw4qFdtPQkE4mE1XuXiNiqqVZCqtjt8wQOO
         8eSsvawRivfKluZ6PlO2gR+fdpGJty+pR+m0AEAbt6VSK6cJGZ/IdolprNuDJ7VbiHGy
         v9Hye9NjQKbnUOhQKWrK+qq+fbI4MLJYLbvG2c69X2QacmLWtsUSyXF9J2iS97Xa/kDn
         UQ7BYJL0SUkcHYLG/Ci75IIibZ98W8SOosuO9MN1qtyp8MW8Eu/4eeGQpYGaJkDxzJHC
         hegg==
X-Gm-Message-State: AOAM532dwAJGvdi+mIpEPvtcrX9wEHQ+UDj+AJ2JQh5Tu5cMz9GctPxZ
        KdNHDlfxuv5Fkx1As+UEMEZBSKToU9rUjYBg
X-Google-Smtp-Source: ABdhPJxlIRlPOoEkoKRn2QxzuO5tPmlWYXDmDfJsjBY80AWkmZ4xIk9ZgU6TyU8+SB4jo6vltkAdag==
X-Received: by 2002:a63:5652:: with SMTP id g18mr954392pgm.178.1625090118307;
        Wed, 30 Jun 2021 14:55:18 -0700 (PDT)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id 206sm22947163pfv.108.2021.06.30.14.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 14:55:18 -0700 (PDT)
Message-ID: <60dce846.1c69fb81.8dade.40a6@mx.google.com>
Date:   Wed, 30 Jun 2021 14:55:18 -0700 (PDT)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Report-Type: test
X-Kernelci-Kernel: v5.12.14
X-Kernelci-Tree: stable-rc
X-Kernelci-Branch: linux-5.12.y
Subject: stable-rc/linux-5.12.y baseline: 152 runs, 1 regressions (v5.12.14)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/linux-5.12.y baseline: 152 runs, 1 regressions (v5.12.14)

Regressions Summary
-------------------

platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:  https://kernelci.org/test/job/stable-rc/branch/linux-5.12.y/ker=
nel/v5.12.14/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   linux-5.12.y
  Describe: v5.12.14
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      afe5d2361cfac43e2eb53d547e78386bd9fb9483 =



Test Regressions
---------------- =



platform           | arch | lab          | compiler | defconfig         | r=
egressions
-------------------+------+--------------+----------+-------------------+--=
----------
bcm2837-rpi-3-b-32 | arm  | lab-baylibre | gcc-8    | bcm2835_defconfig | 1=
          =


  Details:     https://kernelci.org/test/plan/id/60dcb09e24fa3b82b623bcb1

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: bcm2835_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.txt
  HTML log:    https://storage.kernelci.org//stable-rc/linux-5.12.y/v5.12.1=
4/arm/bcm2835_defconfig/gcc-8/lab-baylibre/baseline-bcm2837-rpi-3-b-32.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-6-g8983f3b738df/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/60dcb09e24fa3b82b623b=
cb2
        new failure (last pass: v5.12.13-11-g6645d6f022e7) =

 =20
