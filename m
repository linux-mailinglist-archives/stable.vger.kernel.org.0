Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0172A6661
	for <lists+stable@lfdr.de>; Wed,  4 Nov 2020 15:30:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgKDOar (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Nov 2020 09:30:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726729AbgKDOar (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Nov 2020 09:30:47 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91AF7C0613D3
        for <stable@vger.kernel.org>; Wed,  4 Nov 2020 06:30:47 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id x13so17406182pfa.9
        for <stable@vger.kernel.org>; Wed, 04 Nov 2020 06:30:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernelci-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:date:mime-version:content-transfer-encoding:subject:to
         :from;
        bh=U4MpteavQvuDJe1f2YplTJ4/FEtkFb5B4GahR7mckPg=;
        b=N9cNJM8ql6k8LsM9oZU2ELEUCNqrJFNFdtKEhzxBIyj8MmF3c4okmWRT6dts9BBzwM
         d6g5kqHffrDSWlH50RwRehu3Hw255o834u5lIKIAKhI7So+kOTSefGT0dxwIWwEVEzPs
         c1IQ9j9xBXyrAAho20YbomqJI+rEpZAzOWCLEBWgLVNPL+RtxEjz8cN4OX+ntuuRCYrM
         KfX2swJGFBX231S2oF8aGQBcS8bjjlP9pz5/aigc5I/G+yfgrorMcFFj95JTFNfd5A6w
         LfsHfSF4qbtAiDmxGzrJOlRDdoG8YC0TOPayObQlX9/wIYop55fSeFhDvfzRu/+on6/a
         pkDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:date:mime-version
         :content-transfer-encoding:subject:to:from;
        bh=U4MpteavQvuDJe1f2YplTJ4/FEtkFb5B4GahR7mckPg=;
        b=Ql6+QGUjfD9Pct198Lh91+WJIyS1K9IE55Jv0/VLajruqSzhJ8OpMsEK4VSa87gHZ6
         QMEdlvNzqw02Ei7hIM29AX2rjBoV4Iwf0CKTjXMc2/bDGukS3e4/1zAS7t0tZr5E+zjU
         6ihpoM5o4TOy0M3v3OrXWASXk1tN7vegcg5aC1+tC+lznncMi9MyMsmyCXgjPGgqyxvW
         vnNNnp4bLFrOvb0DOQNOu3uU02M1PhcT1MwmpMbFHRkNfABRJbCrH6YtugJD+cxEiLye
         JkHmMu7fPWYf34FCx5YwuKcb5QRhKCCx2hvC0qJPnYU/dbjtZ9fkJsKsJ+YYPpVU3keE
         ACzQ==
X-Gm-Message-State: AOAM533eVccg4TbdbskChCAfiz6LOmpHhWbhdqgU7QbYrkq7n0o9k0fR
        BvuJPqK+YqAhN41+uSdf05rFH5CKhQ0Eew==
X-Google-Smtp-Source: ABdhPJxG0ZUyKUn/VD9QW4RNZgVZQGuZMJrD6MgYQAx3zE657eS8PbBE8exaXcezudnPgQkHe3o2HQ==
X-Received: by 2002:a17:90a:8802:: with SMTP id s2mr4369974pjn.149.1604500246666;
        Wed, 04 Nov 2020 06:30:46 -0800 (PST)
Received: from kernelci-production.internal.cloudapp.net ([52.250.1.28])
        by smtp.gmail.com with ESMTPSA id s22sm2510756pfu.119.2020.11.04.06.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2020 06:30:45 -0800 (PST)
Message-ID: <5fa2bb15.1c69fb81.3ccd5.5c7e@mx.google.com>
Date:   Wed, 04 Nov 2020 06:30:45 -0800 (PST)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Kernelci-Kernel: v5.8.18-149-gcf1626b0f42c
X-Kernelci-Tree: stable-rc
X-Kernelci-Report-Type: test
X-Kernelci-Branch: queue/5.8
Subject: stable-rc/queue/5.8 baseline: 214 runs,
 1 regressions (v5.8.18-149-gcf1626b0f42c)
To:     stable@vger.kernel.org, kernel-build-reports@lists.linaro.org,
        kernelci-results@groups.io
From:   "kernelci.org bot" <bot@kernelci.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

stable-rc/queue/5.8 baseline: 214 runs, 1 regressions (v5.8.18-149-gcf1626b=
0f42c)

Regressions Summary
-------------------

platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:  https://kernelci.org/test/job/stable-rc/branch/queue%2F5.8/kern=
el/v5.8.18-149-gcf1626b0f42c/plan/baseline/

  Test:     baseline
  Tree:     stable-rc
  Branch:   queue/5.8
  Describe: v5.8.18-149-gcf1626b0f42c
  URL:      https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
  SHA:      cf1626b0f42c7912da1fb20ae30d763ea1cd5a9a =



Test Regressions
---------------- =



platform        | arch | lab          | compiler | defconfig          | reg=
ressions
----------------+------+--------------+----------+--------------------+----=
--------
stm32mp157c-dk2 | arm  | lab-baylibre | gcc-8    | multi_v7_defconfig | 1  =
        =


  Details:     https://kernelci.org/test/plan/id/5fa288891b3c46e52dfb532f

  Results:     0 PASS, 1 FAIL, 0 SKIP
  Full config: multi_v7_defconfig
  Compiler:    gcc-8 (arm-linux-gnueabihf-gcc (Debian 8.3.0-2) 8.3.0)
  Plain log:   https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-gcf1626b0f42c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.txt
  HTML log:    https://storage.kernelci.org//stable-rc/queue-5.8/v5.8.18-14=
9-gcf1626b0f42c/arm/multi_v7_defconfig/gcc-8/lab-baylibre/baseline-stm32mp1=
57c-dk2.html
  Rootfs:      http://storage.kernelci.org/images/rootfs/buildroot/kci-2020=
.05-4-g97706c5d9567/armel/baseline/rootfs.cpio.gz =



  * baseline.login: https://kernelci.org/test/case/id/5fa288891b3c46e52dfb5=
330
        failing since 9 days (last pass: v5.8.16-78-g480e444094c4, first fa=
il: v5.8.16-626-g41d0d5713799) =

 =20
